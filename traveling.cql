CREATE (city1:CITY {name: "City1"}),
(city2:CITY {name: "City2"}),
(city3:CITY {name: "City3"}),
(city4:CITY {name: "City4"}),
(city5:CITY {name: "City5"}),
(city6:CITY {name: "City6"}),
(city7:CITY {name: "City7"})

// some paths between them
CREATE (city1)-[:ROAD {dist: 20}]->(city3)
CREATE (city1)-[:ROAD {dist: 22}]->(city4)
CREATE (city2)-[:ROAD {dist: 21}]->(city5)
CREATE (city2)-[:ROAD {dist: 27}]->(city1)
CREATE (city3)-[:ROAD {dist: 31}]->(city2)
CREATE (city3)-[:ROAD {dist: 31}]->(city6)
CREATE (city4)-[:ROAD {dist: 12}]->(city5)
CREATE (city4)-[:ROAD {dist: 19}]->(city1)
CREATE (city4)-[:ROAD {dist: 19}]->(city2)
CREATE (city4)-[:ROAD {dist: 19}]->(city7)
CREATE (city5)-[:ROAD {dist: 24}]->(city3)
CREATE (city5)-[:ROAD {dist: 18}]->(city7)
CREATE (city6)-[:ROAD {dist: 14}]->(city4)
CREATE (city6)-[:ROAD {dist: 12}]->(city2)
CREATE (city7)-[:ROAD {dist: 19}]->(city1)
CREATE (city7)-[:ROAD {dist: 25}]->(city3)

// assign some values
SET city1.value = 100,
city2.value = 70,
city3.value = 120,
city4.value = 140,
city5.value = 90,
city6.value = 105,
city7.value = 102

// -------------------------------------

// shortest path between three nodes, only visiting each node once.
// match the three cities to be visited.
// note that this one speficies the order the cities must be visited.
MATCH (start {name:"City1"}), (two {name:"City3"}), (three {name:"City7"})

// find a bunch of possible paths between them
MATCH p=(start)-[:ROAD*0..10]->(two)-[:ROAD*0..10]->(three)

// filter down to paths containing only unique nodes
WHERE ALL(n in nodes(p) WHERE 1=length(filter(m in nodes(p) WHERE m=n)))
RETURN p AS shortestPath,

// find the total distance for each path
reduce(Distance=0, r in relationships(p) | Distance + r.dist) AS TotalDistance

// return the shortest path
ORDER BY TotalDistance ASC
LIMIT 1


// --------------------------------


// find best path to earn money at 4 unique cities, 
// maximizing value and minimizing distance driven

// match the starting city
MATCH (start {name:"City1"})

// match possible paths outward
MATCH p=(start)-[:ROAD*0..5]->()

// filter for unique nodes only
WHERE ALL(n in nodes(p) WHERE 1=length(filter(m in nodes(p) WHERE m=n)))

// filter for paths with four cities
AND length(nodes(p)) = 4

RETURN p AS bestPath,

// reduce each path, summing total distance and total profit on each route
reduce(Distance=0, r in relationships(p) | Distance + r.dist) AS TotalDistance,
reduce(Profit=0, r in nodes(p) | Profit + r.value) AS TotalProfit

// maximize total profit and minimize distance
ORDER BY TotalProfit DESC, TotalDistance ASC
LIMIT 1
