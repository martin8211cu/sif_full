<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_TRegimen">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='TiposNomina', columnType='string', columnName='TRegimen', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='TiposNomina',columnName='TRegimen');
    </cfscript>
  </cffunction>
</cfcomponent>