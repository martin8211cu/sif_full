<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_CFid_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_FK02 FOREIGN KEY (CFid) REFERENCES CFuncional(CFid)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_FK02');
    </cfscript>
  </cffunction>
</cfcomponent>

		
