// Helper methods
function forEach(array, action) {  
  for (var i = 0; i < array.length; i++) {
   action(array[i]);
  }
} 

 // NEED TO THINK ABOUT TRACING PARENT SQuares and how ther are stored in the algorithm
function calculateGCost(movementsFromStartToCurrentCoordinates) {
  gCost = 0;
  for (point in movementsFromStartToCurrentCoordinates) {
    gCost += point["movementCost"];
  }    
}   

// calculates estimated distance to the destination co-ordinates from current co-ordinates in absolute terms, ignoring diagonal moves and obstacles
function calculateHCost(currentCoordinates, destinationCoordinates) {
  return (Math.abs(destinationCoordinates["x"] - currentCoordinates["x"]) * 10) + (Math.abs(destinationCoordinates["y"] - currentCoordinates["y"]) * 10)
}

function calculateFCost(startPoint) {
  return (startPoint["hCost"] + startPoint["gCost"]);
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

function checkCoordinateIsValid(coordinate) {
  // check that newCoordinate is within bounds of planet and is not a wall
}

// accepts a world data hash, start coordinates and destination coordinates hash
function aStarSearch(worldData, startCoordinates, destinationCoordinates) {

  var movements = {north:     {x: 0, y: 1, cost: 10}
                  ,northEast: {x: 1, y: 1, cost: 14} 
                  ,east:      {x: 1, y: 0, cost: 10} 
                  ,southEast: {x: 1, y: -1, cost: 14}
                  ,south:     {x: 0, y: -1, cost: 10} 
                  ,southWest: {x: -1, y: -1, cost: 14} 
                  ,west:      {x: -1, y: 0, cost: 10} 
                  ,northWest: {x: -1, y: 1, cost: 14}
  };
  var openList = [];
  var closedList = [];
  var startPoint = {id: "0"
                   ,parent: "0"
                   ,x: startCoordinates["x"]
                   ,y: startCoordinates["y"] 
                   ,gCost: 0
                   ,hCost: calculateHCost(startCoordinates, destinationCoordinates)  
  };
  startPoint["fCost"] = calculateFCost(startPoint);
  openList.push(startPoint);

  // LOOPING MAIN OPERATION OF THE A STAR SEARCH
  // while !(nextSquareWIthLowestFCost.fCost == destinationCoordinates) {
  // var nextSquareWithLowestFCost = findPointWithLowestFCost(openList);  
  //   closedList.push(nextSquareWithLowestFCost)  // move lowest fcost to the closed list
  //   remove nextSquareWIthLoestFCost from the openList
  return 0;
}