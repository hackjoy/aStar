_ = require('underscore');

exports.searchFor = function (destination, startLocation, environment) {
    var openList = [];
    var closedList = [];
    var idCounter = 2;
    // add startLocation to the openList
    co = {id: 1, xAxis: startLocation.xAxis, yAxis: startLocation.yAxis, parentSquare: 0, gCost: 0};
    co.hCost = exports.calculateHCost(co, destination);
    co.fCost = exports.calculateFCost(co);
    openList.push(co);
    var currentLocation = co;

    while (true) {
        if (currentLocation.xAxis == destination.xAxis && currentLocation.yAxis == destination.yAxis) {
            break; // we reached the destination
        } else {
            var nextToExplore = currentLocation = exports.findPointWithLowestFCost(openList);
            closedList.push(nextToExplore);
            _.map(openList, function (coordinate) {
                if (coordinate.xAxis == nextToExplore.xAxis && coordinate.yAxis == nextToExplore.yAxis) {
                    delete openList[(openList.indexOf(coordinate))]; // remove nextToExplore from open list
                }
            });
            // get the adjacent coordinates, check if each exists on the open list
            var adjacentCoordinates = exports.validateCoordinates(exports.getAdjacentCoordinates(nextToExplore), environment);
            _.map(adjacentCoordinates, function (adjacentCoordinate) {
                _.map(openList, function (openListCoordinate) {
                    if (openListCoordinate.xAxis == nextToExplore.xAxis && openListCoordinate.yAxis == nextToExplore.yAxis) {
                        // check to see if path to this square has a better G cost than the one currently on the openList
                        //      if it is better
                        //        change the parent of this square to the current square - recalculate g and f costs of that square
                    } else {
                        // add adjacentCoordinate to openList with nextToExplore as the parent
                        co = {id: idCounter, xAxis: adjacentCoordinate.xAxis, yAxis: adjacentCoordinate.yAxis, parentSquare: nextToExplore.id, gCost: 0};
                        co.hCost = exports.calculateHCost(co, destination);
                        co.fCost = exports.calculateFCost(co);
                        openList.push(co);
                    }
                });
            });
        }
    }
    return closedList; // shortest path
};

// receives a current location {xAxis: 3, yAxis: 3} and returns 8 adjacent coordinates [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
exports.getAdjacentCoordinates = function (currentLocation) {
    adjacentMovements = [{xAxis: -1, yAxis: 1, cost: 14},  {xAxis: 0, yAxis: 1, cost: 10},  {xAxis: 1, yAxis: 1, cost: 14},
                         {xAxis: -1, yAxis: 0, cost: 10},                                   {xAxis: 1, yAxis: 0, cost: 10},
                         {xAxis: -1, yAxis: -1, cost: 14}, {xAxis: 0, yAxis: -1, cost: 10}, {xAxis: 1, yAxis: -1, cost: 14}];
    adjacentCoordinates = _.map(adjacentMovements, function (movement) {
        movement.xAxis += this.xAxis;
        movement.yAxis += this.yAxis;
        return movement;
    }, currentLocation);
    return adjacentCoordinates;
};

// receives an array of coordinate objects [{coordinates1}, {coordinates2}, {...} ] and returns new array of valid coordinates
exports.validateCoordinates = function (adjacentCoordinates, environment) {
    var validatedCoordinates = [];
    _.map(adjacentCoordinates, function(coordinate) {
        if (coordinate.xAxis <= environment.worldSize.xAxis && coordinate.yAxis <= environment.worldSize.yAxis &&
            coordinate.xAxis >= 0 && coordinate.yAxis >= 0) {
            _.map(environment.walls, function (wall) {
                if (coordinate.xAxis == wall.xAxis && coordinate.yAxis == wall.yAxis) {
                    // don't include it
                } else {
                    validatedCoordinates.push(coordinate);
                }
            });
        }
    });
    return validatedCoordinates;
};

// calculates the movement cost from the start to the current location based on the path generated to get there. gCost = gCost of parent + current move cost
exports.calculateGCost = function (currentLocation, proposedLocation, closedList) {
    var gCost;
    _.map(closedList, function (point) {
        if (point.id == proposedLocation.id - 1) {
            gCost = point.gCost + proposedLocation.cost;
        }
    });
    return gCost;
};

// calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms,
// ignoring diagonal moves and obstacles
exports.calculateHCost = function (currentLocation, destination) {
    return (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) +
           (Math.abs(destination.yAxis - currentLocation.yAxis) * 10);
};

exports.calculateFCost = function (currentLocation) {
    return (currentLocation.hCost + currentLocation.gCost);
};

// returns {point} from the [openList] with the lowest fCost
exports.findPointWithLowestFCost = function (openList) {
    var pointWithLowestFCost = null;
    _.map(openList, function (element) {
        if (pointWithLowestFCost === null) {
            pointWithLowestFCost = element;
        }
        else if (element.fCost < pointWithLowestFCost.fCost) {
            pointWithLowestFCost = element;
        }
    });
    return pointWithLowestFCost;
};

