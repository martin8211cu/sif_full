
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modification_MaxLength_Observacion">
  <cffunction name="up">
    <cfscript>
	          execute("
          ALTER TABLE Documentos
          ALTER COLUMN DEobservacion varchar(5000);

          ALTER TABLE EDocumentosCxC
          ALTER COLUMN DEobservacion varchar(5000);
      ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		      execute("
      select 1
      ");
    </cfscript>
  </cffunction>
</cfcomponent>
