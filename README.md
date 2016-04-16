# apiman-oauth-demo
Using command line utils, creates a keycloak realm, sets up an organisation in apiman, adds the OAuth plugin, creates and publishes an API secured with OAuth.

This is a scripting of the tutorial in [Marc Savy's blog post] [1] on the apiman blog. It uses the same keycloak realm definition (`stottie`) referenced in that post.

Requires:

- [apiman-cli] [2]
- [jq] [3] (`brew install jq`)
- a sample REST API (to demo with)

Requires apiman >= 1.2.3.Final.

## What it does

The shell script does the following:

1. Gets an authentication token from keycloak
1. Imports a realm into keycloak from a JSON definition (`keycloak-stottie.json`) using keycloak's REST API
1. Uses the `apiman-cli` tool to add the OAuth plugin to apiman, create an organisation, add an API, secure it with OAuth and publish it.

## How to run

1. Clone the repo.
1. Edit the script `apiman-oauth-demo.sh`, modifying the following variables:
	- `APIMAN_HOST` - the hostname of your apiman instance, e.g. `http://myapiman.local`
	- `API_URL` - the URL of the API to be secured, e.g. `http://myapi.local/path/to/endpoint`
	- `APIMAN_USERNAME` and `APIMAN_PASSWORD` to your apiman admin credentials
	- `APIMANCLI_PATH` - the path to `apiman-cli`, e.g. `/Users/john/Documents/apiman-cli`
1. Edit the YAML definition `apiman-rest-hello.yml`, modifying the `name` and `description` of your API in the `api` block.
1. Run `./apiman-oauth-demo.sh`

[1]:http://www.apiman.io/blog/gateway/security/oauth2/keycloak/authentication/authorization/1.2.x/2016/01/22/keycloak-oauth2-redux.html "Keycloak and dagger: Securing your APIs with OAuth2"
[2]:https://github.com/apiman/apiman-cli "apiman-cli"
[3]:https://github.com/stedolan/jq "jq"