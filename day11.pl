use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

while(my $input = <$fh>){
	chomp $input;
	my @input = split ",",$input;
	
	my $north = 0;
	my $northeast = 0;
	my $northwest = 0;
	my $maxDistance = 0;
	foreach (@input) {
		if($_ eq "n"){
			$north++;
		} elsif($_ eq "s"){
			$north--;
		} elsif($_ eq "ne"){
			$northeast++;
		} elsif($_ eq "sw"){
			$northeast--;
		} elsif($_ eq "nw"){
			$northwest++;
		} elsif($_ eq "se"){
			$northwest--;
		}
		my $currentDistance = 0;
		foreach my $x (calculateDistance($north,$northeast,$northwest)) {
			$currentDistance+=abs($x);
		}
		if ($maxDistance < $currentDistance) {
			$maxDistance = $currentDistance;
		}
	}

	($north,$northeast,$northwest) = calculateDistance($north,$northeast,$northwest);
	
	print "The required number of steps is ", colored( abs($north)+abs($northeast)+abs($northwest), "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
	print "The furthest away was ", colored( $maxDistance, "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
}

sub calculateDistance {
	my $north = shift;
	my $northeast = shift;
	my $northwest = shift;# NE + NW = N

	while( ($northeast!=0) && ($northwest!=0) && (($northeast<0) == ($northwest<0)) ){
		my $sign = $northeast/abs($northeast);
		$northeast -= $sign;
		$northwest -= $sign;
		$north += $sign;
	}

	# N - NE = NW
	while( ($north!=0) && ($northeast!=0) && (($north<0) != ($northeast<0)) ){
		my $sign = $north/abs($north);
		$north -= $sign;
		$northeast -= -$sign;
		$northwest += $sign;
	}

	# N-NW = NE
	while( ($north!=0) && ($northwest!=0) && (($north<0) != ($northwest<0)) ){
		my $sign = $north/abs($north);
		$north -= $sign;
		$northwest -= -$sign;
		$northeast += $sign;
	}

	return ($north,$northeast,$northwest);
}