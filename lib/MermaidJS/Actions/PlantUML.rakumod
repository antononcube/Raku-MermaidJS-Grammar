use v6.d;

class MermaidJS::Actions::PlantUML {
    has %!nodes;
    has @!node-order;
    has @!edges;
    has @!body-lines;

    method TOP($/) {
        $/.make($<diagram>.made);
    }

    method diagram($/) {
        $/.make($<flowchart>.made);
    }

    method flowchart($/) {
        my $dir-line = self!direction-line($<direction>);

        my @lines;
        @lines.push('@startuml');
        @lines.push($dir-line) if $dir-line.defined;

        for @!node-order -> $id {
            my %node = %!nodes{$id};
            my $label = %node<label> // $id;
            next without $label;
            my $shape = %node<shape> // 'rectangle';
            my $safe-label = $label.subst('"', '\\"', :g);
            @lines.push(qq{$shape "$safe-label" as $id});
        }

        @lines.append(@!body-lines);

        for @!edges -> %edge {
            my $line = %edge<from> ~ ' --> ' ~ %edge<to>;
            if %edge<label>:exists && %edge<label>.defined && %edge<label>.trim.chars {
                $line ~= ' : ' ~ %edge<label>.trim;
            }
            @lines.push($line);
        }

        @lines.push('@enduml');
        $/.make(@lines.join("\n"));
    }

    method statement-list($/) {
        $/.make($<statement>».made);
    }

    method statement($/) {
        if $<edge> {
            @!edges.append($<edge>.made);
        } elsif $<node-def> {
            self!add-node($<node-def>.made);
        } elsif $<comment> {
            @!body-lines.push($<comment>.made);
        } elsif $<class-def> {
            @!body-lines.push($<class-def>.made);
        } elsif $<class-assign> {
            @!body-lines.push($<class-assign>.made);
        } elsif $<style> {
            @!body-lines.push($<style>.made);
        } elsif $<link-style> {
            @!body-lines.push($<link-style>.made);
        } elsif $<click> {
            @!body-lines.push($<click>.made);
        } elsif $<subgraph> {
            @!body-lines.append($<subgraph>.made);
        }
        $/.make(True);
    }

    method subgraph($/) {
        my $title = $<subgraph-start><subgraph-title>
            ?? self!strip-label($<subgraph-start><subgraph-title>.Str)
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
        self!add-node(@current[0]);

        for $<linked-node> -> $ln {
            my %ln = $ln.made;
            my @targets = |%ln<nodes>;
            for @targets -> $node {
                self!add-node($node);
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

    method linked-node($/) {
        $/.make({
            link => $<link>.made,
            nodes => $<node-list>.made,
        });
    }

    method link($/) {
        my $label;
        if $<edge-label> {
            if $<edge-label><label-text> {
                $label = $<edge-label><label-text>.Str;
            } elsif $<edge-label><edge-text> {
                $label = $<edge-label><edge-text>.Str;
            }
        }
        $/.make({ op => $<link-op>.Str, label => $label });
    }

    method node-list($/) {
        $/.make($<node>».made);
    }

    method node-def($/) {
        $/.make($<node>.made);
    }

    method node($/) {
        my $id = $<node-id>.Str;
        my $label = $id;
        my $shape = 'rectangle';
        if $<node-label> {
            my $raw = $<node-label>.Str;
            $label = self!strip-label($raw);
            $shape = self!shape-for($raw);
        }
        $/.make({
            :$id,
            :$label,
            :$shape,
        });
    }

    method !add-node(%node) {
        my $id = %node<id>;
        return if %!nodes{$id}:exists;
        %!nodes{$id} = %node;
        @!node-order.push($id);
    }

    method !strip-label(Str $raw --> Str) {
        my $text = $raw;
        $text ~~ s/^ <[ \[ \] \( \) \{ \} \< \> ]>+ //;
        $text ~~ s/ <[ \[ \] \( \) \{ \} \< \> ]>+ $//;
        $text;
    }

    method !shape-for(Str $raw --> Str) {
        return 'circle' if $raw.starts-with('((') || $raw.starts-with('(((');
        return 'diamond' if $raw.starts-with('{');
        return 'rectangle';
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
