#!/usr/bin/perl
#Enter your code here
open($FD,"<",shift);
while(<$FD>){
 chomp;
 push @c,$_;}
@m = reverse(('a'..'z')x2);
shift@c;
while(@c){
 ($ks,$in) =splice @c,0,2;
 @ka=split //,$ks;
 @ina=split //,$in;
 push @ka,reverse@ka;
 $r="";
 foreach(@ina){
  if($_ eq ' '){
   $r .= $_;
   next;}
  $k = shift @ka;
  push @ka,$k;
  $i = ord('z') - ord( $_) + $k;
  $r .= $m[$i];}
 print "$r\n";}
