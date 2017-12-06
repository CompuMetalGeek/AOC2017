use strict;
use Term::ANSIColor;
use List::Util qw/max min/;
use Time::HiRes qw/time/;

my $time = time;
my $filename = "${0}_input";
open(my $fh, $filename);

my $sum = 0;
my $sum2 = 0;

while(<$fh>){
	my @list = split "\t";
	my $max = max @list;
	my $min = min @list;
	$sum += $max - $min;
	for (my $i = 0; $i < scalar @list; $i++) {
		for (my $j = 0; $j < $i; $j++) {
			next if ($i==$j);
			$sum2 += $list[$i] / $list[$j] if($list[$i] % $list[$j] == 0);
			$sum2 += $list[$j] / $list[$i] if($list[$j] % $list[$i] == 0);
		}
	}
}



print "The checksum is ", colored( $sum, "bright_red" ), ".\n";
print "The sum of each result is " , colored($sum2,"bright_red"), ". ( ", sprintf ("%.3f",time - $time) ," s )\n";
