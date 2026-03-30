<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_esUltimaSemana">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='CalendarioPagos', columnType='boolean', columnName='CPesUltimaSemana', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='CalendarioPagos',columnName='CPesUltimaSemana');
    </cfscript>
  </cffunction>
</cfcomponent>
