use strict;
use Term::ANSIColor;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my @list = (0..255);
my $skip = 0;
my $current = 0;
my $input = <$fh>;
my @input = split ",", $input;


for my $length (@input){
	my @toReverse;
	for (my $i = 0; $i < $length; $i++) {
		push @toReverse, $list[($i+$current)% scalar @list];
	}

	@toReverse = reverse @toReverse;

	for (my $i = 0; $i < $length; $i++) {
		$list[($i+$current)% scalar @list]=$toReverse[$i];
	}
	$current+=$length+$skip;
	$current % scalar @list;
	$skip++;
}

print "The product of the first two numbers is ", colored( $list[0]*$list[1], "bright_red" ), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";

# $time = time;
# @input=();
# push @input, ord($_) foreach (split "", $input);
# push @input, (17,31,73,47,23);

# my @list = (0..255);
# my $skip = 0;
# my $current = 0;

# for (my $round = 0; $round < 64; $round++) {
# 	for my $length (@input){
# 		my @toReverse;
# 		for (my $i = 0; $i < $length; $i++) {
# 			push @toReverse, $list[($i+$current)% scalar @list];
# 		}

# 		@toReverse = reverse @toReverse;

# 		for (my $i = 0; $i < $length; $i++) {
# 			$list[($i+$current)% scalar @list]=$toReverse[$i];
# 		}
# 		$current+=$length+$skip;
# 		$current % scalar @list;
# 		$skip++;
# 	}
# }
# print join(",",@input);