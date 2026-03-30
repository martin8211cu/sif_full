<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_ISRDeterminado">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='RHSubsidio', columnType='money', columnName='ISRDeterminado', default='', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='RHSubsidio',columnName='ISRDeterminado');
    </cfscript>
  </cffunction>
</cfcomponent>
