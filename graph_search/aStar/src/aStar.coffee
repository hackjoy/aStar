_ = require 'underscore'

# receives coordinate object e.g. {xAxis: 3, yAxis: 3} and returns an array of 8 adjacent coordinate objects [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
exports.getAdjacentCoordinates = (currentLocation) ->
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
exports.validateCoordinates = (adjacentCoordinates, environment) ->
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

# calculates the movement cost from the start to the current location based on the path generated to get there. gCost = gCost of parent + current move cost
exports.calculateGCost = (newCoordinatesID, newCoordinatesCost, closedList) ->
  gCost = undefined
  _.map closedList, (point) ->
    if point.id == newCoordinatesID - 1
      gCost = point.gCost + newCoordinatesCost
      console.log gCost
  console.log gCost
  gCost

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
exports.calculateHCost = (currentLocation, destination) ->
  (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

exports.calculateFCost = (currentLocation) ->
  currentLocation.hCost + currentLocation.gCost

# returns point object from the openList with the lowest fCost
exports.findPointWithLowestFCost = (openList) ->
  pointWithLowestFCost = null
  _.map openList, (element) ->
    if pointWithLowestFCost == null
      pointWithLowestFCost = element
    else if (element.fCost < pointWithLowestFCost.fCost)
      pointWithLowestFCost = element
  pointWithLowestFCost

createPoint = (input, destination, closedList) ->
  point = {id: input.id, xAxis: input.coordinates.xAxis, yAxis: input.coordinates.yAxis, cost: input.cost, parentID: input.parentID}
  point.gCost = if input.id is 0 then 0 else exports.calculateGCost(point.id, point.cost, closedList)
  point.hCost = exports.calculateHCost(point, destination)
  point.fCost = exports.calculateFCost(point)
  point

sameCoordinates = (pointA, pointB) ->
  if pointA and pointB then pointA.xAxis == pointB.xAxis and pointA.yAxis == pointB.yAxis else false

removeCurrentLocationFromOpenList = (openList, currentLocation) ->
  _.map openList, (coordinate) ->
    if (coordinate.xAxis == currentLocation.xAxis and coordinate.yAxis == currentLocation.yAxis)
      delete openList[(openList.indexOf(coordinate))]

updateCoordinateCosts = (openListCoordinate, currentLocation, destination) ->
  openListCoordinate.parentID = currentLocation.id
  openListCoordinate.gCost = exports.calculateGCost(currentLocation.id, currentLocation.cost, destination)
  openListCoordinate.hCost = exports.calculateHCost(openListCoordinate, destination)
  openListCoordinate.fCost = exports.calculateFCost(openListCoordinate)
  openListCoordinate

exports.run = (destination, startCoordinates, environment) ->
  coordinateIDCounter = 0   # unique ID for coordinates
  openList = []             # list of coordinates that have been found but not yet explored
  closedList = []           # list of coordinates that form part of the shortest path
  currentLocation = {}      # updated and compared with the destination on each iteration

  # Begin with startCoordinates as our current location
  openList.push createPoint({id: coordinateIDCounter, destination: destination, coordinates: startCoordinates, cost: 0, parentID: coordinateIDCounter}, destination, closedList)
  coordinateIDCounter++

  # TODO: not assigning gCost correctly to new coordinates
  while sameCoordinates(currentLocation, destination) is false
    currentLocation = exports.findPointWithLowestFCost(openList)
    removeCurrentLocationFromOpenList(openList, currentLocation)
    closedList.push currentLocation
    adjacentCoordinates = exports.validateCoordinates(exports.getAdjacentCoordinates(currentLocation), environment)
    console.log adjacentCoordinates
    for adjacentCoordinate in adjacentCoordinates
      for openListCoordinate in openList
        if sameCoordinates(openListCoordinate, adjacentCoordinate) and (adjacentCoordinate.gCost < openListCoordinate.gCost)
          openListCoordinate = updateCoordinateCosts(openListCoordinate, currentLocation, destination)
        else
          openList.push createPoint({id: coordinateIDCounter, destination: destination, coordinates: adjacentCoordinate, cost: adjacentCoordinate.cost, parentID: currentLocation.id}, destination, closedList)
          coordinateIDCounter++
  closedList
