
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="tabla SNegocios add col Contrato">
  <cffunction name="up">
    <cfscript>
    	addColumn(table='SNegocios', columnType='string', columnName='Contrato', limit='50', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SNegocios',columnName='Contrato');
    </cfscript>
  </cffunction>
</cfcomponent>

		
