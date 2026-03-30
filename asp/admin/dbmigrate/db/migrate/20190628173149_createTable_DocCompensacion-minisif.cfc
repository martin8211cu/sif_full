<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="createTable_DocCompensacion">
  <cffunction name="up">
    <cfscript>
      execute("IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacion')
	  	BEGIN
	  		CREATE TABLE [DocCompensacion](
				[idDocCompensacion] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
				[CFid] [numeric](18, 0) NULL,
				[Ecodigo] [int] NULL,
				[Mcodigo] [numeric](18, 0) NOT NULL,
				[CCTcodigo] [char](2) NULL,
				[DocCompensacion] [char](20) NULL,
				[TipoCompensacion] [int] NOT NULL,
				[SNcodigo] [int] NULL,
				[Dmonto] [money] NULL,
				[BMUsucodigo] [numeric](18, 0) NULL,
				[Observaciones] [varchar](255) NULL,
				[Aplicado] [bit] NOT NULL,
				[Ocodigo] [int] NULL,
				[ts_rversion] [timestamp] NULL,
				[Dfechadoc] [datetime] NULL,
				[TipoCompensacionDocs] [int] NOT NULL,
			 CONSTRAINT [DocCompensacion_PK] PRIMARY KEY CLUSTERED 
			(
				[idDocCompensacion] ASC
			)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
			) ON [PRIMARY]

			ALTER TABLE [DocCompensacion] ADD  DEFAULT ((1)) FOR [TipoCompensacion]

			ALTER TABLE [DocCompensacion] ADD  DEFAULT ((0.00)) FOR [Dmonto]

			ALTER TABLE [DocCompensacion] ADD  DEFAULT ((0)) FOR [Aplicado]

			ALTER TABLE [DocCompensacion] ADD  DEFAULT ((1)) FOR [TipoCompensacionDocs]

			ALTER TABLE [DocCompensacion]  WITH NOCHECK ADD  CONSTRAINT [DocCompensacion_FK01] FOREIGN KEY([CFid])
			REFERENCES [CFuncional] ([CFid])

			ALTER TABLE [DocCompensacion] CHECK CONSTRAINT [DocCompensacion_FK01]

			ALTER TABLE [DocCompensacion]  WITH NOCHECK ADD  CONSTRAINT [DocCompensacion_CK07] CHECK  (([TipoCompensacion]=(3) OR [TipoCompensacion]=(2) OR [TipoCompensacion]=(1)))

			ALTER TABLE [DocCompensacion] CHECK CONSTRAINT [DocCompensacion_CK07]

			ALTER TABLE [DocCompensacion]  WITH CHECK ADD  CONSTRAINT [DocCompensacion_CK14] CHECK  (([TipoCompensacionDocs]=(4) OR [TipoCompensacionDocs]=(3) OR [TipoCompensacionDocs]=(2) OR [TipoCompensacionDocs]=(1) OR [TipoCompensacionDocs]=(0)))

			ALTER TABLE [DocCompensacion] CHECK CONSTRAINT [DocCompensacion_CK14]

		END");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
	  		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacion')
				BEGIN
	  				DROP TABLE DocCompensacion
				END");
    </cfscript>
  </cffunction>
</cfcomponent>
