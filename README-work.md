# MermaidJS::Grammar

Raku package with a grammar for Mermaid-JS diagram specs.

Languages and formats [Mermaid-JS](https://mermaid.js.org) is translated to:

- [X] DONE Raku
  - Translation to Raku hashmap structure with keys "nodes", "edges", and "styles".
- [X] DONE JSON
  - Simple JSON serialization from Raku-actions results.
- [X] DONE [Graphviz DOT](https://graphviz.org/doc/info/lang.html)
- [ ] TODO [PlantUML](https://plantuml.com)
  - PlantUML uses DOT language, so, for flowcharts this _should be_ a very short and easy format implementation based on DOT actions.
  - The current unfinished implementation tries to reuse the Raku actions. (Without good results.)
- [ ] TODO Mathematica
  - [ ] DONE Basic vertexes and edges
  - [ ] TODO Vertex styles
  - [ ] TODO Edge styles

A very similar Raku package is ["Graphviz::DOT::Grammar"](https://raku.land/zef:antononcube/Graphviz::DOT::Grammar), [AAp1].

------

## Usage examples

Here is a Mermaid-JS spec:

```raku, output.prompt=NONE,  output.language=mermaid
my $spec = q:to/END/;
flowchart TD
  A[Start] --> B{Decide}
  B -->|Yes| C[Do thing]
  B -->|No| D[Stop]
END
```

Translate to Raku:

```raku
use MermaidJS::Grammar;
$spec ==> mermaid-js-interpret
```

Translate to [Graphviz DOT](https://graphviz.org):

```perl6, output.prompt=NONE,  output.language=mathematica
$spec ==> mermaid-js-interpret(a=>'DOT')
```

------

## CLI

The package provides the Command Line Interface (CLI) script `from-mermaid-js`. Here is its usage message:

```shell
from-mermaid-js --help
```

------

## References

[AAp1] Anton Antonov,
[Graphviz::DOT::Grammar. Raku package](https://github.com/antononcube/Raku-Graphviz-DOT-Grammar),
(2024),
[GitHub/antononcube](https://github.com/antononcube).