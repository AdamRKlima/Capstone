SELECT *
FROM NumofSuicByState

DELETE FROM AgeByState
WHERE Year<2015

SELECT * FROM AgeByState

DELETE FROM HispanicAffiliationRates
WHERE Year<2015

SELECT * FROM HispanicAffiliationRates

DELETE FROM NumofSuicByState
WHERE Year<2015

SELECT * FROM NumofSuicByState

DELETE FROM RaceByState
WHERE Year<2015

SELECT * FROM RaceByState

DELETE FROM RatesBySex
WHERE Year<2015

SELECT * FROM RatesBySex

DELETE FROM RatesByRace
WHERE Year<2015

SELECT * FROM RatesByRace

DELETE FROM RatesBySexandAge
WHERE Year<2015

SELECT * FROM RatesBySexandAge

DELETE FROM RecentVHAbyAge
WHERE Year<2015

SELECT * FROM RecentVHAbyAge

DELETE FROM SexByYearAndState
WHERE Year<2015

SELECT * FROM SexByYearAndState

DELETE FROM NonRecentVHAbyYear
WHERE Year<2015

SELECT * FROM NonRecentVHAbyYear

DELETE FROM NonRecentVHAbyAge
WHERE Year<2015

SELECT * FROM NonRecentVHAbyAge

SELECT rr.*, rs.*
FROM RatesByRace rr
LEFT JOIN RatesBySex rs
on rr.Year=rs.Year

SELECT rtrim("SuicideRate/100,000", '*') as trimmed
FROM AgeByState

UPDATE AgeByState
SET "SuicideRate/100,000"=rtrim("SuicideRate/100,000", '*')

SELECT "SuicideRate/100,000"
FROM AgeByState

CREATE TABLE RecentVHAbyYear as
	SELECT *
	FROM RecentVHAbyAge
	WHERE AgeGroup='All'

CREATE TABLE RecentAndNonRecentVHAbyYear as
	SELECT nry.*, ry.*
	FROM NonRecentVHAbyYear nry
	LEFT JOIN RecentVHAbyYear ry
	on nry.Year=ry.Year

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN NonRecentVHAMaleSuicides

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN MaleNonRecentVHApopEst

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN "MaleNonRecentVHAuserCrudeRate/100,000"

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN FemaleNonRecentVHAuserSuicides

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN FemaleNonRecentVHAuserPopEst

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN "FemaleNonRecentVHAuserCrudeRate/100,000"

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN "Year:1"

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN AgeGroup

ALTER TABLE HispanicAffiliationRates
DROP COLUMN "AgeAdjustedRate/100,000"

ALTER TABLE HispanicAffiliationRates
DROP COLUMN "AgeAndSexAdjustedRate/100,000"

ALTER TABLE HispanicAffiliationRates
DROP COLUMN "MaleAgeAdjustedRate/100,000"

ALTER TABLE HispanicAffiliationRates
DROP COLUMN "FemaleAgeAdjustedRate/100,000"

ALTER TABLE RecentVHAbyYear
DROP COLUMN AgeGroup

CREATE TABLE RecentAndNonRecentVHAbyAGE as
	SELECT nra.*, ra.*
	FROM NonRecentVHAbyAge nra
	LEFT JOIN RecentVHAbyAge ra
	on nra.Year=ra.Year AND nra.AgeGroup=ra.AgeGroup

ALTER TABLE RecentAndNonRecentVHAbyAGE
DROP COLUMN 'Year:1'

ALTER TABLE RecentAndNonRecentVHAbyAGE
DROP COLUMN 'AgeGroup:1'

CREATE TABLE AgeOverview as
	SELECT ab.*, rba.*
	FROM RatesBySexandAge ab
	LEFT JOIN RecentAndNonRecentVHAbyAGE rba
	on ab.Year=rba.Year AND ab.AgeGroup=rba.AgeGroup
	
ALTER TABLE AgeOverview
DROP COLUMN AgeGroup2

ALTER TABLE AgeOverview
DROP COLUMN 'Year:1'

ALTER TABLE AgeOverview
DROP COLUMN 'AgeGroup:1'

SELECT *
FROM AgeOverview
WHERE FemaleNumofSuicide = '.'

UPDATE AgeOverview
SET FemaleNumofSuicide = 0
WHERE FemaleNumofSuicide ='.'

UPDATE AgeOverview
SET FemalePopEst = 0
WHERE FemalePopEst ='.'

UPDATE AgeOverview
SET "FemaleCrudeRate/100,000" = 0
WHERE "FemaleCrudeRate/100,000" ='.'