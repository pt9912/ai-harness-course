// Package main — DocSearch Entry-Point.
// Wiring der Schichten gemäß ADR-0001.
package main

import (
	"flag"
	"fmt"
	"os"

	"github.com/example/docsearch/internal/embedding"
	"github.com/example/docsearch/internal/index"
	"github.com/example/docsearch/internal/service"
)

const version = "0.3.0"

func main() {
	showVersion := flag.Bool("version", false, "Version anzeigen")
	help := flag.Bool("help", false, "Hilfe anzeigen")
	flag.Parse()

	if *help {
		fmt.Fprintf(os.Stderr, "DocSearch %s\n\nNutzung: docsearch [--version]\n", version)
		os.Exit(0)
	}
	if *showVersion {
		fmt.Println(version)
		return
	}

	// Wiring: types ← embedding, index → service → ui (siehe ADR-0001).
	idx := index.New()
	emb := embedding.MockEmbedder{}
	_ = service.NewSearcher(idx, emb)
	// HTTP-Layer-Start wäre hier; im Lab-Skelett zeigen wir nur das Wiring.

	fmt.Println("DocSearch wired. HTTP-Start ist in Welle-4-Slice geplant.")
}
