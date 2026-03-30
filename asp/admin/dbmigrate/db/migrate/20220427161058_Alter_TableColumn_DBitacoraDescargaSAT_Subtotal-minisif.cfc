<cfcomponent extends="asp.admin.dbmigrate.Migration" hint=" Alter_TableColumn_DBitacoraDescargaSAT_Subtotal">
  <cffunction name="up">
    <cfscript>
	    changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='Subtotal');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
		changeColumn(table='DBitacoraDescargaSAT', columnType='money', columnName='Subtotal');
    </cfscript>
  </cffunction>
</cfcomponent>


		

		
