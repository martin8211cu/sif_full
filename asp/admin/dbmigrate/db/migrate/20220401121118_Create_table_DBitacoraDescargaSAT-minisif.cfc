<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_table_DBitacoraDescargaSAT">
  <cffunction name="up">
    <cfscript>
      execute("     
              
CREATE TABLE dbo.DBitacoraDescargaSAT(
	[DBDSATid] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[Ecodigo] [int] NOT NULL,
	[EBDSATid] [numeric](18, 0) NOT NULL,
	[UUID_Factura] [varchar](100) NULL,
	[RFCEmisor] [varchar](20) NULL,
	[RFCReceptor] [varchar](20) NULL,
	[NombreEmisor] [varchar](200) NULL,
	[NombreReceptor] [varchar](200) NULL,
	[FechaFactura] [datetime] NULL,
	[Total] [decimal](18, 0) NULL,
	[Subtotal] [decimal](18, 0) NULL,
	[TotalImpuesto] [decimal](18, 0) NULL,
	[Serie] [varchar](100) NULL,
	[Folio] [varchar](100) NULL,
	[XML] [varchar](max) NULL,
	[MetodoPago] [varchar](5) NULL,
	[Relacionado] [bit] NULL,
    [FechaTimbrado] [datetime] NULL,
	[ts_rversion] [timestamp] NULL,
	[BMUsucodigo] [numeric](18, 0) NULL,
	[BMfecha] [datetime] NULL,
 CONSTRAINT [PK_DBitacoraDescargaSAT] PRIMARY KEY CLUSTERED 
(
	[DBDSATid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[DBitacoraDescargaSAT]  WITH CHECK ADD  CONSTRAINT [FK_DBitacoraDescargaSAT_EBitacoraDescargaSAT] FOREIGN KEY([EBDSATid], [Ecodigo])
REFERENCES [dbo].[EBitacoraDescargaSAT] ([EBDSATid], [Ecodigo])


ALTER TABLE [dbo].[DBitacoraDescargaSAT] CHECK CONSTRAINT [FK_DBitacoraDescargaSAT_EBitacoraDescargaSAT]

	  ");
	    
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      dropTable('DBitacoraDescargaSAT');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		

		

		

		

		

		
