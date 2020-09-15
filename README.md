# devcontainer-php
Devcontainers or Codespace with optimizations for PHP and Nodejs development. Laravel, Symfony, WordPress, Drupal etc.

## Getting started:

Download a zip of this repo (clone only for contributions).

Rename the directory with something suitable for your project
(will be used by docker!)

Change name in `.devcontainer/devcontainer.json` for your project.

Open it in Visual Studio Code ([install the remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).

Enjoy :)

PS. Turn off services that might use 8000, 8080, 3000, 3306 ports on uour local. This are needed for Docker to map ports
in the containers.

## Examples
_(after you have started it)_
Start Visual Studio Code's terminal (will by default use the dev container bash).

Start a new Laravel project: `composer create-project laravel/laravel .`
This will generate a new project in the workspace.
When you serve, pass `--host=0.0.0.0`. App will be accessible at http://127.0.0.1:8000 in your browser.

Or generate a ssh key with `ssh-keygen`. Copy the public key to your git account.
Clone the project in the workspace `git clone [git-repo] .`

Use git, edit as expected, use debug for php, nodejs etc.

Access the database at host `db`
