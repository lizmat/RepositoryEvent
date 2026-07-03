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

Status of a test-suite (usually a set of Github Actions). Provides these methods:

### branch

The name of the branch that was being tested.

### commit

The SHA of the most recent commit that was being tested.

### conclusion

The conclusion of running the test-suite: one of:

  * success

  * failure

  * neutral

  * cancelled

  * timed_out

  * action_required

  * stale

### name

The name of the test-suite (usually "GitHub Actions").

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Commit
-----------------------

Representing a commit in the repository. Provides these methods:

### added

A `List` of filenames that were added in this commit.

### affected

A `List` of filenames that were affected by this commit (as in either added, modified or removed).

### author

The name of the author.

### branch

The name of the branch.

### committer

The name of the person who added this commit to the repository.

### message

The message of the commit (excluding the first line, which is considered to be the title).

### modified

A `List` of filenames that were modified by this commit.

### removed

A `List` of filenames that were removed by this commit.

### sha

The SHA of the commit.

### timestamp

A `DateTime` object indicating when the commit was added to the repository.

### title

The title of the commit (as in the first line of the messaged).

### url

The URL of the commit in the repository.

RepositoryEvent::Push
---------------------

Representing the push of one or more commits to a service. Provides these methods:

### branch

The name of the branch to which one or more commits were pushed.

### commits

A `List` of one or more `RepositoryEvent::Commit` objects, one for each commit that was part of the push to the repository.

### compare-url

The URL to see the changes that were made by this push to the repository.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::PullRequest
----------------------------

Representing actions related to a Pull Request. Provides these methods:

### action

The action that was performed on the Pull Request. One of these:

  * assigned

  * auto_merge_disabled

  * auto_merge_enabled

  * closed

  * converted_to_draft

  * demilestoned

  * dequequed

  * edited

  * enqueued

  * labeled

  * locked

  * milestoned

  * opened

  * ready_for_review

  * reopened

  * review_request_removed

  * review_requested

  * synchronize

  * unassigned

  * unlabeled

  * unlocked

### login

The login name of the person doing the action on the Pull Request.

### number

The number of the Pull Request.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### title

The title of the Pull Request.

### url

The URL of the Pull Request.

CREDITS
=======

This module has been inspired by some of the internals of [`Geth`](https://github.com/Raku/geth), developed by *Zoffix Znet*.

AUTHOR
======

Elizabeth Mattijsen <liz@raku.rocks>

COPYRIGHT AND LICENSE
=====================

Copyright 2026 Elizabeth Mattijsen

Source can be located at: https://codeberg.org/lizmat/RepositoryEvent . Comments and Pull Requests are welcome.

If you like this module, or what I'm doing more generally, committing to a [small sponsorship](https://github.com/sponsors/lizmat/) would mean a great deal to me!

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

