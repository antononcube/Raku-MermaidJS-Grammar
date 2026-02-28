#!/usr/bin/env raku
use v6.d;

use MermaidJS::Grammar;
use JSON::Fast;

my $flowchart = q:to/EOF/;
flowchart TD
  A[Start] --> B{Decide}
  B -->|Yes| C[Do thing]
  B -->|No| D[Stop]
EOF

# .say for |mermaid-js-interpret($spec, actions => 'Raku'));
# say mermaid-js-interpret($spec, actions => 'PlantUML');
say mermaid-js-interpret($flowchart, actions => 'DOT');
