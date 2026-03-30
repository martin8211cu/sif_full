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
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion_Tabla_FATipoPago">
  <cffunction name="up">
   <cfscript>
    addColumn(table='FATipoPago', columnType='numeric', columnName='MPid', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
     <cfscript>
     removeColumn(table='FATipoPago',columnName='MPid');
    </cfscript>
  </cffunction>
</cfcomponent>
