use Test;
BEGIN { plan tests => 17 };
use AI::Fuzzy;
ok(1); # If we made it this far, we're ok.

$f = new AI::Fuzzy::Label;
ok(2); # If we made it this far, we're ok.

$s = new AI::Fuzzy::Set;
ok(3); # If we made it this far, we're ok.

$f->addlabel("baby",        -1,   1, 2.5);
$f->addlabel("toddler",      1, 1.5, 3.5);
$f->addlabel("little kid",   2,   7,  12);
$f->addlabel("kid",          6,  10,  14);
$f->addlabel("teenager",    12,  16,  20);
$f->addlabel("young adult", 18,  27,  35);
$f->addlabel("adult",       25,  50,  75);
$f->addlabel("senior",      60,  80, 110);
$f->addlabel("relic",      100, 150, 200);


ok($f->label(50), "adult");
ok($f->label(5),  "little kid");


$fs_tall_people = new AI::Fuzzy::Set( Lester=>34, Bob=>100, Max=>86 );
   
# $x will be 86
$x = $fs_tall_people->membership( "Max" );
ok($x, 86);

# get list of members, sorted from least membership to greatest:
@shortest_first =  $fs_tall_people->members();
ok @shortest_first, 3, "got " . join(',', @shortest_first) . ", wanted " . join(',', qw(Lester Max Bob));


$fl = new AI::Fuzzy::Label;

$fl->addlabel( "cold", 32, 60, 70 );
$fl->addlabel( "warm", 60, 70, 90 );
$fl->addlabel( "hot", 77, 80, 100 );
    # what I consider hot. :) (in Farenheit, of course!)
ok $fl;

$a = $fl->applicability(99,"hot");
    # $a is now the degree to which $label applies to $value
ok $a;

$l = $fl->label (99);
    # applies a label to $value
ok ($l, "hot");

@l = $fl->label(65);
%l = $fl->label(65);
    # returns a list of labels and their applicability values
ok @l, 4, "got " . join (',',@l) . " wanted " . join(',',qw(cold 0.5 warm 0.5));
ok ($l{cold}, .5);
ok ($l{warm}, .5);



$ns = new AI::Fuzzy::Set( Lester=>.34, Bob=>1.00, Max=>.86 );
$sa = new AI::Fuzzy::Set( Lester=>.34, Bob=>1.00, Max=>.86 );
$sb = new AI::Fuzzy::Set( Bob=>1.00, Max=>.86 );
$sc = new AI::Fuzzy::Set( Lester=>.35, Bob=>1.00, Max=>.86 );

ok ($sa->equal($ns),1);
ok ($sa->equal($sc),0);
ok ($sa->equal($sb),0);
ok ($sa->equal($sa),1);

$sd = $sa->union($sc);
ok ($sd->membership("Lester"), .35);

$sd = $sa->intersection($sb);
ok ($sd->membership("Lester"), 0);

$sd = $sd->complement();
ok ($sd->membership("Max"), .14);

# the complement of the complement should be the original
$se = $sa->complement() || print "problem with complement\n";
$se = $se->complement() || print "problem with complement\n";
ok ($se->equal($sa));

# a union b should equal b union a
$aUb = $sa->union($sb);
$bUa = $sb->union($sa);
ok($aUb->equal($bUa));

# a intersection b should equal b intersection a
$aNb = $sa->intersection($sb);
$bNa = $sb->intersection($sa);
ok($aNb->equal($bNa));


# a union b  union c should equal b union c union a
$abc = $sa->union($sb);
$abc = $abc->union($sc);

$bca = $sb->union($sc);
$bca = $bca->union($sa);

ok($abc->equal($bca));

# a intersection b  intersection c should equal b intersection c intersection a
$abc = $sa->intersection($sb);
$abc = $abc->intersection($sc);

$bca = $sb->intersection($sc);
$bca = $bca->intersection($sa);
ok($abc->equal($bca));



exit 0;
$a = new AI::Fuzzy::Set( x1 => .3, x2 => .5, x3 => .8, x4 => 0, x5 => 1);
$b = new AI::Fuzzy::Set( x5 => .3, x6 => .5, x7 => .8, x8 => 0, x9 => 1);
print "a is: " . $a->as_string . "\n"; 
print "b is: " . $b->as_string . "\n"; 

print "a is equal to b" if ($a->equal($b));

$c = $a->complement();
print "complement of a is: " . $c->as_string . "\n"; 

$c = $a->union($b);
print "a union b is: " . $c->as_string . "\n"; 

$c = $a->intersection($b);
print "a intersection b is: " . $c->as_string . "\n"; 

