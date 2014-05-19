_ = require 'underscore'

# receives location object e.g. {xAxis: 3, yAxis: 3} and returns an array of 8 adjacent location objects [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
getAdjacentLocations = (currentLocation) ->
  adjacentMovements = [{xAxis: -1, yAxis: 1, cost: 14},  {xAxis: 0, yAxis: 1, cost: 10},  {xAxis: 1, yAxis: 1, cost: 14},
                       {xAxis: -1, yAxis: 0, cost: 10},                                   {xAxis: 1, yAxis: 0, cost: 10},
                       {xAxis: -1, yAxis: -1, cost: 14}, {xAxis: 0, yAxis: -1, cost: 10}, {xAxis: 1, yAxis: -1, cost: 14}]
  adjacentLocations = _.map(adjacentMovements, (movement) ->
    movement.xAxis += this.xAxis
    movement.yAxis += this.yAxis
    movement
  , currentLocation)
  adjacentLocations

# receives an array of coordinate objects e.g. [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ] and returns new array of *valid* coordinate objects based on the environment
validateLocations = (adjacentLocations, environment) ->
  validatedLocations = []
  _.each adjacentLocations, (location) ->
    if withinWorldBoundary(location, environment)
      valid = true
      _.each environment.walls, (wall) ->
        if (location.xAxis == wall.xAxis and location.yAxis == wall.yAxis) then valid = false
      validatedLocations.push location if valid is true
  validatedLocations

withinWorldBoundary = (location, environment) ->
  if (location.xAxis <= environment.worldSize.xAxis) and (location.yAxis <= environment.worldSize.yAxis) and (location.xAxis >= 0) and (location.yAxis >= 0) then true else false

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
calculateHCost = (currentLocation, destination) ->
  (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

# returns point object from the openList with the lowest fCost
findLocationWithLowestFCost = (openList) ->
  locationWithLowestFCost = undefined
  _.map openList, (location) ->
    locationWithLowestFCost = if locationWithLowestFCost is undefined or location.fCost < locationWithLowestFCost.fCost then location else locationWithLowestFCost
  locationWithLowestFCost

sameLocation = (pointA, pointB) ->
  if pointA and pointB then pointA.xAxis == pointB.xAxis and pointA.yAxis == pointB.yAxis else false

removeLocationFrom = (list, location) ->
  _.reject list, (el) -> el.xAxis == location.xAxis and el.yAxis == location.yAxis

createOpenListLocation = (newLocation, parentLocation, destination) ->
  point =
    parent: {xAxis: parentLocation.xAxis, yAxis: parentLocation.yAxis}
    xAxis: newLocation.xAxis
    yAxis: newLocation.yAxis
    gCost: parentLocation.gCost + newLocation.cost || 0
    hCost: calculateHCost newLocation, destination
  point.fCost = point.gCost + point.hCost
  point

exports.run = (destination, startPosition, environment) ->
  openList = []             # list of coordinates that have been found but not yet explored
  closedList = []           # list of coordinates that form part of the shortest path
  currentLocation = {}      # updated and compared with the destination on each iteration
  openList.push createOpenListLocation(startPosition, startPosition, destination) # add startPosition with itself as parent

  while sameLocation(currentLocation, destination) is false
    currentLocation = findLocationWithLowestFCost openList
    openList = removeLocationFrom(openList, currentLocation)
    closedList.push currentLocation

    adjacentLocations = validateLocations(getAdjacentLocations(currentLocation), environment)
    adjacentLocations = _.map adjacentLocations, (location) ->
      createOpenListLocation(location, currentLocation, destination)

    # check if adjacents exist in openList or closedList
    for location in adjacentLocations
      if not _.find(closedList, (el) -> el.yAxis == location.yAxis and el.xAxis == location.xAxis)
        openListMatch = _.find(openList, (el) -> el.yAxis == location.yAxis and el.xAxis == location.xAxis)
        if openListMatch and location.gCost < openListMatch.gCost
          openList = removeLocationFrom(openList, openListMatch)
          openList.push location
        else
          openList.push location
  return closedList
