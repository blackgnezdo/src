#! perl

use strict;
use warnings;

use Test::More 0.89;

local $SIG{__WARN__} = sub { fail("Got unexpected warning"); diag($_[0]) };

if ($] >= 5.010000) {
	is (eval <<'END', 1, 'state compiles') or diag $@;
	use experimental 'state';
	state $foo = 1;
	is($foo, 1, '$foo is 1');
	1;
END
}

if ($] >= 5.010001) {
	if (eval '
		no warnings "experimental";
		use feature "switch";
		if(0) { when(3) {} }
		1;
	') {
		is (eval <<'END', 1, 'switch compiles') or diag $@;
		use experimental 'switch';
		sub bar { 1 };
		given(1) {
			when (\&bar) {
				pass("bar matches 1");
			}
			default {
				fail("bar matches 1");
			}
		}
		1;
END
	} else {
		is (eval <<'END', 1, 'switch compiles') or diag $@;
		use experimental 'switch';
		sub bar { 1 };
		given(1) {
			whereso (\&bar) {
				pass("bar matches 1");
			}
			fail("bar matches 1");
		}
		1;
END
	}
}

if ($] >= 5.010001) {
	is (eval <<'END', 1, 'smartmatch compiles') or diag $@;
	use experimental 'smartmatch';
	{ package Baz; use overload "~~" => sub { 1 }; }
	is(1 ~~ bless({}, "Baz"), 1, "is 1");
	1;
END
}

if ($] >= 5.018) {
	is (eval <<'END', 1, 'lexical subs compiles') or diag $@;
	use experimental 'lexical_subs';
	my sub foo { 1 };
	is(foo(), 1, "foo is 1");
	1;
END
}

if ($] >= 5.026000) {
	is (eval <<'END', 1, 'declared refs compiles') or diag $@;
	use experimental 'declared_refs';
	my @b;
	my \@a = \@b;
	is(\@a, \@b, '@a and @b are the same after \@a=\@b');
	1;
END
}
elsif ($] >= 5.021005) {
	is (eval <<'END', 1, 'ref aliasing compiles') or diag $@;
	use experimental 'refaliasing';
	my (@a, @b);
	\@a = \@b;
	is(\@a, \@b, '@a and @b are the same after \@a=\@b');
	1;
END
}

done_testing;

