# SE Demo Template

Use this template to quickly build and deploy a Federated demo environment.

Use the included setup tool (`make setup`) whenever possible as it saves
your information and can be re-run multiple times to update `.env` files
and `cloudbuild.yaml` files. 

## Git Checkout Basics

If you want to save changes that you make to your demo, it's a good idea
to use git branches.

 1. Check out the code: `git clone git@github.com:apollographql/se-demo-template.git` or `git clone https://github.com/apollographql/se-demo-template.git` (use the second one if you haven't setup a SSH key in GitHub).
 2. Make your own branch: `git checkout -b <my-branch-name>` use your name or something for `<my-branch-name>`.
 3. Push (create) your branch on GitHub: `git push origin <my-branch-name>`
 4. To add a new file to your branch: `git add <my-file-name>`
 5. If you want to save (a)ll your changes and include a (m)essage: `git commit -am "My message about what I changed"`
 6. If you want to save it remotely (on GitHub) you need to push: `git push origin <my-branch-name>`
 7. If you want to update your branch with updates made to the main branch: `git pull origin master`
 8. If you want to revert a change to a file that you haven't set saved (commited): `git checkout <the-file-name>`

## Prereqs

 1. Check out this repository (forking is disabled, sorry)
 2. Install Docker for Mac
 3. Install Homebrew & Python 3: https://docs.python-guide.org/starting/install3/osx/
 4. Install NVM for Mac: https://tecadmin.net/install-nvm-macos-with-homebrew/ 
 5. Install NodeJS v16.13.1 using NVM: `nvm install v16.13.1`
 6. Use NodeJS v16.13.1: `nvm use v16.13.1`
 7. Install the Apollo CLI: https://www.apollographql.com/docs/devtools/cli/
 8. Install the Rover CLI: https://www.apollographql.com/docs/rover/
 9. Log into Studio and create a Deployed Graph, get an API Key and note your Graph ID and Variant ID
 10. Run `make install-deps` to install npm packages for each subgraph and to rename dot_env to .env and cloudbuild.yaml.tmpl to cloudbuild.yaml (this __will__ overwrite current files but `make setup` will restore them)
 11. Edit the .env file in ./gateway, ./subgraph1, ./subgraph2, ./subgraph3 to fill in the appropriate variables __OR__ use the setup tool by typing `make setup`

## Run it Locally with Unmanaged Federation (Local Composition)

`make run-local-unmanaged`

## Run it Locally with Managed Federation

 1. Publish your schemas to Apollo
    1. Edit the `ROUTING_URL` in each of the subgraph directories `.env` file:  ./subgraph1, ./subgraph2, ./subgraph3 __OR__ run `make setup` again to set them (recommended).
    2. Publish your graph with `make publish`
 2. Deploy locally: `make run-local-managed`

## Deploy everything to GCP

### Initial Setup (this only happens once)

 1. Install the Google Cloud CLI: https://cloud.google.com/sdk/docs/quickstart
 2. Login to the Google Cloud Console and create a new project
    1. Go to https://console.cloud.google.com/
    2. Find the __"Sales Engineering"__ folder by searching in the drop down and then click "New Project" the "Location" needs to be "Sales Engineering"
    3. Name your new project `<your-last-name>-demo`
    4. Choose `doit.apollographql.com` under "other billing accounts" as the `Billing account`
    5. In your new project click on the menu and select "Cloud Run" from the list.
    6. Click "Enable Cloud Run API"
    7. In your new project click on the menu and select "Cloud Build" from the list.
       1. Under the "Settings" area enable the "Cloud Run Admin" Role (it may ask you if you want to add the role to the service account: approve that action).
 3. Authenticate with Google Cloud from a terminal on your Mac using your Apollo email: `gcloud init` (if you ever need to change your default Project ID (this might be different from the project name so always use the ID) use the command `gcloud config set project <project-ID>`)
 4. In the folder ./gateway, ./subgraph1, ./subgraph2, and ./subgraph3 folders edit the `cloudbuild.yaml` file to use your correct project ID (replace the <CHANGE_ME> in each of those) __OR__ use the setup tool by typing `make setup` (recommended)

### How to deploy

 1. Deploy your gateway and subgraphs with `make deploy`(say "(Y)es" if it asks you to activate any GCP services)
 2. Check the Google Cloud Run Console to see the URLs for each of your services and your gateway.
 3. Update the `.env` files in ./subgraph1, ./subgraph2, ./subgraph3 to have the right `ROUTING_URL` that you got from Cloud Run dashboard __OR__ use the setup tool by typing `make setup`
 4. Run `make publish` (this will run `make publish` in each of your subgraph directories, you can also run those one by one)
 5. Update studio with the right URL for your gateway.

 Steps 2, 3, and 5 should only need to be done the first time.  After that you can just use `make deploy` and `make publish`

## Generate Traffic

### Cloud Scheduler Method (recommended)

 1. Enable Cloud Functions by going to that tab in the Google Cloud Console
 2. Go to Cloud Build->Settings and enable the "Cloud Functions" service account
 3. Edit the client/client.py file to put in the URL of your gateway (must be deployed, not local)
 4. Run `make traffic-gen` it may ask you to enable some things like AppEngine, say (y)es (this will run `make setup-traffic-gen` and `make deploy` in the `client` directory)
 5. If you need to re-deploy your client for any reason go into the `client` directory and run `make deploy`

### CI/CD Method

 1. Update the `client/client.py` file to have the right URL for your gateway (if you change your schema you will need to update the queries in this file).
 2. Update the `.github/workflows/client_gen.yaml` file to have the correct cron string.
 3. Commit and deploy your code to your forked repo and GitHub Actions will start generating traffic for your site.


## Files & Directories

 * _.github/_ - configuration for GitHub Actions (CI/CD)
 * _client/_ - a simple client app to send GQL queries to your demo
 * _gateway/_ - the Apollo Gateway for this demo
 * _subgraph1/_ - a subgraph for this demo
 * _subgraph2/_ - a subgraph for this demo
 * _subgraph3/_ - a subgraph for this demo
 * _.gitignore_ - files that git should not manage
 * _local-test-unmanaged.yaml_ - a config file for Docker Compose to run an unmanaged Federation demo
 * _local-test.yaml_ - a config file for Docker Compose to run a managed Federation demo
 * _Makefile_ - a collection of command shortcuts
 * _supergraph.yaml_ - the config file that Rover uses to create a supergraph offline (ie, without Studio)

## Make it your own

Change the schemas for each of the subgraphs and update the data in the `database.json` files.  In each `server.js` make sure you have the right resolvers for the queries and/or mutations on your graph. 