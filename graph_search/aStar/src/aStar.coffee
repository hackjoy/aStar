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
  if (coordinate.xAxis <= environment.worldSize.xAxis) && (coordinate.yAxis <= environment.worldSize.yAxis) && (coordinate.xAxis >= 0) && (coordinate.yAxis >= 0)
    true
  else false

# calculates the movement cost from the start to the current location based on the path generated to get there. gCost = gCost of parent + current move cost
exports.calculateGCost = (currentLocation, proposedLocation, closedList) ->
  gCost = undefined
  _.map closedList, (point) ->
    if point.id == proposedLocation.id - 1
      gCost = point.gCost + proposedLocation.cost
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

createPoint = (input, destination) ->
  startPoint = {id: input.id, xAxis: input.coordinates.xAxis, yAxis: input.coordinates.yAxis, parentID: input.parentID, gCost: input.gCost}
  startPoint.hCost = exports.calculateHCost(startPoint, destination)
  startPoint.fCost = exports.calculateFCost(startPoint)
  return startPoint

sameCoordinates = (pointA, pointB) ->
  return pointA.xAxis == pointB.xAxis && pointA.yAxis == pointB.yAxis

removeCurrentLocationFromOpenList = (openList, currentLocation) ->
  _.map openList, (coordinate) ->
    if (coordinate.xAxis == currentLocation.xAxis && coordinate.yAxis == currentLocation.yAxis)
      delete openList[(openList.indexOf(coordinate))]

# TODO: Complete full implementation
# split into small functions that .run() calls

exports.run = (destination, startCoordinates, environment) ->
  # Algorithm state variables
  coordinateIDCounter = 0
  openList = []
  closedList = []
  currentLocation = {} # updated and compared with the destination on each iteration

  # Begin with the startCoordinates as our current location
  currentLocation = createPoint({id: coordinateIDCounter, destination: destination, coordinates: startCoordinates, parentID: coordinateIDCounter, gCost: 0}, destination)
  openList.push currentLocation
  coordinateIDCounter++

  while sameCoordinates(currentLocation, destination) is false
    currentLocation = exports.findPointWithLowestFCost(openList)
    closedList.push currentLocation
    adjacentCoordinates = exports.validateCoordinates(exports.getAdjacentCoordinates(currentLocation), environment)  #TODO: Not generationg correct coordinates!!

    for adjacentCoordinate in adjacentCoordinates
      for openListCoordinate in openList
        if sameCoordinates(openListCoordinate, adjacentCoordinate)
          # It's already been added to openList so check the gCost
          if (adjacentCoordinate.gCost < openListCoordinate.gCost)
            # Found a better route so recalculate data for that point
            openListCoordinate.parentID = currentLocation.id
            openListCoordinate.gCost = exports.calculateGCost(currentLocation, openListCoordinate, destination)
            openListCoordinate.hCost = exports.calculateHCost(openListCoordinate, destination)
            openListCoordinate.fCost = exports.calculateFCost(openListCoordinate)
            removeCurrentLocationFromOpenList(openList, currentLocation)
        else
          point = createPoint({id: coordinateIDCounter, destination: destination, coordinates: adjacentCoordinate, parentID: currentLocation.id, gCost: 0}, destination) #TODO: NEED TO CALCULATE REAL GCOST HERE!! - based on the path generated to reach this new point
          openList.push point
          coordinateIDCounter++
          removeCurrentLocationFromOpenList(openList, currentLocation)

  return closedList




