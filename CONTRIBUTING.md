## How to contribute 

**This document was inspired by the [khmer project getting started documentation](https://github.com/dib-lab/khmer/blob/master/doc/dev/getting-started.rst).** 

This document is for people that want to contribute to the dahak metagenomics project. It walks contributors through getting started with GitHub, creating an issue, claiming an issue, making a pull request, and where to store data and newly created Docker images. 

## Quickstart 

Dahak is open source, open data project and we welcome contributions at all levels. We encourage you to submit issues, suggest documentation changes, contribute code, images, workflows etc.. Any software included in the workflows must be open source, findable, and reusable. Check out [Getting Started](https://github.com/dahak-metagenomics/dahak#getting-started), analyze some data, and contribute however you see fit. 

## How to get started

1. Create a [GitHub](https://github.com) account. 

2. Fork https://github.com/dahak-metagenomics/dahak .

Visit that page, and then click 'Fork' in the upper right-hand corner. This creates a copy of the dahak source code in your GitHub account. If you're new to GitHub or want a refresher, please check out this awesome [tutorial](https://guides.github.com/activities/hello-world/). 

3. Clone a copy of khmer into your local environment (or work in your browser!).

Your shell command should look something like (you can click the 'clone or download' button on the dahak github, copy the link, and insert git clone before it): 

```git clone https://github.com/dahak-metagenomics/dahak.git```

This makes a copy of the dahak repository on your local machine. 

## Claiming an issue and starting to develop 

1. Find an open issue and claim it. 

Go to the list [open issues](https://github.com/dahak-metagenomics/dahak/issues) and claim one you like. Once you've found an issue you like, open it, click 'Assignees', and assign yourself. Once you've assigned yourself make a comment below the issue saying "I'm working on this." That's it; it's all yours. Well not really, because you can always ask for help. Just make another comment below stating what you need some help with and we'll get right back to you. 

(Staking your claim is super important because we're trying to avoid people working on the same issue.) 

2. In your local copy of the source code, update your master branch from the main dahak branch. 

```
git checkout master 
git pull dib master
```

(This pulls in the latest changes from the master repository)

If git complains about 'merge conflicts' when you execute ```git pull```, please refer to the ***Resolving merge conflicts*** [section](https://khmer.readthedocs.io/en/v2.1.1/dev/guidelines-continued-dev.html) in the khmer documentation.  

If you are asked to make changes before your pull request can be accepted, you can continue to commit additional changes to the branch associated with your original pull request. The pull request will automatically be updated each time you commit to that branch. Github provides a medium for communicating and providing feedback. Once the pull request is approved, it will be merged into the main branch by the dahak development team.

3. Creating a new branch and linking it to your fork on GitHub 

```
git checkout -b fix/brief_issue_description 
git push -u origin fix/brief_issue_description 
```

where you replace "brief_issue_description" with 2-3 words separated by underscores describing the issue. 

4. Make some changes and commit them

After you've made a set of cohesive changes, run the command ```git status```. This will display a list of all the files git has noticed you changed. Files in the 'untracked' section are files that weren't in the repository before but git has seen. 

To commit these changes you have to 'stage' them using the following command. 

```
git add path/to/file
```

Once you've staged your changes, it's time to make a commit (Don't forget to change path/to/file to the actual path to file): 

``` 
git commit -m 'Provide a brief description of the changes you made here' 
```

Please make your commit message informative but concise — these messages become a part of the history of the repo and an informative message will help track down changes later. Don't stress over this too much, but before you press the button, please consider whether you will find this commit message useful when a bug pops up 6 months from now and you need to sort through issues to find the right one. Once your changes have been commited, push them to the remote branch: 

```
git push origin
```

7. As you develop, please periodically update your branch and resolve conflicts. 

```
git pull master
```

8. Repeat until your ready to commit to master 

9. Set up a 'Pull Request' asking to merge your changes into the master dahak repository

In a web browser, go to your GitHub fork of dahak, e.g.:

```
https://github.com/your-github-username/dahak
```
and you will see a list of 'recently pushed branches' just above the source code listing. On the right side, there should be a green 'Compare and pull request' button. This will add a pull request submission checklist in the following form: 

```
Merge Checklist
 - Typos are a sign of poorly maintained code. Has this request been checked with a spell checker?
 - Tutorials should be universally reproducible. If this request modifies a tutorial, does it assume we're starting from a blank Ubuntu 16.04 (Xenial Xerus) image?
 - Large diffs to binary or data files can artificially inflate the size of the repository. Are there large diffs to binary or data files, and are these changes necessary?
 ```
Next, click "Create Pull Request". This creates a new issue where others can review and make suggestions before your code is added the master dahak repository. 

10. Review the pull request checklist and make changes, if necessary. 

Check off as many boxes as possible and make a comment if you need help. If you have an ORCID ID <https://orcid.org/> please ad that as a comment. Dahak is an open-source, community-driven project and we'd like to acknowledge your contribution when we publish. Including your ORCID ID helps that process move smoothly. 

As you add new changes, you can keep pushing to your pull request using ```git push origin```. 

11. When you're ready to have the pull request reviewed, please mention @brooksph, @charlesreid1, @kternus, @stephenturner, @ctb or anyone else on the list of [collaborators](https://github.com/dahak-metagenomics/dahak/settings/collaboration) plus the comment `ready for review`. Often pull requests will require changes, need more work before they can be merged, or simply need to be addressed later. Adding tags can help with organizing. Check out this list for some examples of [tags](https://github.com/atom/atom/blob/master/CONTRIBUTING.md#pull-request-labels). 

12. Once your issue has been reviewed an merged, stand-up, throw your hands in the air, and do a little dance; you're officially a GitHub master and a contributor to the dahak project – we hold you in the highest of regards. 

## My pull request has been merged. What do I do now? 

Before continuing on your journey towards your next pull request, there are a couple of steps that you need take to clean up your local copy of dahak. 
```
git checkout master
git pull master
git branch -d fix/brief_issue_description     # delete the branch locally
git push origin :fix/brief_issue_description  # delete the branch on your GitHub fork
```

## I have a dataset that I'd like to contribute to the project 

Great! A big part of this project is benchmarking tools to determine when and how we should use them. Datasets with interesting composition help us uncover new and interesting things about metagenomics tools. If you have a dataset that you would like to benchmark and/or submit for benchmarking please create an issue and mention @brooksph, @kternus, or @ctb. In general, we'll advise you to make the data publicly available and go crazy characterizing it. We can help you think about the best way to do it but in general we're using the workflows in the [workflows/](https://github.com/dahak-metagenomics/dahak/tree/master/workflows) repository and analyzing the data in Jupyter notebooks. Poke us and we'd be happy to discuss the process. If your dataset is less than 5 GB in size, the [open science framework](https://osf.io) is a great, free place to put it. 

## I have a tool that I'd like to contribute to the project
Greater! The more tools the better. A major goal of this project to make more tools easy to use. We opted to do this by using or creating containerized tools. The [biocontainers project](https://biocontainers.pro) is leading the way in this effort and we've contributed a few things there. You're not required to contribute to the biocontainers project to add a tool to this project but the tool must be open source and the image must be stored in a public repository like [Docker hub](https://hub.docker.com) or [quay.io](https://quay.io). [Here's](https://docs.docker.com/get-started/#containers-and-virtual-machines) an excellent guide to getting started building containers. We're using [Singularity](https://singularity.lbl.gov/docs-docker) to run the containers in our workflows. Docker does not need to be installed. 

## I have a workflow that I'd like to contribute to the project 
Greatest! New metagenomics analysis tools are created all the time. We're using a small subset that we think encompasses most the methods that are most commonly used to probe metagenomic communities. If you want to include a new tool or workflow, create an issue and we can point you in the right direction. The critical bits are we're stringing together open-source, containerized tools to make workflows using [Snakemake](https://snakemake.readthedocs.io/en/stable/). Take a look here for a [basic example](https://github.com/dahak-metagenomics/dahak/blob/master/workflows/read_filtering/Snakefile) and here for a bit [more flavor](https://github.com/dahak-metagenomics/taco-read-filtering/tree/master/rules/read_filtering). This is a work in progress but the second example is where we're headed. 

## Contributor Code of Conduct

As contributors and maintainers of this project, we pledge to respect all people who contribute through reporting issues, posting feature requests, updating documentation, submitting pull requests or patches, and other activities.

We are committed to making participation in this project a harassment-free experience for everyone, regardless of level of experience, gender, gender identity and expression, sexual orientation, disability, personal appearance, body size, race, ethnicity, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual language or imagery, derogatory comments or personal attacks, trolling, public or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or reject comments, commits, code, wiki edits, issues, and other contributions that are not aligned to this Code of Conduct. Project maintainers who do not follow the Code of Conduct may be removed from the project team.

Instances of abusive, harassing, or otherwise unacceptable behavior may be reported by emailing [Phil Brooks](ptbrooks@ucdavis.edu) or [C. Titus Brown](ctbrown@ucdavis.edu). To report an issue involving either of them, please email [Judi Brown Clarke](jbc@egr.msu.edu), Ph.D. the Diversity Director at the BEACON Center for the Study of Evolution in Action, an NSF Center for Science and Technology.

This Code of Conduct is adapted from the Contributor Covenant, version 1.0.0, available from http://contributor-covenant.org/version/1/0/0/
