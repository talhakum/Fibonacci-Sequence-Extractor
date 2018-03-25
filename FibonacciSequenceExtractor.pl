# Name: Orhan Talha
# Surname: Kum
# Number: 1306140131
# Scripting Languages Project 2
# Date: 28.12.2017

#!/usr/bin/perl
use strict;
use warnings;
use POSIX 'floor';

# Get golden ratio to use in the first method
my $GOLDEN_RATIO = 0.5 * (1.0 + sqrt(5));

# Subroutines

# I created my own logGoldenRatio subroutine to make simpler
sub logGoldenRatio {
	# Use shift to get first parameter
    my $n = shift(@_);
    return log($n)/log($GOLDEN_RATIO);
 }

# Subroutine to find if a number is perfect square
sub isPerfectSquare {
	# Use shift to get first parameter
	my $number=shift(@_);
	# int function is used to round floating point numbers
	my $s=int(sqrt($number+0.5));
	return ($s**2 == $number);
}

# Subroutine to find if a number is a fibonacci number
sub isFibonacciNumber {
	# Use shift to get first parameter
	my $number=shift(@_);
	# Find if the number is Fibonacci number
	return ($number==0) ? '' : ( isPerfectSquare(5*$number**2+4) || isPerfectSquare(5*$number**2-4) );
}

# Formula method
sub firstMethod {
	# Use shift to get first parameter
	my $n=shift @_;
	return ($n<=1) ? 1 : (($GOLDEN_RATIO)**($n) - (-$GOLDEN_RATIO)**(-$n)) * (1/sqrt(5));
}

# Recursive definition of the Fibonacci Sequence
sub secondMethod {
	# Use shift to get first parameter
	my $number=shift(@_);
	# Use recursive definition of the Fibonacci sequence
	return ($number<=1) ? 1 : (secondMethod($number-1)+secondMethod($number-2));
}

sub getOrder {
	# Use shift to get first parameter
	my $fn=shift @_;
	return floor(logGoldenRatio($fn*sqrt(5)+0.5));
}

# Get reference of file
my $file;

# Check if whether user gives an argument
if(@ARGV ne 1) {
	# Ask user to give a filename
	print "Please give the filename to find fibonacci sequences: \n";
	$file=<STDIN>;
	chomp($file);
}
else {
	# Assign argument to file variable if user gives an anguremnt
	$file=$ARGV[0];
}

# Warn user and exist if no filename entered
unless($file) {
	die "You must enter a filename!\n";
}

unless(open(FILE , "<" .$file)) {
	die "Can't open given file!\n";
}
my @ata=<FILE>;

# Get length of file
my $length=length($ata[0]);
# Set file content to $var
my $var=$ata[0];

# Get reference of iterators, cursor, order, counter and array.
my @fibonacciSequences;
my $order;
my $i=0,$b=1;
my $cursor=0;
my $c=6;
my $counter=0;

# First loop to iterate all over number
for($i=0;$i<$length; $i++) {
	# Set c = length-i when remains less than 6 to end of file
	if(($length-$i)<6) {
			$c=$length-$i;
		}
	# Second loop to find first number of Fibonacci Sequence
	for($b=1; $b<=$c; $b++) {

		# Check if number is a fibonacci number by using substr
		if(isFibonacciNumber(substr($var,$i,$b)) ) {
			# Set counter 1
			$counter=1;	
			# Set cursor $i+$b to iterate sequence number
			$cursor=$i+$b;
			# Get position (index) of fibonacci number
			# It is used in firstMethod and secondMethod
			$order=getOrder(substr($var,$i,$b));
			# Push the first fibonacci number to array
			push @fibonacciSequences,substr($var,$i,$b);

			# Loop to find all sequences after first fibonacci number is found
			while(1) {
				
			# Find fibonacci sequences by using FIRST and SECOND method
			# and compare if the two methods equal to each other
			if($cursor<$length && substr($var,$cursor,length(secondMethod($order))) eq secondMethod($order)
				&& substr($var,$cursor,length(firstMethod($order+1))) eq firstMethod($order+1)) {
				# Add counter 1 when sequence continues 
				$counter++;
				# Push fibonacciSequences array to new fibonaccio number 
				# It is no matter using firstMethod or SecondMethod (they are equal to each other)
				push @fibonacciSequences,substr($var,$cursor,length(secondMethod($order)));
				# Update order 
				$order=getOrder(substr($var,$cursor,length(secondMethod($order))));
				# Add cursor length of new fibonacci number to next
				# It is no matter using firstMethod or SecondMethod (they are equal to each other)
				$cursor+=length(firstMethod($order));

			}
				else {
					# Print fibonacci sequences that greater and equals than 3
					if($counter>=3) {
						print "@fibonacciSequences\n";
						# Set the cursor  fibonacci sequences suffix
						$i=$cursor-1;
						# Set b to c+1 to break inside for loop
						$b=$c+1;
					}
					# empty out array
					@fibonacciSequences=();
					# break loop when it is not fibonacci series
					# and reset counter
					$counter=1;
					last;
				}
			}

		}
	}
}

close FILE;


