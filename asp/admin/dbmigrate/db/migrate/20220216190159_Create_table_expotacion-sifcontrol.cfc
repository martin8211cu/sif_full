<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_CSAExportacion">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='CSATExportacion',id=true,primaryKey='IdExportacion');
      t.string(columnNames='CSATcodigo', null=false, limit='25');
      t.string(columnNames='CSATdescripcion', null=true, limit='20');
	  t.datetime(columnNames='CSATfechaVigencia', null=true);
	  t.integer(columnNames='CSATestatus', default='0', null=true);
	  t.integer(columnNames='BMUsucodigo', null=true);
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('CSATExportacion');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		

		
