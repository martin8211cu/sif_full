<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_FAPFTransacciones_esContado">
  <cffunction name="up">
    <cfscript>
      execute("IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPFTransacciones' AND col.COLUMN_NAME = 'esContado')
              alter table  FAPFTransacciones 
              add esContado varchar(25)
      ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		execute("IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
        		AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'FAPFTransacciones' AND col.COLUMN_NAME = 'esContado')
            ALTER TABLE FAPFTransacciones DROP COLUMN esContado
      ");
    </cfscript>
  </cffunction>
</cfcomponent>


		
