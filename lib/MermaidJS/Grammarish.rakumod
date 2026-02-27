use v6.d;

role MermaidJS::Grammarish {
    regex TOP {
        \s* <diagram> \s*
    }

    regex diagram {
        [ <init-directive>* %% \n ]? <flowchart>
    }

    regex flowchart {
        <flowchart-keyword> \h+ <direction>? \h* \n
        <statement-list>?
    }

    token flowchart-keyword { 'flowchart' | 'graph' }
    token direction { 'TB' | 'TD' | 'BT' | 'RL' | 'LR' }

    #\s* <statement> [ \n+ <statement> ]* \s*
    #<[\h \w \- = > { } ]>+ %% \n
    regex statement-list { <statement>+ % \n }

    regex statement {
        \h* [
        <subgraph>
        | <edge>
        | <node-def>
        | <class-def>
        | <class-assign>
        | <style>
        | <link-style>
        | <click>
        | <comment>
        #| <any-line>
        ] \h*
    }

    token any-line { <-[\n]>+ }
    token comment { '%%' <-[\n]>* }

    regex subgraph {
        <subgraph-start> <nl> <statement-list>? <subgraph-end>
    }
    token subgraph-start { 'subgraph' <ws> <subgraph-title>? }
    token subgraph-title { <quoted> | <label-text> }
    token subgraph-end { 'end' }

    regex edge {
        <node> \h* [<linked-node>+ % \h*]?
    }

    regex linked-node {
        <link> \h* <node>
    }

    regex link {
        <link-op> \s* [ <edge-label> \s* <link-op>? ]?
    }

    token link-op {
        '---'
        | '-->'
        | '--'
        | '-.->'
        | '-.-'
        | '==>'
        | '===' 
        | '==o'
        | '==x'
        | '--o'
        | '--x'
    }

    token edge-label { '|' <label-text> '|' | <edge-text> }
    token edge-text { <-[\n\-]>+ }

    regex node-def { <node> }

    regex node { <node-id> <node-label>? <class-annotation>? }

    token node-id { <id> }
    token class-annotation { ':::' <class-name> }

    token node-label {
        '[[' <label-text> ']]'
        | '[' <label-text> ']'
        | '(((' <label-text> ')))'
        | '((' <label-text> '))'
        | '(' <label-text> ')'
        | '{{' <label-text> '}}'
        | '{' <label-text> '}'
        | '<' <label-text> '>'
        | '>' <label-text> ']'
    }

    token label-text { <-[|\]\[{}]>* }

    rule class-def {
        'classDef' <ws> <class-name> <ws> <rest-of-line>
    }

    rule class-assign {
        'class' <ws> <id-list> <ws> <class-name-list>
    }

    rule style {
        'style' <ws> <id> <ws> <rest-of-line>
    }

    rule link-style {
        'linkStyle' <ws> <link-indices> <ws> <rest-of-line>
    }

    rule click {
        'click' <ws> <id> <ws> <click-target> [ <ws> <click-text> ]?
    }

    token click-target { <quoted> | <url> | <id> }
    token click-text { <quoted> }

    token class-name { <id> }
    rule class-name-list { <class-name>+ % [ <ws>? ',' <ws>? ] }

    rule id-list { <id>+ % [ <ws>? ',' <ws>? ] }

    token link-indices { <digits>+ % [ <ws>? ',' <ws>? ] }

    token id { <[A..Z a..z 0..9 \w \- _ .]>+ }
    token digits { <[0..9]>+ }

    token url { \S+ }
    token quoted { '"' <-["\n]>* '"' }

    token rest-of-line { <-[\n]>* }
    token ws { \h+ }
    token nl { \h* \n+ }

    rule init-directive {
        '%%{' <ws>? 'init' <ws>? ':' <ws>? <init-map> <ws>? '}%%'
    }

    rule init-map {
        '{' <ws>? <init-pairs>? <ws>? '}'
    }

    rule init-pairs {
        <init-pair>+ % [ <ws>? ',' <ws>? ]
    }

    rule init-pair {
        <init-key> <ws>? ':' <ws>? <init-value>
    }

    token init-key { <quoted> | <squoted> | <id> }
    rule init-value { <init-map> | <quoted> | <squoted> | <number> | <id> }

    token squoted { "'" <-['\n]>* "'" }
    token number { <[+-]>? <[0..9]>+ [ '.' <[0..9]>+ ]? }
}
