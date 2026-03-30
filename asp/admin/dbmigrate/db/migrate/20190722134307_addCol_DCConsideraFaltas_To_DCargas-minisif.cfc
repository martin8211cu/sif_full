<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_DCConsideraFaltas_To_DCargas">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='DCargas', columnType='integer', columnName='DCConsideraFaltas');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='DCargas',columnName='DCConsideraFaltas');
    </cfscript>
  </cffunction>
</cfcomponent>

		
