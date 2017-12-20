use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;
use Set::Scalar;
use v5.14;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my %position;
my %velocity;
my %acceleration;

my $i = 0;
my $closest = -1;
my $lowestAcceleration = -1;
my $lowestVelocity = -1;
my $lowestPosition = -1;
while(my $input = <$fh>){
	chomp $input;
	my @line = split ", ", $input;
	my @position = $line[0] =~ /(-?\d+)/g;
	my @velocity = $line[1] =~ /(-?\d+)/g;
	my @acceleration = $line[2] =~ /(-?\d+)/g;
	#printf "p(%20s) v(%20s) a(%20s)\n", join(",", @position), join(",", @velocity), join(",", @acceleration);

	$position{$i} = [@position];
	$velocity{$i} = [@velocity];
	$acceleration{$i} = [@acceleration];

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
				#exit(0);
			}
		}
	}
	$i++;
}

print "The particle that stays closest is ", colored( "$closest" , "black on_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;
my $runtime = 1_00;
for (my $t = 1; $t < $runtime; $t++) {
	calculatePositions($t);
	my @collided = getCollisions();
	for my $duplicate (@collided){
		delete $position{$duplicate};
	}
	if($t % ($runtime/100) == 0 ){
		local $| = 1;
		printf "\r%3d %% completed -- %4d keys left", 
				$t / ($runtime / 100), scalar keys %position;
	}
}

print "\rThere will be ", colored( scalar keys %position , "black on_red" ), " particles left. ( ", sprintf ("%.3f",time - $time) ," s )\n";

sub calculatePositions {
	my $t = shift;
	foreach my $index (keys %position) {
		$velocity{$index}[0] += $acceleration{$index}[0];
		$velocity{$index}[1] += $acceleration{$index}[1];
		$velocity{$index}[2] += $acceleration{$index}[2];
		
		$position{$index}[0] += $velocity{$index}[0];
		$position{$index}[1] += $velocity{$index}[1];
		$position{$index}[2] += $velocity{$index}[2];
	}
}

sub getCollisions {
	my @set;
	my @indices = keys %position;
	for (my $index = 0; $index < scalar @indices; $index++) {
		for (my $secondIndex = $index+1; $secondIndex < scalar @indices; $secondIndex++) {
			if(join(",", @{$position{$indices[$index]}}) eq join(",", @{$position{$indices[$secondIndex]}})){
				push @set, $indices[$index];
				push @set, $indices[$secondIndex];
			}
		}
	}
	return @set;
}