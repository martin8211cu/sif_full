<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_TDespecie_To_TDeduccion">
  <cffunction name="up">
    <cfscript>
      execute('alter table TDeduccion add TDespecie int default 0');
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
                  t.[name] = 'TDeduccion'
              and col.[name] = 'TDespecie'
              and con.[type] = 'D' 
              EXEC('ALTER TABLE TDeduccion DROP CONSTRAINT ' + @constraintName)
              alter table TDeduccion drop column TDespecie
              ");
    </cfscript>
  </cffunction>
</cfcomponent>

		
