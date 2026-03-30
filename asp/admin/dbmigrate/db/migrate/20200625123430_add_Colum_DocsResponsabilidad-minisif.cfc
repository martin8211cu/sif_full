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
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="add_Colum_DocsResponsabilidad">
  <cffunction name="up">
    <cfscript>
    addColumn(table='CRDocumentoResponsabilidad', columnType='numeric', columnName='CRDR_TipoReg', null=true);
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
     removeColumn(table='CRDocumentoResponsabilidad',columnName='CRDR_TipoReg');
    </cfscript>
  </cffunction>
</cfcomponent>
