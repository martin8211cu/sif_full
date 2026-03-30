<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add columna SNCredyC a SNClasificacionE">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'SNCredyC' AND TABLE_NAME = 'SNClasificacionE'
                )
              BEGIN
                  ALTER TABLE SNClasificacionE add SNCredyC bit not null default(0)
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'SNCredyC' AND TABLE_NAME = 'SNClasificacionE'
                )
              BEGIN
                  ALTER TABLE SNClasificacionE DROP COLUMN SNCredyC
              END");
    </cfscript>
  </cffunction>
</cfcomponent>
