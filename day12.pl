use strict;
use Term::ANSIColor;
use Win32::Console::ANSI;
use Time::HiRes qw/time/;
use Set::Scalar;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);
my %links;
while(my $input = <$fh>){
	chomp $input;
	my @input = split / <-> |, /,$input;
	my $program=$input[0];
	for(my $i = 1; $i<scalar @input; $i++) {
		chomp $input[$i];
		my $linkedProgram = $input[$i];
		if(! exists $links{$program}){
			$links{$program} = Set::Scalar->new;
		}
		if(! exists $links{$linkedProgram}){
			$links{$linkedProgram} = Set::Scalar->new;
		}
		$links{$program}->insert($linkedProgram);
		$links{$linkedProgram}->insert($program);
	}
}

my $set = Set::Scalar->new;
getConnectedElements(0,$set);
print "There are ", colored( $set->size, "black on_red" ), " elements in the set that contains process 0. ( ", sprintf ("%.3f",time - $time) ," s )\n";


my $time = time;
my $sets = 0;
while(keys %links > 0){
	$sets++;
	$set = Set::Scalar->new;
	getConnectedElements((keys %links)[0],$set);
	while (defined(my $e = $set->each)) {
		delete $links{$e};
	}
}

print "There are ", colored( $sets, "black on_red" ), " groups of processes. ( ", sprintf ("%.3f",time - $time) ," s )\n";





sub  getConnectedElements {
	my $element = shift;
	my $set = shift;
	$set->insert($element);
	while (defined(my $e = $links{$element}->each)) {
		if(! $set->has($e)){
			$set->insert($e);
			getConnectedElements($e,$set);
		}

 	}
	return $set;
}