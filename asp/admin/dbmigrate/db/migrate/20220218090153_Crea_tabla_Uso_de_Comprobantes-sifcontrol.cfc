<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Crea tabla Uso de Comprobantes">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='CSATUsoComp',id=true,primaryKey='IdUsoComp');
      t.integer(columnNames='idUsoCfdi', null=false);
      t.integer(columnNames='idRegFisc', null=false);
	  t.timestamp(columnNames='ts_rversion', null=true);
	  t.integer(columnNames='BMUsucodigo', null=true);
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('CSATUsoComp');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		
