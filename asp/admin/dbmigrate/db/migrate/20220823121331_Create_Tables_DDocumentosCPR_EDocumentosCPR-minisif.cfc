<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Create_Tables_DDocumentosCPR_EDocumentosCPR">
  <cffunction name="up">
    <cfscript>
      execute("
              IF OBJECT_ID('EDocumentosCPR', 'U') IS NULL
              BEGIN

                    CREATE TABLE [dbo].[EDocumentosCPR](
                  	[IDdocumento] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
                  	[Ecodigo] [int] NOT NULL,
                  	[CPTcodigo] [char](2) NOT NULL,
                  	[EDdocumento] [char](20) NOT NULL,
                  	[Mcodigo] [numeric](8, 0) NOT NULL,
                  	[SNcodigo] [int] NOT NULL,
                  	[Icodigo] [char](5) NULL,
                  	[Ocodigo] [int] NOT NULL,
                  	[Ccuenta] [numeric](18, 0) NULL,
                  	[Rcodigo] [char](2) NULL,
                  	[CFid] [numeric](18, 0) NULL,
                  	[id_direccion] [numeric](18, 0) NULL,
                  	[EDtipocambio] [float] NOT NULL,
                  	[EDimpuesto] [money] NOT NULL,
                  	[EDporcdescuento] [float] NOT NULL,
                  	[EDdescuento] [money] NOT NULL,
                  	[EDtotal] [money] NOT NULL,
                  	[EDfecha] [datetime] NOT NULL,
                  	[EDusuario] [varchar](30) NOT NULL,
                  	[EDdocref] [numeric](18, 0) NULL,
                  	[EDselect] [tinyint] NOT NULL,
                  	[Interfaz] [bit] NOT NULL,
                  	[EDvencimiento] [datetime] NULL,
                  	[EDfechaarribo] [datetime] NULL,
                  	[EDreferencia] [varchar](20) NULL,
                  	[BMUsucodigo] [numeric](18, 0) NULL,
                  	[ts_rversion] [timestamp] NULL,
                  	[TESRPTCid] [numeric](18, 0) NULL,
                  	[IDdocumentorec] [numeric](18, 0) NULL,
                  	[EDtipocambioFecha] [datetime] NULL,
                  	[EDtipocambioVal] [float] NULL,
                  	[NRP] [numeric](18, 0) NULL,
                  	[TESRPTCietu] [int] NOT NULL,
                  	[EVestado] [numeric](18, 0) NULL,
                  	[folio] [int] NULL,
                  	[EDAdquirir] [bit] NOT NULL,
                  	[EDexterno] [bit] NOT NULL,
                  	[TimbreFiscal] [varchar](40) NULL,
                  	[EDTiEPS] [money] NULL,
                  	[EDretencionVariable] [money] NULL,
                  	[FolioReferencia] [varchar](13) NULL,
                  	[IDContable] [numeric](18, 0) NULL,
                   CONSTRAINT [EDocumentosCPR_PK] PRIMARY KEY CLUSTERED 
                    (
                    	[IDdocumento] ASC
                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
                     CONSTRAINT [EDocumentosCPR_AK01] UNIQUE NONCLUSTERED 
                    (
                    	[Ecodigo] ASC,
                    	[CPTcodigo] ASC,
                    	[EDdocumento] ASC,
                    	[SNcodigo] ASC
                    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                    ) ON [PRIMARY]


                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((0)) FOR [EDselect]
                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((0)) FOR [Interfaz]
                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((0)) FOR [TESRPTCietu]
                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((1)) FOR [EDAdquirir]
                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((0)) FOR [EDexterno]
                    ALTER TABLE [dbo].[EDocumentosCPR] ADD  DEFAULT ((0)) FOR [EDTiEPS]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK01] FOREIGN KEY([CFid])
                    REFERENCES [dbo].[CFuncional] ([CFid])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK01]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK02] FOREIGN KEY([Mcodigo])
                    REFERENCES [dbo].[Monedas] ([Mcodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK02]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK03] FOREIGN KEY([Ccuenta])
                    REFERENCES [dbo].[CContables] ([Ccuenta])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK03]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK04] FOREIGN KEY([Ecodigo], [Ocodigo])
                    REFERENCES [dbo].[Oficinas] ([Ecodigo], [Ocodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK04]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK05] FOREIGN KEY([Ecodigo], [Icodigo])
                    REFERENCES [dbo].[Impuestos] ([Ecodigo], [Icodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK05]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK06] FOREIGN KEY([IDdocumentorec])
                    REFERENCES [dbo].[HEDocumentosCP] ([IDdocumento])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK06]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK07] FOREIGN KEY([Ecodigo], [Rcodigo])
                    REFERENCES [dbo].[Retenciones] ([Ecodigo], [Rcodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK07]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK08] FOREIGN KEY([Ecodigo], [SNcodigo])
                    REFERENCES [dbo].[SNegocios] ([Ecodigo], [SNcodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK08]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK09] FOREIGN KEY([Ecodigo], [CPTcodigo])
                    REFERENCES [dbo].[CPTransacciones] ([Ecodigo], [CPTcodigo])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK09]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_FK10] FOREIGN KEY([Ecodigo], [SNcodigo], [id_direccion])
                    REFERENCES [dbo].[SNDirecciones] ([Ecodigo], [SNcodigo], [id_direccion])
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_FK10]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_CK21] CHECK  (([EDselect]=(1) OR [EDselect]=(0)))
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_CK21]
                    ALTER TABLE [dbo].[EDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [EDocumentosCPR_CK27] CHECK  (([TESRPTCietu]=(3) OR [TESRPTCietu]=(2) OR [TESRPTCietu]=(1) OR [TESRPTCietu]=(0)))
                    ALTER TABLE [dbo].[EDocumentosCPR] CHECK CONSTRAINT [EDocumentosCPR_CK27]
              END


              IF OBJECT_ID('DDocumentosCPR', 'U') IS NULL
                BEGIN
              	      CREATE TABLE [dbo].[DDocumentosCPR](
              	      [IDdocumento] [numeric](18, 0) NOT NULL,
              	      [Linea] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
              	      [Cid] [numeric](18, 0) NULL,
              	      [Alm_Aid] [numeric](18, 0) NULL,
              	      [Ecodigo] [int] NULL,
              	      [Dcodigo] [int] NULL,
              	      [Ccuenta] [numeric](18, 0) NULL,
              	      [Aid] [numeric](18, 0) NULL,
              	      [DOlinea] [numeric](18, 0) NULL,
              	      [CFid] [numeric](18, 0) NULL,
              	      [DDdescripcion] [varchar](255) NOT NULL,
              	      [DDdescalterna] [varchar](255) NULL,
              	      [DDcantidad] [float] NOT NULL,
              	      [DDpreciou] [float] NOT NULL,
              	      [DDdesclinea] [money] NOT NULL,
              	      [DDporcdesclin] [float] NOT NULL,
              	      [DDtotallinea] [money] NOT NULL,
              	      [DDtipo] [char](1) NOT NULL,
              	      [DDtransito] [bit] NOT NULL,
	                  [DDembarque] [varchar](20) NULL,
	                  [DDfembarque] [datetime] NULL,
	                  [DDobservaciones] [varchar](255) NULL,
	                  [BMUsucodigo] [numeric](18, 0) NULL,
	                  [Icodigo] [char](5) NULL,
	                  [Ucodigo] [varchar](5) NULL,
	                  [ts_rversion] [timestamp] NULL,
	                  [OCTtipo] [char](1) NULL,
	                  [OCTtransporte] [char](20) NULL,
	                  [OCTfechaPartida] [datetime] NULL,
	                  [OCTobservaciones] [varchar](255) NULL,
	                  [OCCid] [numeric](18, 0) NULL,
	                  [OCid] [numeric](18, 0) NULL,
	                  [ContractNo] [varchar](20) NULL,
	                  [DDimpuestoInterfaz] [money] NULL,
	                  [CFcuenta] [numeric](18, 0) NULL,
	                  [CFComplemento] [varchar](100) NULL,
	                  [FPAEid] [numeric](18, 0) NULL,
	                  [OBOid] [numeric](18, 0) NULL,
	                  [PCGDid] [numeric](18, 0) NULL,
	                  [DSespecificacuenta] [bit] NOT NULL,
	                  [UsucodigoModifica] [numeric](18, 0) NULL,
	                  [CPDCid] [numeric](18, 0) NULL,
	                  [CTDContid] [numeric](18, 0) NULL,
	                  [CambioCF] [int] NOT NULL,
	                  [codIEPS] [char](5) NULL,
	                  [DDMontoIeps] [money] NULL,
	                  [DFacturalinea] [numeric](18, 0) NULL,
                      CONSTRAINT [DDocumentosCPR_PK] PRIMARY KEY CLUSTERED 
                      (
                      	[IDdocumento] ASC,
                      	[Linea] ASC
                      )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                      ) ON [PRIMARY]


                      ALTER TABLE [dbo].[DDocumentosCPR] ADD  DEFAULT ((0)) FOR [DDtransito]        
                      ALTER TABLE [dbo].[DDocumentosCPR] ADD  DEFAULT ((0)) FOR [DSespecificacuenta]        
                      ALTER TABLE [dbo].[DDocumentosCPR] ADD  DEFAULT ((0)) FOR [CPDCid]        
                      ALTER TABLE [dbo].[DDocumentosCPR] ADD  DEFAULT ((0)) FOR [CambioCF]        
                      ALTER TABLE [dbo].[DDocumentosCPR] ADD  DEFAULT ((0)) FOR [DDMontoIeps]        
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK02] FOREIGN KEY([Aid])
                      REFERENCES [dbo].[Articulos] ([Aid])        
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK02]       
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK03] FOREIGN KEY([Cid])
                      REFERENCES [dbo].[Conceptos] ([Cid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK03]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK04] FOREIGN KEY([OBOid])        		
		              REFERENCES [dbo].[OBobra] ([OBOid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK04]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK05] FOREIGN KEY([Alm_Aid])
                      REFERENCES [dbo].[Almacen] ([Aid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK05]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK06] FOREIGN KEY([CFid])
                      REFERENCES [dbo].[CFuncional] ([CFid])    
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK06]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK07] FOREIGN KEY([DOlinea])
                      REFERENCES [dbo].[DOrdenCM] ([DOlinea])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK07]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK08] FOREIGN KEY([Ccuenta])
		              REFERENCES [dbo].[CContables] ([Ccuenta])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK08]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK09] FOREIGN KEY([OCid])
                      REFERENCES [dbo].[OCordenComercial] ([OCid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK09]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK10] FOREIGN KEY([OCCid])
                      REFERENCES [dbo].[OCconceptoCompra] ([OCCid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK10]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK11] FOREIGN KEY([PCGDid])       
		              REFERENCES [dbo].[PCGDplanCompras] ([PCGDid])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK11]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK12] FOREIGN KEY([IDdocumento])
                      REFERENCES [dbo].[EDocumentosCPR] ([IDdocumento])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK12]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK13] FOREIGN KEY([Ecodigo], [Dcodigo])
		              REFERENCES [dbo].[Departamentos] ([Ecodigo], [Dcodigo])       
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK13]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_FK14] FOREIGN KEY([Ecodigo], [Icodigo])
		              REFERENCES [dbo].[Impuestos] ([Ecodigo], [Icodigo])
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_FK14]       
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD FOREIGN KEY([CTDContid])
                      REFERENCES [dbo].[CTDetContrato] ([CTDCont])
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD FOREIGN KEY([CTDContid])
                      REFERENCES [dbo].[CTDetContrato] ([CTDCont])
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_CK18] CHECK  (([DDtipo]='P' OR [DDtipo]='O' OR [DDtipo]='T' OR [DDtipo]='F' OR [DDtipo]='A' OR [DDtipo]='S' OR [DDtipo]='I'))
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_CK18]
                      ALTER TABLE [dbo].[DDocumentosCPR]  WITH CHECK ADD  CONSTRAINT [DDocumentosCPR_CK21] CHECK  (([OCTtipo] IS NULL OR ([OCTtipo]='O' OR [OCTtipo]='F' OR [OCTtipo]='T' OR [OCTtipo]='A' OR [OCTtipo]='B')))
                      ALTER TABLE [dbo].[DDocumentosCPR] CHECK CONSTRAINT [DDocumentosCPR_CK21]
                  END
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("  
            IF OBJECT_ID('DDocumentosCPR', 'U') IS NOT NULL
            BEGIN
	            DROP table DDocumentosCPR
            END

            IF OBJECT_ID('EDocumentosCPR', 'U') IS NOT NULL
            BEGIN
	            DROP TABLE EDocumentosCPR
            END");
    </cfscript>
  </cffunction>
</cfcomponent>

		

		
