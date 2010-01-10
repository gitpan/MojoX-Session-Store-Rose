use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'MojoX::Session::Store::Rose',
    AUTHOR              => q{Sascha Kiefer <perl@intertivity.com>},
    VERSION_FROM        => 'lib/MojoX/Session/Store/Rose.pm',
    ABSTRACT_FROM       => 'lib/MojoX/Session/Store/Rose.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
		'MojoX::Session' => 0.15,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'MojoX-Session-Store-Rose-*' },
);
