_ = require 'underscore'

# receives coordinate object e.g. {xAxis: 3, yAxis: 3} and returns an array of 8 adjacent coordinate objects [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
getAdjacentCoordinates = (currentLocation) ->
  adjacentMovements = [{xAxis: -1, yAxis: 1, cost: 14},  {xAxis: 0, yAxis: 1, cost: 10},  {xAxis: 1, yAxis: 1, cost: 14},
                       {xAxis: -1, yAxis: 0, cost: 10},                                   {xAxis: 1, yAxis: 0, cost: 10},
                       {xAxis: -1, yAxis: -1, cost: 14}, {xAxis: 0, yAxis: -1, cost: 10}, {xAxis: 1, yAxis: -1, cost: 14}]
  adjacentCoordinates = _.map(adjacentMovements, (movement) ->
    movement.xAxis += this.xAxis
    movement.yAxis += this.yAxis
    movement
  , currentLocation)
  adjacentCoordinates

# receives an array of coordinate objects e.g. [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ] and returns new array of *valid* coordinate objects based on the environment
validateCoordinates = (adjacentCoordinates, environment) ->
  validatedCoordinates = []
  _.each adjacentCoordinates, (coordinate) ->
    if withinWorldBoundary(coordinate, environment)
      valid = true
      _.each environment.walls, (wall) ->
        if (coordinate.xAxis == wall.xAxis and coordinate.yAxis == wall.yAxis) then valid = false
      validatedCoordinates.push coordinate if valid is true
  validatedCoordinates

withinWorldBoundary = (coordinate, environment) ->
  true if (coordinate.xAxis <= environment.worldSize.xAxis) and (coordinate.yAxis <= environment.worldSize.yAxis) and (coordinate.xAxis >= 0) and (coordinate.yAxis >= 0)

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
calculateHCost = (currentLocation, destination) ->
  (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

# returns point object from the openList with the lowest fCost
findPointWithLowestFCost = (openList) ->
  pointWithLowestFCost = null
  _.map openList, (element) ->
    if pointWithLowestFCost == null
      pointWithLowestFCost = element
    else if (element.fCost < pointWithLowestFCost.fCost)
      pointWithLowestFCost = element
  pointWithLowestFCost

sameCoordinates = (pointA, pointB) ->
  if pointA and pointB then pointA.xAxis == pointB.xAxis and pointA.yAxis == pointB.yAxis else false

removeCoordinateFrom = (list, coordinate) ->
  _.reject list, (coordinate) ->
    coordinate.xAxis == coordinate.xAxis and coordinate.yAxis == coordinate.yAxis

updateCoordinateCosts = (openListCoordinate, location, destination) ->
  openListCoordinate.parentID = location.parentID
  openListCoordinate.gCost = location.gCost
  openListCoordinate.fCost = location.gCost + location.hCost
  openListCoordinate

createOpenListCoordinate = (input, location, destination, IDCounter) ->
  point =
    id: IDCounter
    parentID: input.parentID
    xAxis: location.xAxis
    yAxis: location.yAxis
    gCost: input.gCost
    hCost: calculateHCost location, destination
  point.fCost = point.gCost + point.hCost
  IDCounter++
  point

exports.run = (destination, startPosition, environment) ->
  openList = []             # list of coordinates that have been found but not yet explored
  closedList = []           # list of coordinates that form part of the shortest path
  currentLocation = {}      # updated and compared with the destination on each iteration
  IDCounter = 0             # unique ID for coordinates

  openList.push createOpenListCoordinate({parentID: 0, gCost: 0}, startPosition, destination, IDCounter)

  while sameCoordinates currentLocation, destination is false
    currentLocation = findPointWithLowestFCost openList
    openList = removeCoordinateFrom openList, currentLocation
    closedList.push currentLocation

    adjacentLocations = validateCoordinates(getAdjacentCoordinates currentLocation, environment)
    adjacentLocations = _.map adjacentLocations, (location) ->
      createOpenListCoordinate({parentID: currentLocation.id, gCost: currentLocation.gCost + location.gCost}, location, destination, IDCounter)

    for location in adjacentLocations
      for openListCoordinate in openList
        if sameCoordinates openListCoordinate, location and location.gCost < openListCoordinate.gCost
          openListCoordinate = updateCoordinateCosts openListCoordinate, location, destination
        else
          openList.push location
  closedList
