<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_HEACPid_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
	    execute('ALTER TABLE HEAplicacionCP ADD HEACPid Int Identity(1,1)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		execute('ALTER TABLE HEAplicacionCP DROP COLUMN HEACPid');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
