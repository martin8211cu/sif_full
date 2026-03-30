<!---
    |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
    |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | existing table name                              |
    |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      t = changeTable(name='employees');
      t.string(columnNames="fullName", default="", null=true, limit="255");
      t.change();


	 
			
			
--->
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion_Trabla_FAPreFacturaE">
  <cffunction name="up">
    <cfscript>
    t = changeTable('FAPreFacturaE');
    t.string(columnNames="DatosContacto", default="", null=true, limit="255");
	t.string(columnNames="NumDatoBancarios", default="", null=true, limit="255");
	t.string(columnNames="NumOrdenServicio", default="", null=true, limit="255");
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='FAPreFacturaE',columnName='DatosContacto');
 	removeColumn(table='FAPreFacturaE',columnName='NumDatoBancarios');
	removeColumn(table='FAPreFacturaE',columnName='NumOrdenServicio');
    </cfscript>
  </cffunction>
</cfcomponent>

		
