<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="creaTabla_DRHAjusteAnual">
  <cffunction name="up">
    <cfscript>
      execute('
                CREATE TABLE [dbo].[DRHAjusteAnual](
                  [RHAAid] [int] NULL,
                  [DEid] [numeric](18, 0) NULL,
                  [DRHAAAcumulado] [money] NULL,
                  [CIid] [numeric](18, 0) NULL
                ) ON [PRIMARY]
                
                ALTER TABLE [dbo].[DRHAjusteAnual]  WITH CHECK ADD  CONSTRAINT [CIncidentes_DRHAjusteAnual_CIid_FK] FOREIGN KEY([CIid])
                REFERENCES [dbo].[CIncidentes] ([CIid])
                
                ALTER TABLE [dbo].[DRHAjusteAnual] CHECK CONSTRAINT [CIncidentes_DRHAjusteAnual_CIid_FK]
                
                ALTER TABLE [dbo].[DRHAjusteAnual]  WITH CHECK ADD  CONSTRAINT [DatosEmpleado_DRHAjusteAnual_DEid_FK] FOREIGN KEY([DEid])
                REFERENCES [dbo].[DatosEmpleado] ([DEid])

                ALTER TABLE [dbo].[DRHAjusteAnual] CHECK CONSTRAINT [DatosEmpleado_DRHAjusteAnual_DEid_FK]

                ALTER TABLE [dbo].[DRHAjusteAnual]  WITH CHECK ADD  CONSTRAINT [RHAjusteAnual_DRHAjusteAnual_RHAAid_FK] FOREIGN KEY([RHAAid])
                REFERENCES [dbo].[RHAjusteAnual] ([RHAAid])
                
                ALTER TABLE [dbo].[DRHAjusteAnual] CHECK CONSTRAINT [RHAjusteAnual_DRHAjusteAnual_RHAAid_FK]
      ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
        execute('drop table DRHAjusteAnual');
    </cfscript>
  </cffunction>
</cfcomponent>
