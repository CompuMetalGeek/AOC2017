use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);
my %values;
my %children;
my %parent;
my $root;
while(my $input = <$fh>){
	chomp $input;
	#print "$input\n---\n";
	my @input = split /,? /,$input;
	#print arrayToString(@input),"\n";

	my $element = $input[0];
	my $value = substr($input[1], 1, length($input[1]) - 2);
	$values{$element} = $value;
	$children{$element} = [@input[3..$#input]];
	foreach my $child (@input[3..$#input]) {
		$parent{$child} = $element;
	}
}

foreach my $element (keys %values) {
	if(!$parent{$element}){
		$root = $element;
	}
}

print "The bottom program is named ", colored( $root, "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
$time = time;
my @problemChildren;
my @problemValues;
createStack($root);

foundProblemSituation:
my $correctTotal = $problemValues[0]==$problemValues[1]?$problemValues[0]:$problemValues[2];
my $wrongTotal = (grep {!/$correctTotal/} @problemValues)[0];
my $wrongValue;
my $wrongProgram;
for (my $i = 0; $i < scalar @problemValues; $i++) {
	if($problemValues[$i]==$wrongTotal){
		$wrongProgram = $problemChildren[$i];
		$wrongValue = $values{$problemChildren[$i]};
		last;
	}
}
	
print "The new value for the wrong program ($wrongProgram) is ", 
	colored( $wrongValue + ($correctTotal-$wrongTotal), "bright_red" ), 
	". ( ", sprintf ("%.3f",time - $time) ," s )\n";




sub arrayToString {
	my $retval="";
	foreach my $x (@_) {
		$retval.= "$x,";
	}
	chop $retval;
	return $retval;
}

sub childrenToString {
	my $retval="";
	for (my $i = 0; $i < scalar @_ /2; $i++) {
		$retval .= $_[$i] . " (" . $_[$i + scalar @_ /2] . "),";
	}
	chop $retval;
	return $retval;
}

sub createStack{
	my $root = shift;
	createLevel($root,0);

}

sub createLevel{
	my $element = shift;
	my $level = shift;
	my @childWeights;
	my $weight = $values{$element};
	foreach my $child (@{$children{$element}}) {
		push @childWeights, createLevel($child,$level+1);
	}

	 if(!elementsEqual(@childWeights)){
	 	@problemChildren = @{$children{$element}};
	 	@problemValues = @childWeights;
	 	goto foundProblemSituation;
	foreach my $childWeight (@childWeights) {
		$weight+=$childWeight;
	}
	 	$weight += scalar @childWeights * $childWeights[0];
	 } else {
	 	$weight += scalar @childWeights * $childWeights[0];
	 }


	#used for visual representation, remove goto for full tree
	# for (my $i = 0; $i < $level; $i++) {
	# 	print "            ";
	# }
	# print "|> $element ($weight)\n";
	return $weight;
}

sub elementsEqual {
	for (my $i = 0; $i < scalar @_; $i++) {
		if($_[0] != $_[$i]){
			return 0;
		}
	}
	return 1;
}
