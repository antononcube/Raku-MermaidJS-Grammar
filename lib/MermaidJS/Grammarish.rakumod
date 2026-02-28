use v6.d;

use MermaidJS::Grammar::Flowchartish;
use MermaidJS::Grammar::MindMappish;

role MermaidJS::Grammarish
        does MermaidJS::Grammar::Flowchartish
        does MermaidJS::Grammar::MindMappish {
    regex TOP {
        \s* <diagram> \s*
    }

    regex diagram {
        [ <init-directive>* %% \n ]? [ <flowchart> | <mindmap> ]
    }
}
