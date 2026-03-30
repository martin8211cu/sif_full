<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_IRTipoPeriodo_To_ImpuestoRenta">
  <cffunction name="up">
    <cfscript>
      execute('alter table ImpuestoRenta add IRTipoPeriodo numeric(18,0) not null default 0');
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
                  t.[name] = 'ImpuestoRenta'
              and col.[name] = 'IRTipoPeriodo'
              and con.[type] = 'D' 
              EXEC('ALTER TABLE ImpuestoRenta DROP CONSTRAINT ' + @constraintName)
              alter table ImpuestoRenta drop column IRTipoPeriodo
              ");
    </cfscript>
  </cffunction>
</cfcomponent>

		
