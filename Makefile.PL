
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME		=> 'Pipeworks',
	VERSION_FROM	=> 'lib/Pipeworks.pm',
	PREREQ_PM	=> {
		Mojolicious	=> 0,
	},
	ABSTRACT_FROM	=> 'lib/Pipeworks.pm',
	AUTHOR		=> 'Simon Bertrang <janus@cpan.org>',
);
