--SELECT * 
--FROM WorldHappinessReport..CombinedHappinessData
--FROM #CombinedHappinessData

--NOTES: Raw Data Queried below.
--https://worldhappiness.report/faq/
--Family was replaced with Social Support in 2018 WHR
--Whisker was used as Confidence Intervals
--All Tables are reordered & renamed to match Set Column Template (below) as best possible prior to merging. 

--SELECT (Template)
	--[Year],
	--[Country], 
	--[Region],
	--[Happiness Rank], 
	--[Happiness Score], 
	--[Whisker Low],
	--[Whisker High],
	--[Standard Error],
	--[Economy (GDP per Capita)], 
	--[Economy (GDP per Capita) Rank],
	--[Family (Social Support)], 
	--[Family (Social Support) Rank],
	--[Health (Life Expectancy)], 
	--[Health (Life Expectancy) Rank],
	--[Freedom],
	--[Freedom Rank],
	--[Trust (Government Corruption)], 
	--[Trust (Government Corruption) Rank],
	--[Generosity], 
	--[Generosity Rank],
	--[Dystopia Residual],
	--[Dystopia Residual Rank]

--SELECT *
--FROM #CombinedHappinessData; --Temporary Table FROM + UNION ALL 
----See Temp Table Guide https://www.sqlservertutorial.net/sql-server-basics/sql-server-temporary-tables/ 

--TABLE: WorldHappinessReport..CombinedHappinessData
SELECT --All Tables Updated and Renamed with Columns & Ranked Category Column:
	[Year],
	[Country], 
	    CASE
        WHEN [Region] IS NULL THEN LAG([Region]) OVER (PARTITION BY [Country] ORDER BY [Year])
        ELSE [Region]
    END AS [Region],
	[Happiness Rank], 
	[Happiness Score], 
	[Whisker Low],
	[Whisker High],
	[Standard Error],
	[Economy (GDP per Capita)], 
	[Economy (GDP per Capita) Rank],
	[Family (Social Support)], 
	[Family (Social Support) Rank],
	[Health (Life Expectancy)], 
	[Health (Life Expectancy) Rank],
	[Freedom], 
	[Freedom Rank],
	[Trust (Government Corruption)], 
	[Trust (Government Corruption) Rank],
	[Generosity], 
	[Generosity Rank],
	[Dystopia Residual],
	[Dystopia Residual Rank]
--INTO #CombinedHappinessData --Temporary table
--INTO WorldHappinessReport..CombinedHappinessData
FROM
(

	--2015 WHR ps://s3.amazonaws.com/happiness-report/2015/WHR15_Sep15.pdf 
	SELECT
		'2015' AS [Year], 
		[Country],
		[Region],
		[Happiness Rank], 
		[Happiness Score], 
		CAST (NULL AS int) AS [Whisker Low],
		CAST (NULL AS int) AS [Whisker High],
		[Standard Error], 
		[Economy (GDP per Capita)],
		ROW_NUMBER() OVER (ORDER BY [Economy (GDP per Capita)] DESC) AS [Economy (GDP per Capita) Rank],
		[Family] AS [Family (Social Support)], --Family -> Social Support in 2018 WHR
		ROW_NUMBER() OVER (ORDER BY [Family] DESC) AS [Family (Social Support) Rank],
		[Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Health (Life Expectancy)] DESC) AS [Health (Life Expectancy) Rank] ,
		[Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Freedom] DESC) AS [Freedom Rank],
		[Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Trust (Government Corruption)] DESC) AS [Trust (Government Corruption) Rank],
		[Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Generosity] DESC) AS [Generosity Rank],
		[Dystopia Residual],
		ROW_NUMBER() OVER (ORDER BY [Dystopia Residual] DESC) AS [Dystopia Residual Rank]
	--INTO #Qry2015
	FROM WorldHappinessReport..[2015]

	UNION ALL

	SELECT --2016
		'2016' AS [Year], 
		[Country],
		[Region],
		[Happiness Rank], 
		[Happiness Score], 
		[Lower Confidence Interval] AS [Whisker Low],
		[Upper Confidence Interval] AS [Whisker High],
		CAST((([Upper Confidence Interval] - [Lower Confidence Interval]) / (2 * 1.96)) AS float) AS [Standard Error],
		[Economy (GDP per Capita)], 
		ROW_NUMBER() OVER (ORDER BY [Economy (GDP per Capita)] DESC) AS [Economy (GDP per Capita) Rank],
		[Family] AS [Family (Social Support)], --Family -> Social Support in 2018 WHR
		ROW_NUMBER() OVER (ORDER BY [Family] DESC) AS [Family (Social Support) Rank],
		[Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Health (Life Expectancy)] DESC) AS [Health (Life Expectancy) Rank],
		[Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Freedom] DESC) AS [Freedom Rank],
		[Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Trust (Government Corruption)] DESC) AS [Trust (Government Corruption) Rank],
		[Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Generosity] DESC) AS [Generosity Rank],
		[Dystopia Residual],
		ROW_NUMBER() OVER (ORDER BY [Dystopia Residual] DESC) AS [Dystopia Residual Rank]
	--INTO #Qry2016
	FROM WorldHappinessReport..[2016]

	UNION ALL

	SELECT --2017
		'2017' AS [Year], 
		[Country],
		CAST (NULL AS nvarchar) AS [Region],
		[Happiness#Rank] AS [Happiness Rank], 
		[Happiness#Score] AS [Happiness Score], 
		[Whisker#low] AS [Whisker Low],
		[Whisker#high] AS [Whisker High],
		CAST ((([Whisker#high] - [Whisker#low]) / (2 * 1.96)) AS float) AS [Standard Error],
		[Economy##GDP#per#Capita#] AS [Economy (GDP per Capita)],
		ROW_NUMBER() OVER (ORDER BY [Economy##GDP#per#Capita#] DESC) AS [Economy (GDP per Capita) Rank],
		Family AS [Family (Social Support)], -- Family -> Social Support in 2018 WHR
		ROW_NUMBER() OVER (ORDER BY [Family] DESC) AS [Family (Social Support) Rank],
		[Health##Life#Expectancy#] AS [Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Health##Life#Expectancy#] DESC) AS [Health (Life Expectancy) Rank],
		[Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Freedom] DESC) AS [Freedom Rank],
		[Trust##Government#Corruption#] AS [Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Trust##Government#Corruption#] DESC) AS [Trust (Government Corruption) Rank],
		[Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Generosity] DESC) AS [Generosity Rank],
		[Dystopia#Residual] AS [Dystopia Residual],
		ROW_NUMBER() OVER (ORDER BY [Dystopia#Residual] DESC) AS [Dystopia Residual Rank]
	--INTO #Qry2017
	FROM WorldHappinessReport..[2017]

	UNION ALL

	SELECT
		'2018' AS [Year],
		[Country or region] AS [Country],
		CAST(NULL AS nvarchar) AS [Region],
		ROW_NUMBER() OVER (ORDER BY [Score] DESC) AS [Happiness Rank],
		[Score] AS [Happiness Score],
		CAST(NULL AS int) AS [Whisker Low],
		CAST(NULL AS int) AS [Whisker High],
		CAST(NULL AS int) AS [Standard Error],
		[GDP per capita] AS [Economy (GDP per Capita)],
		ROW_NUMBER() OVER (ORDER BY [GDP per capita] DESC) AS [Economy (GDP per Capita) Rank],
		[Social support] AS [Family (Social Support)],
		ROW_NUMBER() OVER (ORDER BY [Social Support] DESC) AS [Family (Social Support)],
		[Healthy life expectancy] AS [Health (Life Expectancy)],
		ROW_NUMBER() OVER (ORDER BY [Healthy life expectancy] DESC) AS [Health (Life Expectancy) Rank],
		[Freedom to make life choices] AS [Freedom],
		ROW_NUMBER() OVER (ORDER BY [Freedom to make life choices] DESC) AS [Freedom Rank],
		[Perceptions of corruption] AS [Trust (Government Corruption)],
		ROW_NUMBER() OVER (ORDER BY [Perceptions of corruption] DESC) AS [Trust (Government Corruption) Rank],
		[Generosity],
		ROW_NUMBER() OVER (ORDER BY [Generosity] DESC) AS [Generosity Rank],
		CAST (NULL AS int) AS [Dystopia Residual],
		CAST (NULL AS int) AS [Dystopia Residual Rank]
	--INTO #Qry2018
	FROM WorldHappinessReport..[2018]

	UNION ALL

	SELECT --2019
		'2019' AS [Year], 
		[Country or region] AS [Country],
		CAST (NULL AS nvarchar) AS [Region],
		ROW_NUMBER() OVER (ORDER BY [Score] DESC) AS [Happiness Rank],
    	[Score] AS [Happiness Score], 
		CAST (NULL AS int) AS [Whisker Low],
		CAST (NULL AS int) AS [Whisker High],
		CAST (NULL AS int) AS [Standard Error],
		[GDP per capita] AS [Economy (GDP per Capita)], 
		ROW_NUMBER() OVER (ORDER BY [GDP per capita] DESC) AS [Economy (GDP per Capita) Rank],
		[Social support] AS [Family (Social Support)], 
		ROW_NUMBER() OVER (ORDER BY [Social Support] DESC) AS [Family (Social Support) Rank],
		[Healthy life expectancy] AS [Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Healthy life expectancy] DESC) AS [Health (Life Expectancy) Rank],
		[Freedom to make life choices] AS [Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Freedom to make life choices] DESC) AS [Freedom Rank],
		[Perceptions of corruption] AS [Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Perceptions of corruption] DESC) AS [Trust (Government Corruption) Rank],
		[Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Generosity] DESC) AS [Generosity Rank],
		CAST (NULL AS int) AS [Dystopia Residual],
		CAST (NULL AS int) AS [Dystopia Residual Rank]
	--INTO #Qry2019
	FROM WorldHappinessReport..[2019]

	UNION ALL

	SELECT --2020
	--"Explained by" columns correlates with past WRH data.
		'2020' AS [Year], 
		[Country name] AS [Country],
		[Regional indicator] AS [Region],
		ROW_NUMBER() OVER (ORDER BY [Ladder score] DESC) AS [Happiness Rank], 
		[Ladder score] AS [Happiness Score], 
		[lowerwhisker] AS [Whisker Low],
		[upperwhisker] AS [Whisker High],
		[Standard error of ladder score] AS [Standard Error],
		[Explained by: Log GDP per capita] AS [Economy (GDP per Capita)],
		ROW_NUMBER() OVER (ORDER BY [Explained by: Log GDP per capita] DESC) AS [Economy (GDP per Capita) Rank],
		[Explained by: Social support] AS [Family (Social Support)],
		ROW_NUMBER() OVER (ORDER BY [Explained by: Social Support] DESC) AS [Family (Social Support) Rank],		
		[Explained by: Healthy life expectancy] AS [Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Healthy life expectancy] DESC) AS [Health (Life Expectancy) Rank],
		[Explained by: Freedom to make life choices] AS [Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Freedom to make life choices] DESC) AS [Freedom Rank],
		[Explained by: Perceptions of corruption] AS [Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Perceptions of corruption] DESC) AS [Trust (Government Corruption) Rank],		
		[Explained by: Generosity] AS [Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Generosity] DESC) AS [Generosity Rank],
		[Dystopia + residual] AS [Dystopia Residual],
		ROW_NUMBER() OVER (ORDER BY [Dystopia + residual] DESC) AS [Dystopia Residual Rank]
	--INTO #Qry2020
	FROM WorldHappinessReport..[2020]

	UNION ALL

	SELECT --2021
		'2021' AS [Year], 
		[Country name] AS [Country],
		[Regional indicator] AS [Region],
		ROW_NUMBER() OVER (ORDER BY [Ladder score] DESC) AS [Happiness Rank],
		[Ladder score] AS [Happiness Score], 
		[lowerwhisker] AS [Whisker Low],
		[upperwhisker] AS [Whisker High],
		[Standard error of ladder score] AS [Standard Error],
		[Explained by: Log GDP per capita] AS [Economy (GDP per Capita)],
		ROW_NUMBER() OVER (ORDER BY [Explained by: Log GDP per capita] DESC) AS [Economy (GDP per Capita) Rank],
		[Explained by: Social support] AS [Family (Social Support)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Social Support] DESC) AS [Family (Social Support) Rank],
		[Explained by: Healthy life expectancy] AS [Health (Life Expectancy)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Healthy life expectancy] DESC) AS [Health (Life Expectancy) Rank],
		[Explained by: Freedom to make life choices] AS [Freedom], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Freedom to make life choices] DESC) AS [Freedom Rank],
		[Explained by: Perceptions of corruption] AS [Trust (Government Corruption)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Perceptions of corruption] DESC) AS [Trust (Government Corruption) Rank],		
		[Explained by: Generosity] AS [Generosity], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Generosity] DESC) AS [Generosity Rank],
		[Dystopia + residual] AS [Dystopia Residual],
		ROW_NUMBER() OVER (ORDER BY [Dystopia + residual] DESC) AS [Dystopia Residual Rank]
	--INTO #Qry2021
	FROM WorldHappinessReport..[2021]

	UNION ALL

	-- 2022 WHR https://happiness-report.s3.amazonaws.com/2022/WHR+22.pdf
	--TRY_Cast was the only option available to Combine Table with the rest. 
	--REPLACE comma's ',' with periods '.'  
		--Took days to find out comma's were reason that Combine / Join Query had "Error converting data type nvarchart to float" 
	SELECT --2022
		'2022' AS [Year], 
		CAST (Country AS nvarchar) AS [Country],
		CAST (NULL AS nvarchar) AS [Region],
		CAST ([RANK] AS bigint) AS [Happiness Rank], 
		[Happiness score] / 1000 AS [Happiness Score], 
		[Whisker-low] / 1000 AS [Whisker Low],
		[Whisker-high] / 1000 AS [Whisker High],
		CAST ((([Whisker-high] / 1000 - [Whisker-low] / 1000) / (2 * 1.96)) AS float) AS [Standard Error],
		[Explained by: GDP per capita] / 1000 AS [Economy (GDP per Capita)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: GDP per capita] DESC) AS [Economy (GDP per Capita) Rank],
		[Explained by: Social support] / 1000 AS [Family (Social Support)], 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Social Support] DESC) AS [Family (Social Support) Rank],
		[Health (Life Expectancy)] = CAST(CASE WHEN ISNUMERIC([Explained by: Healthy life expectancy]) = 1 THEN TRY_CAST(REPLACE([Explained by: Healthy life expectancy], ',', '.') AS float) END AS float),
		ROW_NUMBER() OVER (ORDER BY [Explained by: Healthy life expectancy] DESC) AS [Health (Life Expectancy) Rank],
		[Freedom] = CAST(CASE WHEN ISNUMERIC([Explained by: Freedom to make life choices]) = 1 THEN TRY_CAST(REPLACE([Explained by: Freedom to make life choices], ',', '.') AS float) END AS float),
		ROW_NUMBER() OVER (ORDER BY [Explained by: Freedom to make life choices] DESC) AS [Freedom Rank],		
		[Trust (Government Corruption)] = CAST(CASE WHEN ISNUMERIC([Explained by: Perceptions of corruption]) = 1 THEN TRY_CAST(REPLACE([Explained by: Perceptions of Corruption], ',', '.') AS float) END AS float),
		ROW_NUMBER() OVER (ORDER BY [Explained by: Perceptions of corruption] DESC) AS [Trust (Government Corruption) Rank],		
		[Generosity] = CAST(CASE WHEN ISNUMERIC([Explained by: Generosity]) = 1 THEN TRY_CAST(REPLACE([Explained by: Generosity], ',', '.') AS float) END AS float), 
		ROW_NUMBER() OVER (ORDER BY [Explained by: Generosity] DESC) AS [Generosity Rank],
		CAST (NULL AS float) AS [Dystopia Residual],
		CAST (NULL AS float) AS [Dystopia Residual Rank]
	--INTO #Qry2022
	FROM WorldHappinessReport..[2022]

) AS CombinedData
ORDER BY Year DESC, [Happiness Rank] ASC
