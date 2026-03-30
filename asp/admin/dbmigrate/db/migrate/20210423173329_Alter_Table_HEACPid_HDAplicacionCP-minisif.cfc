<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_HEACPid_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='HDAplicacionCP', columnType='integer', columnName='HEACPid', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		execute('ALTER TABLE HDAplicacionCP DROP COLUMN HEACPid');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
