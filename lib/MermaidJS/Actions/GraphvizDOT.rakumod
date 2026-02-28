use v6.d;

use MermaidJS::Actions::Raku;

class MermaidJS::Actions::GraphvizDOT
        is MermaidJS::Actions::Raku {
    method TOP($/) {
        my $res = $<diagram>.made;

        my @lines;
        @lines.push('digraph G {');

        for $res<styles>.Array -> $s {
            @lines.push('  // ' ~ $s);
        }

        for $res<nodes>.Array -> %n {
            my $id = self!dot-id(%n<name>);
            my $label = self!dot-label(%n<label> // %n<name>);
            my $shape = self!dot-shape(%n<type> // 'rect');
            @lines.push("  $id [label=$label, shape=$shape];");
        }

        for $res<edges>.Array -> %e {
            my $from = self!dot-id(%e<from>);
            my $to = self!dot-id(%e<to>);
            my @attrs;
            if %e<label>:exists && %e<label>.defined && %e<label>.trim.chars {
                @attrs.push('label=' ~ self!dot-label(%e<label>));
            }
            @attrs.append(self!edge-attrs(%e<type> // ''));
            my $attr-str = @attrs.elems ?? ' [' ~ @attrs.join(', ') ~ ']' !! '';
            @lines.push("  $from -> $to$attr-str;");
        }

        @lines.push('}');
        make @lines.join("\n");
    }

    method !dot-id(Str $id --> Str) {
        my $safe = $id.subst('"', '\\"', :g);
        '"' ~ $safe ~ '"';
    }

    method !dot-label(Str $label --> Str) {
        my $safe = $label.subst('"', '\\"', :g);
        '"' ~ $safe ~ '"';
    }

    method !dot-shape(Str $type --> Str) {
        given $type {
            when 'circle' { 'circle' }
            when 'diamond' { 'diamond' }
            when 'round' { 'ellipse' }
            when 'subroutine' { 'box' }
            default { 'box' }
        }
    }

    method !edge-attrs(Str $op --> Array) {
        my @attrs;
        if $op.contains('.') {
            @attrs.push('style=dotted');
        } elsif $op.contains('-') && !$op.contains('>') {
            @attrs.push('style=dashed');
        }
        if $op.contains('=') {
            @attrs.push('penwidth=2');
        }
        if $op.contains('o') {
            @attrs.push('arrowhead=odot');
        } elsif $op.contains('x') {
            @attrs.push('arrowhead=tee');
        }
        @attrs;
    }
}
