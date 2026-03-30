<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_HEAplicacionCP">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='HEAplicacionCP',id=false);
	  t.numeric(columnNames='ID', null=false);
      t.integer(columnNames='Ecodigo', null=false);
	  t.char(columnNames='CPTcodigo', limit='2', null=false);
	  t.char(columnNames='Ddocumento', limit='20', null=false);
	  t.integer(columnNames='SNcodigo', null=false);
      t.numeric(columnNames='Mcodigo', null=false);
      t.numeric(columnNames='CFid', null=true);
	  t.float(columnNames='EAtipocambio', null=false);
	  t.money(columnNames='EAtotal', null=false);
	  t.datetime(columnNames='EAfecha', null=false);
	  t.string(columnNames='EAusuario', null=false, limit='30');
	  t.integer(columnNames='EAselect', null=false);
      t.numeric(columnNames='BMUsucodigo', null=true);
	  t.numeric(columnNames='HEACPreversa', default ='0', null=true);
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('HEAplicacionCP');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		
