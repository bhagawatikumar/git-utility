A git wrapper for extended functionality.
```bash
clone this repo
    $ git clone git@gitlab.amicillc.com:pchaudhry/git-me.git
add following line to your .bashrc
    source <path_to_your_git-me_repo_clone>/.pc_git.sh
    eg.:
        source $HOME/git-clones/git-me/.pc_git.sh

List of extensions
    git-prompt      : will change the prompt to display the branch name
    auto-complete   : will allow the TABing for completion of git commands

    Commands:
    g       --  alternate to typing 'git' and shows status if no arguments are provided
    bb      --  list all the branches (just an alias)
    cc      --  conditional checkout
    dd      --  list diff (alias)
    ac      --  add and commit
    gc      --  git commit with a msg and no quotes
    gl      --  list log


Usage:
$ g
    -- will display status
$ g add file1
    -- will add filename
$ g checkout branchX
    -- will checkout branchX

$ bb
    -- alias to 'git branch', will list all the local branches

$ cc <branch/jira_no/any_specific_word>
    -- this will let you checkout git branch for a jira without knowing the branch name

    For eg:
        alyssa: omnix[master] > cc 22100
            Switched to branch 'feature/xls-22100-md-manager-optimize-label-process'
            Your branch is up-to-date with 'origin/feature/xls-22100-md-manager-optimize-label-process'.
        alyssa: omnix[feature/xls-22100-md-manager-optimize-label-process] >

        alyssa: omnix[feature/xls-22100-md-manager-optimize-label-process] > cc tar
            There are more than one branches containing "tar" :
              feature/tar
              feature/tar-v2-qc
              tar-qc/defect/xls-20903
              tar-qc/sub-feature/xls-20621-db-changes
              tar-qc/sub-feature/xls-20716-invalid_coded_streamid

        alyssa: omnix[feature/xls-22100-md-manager-optimize-label-process] > cc master
            Switched to branch 'master'
            Your branch is up-to-date with 'origin/master'.
        alyssa: omnix[master] >

$ dd
    -- alias to 'git diff'

$ac
    -- will assist while you add and commit modified files in a [kind of] standard way.
    For eg:
    --we have a modified file named jobDetails under Tar directory.

    alyssa: omnix[feature/tar-v2-qc] > g
        On branch feature/tar-v2-qc
        Your branch is up-to-date with 'origin/feature/tar-v2-qc'.
        Changes not staged for commit:
          (use "git add <file>..." to update what will be committed)
          (use "git checkout -- <file>..." to discard changes in working directory)

                modified:   amici_php/app/views/Tar/jobDetails.html

        no changes added to commit (use "git add" and/or "git commit -a")

    -- using ac will list all the modified files and will prompt you to add files.
    -- providing the file will partially create the commit msg with JIRA no and
    -- name of modified file(for single file) and will ask you for remaining commit msg.
    -- Providing the remaining msg will show you the log for last 6 commits for confirmation.

    alyssa: omnix[feature/tar-v2-qc] > ac
        Modified files:
        amici_php/app/views/Tar/jobDetails.html

        File           : amici_php/app/views/Tar/jobDetails.html
        Commit message : [XLS-]--jobDetails.html--running a test for ac function
        [feature/tar-v2-qc 6240c3a] [XLS-]--jobDetails.html--running a test for ac function
         1 file changed, 1 insertion(+), 1 deletion(-)

        Commit logs:
        6240c3a [XLS-]--jobDetails.html--running a test for ac function
        57918cc Merge branch 'defect/fix-tar-v2-qc-rebase-issues' into 'feature/tar-v2-qc'
        46b6975 Rebase Issue, remove duplicate methods getInvalidCodedDocsCount(), addInvalidCodedDocsToStream() and getCodedDocsSql()
        a3ab00b Rebase Issue, remove duplicate methods addInvalidCodedDocs() and qcMethod()
        30cc411 XLs-20592, Changes due to rebasing.
        4b8e6b1 XLS-20592, confirmation msg on cancelling testing set creation updated conditionally.
        alyssa: omnix[feature/tar-v2-qc] >

    alyssa: omnix[zeus--xls-123467] > ac
        Modified files:
        amici_php/app/views/Tar/jobDetails.html
        database/matter/plsql/rev_stream_doc_grouping.pkb

        File           : amici_php/app/views/Tar/jobDetails.html database/matter/plsql/rev_stream_doc_grouping.pkb
        Commit message : [XLS-12346]--testing multiple files
        [zeus--xls-123467 cd0a6ec] [XLS-12346]--testing multiple files
         2 files changed, 13 insertions(+), 7 deletions(-)

        Commit logs:
        cd0a6ec [XLS-12346]--testing multiple files
        6bb30e9 Merge remote-tracking branch 'origin/defect/xls-22268-unable-to-navigate-terms' into release/6.16
        c8e4cc2 XLS-22268: Changed function name to getQuerySetCacheId()
        0bbe0cd XLS-22268: Added a protected function to return the cached Id
        b56505d XLS-22268: Added requestQueryInformation in the cached query to get the correct cache every time
        8fbe59f Merge remote-tracking branch 'origin/patch/6.16.3.3' into release/6.16
    alyssa: omnix[zeus--xls-123467] >


$ gl 10
    -- will display one line log upto last 10 commits
$ gl
    -- will display one line log of last 6 commits as default
    -- example is displayed under usage of 'gc'


$ gc
    eg.:
    alyssa: omnix[feature/tar-v2-qc] > gc testing gc
        [feature/tar-v2-qc f76eb74] testing gc
         1 file changed, 1 insertion(+), 1 deletion(-)

    alyssa: omnix[feature/tar-v2-qc] > gl
        f76eb74 testing gc
        e3a806a Merge branch 'feature-task/xls-21728' into 'feature/tar-v2-qc'
        17b4b37 [XLS-21728]--t$tar_jobs.sql--adding the column in tar_jobs table
        4a23672 [XLS-21728]--patch.sql--added predictiveCoding as default value for job_type and NOT NULL
        57918cc Merge branch 'defect/fix-tar-v2-qc-rebase-issues' into 'feature/tar-v2-qc'
        46b6975 Rebase Issue, remove duplicate methods getInvalidCodedDocsCount(), addInvalidCodedDocsToStream() and getCodedDocsSql()
        a3ab00b Rebase Issue, remove duplicate methods addInvalidCodedDocs() and qcMethod()
        30cc411 XLs-20592, Changes due to rebasing.
        4b8e6b1 XLS-20592, confirmation msg on cancelling testing set creation updated conditionally.
        3344340 XLS-20592, changed redirect url for continue button on testing set page.
    alyssa: omnix[feature/tar-v2-qc] >


```