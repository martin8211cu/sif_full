<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_Ecodigo_SNcodigo_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP ADD CONSTRAINT HDAplicacionCP_FK03 FOREIGN KEY (Ecodigo,SNcodigo) REFERENCES SNegocios(Ecodigo,SNcodigo)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP CONSTRAINT HDAplicacionCP_FK03');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
