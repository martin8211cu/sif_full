<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CCTransacciones_AddCol_CCTCompensacion">
  <cffunction name="up">
    <cfscript>
      execute("
        IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'CCTransacciones' AND col.COLUMN_NAME = 'CCTCompensacion')
          ALTER TABLE CCTransacciones ADD CCTCompensacion BIT NULL");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
        IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'CCTransacciones' AND col.COLUMN_NAME = 'CCTCompensacion')      
          ALTER TABLE CCTransacciones DROP COLUMN CCTCompensacion");
    </cfscript>
  </cffunction>
</cfcomponent>
