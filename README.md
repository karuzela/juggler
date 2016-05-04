# Juggler

Online tool for managing code reviews inside larger teams

## 1. How to run

### 1.1. Setting config variables

Copy `application_example.yml` file and save it as `application.yml` in config folder

#### 1.1.1. Github access token

Go to your Github account Settings. Choose "Personal access tokens" from left bar and then click "Generate new token". Type token description and select those scopes:
- repo
- admin:repo_hook

Confirm with "Generate token" button. Copy generated token to clipboard and paste it as `GITHUB_ACCESS_TOKEN` in `application.yml`

#### 1.1.2. Github app client id and client secret

Go to your Github account Settings. Choose "Applications" from left bar and go to "Developer applications" tab. Click "Register new application" button. Fill in app name. If you want to use "Connect with Github" button in Juggler (which is needed to use Juggler) you should use `ngrok`. Run `ngrok` and copy generated url (for example: https://ad9a381e.ngrok.io). Paste this url in "Homepage URL" input. Then fill in "Authorization callback URL" with this url with /users/github_connect endpoint (for example: https://ad9a381e.ngrok.io/users/github_connect). Confirm with "Register application" button. Copy client id and paste it as `GITHUB_APP_CLIENT_ID` and also paste client secret as `GITHUB_APP_CLIENT_SECRET` in `application.yml`.

### 1.2. Creating first user

Go to `rails console` and create first user

### 1.3. Run app

Run migrations, run `rails server` and go to ngrok url (for example https://ad9a381e.ngrok.io). Log in and then click "Connect with Github" button. Confirm permissions and you will be redirected back to Juggler.

### 1.4. Synchronize your repositories list

Go to "Manager repositories" and click "Refresh repositories" button to get your repositories list from Github. Repositories will be saved as "not synchronized". To subscribe repo pull requests, comments etc. you should go to "Not synchronized" tab on Repositories list and click "Synchronize" on selected repo. From now all PR's from this repo will be send to Juggler.

## 2. How to use

You can now claim, accept or reject PR's by typing `juggler:claim`, `juggler:accept` or `juggler:reject` directly on Github PR's comment.
