<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_Mcodigo_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_FK03 FOREIGN KEY (Mcodigo) REFERENCES Monedas(Mcodigo)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_FK03');
    </cfscript>
  </cffunction>
</cfcomponent>

		
