# devcontainers
Devcontainers or Codespace with optimizations for PHP and Nodejs development.

Laravel, Symfony, NestJS, SailsJS, WordPress, Drupal, Magento, Prestashop, Opencart compatible and mode.

## Getting started:

[Download a zip of this repo](https://github.com/madalinignisca/devcontainers/archive/master.zip)
(clone only for contributions).

Rename the directory with something suitable for your project
(will be used by docker!)

Change name in `.devcontainer/devcontainer.json` for your project.
(This will keep your projects storage isolated between them)

Uncomment/add needed services in `docker-compose.yml`.

You need to have [Docker](https://docs.docker.com/get-docker/)
installed and working on your computer
(remote can also be used, this setup does not uses local volume binds).

Open it in Visual Studio Code.

[Install the remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
if you do not have it yet.

Install [Git](https://git-scm.com/) and make
[Identity config](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup).

Generate your [ssh key](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent),
but follow next for ssh-agent.

Follow the ssh integration help [Using ssh keys](https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys).
VSCode will automatically use ssh keys if were previously generated locally and are available.
(this is nice, as VSCode automates usage of your git and ssh stuff and you do not have to do it on each new project)

Enjoy :)

To use [Prettier] with php once you have your project setup, run
`npm install --save-dev prettier @prettier/plugin-php`
to install the php plugin for the extension to consume it. Config your settings as you like.

PS. Turn off services that might use 8000, 8080, 3000, 3306 or other ports on your local.
This are needed for Docker to map ports in the containers.
Or disable them in `docker-compose.yml`, VSCode will ask you to open a new random port
when you start a development server.

## Examples
_(after you have started it)_
Start Visual Studio Code's terminal (will by default use the dev container bash).

Start a new Laravel project: `composer create-project laravel/laravel .`
This will generate a new project in the workspace.
When you serve, pass `--host=0.0.0.0`. App will be accessible at http://127.0.0.1:8000 in your browser.

Clone the project in the workspace `git clone [git-repo] .`.

Use git, edit as expected, use debug for php, nodejs etc.

Access the database at host `mariadb`, user and password `developer`.
