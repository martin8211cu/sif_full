
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Agregar Columna a CSATTipoRel">
  <cffunction name="up">
    <cfscript>
    t = changeTable('CSATTipoRel');
	t.string(columnNames="CSATdefault", default="", null=true, limit="2");
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='CSATTipoRel',columnName='CSATdefault');
    </cfscript>
  </cffunction>
</cfcomponent>

		
