<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_ISRDeterminado_Historico">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='HRHSubsidio', columnType='money', columnName='ISRDeterminado', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='HRHSubsidio',columnName='ISRDeterminado');
    </cfscript>
  </cffunction>
</cfcomponent>
