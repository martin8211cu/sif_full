<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Modificaciones_Retenciones">
  <cffunction name="up">
    <cfscript>
       execute("
       			
CREATE TABLE [dbo].[DPedido](
  [DOlinea] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
  [Ecodigo] [int] NOT NULL,
  [EOidorden] [numeric](18, 0) NOT NULL,
  [EOnumero] [numeric](18, 0) NOT NULL,
  [DOconsecutivo] [int] NOT NULL,
  [ESidsolicitud] [numeric](18, 0) NULL,
  [DSlinea] [numeric](18, 0) NULL,
  [CMtipo] [char](1) NOT NULL,
  [Cid] [numeric](18, 0) NULL,
  [Aid] [numeric](18, 0) NULL,
  [Alm_Aid] [numeric](18, 0) NULL,
  [ACcodigo] [int] NULL,
  [ACid] [int] NULL,
  [CFid] [numeric](18, 0) NOT NULL,
  [Icodigo] [char](5) NOT NULL,
  [Ucodigo] [char](5) NOT NULL,
  [DClinea] [numeric](18, 0) NULL,
  [CFcuenta] [numeric](18, 0) NULL,
  [CAid] [numeric](18, 0) NULL,
  [DOdescripcion] [varchar](255) NOT NULL,
  [DOalterna] [varchar](1024) NULL,
  [DOobservaciones] [varchar](255) NULL,
  [DOcantidad] [float] NOT NULL,
  [DOcantsurtida] [float] NOT NULL,
  [DOpreciou] [float] NOT NULL,
  [DOtotal] [money] NOT NULL,
  [DOfechaes] [datetime] NOT NULL,
  [DOgarantia] [int] NOT NULL,
  [Ppais] [char](2) NULL,
  [DOfechareq] [datetime] NULL,
  [DOrefcot] [numeric](18, 0) NULL,
  [ETidtracking] [numeric](18, 0) NULL,
  [DOcantliq] [float] NOT NULL,
  [DOjustificacionliq] [varchar](255) NULL,
  [Usucodigoliq] [numeric](18, 0) NULL,
  [fechaliq] [datetime] NULL,
  [BMUsucodigo] [numeric](18, 0) NULL,
  [DOmontodesc] [money] NULL,
  [DOporcdesc] [float] NULL,
  [numparte] [varchar](20) NULL,
  [DOcantexceso] [float] NOT NULL,
  [ts_rversion] [timestamp] NULL,
  [DOimpuestoCosto] [money] NOT NULL,
  [DOimpuestoCF] [money] NOT NULL,
  [EOsecuencia] [int] NOT NULL,
  [PCGDid] [numeric](18, 0) NULL,
  [OBOid] [numeric](18, 0) NULL,
  [DOcontrolCantidad] [bit] NOT NULL,
  [DOmontoSurtido] [money] NOT NULL,
  [FPAEid] [numeric](18, 0) NULL,
  [CFComplemento] [varchar](100) NULL,
  [DOcantSurtSinDoc] [float] NOT NULL,
  [CPDDid] [numeric](18, 0) NULL,
  [DOcantcancel] [float] NULL,
  [DOmontoCancelado] [money] NULL,
  [CPDCid] [numeric](18, 0) NULL,
  [CTDContid] [numeric](18, 0) NULL,
  [codIEPS] [char](5) NULL,
  [DOMontIeps] [money] NOT NULL,
  [DOMontIepsCF] [money] NOT NULL,
 CONSTRAINT [DPedidoFA_PK] PRIMARY KEY CLUSTERED 
(
  [DOlinea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [DPedidoFA_AK01] UNIQUE NONCLUSTERED 
(
  [Ecodigo] ASC,
  [EOnumero] ASC,
  [EOsecuencia] ASC,
  [DOconsecutivo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]



CREATE TABLE [dbo].[EPedido](
  [EOidorden] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
  [Ecodigo] [int] NOT NULL,
  [EOnumero] [numeric](18, 0) NOT NULL,
  [SNcodigo] [int] NOT NULL,
  [CMCid] [numeric](18, 0) NOT NULL,
  [Mcodigo] [numeric](8, 0) NOT NULL,
  [Rcodigo] [char](2) NULL,
  [CMTOcodigo] [char](5) NOT NULL,
  [CMFPid] [numeric](18, 0) NULL,
  [CMIid] [numeric](18, 0) NULL,
  [EOfecha] [datetime] NOT NULL,
  [Observaciones] [varchar](255) NULL,
  [EOtc] [float] NOT NULL,
  [EOrefcot] [numeric](18, 0) NULL,
  [Impuesto] [money] NOT NULL,
  [EOdesc] [money] NOT NULL,
  [EOtotal] [money] NOT NULL,
  [Usucodigo] [numeric](18, 0) NOT NULL,
  [EOfalta] [datetime] NOT NULL,
  [Usucodigomod] [numeric](18, 0) NULL,
  [fechamod] [datetime] NULL,
  [EOplazo] [int] NOT NULL,
  [NAP] [numeric](18, 0) NULL,
  [NRP] [numeric](18, 0) NULL,
  [NAPcancel] [numeric](18, 0) NULL,
  [EOporcanticipo] [numeric](18, 0) NOT NULL,
  [EOestado] [int] NOT NULL,
  [EOImpresion] [char](1) NULL,
  [ETidtracking] [numeric](18, 0) NULL,
  [EOjustificacion] [varchar](255) NULL,
  [CRid] [numeric](18, 0) NULL,
  [EOtipotransporte] [varchar](80) NULL,
  [EOlugarentrega] [varchar](255) NULL,
  [EOdiasEntrega] [int] NULL,
  [BMUsucodigo] [numeric](18, 0) NULL,
  [ts_rversion] [timestamp] NULL,
  [EOsecuencia] [int] NOT NULL,
  [EOhabiles] [bit] NOT NULL,
  [EOFechaAplica] [datetime] NULL,
  [UsucodigoAplica] [numeric](18, 0) NULL,
  [CMPid] [numeric](18, 0) NULL,
  [EOfechaEnvP] [datetime] NULL,
  [EOTiEPS] [money] NULL,
  [ObservacionesCM] [varchar](255) NULL,
 CONSTRAINT [EPedidoFA_PK] PRIMARY KEY CLUSTERED 
(
  [EOidorden] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [EPedidoFA_AK01] UNIQUE NONCLUSTERED 
(
  [Ecodigo] ASC,
  [EOnumero] ASC,
  [EOsecuencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[DPedido] ADD  CONSTRAINT [DPedidoFA_DF28]  DEFAULT ((0)) FOR [DOcantsurtida]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0.00)) FOR [DOcantliq]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0.00)) FOR [DOmontodesc]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0.00)) FOR [DOporcdesc]

ALTER TABLE [dbo].[DPedido] ADD  CONSTRAINT [DPedidoFA_DF29]  DEFAULT ((0)) FOR [DOcantexceso]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOimpuestoCosto]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOimpuestoCF]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [EOsecuencia]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((1)) FOR [DOcontrolCantidad]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOmontoSurtido]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOcantSurtSinDoc]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOcantcancel]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOmontoCancelado]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [CPDCid]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOMontIeps]

ALTER TABLE [dbo].[DPedido] ADD  DEFAULT ((0)) FOR [DOMontIepsCF]

ALTER TABLE [dbo].[EPedido] ADD  CONSTRAINT [EPedidoFA_DF27]  DEFAULT ((0.00)) FOR [EOporcanticipo]

ALTER TABLE [dbo].[EPedido] ADD  DEFAULT ((0)) FOR [EOestado]

ALTER TABLE [dbo].[EPedido] ADD  DEFAULT ((0)) FOR [EOsecuencia]

ALTER TABLE [dbo].[EPedido] ADD  DEFAULT ((0)) FOR [EOhabiles]

ALTER TABLE [dbo].[EPedido] ADD  DEFAULT ((0)) FOR [EOTiEPS]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK01] FOREIGN KEY([Aid])
REFERENCES [dbo].[Articulos] ([Aid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK01]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK02] FOREIGN KEY([Cid])
REFERENCES [dbo].[Conceptos] ([Cid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK02]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK03] FOREIGN KEY([OBOid])
REFERENCES [dbo].[OBobra] ([OBOid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK03]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK04] FOREIGN KEY([Alm_Aid])
REFERENCES [dbo].[Almacen] ([Aid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK04]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK05] FOREIGN KEY([CFid])
REFERENCES [dbo].[CFuncional] ([CFid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK05]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK06] FOREIGN KEY([CAid])
REFERENCES [dbo].[CodigoAduanal] ([CAid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK06]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK07] FOREIGN KEY([EOidorden])
REFERENCES [dbo].[EPedido] ([EOidorden])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK07]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK08] FOREIGN KEY([CFcuenta])
REFERENCES [dbo].[CFinanciera] ([CFcuenta])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK08]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK09] FOREIGN KEY([PCGDid])
REFERENCES [dbo].[PCGDplanCompras] ([PCGDid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK09]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK10] FOREIGN KEY([DClinea])
REFERENCES [dbo].[DCotizacionesCM] ([DClinea])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK10]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK11] FOREIGN KEY([DSlinea])
REFERENCES [dbo].[DSolicitudCompraCM] ([DSlinea])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK11]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK12] FOREIGN KEY([Ucodigo], [Ecodigo])
REFERENCES [dbo].[Unidades] ([Ucodigo], [Ecodigo])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK12]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK13] FOREIGN KEY([Ecodigo], [Icodigo])
REFERENCES [dbo].[Impuestos] ([Ecodigo], [Icodigo])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK13]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK14] FOREIGN KEY([Ecodigo], [ACcodigo])
REFERENCES [dbo].[ACategoria] ([Ecodigo], [ACcodigo])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK14]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK15] FOREIGN KEY([ESidsolicitud])
REFERENCES [dbo].[ESolicitudCompraCM] ([ESidsolicitud])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK15]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK16] FOREIGN KEY([Ecodigo], [ACid], [ACcodigo])
REFERENCES [dbo].[AClasificacion] ([Ecodigo], [ACid], [ACcodigo])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK16]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_FK17] FOREIGN KEY([CPDDid])
REFERENCES [dbo].[CPDocumentoD] ([CPDDid])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_FK17]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [FK__DPedidoFA__CTDCon__3E17DC4A] FOREIGN KEY([CTDContid])
REFERENCES [dbo].[CTDetContrato] ([CTDCont])

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [FK__DPedidoFA__CTDCon__3E17DC4A]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK02] FOREIGN KEY([CMIid])
REFERENCES [dbo].[CMIncoterm] ([CMIid])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK02]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK03] FOREIGN KEY([Mcodigo])
REFERENCES [dbo].[Monedas] ([Mcodigo])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK03]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK04] FOREIGN KEY([CMCid])
REFERENCES [dbo].[CMCompradores] ([CMCid])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK04]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK05] FOREIGN KEY([CMFPid])
REFERENCES [dbo].[CMFormasPago] ([CMFPid])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK05]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK06] FOREIGN KEY([Ecodigo], [Rcodigo])
REFERENCES [dbo].[Retenciones] ([Ecodigo], [Rcodigo])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK06]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK07] FOREIGN KEY([Ecodigo], [SNcodigo])
REFERENCES [dbo].[SNegocios] ([Ecodigo], [SNcodigo])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK07]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK08] FOREIGN KEY([CMTOcodigo], [Ecodigo])
REFERENCES [dbo].[CMTipoOrden] ([CMTOcodigo], [Ecodigo])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK08]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_FK09] FOREIGN KEY([CMPid])
REFERENCES [dbo].[CMProcesoCompra] ([CMPid])

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_FK09]

ALTER TABLE [dbo].[DPedido]  WITH CHECK ADD  CONSTRAINT [DPedidoFA_CK09] CHECK  (([CMtipo]='P' OR [CMtipo]='F' OR [CMtipo]='S' OR [CMtipo]='A'))

ALTER TABLE [dbo].[DPedido] CHECK CONSTRAINT [DPedidoFA_CK09]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_CK28] CHECK  (([EOestado]=(101) OR [EOestado]=(70) OR [EOestado]=(60) OR [EOestado]=(55) OR [EOestado]=(10) OR [EOestado]=(9) OR [EOestado]=(8) OR [EOestado]=(7) OR [EOestado]=(5) OR [EOestado]=(0) OR [EOestado]=(-7) OR [EOestado]=(-8) OR [EOestado]=(-10)))

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_CK28]

ALTER TABLE [dbo].[EPedido]  WITH CHECK ADD  CONSTRAINT [EPedidoFA_CK29] CHECK  (([EOImpresion] IS NULL OR ([EOImpresion]='R' OR [EOImpresion]='I')))

ALTER TABLE [dbo].[EPedido] CHECK CONSTRAINT [EPedidoFA_CK29]



       	");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute("
       		
          drop table DPedido

          drop table EPedido

       	");
    </cfscript>
  </cffunction>
</cfcomponent>
