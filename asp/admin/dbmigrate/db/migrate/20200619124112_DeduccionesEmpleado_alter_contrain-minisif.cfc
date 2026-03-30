<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="DeduccionesEmpleado_alter contrain">
  <cffunction name="up">
    <cfscript>
      execute('
              ALTER TABLE [dbo].[DeduccionesEmpleado] DROP CONSTRAINT [DeduccionesEmpleado_CK07]
			ALTER TABLE [dbo].[DeduccionesEmpleado]  WITH CHECK ADD  CONSTRAINT [DeduccionesEmpleado_CK07] CHECK  (([Dmetodo]=(1) OR [Dmetodo]=(0) OR [Dmetodo]=(2) OR [Dmetodo]=(3) OR [Dmetodo]=(4) OR [Dmetodo]=(5)))
			ALTER TABLE [dbo].[DeduccionesEmpleado] CHECK CONSTRAINT [DeduccionesEmpleado_CK07]

              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('');
    </cfscript>
  </cffunction>
</cfcomponent>

		
