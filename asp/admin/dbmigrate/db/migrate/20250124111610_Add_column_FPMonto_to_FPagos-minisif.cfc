<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add column FPMonto to FPagos">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPMonto' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos add FPMonto money null
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPMonto' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos DROP COLUMN FPMonto
              END");
    </cfscript>
  </cffunction>
</cfcomponent>
