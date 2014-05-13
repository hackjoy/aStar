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
  true if (location.xAxis <= environment.worldSize.xAxis) and (location.yAxis <= environment.worldSize.yAxis) and (location.xAxis >= 0) and (location.yAxis >= 0)

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
calculateHCost = (currentLocation, destination) ->
  (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

# returns point object from the openList with the lowest fCost
findLocationWithLowestFCost = (openList) ->
  locationWithLowestFCost = undefined
  _.map openList, (location) ->
    locationWithLowestFCost = if locationWithLowestFCost is undefined or location.fCost < locationWithLowestFCost.fCost then location
  locationWithLowestFCost

sameLocation = (pointA, pointB) ->
  if pointA and pointB then pointA.xAxis == pointB.xAxis and pointA.yAxis == pointB.yAxis

removeLocationFrom = (list, location) ->
  _.reject list, (el) -> el.xAxis == location.xAxis and el.yAxis == location.yAxis

updateLocationCosts = (openListLocation, location, destination) ->
  openListLocation.parentID = location.parentID
  openListLocation.gCost = location.gCost
  openListLocation.fCost = location.fCost
  openListLocation

createOpenListLocation = (input, location, destination, IDCounter) ->
  point =
    id: IDCounter
    parentID: input.parentID
    xAxis: location.xAxis
    yAxis: location.yAxis
    gCost: input.gCost
    hCost: calculateHCost location, destination
  point.fCost = point.gCost + point.hCost

  point

exports.run = (destination, startPosition, environment) ->
  openList = []             # list of coordinates that have been found but not yet explored
  closedList = []           # list of coordinates that form part of the shortest path
  currentLocation = {}      # updated and compared with the destination on each iteration
  IDCounter = 0             # unique ID for coordinates
  openList.push createOpenListLocation({parentID: 0, gCost: 0}, startPosition, destination, IDCounter) # add startPosition

  while sameLocation(currentLocation, destination) is false
    currentLocation = findLocationWithLowestFCost openList
    openList = removeLocationFrom(openList, currentLocation)
    closedList.push currentLocation

    adjacentLocations = validateLocations(getAdjacentLocations(currentLocation), environment)
    adjacentLocations = _.map adjacentLocations, (location) ->
      IDCounter++
      createOpenListLocation({parentID: currentLocation.id, gCost: currentLocation.gCost + location.cost}, location, destination, IDCounter)

    # check if adjacents already exist in open list
    for location in adjacentLocations
      openListMatch = _.find(openList, (el) -> el.yAxis == location.yAxis && el.xAxis == location.yAxis)
      if openListMatch and location.gCost < openListMatch.gCost
        openList = removeLocationFrom(openList, openListMatch)
        openList.push location
      else
        openList.push location
  closedList
