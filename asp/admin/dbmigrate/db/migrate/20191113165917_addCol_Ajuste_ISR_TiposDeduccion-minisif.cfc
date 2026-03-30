<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_Ajuste_ISR">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='TDeduccion', columnType='boolean', columnName='TDesajuste', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='TDeduccion',columnName='TDesajuste');
    </cfscript>
  </cffunction>
</cfcomponent>
