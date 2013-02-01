#!/usr/bin/perl
#Enter your code here
sub a{($x,$y)=@_;
if($h{$x}) {push @{$h{$x}},$y}else{$h{$x}=[$y]}}
open($F,"<",shift);
while(<$F>){chomp;push @c,$_}
($n,$p)=split / /,$c[0];
map{
@e=split;
map{a($e[$_],$e[1-$_])}(0..1)}@c[1..$p];
map{
 $m=$c[$p+1+$_];
 $el=$h{$m};
 @fs=();
 map{
  @f = grep {!($_ ~~ @fs)and($_ ne $m)and!($_ ~~ @$el)
 } @{$h{$_}};
 push @fs,@f;
}@$el;
print @fs."\n";
}(1..$c[$p+1]);
