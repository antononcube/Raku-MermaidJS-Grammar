use v6.d;

use MermaidJS::Actions::Raku;
use JSON::Fast;

class MermaidJS::Actions::JSON
        is MermaidJS::Actions::Raku {
    has $.pretty is rw = True;
    method TOP($/) {
        my $res = $<diagram>.made;
        make to-json($res, :$!pretty);
    }
}
