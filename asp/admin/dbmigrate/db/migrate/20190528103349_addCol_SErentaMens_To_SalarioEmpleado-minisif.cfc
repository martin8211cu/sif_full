<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_SErentaMens_To_SalarioEmpleado">
  <cffunction name="up">
    <cfscript>
      execute('
              	alter table SalarioEmpleado add SErentaMens money not null default 0.0000
				alter table HSalarioEmpleado add SErentaMens money not null default 0.0000
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
              	declare @constraintName varchar(max);
                SELECT 
                        @constraintName = con.[name]   
                from sys.default_constraints con
                left outer join sys.objects t
                    on con.parent_object_id = t.object_id
                left outer join sys.all_columns col
                    on con.parent_column_id = col.column_id
                    and con.parent_object_id = col.object_id
                where 
                    t.[name] = 'SalarioEmpleado'
                and col.[name] = 'SErentaMens'
                and con.[type] = 'D' 
                EXEC('ALTER TABLE SalarioEmpleado DROP CONSTRAINT ' + @constraintName)
                alter table SalarioEmpleado drop column SErentaMens
                
                
                declare @constraintNameH varchar(max);
                SELECT 
                        @constraintNameH = con.[name]   
                from sys.default_constraints con
                left outer join sys.objects t
                    on con.parent_object_id = t.object_id
                left outer join sys.all_columns col
                    on con.parent_column_id = col.column_id
                    and con.parent_object_id = col.object_id
                where 
                    t.[name] = 'HSalarioEmpleado'
                and col.[name] = 'SErentaMens'
                and con.[type] = 'D' 
                EXEC('ALTER TABLE HSalarioEmpleado DROP CONSTRAINT ' + @constraintNameH)
                alter table HSalarioEmpleado drop column SErentaMens
              ");
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		
