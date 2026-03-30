<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificacion TiposNomina addCol Contabilizar">
  <cffunction name="up">
    <cfscript>
    t = changeTable('TiposNomina');
    t.boolean(columnNames="Contabilizar",null=true);
    t.change();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='TiposNomina',columnName='Contabilizar');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
