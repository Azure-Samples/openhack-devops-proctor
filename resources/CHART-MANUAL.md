# Manual to use the team's chart

This manual explains how to use the helm chart that was provided to deploy the [team's API](https://github.com/Azure-Samples/openhack-devops-team/tree/master/apis).

## Chart installation

During the course of an OpenHack, the initial deployment of the chart has already been done for each team. Should you need to redeploy the chart for any reason, you can use the following command from `openhack-devops-team/apis/poi/charts/mydrive-poi`:

> NOTE: Adjust the names with the ones corresponding to your environment.

```
export $TAG="openhackch63acr.azurecr.io/devopsoh/api-poi"
export $BASE_URI="http://akstraefikopenhackch63.eastus.cloudapp.azure.com"
export $dnsUrl="akstraefikopenhackch63.eastus.cloudapp.azure.com"
helm install . --name api-poi --set repository.image=$TAG,env.webServerBaseUri=$BASE_URI,ingress.rules.endpoint.host=$dnsUrl
```

## Updating an existing deployment

The following command will deploy the container of `api-poi` with the tag `123` in the green environment. To deploy to the blue environment, you replace green with blue (green and blue are the only accepted values in the chart provided)

```
helm upgrade api-poi . --set green.enabled=true,green.tag=123 --reuse-values
```

## Selecting the environment to expose in production

The following command will expose the `green` environment to be the production environment (you can also use `blue`). The selected environment will be accessible via the production endpoint.

```
helm upgrade api-poi . productionSlot=green --reuse-values
```

## Delete an environment

The following command will destroy the pods of the green environment, you can replace green with blue (green and blue are the only accepted values in the chart provided)

```
helm upgrade api-poi . --set green.enabled=false
```
