## A* Search

A special case of best-first graph search that uses heuristics to improve speed.  Works with 2D grids and can currently supports walls as obstacles within the environment. Written in CoffeeScript.


### Usage

Add `a-star-search` to your package.json and run `$ npm install`

Require aStar in your app and define the parameters of your 2D grid:

```
aStar = require 'a-star-search'
startLocation = {xAxis: 1, yAxis: 1}
destination = {xAxis: 4, yAxis: 1}
environment = {walls: [{xAxis: 2, yAxis: 1}, {xAxis: 2, yAxis: 2}, {xAxis: 2, yAxis: 3}], worldSize: {xAxis: 10, yAxis: 10}}

```

Call the run method passing in the parameters defined above:
`aStar.run(destination, startCoordinates, environment)`

This returns the following shortest path:
```
[{xAxis: 1, yAxis: 1, gCost: 0, hCost: 30, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
 {xAxis: 2, yAxis: 0, gCost: 14, hCost: 30, fCost: 44, parent: {xAxis: 1, yAxis: 1}},
 {xAxis: 3, yAxis: 1, gCost: 28, hCost: 10, fCost: 38, parent: {xAxis: 2, yAxis: 0}},
 {xAxis: 4, yAxis: 1, gCost: 38, hCost: 0, fCost: 38, parent: {xAxis: 3, yAxis: 1}}
]
```

### Running the test suite

```
$ npm install
$ grunt && NODE_ENV=development jasmine-node spec/aStarSpec.js
```

##### References
http://www.policyalmanac.org/games/aStarTutorial.htm

http://en.wikipedia.org/wiki/A*

http://en.wikipedia.org/wiki/List_of_algorithms
