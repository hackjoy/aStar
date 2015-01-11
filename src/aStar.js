var calculateHCost, createOpenListLocation, existsInClosedList, findLocationWithLowestFCost, generateAdjacentLocations, getAdjacentLocations, removeLocationFrom, run, sameLocation, updateOpenList, validateLocations, withinWorldBoundary, _;

_ = require('underscore');

generateAdjacentLocations = function(currentLocation) {
  var adjacentLocations, adjacentMovements;
  adjacentMovements = [
    {
      xAxis: -1,
      yAxis: 1,
      cost: 14
    }, {
      xAxis: 0,
      yAxis: 1,
      cost: 10
    }, {
      xAxis: 1,
      yAxis: 1,
      cost: 14
    }, {
      xAxis: -1,
      yAxis: 0,
      cost: 10
    }, {
      xAxis: 1,
      yAxis: 0,
      cost: 10
    }, {
      xAxis: -1,
      yAxis: -1,
      cost: 14
    }, {
      xAxis: 0,
      yAxis: -1,
      cost: 10
    }, {
      xAxis: 1,
      yAxis: -1,
      cost: 14
    }
  ];
  adjacentLocations = _.map(adjacentMovements, function(movement) {
    movement.xAxis += this.xAxis;
    movement.yAxis += this.yAxis;
    return movement;
  }, currentLocation);
  return adjacentLocations;
};

validateLocations = function(adjacentLocations, environment) {
  var validLocations;
  validLocations = _.filter(adjacentLocations, function(location) {
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

getAdjacentLocations = function(currentLocation, environment, destination) {
  var adjacentLocations;
  adjacentLocations = validateLocations(generateAdjacentLocations(currentLocation), environment);
  adjacentLocations = _.map(adjacentLocations, function(location) {
    return createOpenListLocation(location, currentLocation, destination);
  });
  return adjacentLocations;
};

withinWorldBoundary = function(location, environment) {
  if ((location.xAxis <= environment.worldSize.xAxis) && (location.yAxis <= environment.worldSize.yAxis) && (location.xAxis >= 0) && (location.yAxis >= 0)) {
    return true;
  } else {
    return false;
  }
};

calculateHCost = function(currentLocation, destination) {
  return (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10);
};

findLocationWithLowestFCost = function(openList) {
  var locationWithLowestFCost;
  locationWithLowestFCost = void 0;
  _.map(openList, function(location) {
    return locationWithLowestFCost = locationWithLowestFCost === void 0 || location.fCost < locationWithLowestFCost.fCost ? location : locationWithLowestFCost;
  });
  return locationWithLowestFCost;
};

sameLocation = function(locationA, locationB) {
  if (locationA && locationB) {
    return locationA.xAxis === locationB.xAxis && locationA.yAxis === locationB.yAxis;
  } else {
    return false;
  }
};

removeLocationFrom = function(list, location) {
  return _.reject(list, function(el) {
    return el.xAxis === location.xAxis && el.yAxis === location.yAxis;
  });
};

createOpenListLocation = function(newLocation, parentLocation, destination) {
  var location;
  location = {
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

existsInClosedList = function(closedList, location) {
  return _.find(closedList, function(el) {
    return el.yAxis === location.yAxis && el.xAxis === location.xAxis;
  });
};

updateOpenList = function(openList, location, closedList) {
  var openListMatch;
  if (!existsInClosedList(closedList, location)) {
    openListMatch = _.find(openList, function(el) {
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

run = function(startLocation, destination, environment) {
  var adjacentLocations, closedList, currentLocation, location, openList, _i, _len;
  openList = [createOpenListLocation(startLocation, startLocation, destination)];
  closedList = [];
  currentLocation = {};
  while (!sameLocation(currentLocation, destination)) {
    currentLocation = findLocationWithLowestFCost(openList);
    openList = removeLocationFrom(openList, currentLocation);
    closedList.push(currentLocation);
    adjacentLocations = getAdjacentLocations(currentLocation, environment, destination);
    for (_i = 0, _len = adjacentLocations.length; _i < _len; _i++) {
      location = adjacentLocations[_i];
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
