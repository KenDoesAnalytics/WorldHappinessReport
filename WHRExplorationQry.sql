--Original Data/Query Path "C:\Users\kendr\Desktop\ANALYTICS\MICROSOFT SSMS\SQL Server Management Studio\WHRWorldHappinessReportQry.sql"

/*
TABLE: WorldHappinessReport..RegionCoelesced
Match Null Region with Corresponding country when the country is repeated:
	COALESCE function returns first non-null region value for each country. The subquery (SELECT TOP 1 [Region] FROM WorldHappinessReport..CombinedHappinessData AS t2 WHERE t2.[Country] = t1.[Country] AND t2.[Region] IS NOT NULL) is used to find the non-null region value for the repeated country. If a country has a non-null region, it will be used as the region value. Otherwise, the subquery will return null and the COALESCE function will return the corresponding region for the repeated country.
	Utilizes Table WorldHappinessReport..CombinedHappinessData
*/
--SELECT
--	[Year],
--	[Country],
--    COALESCE([Region], 
--             (SELECT TOP 1 [Region] 
--              FROM WorldHappinessReport..CombinedHappinessData AS t2 
--              WHERE t2.[Country] = t1.[Country] AND t2.[Region] IS NOT NULL)
--             ) AS [Region],
--	[Happiness Rank],
--	[Happiness Score],
--	[Whisker Low],
--	[Whisker High],
--	[Standard Error],
--	[Economy (GDP per Capita)], 
--	[Economy (GDP per Capita) Rank],
--	[Family (Social Support)], 
--	[Family (Social Support) Rank],
--	[Health (Life Expectancy)], 
--	[Health (Life Expectancy) Rank],
--	[Freedom], 
--	[Freedom Rank],
--	[Trust (Government Corruption)], 
--	[Trust (Government Corruption) Rank],
--	[Generosity], 
--	[Generosity Rank],
--	[Dystopia Residual],
--	[Dystopia Residual Rank]
----INTO WorldHappinessReport..RegionCoelesced 
--FROM 
--    WorldHappinessReport..CombinedHappinessData as t1



/*
Countries in 2022 that have * at the end have it removed as shown
*/
--UPDATE WorldHappinessReport..RegionCoelesced
--SET Country = REPLACE(Country, '*', '')
--WHERE Country LIKE '%*%';



/*
TABLE: WorldHappinessReport..WHRTop10in2022AllData
	No longer active. Refer to [RegionCoelesced2]
Available WHR Data 2015-2022 for Countries with Top 10 Happiness Ranking in 2022.
	73 rows of 80 present indicate at most x7 countries have been Top 10 WHR between 2015-2021 but has not stayed there for WHR 2022.
	Subquery Top 10 Happiness Ranking in 2022 > All Data for Selected Countires in Order by Year > Rank.
 	Utilizes Table WorldHappinessReport..RegionCoelesced
*/
--SELECT t1.*
----INTO WorldHappinessReport..WHRTop10in2022AllData
--FROM WorldHappinessReport..RegionCoelesced AS t1
--WHERE t1.[Country] = (
--    SELECT TOP 1 [Country]
--    FROM (
--		SELECT TOP 10 [Country]
--		FROM WorldHappinessReport..RegionCoelesced
--		WHERE [Year] = 2022
--		ORDER BY [Happiness Rank]
--    ) AS t2
--    WHERE t2.[Country] = t1.[Country]
--)
--ORDER BY t1.[Year] DESC, t1.[Happiness Rank] ASC



/*
TABLE: WorldHappinessReport..Top10In2022
	No longer active. Refer to [RegionCoelesced2]
Top 10 Countries in WHR-2022, Frequency as Top 10 Rank, and 2015-2022 Rank Sum
	Utilizes WorldHappinessReport..WHRTop10in2022AllData
	SubQuery COUNT(*) function for Frequency/Occurance of each country WHERE Happiness Rank <= 10. 
		CROSS APPLY (LEFT JOIN) Data from Year 2022
	2022 Scores are replaced by Ranking
	Order By Total Happiness Rank (lower is better)
*/
--SELECT 
--	t1.Year,
--	t2.Country, 
--	t1.[Region],
--	t2.[Top10 Frequency], 
--	t2.[2015-2022 RankSum],  
--	t1.[Happiness Rank],
--	t1.[Happiness Score],
--	t1.[Whisker Low], 
--	t1.[Whisker High], 
--	t1.[Standard Error], 
--	t1.[Economy (GDP per Capita)], 
--	t1.[Economy (GDP per Capita) Rank], 
--	t1.[Family (Social Support)], 
--	t1.[Family (Social Support) Rank], 
--	t1.[Health (Life Expectancy)], 
--	t1.[Health (Life Expectancy) Rank], 
--	t1.[Freedom],
--	t1.[Freedom Rank],
--	t1.[Trust (Government Corruption)], 
--	t1.[Trust (Government Corruption) Rank], 
--	t1.[Generosity], 
--	t1.[Generosity Rank], 
--	t1.[Dystopia Residual], 
--	t1.[Dystopia Residual Rank] 
----INTO WorldHappinessReport..Top10In2022
--FROM (
--    SELECT *
--	FROM WorldHappinessReport..WHRTop10in2022AllData
--    WHERE [Year] = 2022
--) AS t1
--CROSS APPLY (
--    SELECT 
--		[Country], 
--		COUNT(CASE WHEN [Happiness Rank] <= 10 THEN 1 END) AS [Top10 Frequency],
--		SUM([Happiness Rank]) AS [2015-2022 RankSum]
--    FROM WorldHappinessReport..WHRTop10in2022AllData AS t2
--    WHERE t2.[Country] = t1.[Country]
--        AND t2.[Happiness Rank] <= 10
--    GROUP BY [Country]
--) AS t2
--ORDER BY t2.[Top10 Frequency] DESC, t2.[2015-2022 RankSum] ASC 



/*
TABLE: 2022Top10AndBrazil 
	No longer active. Refer to [RegionCoelesced2]
Refer to TABLE: 2022Top10AndSelected for Comparison of Code. 
Comparison to Brazil WHR 2022  
*/
--SELECT 
--	[Year],
--	[Country],
--	[Region],
--	[Top10 Frequency],
--	[2015-2022 RankSum],
--	[Happiness Rank],
--	[Whisker Low],
--	[Whisker High],
--	[Standard Error],
--	[Economy (GDP per Capita) Rank],
--	[Family (Social Support) Rank],
--	[Health (Life Expectancy) Rank],
--	[Freedom Rank],
--	[Trust (Government Corruption) Rank],
--	[Generosity Rank],
--	[Dystopia Residual Rank]
--FROM WorldHappinessReport..Top10In2022 AS t1
--UNION ALL
--SELECT t2.[Year],
--       t2.[Country],
--       CAST(t2.[Region] AS nvarchar) AS [Region],
--       t3.[Top10 Frequency],
--       t3.[2015-2022 RankSum],
--       t2.[Happiness Rank],
--       t2.[Whisker Low],
--       t2.[Whisker High],
--       t2.[Standard Error],
--       t2.[Economy (GDP per Capita) Rank],
--       t2.[Family (Social Support) Rank],
--       t2.[Health (Life Expectancy) Rank],
--       t2.[Freedom Rank],
--       t2.[Trust (Government Corruption) Rank],
--       t2.[Generosity Rank],
--       t2.[Dystopia Residual Rank]
--FROM WorldHappinessReport..RegionCoelesced AS t2
--CROSS APPLY (
--	SELECT 
--		[Country], 
--		COUNT(CASE WHEN [Happiness Rank] <= 10 THEN 1 END) AS [Top10 Frequency], 
--		SUM([Happiness Rank]) AS [2015-2022 RankSum]
--	FROM WorldHappinessReport..RegionCoelesced
--	WHERE [Country] = 'Brazil'
--	GROUP BY [Country]
--) AS t3
--WHERE t2.[Country] = 'Brazil'
--    AND t2.[Year] = 2022
--ORDER BY [Top10 Frequency] DESC, [2015-2022 RankSum] ASC 


/*
TABLE(S): Top10In2022AndSelected
	No longer active. Refer to [RegionCoelesced2]
	Following Table is taken from [Top10In2022] Table and [RegionColesced] Table combined. An easier route could have been querying Top10-&-Selected [Country] from [RegionCoelesced] Table
Compare with Other Main / Interested Countries
Include Countries: 'Finland', 'Iceland', 'Switzerland', 'Netherlands', 'New Zealand', 'Australia', 'Germany', 'Canada', 'United States', 'United Kingdom', 'France', 'Costa Rica', 'Singapore', 'Spain', 'Italy', 'Lithuania', 'Panama', 'Brazil', 'Latvia', 'Chile', 'Mexico', 'El Salvador', 'Kuwait*', 'Japan', 'Portugal', 'Argentina', 'Greece', 'South Korea', 'Philippines', 'Thailand', 'Jamaica', 'Colombia', 'Mongolia', 'Malaysia', 'China', 'Peru', 'Vietnam', 'Russia', 'Hong Kong S.A.R. of China', 'Nepal', 'Indonesia', 'Congo', 'Iraq', 'Iran', 'Cambodia', 'Myanmar', 'Sri Lanka', 'Madagascar*', 'Chad*', 'Ethiopia', 'India'
Function: JOIN Alternative to IN of WHERE function
	Initially, the WHERE [Country] IN (...) function was used. This led to 2,100 rows and Inaccuracy in [Top 10 Frequency] and [2015-2022 RankSum], which seemed to be a calculations error. 
	Instead, of using IN in WHERE clause to filter by country, JOIN operation to find the results.
		Noticeable difference: SELECT 'Country_Name' UNION ALL was used with Inner JOIN. This makes EXCEL Concatenante helpful, unless faster tricks are available. 
	Too long time to ask this of ChatGPT. Multiple other requests were made that was not successful. 
Alternate Table Data may include All Years instead of 2022. Then Organize based on [Year] as needed.
*/
--SELECT* --Since SELECT DISTINCT doesn't work, this allows 'ROW_NUMBER' in combination with a subquery to remove duplicates
----INTO WorldHappinessReport..Top10In2022AndSelected
--FROM (	
--	SELECT --finalquery with ROW_NUMBER to remove duplicate rows
--		[Year],
--		[Country],
--		[Region],
--		[Top10 Frequency],
--		[2015-2022 RankSum],
--		[Happiness Rank],
--		[Whisker Low],
--		[Whisker High],
--		[Standard Error],
--		[Economy (GDP per Capita) Rank],
--		[Family (Social Support) Rank],
--		[Health (Life Expectancy) Rank],
--		[Freedom Rank],
--		[Trust (Government Corruption) Rank],
--		[Generosity Rank],
--		[Dystopia Residual Rank],
--		ROW_NUMBER() OVER (PARTITION BY [Country], [Year] ORDER BY [Year] DESC) AS DistinctRowNum
--	FROM (
--		SELECT --subquery Main Table, which contains duplicate rows (ex Finland 2022 from both tables) 
--			[Year],
--			[Country],
--			[Region],
--			[Top10 Frequency],
--			[2015-2022 RankSum],
--			[Happiness Rank],
--			[Whisker Low],
--			[Whisker High],
--			[Standard Error],
--			[Economy (GDP per Capita) Rank],
--			[Family (Social Support) Rank],
--			[Health (Life Expectancy) Rank],
--			[Freedom Rank],
--			[Trust (Government Corruption) Rank],
--			[Generosity Rank],
--			[Dystopia Residual Rank]
--		--INTO WorldHappinessReport..[Top10In2022AndSelected]
--		FROM WorldHappinessReport..Top10In2022 AS t1
--		UNION ALL
--		SELECT 
--			   t2.[Year],
--			   t2.[Country],
--			   CAST(t2.[Region] AS nvarchar) AS [Region],
--			   t3.[Top10 Frequency],
--			   t3.[2015-2022 RankSum],
--			   t2.[Happiness Rank],
--			   t2.[Whisker Low],
--			   t2.[Whisker High],
--			   t2.[Standard Error],
--			   t2.[Economy (GDP per Capita) Rank],
--			   t2.[Family (Social Support) Rank],
--			   t2.[Health (Life Expectancy) Rank],
--			   t2.[Freedom Rank],
--			   t2.[Trust (Government Corruption) Rank],
--			   t2.[Generosity Rank],
--			   t2.[Dystopia Residual Rank]
--		FROM WorldHappinessReport..RegionCoelesced AS t2
--		CROSS APPLY (
--			SELECT 
--				[Country], 
--				COUNT(CASE WHEN [Happiness Rank] <= 10 THEN 1 END) AS [Top10 Frequency], 
--				SUM([Happiness Rank]) AS [2015-2022 RankSum]
--			FROM WorldHappinessReport..RegionCoelesced
--			WHERE [Country] = t2.[Country] -- Join condition to filter by country (instead of IN condition)
--			GROUP BY [Country]
--		) AS t3
--		INNER JOIN (
--			SELECT 'Finland' AS [Country] UNION ALL
--			SELECT 'Iceland' UNION ALL
--			SELECT 'Switzerland' UNION ALL
--			SELECT 'Netherlands' UNION ALL
--			SELECT 'New Zealand' UNION ALL
--			SELECT 'Australia' UNION ALL
--			SELECT 'Germany' UNION ALL
--			SELECT 'Canada' UNION ALL
--			SELECT 'United States' UNION ALL
--			SELECT 'United Kingdom' UNION ALL
--			SELECT 'France' UNION ALL
--			SELECT 'Costa Rica' UNION ALL
--			SELECT 'Singapore' UNION ALL
--			SELECT 'Spain' UNION ALL
--			SELECT 'Italy' UNION ALL
--			SELECT 'Lithuania' UNION ALL
--			SELECT 'Panama' UNION ALL
--			SELECT 'Brazil' UNION ALL
--			SELECT 'Latvia' UNION ALL
--			SELECT 'Chile' UNION ALL
--			SELECT 'Mexico' UNION ALL
--			SELECT 'El Salvador' UNION ALL
--			SELECT 'Kuwait*' UNION ALL
--			SELECT 'Japan' UNION ALL
--			SELECT 'Portugal' UNION ALL
--			SELECT 'Argentina' UNION ALL
--			SELECT 'Greece' UNION ALL
--			SELECT 'South Korea' UNION ALL
--			SELECT 'Philippines' UNION ALL
--			SELECT 'Thailand' UNION ALL
--			SELECT 'Jamaica' UNION ALL
--			SELECT 'Colombia' UNION ALL
--			SELECT 'Mongolia' UNION ALL
--			SELECT 'Malaysia' UNION ALL
--			SELECT 'China' UNION ALL
--			SELECT 'Peru' UNION ALL
--			SELECT 'Vietnam' UNION ALL
--			SELECT 'Russia' UNION ALL
--			SELECT 'Hong Kong S.A.R. of China' UNION ALL
--			SELECT 'Nepal' UNION ALL
--			SELECT 'Indonesia' UNION ALL
--			SELECT 'Congo' UNION ALL
--			SELECT 'Iraq' UNION ALL
--			SELECT 'Iran' UNION ALL
--			SELECT 'Cambodia' UNION ALL
--			SELECT 'Myanmar' UNION ALL
--			SELECT 'Sri Lanka' UNION ALL
--			SELECT 'Madagascar*' UNION ALL
--			SELECT 'Chad*' UNION ALL
--			SELECT 'Ethiopia' UNION ALL
--			SELECT 'India'
--		) AS countries ON t2.[Country] = countries.[Country]
--	) AS subquery
--) AS finalquery
--WHERE 
--	DistinctRowNum = 1
--	--AND t2.[Year] = 2022 --Use to include only specific Year
--ORDER BY [Year] DESC, [Top10 Frequency] DESC, [2015-2022 RankSum] ASC

------------------------------------------------------------------------------------

/*
TABLE RegionCoelesced2
Alternative to Top10In2022 data's; Cleaned version with more available data 
	Year Count (Presence in 2015-2022)
	Top10 Frequency (# Times in Top10)
	2015-2022 RankSum 
	[Avg Rank] = [2015-2022 RankSum] / [Year Count]
*/
--SELECT
--    t1.*,
--    t2.[Year Count],
--    t2.[Top10 Frequency],
--    t2.[2015-2022 RankSum],
--    t2.[Avg Rank]
--INTO WorldHappinessReport..[RegionCoelesced2]
--FROM
--    WorldHappinessReport..RegionCoelesced AS t1
--JOIN
--    (
--        SELECT
--            [Country],
--            COUNT(DISTINCT [Year]) AS [Year Count],
--            COUNT(CASE WHEN [Happiness Rank] <= 10 THEN 1 END) AS [Top10 Frequency],
--            SUM([Happiness Rank]) AS [2015-2022 RankSum],
--            SUM([Happiness Rank]) / COUNT(DISTINCT [Year]) AS [Avg Rank]
--        FROM
--            WorldHappinessReport..RegionCoelesced
--        GROUP BY
--            [Country]
--    ) AS t2 ON t1.[Country] = t2.[Country]
--ORDER BY [Year] DESC, [Happiness Rank] ASC


/*
TABLE RegionCoelesced2 - Updated w/ Column Year Ranks 
Plan to Compare Avg Rank to 2022 Rank &/ All Other Ranks
	1. Change Avg Rank Column into a for each as "Year" from RegionCoelesced2 
	2. Add Column Year 2022 Rank next to Avg Rank 
ALTER TABLE added additional [Year Rank] Columns 
*/
--ALTER TABLE WorldHappinessReport..RegionCoelesced2
--ADD [2015 Rank] INT,
--    [2016 Rank] INT,
--    [2017 Rank] INT,
--	[2018 Rank] INT,
--	[2019 Rank] INT,
--	[2020 Rank] INT,
--	[2021 Rank] INT,
--	[2022 Rank] INT;

/* 
UPDATE & LEFTJOIN for [Happiness Rank] 
*/
--UPDATE t
--SET
--    [2015 Rank] = r2015.[Happiness Rank],
--    [2016 Rank] = r2016.[Happiness Rank],
--    [2017 Rank] = r2017.[Happiness Rank],
--    [2018 Rank] = r2018.[Happiness Rank],
--    [2019 Rank] = r2019.[Happiness Rank],
--    [2020 Rank] = r2020.[Happiness Rank],
--    [2021 Rank] = r2021.[Happiness Rank],
--    [2022 Rank] = r2022.[Happiness Rank]
--FROM WorldHappinessReport..RegionCoelesced2 t
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2015 ON t.[Country] = r2015.[Country] AND r2015.[Year] = 2015
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2016 ON t.[Country] = r2016.[Country] AND r2016.[Year] = 2016
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2017 ON t.[Country] = r2017.[Country] AND r2017.[Year] = 2017
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2018 ON t.[Country] = r2018.[Country] AND r2018.[Year] = 2018
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2019 ON t.[Country] = r2019.[Country] AND r2019.[Year] = 2019
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2020 ON t.[Country] = r2020.[Country] AND r2020.[Year] = 2020
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2021 ON t.[Country] = r2021.[Country] AND r2021.[Year] = 2021
--LEFT JOIN WorldHappinessReport..RegionCoelesced2 r2022 ON t.[Country] = r2022.[Country] AND r2022.[Year] = 2022;

----------------------------------------------------------------

/*
Download Results AS... 
	Tools - Options - Query results - sql server - results to grid (or text) -> Include column headers when copying or saving the results.
	Changed settings are applied to new, but not existing query windows.

POTENTIAL ANALYSIS OPTIONS 
	Happiness Trends: Analyze the happiness scores and ranks over the years to identify any trends or changes in happiness levels for different countries and regions. You can plot line charts or use statistical techniques to observe patterns and changes over time.
		- Data collection: Gather data on happiness scores and ranks for different countries and regions over the years. This data can typically be obtained from reputable sources like the World Happiness Report or other relevant research studies.
		- Data preprocessing: Clean and organize the data to ensure consistency and compatibility. This may involve removing missing values, standardizing variables, and transforming the data into a suitable format for analysis.
		- Exploratory data analysis: Start by examining the basic characteristics of the data, such as the range, distribution, and summary statistics of happiness scores and ranks. This will give you a better understanding of the dataset and help identify any outliers or inconsistencies.
		- Visualize trends over time: Create line charts or time series plots to visualize the changes in happiness scores and ranks over the years. Plotting the data over time allows you to observe patterns, trends, and any significant changes.
		- Statistical analysis: Apply statistical techniques to identify and analyze trends in happiness levels. Some common techniques include:
			a. Trend analysis: Use regression analysis or other time series models to determine if there is a significant trend in happiness scores over time. This can help you identify whether happiness levels are increasing, decreasing, or remaining stable.
			b. Comparative analysis: Compare happiness scores and ranks across different countries or regions to identify variations and differences. You can use statistical tests such as t-tests or analysis of variance (ANOVA) to determine if these differences are statistically significant.
			c. Correlation analysis: Explore the relationships between happiness scores and other variables like GDP, social factors, or environmental factors. Use correlation analysis to measure the strength and direction of these relationships.
		- Interpret the findings: Analyze the results of your statistical analysis and interpret the trends or changes in happiness levels. Consider factors such as economic conditions, social policies, or cultural influences that may contribute to these changes.
		- Communicate the results: Present your findings in a clear and concise manner. Use visualizations, tables, and narratives to effectively communicate the happiness trends to your audience.
	Regional Comparison: Compare the happiness scores and ranks across different regions to identify which regions consistently have higher happiness levels. You can calculate the average happiness scores for each region and visualize the results using bar charts or maps.
		- Data Preparation: Ensure you have a dataset that includes happiness scores and regions for each observation.
		- Calculate Average Happiness Scores: Group the data by regions and calculate the average happiness score for each region. This will give you a measure of the overall happiness level in each region.
		- Rank the Regions: Sort the regions based on their average happiness scores to determine the ranking. This will help identify which regions consistently have higher happiness levels.
		- Visualize the Results: There are several ways to present the regional comparison:
			a. Bar Charts: Create a bar chart with the regions on the x-axis and the average happiness scores on the y-axis. This will allow for a quick visual comparison of the happiness levels across different regions. You can color-code the bars to make it more visually appealing or add error bars to indicate the level of variability.
			b. Maps: Plot the average happiness scores for each region on a map. Use different colors or shades to represent the happiness levels. This will provide a spatial representation of the regional differences in happiness.
		- Interpret the Findings: Analyze the results from the visualizations to identify regions that consistently have higher happiness levels. Look for patterns or trends that emerge from the data. You can also compare the rankings of the regions to understand the relative differences in happiness levels.
		*Remember to label your charts, provide clear legends, and include a title that summarizes the regional comparison. This will make it easier for your audience to understand and interpret the findings.
		Overall, these steps will help you analyze and present the regional comparison of happiness scores, allowing you to identify regions with consistently higher happiness levels and visualize the results effectively.
	Top 10 Frequency: Explore the frequency of countries appearing in the top 10 happiest countries list. Identify which countries consistently rank among the top 10 and analyze the factors contributing to their high happiness levels. You can create a histogram or a bar chart to visualize the frequency.
		- Gather the Data: Obtain the data containing the happiness rankings of countries over a certain period. You can find this data from reliable sources such as the World Happiness Report or other relevant studies.
		- Extract the Top 10: Identify the countries that consistently rank among the top 10 happiest countries. Calculate the frequency of each country appearing in the top 10 over the specified period.
		- Analyze Factors: Research the factors that contribute to the high happiness levels of the countries identified in the previous step. Consider indicators such as GDP per capita, social support, life expectancy, freedom, generosity, and corruption levels. You can refer to the World Happiness Report or other research papers for insights on these factors.
		- Visualize the Frequency: Create a histogram or a bar chart to visually represent the frequency of countries appearing in the top 10. The x-axis of the chart should display the countries, while the y-axis should represent the frequency of their appearance. This visualization will help highlight the countries that consistently rank among the happiest.
		- Provide Insights: Analyze the chart and provide insights into the countries that appear most frequently in the top 10. Discuss the factors that contribute to their high happiness levels based on your research. Consider highlighting any patterns or trends you observe.
		- Present the Findings: Prepare a presentation or report summarizing your analysis. Include the visualization (histogram or bar chart) along with relevant insights and explanations. You can also include supporting data and references to back up your findings.
	Correlation Analysis: Investigate the correlation between happiness scores and various factors such as economy (GDP per capita), social support, life expectancy, freedom, and government corruption. You can calculate correlation coefficients and create scatter plots or heatmaps to visualize the relationships.
		- Data Preparation: Make sure you have a dataset that includes happiness scores and the respective values for each factor (economy, social support, life expectancy, freedom, and government corruption) for multiple observations or countries.
		- Calculate Correlation Coefficients: Compute correlation coefficients to quantify the strength and direction of the relationships between happiness scores and each factor. You can use statistical methods such as Pearson's correlation coefficient or Spearman's rank correlation coefficient, depending on the nature of your data (e.g., linear or non-linear). Most statistical software or programming languages have built-in functions to calculate correlation coefficients.
		- Interpret Correlation Coefficients: Analyze the correlation coefficients to understand the relationships between happiness scores and each factor. A positive correlation coefficient indicates a positive relationship, where higher values of one variable tend to be associated with higher values of the other variable. A negative correlation coefficient indicates an inverse relationship, where higher values of one variable tend to be associated with lower values of the other variable. The magnitude of the correlation coefficient represents the strength of the relationship, with values closer to 1 or -1 indicating a stronger correlation.
		- Create Scatter Plots: Plot scatter plots to visualize the relationships between happiness scores and each factor individually. Each data point represents an observation or country, with the x-axis representing the factor value and the y-axis representing the happiness score. Scatter plots allow you to observe the general pattern or trend between the variables and identify any outliers or clusters.
		- Create Heatmaps: If you want to visualize the correlation between happiness scores and multiple factors simultaneously, you can create a correlation heatmap. This heatmap will display the correlation coefficients in a grid format, with each cell representing the correlation between two variables. You can use a color scale to indicate the strength and direction of the correlation.
		- Present Findings: Once you have analyzed the correlation coefficients and visualized the relationships through scatter plots or heatmaps, you can present your findings. Describe the strength and direction of the relationships, highlight any significant correlations, and discuss the implications of these findings. You can also include the scatter plots or heatmaps in your presentation or report to provide visual support to your analysis.
		*Remember to properly label your axes, provide a clear title for each visualization, and provide explanations or interpretations for your findings.
	Rank Sum Analysis: Examine the rank sum for each country over the years to identify changes in their overall rankings. You can calculate the average rank sum for each country and identify countries that have consistently improved or declined in their rankings.Gather the necessary data: Collect the rankings of each country for each year you want to analyze. Make sure you have a consistent set of rankings for all countries and years.
		- Calculate the rank sum: For each country, sum up its rankings across all the years. This will give you the total rank sum for each country. For example, if a country has rankings of 3, 5, and 2 over three years, the rank sum would be 3 + 5 + 2 = 10.
		- Calculate the average rank sum: Divide the rank sum of each country by the number of years to calculate the average rank sum. This will give you a normalized value that represents the overall ranking performance of each country. For example, if a country's rank sum is 10 and you analyzed data for 3 years, the average rank sum would be 10 / 3 = 3.33.
		- Identify consistent changes: Compare the average rank sums of each country to identify countries that have consistently improved or declined in their rankings. Countries with decreasing average rank sums indicate improvement in their rankings over the years, while increasing average rank sums indicate a decline in rankings.
		- Visualize the results: Create a graph or table to present the average rank sums for each country. You can use a bar chart, line graph, or any other suitable visualization method to showcase the changes in rankings over the years. Make sure to label the countries along the x-axis and the average rank sums along the y-axis.
		- Highlight countries of interest: If you want to emphasize specific countries that have shown significant changes in their rankings, you can use different colors, annotations, or callout boxes to draw attention to them in your presentation or report.
		- Provide analysis and insights: After presenting the data visually, provide additional analysis and insights into the trends and patterns you observe. Discuss the countries that have consistently improved or declined in rankings and speculate on possible factors contributing to these changes.
		*Remember to clearly label your visualizations, provide a legend if needed, and include a title and captions to help your audience understand the Rank Sum Analysis.
	Dystopia Residual: Analyze the dystopia residual scores to understand the gap between a country's happiness score and the lowest possible happiness score. Explore how different regions and countries contribute to the overall happiness levels. You can create box plots or compare means to visualize the differences.
		- Data Preparation: Make sure you have a dataset that includes the happiness scores and dystopia residual scores for different countries. Ensure the dataset is clean and formatted correctly.
		- Calculate the Dystopia Residual: The dystopia residual is the difference between a country's happiness score and the lowest possible happiness score. You can calculate it by subtracting the lowest possible happiness score from each country's happiness score.
		- Grouping by Regions: If your dataset includes information about the regions to which the countries belong, you can group the data based on regions. This will help in comparing the happiness levels across different regions.
		- Statistical Analysis: To understand the differences in dystopia residual scores, you can perform statistical analysis. Two common approaches are:
		- Box Plots: Create box plots to visualize the distribution of dystopia residual scores for each region or country. Box plots provide information about the median, quartiles, and any outliers in the data, allowing you to compare the gaps between regions or countries.
		- Means Comparison: Calculate the mean dystopia residual scores for different regions or countries and compare them. You can use statistical tests such as t-tests or ANOVA to determine if there are significant differences between the groups.
		- Data Visualization: Create visualizations to present your findings effectively. Consider using bar charts, line graphs, or box plots to compare the dystopia residual scores across regions or countries. Add labels, titles, and color schemes to make the visualizations clear and informative.
		- Interpretation and Insights: Analyze the results and draw insights from your findings. Identify which regions or countries have the largest gaps between their happiness scores and the lowest possible happiness score. Determine if there are any significant differences between regions or countries and provide explanations or hypotheses for these differences.
		- Communicate your Analysis: Present your analysis and findings in a clear and concise manner. You can create a report or presentation summarizing the key points, visualizations, and insights. Use language and visual aids that are accessible to your audience and highlight the main takeaways from your analysis.
		*Remember to consider the limitations of your data and analysis while interpreting the results.
	Outlier Detection: Identify any outliers in the dataset where countries have unexpectedly high or low happiness scores compared to their region or other factors. Investigate the possible reasons behind these outliers and examine if they are consistent over the years
		1. Data Preparation:
			- Gather the dataset containing happiness scores and relevant factors for each country and year.
			- Ensure the dataset includes information on regions or other factors for comparison.
			- Clean the data by handling missing values, inconsistencies, or errors.
		2. Define Regions or Factors for Comparison:
			- Identify the regions or factors you want to compare the happiness scores against. For example, you might compare countries within the same geographical region or countries with similar economic indicators.
		3. Calculate Regional or Factor Statistics:
			- Calculate summary statistics (e.g., mean, median, standard deviation) of happiness scores within each region or factor category.
			- Identify the expected range of happiness scores based on the statistics calculated.
		4. Detect Outliers:
			- Use appropriate outlier detection techniques such as z-score, Tukey's fences, or density-based clustering to identify outliers.
			- Apply the chosen method to the happiness scores dataset, considering the regional or factor categories.
		5. Investigate Outliers:
			- Once outliers are identified, examine the possible reasons behind their unexpectedly high or low happiness scores.
			- Consider socio-economic, cultural, political, or historical factors that could contribute to the outliers.
			- Research specific events or circumstances in the outlier countries that might explain the deviations from the norm.
		6. Temporal Consistency:
			- Analyze whether the outliers persist consistently over the years or if they are sporadic.
			- Plot the happiness scores of the outliers over time to observe any patterns or trends.
			- Compare the outliers' behavior with the rest of the dataset to determine if they consistently deviate from the expected range.
		7. Visualize and Present Findings:
			- Create visualizations such as box plots, scatter plots, or bar charts to highlight the outliers and their relationship to the region or other factors.
			- Present the findings in a clear and concise manner, explaining the methodology used and providing insights into the possible reasons for outliers.
			- Consider creating a report or presentation to communicate the analysis and conclusions effectively.
		*Remember that outlier detection is a complex task and may require iterative exploration and refinement of the analysis process.
*You can also combine different analyses or come up with your own research questions based on the available variables.


Microsoft Power BI, Tableau, and Looker:
	Microsoft Power BI:
		- Integration: Power BI seamlessly integrates with other Microsoft tools such as Excel, SharePoint, and Azure services, making it convenient if you already use Microsoft products.
		- User-Friendly: Power BI has a user-friendly interface and is known for its intuitive drag-and-drop functionality, making it easier for users with less technical expertise to create visuals and reports.
		- Data Preparation: Power BI offers robust data preparation capabilities, allowing you to transform and clean your data before creating visuals.
		- Collaboration: Power BI allows for easy collaboration and sharing of reports and dashboards with team members.
		- Pricing: Power BI offers both free and paid versions, with different pricing plans depending on your needs.
	Tableau:
		- Visualization Options: Tableau provides a wide range of interactive and visually appealing charts, graphs, and maps that can be customized to suit your specific requirements.
		- Data Connectivity: Tableau offers extensive connectivity options, enabling you to connect to various data sources, including databases, spreadsheets, cloud services, and more.
		- Advanced Analytics: Tableau has robust analytics capabilities, allowing you to perform advanced calculations, statistical analysis, and data modeling within the tool.
		- Community and Resources: Tableau has a large and active user community, offering a wealth of resources, tutorials, and support.
		- Pricing: Tableau offers different pricing options, including a free Tableau Public version and paid versions for individuals and organizations.
	Looker:
		- Data Modeling: Looker focuses on data modeling and provides a semantic layer that simplifies data exploration and visualization.
		- Customization and Embedding: Looker offers extensive customization options, allowing you to create personalized visualizations and embed them in your own applications or websites.
		- Collaboration: Looker emphasizes collaboration and provides features for sharing, commenting, and annotating reports and dashboards.
		- Data Governance: Looker includes robust data governance features, allowing you to control and manage access to data and reports.
		- Pricing: Looker offers custom pricing based on your specific requirements and needs.
*When choosing between Microsoft Power BI, Tableau, and Looker, consider factors such as your familiarity with the tools, integration with your existing systems, ease of use, data connectivity options, advanced analytics capabilities, collaboration features, available resources and support, and pricing. Evaluating these factors will help you select the tool that best aligns with your goals and requirements for creating graphs and visuals for your portfolio report.
*/


/*
 1.EXPLORATORY - HAPPINESS TRENDS
	Happiness Trends: Analyze the happiness scores and ranks over the years to identify any trends or changes in happiness levels for different countries and regions. You can plot line charts or use statistical techniques to observe patterns and changes over time.
		- Data collection: Gather data on happiness scores and ranks for different countries and regions over the years. This data can typically be obtained from reputable sources like the World Happiness Report or other relevant research studies.
		- Data preprocessing: Clean and organize the data to ensure consistency and compatibility. This may involve removing missing values, standardizing variables, and transforming the data into a suitable format for analysis.
		- Exploratory data analysis: Start by examining the basic characteristics of the data, such as the range, distribution, and summary statistics of happiness scores and ranks. This will give you a better understanding of the dataset and help identify any outliers or inconsistencies.
		- Visualize trends over time: Create line charts or time series plots to visualize the changes in happiness scores and ranks over the years. Plotting the data over time allows you to observe patterns, trends, and any significant changes.
		- Statistical analysis: Apply statistical techniques to identify and analyze trends in happiness levels. Some common techniques include:
			a. Trend analysis: Use regression analysis or other time series models to determine if there is a significant trend in happiness scores over time. This can help you identify whether happiness levels are increasing, decreasing, or remaining stable.
			b. Comparative analysis: Compare happiness scores and ranks across different countries or regions to identify variations and differences. You can use statistical tests such as t-tests or analysis of variance (ANOVA) to determine if these differences are statistically significant.
			c. Correlation analysis: Explore the relationships between happiness scores and other variables like GDP, social factors, or environmental factors. Use correlation analysis to measure the strength and direction of these relationships.
		- Interpret the findings: Analyze the results of your statistical analysis and interpret the trends or changes in happiness levels. Consider factors such as economic conditions, social policies, or cultural influences that may contribute to these changes.
		- Communicate the results: Present your findings in a clear and concise manner. Use visualizations, tables, and narratives to effectively communicate the happiness trends to your audience.
*/


-- 1. 

/* 
Following Dataset may be used to examine the variability amongst Rankings for overall Happiness Score.
	Consider to utilize Range to explore the major differences during the Years for which Data is presented for.
Columns: Country, Min Score, Max Score, Range, StdDevScore, Count, Avg Rank
	Able to compare StdDevScore with Avg Rank, Count, or Range to explore outliers and shifts 
Standard Deviation Score (StdDevScore) quantifies dispersion or variability of set of scores or values; quantifies how much individual scores deviate from the average. 
	StdDevScore = Sqrt of Variance. = Sqrt (Happiness^2 / WHR Count - Avg_Happiness^2)
	StdDevScore is associated, but not directly correlated with range (max to min). Extreme values or outliers may increase StdDevScore
	It is important to remember StdDevScores are taken from Scores of different WHR, which in itself are measured differently year or over year
*/
----Create View RangeAndStandardDeviation AS
----DROP TABLE if exists #StdDevScore
--SELECT *
----INTO #StdDevScore
--FROM (
--	SELECT
--		'All Countries' AS Country,
--		MIN([Happiness Score]) AS MinScore, 
--		MAX([Happiness Score]) AS MaxScore,
--		MAX([Happiness Score]) - MIN ([Happiness Score]) AS Range,
--		SQRT(SUM([Happiness Score]*[Happiness Score])/COUNT(*) - AVG([Happiness Score])*AVG([Happiness Score])) AS StdDevScore,
--		--AVG ([Standard Error]) AS AvgStdError,
--		COUNT(*) AS [Count],
--		NULL AS [Avg Rank]
--	FROM
--		WorldHappinessReport..[RegionCoelesced2]
--	UNION ALL
--	SELECT
--		[Country], 
--		MIN([Happiness Score]) AS MinScore, 
--		MAX([Happiness Score]) AS MaxScore,
--		MAX([Happiness Score]) - MIN ([Happiness Score]) AS Range,
--		SQRT(SUM([Happiness Score]*[Happiness Score])/COUNT(*) - AVG([Happiness Score])*AVG([Happiness Score])) AS StdDevScore,
--		--AVG ([Standard Error]) AS AvgStdError,
--		COUNT(*) AS [Count],
--		[Avg Rank]
--	FROM
--		WorldHappinessReport..[RegionCoelesced2]
--	GROUP BY 
--		[Country],
--		[Avg Rank]
--	) AS subquery
----ORDER BY [Avg Rank] ASC



/*
TABLE HappinessRankings
DISTINCT Country At MaxYear w/ Happiness Ranks. 
	Shows Data for Most Recent Year. Not useful for comparing 
	Shows Happiness Rank for all Years
*/
--SELECT t.*
----INTO WorldHappinessReport..HappinessRankings
--FROM (
--    SELECT Country, MAX(Year) AS MaxYear
--    FROM WorldHappinessReport..RegionCoelesced2
--    GROUP BY Country
--) AS s
--INNER JOIN WorldHappinessReport..RegionCoelesced2 AS t ON t.Country = s.Country AND t.Year = s.MaxYear;


--SELECT *
--FROM WorldHappinessReport..RegionCoelesced2

/*
TO ANALYZE 
WorldData Comparison: USA & Brazil
	- https://www.worlddata.info/country-comparison.php?country1=BRA&country2=USA
No use since unable to properly Copy & Paste unless manually.
*/


