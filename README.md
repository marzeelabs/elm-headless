# elm-headless

Trial repo for building an Elm app. Currently, this displays a list of articles from a Drupal 8 back-end (hosted on platform.sh)

## Installation

	npm install

and then

	elm-package install

## How to start

Start the web app (`http://localhost:3000`)

	npm run dev

## For debugging

To help out with debugging, it is often easier to use a fake JSON back-end. Start the JSON server (`http://localhost:4000`) and use this source instead

	npm run api
