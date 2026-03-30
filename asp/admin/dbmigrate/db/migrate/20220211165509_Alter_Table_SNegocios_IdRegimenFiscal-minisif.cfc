<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_SNegocios_IdRegimenFiscal">
  <cffunction name="up">
    <cfscript>
	    addColumn(table='SNegocios', columnType='integer', columnName='IdRegimenFiscal', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		removeColumn(table='SNegocios',columnName='IdRegimenFiscal');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		
