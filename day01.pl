my $filename = "day01_input";

my $fh;
open($fh, $filename);

my @input;

$input = <$fh>;
my $sum = 0;
my $sum2 = 0;
my $len = length $input;
for (my $i = 0; $i < $len; $i++) {
	my $current = substr($input, $i, 1);
	my $next  = substr($input, ($i+1) % ($len),1);
	my $halfway = substr($input,($i+$len/2)%($len),1);
	if($current==$next){
		$sum+=$current;
	}
	if($current==$halfway){
		$sum2+=$current;
	}
}
printf "sum of al chars that are equal to themselves is %d\n", $sum;
printf "sum of al chars that are equal to their halfway equal is %d", $sum2;


