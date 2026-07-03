unit class RepositoryEvent;
has $.event;

my constant %can-be-simplified = <
  JSON::RepositoryEvent::Forgejo::EventCreate       create
  JSON::RepositoryEvent::Forgejo::EventDelete       delete
  JSON::RepositoryEvent::Forgejo::EventFork         fork
  JSON::RepositoryEvent::Forgejo::EventIssues       issues
  JSON::RepositoryEvent::Forgejo::EventPullRequest  pull-request
  JSON::RepositoryEvent::Forgejo::EventPush         push

  JSON::RepositoryEvent::GitHub::EventCheckSuite    check-suite
  JSON::RepositoryEvent::GitHub::EventCommitComment commit-comment
  JSON::RepositoryEvent::GitHub::EventCreate        create
  JSON::RepositoryEvent::GitHub::EventDelete        delete
  JSON::RepositoryEvent::GitHub::EventFork          fork
  JSON::RepositoryEvent::GitHub::EventIssues        issues
  JSON::RepositoryEvent::GitHub::EventIssueComment  issue-comment
  JSON::RepositoryEvent::GitHub::EventLabel         label
  JSON::RepositoryEvent::GitHub::EventPullRequest   pull-request
  JSON::RepositoryEvent::GitHub::EventPush          push
>;

#- RepositoryEvent::Basics -----------------------------------------------------

my role Basics {  # UNCOVERABLE
    has $.repo-full-name;
    has $.repo-issues;
    has $.repo-name;
    has $.repo-stars;
}

#- RepositoryEvent::CheckSuite -------------------------------------------------
my class CheckSuite does Basics {
    has $.branch;
    has $.commit;
    has $.conclusion;
    has $.name;
}

#- RepositoryEvent::Commit -----------------------------------------------------
my class Commit {
    has $.added;
    has $.author;
    has $.branch;
    has $.committer;
    has $.message;
    has $.modified;
    has $.removed;
    has $.sha;
    has $.timestamp;
    has $.title;
    has $.url;

    method files() {
        (|$!added, |$!modified, |$!removed).sort.squish
    }
}

#- RepositoryEvent::Issues -----------------------------------------------------
class Issues does Basics {
    has $.action;
    has $.assignee;
    has $.number;
    has $.sender;
    has $.title;
    has $.url;
}

#- RepositoryEvent::PullRequest ------------------------------------------------
class PullRequest does Basics {
    has $.action;
    has $.login;
    has $.number;
    has $.title;
    has $.url;
}

#- RepositoryEvent::Push -------------------------------------------------------
my class Push does Basics {
    has $.branch;
    has @.commits;
    has $.compare-url;
}

#- RepositoryEvent -------------------------------------------------------------
method new($event) {
    my $name := $event.^name;
    if %can-be-simplified{$name} -> $method {
        self!"$method"(
          $event, $name.starts-with("JSON::RepositoryEvent::Forgejo::")
        );
    }
    else {
        "Instance of $name can not be simplified".Failure
    }
}

method !basics($event, $forgejo) {
    my $repository := $event.repository;

    my %args;

    %args<repo-name>      := $repository.name;
    %args<repo-full-name> := $repository.full-name;
    %args<repo-stars>     := $forgejo
                               ?? $repository.stars-count
                               !! $repository.stargazers-count;
    %args<repo-issues>    := $repository.open-issues-count;

    %args
}

method !push($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $repository := $event.repository;

    %args<branch> := my $branch := $event.ref.subst('refs/heads/');
    %args<compare-url> := $forgejo ?? $event.compare-url !! $event.compare;

    %args<commits> := eager $event.commits.map: -> $commit {
        my @lines  = $commit.message.lines;
        my $title := @lines.shift;

        my %args;
        %args<added>     := $commit.added;
        %args<author>    := $commit.author.name;
        %args<branch>    := $branch;
        %args<committer> := $commit.committer.name;
        %args<message>   := @lines.join("\n").trim;
        %args<modified>  := $commit.modified;
        %args<removed>   := $commit.removed;
        %args<sha>       := $commit.id;
        %args<title>     := $title;
        %args<timestamp> := $commit.timestamp;
        %args<url>       := $commit.url;

        Commit.new(|%args)
    }

    Push.new(|%args)
}

method !pull-request($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $pull-request := $event.pull-request;

    %args<action> := $event.action;
    %args<login>  := $pull-request.user.login;
    %args<number> := $pull-request.number;
    %args<title>  := $pull-request.title;
    %args<url>    := $pull-request.html-url;

    PullRequest.new(|%args)
}

method !issues($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $issue := $event.issue;

    %args<action>   := $event.action;
    %args<assignee> := $issue.assignee.login;
    %args<number>   := $issue.number;
    %args<sender>   := $event.sender.login;
    %args<title>    := $issue.title;
    %args<url>      := $issue.html-url;

    Issues.new(|%args)
}

method !check-suite($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $check-suite := $event.check-suite;

    %args<branch>     := $check-suite.head-branch;
    %args<commit>     := $check-suite.head-sha;
    %args<conclusion> := $check-suite.conclusion;
    %args<name>       := $check-suite.app.name;

    CheckSuite.new(|%args)
}

# vim: expandtab shiftwidth=4
