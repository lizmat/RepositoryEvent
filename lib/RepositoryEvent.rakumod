unit class RepositoryEvent;
has $.event;

my constant %can-be-simplified = <
  JSON::RepositoryEvent::Forgejo::EventCreate       create
  JSON::RepositoryEvent::Forgejo::EventDelete       delete
  JSON::RepositoryEvent::Forgejo::EventFork         fork
  JSON::RepositoryEvent::Forgejo::EventIssues       issues
  JSON::RepositoryEvent::Forgejo::EventPullRequest  pullrequest
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

#- RepositoryEvent::Commit -----------------------------------------------------
my class Commit {
    has $.sha;
    has $.branch;
    has $.timestamp;
    has $.url;
    has $.title;
    has $.message;
    has $.author;
    has $.committer;
    has $.added;
    has $.modified;
    has $.removed;

    method files() {
        (|$!added, |$!modified, |$!removed).sort.squish
    }
}

#- RepositoryEvent::Issues -----------------------------------------------------
class Issues {
    has $.action;
    has $.sender;
    has $.assignee;
    has $.url;
    has $.title;
#    method self-self { $!sender eq $!assignee }
}

#- RepositoryEvent::PullRequest ------------------------------------------------
class PullRequest {
    has $.number;
    has $.url;
    has $.title;
    has $.sender;
}

#- RepositoryEvent::Push -------------------------------------------------------
my class Push {
    has $.compare-url;
    has $.branch;
    has @.commits;
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

method !push($event, $forgejo) {
    my %args;

    my $repository := $event.repository;
    my $branch     := $event.ref.subst('refs/heads/');

    %args<compare-url> := $forgejo ?? $event.compare-url !! $event.compare;
    %args<branch>      := $branch;

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

# vim: expandtab shiftwidth=4
