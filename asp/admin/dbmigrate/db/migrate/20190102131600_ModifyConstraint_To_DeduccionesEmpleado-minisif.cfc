<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ModifyConstraint_To_DeduccionesEmpleado">
  <cffunction name="up">
    <cfscript>
      execute('
              alter table DeduccionesEmpleado drop constraint DeduccionesEmpleado_CK07
              ALTER TABLE [dbo].[DeduccionesEmpleado]  WITH CHECK ADD  CONSTRAINT [DeduccionesEmpleado_CK07] CHECK  (([Dmetodo]=(1) OR [Dmetodo]=(0) OR [Dmetodo]=(2)))
              ALTER TABLE [dbo].[DeduccionesEmpleado] CHECK CONSTRAINT [DeduccionesEmpleado_CK07]
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('
              alter table DeduccionesEmpleado drop constraint DeduccionesEmpleado_CK07
              ALTER TABLE [dbo].[DeduccionesEmpleado]  WITH CHECK ADD  CONSTRAINT [DeduccionesEmpleado_CK07] CHECK  (([Dmetodo]=(1) OR [Dmetodo]=(0)))
              ALTER TABLE [dbo].[DeduccionesEmpleado] CHECK CONSTRAINT [DeduccionesEmpleado_CK07]
              ');
    </cfscript>
  </cffunction>
</cfcomponent>

		
