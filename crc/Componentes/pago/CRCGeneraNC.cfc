<cfcomponent output="false" displayname="CRCGeneraNC" >

	<cffunction  name="CreaNC">
		<cfargument  name="CentroFuncionalID" type="numeric">
		<cfargument  name="ConceptoId" type="numeric">
		<cfargument  name="Monto" type="numeric">

		<!--- Obtiene el id del Socio de Negocio --->
		<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
		<cfset val = objParams.GetParametroInfo('30200101')>
		<cfif val.valor eq ''><cfthrow message="El parametro [30200101 - Cuenta generica de cliente vales] no esta definido"></cfif>

		<!--- Obtiene los datos del Socio de Negocio --->
		<cfquery name="q_SNegocio" datasource="#session.dsn#">
			select SNcodigo,isNull(SNcuentacxc,'') SNcuentacxc,* 
			from SNegocios where SNid = #val.valor#
		</cfquery>

		<!--- Valida que exista el Socio de Negocio --->
		<cfif q_SNegocio.recordCount eq 0>
			<cfthrow message="El Socio de Negocio especificado en el parametro [30200101 - Cuenta generica de cliente vales] no existe">
		</cfif>
		<!--- Valida que esté configurada el id de CxC --->
		<cfif q_SNegocio.SNcuentacxc eq ''>
			<cfthrow message="No se ha configurado una Cuenta por Cobrar para el Socio de Negocio [#q_SNegocio.SNnumero#: #q_SNegocio.SNnombre#]">
		</cfif>
		<!--- Obtiene los datos de la cuenta por cobrar --->
		<cfquery name="q_CuentaCxC" datasource="#session.dsn#">
			select * from CContables where Ccuenta = #q_SNegocio.SNcuentacxc#;
		</cfquery>
		<!--- Valida que la cuenta especificada exista --->
		<cfif q_CuentaCxC.recordCount eq 0>
			<cfthrow message="El Socio de Negocio especificado en el parametro [30200101 - Cuenta generica de cliente vales] no existe">
		</cfif>

		<!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
		<cfquery name="q_Moneda" datasource="#session.dsn#">
			select e.Mcodigo, m.Miso4217
			from empresas e
				inner join Monedas m
					on m.Mcodigo = e.Mcodigo
			where e.Ecodigo = #session.ecodigo#;
		</cfquery>

		<!--- id de Centro Funcional --->
		<cfset CentroFuncionalID = arguments.CentroFuncionalID>

		<!--- Se obtiene el Ocodigo para el detalle del pago--->
		<cfquery name="q_CFuncional" datasource="#session.dsn#">
			select cf.Ocodigo, Dcodigo, cf.CFcodigo
				from CFuncional cf
				where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">
		</cfquery>

		<!--- id de concepto, crear parametro Cid--->
		<cfset ConceptoServicioID = arguments.ConceptoId>
		<!--- Se obtiene el Ocodigo para el detalle del pago--->
		<cfquery name="q_CServicio" datasource="#session.dsn#">
			select c.Cid, c.Ccodigo, c.Cdescripcion, c.Cformato
			from Conceptos c
			where c.Ecodigo = #Session.Ecodigo#
				and c.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">
		</cfquery>
		<!--- Valida que la cuenta especificada exista --->
		<cfif q_CServicio.Cformato eq "" >
			<cfthrow message="No se ha definido la Cuenta Contable en el Concepto de Servicio especificado en el parametro [30200505 - Concepto de Servicio por Pronto Pago]">
		</cfif>

		<!--- Fecha de Nota de Credito --->
		<cfset NC_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

		<!--- Determinar el codigo de documento --->
		<cfset CodigoDocumento = "CRC-NCD-#DateTimeFormat(now(),'yymmddhhmmss')#">

		<!--- Adecuación para obtener el código de Exportación CFDI40--->
		<cfquery name="q_Exportacion" datasource="#session.dsn#">
			select IdExportacion from CSATExportacion
			where CSATdefault = 1
		</cfquery>
		<cfif q_Exportacion.IdExportacion eq "">
			<cfthrow message="No se ha definido un valor default para la exportación">
		</cfif>


		<cftransaction>

			<!--- Inserta encabezado de NC --->
			<cfquery name="insertEnc" datasource="#session.dsn#">
				INSERT INTO FAPreFacturaE
					(Ecodigo, PFDocumento, Ocodigo, SNcodigo, Mcodigo, FechaCot, FechaVen, PFTcodigo, TipoPago, Estatus,
						Descuento, Impuesto, Total, NumOrdenCompra,
						Observaciones, TipoCambio, BMUsucodigo, fechaalta, id_direccion, Fecha_doc,vencimiento,Rcodigo,
						IdExportacion)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CodigoDocumento#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#q_CFuncional.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#q_SNegocio.SNcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Moneda.Mcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#NC_Date#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#NC_Date#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="PN">,
					0,
					'P',
					0,
					0, 0,
					null,
					'',
					1, <!--- TODO --->
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#q_SNegocio.id_direccion#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#NC_Date#">,
					0,
					-1,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#q_Exportacion.IdExportacion#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="q_insertEncabezadoNC">
			<cfset idE_NC = q_insertEncabezadoNC.identity>

			<!--- Inserta Detalle de NC  --->
			<cfobject component="sif.Componentes.AplicarMascara" name="mascara">
			<cfset _formatoDescuento = mascara.AplicarMascara(q_CServicio.Cformato, q_CFuncional.CFcodigo, '!')>
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#_formatoDescuento#"/>
				<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_Ecodigo" 			value="#Session.Ecodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfthrow message="#LvarERROR#. Proceso Cancelado!">
			</cfif>
		<!---         Se obtiene la cuenta contable --->
			<cfquery name="rsCcuentaServicio" datasource="#session.dsn#">
				select Ccuenta,Cdescripcion from CContables where Cformato = '#trim(_formatoDescuento)#' and Ecodigo = #Session.Ecodigo#
			</cfquery>

			<cfquery name="proxLinea" datasource="#session.dsn#">
				select 	(coalesce(max(Linea),0) + 1) as Linea
				from 	FAPreFacturaD
				where 	Ecodigo = #session.Ecodigo#
					and IDpreFactura = #idE_NC#
			</cfquery>

			<cfset crcObjParametros = createobject("component","crc.Componentes.CRCParametros")>
			<cfset _icodigo = crcObjParametros.GetParametro(codigo='30300106',conexion=session.dsn,ecodigo=session.ecodigo)>

			<cfif _icodigo eq ''>
				<cfthrow errorcode="30300106" type="ParametroException" message = "No se ha configurado el Impuesto para Notas de Credito y Comisiones">
			</cfif>	

			<cfquery name="rsImpuestos" datasource="#Session.DSN#">
				select Icodigo,Idescripcion,Iporcentaje, ieps, IEscalonado, TipoCalculo, ValorCalculo, Icreditofiscal
				from Impuestos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Icodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#_icodigo#">
			</cfquery>

			<!---Adecuación para obtener el Objeto impuesto CFDI40--->
			<cfset objImp = 1>
			<cfif rsImpuestos.Icreditofiscal eq 1>
				<cfset objImp = 2>
			</cfif>

			<cfset _total = LSParseNumber(arguments.Monto)>
			<cfset _subtotal = (_total/(1+(rsImpuestos.Iporcentaje/100))) >
				
			<cfquery name="q_insertDetalleNC" datasource="#Session.DSN#" >
				INSERT INTO FAPreFacturaD
						(Ecodigo, Linea, IDpreFactura, Cantidad, TipoLinea, Aid, Alm_Aid, Cid, CFid, Icodigo, Descripcion,
						Descripcion_Alt, PrecioUnitario, DescuentoLinea, TotalLinea, BMUsucodigo, fechaalta, Ccuenta, codIEPS, FAMontoIEPSLinea, afectaIVA,
						IdImpuesto)
				VALUES  (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#proxLinea.Linea#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_NC#">,
						1,
						'S',
						null,
						null,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#_icodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#q_CServicio.Cdescripcion#">,
						null,
						<cfqueryparam cfsqltype="cf_sql_money" value="#_subtotal#">,
						0,
						<cfqueryparam cfsqltype="cf_sql_money" value="#_subtotal#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mm/yyyy')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCcuentaServicio.Ccuenta#">,
						-1,
						0,
						1,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#objImp#">
					)
			</cfquery>

			<!--- Actualiza Encabezado --->
			<cfquery name="validaIEPS" datasource="#session.dsn#">
				select SUM(isnull(FAMontoIEPSLinea,0)) as valid from FAPreFacturaD d
							inner join FAPreFacturaE ce
								on ce.IDpreFactura = d.IDpreFactura
									and ce.Ecodigo = d.Ecodigo
				where d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and d.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_NC#">
			</cfquery>
			<cfquery name="rsTotales" datasource="#session.DSN#">
				SELECT SUM(sumImpuesto) AS sumImpuesto, SUM(sumDescuento) sumDescuento, SUM(sumSubTotal) sumSubTotal, SUM(IEPS) IEPS
				FROM (SELECT SUM(d.DescuentoLinea) as sumDescuento, SUM(Cantidad * PrecioUnitario) as sumSubTotal, SUM(isnull(FAMontoIEPSLinea,0)) as IEPS,
							case d.afectaIVA
								when 0 then
									SUM((((Cantidad * PrecioUnitario) - d.DescuentoLinea) + d.FAMontoIEPSLinea) * (i.Iporcentaje / 100))
								else
									SUM(((Cantidad * PrecioUnitario) - d.DescuentoLinea) * (i.Iporcentaje / 100))
								end as sumImpuesto
						from FAPreFacturaD d
							inner join FAPreFacturaE ce
								on ce.IDpreFactura = d.IDpreFactura
									and ce.Ecodigo = d.Ecodigo
							inner join Impuestos i
								on i.Icodigo = d.Icodigo
									and i.Ecodigo = ce.Ecodigo
							left join Impuestos ii
								on ii.Icodigo = d.codIEPS
									and ii.Ecodigo = ce.Ecodigo
							where d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and d.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_NC#">
							group by afectaIVA
					)as impuestos
			</cfquery>
			<cfif isdefined('rsTotales')
				and rsTotales.recordCount GT 0
				and rsTotales.sumSubTotal NEQ ''
				and rsTotales.sumImpuesto NEQ ''
				and rsTotales.sumDescuento NEQ ''>
				<cfset TotalCot = 0>
				<cfif validaIEPS.valid GT 0 >
					<cfset TotalCot = (rsTotales.sumSubTotal - rsTotales.sumDescuento + rsTotales.IEPS + rsTotales.sumImpuesto) >
				<cfelse>
					<cfset TotalCot = (rsTotales.sumSubTotal - rsTotales.sumDescuento + rsTotales.sumImpuesto) >
				</cfif>
				<cfquery name="update" datasource="#session.DSN#">
						update FAPreFacturaE
							set
								Impuesto	=	<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumImpuesto#">,
								<cfif validaIEPS.valid GT 0 >
									FAieps		=	<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.IEPS#">,
							<cfelse>
									FAieps		=	0,
								</cfif>
								Total		=	<cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - coalesce(Descuento,0)
						where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and IDpreFactura = <cfqueryparam value="#idE_NC#" cfsqltype="cf_sql_numeric">
					</cfquery>
			<cfelse>
				<cfquery name="update" datasource="#session.DSN#">
					update FAPreFacturaE
						set
							Impuesto = 0,
							Total = 0,
							FAieps = 0
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and IDpreFactura = <cfqueryparam value="#idE_NC#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>

			<!--- Realiza la aplicacion del documentos --->
			<cfinvoke component="sif.fa.Componentes.FA_Facturacion"
						method="AplicaPreFactura"
						idPrefactura	= "#idE_NC#"
						Ecodigo = "#Session.Ecodigo#"
						dsn = "#Session.dsn#"
			/>

		<cfreturn CodigoDocumento>

	</cffunction>

</cfcomponent>