<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion_TablaImpuestos_ParametroRetencion">
  <cffunction name="up">
    <cfscript>
      execute("
          IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
          AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'Impuestos' AND col.COLUMN_NAME = 'IRetencion')
       		ALTER TABLE Impuestos ADD IRetencion bit
       	");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
          IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES tab INNER JOIN INFORMATION_SCHEMA.COLUMNS col ON tab.TABLE_NAME = col.TABLE_NAME 
          AND tab.TABLE_TYPE = 'BASE TABLE' AND tab.TABLE_NAME = 'Impuestos' AND col.COLUMN_NAME = 'IRetencion')
       		ALTER TABLE Impuestos DROP COLUMN IRetencion
       	");
    </cfscript>
  </cffunction>
</cfcomponent>
