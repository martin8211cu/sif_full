<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="addTipoPago_To_DatosEmpleado">
  <cffunction name="up">
    <cfscript>
      execute('alter table DatosEmpleado add DETipoPago numeric default 0 not null');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('alter table DatosEmpleado drop column DETipoPago');
    </cfscript>
  </cffunction>
</cfcomponent>

		
