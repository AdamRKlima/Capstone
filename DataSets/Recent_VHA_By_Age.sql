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
