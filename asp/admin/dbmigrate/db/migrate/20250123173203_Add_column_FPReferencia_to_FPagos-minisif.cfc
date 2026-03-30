<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add column FPReferencia to FPagos">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPReferencia' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos add FPReferencia varchar(15)
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'FPReferencia' AND TABLE_NAME = 'FPagos'
                )
              BEGIN
                  ALTER TABLE FPagos DROP COLUMN FPReferencia
              END");
    </cfscript>
  </cffunction>
</cfcomponent>
