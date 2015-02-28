# NAME

Test::PackageName - check whether filename matches package name

# SYNOPSIS

    use Test::PackageName;
    all_package_name_ok;

# DESCRIPTION

Test::PackageName checks whether filename matches package name.
For example, a file `lib/Foo/Bar.pm` must contains package `Foo::Bar`.

Yes, you can use [Perl::Critic::Policy::Modules::RequireFilenameMatchesPackage](https://metacpan.org/pod/Perl::Critic::Policy::Modules::RequireFilenameMatchesPackage),
but the output is hard to understand for me.

I recommend you to add the following alias to your `.bashrc` or `.zshrc`:

    alias test_package_name='perl -MTest::PackageName -e all_package_name_ok'

and type `test_package_name` anytime.

# LICENSE

Copyright (C) Shoichi Kaji.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

Shoichi Kaji <skaji@cpan.org>
