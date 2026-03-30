<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="DIDeducciones alter contrain">
  <cffunction name="up">
    <cfscript>
      execute('
    	ALTER TABLE [dbo].[DIDeducciones] DROP CONSTRAINT [DIDeducciones_CK05]
		ALTER TABLE [dbo].[DIDeducciones]  WITH CHECK ADD  CONSTRAINT [DIDeducciones_CK05] CHECK  (([DIDmetodo]=(1) OR [DIDmetodo]=(0) OR [DIDmetodo]=(2) OR [DIDmetodo]=(3) OR [DIDmetodo]=(4) OR [DIDmetodo]=(5)))
		ALTER TABLE [dbo].[DIDeducciones] CHECK CONSTRAINT [DIDeducciones_CK05]
	');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
