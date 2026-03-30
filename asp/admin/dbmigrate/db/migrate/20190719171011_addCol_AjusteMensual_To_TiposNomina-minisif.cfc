<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_AjusteMensual_To_TiposNomina">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='TiposNomina', columnType='integer', columnName='AjusteMensual');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='TiposNomina',columnName='AjusteMensual');
    </cfscript>
  </cffunction>
</cfcomponent>

		
