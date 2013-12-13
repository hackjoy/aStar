_ = require('underscore');

// generates adjacent x,y coordinates. Passed a current location e.g. {x: 2 y: 4}, returns an array of 8 x,y coordinate objects
exports.getAdjacentCoordinates = function (currentLocation) {
    adjacentMovements = [{x: -1, y: 1}, {x: 0, y: 1}, {x: 1, y: 1},
                         {x: -1, y: 0}, {x: 1, y: 0},
                         {x: -1, y: -1}, {x: 0, y: -1}, {x: 1, y: -1}];
    adjacentCoordinates = _.map(adjacentMovements, function (movement) {
        movement.x += this.x;
        movement.y += this.y;
        return movement;
    }, currentLocation);
    return adjacentCoordinates;
};

// calculates the movement cost from the start to the current location based on the path generated to get there.
exports.calculateGCost = function (currentLocation, currentLocation, closedList) {
    var previousGCost = closedList[((currentLocation) - 1)].gCost;
    var currentMovementCost = 10;
    return previousGCost + currentMovementCost;
};

// calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms,
// ignoring diagonal moves and obstacles
exports.calculateHCost = function (currentLocation, destination) {
    return (Math.abs(destination.x - currentLocation.x) * 10) +
           (Math.abs(destination.y - currentLocation.y) * 10);
};

exports.calculateFCost = function (currentLocation) {
    return (currentLocation.hCost + currentLocation.gCost);
};

// returns {point} from the [openList] with the lowest fCost
exports.findPointWithLowestFCost = function (openList) {
    var pointWithLowestFCost = null;
    forEach(openList, function (element) {
        if (pointWithLowestFCost === null) {
            pointWithLowestFCost = element;
        }
        else if (element.fCost < pointWithLowestFCost.fCost) {
            pointWithLowestFCost = element;
        }
    });
    return pointWithLowestFCost;
};

// // receives an array of coordinates hash data [{coordinates1}, {coordinates2}, {...} ]
// // returns true if a coordinate is within the bounds of the world and is not the coordinate of a wall
exports.validateCoordinates = function (coordinates, worldData) {
    var coordinatesValid = true;
    if (coordinates["x"] > worldData["xBoundary"] || coordinates["y"] > worldData["yBoundary"]) {
        coordinatesValid = false;
    }
    forEach(worldData["walls"], function (element) {
        if (coordinates["x"] == element["x"] && coordinates["y"] == element["y"]) {
            coordinatesValid = false;
        }
    });
    return coordinatesValid;
};


exports.searchFor = function (destination, startLocation, environment) {
  var openList = [];
  var closedList = [];
  var idCounter = 0;

  // prepare the startLocation as the first square in openList
  start = {id: idCounter, x: startLocation.x, y: startLocation.y, parentSquare: idCounter, fCost: 0, gCost: 0, hCost: 0};
  idCounter += 1;
  openList += start;

  // loop
  // var nextToExplore = nextfindPointWithLowestFCost(openList);
  // move nextToExplore to the closedList
  // remove nextToExplore from the open list
  // for each adjacent square to the nextToExplore
  //   if not on the openlist, add it with nextToExplore as the parent, record f,g,h costs of the adjacent squares, add id
  //   else if its already on the openlist check to see if path to this square has a better G cost
  //     if it is better
  //        change the parent of this square to the current square - recalculate g and f costs of that square
  // stop if you find the destination square or the open list is empty
};