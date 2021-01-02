# devcontainers
Devcontainers or Codespace with optimizations for PHP and Nodejs development.

Laravel, Symfony, NestJS, SailsJS, WordPress, Drupal, Magento,
Prestashop, Opencart compatible and possible any NodeJS and PHP project.

## Getting started:

[Download a zip of this repo](https://github.com/madalinignisca/devcontainers/archive/master.zip)
(clone only for contributions).

Rename the directory with something suitable for your project
(will be used by docker as a namespace!)

Change name in `.devcontainer/devcontainer.json` for your project.
(This will keep your projects storage isolated between them)

Uncomment/add needed services in `docker-compose.yml`.

You need to have [Docker](https://docs.docker.com/get-docker/)
installed and working on your computer
(remote can also be used, this setup does not use local volume binds).

_One time_: Generate your [ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent),
but follow next for ssh-agent.

Follow the ssh integration help [Using ssh keys](https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys).
VSCode will automatically use ssh keys if were previously generated locally and are available.
(this is nice, as VSCode automates usage of your git and ssh stuff and you do not have to do it on each new project)

_Optional_: Setup git in your host machine and set all global configuration (Like your name, email, gpg etc.).
Visual Studio Code will syncronize them with any project you will work using this.

**Open it in Visual Studio Code.**

_One time_: [Install the remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
if you do not have it yet.

_Optional_: Install [Git](https://git-scm.com/) and make
[Identity config](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

Enjoy :)

_Optional_: To use [Prettier](https://prettier.io/) with php once you have your project setup, run
`npm install --save-dev prettier @prettier/plugin-php`
to install the php plugin for the extension to consume it. Config your settings as you like.

_Add another related project/folder to the workspace_: in `/projects` create a folder for the additional project and add this folder to the workspace
in Visual Studio Code like you do for local. I use this setup to have the frontend main client in the main `/projects/workspace` folder and
`/projects/api` for the api as an example.

_Advanced extra settings_: Once a project has been initiated, the developer user folder is mounted as a docker volume.
If you need to make changes in the configuration of devcontainer that should change the workspace,
possible you might need to close the project, remove main container and the user volume.
I usually did workspace settings changes or added new extensions in Visual Studio Code, and
added them also in the devcontainer json file and did not need to remove the use volume for recreation.
Changing the docker compose recipe requires only triggering a rebuild in Visual Studio Code from the remote extension
options (click on bottom left icon of it and choose to rebuild).

PS. Turn off services that might use 8000, 8080, 3000, 3306 or other ports on your local.
This are needed for Docker to map ports in the containers.
Or disable/change them in `docker-compose.yml` (left value is host to change, right is inside container - do not change the right one if unsure what you do),
VSCode will ask you to open a new random port when you start a development server.

## Examples
_(after you have started it)_
Start Visual Studio Code's terminal (will by default use the dev container zsh with some enhancements).

Start a new Laravel project: `composer create-project laravel/laravel .`
This will generate a new project in the workspace.

Edit `.env` to access the database at host `mariadb`, user and password `developer` or whatever database
you have set in docker compose file.

When you serve, pass `--host=0.0.0.0`. App will be accessible at http://127.0.0.1:8000 in your browser.
_Tip_: For Laravel, add [this gist](https://gist.github.com/madalinignisca/1c7a360fb75dfce4a317843eaf63a637)
to `/app/console/commands/ServeCommand.php` and just run `artisan serve`.

Clone the project in the workspace `git clone [git-repo] .`.

Use git, edit as expected, use debug for php, nodejs etc. Workspace settings for debugging should be saved in
the project (I usually save them to the project's git repo, as all team members use identical setup and
there is no need for different settings).
