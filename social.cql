Create some sample data
CREATE (mitch:PERSON {name: "Mitch"}),
(david:PERSON {name: "David"}),
(jc:PERSON {name: "Joel Cox"}),
(jared:PERSON {name: "Jared"}),
(ajay:PERSON {name: "Ajay"}),
(nick:PERSON {name: "Nick"}),
(tyler:PERSON {name: "Tyler"}),
(park:PERSON {name: "Park"}),
(nelson:PERSON {name: "Nelson"}),
(john:PERSON {name: "John"}),
(will:PERSON {name: "Will"})
CREATE UNIQUE (mitch)-[:FOLLOWS]->(jared),
(david)-[:FOLLOWS]->(jared),
(david)-[:FOLLOWS]->(mitch),
(jared)-[:FOLLOWS]->(jc),
(ajay)-[:FOLLOWS]->(jc),
(ajay)-[:FOLLOWS]->(park),
(ajay)-[:FOLLOWS]->(john),
(tyler)-[:FOLLOWS]->(ajay),
(tyler)-[:FOLLOWS]->(david),
(jared)-[:FOLLOWS]->(tyler),
(nelson)-[:FOLLOWS]->(will),
(nelson)-[:FOLLOWS]->(john),
(will)-[:FOLLOWS]->(nelson),
(will)-[:FOLLOWS]->(john),
(park)-[:FOLLOWS]->(nelson),
(park)-[:FOLLOWS]->(jc),
(nick)-[:FOLLOWS]->(john),
(nick)-[:FOLLOWS]->(jared),
(mitch)-[:FOLLOWS]->(john),
(mitch)-[:FOLLOWS]->(will),
(mitch)-[:FOLLOWS]->(park)

Find everyone I'm following
MATCH (me:PERSON {name:"Mitch"})
MATCH (me)-[:FOLLOWS]->(other)
RETURN other

Find everyone who's following Jared
MATCH (j:PERSON {name:"Jared"})
MATCH (j)<-[:FOLLOWS]-(follower)
RETURN follower

Count Jared's followers
MATCH (j:PERSON {name:"Jared"})
MATCH (j)<-[:FOLLOWS]-(follower)
RETURN count(DISTINCT follower)

Find friends of my friends
MATCH (me:PERSON {name:"Mitch"})
MATCH (me)-[:FOLLOWS*2]->(friendOfFriend)
RETURN Distinct friendOfFriend

Find a third-degree follower whose name starts with 'a', who follows at least 
two of the same people I do, and follow him back.
MATCH (me:PERSON {name:"Mitch"})
MATCH (me)-[:FOLLOWS*3]->(other)
MATCH (me)-[:FOLLOWS]->(immediate)
WHERE NOT (me)-[:FOLLOWS]->(other) AND other.name =~ "A.*"
WITH count(distinct (other)-->(immediate)) AS count, other
WHERE count > 2
CREATE (me)-[:FOLLOWS]->(other)
