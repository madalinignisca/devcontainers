# devcontainer-php
Devcontainers or Codespace with optimizations for PHP and Nodejs development. Laravel, Symfony, WordPress, Drupal etc.

## Getting started:

Download a zip of this repo (clone only for contributions).
Rename the directory with something suitable for your project
(will be used by docker!)
Change name in `.devcontainer/devcontainer.json` for your project.
It expects you will add `.ssh` or you can generate after it started.
Open it in Visual Studio Code ([install the remote containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).
Enjoy :)

## Examples
_(after you have started it)_
Start a new Laravel project: `composer create-project laravel/laravel .`
This will generate a new project in the workspace.
Use git, edit as expected, use debug for php, node etc.
