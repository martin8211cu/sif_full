<!---
    |----------------------------------------------------------------------------------------------|
	| Parameter  | Required | Type    | Default | Description                                      |
    |----------------------------------------------------------------------------------------------|
	| name       | Yes      | string  |         | table name, in pluralized form                   |
	| force      | No       | boolean | false   | drop existing table of same name before creating |
	| id         | No       | boolean | true    | if false, defines a table with no primary key    |
	| primaryKey | No       | string  | id      | overrides default primary key name
    |----------------------------------------------------------------------------------------------|

    EXAMPLE:
      t = createTable(name='employees',force=false,id=true,primaryKey='empId');
      t.string(columnNames='name', default='', null=true, limit='255');
      t.text(columnNames='bio', default='', null=true);
      t.time(columnNames='lunchStarts', default='', null=true);
      t.datetime(columnNames='employmentStarted', default='', null=true);
      t.integer(columnNames='age', default='', null=true);
      t.decimal(columnNames='hourlyWage', default='', null=true);
      t.date(columnNames='dateOfBirth', default='', null=true);
--->
<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="creaTabla_Medicos">
  <cffunction name="up">
    <cfscript>
      	t = createTable(name='Medicos',force=false,id=true,primaryKey='MEid');
      	t.string(columnNames='MEidentificacion', null=false, limit='60');
      	t.string(columnNames='MEnombre', null=false, limit='60');
		t.integer(columnNames='Usucodigo', null=false);
		t.string(columnNames='MEespecialidad', null=false, limit='120');
		t.integer(columnNames='MEactivo', default="1", null=false);
		t.integer(columnNames='CEcodigo', null=false);
		t.integer(columnNames='agenda', null=false);
		t.integer(columnNames='BMUsucodigo', null=true);
      	t.create();
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('Medicos');
    </cfscript>
  </cffunction>
</cfcomponent>

		
