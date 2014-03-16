require './specHelper'

aStar = require '../src/aStar'

describe "aStar search", ->

  describe "generating coordinates", ->

    it 'should return adjacent coordinates to the current location', ->
      currentLocation = {xAxis: 2, yAxis: 1}
      adjacentCoordinates = aStar.getAdjacentCoordinates(currentLocation)
      expectedAdjacentCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                     {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                     {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expect(adjacentCoordinates).toEqual(expectedAdjacentCoordinates)

  describe "validating coordinates", ->

    it 'should return all coordinates when all are valid', ->
      adjacentCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                             {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                             {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expectedValidCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                  {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                  {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      environment = {walls: [{}], worldSize: {xAxis: 5, yAxis: 5}}
      validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment)
      expect(validCoordinates).toEqual(expectedValidCoordinates)

    it 'should not return coordinates that are walls', ->
      adjacentCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                             {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                             {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      # expected coordinates do not include North West as it is a wall
      expectedValidCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10},
                                  {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                  {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      environment = {walls: [{xAxis: 3, yAxis: 2}], worldSize: {xAxis: 5, yAxis: 5}}
      validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment)
      expect(validCoordinates).toEqual(expectedValidCoordinates)

    it 'should not return coordinates that are outside the worldSize', ->
      adjacentCoordinates =      [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                  {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                  {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expectedValidCoordinates = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10},
                                  {xAxis: 1, yAxis: 1, cost: 10},
                                  {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}]
      environment = {walls: [{}], worldSize: {xAxis: 2, yAxis: 2}}
      validCoordinates = aStar.validateCoordinates(adjacentCoordinates, environment)
      expect(validCoordinates).toEqual(expectedValidCoordinates)

  describe "calculating costs", ->

    it "should calculate the fCost", ->
      point = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, gCost: 10, hCost: 10}
      fCost = aStar.calculateFCost(point)
      expect(fCost).toEqual(20)

    it 'should calculate the gCost', ->
      currentLocation = {xAxis: 2, yAxis: 1}
      a1 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 40}
      a2 = {id: 2, xAxis: 2, yAxis: 1, parentSquare: 1, fCost: 40, gCost: 10, hCost: 30}
      a3 = {id: 3, xAxis: 3, yAxis: 1, parentSquare: 2, fCost: 40, gCost: 20, hCost: 20}
      closedList = [a1, a2, a3]
      proposedLocation = {id: 4, xAxis: 1, yAxis: 2, parentSquare: 3, cost: 10}
      gCost = aStar.calculateGCost(currentLocation, proposedLocation, closedList)
      expect(gCost).toEqual(30)

    it "should calculate the hCost", ->
      currentLocation = {xAxis: 1, yAxis: 2}
      destination = {xAxis: 4, yAxis: 2}
      hCost = aStar.calculateHCost(currentLocation, destination)
      expect(hCost).toEqual(30)

    it 'should find point with the lowest fCost in the openList', ->
      a1 = {id: 0, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 20, gCost: 0, hCost: 0}
      a2 = {id: 1, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 0, gCost: 0, hCost: 0}
      a3 = {id: 2, xAxis: 1, yAxis: 1, parentSquare: 0, fCost: 40, gCost: 0, hCost: 0}
      openList = [a1, a2, a3]
      expect(aStar.findPointWithLowestFCost(openList)).toEqual(a2)

  describe "integration test", ->
    it "should return the shortest path given a destination, starting point and environment", ->
      destination = {xAxis: 7, yAxis: 3}
      startCoordinates = {xAxis: 1, yAxis: 3}
      environment = {walls: [{xAxis: 4, yAxis: 2}, {xAxis: 4, yAxis: 3}, {xAxis: 4, yAxis: 4}], worldSize: {xAxis: 2, yAxis: 2}}
      result = aStar.run(destination, startCoordinates, environment)
      expectedResult = []
      expect(result).toEqual(expectedResult)