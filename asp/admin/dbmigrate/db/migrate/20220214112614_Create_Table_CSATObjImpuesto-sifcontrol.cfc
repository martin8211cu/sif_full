<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Table_CSATObjImpuesto">
  <cffunction name="up">
    <cfscript>
      t = createTable(name='CSATObjImpuesto',id=true,primaryKey='IdObjImp');
      t.string(columnNames='CSATcodigo', null=false, limit='25');
      t.string(columnNames='CSATdescripcion', null=true, limit='100');
	  t.datetime(columnNames='CSATfechaVigencia', null=true);
	  t.integer(columnNames='CSATestatus', default='0', null=true);
	  t.integer(columnNames='BMUsucodigo', default='0', null=true);
	  t.integer(columnNames='CSATchekImp', default='0', null=true);
	
      t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('CSATObjImpuesto');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		

		

		

		

		
