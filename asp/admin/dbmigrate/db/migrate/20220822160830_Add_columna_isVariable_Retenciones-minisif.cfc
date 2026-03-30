<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add_columna_isVariable_Retenciones">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'isVariable' AND TABLE_NAME = 'Retenciones'
                )
              BEGIN
                  ALTER TABLE Retenciones ADD isVariable bit
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'isVariable' AND TABLE_NAME = 'Retenciones'
                )
              BEGIN
                  ALTER TABLE Retenciones DROP COLUMN isVariable
              END");
    </cfscript>
  </cffunction>
</cfcomponent>

		
