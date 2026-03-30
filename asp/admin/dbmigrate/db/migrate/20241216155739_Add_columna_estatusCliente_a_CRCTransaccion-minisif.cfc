<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add columna estatusCliente a CRCTransaccion ">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'estatusCliente' AND TABLE_NAME = 'CRCTransaccion'
                )
              BEGIN
                  ALTER TABLE CRCTransaccion ADD estatusCliente numeric null
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'estatusCliente' AND TABLE_NAME = 'CRCTransaccion'
                )
              BEGIN
                  ALTER TABLE CRCTransaccion DROP COLUMN estatusCliente
              END");
    </cfscript>
  </cffunction>
</cfcomponent>
