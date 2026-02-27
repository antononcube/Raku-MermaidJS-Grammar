use v6.d;

class MermaidJS::Actions::Raku {
    has %!nodes;
    has @!node-order;
    has @!edges;
    has @!styles;

    method TOP($/) {
        make($<diagram>.made);
    }

    method diagram($/) {
        make($<flowchart>.made);
    }

    method flowchart($/) {
        my @statements = |$<statement-list>.made;
        say (:@statements);
        my @nodes;
        for @!node-order -> $id {
            my %node = %!nodes{$id};
            @nodes.push({
                name => %node<id>,
                label => %node<label>,
                type => %node<type>,
            });
        }

        make({
            nodes => @nodes,
            edges => @!edges,
            styles => @!styles,
        });
    }

    method statement-list($/) {
        make($<statement>».made);
    }

    method statement($/) {
        if $<edge> {
            @!edges.append($<edge>.made);
        } elsif $<node-def> {
            self!add-node($<node-def>.made);
        } elsif $<comment> {
            @!styles.push($<comment>.made);
        } elsif $<class-def> {
            @!styles.push($<class-def>.made);
        } elsif $<class-assign> {
            @!styles.push($<class-assign>.made);
        } elsif $<style> {
            @!styles.push($<style>.made);
        } elsif $<link-style> {
            @!styles.push($<link-style>.made);
        } elsif $<click> {
            @!styles.push($<click>.made);
        } elsif $<subgraph> {
            @!styles.append($<subgraph>.made);
        }
        make(True);
    }

    method subgraph($/) {
        my $title = $<subgraph-start><subgraph-title>
            ?? self!strip-label($<subgraph-start><subgraph-title>.Str)
            !! '';
        my @lines;
        @lines.push($title.chars ?? "subgraph $title" !! 'subgraph');
        @lines.append($<statement-list>.made) if $<statement-list>;
        @lines.push('end');
        make(@lines);
    }

    method comment($/) {
        make($/.Str.trim);
    }

    method class-def($/) { make($/.Str.trim); }
    method class-assign($/) { make($/.Str.trim); }
    method style($/) { make($/.Str.trim); }
    method link-style($/) { make($/.Str.trim); }
    method click($/) { make($/.Str.trim); }

    method edge($/) {
        my @edges;
        my @current = ($<node>.made, );
        self!add-node(@current.head);

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
                        type => %ln<link><op>,
                        label => %ln<link><label>,
                    });
                }
            }
            @current = @targets;
        }
        make(@edges);
    }

    method linked-node($/) {
        make({
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
        make({ op => $<link-op>.Str, label => $label });
    }

    method node-list($/) {
        make($<node>».made);
    }

    method node-def($/) {
        make($<node>.made);
    }

    method node($/) {
        my $id = $<node-id>.Str;
        my $label = $id;
        my $type = 'rect';
        if $<node-label> {
            my $raw = $<node-label>.Str;
            $label = self!strip-label($raw);
            $type = self!node-type($raw);
        }
        make({
            :$id,
            :$label,
            :$type,
        });
    }

    method !add-node(%node) {
        my $id = %node<id>;
        return if %!nodes{$id}:exists;
        %!nodes{$id} = %node;
        @!node-order.push($id);
    }

    method !strip-label(Str:D $raw --> Str) {
        my $text = $raw;
        $text .= subst(/^ <[ \[ \] \( \) \{ \} \< \> ]>+ /);
        $text .= subst(/ <[ \[ \] \( \) \{ \} \< \> ]>+ $/);
        $text;
    }

    method !node-type(Str $raw --> Str) {
        return 'circle' if $raw.starts-with('((');
        return 'double-circle' if $raw.starts-with('(((');
        return 'rhombus' if $raw.starts-with('{');
        return 'hexagon' if $raw.starts-with('{{');
        return 'round' if $raw.starts-with('(');
        return 'parallelogram' if $raw.starts-with('[/');
        return 'parallelogram-alt' if $raw.starts-with('[\\');
        return 'trapezoid' if $raw.starts-with('[/') && $raw.ends-with('\]');
        return 'trapezoid-alt' if $raw.starts-with('[\\') && $raw.ends-with('/]');
        return 'stadium' if $raw.starts-with('([');
        return 'cylinder' if $raw.starts-with('[(');
        return 'subroutine' if $raw.starts-with('[[');
        return 'assymetric' if $raw.starts-with('>');
        return 'rect';
    }
}
