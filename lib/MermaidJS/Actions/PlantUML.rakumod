use v6.d;

use MermaidJS::Actions::Raku;

class MermaidJS::Actions::PlantUML
        is MermaidJS::Actions::Raku {
    has @!body-lines;

    method flowchart($/) {
        my $dir-line = self!direction-line($<direction>);

        my @lines;
        @lines.push('@startuml');
        @lines.push($dir-line) if $dir-line.defined;

        for self.node-order -> $id {
            my %node = self.nodes{$id};
            my $label = %node<label> // $id;
            next without $label;
            my $shape = %node<shape> // 'rectangle';
            my $safe-label = $label.subst('"', '\\"', :g);
            @lines.push(qq{$shape "$safe-label" as $id});
        }

        @lines.append(@!body-lines);

        for self.edges -> %edge {
            my $line = %edge<from> ~ ' --> ' ~ %edge<to>;
            if %edge<label>:exists && %edge<label>.defined && %edge<label>.trim.chars {
                $line ~= ' : ' ~ %edge<label>.trim;
            }
            @lines.push($line);
        }

        @lines.push('@enduml');
        $/.make(@lines.join("\n"));
    }

    method subgraph($/) {
        my $title = $<subgraph-start><subgraph-title>
            ?? self.strip-label($<subgraph-start><subgraph-title>.Str)
            !! '';
        my @lines;
        @lines.push($title.chars ?? "package \"$title\" \{" !! 'package {');
        @lines.append($<statement-list>.made) if $<statement-list>;
        @lines.push('}');
        $/.make(@lines);
    }

    method comment($/) {
        my $text = $/.Str.subst(/^ \h* '%%' \h* /, '');
        $/.make("' $text");
    }

    method class-def($/) { $/.make("' " ~ $/.Str); }
    method class-assign($/) { $/.make("' " ~ $/.Str); }
    method style($/) { $/.make("' " ~ $/.Str); }
    method link-style($/) { $/.make("' " ~ $/.Str); }
    method click($/) { $/.make("' " ~ $/.Str); }

    method edge($/) {
        my @edges;
        my @current = ($<node>.made, );
        self.add-node(@current[0]);

        for $<linked-node> -> $ln {
            my %ln = $ln.made;
            my @targets = |%ln<nodes>;
            for @targets -> $node {
                self.add-node($node);
            }
            for @current -> $src {
                for @targets -> $dst {
                    @edges.push({
                        from => $src<id>,
                        to => $dst<id>,
                        label => %ln<link><label>,
                        op => %ln<link><op>,
                    });
                }
            }
            @current = @targets;
        }
        $/.make(@edges);
    }

    method !direction-line($direction) {
        return Nil unless $direction;
        given $direction.Str {
            when 'LR' { 'left to right direction' }
            when 'RL' { 'right to left direction' }
            when 'BT' { 'bottom to top direction' }
            default { 'top to bottom direction' }
        }
    }
}
