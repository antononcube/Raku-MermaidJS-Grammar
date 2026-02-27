#!/usr/bin/env raku
use v6.d;

use MermaidJS::Grammar;
use JSON::Fast;

my $spec = q:to/EOF/;
flowchart TD
  A[Start] --> B{Decide}
  B -->|Yes| C[Do thing]
  B -->|No| D[Stop]
EOF

say to-json(mermaid-js-interpret($spec, actions => 'Raku'));
#say mermaid-js-interpret($spec, actions => 'PlantUML');
