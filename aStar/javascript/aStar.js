
// world = 2d array representation (see above), startCoordinates = {x:?,y:?}, destinationCoordinates = {x:?,y:?}
function aStarSearch(worldStructure, startCoordinates, destinationCoordinates) {
  var movements = {north:     {x: 0, y: 1, cost: 10} 
                  ,northEast: {x: 1, y: 1, cost: 14} 
                  ,east:      {x: 1, y: 0, cost: 10} 
                  ,southEast: {x: 1, y: -1, cost: 14}
                  ,south:     {x: 0, y: -1, cost: 10} 
                  ,southWest: {x: -1, y: -1, cost: 14} 
                  ,west:      {x: -1, y: 0, cost: 10} 
                  ,northWest: {x: -1, y: 1, cost: 14}
  };
  
  function calculateHCost(current_x, current_y) {
    return (abs(destinationCoordinates[x] - current_x) * 10) + (abs(destinationCoordinates[y] - current_y) * 10)
  }


  // add the starting position to openList
  var startPoint = {x: startCoordinates[x], y: startCoordinates[y], fCost: 0, gCost: 0, hCost: calculateHCost(startCoordinates[x],startCoordinates[y])};
  var openList = [startPoint];
  var closedList = []
  while !(destinationCoordinates in openList) {
    // pick the openList square with lowest f cost
    // calculate directions that can be moved from start - avoiding out of bounds or walls
    // add them to open list with starting point as the parent
    // add starting point to closed list and remove from open list
    // determine F cost for all in the open list >> F = G + H
            // g is movement cost from starting point to the point being analysed
            // h is estimated cost to get to destination - using straight line movements, ignorning obstacles
                   // calculateHCost(x,y)
    // pick the square with the lowest f cost unless its on the closed list
    // remove next square from openList, add to closedList           
  }
}


var worldStructure = {x_boundary: 7, y_boundary: 5, walls: [{x: 3 y: 1}, {x: 3, y: 2}, {x: 3, y: 3}]}
