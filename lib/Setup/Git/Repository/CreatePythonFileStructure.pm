package Setup::Git::Repository::CreatePythonFileStructure;

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

has desc => (
    is => 'ro',
    required => 1,
);

sub create_file_structure {
    
    my $self = shift;

    $self->create_main();

    $self->create_scripts() if ($self->script);
    
    $self->create_sub_structure();

    $self->create_docs();
    
    $self->create_gitignore();
    
    $self->create_setup();

}

sub create_main {
    
    my $self = shift;

    mkdir $self->name or die($!);

}

sub create_scripts {
    
    my $self = shift;

    mkdir $self->name . '/scripts' or die($!); 
    
    $self->create_script();

}

sub create_script {
    
    my $self = shift;

    my $oh = IO::File->new($self->name . '/scripts/' . $self->script, '>') or die($!);
    
    print{$oh} "#!/usr/bin/python\n\n";
    print{$oh} 'import ' . $self->name . "\n\n";

}

sub create_sub_structure {
    
    my $self = shift;

    mkdir $self->name . '/' . $self->name or die($!);
    
    mkdir $self->name . '/' . $self->name . '/tests' or die($!);   
    
    $self->create_init(path => $self->name . '/' . $self->name);

    $self->create_init(path => $self->name . '/' . $self->name . '/tests');

}

sub create_init {
    
    my ($self, %args) = @_;

    my $path = $args{path};
    my $name = $args{name};

    my $oh = IO::File->new("$path/__init__.py", '>') or die($!);   
    
}

sub create_docs {
    
    my $self = shift;

    mkdir $self->name . '/docs' or die($!); 

}

sub create_gitignore {

    my $self = shift;

    my $oh = IO::File->new($self->name . '/.gitignore', '>') or die($!);
    
    print{$oh} "# Byte-compiled / optimized / DLL files\n";
    print{$oh} "__pycache__/\n";
    print{$oh} "*.py[cod]\n";
    print{$oh} "*\$py.class\n";
    print{$oh} "\n";
    print{$oh} "# C extensions\n";
    print{$oh} "*.so\n";
    print{$oh} "\n";
    print{$oh} "# Distribution / packaging\n";
    print{$oh} ".Python\n";
    print{$oh} "build/\n";
    print{$oh} "develop-eggs/\n";
    print{$oh} "dist/\n";
    print{$oh} "downloads/\n";
    print{$oh} "eggs/\n";
    print{$oh} ".eggs/\n";
    print{$oh} "lib/\n";
    print{$oh} "lib64/\n";
    print{$oh} "parts/\n";
    print{$oh} "sdist/\n";
    print{$oh} "var/\n";
    print{$oh} "wheels/\n";
    print{$oh} "*.egg-info/\n";
    print{$oh} ".installed.cfg\n";
    print{$oh} "*.egg\n";
    print{$oh} "MANIFEST\n";
    print{$oh} "\n";
    print{$oh} "# PyInstaller\n";
    print{$oh} "#  Usually these files are written by a python script from a template\n";
    print{$oh} "#  before PyInstaller builds the exe, so as to inject date/other infos into it.\n";
    print{$oh} "*.manifest\n";
    print{$oh} "*.spec\n";
    print{$oh} "\n";
    print{$oh} "# Installer logs\n";
    print{$oh} "pip-log.txt\n";
    print{$oh} "pip-delete-this-directory.txt\n";
    print{$oh} "\n";
    print{$oh} "# Unit test / coverage reports\n";
    print{$oh} "htmlcov/\n";
    print{$oh} ".tox/\n";
    print{$oh} ".coverage\n";
    print{$oh} ".coverage.*\n";
    print{$oh} ".cache\n";
    print{$oh} "nosetests.xml\n";
    print{$oh} "coverage.xml\n";
    print{$oh} "*.cover\n";
    print{$oh} ".hypothesis/\n";
    print{$oh} ".pytest_cache/\n";
    print{$oh} "\n";
    print{$oh} "# Translations\n";
    print{$oh} "*.mo\n";
    print{$oh} "*.pot\n";
    print{$oh} "\n";
    print{$oh} "# Django stuff:\n";
    print{$oh} "*.log\n";
    print{$oh} ".static_storage/\n";
    print{$oh} ".media/\n";
    print{$oh} "local_settings.py\n";
    print{$oh} "\n";
    print{$oh} "# Flask stuff:\n";
    print{$oh} "instance/\n";
    print{$oh} ".webassets-cache\n";
    print{$oh} "\n";
    print{$oh} "# Scrapy stuff:\n";
    print{$oh} ".scrapy\n";
    print{$oh} "\n";
    print{$oh} "# Sphinx documentation\n";
    print{$oh} "docs/_build/\n";
    print{$oh} "\n";
    print{$oh} "# PyBuilder\n";
    print{$oh} "target/\n";
    print{$oh} "\n";
    print{$oh} "# Jupyter Notebook\n";
    print{$oh} ".ipynb_checkpoints\n";
    print{$oh} "\n";
    print{$oh} "# pyenv\n";
    print{$oh} ".python-version\n";
    print{$oh} "\n";
    print{$oh} "# celery beat schedule file\n";
    print{$oh} "celerybeat-schedule\n";
    print{$oh} "\n";
    print{$oh} "# SageMath parsed files\n";
    print{$oh} "*.sage.py\n";
    print{$oh} "\n";
    print{$oh} "# Environments\n";
    print{$oh} ".env\n";
    print{$oh} ".venv\n";
    print{$oh} "env/\n";
    print{$oh} "venv/\n";
    print{$oh} "ENV/\n";
    print{$oh} "env.bak/\n";
    print{$oh} "venv.bak/\n";
    print{$oh} "\n";
    print{$oh} "# Spyder project settings\n";
    print{$oh} ".spyderproject\n";
    print{$oh} ".spyproject\n";
    print{$oh} "\n";
    print{$oh} "# Rope project settings\n";
    print{$oh} ".ropeproject\n";
    print{$oh} "\n";
    print{$oh} "# mkdocs documentation\n";
    print{$oh} "/site\n";
    print{$oh} "\n";
    print{$oh} "# mypy\n";
    print{$oh} ".mypy_cache/\n";    

}

sub create_setup {
    
    my $self = shift;
    
    my $oh = IO::File->new($self->name . '/setup.py', '>') or die($!);
        
    my $name = $self->get_username();

    print{$oh} "#!/usr/bin/python\n\n";
    print{$oh} "from distutils.core import setup\n\n";
    print{$oh} "setup(name='" . $self->name . "',\n";
    print{$oh} "      version='1.0',\n";
    print{$oh} "      description='" . $self->desc . "',\n";
    print{$oh} "      author='" . $name . "',\n";
    print{$oh} "      author_email='" . $self->get_email() . "',\n";
    print{$oh} "      url='https://github.com/$name/" . $self->name . "',\n";
    print{$oh} "      packages=[],\n";
    print{$oh} "     )\n";    
   
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
1;
