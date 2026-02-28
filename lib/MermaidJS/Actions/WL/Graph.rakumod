use v6.d;

use MermaidJS::Actions::Raku;

class MermaidJS::Actions::WL::Graph
        is MermaidJS::Actions::Raku {
    method TOP($/) {

        my $res = $<diagram>.made;

        my @edge-exprs = $res<edges>.Array.map({
            self!wl-edge($_<from> // '', $_<to> // '')
        });
        my $edges = self!wl-list(@edge-exprs);

        my $vlabels = self!wl-list($res<nodes>.Array.map({
            my $name = $_<name> // '';
            my $label = $_<label> // $name;
            self!wl-rule(self!wl-string($name), "Placed[{self!wl-string($label)}, Center]")
        }));

        my $vshapes = self!wl-list($res<nodes>.Array.map({
            my $name = $_<name> // '';
            my $shape = self!wl-shape($_<type> // 'rect');
            self!wl-rule(self!wl-string($name), self!wl-string($shape))
        }));

        my @edge-labels = $res<edges>.Array.map({
            if $_<label>.defined && $_<label>.trim.chars {
                self!wl-rule(self!wl-edge($_<from> // '', $_<to> // ''), self!wl-string($_<label>))
            } else { Nil }
        }).grep(*.defined);
        my $elabels = @edge-labels.elems ?? self!wl-list(@edge-labels) !! Nil;

        my @args;
        @args.push($edges);
        @args.push('VertexLabels -> ' ~ $vlabels);
        @args.push('VertexShapeFunction -> ' ~ $vshapes);
        @args.push('EdgeLabels -> ' ~ $elabels) if $elabels.defined;
        @args.push('VertexSize -> {"Scaled", 0.1}');

        my $graph = 'Graph[' ~ @args.join(', ') ~ ']';

        my $styles = $res<styles>.Array;
        if $styles.elems {
            my $comment = '(* styles: ' ~ $styles.join('; ') ~ ' *)';
            make $comment ~ "\n" ~ $graph;
        } else {
            make $graph;
        }
    }

    method !wl-edge(Str $from, Str $to --> Str) {
        'DirectedEdge[' ~ self!wl-string($from) ~ ', ' ~ self!wl-string($to) ~ ']';
    }

    method !wl-rule(Str $lhs, Str $rhs --> Str) {
        $lhs ~ ' -> ' ~ $rhs;
    }

    method !wl-assoc(@rules --> Str) {
        '<|' ~ @rules.join(', ') ~ '|>';
    }

    method !wl-list(@items --> Str) {
        '{' ~ @items.join(', ') ~ '}';
    }

    method !wl-string(Str $s --> Str) {
        my $safe = $s.subst('"', '\\"', :g).subst("\\", "\\\\", :g);
        '"' ~ $safe ~ '"';
    }

    method !wl-shape(Str $type --> Str) {
        given $type {
            when 'circle' { 'Circle' }
            when 'diamond' { 'Diamond' }
            when 'round' { 'RoundRectangle' }
            when 'subroutine' { 'Rectangle' }
            default { 'Rectangle' }
        }
    }
}
