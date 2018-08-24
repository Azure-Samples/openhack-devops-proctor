# Leaderboard batch chart


# Prerequisite 

You need two secrets before applying this helm chart. You can create these by this command. 

```
kubectl create secret generic functions --type=string --from-literal=storage_connection_string="YOUR_STORAGE_ACCOUNT_CONNECTION_STRING" --from-literal=sql_connection_string="YOUR_SQL_CONNECTION_STRING"
```



# Usage

Modify the `value.yaml.example` to `value.yaml`. `value.yaml`.
Apply the chart


```
helm install ./helm/ 
helm install ./helm --name leaderboardbatch --set image.repository=YOUR_IMAGE_NAME
```

NOTE: YOUR_IMAGE_NAME: e.g. someacr.azurecr.io/devopsoh/leaderboard-batch

