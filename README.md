# devcontainers
Devcontainers or Codespace with optimizations for PHP and Nodejs development.

[![buildx-8.1-18](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-8.1-18.yml/badge.svg)](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-8.1-18.yml) [![buildx-8.0](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-8.0.yml/badge.svg)](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-8.0.yml) [![buildx-7.4](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-7.4.yml/badge.svg)](https://github.com/madalinignisca/devcontainers/actions/workflows/buildx-bake-7.4.yml)

Laravel, Symfony, CakePHP, Codeigniter, AdonisJS, NestJS, SailsJS, WordPress, Drupal, Magento,
Prestashop, Opencart compatible or any NodeJS and PHP project.

## Getting started:

Using a shell compatible prompt, download generate.sh and run it.

PHP and Node combinations:
|    | 7.4 | 8.0 | 8.1 | 8.2 |
|----|-----|-----|-----|-----|
| 14 | X   | X   |     |     |
| 16 |     | X   | X   |     |
| 18 |     |     | X   | X   |

ARM64 users, you might need to look for supported docker images alternatives for some services. Some official providers don't look into supporting ARM64 too soon.
More on ARM64 soon.

Continue with the [Wiki](https://github.com/madalinignisca/devcontainers/wiki) for advanced documentation.

## Important for Windows 10 users:

https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig

Make sure you will set a memory limit, as the 80% default limit will allow WSL2 to do aggresive caching in ram
and will simply make your system slow, sometimes even freezing minutes. This is not a bug of Docker, neither of
Linux. It's purely a missed optimization of Microsoft in WSL2, forgetting that Linux, like Windows as well, is
very aggressive on caching anything possible.

Example: I use 4GB memory limit and 0 swap to make docker behave identical like on a virtual server with 4gb of ram.
Works fine on a 16GB laptop, no slowness while running devcontainers with lots of services, including
Elastic Search. On a 8GB Windows Host, I would set 3GB memory limit, and tweak in `docker-compose.yaml` to enforce
lower memory limits per services, but do really investigate if those services can run with extrem low memory constrains.

Alternative on <= 16GB of ram, I strongly recommend using a remote small cloud server. Combining REMOTE SSH extension
for Visual Studio Code with the REMOTE DOCKER extension is stright forward with no special setup.

## Sponsors:

### Silver:
- [Coder](https://coder.com/)
