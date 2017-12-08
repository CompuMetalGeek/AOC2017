use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);
my %registers;
my ($globalMax,$globalMaxvar);
while(my $input = <$fh>){
	my @input = split " ",$input;
	my $register = $input[0];
	my $operator = $input[1];
	my $value = $input[2];
	my $conditionRegister = $input[4];
	my $conditionOperator = $input[5];
	my $conditionValue = $input[6];
	if(evalCondition($conditionRegister,$conditionOperator,$conditionValue)){
		execute($register,$operator,$value);
		my ($currentMax, $currentMaxvar) = calculateMaxValue();
		if($globalMax<$currentMax){
			$globalMax=$currentMax;
			$globalMaxvar=$currentMaxvar;
		}
	}
}

my ($max, $maxvar) = calculateMaxValue();


print "The maximum value at the end is ", colored( $max, "bright_red" ), " (stored in '$maxvar').\n";
print "The maximum value ever stored is ", colored( $globalMax, "bright_red" ), " (stored in '$globalMaxvar'). ( ", sprintf ("%.3f",time - $time) ," s )\n";



sub evalCondition {
	my $register = shift;
	my $operator = shift;
	my $value = shift;
	if(! $registers{$register}){
		$registers{$register} = 0;
	}
	return eval($registers{$register}.$operator.$value);
}

sub execute {
	my $register = shift;
	my $operator = shift;
	my $value = shift;
	if(! $registers{$register}){
		$registers{$register} = 0;
	}

	if($operator eq "inc") {
		$registers{$register} += $value;
	} elsif($operator eq "dec") {
		$registers{$register} -= $value;
	}
}

sub calculateMaxValue{
	my ($max, $maxvar);
	while (my ($key, $value) =each %registers) {
		if(! $max){
			$max = $value;
			$maxvar = $key;
		}
		if($max<$value){
			$max = $value;
			$maxvar = $key;
		}
	}
	return ($max,$maxvar);
}