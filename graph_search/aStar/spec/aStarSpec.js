require('./specHelper');

var aStar = require('../src/aStar');

describe("aStar search", function() {

    describe("generating coordinates", function() {

        it('should generate adjacent coordinates given a currentLocation', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var adjacentCoordinates = aStar.getAdjacentCoordinates(currentLocation);
            var expectedAdjacentCoordinates = [{xAxis: 1, yAxis: 2}, {xAxis: 2, yAxis: 2}, {xAxis: 3, yAxis: 2},
                                               {xAxis: 1, yAxis: 1}, {xAxis: 3, yAxis: 1},
                                               {xAxis: 1, yAxis: 0}, {xAxis: 2, yAxis: 0}, {xAxis: 3, yAxis: 0}];
            expect(adjacentCoordinates).toEqual(expectedAdjacentCoordinates);
        });
    });

    describe("costs", function() {

        it("should calculate the fCost given ", function() {
            point = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, gCost: 10, hCost: 10};
            fCost = aStar.calculateFCost(point);
            expect(fCost).toEqual(20);
        });

        it('should calculate the gCost given a currentLocation and adjacentCoordinate', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var adjacentCoordinates = aStar.getAdjacentCoordinates(currentLocation);
        });

        it("should calculate the hCost given a currentLocation and destination", function() {
            var currentLocation = {xAxis: 1, yAxis: 2};
            var destination = {xAxis: 4, yAxis: 2};
            var hCost = aStar.calculateHCost(currentLocation, destination);
            expect(hCost).toEqual(30);
        });

        it('should find the lowest f cost in the open list', function () {
            a1 = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 20, gCost: 0, hCost: 0};
            a2 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 0, gCost: 0, hCost: 0};
            a3 = {id: 2, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 0};
            openList = [a1, a2, a3];
            expect(aStar.findPointWithLowestFCost(openList)).toEqual(a2);
        });
    });

    describe("testing the full implementation", function() {
        it("should return the shortest path", function() {
            // aStar.searchFor(destination, startingPoint, environment);
        });
    });
});

    // var currentCoordinates, destinationCoordinates, coordinates1, coordinates2, coordinates3;

    // beforeEach(function() {
    //     currentCoordinates = {x: 4, y: 1};
    //     destinationCoordinates = {x: 5, y: 1};
    //     coordinates1 = {x: 1, y: 1, fCost: 30, gCost: 0, hCost: 30, id: 1, parent: 0};
    //     coordinates2 = {x: 2, y: 1, fCost: 30, gCost: 10, hCost: 20, id: 2, parent: 1};
    //     coordinates3 = {x: 3, y: 1, fCost: 30, gCost: 20, hCost: 10, id: 3, parent: 2};
    // });

    // actual distance from current square to start position
    // it("should calculate the G cost of the current coordinates", function() {
    //     var closedList = {1: coordinates1, 2: coordinates2};
    //     var gCost = aStar.calculateGCost(currentCoordinates, currentCoordinatesID, closedList);
    //     expect(gCost).toEqual(20);
    // });

    // estimated distance from current square to destination
    // it("should calculate the H cost of the current coordinates", function() {
    //     var gCost = calculateHCost(currentCoordinates, destinationCoordinates);
    //     expect(gCost).toEqual(20);
    // });
    // // sum of G and H costs
    // it("should calculate the F cost of the current coordinates", function() {
    //     delete coordinates1.fCost;
    //     var fCost = calculateFCost(coordinates1);
    //     expect(fCost).toEqual(30);
    // });


// describe("Determining the next coordinates to explore", function() {

//     var worldData, currentCoordinates;

//     beforeEach(function () {
//         worldData = {xBoundary: 7, yBoundary: 5, walls: [{x: 4, y: 2}, {x: 4, y: 3}, {x: 4, y: 4}]};
//         currentCoordinates = {x: 3, y: 2};
//         destinationCoordinates = {x: 5, y: 1};
//         coordinates1 = {x: 1, y: 1, fCost: 30, gCost: 0, hCost: 30, id: 1, parent: 1};
//         coordinates2 = {x: 2, y: 1, fCost: 30, gCost: 10, hCost: 20, id: 2, parent: 1};
//         coordinates3 = {x: 2, y: 1, fCost: 20, gCost: 20, hCost: 0, id: 3, parent: 2};
//     });

//     // northEast and east are the coordinates of walls - therefore are not valid
//     it("should generate all possible valid moves from the currentCoordinates", function () {
//         var generatedMovements = generateAdjacentCoordinates(currentCoordinates, worldData);
//         var expectedMovements = [{x: 3, y: 3, cost: 10, direction: "north"},
//                                  {x: 4, y: 1, cost: 14, direction: "southEast"},
//                                  {x: 3, y: 1, cost: 10, direction: "south"},
//                                  {x: 2, y: 1, cost: 14, direction: "southWest"},
//                                  {x: 2, y: 2, cost: 10, direction: "west"},
//                                  {x: 2, y: 3, cost: 14, direction: "northWest"}];
//         expect(generatedMovements).toEqual(expectedMovements);
//     });

//     it("should find the coordinates in the open list with the lowest F Cost", function() {
//         var openList = [coordinates1, coordinates2, coordinates3];
//         var lowestFCost = findPointWithLowestFCost(openList);
//         expect(lowestFCost).toEqual(coordinates3);
//     });
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