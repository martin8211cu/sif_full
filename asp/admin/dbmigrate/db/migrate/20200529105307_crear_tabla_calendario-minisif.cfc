<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="crear_tabla_calendario">
  <cffunction name="up">
    <cfscript>
      execute("
IF OBJECT_ID('calendar') IS NOT NULL
  DROP TABLE [calendar];

CREATE TABLE [calendar]
    (PRIMARY KEY ([calendar_date])
  , [calendar_date]     DATETIME  NOT NULL
  , [yyyy]              INT       NOT NULL
  , [mm]                INT       NOT NULL
  , [dd]                INT       NOT NULL
  , [day_of_week]       INT       NOT NULL
  , [day_of_year]       INT       NOT NULL
  , [is_weekday]        BIT       NOT NULL
  , [last_day_of_month] INT       NOT NULL
  , [month_end]         DATETIME  NOT NULL
  , [week_of_year]      INT       NOT NULL
  , [week_of_month]     INT       NOT NULL
  , [quarter]           INT       NOT NULL
  , [is_leap_year]      BIT       NOT NULL);
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
IF OBJECT_ID('calendar') IS NOT NULL
  DROP TABLE [calendar];
      ");
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
