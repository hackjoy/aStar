## A* Search

A special case of best-first graph search that uses heuristics to improve speed. Define your 2D grid then add any blocked coordinates to the environment that must be avoided when generating the shortest path. Written in CoffeeScript.


### Usage

Add `a-star-search` to your package.json and run `$ npm install`

Require aStar in your app and define the parameters of your 2D grid:

```
aStar = require 'a-star-search'
startLocation = {xAxis: 1, yAxis: 1}
destination = {xAxis: 4, yAxis: 1}
environment = {blockedLocations: [{xAxis: 2, yAxis: 1}, {xAxis: 2, yAxis: 2}, {xAxis: 2, yAxis: 3}], worldSize: {xAxis: 10, yAxis: 10}}
```

Call the run method passing in the parameters defined above:

`aStar.run(startLocation, destination, environment)`

This returns the following shortest path:
```
[
 {xAxis: 1, yAxis: 1, gCost: 0, hCost: 30, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
 {xAxis: 2, yAxis: 0, gCost: 14, hCost: 30, fCost: 44, parent: {xAxis: 1, yAxis: 1}},
 {xAxis: 3, yAxis: 1, gCost: 28, hCost: 10, fCost: 38, parent: {xAxis: 2, yAxis: 0}},
 {xAxis: 4, yAxis: 1, gCost: 38, hCost: 0, fCost: 38, parent: {xAxis: 3, yAxis: 1}}
]
```

Visual representation:
```
y
10 . . . . . . . . . . .
 9 . . . . . . . . . . .
 8 . . . . . . . . . . .
 7 . . . . . . . . . . .
 6 . . . . . . . . . . .
 5 . . . . . . . . . . .
 4 . . . . . . . . . . .
 3 . . b . . . . . . . .
 2 . . b . . . . . . . .
 1 . x b x X . . . . . .
 0 . . x . . . . . . . .
   0 1 2 3 4 5 6 7 8 9 10 x
```

### Running the test suite

```
$ npm install
$ NODE_ENV=development jasmine-node spec/aStarSpec.js
```

##### References
http://www.policyalmanac.org/games/aStarTutorial.htm

http://en.wikipedia.org/wiki/A*

http://en.wikipedia.org/wiki/List_of_algorithms
