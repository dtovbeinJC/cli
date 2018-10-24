[< Back to menu](../../README.md)

## Game Services Config V2 CLI Program :metal:
### Automation Program and Code Generator

Created by [Dan Tovbein](https://github.com/dtovbeinJC) with :blue_heart: :yellow_heart: :blue_heart:  and maintained by all CFG2's Developers

:exclamation: **before starting, you have to clone the CLI's repository**

`git clone git@github.com:dtovbeinJC/cli.git cli`

You can run the program through this command

    $ source cli/app-cli.sh

and once it´s initialized for the first time you can run through the next alias

_in addition, you can set the first parameter to `true` or `false` if you want to print the current app version. By default it's set to false._ 

```bash
    $ cfg2-cli
```

or

```bash
    $ builder
```

### Program menu
___
* **[1]** [GIT program](#git-program)
    * **[1]** [Create new branch](#create-new-branch)
    * **[2]** [Commit changes](#commit-changes)
    * **[3]** [Checkout to branch](#checkout-to-branch)
    * **[4]** [Reset edited files](#reset-edited-files)
    * **[5]** [Remove branch](#remove-branch)
    * **[6]** [Remove tag version](#remove-tag-version)
* **[2]** [React program](#react-program)
    * **[1]** [Create component](#create-component)
    * **[2]** [Create reducer](#create-reducer)
    * **[3]** [Show all components and reducers](#show-all-components-and-reducers)
    * **[4]** [Update helpers file](#update-helpers-file)
    * **[5]** [Remove component](#remove-component)
    * **[6]** [Remove reducer](#remove-reducer)
* **[3]** [FTP program](#ftp-program)
   * **[1]** [Set up user](#set-up-ftp-user) 
* **[4]** [Install app](#install-app)
* **[5]** [Run application](#run-application)
* **[6]** [Fix project](#fix-project)
* **[7]** [Set application env variables](#set-app-env-var)
* **[8]** [Set application sass variables](#show-app-sass-vars)
* **[9]** [Show application env variables](#show-app-env-vars)
* **[10]** [Release](#release)
* **[11]** [Remove app env vars](#remove-app-env-vars)
* **[0]**  [Exit program](#exit-program)
* **[?]**  [Help](#help)
___


### Create new branch
Through this option you can create a new semantic branch. Always in this format *PROJECT_NAME:TICKET_ID*

### Commit changes
This option allows you to:
* Make a new commit
* Push your code
* Versioning your changes
* Update [changelog.md](../../changelog.md)
* Once is updated to git, you need to create to merge `base branch` to the new one 

### Release
* Create a new app code version with all the code minified and uglified
* Update to FTP by ssh

### Checkout to branch
Checkout to a branch if exists. The new branch will get the updated code from `develop`

### Reset edited files
It simply reset all edited files from the last commit

### Remove branch
Remove an existed branch local and remote

### Remove tag version
This options removes a selected tag version

### Set up FTP user
Set ftp username

### Install app
Install all app modules through `npm`

### Run application
Run the application compiling all files (js and sass)

### Fix project
Remove and re-install all modules if is there any conflict between npm modules

### Create component
Through this option you can create any React component
* Functional component 
* Class component 
* Container as Smart component

Depends of what kind of component is it:

* View
* Snippet
* Widget 

### Create reducer
You can create a reducer

### Show all components and reducers
Show all components & reducers that were been created

### Update helpers file
Create and update helpers file which is used by all components

### Set app sass vars
You can set current sass environment variables. It creates js and sass files and contains the same variables with the idea that the developer could not only import sass file and also import from a js module

Examples:

```scss
@import "./src/sass/_variables";
```

```javascript
import { VARIABLE } from "./src/sass/_variables";
```

### Show app env vars
You can see current environment variables

### Set app env vars
You can set a new version of environment variables

### Remove component
Remove a selected component

### Remove reducer
Remove a selected reducer

### Remove app env vars
You can remove all environment variables


------------------