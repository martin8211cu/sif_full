<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addCols_To_RHPuestos">
  <cffunction name="up">
    <cfscript>
      execute('alter table RHPuestos add HE2 numeric(18,4) not null default 0,HE3 numeric(18,4) not null default 0');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('alter table RHPuestos drop column HE3; alter table RHPuestos drop column HE2');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
