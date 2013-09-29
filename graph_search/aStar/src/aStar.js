// Helper methods
function forEach(array, action) {  
  for (var i = 0; i < array.length; i++) {
   action(array[i]);
  }
} 

function calculateGCost(currentCoordinates, currentCoordinatesID, closedList) {
  var previousGCost = closedList[((currentCoordinatesID) - 1)].gCost
  var currentMovementCost = 10
  return previousGCost + currentMovementCost;
}   

// calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
function calculateHCost(currentCoordinates, destinationCoordinates) {
  return (Math.abs(destinationCoordinates["x"] - currentCoordinates["x"]) * 10) + (Math.abs(destinationCoordinates["y"] - currentCoordinates["y"]) * 10)
}

function calculateFCost(currentCoordinates) {
  return (currentCoordinates["hCost"] + currentCoordinates["gCost"]);
}

// returns {point} from the [openList] with the lowest fCost 
function findPointWithLowestFCost(openList) {
  var pointWithLowestFCost = undefined
  forEach(openList, function (element) {
    if (pointWithLowestFCost == undefined) {
      pointWithLowestFCost = element; 
    }
    else if (element["fCost"] < pointWithLowestFCost["fCost"]) {
      pointWithLowestFCost = element;
    }
  });
  return pointWithLowestFCost;    
} 

// function validateCoordinates(coordinates) {
//   // check that newCoordinate is within bounds of planet and is not a wall
// }

// accepts a world data hash, start coordinates and destination coordinates hash
// function aStarSearch(worldData, startCoordinates, destinationCoordinates) {

//   var movements = {x: 0, y: 1, cost: 10, direction: "north"
//                   ,x: 1, y: 1, cost: 14}, direction: "northEast"
//                   ,x: 1, y: 0, cost: 10}, direction: "east"    
//                   ,x: 1, y: -1, cost: 14, direction: "southEast"
//                   ,x: 0, y: -1, cost: 10}, direction: "south"   
//                   ,x: -1, y: -1, cost: 14}, direction: "southWest" 
//                   ,x: -1, y: 0, cost: 10}, direction: "west"    
//                   ,x: -1, y: 1, cost: 14, direction: "northWest"
//   };
//   var openList = [];
//   var closedList = [];
//   var startPoint = {id: "0"
//                    ,parent: "0"
//                    ,x: startCoordinates["x"]
//                    ,y: startCoordinates["y"] 
//                    ,gCost: 0
//                    ,hCost: calculateHCost(startCoordinates, destinationCoordinates)  
//   };
//   startPoint["fCost"] = calculateFCost(startPoint);
//   openList.push(startPoint);

  // loop
  // var nextToExplore = nextfindPointWithLowestFCost(openList);
  // move nextToExplore it to the closedList 
  // remove nextToExplore from the open list
  // for each adjacent square to the nextToExplore 
  //   if not on the openlist, add it with nextToExplore as the parent, record f,g,h costs of the adjacent squares
  //   else if its already on the openlist check to see if path to this square has a better G cost
  //     if it is better
  //        change the parent of this square to the current square - recalcualte g and f costs of that square
  // stop if you find the destination square or the open list is empty

  // calculate the path by going from the closed list - then following the parents backwards.
 
// }




