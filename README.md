# Heroku Buildpack: copy 'shared' folder into individual project folders before the build step

This buildpack copies the `shared` folder from the monorepo root into the folder set by the `APP_BASE` environment variable before the monorepo buildpack runs. This ensures that when the monorepo buildpack copies the `APP_BASE` folder to root, the shared folder is included.

## Usage

First, create a Github repo with the files `bin/compile`, `bin/detect`, and `bin/prepare-shared`.

Then, add this buildpack as the **first** buildpack before the monorepo buildpack. Example:

```bash
heroku buildpacks:clear
heroku buildpacks:add https://github.com/yourname/heroku-buildpack-monorepo-copy-shared.git
heroku buildpacks:add https://github.com/lstoll/heroku-buildpack-monorepo
heroku buildpacks:add heroku/nodejs
```

## Files

- `bin/detect` - Detects if buildpack should run (always returns success)
- `bin/compile` - Main compile script that runs prepare-shared
- `bin/prepare-shared` - Script that copies shared folder into app directory

## How It Works

1. This buildpack runs first
2. It uses the `APP_BASE` environment variable (set by the monorepo buildpack) to determine the app directory path
3. It searches up the directory tree to find the repository root (where both `shared` and the app directory exist)
4. It copies `shared` into `$APP_BASE/shared`
5. The monorepo buildpack then copies `$APP_BASE` (now including shared) to root
6. The Node.js buildpack runs the build, which can now find the shared folder

## Environment Variables

- `APP_BASE` - The path to the app directory within the monorepo (e.g., `frontend/apps/app` or `monolith`)
  - This should be set as a Heroku config var per app (e.g., `heroku config:set APP_BASE=monolith`)
  - This is the same variable used by the `heroku-buildpack-monorepo` buildpack
