use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;


my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my %size;
my %state;
my %scannerDirection;
my $maxPosition = 0;
while(my $input = <$fh>){
	chomp $input;
	my @input = split /: /,$input;
	$size{$input[0]} = $input[1];
	$state{$input[0]} = 0;
	$scannerDirection{$input[0]} = 1;
	if( $maxPosition < $input[0] ){
		$maxPosition = $input[0];
	}
}

my $position = 0;
my $severity = 0;

while($position<=$maxPosition){

	if(exists $state{$position}){
		if( $state{$position}==0){
			$severity+=$position*$size{$position};
		}
	}

	$position++;
	foreach my $key (keys %state) {
		if($scannerDirection{$key}==1){
			$state{$key}++;
		} else{
			$state{$key}--;
		}
		if($state{$key} == 0){
			$scannerDirection{$key} = 1;
		} elsif($state{$key} == $size{$key} - 1){
			$scannerDirection{$key} = -1;
		}
	}
}

print "The severity of starting at 0 ps is ", colored( $severity, "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

$time = time;

my $delay = -1;
my $severity = -1;
while( $severity != 0 ){
	$delay++;
	if($delay % 1000 == 0){
		printf "--- DELAY = %2d ---\n", $delay;
	}
	foreach my $key (keys %state) {
		$state{$key} = 0;
		$scannerDirection{$key}=1;
	}

	my $position = -$delay;
	$severity = 0;
	while($position<=$maxPosition){

		if(exists $state{$position}){
			if( $state{$position}==0){
				$severity = 1;
				last;
			}
		}

		$position++;
		foreach my $key (keys %state) {
			if($scannerDirection{$key}==1){
				$state{$key}++;
			} else{
				$state{$key}--;
			}
			if($state{$key} == 0){
				$scannerDirection{$key} = 1;
			} elsif($state{$key} == $size{$key} - 1){
				$scannerDirection{$key} = -1;
			}
		}
	}
}

print "You need to delay your start with ", colored( "$delay ps", "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
