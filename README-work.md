# MermaidJS::Grammar

Raku package with a grammar for Mermaid-JS diagram specs.

Languages and formats [Mermaid-JS](https://mermaid.js.org) is translated to:

- [X] DONE Raku
  - Translation to Raku hashmap structure with keys "nodex", "edges", and "styles".
- [ ] TODO Graphviz DOT
- [ ] TODO PlantUML
    - PlantUML uses DOT language, so it _should be_ a very short and easy format implementation based on DOT actions. 
- [ ] TODO Mathematica
    - [ ] DONE Basic vertexes and edges
    - [ ] TODO Vertex styles
    - [ ] TODO Edge styles

------

## Usage examples

Here is a Mermaid-JS spec:

```raku
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

Translate to Mathematica:

```perl6, output.prompt=NONE,  output.language=mathematica
$spec ==> mermaid-js-interpret(a=>'Mathematica')
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
[Graphviz::DOT::Grammar. Raku package](https://github.com/antononcube/Raku-Graph),
(2024),
[GitHub/antononcube](https://github.com/antononcube).