<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Agregar Columna ts a exportacion">
  <cffunction name="up">
    <cfscript>
       execute('ALTER TABLE CSATExportacion ADD ts_rversion timestamp');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('ALTER TABLE CSATExportacion DROP COLUMN ts_rversion');
    </cfscript>
  </cffunction>
</cfcomponent>
    
   
		

		
