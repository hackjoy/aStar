require './specHelper'
process.env.NODE_ENV = 'development' # export all functions for testing purposes
aStar = require '../src/aStar'

describe "aStar search", ->

  describe "generating and validating coordinates", ->
    # init shared test varibles
    environment = currentLocation = destination = undefined

    beforeEach ->
      currentLocation = {xAxis: 2, yAxis: 1}
      environment = {walls: [], worldSize: {xAxis: 10, yAxis: 10}}
      destination = {xAxis: 4, yAxis: 1}

    it 'should generate adjacent coordinates to the current location', ->
      adjacentLocations = aStar.generateAdjacentLocations(currentLocation)
      expectedAdjacentLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                   {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                   {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expect(adjacentLocations).toEqual(expectedAdjacentLocations)

    it 'should validate coordinates to ensure they are not out of bounds or a wall', ->
      adjacentLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                           {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                           {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expectedValidLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                                {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      validLocations = aStar.validateLocations(adjacentLocations, environment)
      expect(validLocations).toEqual(expectedValidLocations)

    it 'should not return coordinates that are walls', ->
      adjacentLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                           {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                           {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      # expected coordinates do not include North West as it is a wall
      expectedValidLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10},
                                {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                                {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      environment.walls = [{xAxis: 3, yAxis: 2}]
      validLocations = aStar.validateLocations(adjacentLocations, environment)
      expect(validLocations).toEqual(expectedValidLocations)

    it 'should not return coordinates that are outside the worldSize', ->
      adjacentLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10}, {xAxis: 3, yAxis: 2, cost: 14},
                           {xAxis: 1, yAxis: 1, cost: 10},                                 {xAxis: 3, yAxis: 1, cost: 10},
                           {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}, {xAxis: 3, yAxis: 0, cost: 14}]
      expectedValidLocations = [{xAxis: 1, yAxis: 2, cost: 14}, {xAxis: 2, yAxis: 2, cost: 10},
                                {xAxis: 1, yAxis: 1, cost: 10},
                                {xAxis: 1, yAxis: 0, cost: 14}, {xAxis: 2, yAxis: 0, cost: 10}]
      environment.worldSize = {xAxis: 2, yAxis: 2}
      validLocations = aStar.validateLocations(adjacentLocations, environment)
      expect(validLocations).toEqual(expectedValidLocations)

  describe "calculating costs", ->

    it "should calculate the hCost", ->
      currentLocation = {xAxis: 1, yAxis: 2}
      destination = {xAxis: 4, yAxis: 2}
      hCost = aStar.calculateHCost(currentLocation, destination)
      expect(hCost).toEqual(30)

    it 'should find point with the lowest fCost in the openList', ->
      a1 = {xAxis: 3, yAxis: 1, gCost: 34, hCost: 20, fCost: 54, parent: {xAxis: 2, yAxis: 0}}
      a2 = {xAxis: 2, yAxis: 1, gCost: 30, hCost: 10, fCost: 40, parent: {xAxis: 2, yAxis: 0}}
      a3 = {xAxis: 3, yAxis: 0, gCost: 30, hCost: 20, fCost: 50, parent: {xAxis: 2, yAxis: 0}}
      openList = [a1, a2, a3]
      expect(aStar.findLocationWithLowestFCost(openList)).toEqual(a2)

  describe "integration tests", ->

    it "Easy Case A: should return the shortest path when travelling North with no obstacles", ->
      startCoordinates = {xAxis: 1, yAxis: 1}
      destination = {xAxis: 1, yAxis: 4}
      environment = {walls: [], worldSize: {xAxis: 10, yAxis: 10}}
      result = aStar.run(destination, startCoordinates, environment)
      expectedResult = [{xAxis: 1, yAxis: 1, gCost: 0, hCost: 30, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 1, yAxis: 2, gCost: 10, hCost: 20, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 1, yAxis: 3, gCost: 20, hCost: 10, fCost: 30, parent: {xAxis: 1, yAxis: 2}},
                        {xAxis: 1, yAxis: 4, gCost: 30, hCost: 0, fCost: 30, parent: {xAxis: 1, yAxis: 3}}

      ]
      expect(result).toEqual(expectedResult)
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . o . . . . . . . .
      # . ^ . . . . . . . .
      # . ^ . . . . . . . .
      # . ^ . . . . . . . .
      # . . . . . . . . . .

    it "Easy Case B: should return the shortest path when travelling East with no obstacles", ->
      startCoordinates = {xAxis: 1, yAxis: 1}
      destination = {xAxis: 4, yAxis: 1}
      environment = {walls: [], worldSize: {xAxis: 10, yAxis: 10}}
      result = aStar.run(destination, startCoordinates, environment)
      expectedResult = [{xAxis: 1, yAxis: 1, gCost: 0, hCost: 30, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 2, yAxis: 1, gCost: 10, hCost: 20, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 3, yAxis: 1, gCost: 20, hCost: 10, fCost: 30, parent: {xAxis: 2, yAxis: 1}},
                        {xAxis: 4, yAxis: 1, gCost: 30, hCost: 0, fCost: 30, parent: {xAxis: 3, yAxis: 1}}

      ]
      expect(result).toEqual(expectedResult)
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . ^ ^ ^ o . . . . .
      # . . . . . . . . . .

    it "Medium Case A: should return the shortest path when travelling around a wall", ->
      startCoordinates = {xAxis: 1, yAxis: 1}
      destination = {xAxis: 4, yAxis: 1}
      environment = {walls: [{xAxis: 2, yAxis: 1}, {xAxis: 2, yAxis: 2}, {xAxis: 2, yAxis: 3}], worldSize: {xAxis: 10, yAxis: 10}}
      result = aStar.run(destination, startCoordinates, environment)
      expectedResult = [{xAxis: 1, yAxis: 1, gCost: 0, hCost: 30, fCost: 30, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 2, yAxis: 0, gCost: 14, hCost: 30, fCost: 44, parent: {xAxis: 1, yAxis: 1}},
                        {xAxis: 3, yAxis: 1, gCost: 28, hCost: 10, fCost: 38, parent: {xAxis: 2, yAxis: 0}},
                        {xAxis: 4, yAxis: 1, gCost: 38, hCost: 0, fCost: 38, parent: {xAxis: 3, yAxis: 1}}
      ]
      expect(result).toEqual(expectedResult)
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . . . . . . . . .
      # . . W . . . . . . .
      # . . W . . . . . . .
      # . ^ W ^ o . . . . .
      # . . ^ . . . . . . .
