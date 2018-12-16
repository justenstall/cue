// Copyright 2018 The CUE Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Package format implements standard formatting of CUE configurations.
package format // import "cuelang.org/go/cue/format"

import (
	"bytes"
	"fmt"
	"io"
	"strings"
	"text/tabwriter"

	"cuelang.org/go/cue/ast"
	"cuelang.org/go/cue/parser"
	"cuelang.org/go/cue/token"
)

// An Option sets behavior of the formatter.
type Option func(c *config)

// FileSet sets the file set that was used for creating a node. The formatter
// generally formats fine without it.
func FileSet(fset *token.FileSet) Option {
	return func(c *config) { c.fset = fset }
}

// Simplify allows the formatter to simplify output, such as removing
// unnecessary quotes.
func Simplify() Option {
	return func(c *config) { c.simplify = true }
}

// TODO: other options:
//
// const (
// 	RawFormat Mode = 1 << iota // do not use a tabwriter; if set, UseSpaces is ignored
// 	TabIndent                  // use tabs for indentation independent of UseSpaces
// 	UseSpaces                  // use spaces instead of tabs for alignment
// 	SourcePos                  // emit //line comments to preserve original source positions
// )

// Node formats node in canonical cue fmt style and writes the result to dst.
//
// The node type must be *ast.File, []syntax.Decl, syntax.Expr, syntax.Decl, or
// syntax.Spec. Node does not modify node. Imports are not sorted for nodes
// representing partial source files (for instance, if the node is not an
// *ast.File).
//
// The function may return early (before the entire result is written) and
// return a formatting error, for instance due to an incorrect AST.
//
func Node(dst io.Writer, node ast.Node, opt ...Option) error {
	cfg := newConfig(opt)
	return cfg.fprint(dst, node)
}

// Source formats src in canonical cue fmt style and returns the result or an
// (I/O or syntax) error. src is expected to be a syntactically correct CUE
// source file, or a list of CUE declarations or statements.
//
// If src is a partial source file, the leading and trailing space of src is
// applied to the result (such that it has the same leading and trailing space
// as src), and the result is indented by the same amount as the first line of
// src containing code. Imports are not sorted for partial source files.
//
// Caution: Tools relying on consistent formatting based on the installed
// version of cue (for instance, such as for presubmit checks) should execute
// that cue binary instead of calling Source.
//
func Source(b []byte, opt ...Option) ([]byte, error) {
	cfg := newConfig(opt)
	if cfg.fset == nil {
		cfg.fset = token.NewFileSet()
	}

	f, err := parser.ParseFile(cfg.fset, "", b, parser.ParseComments)
	if err != nil {
		return nil, fmt.Errorf("parse: %s", err)
	}

	// print AST
	var buf bytes.Buffer
	if err := cfg.fprint(&buf, f); err != nil {
		return nil, fmt.Errorf("print: %s", err)
	}
	return buf.Bytes(), nil
}

type config struct {
	fset *token.FileSet

	UseSpaces bool
	TabIndent bool
	Tabwidth  int // default: 8
	Indent    int // default: 0 (all code is indented at least by this much)

	simplify bool
}

func newConfig(opt []Option) *config {
	cfg := &config{Tabwidth: 8, TabIndent: true, UseSpaces: true}
	for _, o := range opt {
		o(cfg)
	}
	return cfg
}

// Config defines the output of Fprint.
func (cfg *config) fprint(output io.Writer, node interface{}) (err error) {
	// print node
	var p printer
	p.init(cfg)
	if err = printNode(node, &p); err != nil {
		return err
	}

	minwidth := cfg.Tabwidth

	padchar := byte('\t')
	if cfg.UseSpaces {
		padchar = ' '
	}

	twmode := tabwriter.DiscardEmptyColumns | tabwriter.StripEscape
	if cfg.TabIndent {
		minwidth = 0
		twmode |= tabwriter.TabIndent
	}

	tw := tabwriter.NewWriter(output, minwidth, cfg.Tabwidth, 1, padchar, twmode)

	// write printer result via tabwriter/trimmer to output
	if _, err = tw.Write(p.output); err != nil {
		return
	}

	err = tw.Flush()
	return
}

// A formatter walks a syntax.Node, interspersed with comments and spacing
// directives, in the order that they would occur in printed form.
type formatter struct {
	*printer

	stack    []frame
	current  frame
	nestExpr int

	labelBuf []ast.Label
}

func newFormatter(p *printer) *formatter {
	f := &formatter{
		printer: p,
		current: frame{
			settings: settings{
				nodeSep:   newline,
				parentSep: newline,
			},
		},
	}
	return f
}

type whiteSpace int

const (
	ignore whiteSpace = 0

	// write a space, or disallow it
	blank whiteSpace = 1 << iota
	vtab             // column marker
	noblank

	nooverride

	comma      // print a comma, unless trailcomma overrides it
	trailcomma // print a trailing comma unless closed on same line
	declcomma  // write a comma when not at the end of line

	newline    // write a line in a table
	formfeed   // next line is not part of the table
	newsection // add two newlines

	indent   // request indent an extra level after the next newline
	unindent // unindent a level after the next newline
	indented // element was indented.
)

type frame struct {
	cg  []*ast.CommentGroup
	pos int8

	settings
	commentNewline bool
}

type settings struct {
	// separator is blank if the current node spans a single line and newline
	// otherwise.
	nodeSep   whiteSpace
	parentSep whiteSpace
	override  whiteSpace
}

func (f *formatter) print(a ...interface{}) {
	for _, x := range a {
		f.Print(x)
		switch x.(type) {
		case string, token.Token: // , *syntax.BasicLit, *syntax.Ident:
			f.current.pos++
		}
	}
	f.visitComments(f.current.pos)
}

func (f *formatter) formfeed() whiteSpace {
	if f.current.nodeSep == blank {
		return blank
	}
	return formfeed
}

func (f *formatter) wsOverride(def whiteSpace) whiteSpace {
	if f.current.override == ignore {
		return def
	}
	return f.current.override
}

func (f *formatter) onOneLine(node ast.Node) bool {
	a := node.Pos()
	b := node.End()
	if f.fset != nil && a.IsValid() && b.IsValid() {
		return f.lineFor(a) == f.lineFor(b)
	}
	// TODO: walk and look at relative positions to determine the same?
	return false
}

func (f *formatter) before(node ast.Node) bool {
	f.stack = append(f.stack, f.current)
	f.current = frame{settings: f.current.settings}
	f.current.parentSep = f.current.nodeSep

	if node != nil {
		if f.current.nodeSep != blank && f.onOneLine(node) {
			f.current.nodeSep = blank
		}
		f.current.cg = node.Comments()
		f.visitComments(f.current.pos)
		return true
	}
	return false
}

func (f *formatter) after(node ast.Node) {
	f.visitComments(127)
	p := len(f.stack) - 1
	f.current = f.stack[p]
	f.stack = f.stack[:p]
	f.current.pos++
	f.visitComments(f.current.pos)
}

func (f *formatter) visitComments(until int8) {
	c := &f.current

	for ; len(c.cg) > 0 && c.cg[0].Position <= until; c.cg = c.cg[1:] {
		f.Print(c.cg[0])

		printBlank := false
		if c.cg[0].Doc {
			f.Print(newline)
			printBlank = true
		}
		for _, c := range c.cg[0].List {
			if !printBlank {
				f.Print(vtab)
			}
			f.Print(c.Slash)
			f.Print(c)
			if strings.HasPrefix(c.Text, "//") {
				f.Print(newline)
			}
		}
	}
}
