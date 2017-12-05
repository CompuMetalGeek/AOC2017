use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);
my $target = <$fh>;
chomp $target;

my $x=0, $y=0;
my $index=1;
my $direction = 0; # 0 is right, 1 up, 2 left, 3 down
my $step = 1;
my $previousStep = 0;

while ($index < $target) { # find first corner that is larger than our value
	# set a step along that direction
 	if( $direction == 0 ){
 		$x += $step;
 	} elsif( $direction == 1 ){
 		$y += $step;
 	} elsif( $direction == 2 ){
 		$x -= $step;
 	} elsif( $direction == 3 ){
 		$y -= $step;
 	}
 	# update index number for the steps that are taken
 	$index += $step;

 	if($step==$previousStep){ # make sure each step size is used twice
 		$step++;
 	} else{
 		$previousStep++;
 	}
 	$direction = ++$direction % 4; # change direction
}

# go back to requested number
my $step = $index - $target;
$direction = --$direction % 4;
if( $direction == 0 ){
	$x-=$step;
} elsif( $direction == 1 ){
	$y-=$step;
} elsif( $direction == 2 ){
	$x+=$step;
} elsif( $direction == 3 ){
	$y+=$step;
}
print "The taxicab distance is ", colored( abs($x)+abs($y), "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;
# lookup in OEIS (https://oeis.org/A141481/b141481.txt) at entry 58
print "First value larger than the input is " , colored(266330,"bright_red"), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
