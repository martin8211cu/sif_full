<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add_columna_CRDR_TipoReg_CRDocumentoResponsabilidad">
  <cffunction name="up">
    <cfscript>
      execute("IF not exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'CRDR_TipoReg' AND TABLE_NAME = 'CRDocumentoResponsabilidad'
                )
              BEGIN
                  ALTER TABLE CRDocumentoResponsabilidad ADD CRDR_TipoReg numeric null
              END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("IF exists(
                  SELECT * FROM INFORMATION_SCHEMA.COLUMNS
                  WHERE COLUMN_NAME = 'CRDR_TipoReg' AND TABLE_NAME = 'CRDocumentoResponsabilidad'
                )
              BEGIN
                  ALTER TABLE CRDocumentoResponsabilidad DROP COLUMN CRDR_TipoReg
              END");
    </cfscript>
  </cffunction>
</cfcomponent>

		
