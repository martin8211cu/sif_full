<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CPTransacciones_AddCol_CPTCompensacion">
  <cffunction name="up">
    <cfscript>
      execute("
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'CPTransacciones' AND col.COLUMN_NAME = 'CPTCompensacion')
          ALTER TABLE CPTransacciones ADD CPTCompensacion BIT NULL");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
        IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'CPTransacciones' AND col.COLUMN_NAME = 'CPTCompensacion') 
          ALTER TABLE CPTransacciones DROP COLUMN CPTCompensacion");
    </cfscript>
  </cffunction>
</cfcomponent>
