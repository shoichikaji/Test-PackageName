use strict;
use warnings;
use utf8;
use Test::More;
use Test::PackageName;
use File::Path 'mkpath';
use File::Basename 'dirname';
use File::pushd 'tempd';
sub do_fork (&) {
    my $cb = shift;
    my $pid = fork;
    die "failed to fork" unless defined $pid;
    if ($pid == 0) {
        $cb->();
        exit;
    }
    $pid;
}
sub write_pm {
    my ($file, $content) = @_;
    my $dir = dirname $file;
    mkpath $dir unless -d $dir;
    open my $fh, ">", $file or die "$file: $!";
    print {$fh} $content;
}

subtest ok => sub {
    my $pid = do_fork {
        my $guard = tempd;
        write_pm "lib/Foo/Bar.pm", "package Foo::Bar;\n1";
        write_pm "lib/Foo/Baz.pm", "package Foo::B;\npackage Foo::Baz;\n1";
        my $out = `$^X -Ilib -MTest::PackageName -e all_package_name_ok 2>&1`;
        exit $? >> 8;
    };
    waitpid $pid, 0;
    my $exit = $? >> 8;
    is $exit, 0;
};
subtest ng => sub {
    my $pid = do_fork {
        my $guard = tempd;
        write_pm "lib/Foo/Bar.pm", "package Foo::Ba;\n1";
        write_pm "lib/Foo/Baz.pm", "package Foo::B;\npackage Foo::Baz;\n1";
        my $out = `$^X -Ilib -MTest::PackageName -e all_package_name_ok 2>&1`;
        exit $? >> 8;
    };
    waitpid $pid, 0;
    my $exit = $? >> 8;
    isnt $exit, 0;
};

done_testing;
