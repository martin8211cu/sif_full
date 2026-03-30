<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_Ecodigo_SNcodigo_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_FK04 FOREIGN KEY (Ecodigo,SNcodigo) REFERENCES SNegocios(Ecodigo,SNcodigo)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_FK04');
    </cfscript>
  </cffunction>
</cfcomponent>

		
