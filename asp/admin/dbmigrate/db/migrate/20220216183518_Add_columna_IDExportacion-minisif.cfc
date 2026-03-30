
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add columna IDExportacion">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='FAPreFacturaE', columnType='string', columnName='IdExportacion', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='FAPreFacturaE',columnName='IdExportacion');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
