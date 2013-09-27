describe("aStar Search", function() {

  it("should find the point with the lowest F Cost in the open list", function() {  
    var point1 = {fCost: 2}
    var point2 = {fCost: 3}
    openList = [point1, point2]
    expect(findPointWithLowestFCost(openList)).toEqual(point1);   
  });

  it("should return the lowest cost route", function() {
    var worldData = {xBoundary: 7, yBoundary: 5, walls: [{x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}]};
    var startCoordinates = {x: 2, y: 3};
    var destinationCoordinates = {x: 6, y: 3};
    
    var searchResult = aStarSearch(worldData, startCoordinates, destinationCoordinates);
    var expectedSearchResult = [{x: 2, y: 3},{x: 3, y: 2},{x: 3, y: 1},{x: 4, y: 1},{x: 5, y: 1},{x: 6, y: 2},{x: 6, y: 3}];
    expect(searchResult).toEqual(expectedSearchResult);
  });
});