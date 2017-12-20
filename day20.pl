use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;
use v5.14;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my $i = 0;
my $closest = -1;
my $lowestAcceleration = -1;
my $lowestVelocity = -1;
my $lowestPosition = -1;
while(my $input = <$fh>){
	my @line = split ", ", $input;
	my @position = $line[0] =~ /(-?\d+)/g;
	my @velocity = $line[1] =~ /(-?\d+)/g;
	my @acceleration = $line[2] =~ /(-?\d+)/g;




	# part 1: particle with lowest global acceleration stays closest to (0,0,0), when equal acceleration check for lowest velocity, when equal velocity, check position
	my $relAcceleration = abs($acceleration[0]) + abs($acceleration[1]) + abs($acceleration[2]);
	my $relVelocity = abs($velocity[0]) + abs($velocity[1]) + abs($velocity[2]);
	my $relPosition = abs($position[0]) + abs($position[1]) + abs($position[2]);
	if($relAcceleration < $lowestAcceleration || $lowestAcceleration ==-1){
		$closest = $i;
		$lowestAcceleration = $relAcceleration;
		$lowestVelocity = $relVelocity;
		$lowestPosition = $relPosition;
	} elsif($relAcceleration == $lowestAcceleration){
		if($relVelocity<$lowestVelocity){
			$closest = $i;
			$lowestVelocity = $relVelocity;
			$lowestPosition = $relPosition;
		} elsif($relVelocity == $lowestVelocity){
			if($relPosition<$lowestPosition){
				$closest = $i;
				$lowestPosition = $relPosition;
			} else {
				print "2 exact same closest points";
				exit(0);
			}
		}
	}
	$i++;
}

print "The particle that stays closest is ", colored( "$closest" , "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
