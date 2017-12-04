use Term::ANSIColor;

my $filename = "${0}_input";
open(my $fh, $filename);

my $numberOfSafePassphrases = 0;
my $numberOfExtraSafePassphrases = 0;

while($input = <$fh>){
	if($input !~ /(\b\w+\b).*\1/){
		#print "($1) $input";
		$numberOfSafePassphrases++;
	}
	@input = split " ", $input;
	foreach my $x (@input) {
		$x = join "", sort(split "", $x);
	}
	$input = join " ", @input;
	if($input !~ /(\b\w+\b).*\1/){
		#print "($1) $input";
		$numberOfExtraSafePassphrases++;
	}
}

print "There are ", colored( $numberOfSafePassphrases, "bright_red" ), " safe passphrases.\n";
print "There are ", colored( $numberOfExtraSafePassphrases, "bright_red" ), " extra safe passphrases.\n";

# lookup in OEIS (https://oeis.org/A141481/b141481.txt) at entry 58
#print "First value larger than the input is " , colored(266330,"bright_red"), ".\n";
