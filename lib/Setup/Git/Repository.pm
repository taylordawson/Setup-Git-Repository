package Setup::Git::Repository;

use strict;
use Moo;
use MooX::Options;
use Setup::Git::Repository::CreatePerlFileStructure;
use Setup::Git::Repository::CreatePythonFileStructure;

our $VERSION = '1.0.1';

option name => (
    is => 'ro',
    required => 1,
    format => 's',
    short => 'n',
    doc => 'name of the repository seperated by dashes (Ex. New-Repository)',
);

option extension => (
    is => 'ro',
    required => 1,
    format => 's',
    short => 'e',
    isa => sub { die "$_[0] must be pl or py!" unless ( ($_[0] eq 'py') ||
($_[0] eq 'pl') ); },
    doc => 'File extension: Perl => pl, python => py'
);

option script => (
    is => 'ro',
    format => 's',
    short => 's',
    doc => 'Optional: specify script name, if specified the scripts dir will be
created',
);

option desc => (
    is => 'ro',
    format => 's',
    required => 1,
    short => 'd',
    doc => 'Basic program description to be included in documentation'
);

sub run {
    
    my $self = shift;
        
    $self->perl_format_check();

    my $make = ($self->extension eq 'pl')
        ? Setup::Git::Repository::CreatePerlFileStructure->new(
            name   => $self->name,
            script => $self->script,
            desc   => $self->desc,
        )
        : Setup::Git::Repository::CreatePythonFileStructure->new(
            name   => $self->name,
            script => $self->script,
            desc   => $self->desc,
        );

    $make->create_file_structure();
    
    $self->setup_git_repository();

    print $self->get_language_name() . ' git repository (' . $self->name . ') was created.' . "\n";

}

sub perl_format_check {

    my $self = shift;

    if (($self->extension eq 'pl') && ($self->name !~ /-/)) {
            
        print "Name must contain dashes!\n";
        exit(0);    
    
    }
    
}

sub setup_git_repository {
    
    my $self = shift;

    chdir $self->name or die($!);

    `git init`;

    `git add .`;
    
    `git commit -m "Initial Commit"`;

    `git branch dev`;

    `git branch qa`;  

    `git checkout dev`;

    `git checkout qa`;

    `git merge dev`;

    `git checkout master`;
    
    `git merge qa`;

    `git checkout dev`;
    
    my $url = $self->create_url();

    `git remote add origin $url`;
    
}

sub create_url {
    
    my $self = shift;
    
    my $name = `git config user.name`;
        
    chomp($name);

    return "https://github.com/$name/" . $self->name . '.git';

}

sub get_language_name {

    my $self = shift;

    return 'Perl' if ($self->extension eq 'pl');

    return 'Python' if ($self->extension eq 'py');

}

1;

__END__
=head1 NAME 
    
    Setup::Git::Repository - Creates inital file structure for git repository 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 LICENSE

=head1 ACKNOWLEDGEMENTS

=head1 AUTHOR
    
    Taylor Dawson - dawsoncapital1@gmail.com

=cut
