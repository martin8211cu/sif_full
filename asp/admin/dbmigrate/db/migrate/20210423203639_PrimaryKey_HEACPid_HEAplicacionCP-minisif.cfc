<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="PrimaryKey_HEACPid_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
	  execute('ALTER TABLE HEAplicacionCP ADD CONSTRAINT HEAplicacionCP_PK PRIMARY KEY (HEACPid)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
	  execute('ALTER TABLE HEAplicacionCP DROP CONSTRAINT HEAplicacionCP_PK');
    </cfscript>
  </cffunction>
</cfcomponent>

		
