use Term::ANSIColor;
use Time::HiRes qw/time/;
use List::Util qw/max/;

my $filename = "${0}_input";
my $time = time;
open(my $fh, $filename);

my $input = <$fh>;
chomp $input;
my @input = split "\t", $input;

# number of cycles in total
my $cycles = 0;
# all passed states
my @states = (toString(@input));

my $duplicateFound = 0;
# continue redistributing the largest element until we get in a previous state
while(!$duplicateFound){
	# start next cycle
	$cycles++;
	# execute redistribution
	@input = redistribute(\@input);
	# get representation of state
	$currentState = toString(@input);
	# check if we've been in this state
	$duplicateFound = contains(\@states, $currentState);
	# add state to all passed states
	push @states, $currentState;
}

print "We have a duplicate after ", colored( $cycles, "bright_red" ), " cycles. ( ", sprintf ("%.3f",time - $time) ," s )\n";
$time = time;
print "The loop is ", colored( getLoopSize(\@states), "bright_red" ), " cycles. ( ", sprintf ("%.3f",time - $time) ," s )\n";


sub toString {
	return join( ",", @_);
}

sub contains {
	my $arrayref = shift;
	my @array = @{$arrayref};
	my $newElement = shift;
	# iterate over every existing element and compare it to the new element
	foreach my $element (@array) {
		if($element eq $newElement){
			return 1;
		}
	}
	return 0;
}

sub redistribute {
	my $listref = shift;
	my @list = @{$listref};
	my $max = max @list;

	my $index = 0;
	# look for the first element with the largest value in the list
	while( $list[$index] != $max ){
		$index++;
	}

	# take all values from this element
	$list[$index] = 0;
	# redistribute over all elements, starting with the next element
	while($max > 0){
		$index = (++$index) % (scalar @list);
		$list[$index]++;
		$max--;
	}
	return @list;
}

sub getLoopSize {
	my $listref = shift;
	my @list = @{$listref};

	# we start assuming the loop is the same size as the list, 
	# we then iterate over each element and 
	# decrement the size of the loop until we find the real start
	my $count=$#list;
	# find first element that has same state as last element
	foreach my $element (@list) {
		if($element eq $list[$#list]){
			return $count;
		}
		$count--;
	}
}