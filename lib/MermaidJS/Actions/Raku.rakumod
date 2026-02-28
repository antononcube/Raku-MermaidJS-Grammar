use v6.d;

use MermaidJS::Actions::Raku::Flowchartish;
use MermaidJS::Actions::Raku::MindMappish;

class MermaidJS::Actions::Raku
        does MermaidJS::Actions::Raku::Flowchartish
        does MermaidJS::Actions::Raku::MindMappish {

    method TOP($/) {
        make($<diagram>.made);
    }

    method diagram($/) {
        if $<flowchart> {
            make($<flowchart>.made);
        } elsif $<mindmap> {
            make($<mindmap>.made);
        } else {
            die 'No Raku actions for the parsed diagram.'
        }
    }
}
