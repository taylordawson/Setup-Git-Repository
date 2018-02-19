package Setup::Git::Repository::CreatePerlFileStructure;

use strict;
use Moo;
use IO::File;
use Data::Dumper;

has name => (
    is => 'ro',
    required => 1,
);

has script => (
    is => 'ro',
    required => 1,
);

has base_mod_name => (
    is => 'lazy',
);

has filename => (
    is => 'rw',
);

has desc => (
    is => 'ro',
    required => 1,
);

sub create_file_structure {
    
    my $self = shift;

    $self->create_main();

    $self->create_scripts() if ($self->script);

    $self->create_tests();
    
    $self->create_sub_structure();

}

sub create_main {
    
    my $self = shift;

    mkdir $self->name or die($!);

}

sub create_scripts {
        
    my $self = shift;

    mkdir $self->name . '/' . 'scripts' or die($!);
    
    $self->create_script();

}

sub create_tests {
    
    my $self = shift;

    mkdir $self->name . '/' . 't' or die($!);

}

sub create_sub_structure {

    my $self = shift;
    
    my $parts = $self->split_name();
    
    my $prev_parts = [];
   
    mkdir $self->name . '/lib' or die($!); 
    
    foreach my $part (@$parts) {
        
        my $previous = join('/', @$prev_parts);
        
        if ($previous) {
            
            mkdir $self->name . '/lib/' . $previous . '/' . $part or die($!);
            
        } else {
                
            mkdir $self->name . '/lib/' . $part or die($!);            

        }
        
        push $prev_parts, $part;

    }       
    
    $self->create_module(parts => $prev_parts);    
        
    $self->create_datasource();

    $self->create_makefile();
     
}

sub split_name {
    
    my $self = shift;

    my @parts = split(/\-/, $self->name);

    return \@parts;

}

sub create_module {
    
    my ($self, %args) = @_;
    
    my $prev_parts = $args{parts};
    
    my $filename = pop @$prev_parts;
    
    $filename = 'lib/' . join('/', @$prev_parts) . '/' . $filename . '.pm';
    
    $self->filename($filename);
 
    my $oh = IO::File->new($self->name . '/' . $filename, '>') or die($!);

    print{$oh} 'package ' . $self->base_mod_name . ";\n\n";
    print{$oh} "use strict;\nuse Moo;\nuse MooX::Options;\nuse " . $self->base_mod_name . "::DataSource;\n\n";
    print{$oh} "our \$VERSION = '1.0.1';\n\n";
    print{$oh} "sub run {\n\n    my \$self = shift;\n\n}\n\n1;\n\n";
    
    $self->create_perldoc(oh => $oh);
   
}

sub create_perldoc {
    
    my ($self, %args) = @_;

    my $oh  = $args{oh};
    
    my $name = `git config user.name`;
    my $email = `git config user.email`;
    
    chomp($name);
    chomp($email);
    print{$oh} "__END__\n\n";
    print{$oh} "=head1 NAME\n\n";
    print{$oh} '    ' . $self->base_mod_name . ' - ' . $self->desc . "\n\n";
    print{$oh} "=head1 SYNOPSIS\n\n";
    print{$oh} "=head1 DESCRIPTION\n\n";
    print{$oh} "=head1 BUGS\n\n";
    print{$oh} "=head1 LICENSE\n\n";
    print{$oh} "=head1 ACKNOWLEDGEMENTS\n\n";
    print{$oh} "=head1 AUTHOR\n\n";
    print{$oh} '    ' . $self->get_username() . ' - ' . $self->get_email()
. "\n\n";
    print{$oh} "=cut\n";

}

sub get_username {
    
    my $self = shift;

    my $name = `git config user.name`;
    
    chomp($name);

    return $name;

}

sub get_email {
    
    my $self = shift;

    my $email = `git config user.email`;
    
    chomp($email);

    return $email;      

}

sub create_makefile {
    
    my $self = shift;

    my $oh = IO::File->new($self->name . '/Makefile.PL', '>') or die($!);
   
    print{$oh} "use strict;\nuse warnings;\nuse ExtUtils::MakeMaker;\n\n";
    print{$oh} "WriteMakefile(\n    NAME => '" . $self->base_mod_name . "',\n";
    print{$oh} "    AUTHOR => '" . $self->get_username() . ' ' . $self->get_email() . "',\n";
    print{$oh} "    VERSION_FROM => '" . $self->filename . "',\n"; 
    print{$oh} "    ABSTRACT_FROM => '" . $self->filename . "',\n";
    print{$oh} "    PL_FILES => {},\n";

    if (-e $self->name . '/scripts') {
        
        print{$oh} "    EXE_FILES => ['scripts/" . $self->script . "'],\n";

    } else {

        print{$oh} "    EXE_FILES => [],\n";
    
    }
    
    print{$oh} "    PREREQ_PM => {\n        'version' => 0,\n        'Moo' => 0,\n        'MooX::Options' => 0,\n    },\n";
    print{$oh} "    PREREQ_FATAL => 1,\n";
    print{$oh} "    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },\n";
    print{$oh} "    clean => { FILES => '" . $self->name . "-*' },\n";
    print{$oh} ");\n";
}

sub create_script {
    
    my $self = shift;

    my $oh = IO::File->new($self->name . '/scripts/' . $self->script, '>') or
die($!);
    
    print{$oh} "#!/usr/bin/perl\n\nuse strict;\nuse " . $self->base_mod_name
. ";\n\n";
    
    print{$oh} $self->base_mod_name . "->new_with_options->run();\n";

}

sub create_datasource {
    
    my $self = shift;

    my @parts = split(/\-/, $self->name);

    my $oh = IO::File->new($self->name . '/lib/' . join('/', @parts) . '/'
. 'DataSource.pm', '>') or die($!);
    
    print{$oh} "package " . join('::', @parts) . '::DataSource;' . "\n\n";
    print{$oh} "use strict;\nuse Moo;\n\n";
    print{$oh} "1;\n";

}

sub _build_base_mod_name {
    
    my $self = shift;

    my $mod_name = $self->name;

    $mod_name =~ s/-/::/g;

    return $mod_name;

}

1;
