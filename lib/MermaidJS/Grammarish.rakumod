use v6.d;

use MermaidJS::Grammar::Flowchartish;

role MermaidJS::Grammarish
        does MermaidJS::Grammar::Flowchartish {
    regex TOP {
        \s* <diagram> \s*
    }

    regex diagram {
        [ <init-directive>* %% \n ]? <flowchart>
    }
}
