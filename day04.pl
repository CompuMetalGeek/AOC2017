use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my $numberOfSafePassphrases = 0;
my $numberOfExtraSafePassphrases = 0;

while(my $input = <$fh>){
	if($input !~ /(\b\w+\b).*\1/){
		$numberOfSafePassphrases++;
	}
	my @input = split " ", $input;
	foreach my $x (@input) {
		$x = join "", sort(split "", $x);
	}
	$input = join " ", @input;
	if($input !~ /(\b\w+\b).*\1/){
		$numberOfExtraSafePassphrases++;
	}
}

print "There are ", colored( $numberOfSafePassphrases, "bright_red" ), " safe passphrases.\n";
print "There are ", colored( $numberOfExtraSafePassphrases, "bright_red" ), " extra safe passphrases. ( ", sprintf ("%.3f",time - $time) ," s )\n";
