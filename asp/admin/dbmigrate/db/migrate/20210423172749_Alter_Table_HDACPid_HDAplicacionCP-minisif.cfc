<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_HDACPid_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
       execute('ALTER TABLE HDAplicacionCP ADD HDACPid Int Identity(1,1)');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE HDAplicacionCP DROP COLUMN HDACPid');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
