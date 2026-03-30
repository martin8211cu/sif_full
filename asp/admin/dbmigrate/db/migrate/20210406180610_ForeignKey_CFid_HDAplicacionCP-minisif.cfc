<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_CFid_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP ADD CONSTRAINT HDAplicacionCP_FK02 FOREIGN KEY (CFid) REFERENCES CFuncional(CFid)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP CONSTRAINT HDAplicacionCP_FK02');
    </cfscript>
  </cffunction>
</cfcomponent>

		
