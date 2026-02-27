use v6.d;
use MermaidJS::Grammarish;
use MermaidJS::Actions::PlantUML;
use MermaidJS::Actions::Raku;

grammar MermaidJS::Grammar
        does MermaidJS::Grammarish {
}

#-----------------------------------------------------------
our sub mermaid-js-subparse(Str:D $command, Str:D :$rule = 'TOP') is export {
    my $ending = $command.substr(*- 1, *) eq "\n" ?? '' !! "\n";
    MermaidJS::Grammar.subparse($command ~ $ending, :$rule);
}

our sub mermaid-js-parse(Str:D $command, Str:D :$rule = 'TOP') is export {
    my $ending = $command.substr(*- 1, *) eq "\n" ?? '' !! "\n";
    MermaidJS::Grammar.parse($command ~ $ending, :$rule);
}

our sub mermaid-js-interpret(Str:D $command,
                             Str:D :$rule = 'TOP',
                             :t(:to(:format(:a(:$actions)))) is copy = MermaidJS::Actions::Raku.new
                             ) is export {
    # Choose actions class
    $actions = do given $actions {
        when Whatever {
            MermaidJS::Actions::Raku.new
        }
#        when $_ ~~ Str:D && $_.lc ∈ ["mathematica", "wl", "wolfram language"] {
#            MermaidJS::Actions::Mathematica.new
#        }
#        when $_ ~~ Str:D && $_.lc ∈ <dot graphviz graphviz-dot> {
#            MermaidJS::Actions::GraphvizDOT.new
#        }
        when $_ ~~ Str:D && $_.lc ∈ <plantuml> {
            MermaidJS::Actions::PlantUML.new
        }
        when $_ ~~ Str:D && $_.lc ∈ <raku perl6> {
            MermaidJS::Actions::Raku.new
        }
        default {
            $actions
        }
    }

    # Result
    return MermaidJS::Grammar.parse($command, :$rule, :$actions).made;
}