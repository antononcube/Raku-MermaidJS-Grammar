use v6.d;

use MermaidJS::Actions::Raku;

class MermaidJS::Actions::WL::Association
        is MermaidJS::Actions::Raku {
    method TOP($/) {
        my $res = $<diagram>.made;

        my $nodes = self!wl-list($res<nodes>.Array.map({
            self!wl-assoc(%(
                name => $_<name> // '',
                label => $_<label> // $_<name> // '',
                type => $_<type> // '',
            ))
        }));

        my $edges = self!wl-list($res<edges>.Array.map({
            self!wl-assoc(%(
                from => $_<from> // '',
                to => $_<to> // '',
                type => $_<type> // '',
                label => $_<label>,
            ))
        }));

        my $styles = self!wl-list($res<styles>.Array.map({ self!wl-string($_) }));

        my $out = "<|\"nodes\" -> $nodes, \"edges\" -> $edges, \"styles\" -> $styles|>";
        make $out;
    }

    method !wl-assoc(%pairs --> Str) {
        my @parts;
        for %pairs.kv -> $k, $v {
            my $val = $v.defined ?? self!wl-string($v.Str) !! 'Null';
            @parts.push('"' ~ $k ~ '" -> ' ~ $val);
        }
        '<|' ~ @parts.join(', ') ~ '|>';
    }

    method !wl-list(@items --> Str) {
        '{' ~ @items.join(', ') ~ '}';
    }

    method !wl-string(Str $s --> Str) {
        my $safe = $s.subst('"', '\\"', :g).subst("\\", "\\\\", :g);
        '"' ~ $safe ~ '"';
    }
}
