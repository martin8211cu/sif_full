<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CambiaColumna_PEcantdias_En_PagosEmpledo">
  <cffunction name="up">
    <cfscript>
      execute('alter table PagosEmpleado alter column PEcantdias money');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('alter table PagosEmpleado alter column PEcantdias int');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
