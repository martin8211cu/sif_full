<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="ModifyConstraint_To_DIDeducciones">
  <cffunction name="up">
    <cfscript>
      execute('
              alter table DIDeducciones drop constraint DIDeducciones_CK05
              ALTER TABLE DIDeducciones  WITH CHECK ADD  CONSTRAINT DIDeducciones_CK05 CHECK  (([DIDmetodo]=(1) OR [DIDmetodo]=(0) OR [DIDmetodo]=(2) OR [DIDmetodo]=(3) OR [DIDmetodo]=(4)))
              ALTER TABLE DIDeducciones CHECK CONSTRAINT DIDeducciones_CK05
            ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('
              alter table DIDeducciones drop constraint DIDeducciones_CK05
              ALTER TABLE DIDeducciones  WITH CHECK ADD  CONSTRAINT DIDeducciones_CK05 CHECK  (([DIDmetodo]=(1) OR [DIDmetodo]=(0) OR [DIDmetodo]=(2)))
              ALTER TABLE DIDeducciones CHECK CONSTRAINT DIDeducciones_CK05
            ');
    </cfscript>
  </cffunction>
</cfcomponent>
