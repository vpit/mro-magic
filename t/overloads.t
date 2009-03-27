use strict;
use warnings;
use Test::More 'no_plan';

BEGIN {
  package OLP; # overloads pass through

  use metamethod 
    passthru   => [ 'ISA' ],
    overload   => {
      '@{}'    => 'foo',
      fallback => 1,
    },
    metamethod => sub {
      my ($self, $method, $args) = @_;
      warn "called: " . join(q{, }, @_) . "\n";
      return [ $method, $args ];
    };
}

my $olp = bless {} => 'OLP';

my $control = $olp->new(1,2,3);
is_deeply(
  $control,
  [ new => [ 1, 2, 3 ] ],
  "our control call worked",
);

# my $str = "$olp";
# is($str, '(""', "we stringified to the stringification method name");
use Data::Dumper;
warn Dumper([ @{ $olp } ]);
