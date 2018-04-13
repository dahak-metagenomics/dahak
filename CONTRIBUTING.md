[TOC]

This document is for people that want to contribute to the dahak metagenomics project. It walks contirbutors through getting started with GutHub, creating an issue, claiming issue, making a pull request, and where to store data and newly created Docker images.

# Impatient? Quick start

Dahak is open source, open data project and we welcome contributions at levels ranging from questions to documentation changes to major code or workflow contributions. Any software included in the workflows must be open source, under a BSD license, findable, and reusable. Check out the quick start guide, analyze some data, and please contribute.

# How to Contribute

## Getting started

1. Create a (GitHub)[https://github.com] account

2. Fork https://github.com/dahak-metagenomics/dahak

Visit that page, and then click 'Fork' in the upper right hand corner. This creates a copy of the dahak source code in your GitHub account.

3. Clone a copy of khmer into your local enviroment (or work in your browser!)

Your shell command should look something like (you can click the 'clone or download' button on the dahak github, copy the link, and insert git clone before it):

```git clone https://github.com/dahak-metagenomics/dahak.git```

This makes a copy of the dahak repository on your local machine.

# Claiming and issue and starting to develop

1. Find an open issue claim it.

Go to the list [open issues](https://github.com/dahak-metagenomics/dahak/issues) and claim one you like. Once you've found an issue you like, open it, click 'Assignees', and assign yourself. Once you've assigned yourself make a comment below the issue saying "I'm working on this". That's it, it's all yours. Well not really, because you can always ask for help. Just make another comment below stating what you need some help with and we'll get right back to you.

(Staking your claim is super important because we're trying to avoid people working on the same issue.

2. In your local copy of the source code, update your master branch from the main dahak branch.

```
git checkout master
git pull dib master
```

(This pulls in the latest changes from the master repository)

If git complains about 'merge conflicts' when you execute ```git pull``` please refer the ***Resolving merge conflicts*** (section)[https://khmer.readthedocs.io/en/v2.1.1/dev/guidelines-continued-dev.html] in the khmer documentation.

If you are asked to make changes before your pull request can be accepted, continue to commit additional changes to the branch associated with your 
original pull request. The pull request will automatically be updated each time you commit to that branch. Github provides a medium for communicating and 
providing feedback. Once the pull request is approved, it will be merged into the main branch by the team.

3. Creating a new branch and link it to your fork on github

```
git checkout -b fix/brief_issue_description
git push -u origin fix/brief_issue_description
```

where you replace "brief_issue_description" with 2-3 words seperated by underscores describing the issue.

4. Make some changes and commit them

After you've made a set of cohesive changes, run the command ```git status```. This will display a list of all the files git has noticed you changed. A file in the 'untracked' section are files that weren't in the repository before but git has noticed.

To commit these changes you have to 'stage' them using the following command.

```
git add path/to/file
```

Once you've staged your changes, it's time to make a commit (Don't forget to change path/to/file to the actual path to file):

```
git commit -m 'Provide a brief description of the changes you made here'
```

Please make your commit message informative but concise -- these messages become a part of the history of the repo and the informative message will help track down changes later. Don't stress over this too much but before you press the button consider whether you 6 months from now would find this commit message useful when a bug pops up and you need to sort through issues to find the right one. Once your changes have been commited, push them to the remote branch:

```
git push origin
```

7. As you develop, please periodically update your branch and resolve confilcts.

```
git pull master
```

8. Repeat until your ready to commit to master

9. Set up a 'Pull Request' asking to merge your changes into the main dahak repository

In a web browser, go to your GitHub fork of dahak, e.g.:

```
https://github.com/your-github-username/dahak
```
and you will see a list of recently 'recently pushed branches' just above the source code listing. On the right side there should be a green 'Compare and pull request' button. This will add a pull request submission checklist. In this form

```
Merge Checklist
 - Typos are a sign of poorly maintained code. Has this request been checked with a spell checker?
 - Tutorials should be universally reproducible. If this request modifies a tutorial, does it assume we're starting from a blank Ubuntu 16.04 (Xenial Xerus) image?
 - Large diffs to binary or data files can artificially inflate the size of the repository. Are there large diffs to binary or data files, and are these changes necessary?
 ```
the click "Create Pull Request"

# Contributor Code of Conduct

As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free experience for everyone, regardless of level of experience, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by emailing [Phil Brooks](ptbrooks@ucdavis.edu) or C. [Titus Brown](ctbrown@ucdavis.edu). To report an issue involving either of them please email [Judi Brown Clarke](jbc@egr.msu.edu), Ph.D. the Diversity Director at the BEACON Center for the Study of Evolution in Action, an NSF Center for Science and Technology.

This Code of Conduct is adapted from the Contributor Covenant, version 1.0.0, available from http://contributor-covenant.org/version/1/0/0/
