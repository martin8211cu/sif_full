<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion RHAjusteAnualAcumulado Ajuste Sapiens">
  <cffunction name="up">
    <cfscript>
      execute("alter table RHAjusteAnualAcumulado
				ALTER COLUMN RHAAAcumuladoSalario money");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
       execute("	alter table RHAjusteAnualAcumulado
					ALTER COLUMN RHAAAcumuladoSalario numeric");
    </cfscript>
  </cffunction>
</cfcomponent>

		
