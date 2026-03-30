<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="CreaTable_RHAjusteAnualAcumulado">
  <cffunction name="up">
    <cfscript>
      execute('
              CREATE TABLE [dbo].[RHAjusteAnualAcumulado](
                  [RHAAid] [int] NULL,
                  [DEid] [numeric](18, 0) NULL,
                  [RHAAAcumuladoSalario] [numeric](18, 0) NULL,
                  [Tcodigo] [char](10) NULL,
                  [RHAAAEstatus] [bit] NULL,
                  [RHAAAcumulado] [money] NULL,
                  [RHAAAcumuladoExento] [money] NULL,
                  [RHAAAcumuladoGravado] [money] NULL,
                  [RHAAAcumuladoSG] [money] NULL,
                  [RHAAAcumuladoSubsidio] [money] NULL,
                  [RHAAAcumuladoRenta] [money] NULL,
                  [RHAAAcumuladoISR] [money] NULL,
                  [RHAAAcumuladoISPT] [money] NULL,
                  [RHAAAMesInicio] [numeric](18, 0) NULL,
                  [RHAAAMesFinal] [numeric](18, 0) NULL
              ) ON [PRIMARY]

              ALTER TABLE [dbo].[RHAjusteAnualAcumulado]  WITH CHECK ADD  CONSTRAINT [DatosEmpleado_RHAjusteAnualAcumulado_DEid_FK] FOREIGN KEY([DEid])
              REFERENCES [dbo].[DatosEmpleado] ([DEid])
              ALTER TABLE [dbo].[RHAjusteAnualAcumulado] CHECK CONSTRAINT [DatosEmpleado_RHAjusteAnualAcumulado_DEid_FK]
              ALTER TABLE [dbo].[RHAjusteAnualAcumulado]  WITH CHECK ADD  CONSTRAINT [RHAjusteAnual_RHAjusteAnualAcumulado_RHAAid_FK] FOREIGN KEY([RHAAid])
              REFERENCES [dbo].[RHAjusteAnual] ([RHAAid])
              ALTER TABLE [dbo].[RHAjusteAnualAcumulado] CHECK CONSTRAINT [RHAjusteAnual_RHAjusteAnualAcumulado_RHAAid_FK]
              ');
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('drop table RHAjusteAnualAcumulado');
    </cfscript>
  </cffunction>
</cfcomponent>

		
