_ = require('underscore');

exports.searchFor = function (destination, startLocation, environment) {
    var openList = [];
    var closedList = [];

    // prepare the startLocation as the first square in openList
    start = {id: 1, xAxis: startLocation.xAxis, yAxis: startLocation.yAxis, parentSquare: 0, gCost: 0};
    start.hCost = exports.calculateHCost(start, destination);
    start.fCost = exports.calculateFCost(start);
    openList.push(start);

    var idCounter = 2;
    var currentLocation = start;
    while (true) {
        if (currentLocation.xAxis == destination.xAxis && currentLocation.yAxis == destination.yAxis) {
            break;
        } else {
            // var nextToExplore = nextfindPointWithLowestFCost(openList);
            // add nextToExplore to the closedList
            // remove nextToExplore from the open list
            // get adjacent squares to nextToExplore
            // for each adjacent square
            //   if not on the openlist
            //      add it with nextToExplore as the parent, record f,g,h costs of the adjacent square, add id
            //   else
            //      check to see if path to this square has a better G cost than the one currently on the openList
            //      if it is better
            //        change the parent of this square to the current square - recalculate g and f costs of that square
        }
    }
    // return the shortest path
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
    })
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

