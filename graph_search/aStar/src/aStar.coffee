_ = require 'underscore'

# receives a current location {xAxis: 3, yAxis: 3} and returns 8 adjacent coordinates [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
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

# receives an array of coordinate objects [{coordinates1}, {coordinates2}, {...} ] and returns new array of valid coordinates
exports.validateCoordinates = (adjacentCoordinates, environment) ->
    validatedCoordinates = []
    _.map adjacentCoordinates, (coordinate) ->
        if coordinate.xAxis <= environment.worldSize.xAxis && coordinate.yAxis <= environment.worldSize.yAxis && coordinate.xAxis >= 0 && coordinate.yAxis >= 0
            _.map environment.walls, (wall) ->
                if coordinate.xAxis != wall.xAxis && coordinate.yAxis != wall.yAxis
                    validatedCoordinates.push coordinate
    return validatedCoordinates

# calculates the movement cost from the start to the current location based on the path generated to get there. gCost = gCost of parent + current move cost
exports.calculateGCost = (currentLocation, proposedLocation, closedList) ->
    gCost = undefined
    _.map closedList, (point) ->
        if point.id == proposedLocation.id - 1
            gCost = point.gCost + proposedLocation.cost
    return gCost

# calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms,
# ignoring diagonal moves and obstacles
exports.calculateHCost = (currentLocation, destination) ->
    return (Math.abs(destination.xAxis - currentLocation.xAxis) * 10) + (Math.abs(destination.yAxis - currentLocation.yAxis) * 10)

exports.calculateFCost = (currentLocation) ->
    return currentLocation.hCost + currentLocation.gCost

# returns {point} from the [openList] with the lowest fCost
exports.findPointWithLowestFCost = (openList) ->
    pointWithLowestFCost = null
    _.map openList, (element) ->
        if pointWithLowestFCost == null
            pointWithLowestFCost = element
        else if (element.fCost < pointWithLowestFCost.fCost)
            pointWithLowestFCost = element
    return pointWithLowestFCost


createPoint = (idCounter, destination, coordinates, parentID, gCost) ->
    startPoint = {id: idCounter, xAxis: coordinates.xAxis, yAxis: coordinates.yAxis, parentID: parentID, gCost: gCost}
    startPoint.hCost = exports.calculateHCost(startPoint, destination)
    startPoint.fCost = exports.calculateFCost(startPoint)
    idCounter++
    return startPoint

sameCoordinates = (pointA, pointB) ->
  return pointA.xAxis == pointB.xAxis && pointA.yAxis == pointB.yAxis

removeCurrentLocationFromOpenList = (openList, currentLocation) ->
    _.map openList, (coordinate) ->
        if (coordinate.xAxis == currentLocation.xAxis && coordinate.yAxis == currentLocation.yAxis)
            delete openList[(openList.indexOf(coordinate))] # remove currentLocation from open list

exports.run = (destination, startCoordinates, environment) ->
    openList = []
    closedList = []
    idCounter = 0

    currentLocation = createPoint(idCounter, destination, startCoordinates, 0, 0)
    openList.push currentLocation

    while true
        if sameCoordinates(currentLocation, destination)
            break
        else
            currentLocation = exports.findPointWithLowestFCostopenList(openList)
            closedList.push currentLocation # add to shortest path
            removeCurrentLocationFromOpenList(openList, currentLocation)

            adjacentCoordinates = exports.validateCoordinates(exports.getAdjacentCoordinates(currentLocation), environment)
            _.map adjacentCoordinates, (adjacentCoordinate) ->
                _.map openList, (openListCoordinate) ->
                    if sameCoordinates(openListCoordinate, adjacentCoordinate)  # already been added to openList
                        if (adjacentCoordinate.gCost < openListCoordinate.gCost) # recalculate data for that point
                            openListCoordinate.parentID = currentLocation.id
                            openListCoordinate.gCost = exports.calculateGCost(currentLocation, openListCoordinate, destination)
                            openListCoordinate.hCost = exports.calculateHCost(openListCoordinate, destination)
                            openListCoordinate.fCost = exports.calculateFCost(openListCoordinate)
                    else # add new point to openList
                        point = createPoint(idCounter, destination, adjacentCoordinate, currentLocation.id, 0)
                        openList.push point
                        #TODO: G cost value should not be 0 - it should be based on the path generated to reach this new point
    return closedList # contains the shortest path
