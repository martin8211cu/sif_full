<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ForeignKey_ID_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP CONSTRAINT HDAplicacionCP_FK01');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     execute('ALTER TABLE HDAplicacionCP ADD CONSTRAINT HDAplicacionCP_FK01 FOREIGN KEY (ID) REFERENCES HEAplicacionCP(ID)');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
