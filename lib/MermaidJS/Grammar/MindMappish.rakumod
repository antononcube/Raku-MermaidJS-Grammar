use v6.d;

use MermaidJS::Grammar::Flowchartish;

role MermaidJS::Grammar::MindMappish
        does MermaidJS::Grammar::Flowchartish {

    regex mindmap {
        <mindmap-keyword> \h* \n
        <mindmap-line-list>?
    }

    token mindmap-keyword { 'mindmap' }

    regex mindmap-line-list { <mindmap-line>+ %% \n }

    regex mindmap-line {
        \h* [
        <comment>
        || <mindmap-node-line>
        ] \h*
    }

    regex mindmap-node-line {
        <mindmap-node> [ \h+ <mindmap-decoration> ]*
    }

    regex mindmap-node {
        <mindmap-root-node>
        | <node>
        | <mindmap-quoted-node>
        | <mindmap-text-node>
    }

    token mindmap-root-node {
        'root' <node-label>?
    }

    token mindmap-quoted-node {
        <quoted> | <squoted>
    }

    token mindmap-text-node {
        <-[\n]>+? <?before [ \h+ '::' | \h* $ ]>
    }

    token mindmap-decoration {
        ':::' <class-name>
        | '::' <id> [ '(' <-[)\n]>* ')' ]?
    }
}
