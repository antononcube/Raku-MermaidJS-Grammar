use v6.d;
use MermaidJS::Grammarish;

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