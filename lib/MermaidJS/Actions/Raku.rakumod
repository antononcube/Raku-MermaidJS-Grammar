use v6.d;

use MermaidJS::Actions::Raku::Flowchartish;

class MermaidJS::Actions::Raku
        does MermaidJS::Actions::Raku::Flowchartish {

    method TOP($/) {
        make($<diagram>.made);
    }

    method diagram($/) {
        make($<flowchart>.made);
    }
}
