<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="createTable_DocCompensacionDCxP">
  <cffunction name="up">
    <cfscript>
      execute("
		IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacionDCxP')
			BEGIN	  
				CREATE TABLE [DocCompensacionDCxP](
					[idDetalle] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
					[idDocCompensacion] [numeric](18, 0) NOT NULL,
					[idDocumento] [numeric](18, 0) NOT NULL,
					[CPTcodigo] [char](2) NULL,
					[Ddocumento] [char](20) NULL,
					[Dmonto] [money] NULL,
					[BMUsucodigo] [numeric](18, 0) NULL,
					[Referencia] [varchar](20) NULL,
					[ts_rversion] [timestamp] NULL,
					[DmontoRet] [money] NOT NULL,
					[NumeroEvento] [varchar](25) NULL,
					CONSTRAINT [DocCompensacionDCxP_PK] PRIMARY KEY CLUSTERED 
					(
					[idDetalle] ASC
					)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
					) ON [PRIMARY]

					ALTER TABLE [DocCompensacionDCxP] ADD  DEFAULT ((0)) FOR [DmontoRet]

					ALTER TABLE [DocCompensacionDCxP]  WITH NOCHECK ADD  CONSTRAINT [DocCompensacionDCxP_FK01] FOREIGN KEY([idDocCompensacion])
					REFERENCES [DocCompensacion] ([idDocCompensacion])

					ALTER TABLE [DocCompensacionDCxP] CHECK CONSTRAINT [DocCompensacionDCxP_FK01]

					ALTER TABLE [DocCompensacionDCxP]  WITH CHECK ADD  CONSTRAINT [DocCompensacionDCxP_FK02] FOREIGN KEY([idDocumento])
					REFERENCES [HEDocumentosCP] ([IDdocumento])

					ALTER TABLE [DocCompensacionDCxP] CHECK CONSTRAINT [DocCompensacionDCxP_FK02]
					
			END");

    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
	  	  		IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DocCompensacionDCxP')
				BEGIN
	  				DROP TABLE DocCompensacionDCxP
				END");
    </cfscript>
  </cffunction>
</cfcomponent>
