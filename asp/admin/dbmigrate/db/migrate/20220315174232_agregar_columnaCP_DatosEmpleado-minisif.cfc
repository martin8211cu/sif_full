<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="agregar columnas de DatosEmpleado">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='DEModificables', columnType='string', columnName='DEcodPostal', default='', null=true,limit='50');
	    addColumn(table='DatosEmpleado', columnType='string', columnName='DEcodPostal', default='', null=true,limit='50');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='DEModificables',columnName='DEcodPostal');
		removeColumn(table='DatosEmpleado',columnName='DEcodPostal');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
