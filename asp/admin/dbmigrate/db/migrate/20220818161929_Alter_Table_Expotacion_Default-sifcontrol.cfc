<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Alter_Table_Expotacion_Default">
  <cffunction name="up">
    <cfscript>
    t = changeTable('CSATExportacion');
    t.integer(columnNames="CSATdefault", null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='CSATExportacion',columnName='CSATdefault');
    </cfscript>
  </cffunction>
</cfcomponent>

		
