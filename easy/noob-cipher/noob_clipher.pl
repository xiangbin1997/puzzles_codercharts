#!/usr/bin/perl
#Enter your code here
my $table = shift;
my $file =shift;

open(my $FD, "<", $file) or die "open error!";
my @in = ();
while(<$FD>)
{
    chomp;
    @in = split //,$_;
}
