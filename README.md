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

The `RepositoryEvent` distribution provides a simplified interface to the objects created by the [`JSON::RepositoryEvent`](https://raku.land/zef:lizmat/JSON::RepositoryEvent) class, attempting to unify the information provided by different services (currently `GitHub` and `Forgejo` (Codeberg) support is provided).

SUBCLASSES
==========

RepositoryEvent::Asset
----------------------

An asset as found in a `RepositoryEvent::Release` object.

### id

The ID of the asset.

### label

The label of the asset.

### name

The name of the asset.

### state

The state of the asset, one of:

  * uploaded

### url

The URL with the information about this asset.

### updated-at

A `DateTime` object indicating when the asset was updated.

RepositoryEvent::CheckRun
-------------------------

### action

The action that was performed, one of:

  * completed

  * created

  * requested_action

  * rerequested

### completed-at

A `DateTime` object indicating when the run was completed.

### conclusion

The conclusion of this run.

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

### sha

The SHA of the most recent commit that was being tested.

### started-at

A `DateTime` object indicating when the run was started.

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

Representing a commit in the repository. Only seen as one of the commits in a `RepositoryEvent::Push` event. Provides these methods:

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

### title

The title of the commit (as in the first line of the messaged).

### updated-at

A `DateTime` object indicating when the commit was updated.

### url

The URL of the commit in the repository.

RepositoryEvent::Comment
------------------------

### body

The body of the comment.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### type

The type of comment, one of:

  * commit

  * pull-request-review

### url

The URL of the comment.

RepositoryEvent::Create
-----------------------

Something was created in the repository.

### name

The name of the object being created.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### type

The type of object being created. One of:

  * branch

  * tag

RepositoryEvent::Delete
-----------------------

Something was removed from the repository.

### name

The name of the object being removed.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### type

The type of object being removed. One of:

  * branch

  * tag

RepositoryEvent::Fork
---------------------

A repository has been forked.

### forkee-name

The (short) name of the fork of the repository, excludes login name of the owner of the fork.

### forkee-full-name

The (long) name of the fork of the repository, includes login name of the owner of the fork.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::IssueComment
-----------------------------

An action has been performed on a comment on an issue.

### action

The action performed on the issue comment. One of:

  * created

  * deleted

  * edited

  * pinned

  * unpinned

### actor

The name of the person performing the action on the issue comment.

### title

The title of this issue comment.

### url

The URL of this issue comment.

RepositoryEvent::Issues
-----------------------

An activity related to an issue has occurred.

### action

The action performed on the issue. One of:

  * assigned

  * closed

  * deleted

  * demilestoned

  * edited

  * field_added

  * field_removed

  * labeled

  * locked

  * milestoned

  * opened

  * pinned

  * reopened

  * transferred

  * typed

  * unassigned

  * unlabeled

  * unlocked

  * unpinned

  * untyped

### actor

The person performing the action on the issue.

### number

The issue number.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### assignee

The name of the person the issue was assigned to (if applicable).

### number

The issue number.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### title

The title of this issue.

### url

The URL of this issue.

RepositoryEvent::Label
----------------------

An action was performed on a label.

### action

The action that was performed on a label. One of:

  * created

  * deleted

  * edited

### name

The name of the label.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Page
---------------------

An action was done on a page in a `RepositoryEvent::Wiki` object.

### action

The action performed. One of:

  * created

  * edited

### name

The name of the wiki page.

### title

The title of the wiki page.

### url

The URL of the wiki page.

RepositoryEvent::Ping
---------------------

A repository was created.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

RepositoryEvent::Public
-----------------------

A repository was made public.

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

RepositoryEvent::PullRequestReview
----------------------------------

Representing actions related to a review of a Pull Request. Provides these methods:

### action

The action that was performed on the review of the Pull Request. One of these:

  * dismissed

  * edited

  * submitted

### login

The login name of the person doing the action on the review of the Pull Request.

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

RepositoryEvent::PullRequestReviewThread
----------------------------------------

Representing actions related to a review thread of a Pull Request. Provides these methods:

### action

The action that was performed on the review thread of the Pull Request. One of these:

  * resolved

  * unresolved

### login

The login name of the person doing the action on the review thread of the Pull Request.

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

RepositoryEvent::Push
---------------------

Representing the push of one or more commits to a service. Provides these methods:

### actor

The name of the person performing the push.

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

RepositoryEvent::Release
------------------------

An action was performed on a release.

### action

The action that was performed. One of:

  * created

  * deleted

  * edited

  * prereleased

  * published

  * released

  * unpublished

### assets

A `List` of `RepositoryAsset` objects of this release.

### actor

The name of the person performing the action on the release.

### author

The author of this release.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Repository
---------------------------

An action was performed on the whole of a repository.

### action

The action that was performed. One of:

  * archived

  * created

  * deleted

  * edited

  * privatized

  * publicized

  * renamed

  * transferred

  * unarchived

### actor

The name of the person performing the action.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Star
---------------------

An action was performed on a star in a repository.

### action

The action being performed. One of:

  * created

  * deleted

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Status
-----------------------

The status of a commit was changed.

### actor

The name of the person performing the action.

### author

The name of the author of the commit.

### committer

The name of the committer of the commit.

### message

The message of the commit.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### sha

The SHA of the commit.

### state

The state of the commit. One of:

  * error

  * failure

  * pending

  * success

### title

The title of the commit.

### updated-at

A `DateTime` object indicating when the status of the commit was updated.

### url

The URL of the commit.

RepositoryEvent::Watch
----------------------

Someone started watching the repository.

### actor

The name of the person who started watching the repository.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::Wiki
---------------------

An action was performed in the wiki.

### actor

The name of the person who performed the action in the repository.

### pages

A `List` of `RepositoryEvent::Page` objects representing the pages that were affected in the wiki.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

RepositoryEvent::WorkflowJob
----------------------------

A workflow job was completed.

### completed-at

A `DateTime` object representing when the workflow job was completed.

### conclusion

The conclusion of this workflow job. One of:

  * action_required

  * cancelled

  * failure

  * neutral

  * skipped

  * success

  * timed_out

### name

The name of this workflow job.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### sha

The SHA of this workflow job.

### url

The URL of this workflow job.

RepositoryEvent::WorkflowRun
----------------------------

A workflow run was completed.

### conclusion

The conclusion of this workflow job. One of:

  * action_required

  * cancelled

  * failure

  * neutral

  * skipped

  * stale

  * startup_failure

  * success

  * timed_out

### name

The name of this workflow run.

### repo-name

The (short) name of the repository, excludes login name of the owner.

### repo-full-name

The (long) name of the repository, includes login name of the owner.

### repo-stars

The number of stars the repository has gotten from users.

### repo-issues

The number of open issues in the repository.

### sha

The SHA of the commit that caused this workflow run.

### updated-at

A `DateTime` object representing when the workflow run was updated.

### url

The URL of this workflow job.

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

