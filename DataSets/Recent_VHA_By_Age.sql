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

CREATE TABLE AgeOverviewsdfg as
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

CREATE TABLE StatebyYear as
	SELECT *
	FROM SexByYearAndState
	WHERE Sex = 'All'

ALTER TABLE StatebyYear
DROP COLUMN Sex	

ALTER TABLE AgeByState
ADD COLUMN Addd as (Suicides+"SuicideRate/100,000")

ALTER TABLE AgeByState
DROP COLUMN Addd

CREATE TABLE SuicideByYear as
	SELECT *
	FROM StatebyYear
	WHERE GeoRegion='All'
	
ALTER TABLE SuicideByYear
DROP COLUMN GeoRegion

ALTER TABLE SuicideByYear
DROP COLUMN State

ALTER TABLE RecentAndNonRecentVHAbyYear
ADD COLUMN NumofSuicide

UPDATE RecentAndNonRecentVHAbyYear
	SET NumofSuicide =(
		SELECT NumofSuicide
		FROM SuicideByYear
		WHERE RecentAndNonRecentVHAbyYear.Year = SuicideByYear.Year)

ALTER TABLE RecentAndNonRecentVHAbyYear
DROP COLUMN RecentVHApercentage

ALTER TABLE RecentAndNonRecentVHAbyYear
ADD COLUMN RecentVHApercentage 


UPDATE RecentAndNonRecentVHAbyYear
SET NonRecentVHAsuicides=replace(NonRecentVHAsuicides, ',','')

SELECT NonRecentVHAsuicides
FROM RecentAndNonRecentVHAbyYear

UPDATE RecentAndNonRecentVHAbyYear
SET NonRecentVHApop=replace(NonRecentVHApop, ',','')


UPDATE RecentAndNonRecentVHAbyYear
SET NumOfRecentVHAuserSuicide=replace(NumOfRecentVHAuserSuicide, ',','')

UPDATE RecentAndNonRecentVHAbyYear
SET VHAvetPopEst=replace(VHAvetPopEst, ',','')

UPDATE RecentAndNonRecentVHAbyYear
	SET RecentVHApercentage =(
		SELECT round((100*(NumOfRecentVHAuserSuicide/NumofSuicide)),2)
		FROM RecentAndNonRecentVHAbyYear)

SELECT RecentVHApercentage
FROM RecentAndNonRecentVHAbyYear

ALTER TABLE RecentAndNonRecentVHAbyYear
ADD COLUMN NonRecentVHApercentage 

UPDATE RecentAndNonRecentVHAbyYear
	SET NonRecentVHApercentage=(
		SELECT round((100*(NonRecentVHAsuicides/NumofSuicide)),2)
		FROM RecentAndNonRecentVHAbyYear)
		
SELECT NonRecentVHApercentage
FROM RecentAndNonRecentVHAbyYear

-- SexByYearAndState RecentAndNonRecentVHAbyYear RatesBySexAndRace
CREATE TABLE YearOverview as
	SELECT ss.*, rby.*, rsr.*
	FROM SuicideByYear ss
	NATURAL LEFT JOIN RecentAndNonRecentVHAbyYear rby
	NATURAL LEFT JOIN RatesBySexAndRace rsr

UPDATE YearOverview
SET WhiteNumofSuicide=replace(WhiteNumofSuicide, ',','')

UPDATE YearOverview
SET SuicideDeaths=replace(SuicideDeaths, ',','')

UPDATE YearOverview
SET MalePopEst=replace(MalePopEst, ',','')

UPDATE YearOverview
SET FemalePopEst=replace(FemalePopEst, ',','')

ALTER TABLE YearOverview
DROP COLUMN "Year:1"

ALTER TABLE YearOverview
DROP COLUMN "Year:2"

ALTER TABLE YearOverview
DROP COLUMN "NumofSuicide:1"

ALTER TABLE YearOverview
DROP COLUMN "Percent"

ALTER TABLE YearOverview
DROP COLUMN "AgeAdjustedRate/100,000"

ALTER TABLE YearOverview
DROP COLUMN "AgeAndSexAdjustedRate/100,000"

ALTER TABLE YearOverview
DROP COLUMN "MaleAgeAdjustedRate/100,000"

ALTER TABLE YearOverview
DROP COLUMN "FemaleAgeAdjustedRate/100,000"

UPDATE AgeOverview
SET NumofSuicide=replace(NumofSuicide, ',','')

UPDATE AgeOverview
SET VeteranPopEst=replace(VeteranPopEst, ',','')

UPDATE AgeOverview
SET MaleSuicide=replace(MaleSuicide, ',','')

UPDATE AgeOverview
SET MalePopEst=replace(MalePopEst, ',','')

UPDATE AgeOverview
SET FemaleNumofSuicide=replace(FemaleNumofSuicide, ',','')

UPDATE AgeOverview
SET FemalePopEst=replace(FemalePopEst, ',','')

UPDATE AgeOverview
SET NonRecentVHAsuicides=replace(NonRecentVHAsuicides, ',','')

UPDATE AgeOverview
SET NonRecentVHAuserPopEst=replace(NonRecentVHAuserPopEst, ',','')

UPDATE AgeOverview
SET NumOfRecentVHAuserSuicide=replace(NumOfRecentVHAuserSuicide, ',','')

UPDATE AgeOverview
SET VHAvetPopEst=replace(VHAvetPopEst, ',','')

ALTER TABLE AgeOverview
ADD COLUMN MaleSuicidePercent

UPDATE AgeOverview
	SET MaleSuicidePercent=(
		SELECT round((100*(MaleSuicide/NumofSuicide)),2)
		FROM AgeOverview)
		
ALTER TABLE AgeOverview
ADD COLUMN MalePopPercent

UPDATE AgeOverview
	SET MalePopPercent=(
		SELECT round((100*(MalePopEst/VeteranPopEst)),2)
		FROM AgeOverview)

ALTER TABLE AgeOverview
ADD COLUMN FemaleSuicidePercent

UPDATE AgeOverview
	SET FemaleSuicidePercent=(
		SELECT round((100*(FemaleNumofSuicide/NumofSuicide)),2)
		FROM AgeOverview
		GROUP by Year, AgeGroup)
		
ALTER TABLE AgeOverview
ADD COLUMN FemalePopPercent

UPDATE AgeOverview
	SET FemalePopPercent=(
		SELECT round((100*(FemalePopEst/VeteranPopEst)),2)
		FROM AgeOverview)
		
ALTER TABLE AgeOverview
ADD COLUMN NonRecentVHAMaleSuicidesPercent

UPDATE AgeOverview
	SET NonRecentVHAMaleSuicidesPercent=(
		SELECT round((100*(NonRecentVHAsuicides/NumofSuicide)),2)
		FROM AgeOverview)
		
ALTER TABLE AgeOverview add FemaleNumbofSuicide as (NumofSuicide-MaleSuicide)

ALTER TABLE AgeOverview DROP COLUMN FemaleNumofSuicide

ALTER TABLE AgeOverview DROP COLUMN MaleSuicidePercent

ALTER TABLE AgeOverview DROP COLUMN MalePopPercent

ALTER TABLE AgeOverview DROP COLUMN FemaleSuicidePercent

ALTER TABLE AgeOverview DROP COLUMN FemalePopPercent

ALTER TABLE AgeOverview DROP COLUMN NonRecentVHAMaleSuicidesPercent

ALTER TABLE AgeOverview DROP COLUMN FemalePopEst

ALTER TABLE AgeOverview add FemalePopest as (VeteranPopEst-MalePopEst)

ALTER TABLE AgeOverview ADD MaleSuicidePercent as (round((MaleSuicide/NumofSuicide),4)*100)

ALTER TABLE AgeOverview ADD MalePopPercent as (round((MalePopEst/VeteranPopEst),4)*100)

ALTER TABLE AgeOverview ADD FemaleSuicidePercent as (round((FemaleNumbofSuicide/NumofSuicide),4)*100)

ALTER TABLE AgeOverview ADD FemalePopPercent as (round((FemalePopest/VeteranPopEst),4)*100)

ALTER TABLE AgeOverview ADD NonRecentVHAsuicidePercent as (round((NonRecentVHAsuicides/NumofSuicide),4)*100)

ALTER TABLE AgeOverview ADD NonRecentVHApopPercent as (round((NonRecentVHAuserPopEst/VeteranPopEst),4)*100)

ALTER TABLE AgeOverview ADD RecentVHAsuicidePercent as (round((NumOfRecentVHAuserSuicide/VeteranPopEst),4)*100)

ALTER TABLE AgeOverview ADD RecentVHApopPercent as (round((VHAvetPopEst/VeteranPopEst),4)*100)

CREATE TABLE AllOverview as
	SELECT *
	FROM AgeOverview
	WHERE AgeGroup='All'
	
ALTER TABLE AllOverview DROP COLUMN AgeGroup

ALTER TABLE YearOverview DROP COLUMN NumofSuicide

ALTER TABLE YearOverview DROP COLUMN NonRecentVHAsuicides

ALTER TABLE YearOverview DROP COLUMN NonRecentVHApop

ALTER TABLE YearOverview DROP COLUMN "NonRecentVHAcrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN NumOfRecentVHAuserSuicide

ALTER TABLE YearOverview DROP COLUMN VHAvetPopEst

ALTER TABLE YearOverview DROP COLUMN RecentVHApercentage

ALTER TABLE YearOverview DROP COLUMN SuicideDeaths

ALTER TABLE YearOverview DROP COLUMN VeteranPop

ALTER TABLE YearOverview DROP COLUMN MaleSuicides

ALTER TABLE YearOverview DROP COLUMN MalePopEst

ALTER TABLE YearOverview DROP COLUMN "MaleCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN FemaleSuicides

ALTER TABLE YearOverview DROP COLUMN FemalePopest

ALTER TABLE YearOverview DROP COLUMN "FemaleCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN "RecentVHAuserSuicideCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN NonRecentVHApercentage

ALTER TABLE YearOverview DROP COLUMN "WhiteCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN "AfricanAmericanCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN "NativeCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN "Asian/Hawaiian/PacificIslanderCrudeRate/100,000"

ALTER TABLE YearOverview DROP COLUMN "MultipleRaceCrudeRate"

ALTER TABLE YearOverview DROP COLUMN "CrudeRate/100,000"

ALTER TABLE AllOverview DROP COLUMN "CrudeRate/100,000"

ALTER TABLE AllOverview DROP COLUMN "MaleCrudeRate/100,000"

ALTER TABLE AllOverview DROP COLUMN "FemaleCrudeRate/100,000"

ALTER TABLE AllOverview DROP COLUMN "NonRecentVHAcrudeRate/100,000"

ALTER TABLE AllOverview DROP COLUMN "RecentVHAuserSuicideCrudeRate/100,000"

CREATE TABLE YearMasterSet as
	SELECT ao.*, yo.*
	FROM AgeAllOverview ao
	NATURAL LEFT JOIN YearOverview yo

ALTER TABLE YearMasterSet ADD WhiteNumofSuicidePercent as (round((WhiteNumofSuicide/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet ADD AfricanAmericanNumofSuicidesPercent as (round((AfricanAmericanNumofSuicides/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet ADD NativeNumofSuicidePercent as (round((NativeNumofSuicide/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet ADD "Asian/Hawaiian/PacificIslanderNumofSuicidesPercent" as (round(("Asian/Hawaiian/PacificIslanderNumofSuicides"/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet ADD MultipleRaceNumofSuicidesPercent as (round((MultipleRaceNumofSuicides/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet ADD UnknownRaceSuicidePercent as (round((UnknownRace/NumofSuicide),4)*100)

ALTER TABLE YearMasterSet RENAME COLUMN UnknownRace to UnknownRaceSuicide

ALTER TABLE AgeOverview RENAME to AgeMasterSet

ALTER TABLE YearMasterSet DROP COLUMN RecentVHAsuicidePercent

ALTER TABLE YearMasterSet ADD COLUMN RecentVHAsuicidePercent as (round((NumOfRecentVHAuserSuicide/NumofSuicide),4)*100)