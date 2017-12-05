use Term::ANSIColor;

my $filename = "${0}_input";

open(my $fh, $filename);
@input = <$fh>;
my $location = 0;
my $counter = 0;

while($location < scalar @input){
	$location += $input[$location]++;
	$counter++;
}

print "First case, we escape after ", colored( $counter, "bright_red" ), " steps.\n";

seek $fh, 0, 0;
@input = <$fh>;

my $location = 0;
my $oldLocation = $location;
my $counter = 0;

while($location < scalar @input){
	$oldLocation = $location;
	$location += $input[$location];
	$input[$oldLocation] += $input[$oldLocation] < 3 ? 1 : -1 ;
	$counter++;
}

print "Second case, we escape after ", colored( $counter, "bright_red" ), " steps.\n";
