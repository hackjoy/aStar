require('./specHelper');

var aStar = require('../src/aStar');

describe("aStar search", function() {

    describe("generating coordinates", function() {

        it('should return adjacent coordinates to the current location', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var adjacentCoordinates = aStar.getAdjacentCoordinates(currentLocation);
            var expectedAdjacentCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                               {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                               {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            expect(adjacentCoordinates).toEqual(expectedAdjacentCoordinates);
        });
    });

    describe("validating coordinates", function() {

        it('should return all coordinates when all are valid', function () {
            var adjacentCoordinates =      [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                            {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            var expectedValidCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                            {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            var environment = {walls: [{}], worldSize: {xAxis: 5, yAxis: 5}};
            var validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment);
            expect(validCoordinates).toEqual(expectedValidCoordinates);
        });

        it('should not return coordinates that are walls', function () {
            var adjacentCoordinates =      [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                            {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            // expected coordinates do not include North West as it is a wall
            var expectedValidCoordinates = [                                {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                            {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            var environment = {walls: [{xAxis: 1, yAxis: 2}], worldSize: {xAxis: 5, yAxis: 5}};
            var validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment);
            expect(validCoordinates).toEqual(expectedValidCoordinates);
        });

        it('should not return coordinates that are outside the worldSize', function () {
            var adjacentCoordinates =      [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                            {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            var expectedValidCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10},
                                            {xAxis: 1, yAxis: 1, cost: 10},
                                            {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}];
            var environment = {walls: [{}], worldSize: {xAxis: 2, yAxis: 2}};
            var validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment);
            expect(validCoordinates).toEqual(expectedValidCoordinates);
        });
    });

    describe("calculating costs", function() {

        it("should calculate the fCost", function() {
            var point = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, gCost: 10, hCost: 10};
            var fCost = aStar.calculateFCost(point);
            expect(fCost).toEqual(20);
        });

        it('should calculate the gCost', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var a1 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 40};
            var a2 = {id: 2, xAxis: 2, yAxis: 1, parentSquare: 1, fCost: 40, gCost: 10, hCost: 30};
            var a3 = {id: 3, xAxis: 3, yAxis: 1, parentSquare: 2, fCost: 40, gCost: 20, hCost: 20};
            var closedList = [a1, a2, a3];
            var proposedLocation = {id: 4, xAxis: 1, yAxis: 2, parentSquare: 3, cost: 10};
            var gCost = aStar.calculateGCost(currentLocation, proposedLocation, closedList);
            expect(gCost).toEqual(30);
        });

        it("should calculate the hCost", function() {
            var currentLocation = {xAxis: 1, yAxis: 2};
            var destination = {xAxis: 4, yAxis: 2};
            var hCost = aStar.calculateHCost(currentLocation, destination);
            expect(hCost).toEqual(30);
        });

        it('should find coordinate with the lowest fCost in the openList', function () {
            var a1 = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 20, gCost: 0, hCost: 0};
            var a2 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 0, gCost: 0, hCost: 0};
            var a3 = {id: 2, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 0};
            openList = [a1, a2, a3];
            expect(aStar.findCoordinateWithLowestFCost(openList)).toEqual(a2);
        });
    });

    describe("integration test", function() {
        it("should return the shortest path given a destination, starting point and environment", function() {
            var destination = {xAxis: 7, yAxis: 3};
            var startLocation = {xAxis: 1, yAxis: 3};
            var environment = {walls: [{xAxis: 4, yAxis: 2}, {xAxis: 4, yAxis: 3}, {xAxis: 4, yAxis: 4}], worldSize: {xAxis: 2, yAxis: 2}};
            var result = aStar.searchFor(destination, startLocation, environment);
            var expectedResult = [];
            expect(result).toEqual(expectedResult);
        });
    });
});