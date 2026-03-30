<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_HDAplicacionCP">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='HDAplicacionCP',id=false);
	  t.numeric(columnNames='ID', null=false);
	  t.numeric(columnNames='DAlinea', null=false);
      t.integer(columnNames='Ecodigo', null=false);
      t.integer(columnNames='SNcodigo', null=false);
	  t.numeric(columnNames='CFid', null=true);
	  t.numeric(columnNames='DAidref', null=false);
	  t.char(columnNames='DAtransref', limit='2', null=false);
	  t.char(columnNames='DAdocref', limit='20', null=false);
	  t.money(columnNames='DAmonto', null=false);
	  t.money(columnNames='DAtotal', null=false);
      t.money(columnNames='DAmontodoc', null=false);
	  t.float(columnNames='DAtipocambio', null=false);
	  t.numeric(columnNames='BMUsucodigo', null=true);
	  t.money(columnNames='Rmontodoc', null=false);
	  t.string(columnNames='NumeroEvento', null=true, limit='25');      
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('HDAplicacionCP');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		
