_ = require('underscore');

// exports.calculateGCost = function (currentLocation, currentLocation, closedList) {
//     var previousGCost = closedList[((currentLocation) - 1)].gCost;
//     var currentMovementCost = 10;
//     return previousGCost + currentMovementCost;
// };

// calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms,
// ignoring diagonal moves and obstacles
exports.calculateHCost = function (currentLocation, destination) {
    return (Math.abs(destination["x"] - currentLocation["x"]) * 10) +
           (Math.abs(destination["y"] - currentLocation["y"]) * 10);
};

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

// exports.calculateFCost = function (currentLocation) {
//     return (currentLocation.hCost + currentLocation.gCost);
// };

// // returns {point} from the [openList] with the lowest fCost
// exports.findPointWithLowestFCost = function (openList) {
//     var pointWithLowestFCost = null;
//     forEach(openList, function (element) {
//         if (pointWithLowestFCost === null) {
//             pointWithLowestFCost = element;
//         }
//         else if (element.fCost < pointWithLowestFCost.fCost) {
//             pointWithLowestFCost = element;
//         }
//     });
//     return pointWithLowestFCost;
// };

// // receives an array of coordinates hash data [{coordinates1}, {coordinates2}, {...} ]
// // returns true if a coordinate is within the bounds of the world and is not the coordinate of a wall
// exports.validateCoordinates = function (coordinates, worldData) {
//     var coordinatesValid = true;
//     if (coordinates["x"] > worldData["xBoundary"] || coordinates["y"] > worldData["yBoundary"]) {
//         coordinatesValid = false;
//     }
//     forEach(worldData["walls"], function (element) {
//         if (coordinates["x"] == element["x"] && coordinates["y"] == element["y"]) {
//             coordinatesValid = false;
//         }
//     });
//     return coordinatesValid;
// };

// exports.generateAdjacentCoordinates = function (currentLocation, worldData) {
//     var validMovements = [];
//     var movements = [{x: 0, y: 1, cost: 10, direction: "north"},
//                      {x: 1, y: 1, cost: 14, direction: "northEast"},
//                      {x: 1, y: 0, cost: 10, direction: "east"},
//                      {x: 1, y: -1, cost: 14, direction: "southEast"},
//                      {x: 0, y: -1, cost: 10, direction: "south"},
//                      {x: -1, y: -1, cost: 14, direction: "southWest"},
//                      {x: -1, y: 0, cost: 10, direction: "west"},
//                      {x: -1, y: 1, cost: 14, direction: "northWest"}];
//     forEach(movements, function (element) {
//         element["x"] += currentLocation["x"];
//         element["y"] += currentLocation["y"];
//         if (validateCoordinates(element, worldData) === true) {
//             validMovements.push(element);
//         }
//     });
//     return validMovements;
// };




//   };
//   var openList = [];
//   var closedList = [];
//   var startPoint = {id: "0"
//                    ,parent: "0"
//                    ,x: startCoordinates["x"]
//                    ,y: startCoordinates["y"]
//                    ,gCost: 0
//                    ,hCost: calculateHCost(startCoordinates, destinationCoordinates)
//   };
//   startPoint["fCost"] = calculateFCost(startPoint);
//   openList.push(startPoint);

  // loop
  // var nextToExplore = nextfindPointWithLowestFCost(openList);
  // move nextToExplore it to the closedList
  // remove nextToExplore from the open list
  // for each adjacent square to the nextToExplore
  //   if not on the openlist, add it with nextToExplore as the parent, record f,g,h costs of the adjacent squares
  //   else if its already on the openlist check to see if path to this square has a better G cost
  //     if it is better
  //        change the parent of this square to the current square - recalcualte g and f costs of that square
  // stop if you find the destination square or the open list is empty

  // calculate the path by going from the closed list - then following the parents backwards.

// }




