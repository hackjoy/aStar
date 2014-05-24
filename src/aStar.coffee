_ = require 'underscore'

# receives location object e.g. {xAxis: 3, yAxis: 3} and returns an array of 8 adjacent location objects [{xAxis: 2, yAxis: 3}, {xAxis: 3, yAxis: 2} ... ]
generateAdjacentLocations = (currentLocation) ->
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
  validLocations = _.filter adjacentLocations, (location) ->
    withinWorldBoundary location, environment
  if environment.walls
    validLocations = _.filter validLocations, (location) ->
      not _.find environment.walls, (wall) -> wall.yAxis == location.yAxis and wall.xAxis == location.xAxis
  validLocations

getAdjacentLocations = (currentLocation, environment, destination) ->
  adjacentLocations = validateLocations(generateAdjacentLocations(currentLocation), environment)
  adjacentLocations = _.map adjacentLocations, (location) -> createOpenListLocation(location, currentLocation, destination)
  adjacentLocations

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
    parent:
      xAxis: parentLocation.xAxis,
      yAxis: parentLocation.yAxis
    xAxis: newLocation.xAxis
    yAxis: newLocation.yAxis
    gCost: parentLocation.gCost + newLocation.cost || 0
    hCost: calculateHCost newLocation, destination
  point.fCost = point.gCost + point.hCost
  point

existsInClosedList = (closedList, location) ->
  _.find closedList, (el) -> el.yAxis == location.yAxis and el.xAxis == location.xAxis

updateOpenList = (openList, location, closedList) ->
  if not existsInClosedList closedList, location
    openListMatch = _.find(openList, (el) -> el.yAxis == location.yAxis and el.xAxis == location.xAxis)
    if not openListMatch
      openList.push location
    else if openListMatch.gCost > location.gCost
      openList = removeLocationFrom openList, openListMatch
      openList.push location
  openList

run = (startLocation, destination, environment) ->
  openList = [createOpenListLocation(startLocation, startLocation, destination)] # coordinates found but not explored yet - init with startLocation
  closedList = [] # coorindates explored which form the shortest path
  currentLocation = {} # updated and compared with the destination on each iteration
  while not sameLocation currentLocation, destination
    currentLocation = findLocationWithLowestFCost openList
    openList = removeLocationFrom openList, currentLocation
    closedList.push currentLocation
    adjacentLocations = getAdjacentLocations currentLocation, environment, destination
    for location in adjacentLocations
      openList = updateOpenList openList, location, closedList
  return closedList

module.exports =
  switch process.env.NODE_ENV
    when 'development'
      generateAdjacentLocations: generateAdjacentLocations
      validateLocations: validateLocations
      getAdjacentLocations: getAdjacentLocations
      withinWorldBoundary: withinWorldBoundary
      calculateHCost: calculateHCost
      findLocationWithLowestFCost: findLocationWithLowestFCost
      sameLocation: sameLocation
      removeLocationFrom: removeLocationFrom
      createOpenListLocation: createOpenListLocation
      existsInClosedList: existsInClosedList
      updateOpenList: updateOpenList
      run: run
    else
      run: run
