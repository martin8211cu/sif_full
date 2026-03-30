<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_DErespetaSBC">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='DatosEmpleado', columnType='boolean', columnName='DErespetaSBC', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='DatosEmpleado',columnName='DErespetaSBC');
    </cfscript>
  </cffunction>
</cfcomponent>
