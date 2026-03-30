<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCol_RHLFLISPTRealL_To_RHLiqFLPrev">
  <cffunction name="up">
    <cfscript>
      execute('alter table RHLiqFLPrev add RHLFLISPTRealL money not null default 0');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
				declare @constraintName varchar(max);
				SELECT 
					 con.[name]   
				from sys.default_constraints con
				left outer join sys.objects t
					on con.parent_object_id = t.object_id
				left outer join sys.all_columns col
					on con.parent_column_id = col.column_id
					and con.parent_object_id = col.object_id
				where 
					t.[name] = 'RHLiqFLPrev'
				and col.[name] = 'RHLFLISPTRealL'
				and con.[type] = 'D' 
				EXEC('ALTER TABLE RHLiqFLPrev DROP CONSTRAINT ' + @constraintName)
				alter table RHLiqFLPrev drop column RHLFLISPTRealL
			");
    </cfscript>
  </cffunction>
</cfcomponent>

		
