<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CreaTabla_RHAjusteAnualNomina">
  <cffunction name="up">
    <cfscript>
      execute('
              CREATE TABLE [dbo].[RHAjusteAnualNomina](
                  [RHAAid] [int] NULL,
                  [Tcodigo] [char](10) NULL,
                  [CPid] [numeric](18, 0) NULL,
                  [CPcodigo] [char](12) NULL
              ) ON [PRIMARY]

              ALTER TABLE [dbo].[RHAjusteAnualNomina]  WITH CHECK ADD  CONSTRAINT [RHAjusteAnual_RHAjusteAnualNomina_RHAAid_FK] FOREIGN KEY([RHAAid])
              REFERENCES [dbo].[RHAjusteAnual] ([RHAAid])
              ALTER TABLE [dbo].[RHAjusteAnualNomina] CHECK CONSTRAINT [RHAjusteAnual_RHAjusteAnualNomina_RHAAid_FK]
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('drop table RHAjusteAnualNomina');
    </cfscript>
  </cffunction>
</cfcomponent>

		
