use Term::ANSIColor;
use Time::HiRes qw/time/;

my $filename = "${0}_input";
my $time = time;
open(my $fh, $filename);
@input = <$fh>;
@original = @input;
my $location = 0;
my $counter = 0;

while($location < scalar @input){
	$location += $input[$location]++;
	$counter++;
}

print "First case, we escape after ", colored( $counter, "bright_red" ), " steps. ( ", sprintf ("%.3f",time - $time) ," s )\n";
$time=time;
@input = @original;

my $location = 0;
my $oldLocation = $location;
my $counter = 0;

while($location < scalar @input){
	$oldLocation = $location;
	$location += $input[$location];
	$input[$oldLocation] += $input[$oldLocation] < 3 ? 1 : -1 ;
	$counter++;
}

print "Second case, we escape after ", colored( $counter, "bright_red" ), " steps. ( ", sprintf ("%.3f",time - $time) ," s )\n";
