<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Add_Columns_TraRemision">
  <cffunction name="up">
    <cfscript>
    t = changeTable('Impuestos');
    t.numeric(columnNames="CcuentaTraRemision", null=true);
	t.numeric(columnNames="CFcuentaTraRemision", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='Impuestos',columnName='CcuentaTraRemision');
	removeColumn(table='Impuestos',columnName='CFcuentaTraRemision');
    </cfscript>
  </cffunction>
</cfcomponent>

		
