<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_ID_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_FK05 FOREIGN KEY (ID) REFERENCES HEDocumentosCP(IDdocumento)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_FK05');
    </cfscript>
  </cffunction>
</cfcomponent>

		
