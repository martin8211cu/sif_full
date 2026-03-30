<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CreaTabla_RHAjusteAnualNoConceptos">
  <cffunction name="up">
    <cfscript>
      execute('
              CREATE TABLE [dbo].[RHAjusteAnualNoConceptos](
                  [RHAAid] [int] NULL,
                  [CIid] [numeric](18, 0) NULL
              ) ON [PRIMARY]
              ALTER TABLE [dbo].[RHAjusteAnualNoConceptos]  WITH CHECK ADD  CONSTRAINT [CIncidentes_RHAjusteAnualNoConceptos_CIid_FK] FOREIGN KEY([CIid])
              REFERENCES [dbo].[CIncidentes] ([CIid])
              ALTER TABLE [dbo].[RHAjusteAnualNoConceptos] CHECK CONSTRAINT [CIncidentes_RHAjusteAnualNoConceptos_CIid_FK]
              ALTER TABLE [dbo].[RHAjusteAnualNoConceptos]  WITH CHECK ADD  CONSTRAINT [RHAjusteAnual_RHAjusteAnualNoConceptos_RHAAid_FK] FOREIGN KEY([RHAAid])
              REFERENCES [dbo].[RHAjusteAnual] ([RHAAid])
              ALTER TABLE [dbo].[RHAjusteAnualNoConceptos] CHECK CONSTRAINT [RHAjusteAnual_RHAjusteAnualNoConceptos_RHAAid_FK]
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('drop table RHAjusteAnualNoConceptos');
    </cfscript>
  </cffunction>
</cfcomponent>

		
