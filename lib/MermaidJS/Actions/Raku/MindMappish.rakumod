use v6.d;

role MermaidJS::Actions::Raku::MindMappish {

    method mindmap($/) {
        my @lines = $<mindmap-line-list> ?? |$<mindmap-line-list>.made !! ();
        my %tree;
        my @stack = ({ indent => -1, children => %tree },);

        for @lines -> %entry {
            my $indent = %entry<indent> // 0;
            my $key = %entry<key> // '';
            next unless $key.chars;

            while @stack.elems > 1 && $indent <= @stack[*-1]<indent> {
                @stack.pop;
            }

            my %parent := @stack[*-1]<children>;
            %parent{$key} //= {};
            my %children := %parent{$key};
            @stack.push({ indent => $indent, children => %children });
        }

        make({type => 'mindmap', root => %tree});
    }

    method mindmap-line-list($/) {
        my @entries = $<mindmap-line>».made.grep(*.defined);
        make(@entries);
    }

    method mindmap-line($/) {
        return make(Nil) if $<comment>;

        my $line = $/.Str;
        my $indent = $line.chars - $line.trim-leading.chars;
        my %node = $<mindmap-node-line>.made;

        make({
            indent => $indent,
            key => %node<key>,
        });
    }

    method mindmap-node-line($/) {
        my %node = $<mindmap-node>.made;
        make(%node);
    }

    method mindmap-node($/) {
        if $<mindmap-root-node> {
            make($<mindmap-root-node>.made);
        } elsif $<node> {
            my %n = $<node>.made;
            make({ key => (%n<label> // %n<id>) });
        } elsif $<mindmap-quoted-node> {
            make($<mindmap-quoted-node>.made);
        } else {
            make($<mindmap-text-node>.made);
        }
    }

    method mindmap-root-node($/) {
        my $label = $<node-label> ?? self.strip-label($<node-label>.Str) !! 'root';
        make({ key => $label });
    }

    method mindmap-quoted-node($/) {
        my $label = self.unquote($/.Str.trim);
        make({ key => $label });
    }

    method mindmap-text-node($/) {
        make({ key => $/.Str.trim });
    }

    method unquote(Str:D $text --> Str) {
        return $text.substr(1, $text.chars - 2)
            if $text.chars >= 2 && (
                ($text.starts-with('"') && $text.ends-with('"'))
                || ($text.starts-with("'") && $text.ends-with("'"))
            );
        $text;
    }
}
