# MDR Research Lab Operations

This directory contains local research artifacts for the Paperclip-based MDR lab.

The runtime state is intentionally split:

- Git-managed: company package, skills, case writeups, Docker startup wrapper, and Compose file.
- Local-only: `.env`, embedded Postgres data, auth stores, logs, uploaded assets, and imported runtime state under `data/`.

Do not commit `.env` or `data/`. They can contain secrets, auth tokens, invite state, database contents, and local execution logs.

## Start From This Terminal

Use one command from the repository root:

```sh
./scripts/mdr-up.sh
```

The command:

1. Pulls the latest Git state from the private remote when the worktree is clean.
2. Creates `.env` if it does not exist.
3. Creates the local Paperclip config if it does not exist.
4. Copies the MDR company package into the Docker data area for import.
5. Starts Paperclip with `docker/docker-compose.mdr.yml`.
6. Imports `MDR Frontier Research Lab` if it is missing.
7. Sets the Paperclip CLI context profile to the MDR company.

If you want the running Paperclip company to exactly match the latest Git package, recreate it explicitly:

```sh
./scripts/mdr-up.sh --recreate-company
```

This deletes the existing `MDR Frontier Research Lab` company from the local Paperclip instance and imports it again from `companies/mdr-frontier-research-lab`. Local Paperclip runtime state for that company, such as issue history and comments, is removed with the company.

On a completely fresh machine, the first run will print a bootstrap CEO invite and wait for the first admin account to be created. It may then print a CLI approval URL; approve it in the browser and the same command will continue.

After setup, the dashboard is:

```text
http://localhost:3100/MDR/dashboard
```

## Private GitHub Remote

Keep the upstream Paperclip remote as `origin` or add a private remote named `private`.

Recommended shape:

```sh
git remote add private git@github.com:<owner>/paperclip-mdr.git
git push -u private master
```

`scripts/mdr-up.sh` pulls from `private` when that remote exists. If it does not, it pulls from `origin`.

## Useful Commands

```sh
./scripts/mdr-up.sh --no-pull
./scripts/mdr-up.sh --no-import
./scripts/mdr-up.sh --recreate-company
docker logs -f paperclip-mdr
docker compose --project-name paperclip-mdr -f docker/docker-compose.mdr.yml down
```
