<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="crear function generate calendar">
  <cffunction name="up">
    <cfscript>
      execute("
CREATE FUNCTION [dbo].[fn_generate_calendar] (
    @FromDate DATETIME
  , @NoDays   INT)

RETURNS TABLE
WITH SCHEMABINDING
AS
  RETURN
  WITH [E1] ([N]) AS (
    SELECT 1
    UNION ALL
    SELECT 1), --2 rows   
  [E2] ([N]) AS (
    SELECT 1
    FROM    [E1] AS [a]
          , [E1] AS [b]), --4 rows    
  [E4]  ([N]) AS (
    SELECT 1
    FROM    [E2] AS [a]
          , [E2] AS [b]), --16 rows
  [E8]  ([N]) AS (
    SELECT 1
    FROM    [E4] AS [a]
          , [E4] AS [b]), --256 rows
  [E16] ([N]) AS (
    SELECT 1
    FROM    [E8] AS [a]
          , [E8] AS [b]), --65536 rows
  [cteTally]  ([N]) AS (
    SELECT  TOP (ABS(@NoDays))
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM    [E16])
  
  SELECT  [t].[N] AS [SeqNo] -- [SeqNo]=Sequential day number (@FromDate always=1) forward or backwards
        , [dt].[DT] AS [calendar_date] -- [Date]=Date (with 00:00:00.000 for the time component)   
        , [dp].[YY] AS [yyyy] -- [Year]=Four digit year                                                                                                       
        , [dp].[MM] AS [mm] -- [Month]=Month (as an INT)                                    
        , [dp].[DD] AS [dd] -- [Day]=Day (as an INT)                                                
        , DATEPART(dw, [dt].[DT]) AS [day_of_week] -- [WkDNo]=Week day number (based on @@DATEFIRST)                                              
        , [dp].[Dy] AS [day_of_year] -- [JulDay]=Julian day (day number of the year)                        
        , ISNULL (
            (
              CASE
                WHEN ((@@DATEFIRST-1)+(DATEPART (WeekDay, [dt].[DT])-1)) % 7 NOT IN (5,6) THEN 1
              END)
          ,0) AS [is_weekday]
        , DATEPART(dd, [dp].[LDtOfMo]) AS [last_day_of_month] -- [LdOfMo]=Last day of the month             
        , [dp].[LDtOfMo] AS [month_end] -- [LDtOfMo]=Last day of the month as a DATETIME
        , [dp].[Dy] / 7 + 1 AS [week_of_year] -- [JulWk]=Week number of the year                                                                      
        , [dp].[DD] / 7 + 1 AS [week_of_month] -- [WkNo]=Week number              
        , DATEPART(qq, [dt].[DT]) AS [quarter] -- [Qtr]=Quarter number (of the year)   
        , ISNULL (
          (
            CASE
              WHEN [dp].[YY] % 400 = 0 THEN 1
              WHEN [dp].[YY] % 100 = 0 THEN 0
              WHEN [dp].[YY] % 4 = 0 THEN 1
            END
          )
        , 0) AS [is_leap_year]
  FROM    [cteTally] AS [t]
          CROSS APPLY ( --=== Create the date
                      SELECT  DATEADD(dd, ([t].[N] - 1) * SIGN(@NoDays), @FromDate) AS [DT]) AS [dt]
          CROSS APPLY ( --=== Create the other parts from the date above using a 'cCA'
                      -- (Cascading CROSS APPLY (cCA), courtesy of Chris Morris)
                      SELECT  DATEPART(yy, [dt].[DT]) AS [YY]
                            , DATEPART(mm, [dt].[DT]) AS [MM]
                            , DATEPART(dd, [dt].[DT]) AS [DD]
                            , DATENAME(dw, [dt].[DT]) AS [DW]
                            , DATEPART(dy, [dt].[DT]) AS [Dy]
                            , DATEADD(mm, DATEDIFF(mm, -1, [dt].[DT]), -1) AS [LDtOfMo]) AS [dp];
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
IF OBJECT_ID('dbo.fn_generate_calendar') IS NOT NULL 
  DROP FUNCTION [dbo].[fn_generate_calendar];
              ");
    </cfscript>
  </cffunction>
</cfcomponent>
