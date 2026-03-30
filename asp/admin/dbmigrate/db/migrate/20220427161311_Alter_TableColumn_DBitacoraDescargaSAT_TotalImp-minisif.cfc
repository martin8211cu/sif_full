<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_TableColumn_DBitacoraDescargaSAT_TotalImp">
  <cffunction name="up">
    <cfscript>
	    changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='TotalImpuesto');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='TotalImpuesto');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
