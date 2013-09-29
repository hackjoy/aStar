describe("A* search", function() {

  beforeEach(function () {
    
  });

  // actual distance from current square to start position
  it("should calculate the G cost of the current coordinates", function() {  
    var visitedCoordinates1 = {x: 1, y: 1, fCost: 30, gCost: 0, hCost: 30, parent: 1};
    var visitedCoordinates2 = {x: 2, y: 1, fCost: 30, gCost: 10, hCost: 20, parent: 1};
    var closedList = {1: visitedCoordinates1, 2: visitedCoordinates2};
    var currentCoordinates = {x: 3, y: 1};
    var currentCoordinatesID = 3
    var gCost = calculateGCost(currentCoordinates, currentCoordinatesID, closedList);
    expect(gCost).toEqual(20);   
  });

  // estimated distance from current square to destination
  it("should calculate the H cost of the current coordinates", function() {  
    var currentCoordinates = {x: 3, y: 1};
    var destinationCoordinates = {x: 5, y: 1};
    var gCost = calculateHCost(currentCoordinates, destinationCoordinates);    
    expect(gCost).toEqual(20);   
  });

  it("should calculate the F cost of the current coordinates", function() {  
    var currentCoordinates = {id: 1, parent: 1, x: 1, y: 1, gCost: 20, hCost: 30};
    var fCost = calculateFCost(currentCoordinates);    
    expect(fCost).toEqual(50);   
  });
});



// describe("finding the lowest F cost in the open list", function() {

//   it("should find the point in the open list which has the lowest F Cost", function() {  
//     var point1 = {x: 3, y: 1, fCost: 4};
//     var point2 = {x: 2, y: 2, fCost: 3};
//     var point3 = {x: 1, y: 2, fCost: 1};
//     var openList = [point1, point2, point3]
//     var lowestFCost = findPointWithLowestFCost(openList);
//     expect(lowestFCost).toEqual(point3);   
//   });
// });

// describe("completion of a star search", function() {

//   it("should return the lowest cost route", function() {
//     var worldData = {xBoundary: 7, yBoundary: 5, walls: [{x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}]};
//     var startCoordinatess = {x: 2, y: 3};
//     var destinationCoordinates = {x: 6, y: 3};
    
//     var searchResult = aStarSearch(worldData, startCoordinates, destinationCoordinates);
//     var expectedSearchResult = [{x: 2, y: 3},{x: 3, y: 2},{x: 3, y: 1},{x: 4, y: 1},{x: 5, y: 1},{x: 6, y: 2},{x: 6, y: 3}];
//     expect(searchResult).toEqual(expectedSearchResult);
//   });
// });