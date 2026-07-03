[![Actions Status](https://github.com/lizmat/RepositoryEvent/actions/workflows/linux.yml/badge.svg)](https://github.com/lizmat/RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/RepositoryEvent/actions/workflows/macos.yml/badge.svg)](https://github.com/lizmat/RepositoryEvent/actions) [![Actions Status](https://github.com/lizmat/RepositoryEvent/actions/workflows/windows.yml/badge.svg)](https://github.com/lizmat/RepositoryEvent/actions)

NAME
====

RepositoryEvent - simplified interface for repository events

SYNOPSIS
========

```raku
use RepositoryEvent;

my $raw = JSON::RepositoryEvent.new(...);
my $event = RepositoryEvent($raw.payload);
```

DESCRIPTION
===========

The `RepositoryEvent` distribution provides a simplified interface to the objects created by the [`JSON::RepositoryEvent`](https://raku.land/zef:lizmat/JSON::RepositoryEvent) class, attempting to unify the information provided by different services (currently `GitHub` and `Forgejo` (Codeberg) support is provided.

SUBCLASSES
==========

RepositoryEvent::CheckSuite
---------------------------

### branch

### commit

### commit-url

### conclusion

### name

### repo-name

### repo-full-name

### repo-stars

### repo-issues

RepositoryEvent::Commit
-----------------------

Representing a commit in the repository.

### added

### author

### branch

### committer

### message

### modified

### removed

### sha

### timestamp

### title

### url

RepositoryEvent::Push
---------------------

Representing the push of one or more commits to a service.

### branch

### commits

### compare-url

### repo-name

### repo-full-name

### repo-stars

### repo-issues

RepositoryEvent::PullRequest
----------------------------

Representing actions related to a Pull Request.

### action;

### login;

### number;

### repo-name

### repo-full-name

### repo-stars

### repo-issues

### title;

### url;

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2026 Elizabeth Mattijsen

Source can be located at: https://codeberg.org/lizmat/RepositoryEvent . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

