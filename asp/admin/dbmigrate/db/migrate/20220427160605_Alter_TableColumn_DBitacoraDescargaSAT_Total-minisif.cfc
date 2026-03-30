<cfcomponent extends="asp.admin.dbmigrate.Migration" hint=" Alter_TableColumn_DBitacoraDescargaSAT_Total">
  <cffunction name="up">
    <cfscript>
	    changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='Total');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='Total');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
