const express = require('express')
var cors = require('cors')
const app = express()
app.use(cors())
let result = [
    {
        "id": "15e5a4c5-cdc7-4d32-8b49-3259271cba40",
        "teamName": "team1",
        "downTimeSeconds": 10,
        "points": 300
    },
    {
        "id": "15e5a4c5-cdc7-4d32-8b49-3259271cba40",
        "teamName": "team2",
        "downTimeSeconds": 0,
        "points": 400
    },
    {
        "id": "15e5a4c5-cdc7-4d32-8b49-3259271cba40",
        "teamName": "team3",
        "downTimeSeconds": 100,
        "points": 10
    },    
]
app.get('/', (req, res) => res.send(JSON.stringify(result)))
app.listen(3000, () => console.log('Example app listening on port 3000!'))