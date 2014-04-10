_ = require 'underscore'

# receives coordinate object e.g. {xAxis: 3, yAxis: 3} and returns an array of 8 adjacent coordinate objects [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
exports.getAdjacentCoordinates = (currentLocation) ->
  adjacentMovements = [{xAxis: -1, yAxis: 1, cost: 14},  {xAxis: 0, yAxis: 1, cost: 10},  {xAxis: 1, yAxis: 1, cost: 14},
                       {xAxis: -1, yAxis: 0, cost: 10},                                   {xAxis: 1, yAxis: 0, cost: 10},
                       {xAxis: -1, yAxis: -1, cost: 14}, {xAxis: 0, yAxis: -1, cost: 10}, {xAxis: 1, yAxis: -1, cost: 14}]
  adjacentCoordinates = _.map(adjacentMovements, (movement) ->
    movement.xAxis += this.xAxis
    movement.yAxis += this.yAxis
    return movement
  , currentLocation)
  return adjacentCoordinates

# receives an array of coordinate objects [{coordinates1}, {coordinates2}, {...} ] and returns new array of *valid* coordinate objects based on the environment parameters
exports.validateCoordinates = (adjacentCoordinates, environment) ->
  validatedCoordinates = []
  _.each adjacentCoordinates, (coordinate) ->
    if withinWorldBoundary(coordinate, environment)
      valid = true
      _.each environment.walls, (wall) ->
        if coordinate.xAxis == wall.xAxis && coordinate.yAxis == wall.yAxis
          valid = false
      validatedCoordinates.push coordinate if valid is true
  return validatedCoordinates

withinWorldBoundary = (coordinate, environment) ->
  true if (coordinate.xAxis <= environment.worldSize.xAxis) && (coordinate.yAxis <= environment.worldSize.yAxis) && (coordinate.xAxis >= 0) && (coordinate.yAxis >= 0)

# calculates the movement cost from the start to the current location based on the path generated to get there. gCost = gCost of parent + current move cost
exports.calculateGCost = (newCoordinatesID, newCoordinatesCost, closedList) ->
  gCost = undefined
  _.map closedList, (point) ->
    if point.id == newCoordinatesID - 1
      gCost = point.gCost + newCoordinatesCost
  return gCost

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
exports.calculateHCost = (currentLocation, destination) ->
  return (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

exports.calculateFCost = (currentLocation) ->
  return currentLocation.hCost + currentLocation.gCost

# returns point object from the openList with the lowest fCost
exports.findPointWithLowestFCost = (openList) ->
  pointWithLowestFCost = null
  _.map openList, (element) ->
    if pointWithLowestFCost == null
      pointWithLowestFCost = element
    else if (element.fCost < pointWithLowestFCost.fCost)
      pointWithLowestFCost = element
  return pointWithLowestFCost

createPoint = (input, destination, closedList) ->
  point = {id: input.id, xAxis: input.coordinates.xAxis, yAxis: input.coordinates.yAxis, cost: input.cost, parentID: input.parentID, gCost: input.gCost}
  point.gCost = if closedList then exports.calculateGCost(point.id, point.cost, closedList) else 0
  point.hCost = exports.calculateHCost(point, destination)
  point.fCost = exports.calculateFCost(point)
  return point

sameCoordinates = (pointA, pointB) ->
  return pointA.xAxis == pointB.xAxis && pointA.yAxis == pointB.yAxis

removeCurrentLocationFromOpenList = (openList, currentLocation) ->
  _.map openList, (coordinate) ->
    if (coordinate.xAxis == currentLocation.xAxis && coordinate.yAxis == currentLocation.yAxis)
      delete openList[(openList.indexOf(coordinate))]

updateCoordinateCosts = (openListCoordinate, currentLocation, destination) ->
  openListCoordinate.parentID = currentLocation.id
  openListCoordinate.gCost = exports.calculateGCost(currentLocation.id, currentLocation.cost, destination)
  openListCoordinate.hCost = exports.calculateHCost(openListCoordinate, destination)
  openListCoordinate.fCost = exports.calculateFCost(openListCoordinate)
  return openListCoordinate

# TODO: Complete full implementation & split into small functions that .run() calls
exports.run = (destination, startCoordinates, environment) ->
  coordinateIDCounter = 0   # unique ID for coordinates
  openList = []             # list of coordinates that have been found but not yet explored
  closedList = []           # list of coordinates that form part of the shortest path
  currentLocation = {}      # updated and compared with the destination on each iteration

  # Begin with startCoordinates as our current location
  currentLocation = createPoint({id: coordinateIDCounter, destination: destination, coordinates: startCoordinates, cost: 0, parentID: coordinateIDCounter, gCost: 0}, destination)
  openList.push currentLocation
  coordinateIDCounter++

  # TODO: its stuck in the loop
  while sameCoordinates(currentLocation, destination) is false
    # console.log "Lowest F Cost: #{JSON.stringify(exports.findPointWithLowestFCost(openList))}"
    currentLocation = exports.findPointWithLowestFCost(openList)
    removeCurrentLocationFromOpenList(openList, currentLocation)
    closedList.push currentLocation
    adjacentCoordinates = exports.validateCoordinates(exports.getAdjacentCoordinates(currentLocation), environment)

    _.each adjacentCoordinates, (adjacentCoordinate) ->
      _.each openList, (openListCoordinate) ->
        if sameCoordinates(openListCoordinate, adjacentCoordinate) and (adjacentCoordinate.gCost < openListCoordinate.gCost)
          openListCoordinate = updateCoordinateCosts(openListCoordinate, currentLocation, destination)
        else
          point = createPoint({id: coordinateIDCounter, destination: destination, coordinates: adjacentCoordinate, cost: adjacentCoordinate.cost, parentID: currentLocation.id}, destination, closedList)
          openList.push point
          coordinateIDCounter++

  return closedList

