
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add columna IdImpuesto">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='FAPreFacturaD', columnType='string', columnName='IdImpuesto', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='FAPreFacturaD',columnName='IdImpuesto');
    </cfscript>
  </cffunction>
</cfcomponent>

		
