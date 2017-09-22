var _ = require('underscore');

var generateAdjacentLocations = function(currentLocation) {
  var possibleAdjacentMovements = [
    { xAxis: -1, yAxis: 1, cost: 14 },
    { xAxis: 0, yAxis: 1, cost: 10 },
    { xAxis: 1, yAxis: 1, cost: 14 },
    { xAxis: -1, yAxis: 0, cost: 10 },
    { xAxis: 1, yAxis: 0, cost: 10 },
    { xAxis: -1, yAxis: -1, cost: 14 },
    { xAxis: 0, yAxis: -1, cost: 10 },
    { xAxis: 1, yAxis: -1, cost: 14 }
  ];
  var adjacentLocations = _.map(
    possibleAdjacentMovements,
    function(movement) {
      movement.xAxis += this.xAxis;
      movement.yAxis += this.yAxis;
      return movement;
    },
    currentLocation
  );

  return adjacentLocations;
};

var validateLocations = function(adjacentLocations, environment) {
  var validLocations = _.filter(adjacentLocations, function(location) {
    return withinWorldBoundary(location, environment);
  });

  if (environment.blockedLocations) {
    validLocations = _.filter(validLocations, function(location) {
      return !_.find(environment.blockedLocations, function(blockLocation) {
        return blockLocation.yAxis === location.yAxis && blockLocation.xAxis === location.xAxis;
      });
    });
  }

  return validLocations;
};

var getAdjacentLocations = function(currentLocation, environment, destination) {
  var adjacentLocations = validateLocations(generateAdjacentLocations(currentLocation), environment);
  return _.map(adjacentLocations, function(location) {
    return createOpenListLocation(location, currentLocation, destination);
  });
};

var withinWorldBoundary = function(location, environment) {
  return (
    (location.xAxis <= environment.worldSize.xAxis) &&
    (location.yAxis <= environment.worldSize.yAxis) &&
    (location.xAxis >= 0) &&
    (location.yAxis >= 0)
  );
};

var calculateHCost = function(currentLocation, destination) {
  return (
    (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) +
    (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)
  );
};

var findLocationWithLowestFCost = function(openList) {
  return _.min(openList, function(location) { return location.fCost });
};

var sameLocation = function(locationA, locationB) {
  if (locationA && locationB) {
    return locationA.xAxis === locationB.xAxis && locationA.yAxis === locationB.yAxis;
  }

  return false;
};

removeLocationFrom = function(list, location) {
  return _.reject(list, function(el) {
    return el.xAxis === location.xAxis && el.yAxis === location.yAxis;
  });
};

var createOpenListLocation = function(newLocation, parentLocation, destination) {
  var location = {
    parent: {
      xAxis: parentLocation.xAxis,
      yAxis: parentLocation.yAxis
    },
    xAxis: newLocation.xAxis,
    yAxis: newLocation.yAxis,
    gCost: parentLocation.gCost + newLocation.cost || 0,
    hCost: calculateHCost(newLocation, destination)
  };
  location.fCost = location.gCost + location.hCost;
  return location;
};

var existsInClosedList = function(closedList, location) {
  return _.find(closedList, function(el) {
    return el.yAxis === location.yAxis && el.xAxis === location.xAxis;
  });
};

var updateOpenList = function(openList, location, closedList) {
  if (!existsInClosedList(closedList, location)) {
    var openListMatch = _.find(openList, function(el) {
      return el.yAxis === location.yAxis && el.xAxis === location.xAxis;
    });

    if (!openListMatch) {
      openList.push(location);
    } else if (openListMatch.gCost > location.gCost) {
      openList = removeLocationFrom(openList, openListMatch);
      openList.push(location);
    }
  }
  return openList;
};

var run = function(startLocation, destination, environment) {
  var openList = [createOpenListLocation(startLocation, startLocation, destination)];
  var closedList = [];
  var currentLocation = {};

  while (!sameLocation(currentLocation, destination)) {
    currentLocation = findLocationWithLowestFCost(openList);
    openList = removeLocationFrom(openList, currentLocation);
    closedList.push(currentLocation);
    var adjacentLocations = getAdjacentLocations(currentLocation, environment, destination);

    for (var i = 0; i < adjacentLocations.length; i++) {
      var location = adjacentLocations[i];
      openList = updateOpenList(openList, location, closedList);
    }
  }

  return closedList;
};

module.exports = (function() {
  switch (process.env.NODE_ENV) {
    case 'development':
      return {
        generateAdjacentLocations: generateAdjacentLocations,
        validateLocations: validateLocations,
        getAdjacentLocations: getAdjacentLocations,
        withinWorldBoundary: withinWorldBoundary,
        calculateHCost: calculateHCost,
        findLocationWithLowestFCost: findLocationWithLowestFCost,
        sameLocation: sameLocation,
        removeLocationFrom: removeLocationFrom,
        createOpenListLocation: createOpenListLocation,
        existsInClosedList: existsInClosedList,
        updateOpenList: updateOpenList,
        run: run
      };
    default:
      return {
        run: run
      };
  }
})();
