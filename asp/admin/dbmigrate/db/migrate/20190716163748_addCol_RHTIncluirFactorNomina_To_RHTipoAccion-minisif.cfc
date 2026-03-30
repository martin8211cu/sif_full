<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_RHTIncluirFactorNomina_To_RHTipoAccion">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='RHTipoAccion', columnType='integer', columnName='RHTIncluirFactorNomina');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='RHTipoAccion',columnName='RHTIncluirFactorNomina');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
