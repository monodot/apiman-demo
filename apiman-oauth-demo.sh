#!/usr/bin/env bash
# apiman-oauth-demo.sh
# Sets up a realm in Keycloak
# Creates an API in apiman and secures with OAuth

APIMAN_HOST="http://apiman.local" #no trailing slash!
APIMAN_USERNAME=admin
APIMAN_PASSWORD=admin123!
APIMANCLI_PATH="/path/to/apiman-cli" #no trailing slash!
API_URL="http://myapi.local/path/to/endpoint"
REALM_JSON=keycloak-stottie.json
APIMAN_YAML=rest-hello.yml
APIMAN_YAML_TMP=rest-hello-tmp.yml

# Create new realm in Keycloak
echo Getting keycloak auth token...
export AUTHTOKEN=$(curl --data 'username='$APIMAN_USERNAME'&password='$APIMAN_PASSWORD'&client_id=admin-cli&grant_type=password' $APIMAN_HOST/auth/realms/master/protocol/openid-connect/token | jq -r '.access_token')
echo Got auth token: $AUTHTOKEN
echo Importing JSON realm to keycloak...
curl -X POST -d @$REALM_JSON $APIMAN_HOST/auth/admin/realms --header "Content-Type:application/json" -k -H "Authorization: Bearer $AUTHTOKEN"

# Get the certificate string from the realm JSON file
# Make a new copy of the Apiman YAML file with the cert string
# (because command line params to apiman-cli cannot contain
# the equals sign)
CERT_STRING=$(jq -r '.certificate' $REALM_JSON)
cp $APIMAN_YAML $APIMAN_YAML_TMP
sed -i.bak "s|"'${certString}'"|$CERT_STRING|g" $APIMAN_YAML_TMP

# Create resources in APIman using apiman-cli
CWD=$(pwd)
CMD="./apiman apply -f $CWD/$APIMAN_YAML_TMP -s $APIMAN_HOST/apiman -P endpointUrl=$API_URL -P apimanHost=$APIMAN_HOST"
cd $APIMANCLI_PATH
echo Applying apiman configuration...
echo $CMD
$CMD
cd $CWD
