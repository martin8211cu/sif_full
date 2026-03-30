
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Agregar columna SNnombreFiscal">
  <cffunction name="up">
    <cfscript>
     t = changeTable(name='SNegocios');
      t.string(columnNames="SNnombreFiscal", default="", null=true, limit="255");
      t.change();

    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
    removeColumn(table='SNegocios',columnName='SNnombreFiscal');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
