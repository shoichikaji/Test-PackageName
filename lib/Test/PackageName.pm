package Test::PackageName;
use 5.008001;
use strict;
use warnings;
use Test::More;
use Test::Builder;
use Module::Metadata;
use File::Find ();

use Exporter 'import';
our @EXPORT = (@Test::More::EXPORT, 'all_package_name_ok');

our $VERSION = "0.01";

sub all_package_name_ok {
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my @files;
    my $wanted = sub {
        return unless -f $_ && $_ =~ /\.pm$/;
        push @files, $File::Find::name;
    };
    File::Find::find($wanted, "lib");

    for my $file (@files) {
        my $expected  = _filename_to_package_name($file);
        my $meta = Module::Metadata->new_from_file($file);
        if ($meta and my $name = $meta->name) {
            is $name, $expected, "Filename matches package name: $file";
        } else {
            my @candidate;
            if ($meta) {
                my @package = $meta->packages_inside;
                push @candidate, grep { $_ ne "main" } @package;
            }
            push @candidate, "none" unless @candidate;
            fail "Filename matches package name: $file";
            diag "         got: unknown (candidate: @{[join(', ', @candidate)]})";
            diag "    expected: '$expected'";
        }
    }
    done_testing;
}

sub _filename_to_package_name {
    my $file = shift;
    my $sep = qr{(?:/|\\)};
    $file =~ s/^lib$sep//; $file =~ s/\.pm$//;
    $file =~ s/$sep/::/g;
    $file;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::PackageName - check whether filename matches package name

=head1 SYNOPSIS

    use Test::PackageName;
    all_package_name_ok;

=head1 DESCRIPTION

Test::PackageName checks whether filename matches package name.
For example, a file C<lib/Foo/Bar.pm> must contains package C<Foo::Bar>.

Yes, you can use L<Perl::Critic::Policy::Modules::RequireFilenameMatchesPackage>,
but the output is hard to understand for me.

I recommend you to add the following alias to your C<.bashrc> or C<.zshrc>:

    alias test_package_name='perl -MTest::PackageName -e all_package_name_ok'

and type C<test_package_name> anytime.

=head1 LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Shoichi Kaji E<lt>skaji@cpan.orgE<gt>

=cut

