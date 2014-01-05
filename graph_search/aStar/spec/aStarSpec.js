require('./specHelper');

var aStar = require('../src/aStar');

describe("aStar search", function() {

    describe("generating coordinates", function() {

        it('should generate adjacent coordinates given a currentLocation', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var adjacentCoordinates = aStar.getAdjacentCoordinates(currentLocation);
            var expectedAdjacentCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                               {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                               {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}];
            expect(adjacentCoordinates).toEqual(expectedAdjacentCoordinates);
        });
    });

    describe("calculating costs", function() {

        it("should calculate the fCost given a gCost and hCost", function() {
            var point = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, gCost: 10, hCost: 10};
            var fCost = aStar.calculateFCost(point);
            expect(fCost).toEqual(20);
        });

        it('should calculate the gCost given a currentLocation and closedList', function () {
            var currentLocation = {xAxis: 2, yAxis: 1};
            var a1 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 40};
            var a2 = {id: 2, xAxis: 2, yAxis: 1, parentSquare: 1, fCost: 40, gCost: 10, hCost: 30};
            var a3 = {id: 3, xAxis: 3, yAxis: 1, parentSquare: 2, fCost: 40, gCost: 20, hCost: 20};
            var closedList = [a1, a2, a3];
            var proposedLocation = {id: 4, xAxis: 1, yAxis: 2, parentSquare: 3, cost: 10};
            var gCost = aStar.calculateGCost(currentLocation, proposedLocation, closedList);
            expect(gCost).toEqual(30);
        });

        it("should calculate the hCost given a currentLocation and destination", function() {
            var currentLocation = {xAxis: 1, yAxis: 2};
            var destination = {xAxis: 4, yAxis: 2};
            var hCost = aStar.calculateHCost(currentLocation, destination);
            expect(hCost).toEqual(30);
        });

        it('should find the lowest f cost in the open list', function () {
            var a1 = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 20, gCost: 0, hCost: 0};
            var a2 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 0, gCost: 0, hCost: 0};
            var a3 = {id: 2, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 0};
            openList = [a1, a2, a3];
            expect(aStar.findPointWithLowestFCost(openList)).toEqual(a2);
        });
    });

    describe("integration test", function() {
        it("should return the shortest path given a destination, starting point and environment", function() {
            // aStar.search(destination, startingPoint, environment);
        });
    });
});