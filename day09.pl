use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);
my $score = 0;
my $currentLevel = 0;
my $inGarbage=0;
my $charsInGarbage=0;
while( 0 < read($fh, my $input, 1) ) {
	if( !$inGarbage ) {
		if( $input eq "{" ) {
			$currentLevel++;
		} elsif( $input eq "}" ) {
			$score+=$currentLevel--;
		} elsif( $input eq "<" ) {
			$inGarbage=1;
		}
	} else {
		if( $input eq "!") {
			read $fh, my $input, 1;
		} elsif ( $input eq ">" ) {
			$inGarbage = 0;
		} else {
			$charsInGarbage++;
		}
	}
}

print "The total score is ", colored( $score, "bright_red" ), ".\n";
print "The total amount of garbage is ", colored( $charsInGarbage, "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
