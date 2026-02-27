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
    regex statement-list { <statement>+ %% \n }

    regex statement {
        \h* [
        <subgraph>
        || <comment>
        || <class-def>
        || <class-assign>
        || <style>
        || <link-style>
        || <click>
        || <edge>
        || <node-def>
        #| <any-line>
        ] \h*
    }

    token any-line { <-[\n]>+ }
    token comment { \h* '%%' <-[\n]>* }

    regex subgraph {
        #<subgraph-start> $<in>=(.*?) <subgraph-end>
        <subgraph-start> \n <statement-list>? \n <subgraph-end>
    }
    regex subgraph-start { \h* 'subgraph' [ \h* <subgraph-title> ]? \h* }
    regex subgraph-title { <quoted> | <label-text> }
    regex subgraph-end { \h* 'end' }

    regex edge {
        <node> \h* [<linked-node>+ % \h*]?
    }

    regex linked-node {
        <link> \h* <node-list>
    }

    regex link {
        <link-op> \h* [ <edge-label> \h* <link-op>? ]?
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

    regex node-list { <node>+ % [ \h* '&' \h* ]  }

    regex node { <node-id> <node-label>? <class-annotation>? }

    token node-id { <id> }
    token class-annotation { ':::' <class-name> }

    token node-label {
        '[[' <label-text> ']]'
        | '[' <label-text> ']'
        | '([' <label-text> '])'
        | '(((' <label-text> ')))'
        | '((' <label-text> '))'
        | '(' <label-text> ')'
        | '{{' <label-text> '}}'
        | '{' <label-text> '}'
        | '<' <label-text> '>'
        | '>' <label-text> ']'
    }

    token label-text { <-[|\]\[{}()\v]>* }

    regex class-def {
        'classDef' \h* <class-name> \h <rest-of-line>
    }

    regex class-assign {
        'class' \h+ <id-list> \h+ <class-name-list>
    }

    regex style {
        'style' \h+ <id> \h+ <rest-of-line>
    }

    regex link-style {
        'linkStyle' \h+ <link-indices> \h+ <rest-of-line>
    }

    regex click {
        'click' \h+ <id> \h+ <click-target> [ \h+ <click-text> ]?
    }

    token click-target { <quoted> | <url> | <id> }
    token click-text { <quoted> }

    token class-name { <id> }
    regex class-name-list { <class-name>+ % [ \h* ',' \h* ] }

    regex id-list { <id>+ % [ \h* ',' \h* ] }

    token link-indices { <digits>+ % [ \h* ',' \h* ] }

    token id { <[A..Z a..z 0..9 \w \- _ .]>+ }
    token digits { <[0..9]>+ }

    token url { \S+ }
    token quoted { '"' <-["\n]>* '"' }

    token rest-of-line { <-[\n]>* }
    token ws { \h+ }
    token nl { \h* \n+ }

    regex init-directive {
        '%%{' \h* 'init' \h* ':' \h* <init-map> \h* '}%%'
    }

    regex init-map {
        '{' \h* <init-pairs>? \h* '}'
    }

    regex init-pairs {
        <init-pair>+ % [ \h* ',' \h* ]
    }

    regex init-pair {
        <init-key> \h* ':' \h* <init-value>
    }

    token init-key { <quoted> | <squoted> | <id> }
    regex init-value { <init-map> | <quoted> | <squoted> | <number> | <id> }

    token squoted { "'" <-['\n]>* "'" }
    token number { <[+-]>? <[0..9]>+ [ '.' <[0..9]>+ ]? }
}
