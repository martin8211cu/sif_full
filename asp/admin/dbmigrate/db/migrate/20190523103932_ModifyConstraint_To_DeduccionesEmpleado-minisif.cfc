<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ModifyConstraint_To_DeduccionesEmpleado">
  <cffunction name="up">
    <cfscript>
      execute('
              alter table DeduccionesEmpleado drop constraint DeduccionesEmpleado_CK07
              ALTER TABLE DeduccionesEmpleado  WITH CHECK ADD  CONSTRAINT DeduccionesEmpleado_CK07 CHECK  (([Dmetodo]=(1) OR [Dmetodo]=(0) OR [Dmetodo]=(2) OR [Dmetodo]=(3) OR [Dmetodo]=(4)))      
              ALTER TABLE DeduccionesEmpleado CHECK CONSTRAINT DeduccionesEmpleado_CK07
            ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('
              alter table DeduccionesEmpleado drop constraint DeduccionesEmpleado_CK07
              ALTER TABLE DeduccionesEmpleado  WITH CHECK ADD  CONSTRAINT DeduccionesEmpleado_CK07 CHECK  (([Dmetodo]=(1) OR [Dmetodo]=(0) OR [Dmetodo]=(2)))
              ALTER TABLE DeduccionesEmpleado CHECK CONSTRAINT DeduccionesEmpleado_CK07
            ');
    </cfscript>
  </cffunction>
</cfcomponent>
