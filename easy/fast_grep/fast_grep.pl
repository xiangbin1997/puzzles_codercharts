#!/usr/bin/perl
#Enter your code here
my $key = shift;
my $file = shift;

open(my $FD, "<", $file) or die "open error!";
my $line = 1;
my $result = 0;

while(<$FD>)
{
    chomp;
    if ( $key eq $_  )
    {
        $result = "$line";
        last;
    }

    $line += 1;
}

print "$result\n";

