unit class RepositoryEvent;
has $.event;

my constant %can-be-simplified = <
  Forgejo::EventCreate       create
  Forgejo::EventDelete       delete
  Forgejo::EventFork         fork
  Forgejo::EventIssues       issues
  Forgejo::EventIssueComment issue-comment
  Forgejo::EventPullRequest  pull-request
  Forgejo::EventPush         push

  GitHub::EventCheckRun                 check-run
  GitHub::EventCheckSuite               check-suite
  GitHub::EventCommitComment            commit-comment
  GitHub::EventCreate                   create
  GitHub::EventDelete                   delete
  GitHub::EventFork                     fork
  GitHub::EventGollum                   wiki
  GitHub::EventIssueComment             issue-comment
  GitHub::EventIssues                   issues
  GitHub::EventLabel                    label
  GitHub::EventPing                     ping
  GitHub::EventPublic                   public
  GitHub::EventPullRequest              pull-request
  GitHub::EventPullRequestReview        pull-request-review
  GitHub::EventPullRequestReviewComment pull-request-review-comment
  GitHub::EventPullRequestReviewThread  pull-request-review-thread
  GitHub::EventPush                     push
  GitHub::EventRelease                  release
  GitHub::EventRepository               repository
  GitHub::EventStar                     star
  GitHub::EventStatus                   status
  GitHub::EventWatch                    watch
  GitHub::EventWorkflowJob              workflow-job
  GitHub::EventWorkflowRun              workflow-run
>.map: { .contains(/^ F | G/) ?? "JSON::RepositoryEvent::$_" !! $_ }  # UNCOVERABLE

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

#- RepositoryEvent::Asset ------------------------------------------------------
my class Asset {
    has $.id;
    has $.label;
    has $.name;
    has $.state;
    has $.url;
    has $.updated-at;
}

method !asset($event, $forgejo) {

    my %args;

    %args<id>         := $event.id;
    %args<label>      := $event.label;
    %args<name>       := $event.name;
    %args<state>      := $event.state;
    %args<url>        := $event.url;
    %args<updated-at> := $event.updated-at;

    Asset.new(|%args)
}

#- RepositoryEvent::Basics -----------------------------------------------------
my role Basics {  # UNCOVERABLE
    has $.repo-full-name;
    has $.repo-issues;
    has $.repo-name;
    has $.repo-stars;
}

method !basics($event, $forgejo, $repository = $event.repository) {
    my %args;

    %args<repo-issues>    := $repository.open-issues-count;
    %args<repo-full-name> := $repository.full-name;
    %args<repo-name>      := $repository.name;
    %args<repo-stars>     := $forgejo
                               ?? $repository.stars-count
                               !! $repository.stargazers-count;

    %args
}

#- RepositoryEvent::CheckRun ---------------------------------------------------
my class CheckRun does Basics {
    has $.action;
    has $.completed-at;
    has $.conclusion;
    has $.name;
    has $.sha;
    has $.started-at;
}

method !check-run($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $check-run := $event.check-run;

    %args<action>       := $event.action;
    %args<completed-at> := $check-run.completed-at;
    %args<conclusion>   := $check-run.check-suite.conclusion;
    %args<name>         := $check-run.app.name;
    %args<sha>          := $check-run.head-sha;
    %args<started-at>   := $check-run.started-at;

    CheckRun.new(|%args)
}

#- RepositoryEvent::CheckSuite -------------------------------------------------
my class CheckSuite does Basics {
    has $.branch;
    has $.commit;
    has $.conclusion;
    has $.created-at;
    has $.name;
    has $.updated-at;
}

method !check-suite($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $check-suite := $event.check-suite;

    %args<branch>     := $check-suite.head-branch;
    %args<commit>     := $check-suite.head-sha;
    %args<conclusion> := $check-suite.conclusion;
    %args<created-at> := $check-suite.created-at;
    %args<name>       := $check-suite.app.name;
    %args<updated-at> := $check-suite.updated-at;

    CheckSuite.new(|%args)
}

#- RepositoryEvent::Comment ----------------------------------------------------
my class Comment does Basics {
    has $.body;
    has $.type;
    has $.url;
}

method !comment($event, $forgejo, $type, $repository) {
    my %args := self!basics($event, $forgejo, $repository);

    my $comment := $event.comment;

    %args<type> := $type;  # UNCOVERABLE
    %args<url>  := $comment.html-url;
    %args<body> := $comment.body;

    Comment.new(|%args)
}

method !commit-comment($event, $forgejo) {
    self!comment($event, $forgejo, 'commit', $event.repository)
}

method !pull-request-review-comment($event, $forgejo) {
    self!comment($event, $forgejo, 'pull-request-review', $event.repository)
}

#- RepositoryEvent::Commit -----------------------------------------------------
my class Commit {
    has $.affected;
    has $.added;
    has $.author;
    has $.branch;
    has $.committer;
    has $.message;
    has $.modified;
    has $.removed;
    has $.sha;
    has $.title;
    has $.updated-at;
    has $.url;
}

method !commit($event, $forgejo) {
    my @lines  = $event.message.lines;
    my $title := @lines.shift;

    my @added    := $event.added;
    my @modified := $event.modified;
    my @removed  := $event.removed;

    my %args;
    %args<affected>   := eager (|@added, |@modified, |@removed).sort.squish;
    %args<added>      := @added;
    %args<author>     := $event.author.name;
    %args<branch>     := $*BRANCH // '';
    %args<committer>  := $event.committer.name;
    %args<message>    := @lines.join("\n").trim;
    %args<modified>   := @modified;
    %args<removed>    := @removed;
    %args<sha>        := $event.id;
    %args<title>      := $title;
    %args<updated-at> := $event.timestamp;
    %args<url>        := $event.url;

    Commit.new(|%args)
}

#- RepositoryEvent::Create -----------------------------------------------------
my class Create does Basics {
    has $.name;
    has $.type;
}

method !create($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<name> := $event.ref;
    %args<type> := $event.ref-type;

    Create.new(|%args)
}

#- RepositoryEvent::Delete -----------------------------------------------------
my class Delete does Basics {
    has $.name;
    has $.type;
}

method !delete($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<name> := $event.ref;
    %args<type> := $event.ref-type;

    Delete.new(|%args)
}

#- RepositoryEvent::Fork -------------------------------------------------------
my class Fork does Basics {
    has $.forkee-name;
    has $.forkee-full-name;
}

method !fork($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $forkee := $event.forkee;

    %args<forkee-name>      := $forkee.name;
    %args<forkee-full-name> := $forkee.full-name;

    Fork.new(|%args)
}

#- RepositoryEvent::IssueComment -----------------------------------------------
my class IssueComment does Basics {
    has $.actor;
    has $.action;
    has $.number;
    has $.title;
    has $.url;
}

method !issue-comment($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $issue := $event.issue;

    %args<actor>  := $event.sender.login;
    %args<action> := $event.action;
    %args<number> := $issue.number;
    %args<title>  := $issue.title;
    %args<url>    := $issue.html-url;

    IssueComment.new(|%args)
}

#- RepositoryEvent::Issues -----------------------------------------------------
my class Issues does Basics {
    has $.actor;
    has $.action;
    has $.assignee;
    has $.number;
    has $.title;
    has $.url;
}

method !issues($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $issue := $event.issue;

    %args<actor>    := $event.sender.login;
    %args<action>   := $event.action;
    %args<assignee> := $issue.assignee.login;
    %args<number>   := $issue.number;
    %args<title>    := $issue.title;
    %args<url>      := $issue.html-url;

    Issues.new(|%args)
}

#- RepositoryEvent::Label ------------------------------------------------------
my class Label does Basics {
    has $.action;
    has $.description;
    has $.name;
}

method !label($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $label := $event.label;

    %args<action>      := $event.action;
    %args<description> := $label.description;
    %args<name>        := $label.name;

    Label.new(|%args)
}

#- RepositoryEvent::Page -------------------------------------------------------
my class Page {
    has $.action;
    has $.name;
    has $.title;
    has $.url;
}

method !page($event, $forgejo) {

    my %args;
    %args<action> := $event.action;
    %args<name>   := $event.page-name;
    %args<title>  := $event.title;
    %args<url>    := $event.html-url;

    Page.new(|%args)
}

#- RepositoryEvent::Ping --- ---------------------------------------------------
my class Ping {
    has $.repo-full-name;
    has $.repo-name;
}

method !ping($event, $forgejo) {
    Ping.new(|self!basics($event, $forgejo))
}

#- RepositoryEvent::Public -----------------------------------------------------
my class Public does Basics { }

method !public($event, $forgejo) {
    Public.new(|self!basics($event, $forgejo))
}

#- RepositoryEvent::PullRequestInfo --------------------------------------------
my role PullRequestInfo does Basics {
    has $.action;
    has $.login;
    has $.number;
    has $.title;
    has $.url;
}

method !pull-request-args($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $pull-request := $event.pull-request;

    %args<action> := $event.action;
    %args<login>  := $pull-request.user.login;
    %args<number> := $pull-request.number;
    %args<title>  := $pull-request.title;
    %args<url>    := $pull-request.html-url;

    %args
}

#- RepositoryEvent::PullRequest ------------------------------------------------
my class PullRequest does PullRequestInfo { }

method !pull-request($event, $forgejo) {
    PullRequest.new(|self!pull-request-args($event, $forgejo))
}

#- RepositoryEvent::PullRequestReview ------------------------------------------
my class PullRequestReview does PullRequestInfo { }

method !pull-request-review($event, $forgejo) {
    PullRequestReview.new(|self!pull-request-args($event, $forgejo))
}

#- RepositoryEvent::PullRequestReviewThread ------------------------------------
my class PullRequestReviewThread does PullRequestInfo { }

method !pull-request-review-thread($event, $forgejo) {
    PullRequestReviewThread.new(|self!pull-request-args($event, $forgejo))
}

#- RepositoryEvent::Push -------------------------------------------------------
my class Push does Basics {
    has $.actor;
    has $.branch;
    has @.commits;
    has $.compare-url;
}

method !push($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $pusher := $event.pusher;

    %args<actor>       := $forgejo ?? $pusher.login !! $pusher.name;
    %args<branch>      := my $*BRANCH := $event.ref.subst('refs/heads/');
    %args<commits>     := eager $event.commits.map: {self!commit($_, $forgejo)}
    %args<compare-url> := $forgejo ?? $event.compare-url !! $event.compare;

    Push.new(|%args)
}

#- RepositoryEvent::Release ----------------------------------------------------
my class Release does Basics {
    has $.actor;
    has $.action;
    has @.assets;
    has $.author;
}

method !release($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $release := $event.release;

    %args<action> := $event.action;
    %args<actor>  := $event.sender.login;
    %args<assets> := eager $release.assets.map: { self!asset($_, $forgejo) }
    %args<author> := $release.author.name;

    Release.new(|%args)
}

#- RepositoryEvent::Repository -------------------------------------------------
my class Repository does Basics {
    has $.action;
    has $.actor;
}

method !repository($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<action> := $event.action;
    %args<actor>  := $event.sender.login;

    Repository.new(|%args)
}

#- RepositoryEvent::Star -------------------------------------------------------
my class Star does Basics {
    has $.action;
}

method !star($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<action> := $event.action;

    Star.new(|%args)
}

#- RepositoryEvent::Status -----------------------------------------------------
my class Status does Basics {
    has $.actor;
    has $.author;
    has $.committer;
    has $.message;
    has $.sha;
    has $.state;
    has $.title;
    has $.updated-at;
    has $.url;
}

method !status($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $commit  := $event.commit;
    my $message := $commit.message;
    my @lines    = $message ?? $message.lines !! '';
    my $title   := @lines.shift;

    %args<actor>      := $event.sender.login;
    %args<author>     := $commit.author.name;
    %args<committer>  := $commit.committer.name;
    %args<message>    := @lines.join("\n").trim;
    %args<sha>        := $event.sha;
    %args<state>      := $event.state;
    %args<title>      := $title;
    %args<updated-at> := $event.updated-at;
    %args<url>        := $commit.url;

    Status.new(|%args)
}

#- RepositoryEvent::Watch ------------------------------------------------------
my class Watch does Basics {
    has $.actor;
    has $.action;
}

method !watch($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<actor>  := $event.sender.login;
    %args<action> := $event.action;

    Watch.new(|%args)
}

#- RepositoryEvent::Wiki -------------------------------------------------------
my class Wiki does Basics {
    has $.actor;
    has @.pages;
}

method !wiki($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    %args<actor> := $event.sender.login;
    %args<pages> := eager $event.pages.map: { self!page($_, $forgejo) }

    Wiki.new(|%args)
}

#- RepositoryEvent::WorkflowJob ------------------------------------------------
my class WorkflowJob does Basics {
    has $.completed-at;
    has $.conclusion;
    has $.name;
    has $.sha;
    has $.url;
}

method !workflow-job($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $workflow-job := $event.workflow-job;

    %args<completed-at> := $workflow-job.completed-at;
    %args<conclusion>   := $workflow-job.conclusion;
    %args<name>         := $workflow-job.app.name;
    %args<sha>          := $workflow-job.head-sha;
    %args<url>          := $workflow-job.html-url;

    WorkflowJob.new(|%args)
}

#- RepositoryEvent::WorkflowRun ------------------------------------------------
my class WorkflowRun does Basics {
    has $.conclusion;
    has $.name;
    has $.sha;
    has $.updated-at;
    has $.url;
}

method !workflow-run($event, $forgejo) {
    my %args := self!basics($event, $forgejo);

    my $workflow-run := $event.workflow-run;

    %args<conclusion> := $workflow-run.conclusion;
    %args<name>       := $workflow-run.app.name;
    %args<sha>        := $workflow-run.head-sha;
    %args<updated-at> := $workflow-run.updated-at;
    %args<url>        := $workflow-run.html-url;

    WorkflowRun.new(|%args)
}

# vim: expandtab shiftwidth=4
