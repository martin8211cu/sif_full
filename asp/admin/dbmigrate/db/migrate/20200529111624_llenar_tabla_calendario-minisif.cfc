<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="llenar tabla calendario">
  <cffunction name="up">
    <cfscript>
      execute("
INSERT  [dbo].[calendar] ([calendar_date], [yyyy], [mm], [dd], [day_of_week], [day_of_year], [is_weekday], [last_day_of_month], [month_end], [week_of_year], [week_of_month], [quarter], [is_leap_year])
SELECT  [calendar_date]
      , [yyyy]
      , [mm]
      , [dd]
      , [day_of_week]
      , [day_of_year]
      , [is_weekday]
      , [last_day_of_month]
      , [month_end]
      , [week_of_year]
      , [week_of_month]
      , [quarter]
      , [is_leap_year]
FROM    [dbo].[fn_generate_calendar]('2000-01-01', DATEDIFF(DAY, '20000101', '22001231'));

CREATE NONCLUSTERED INDEX [ix_calendar_yyyy] ON [dbo].[calendar] ([yyyy]);
CREATE NONCLUSTERED INDEX [ix_calendar_mm] ON [dbo].[calendar] ([mm]);
CREATE NONCLUSTERED INDEX [ix_calendar_dd] ON [dbo].[calendar] ([dd]);
CREATE UNIQUE NONCLUSTERED INDEX [ux_calendar_yyyy_mm_dd] ON [dbo].[calendar] ([yyyy], [mm], [dd]);      
      ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('drop table calendar');
    </cfscript>
  </cffunction>
</cfcomponent>
