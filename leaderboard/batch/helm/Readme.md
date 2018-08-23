# Leaderboard batch chart

# Usage

Modify the `value.yaml.example` to `value.yaml`. `value.yaml`.
Apply the chart


```
helm install ./helm/ 
helm install ./helm --name leaderboardbatch --set image.repository=YOUR_IMAGE_NAME
```

NOTE: YOUR_IMAGE_NAME: e.g. someacr.azurecr.io/devopsoh/leaderboard-batch
