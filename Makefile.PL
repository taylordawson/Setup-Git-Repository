use strict;                                                                                 use warnings;
use ExtUtils::MakeMaker;
 
WriteMakefile(
    NAME            => 'Setup::Git::Repository',
    AUTHOR          => 'taylordawson dawsoncapital1@gmail.com',
    VERSION_FROM    => 'lib/Setup/Git/Repository.pm',
    ABSTRACT_FROM   => 'lib/Setup/Git/Repository.pm',
    PL_FILES        => {},
    EXE_FILES       => ['scripts/setup_git_repository'],
    PREREQ_PM       => {
        'version'        => 0,
        'Moo'            => 0,
        'MooX::Options'  => 0,
        'IO::File'       => 0,
    },
    PREREQ_FATAL => 1,
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Setup-Git-Repository-*' },
);
