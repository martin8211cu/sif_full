<!--- 
	Reporte de Compras a Terceros:
		Corresponde al Formulario 43 de la DGI Panamá.
		
		Incluye las Facturas de Compras de CxP:
			a. Documentos CxP tipo crédito, CPTtipo = 'C' (excluir rebajas o devoluciones = débitos)
			b. cuyo concepto de pago haya sido reclasificado a un concepto de compra, 
			c. que dicho concepto de compra debe incluirse en el reporte
			d. y cuya fecha pertenezca al mes del reporte
		
		Incluye las Compras de Contado:
			a. Solicitudes de Pago Manual, TESDPtipoDocumento in (0,5) con monto positivo (excluir rebajas o devoluciones = negativos)
			b. cuyo concepto de pago haya sido reclasificado a un concepto de compra, 
			c. que dicho concepto de compra debe incluirse en el reporte
			d. y cuya fecha de pago pertenezca al mes del reporte
			
		Formato:
			Tipo de Persona: 
				Corresponde al Tipo de Identificación en Socio de Negocio, Beneficiario y Cliente Detallista.  Se modificó el sistema para que se pudiera digitar E=Extranjero
					1 = Físico
					2 = Jurídico
					3 = Extranjero
			RUC:
				Corresponde a la Identificación en Socio de Negocio, Beneficiario y Cliente Detallista.
			DV:
				Corresponde a los 2 últimos dígitos de la Identificación, únicamente si el antepenúltimo caracter es "-"
			NOMBRE O RAZÓN SOCIAL:
				Corresponde al Nombre del Socio de Negocios del Documento de CxP o del Nombre+Sufijo del Beneficiario de la Orden de Pago
			FACTURA/DOCUMENTO:
				Corresponde al Número de Documento de CxP, o al Número de Documento digitado en el Detalle de la Solicitud de Pago Manual
			FECHA:
				Corresponde a la fecha del Documento de CxP o a la Fecha de Pago del cheque de la solicitud manual. Formato YYYYMMDD.
			CONCEPTO:
				Corresponde al Concepto de Compras a terceros correspondiente (reclasificado) al Concepto de Pago a terceros digitado en el Documento de CxP o en la Solicitud de Pago
			COMPRAS DE BIENES Y SERVICIOS:
				Corresponde a Importaciones únicamente cuando el Concepto de Compra sea 6
					1 = Locales
					2 = Importaciones
			MONTO (B/):
				Corresponde al Monto Local del Documento de CxP o del Detalle de la Solicitud de Pago Manual SIN IMPUESTO
			ITBMS PAGADO (B/):
				Corresponde al Total de Impuestos Crédito Fiscal del Documento de CxP o del monto del Detalle de la Solicitud de Pago Manual cuando se indica que es una línea de impuesto.
			
--->
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfsetting 	enablecfoutputonly="yes" requesttimeout="3600">
<cfset LvarDefault = createdate(datepart("YYYY",now()),datepart("m",now()),1)>
<cfset LvarDefault = dateAdd("m",-1,LvarDefault)>
<cf_navegacion name="FechaIni" default="#DateFormat(LvarDefault,"DD/MM/YYYY")#">
<cfset LvarDefault = dateAdd("m",1,LvarDefault)>
<cfset LvarDefault = dateAdd("d",-1,LvarDefault)>
<cf_navegacion name="FechaFin" default="#DateFormat(LvarDefault,"DD/MM/YYYY")#">
<cf_navegacion name="btnGenerar1">

<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as cantidad
	  from TESRPTconcepto 
	 where CEcodigo = #session.CEcodigo#
	   and TESRPTCCid IS NULL
</cfquery>
<cfif rsSQL.cantidad GT 0>
	<cf_errorCode	code = "50783"
					msg  = "Existen @errorDat_1@ Conceptos de Pagos a Terceros que no han sido reclasificados a Conceptos de Compras a Terceros"
					errorDat_1="#rsSQL.cantidad#"
	>
</cfif>
<cfif isdefined("form.btnGenerar1") OR isdefined("form.btnGenerar2")>

<cf_dbfunction name="length" args="rtrim(TESOPbeneficiarioId)" returnvariable="LvarLen">
<cf_dbfunction name="sPart" args="TESOPbeneficiarioId;#LvarLen#-2;1" returnvariable="LvarGuion" delimiters=";">
<cf_dbfunction name="sPart" args="TESOPbeneficiarioId;1;#LvarLen#-3" returnvariable="LvarIdent_sin_digito" delimiters=";">
<cf_dbfunction name="sPart" args="TESOPbeneficiarioId;#LvarLen#-1;2" returnvariable="LvarDigito" delimiters=";">

<cf_dbfunction name="sPart"	args="op.TESOPbeneficiario #LvarCNCT# ' ' #LvarCNCT# op.TESOPbeneficiarioSuf;1;100" returnvariable="LvarNOMBRE" delimiters=";"> 

<cf_dbfunction name="length" args="rtrim(sn.SNidentificacion)" returnvariable="LvarLenSN">
<cf_dbfunction name="sPart" args="sn.SNidentificacion;#LvarLenSN#-2;1" returnvariable="LvarGuionSN" delimiters=";">
<cf_dbfunction name="sPart" args="sn.SNidentificacion;1;#LvarLenSN#-3" returnvariable="LvarIdent_sin_digitoSN" delimiters=";">
<cf_dbfunction name="sPart" args="sn.SNidentificacion;#LvarLenSN#-1;2" returnvariable="LvarDigitoSN" delimiters=";">

	<cfquery name="lista" datasource="#session.dsn#">
		select 
			TIPO_PERSONA,
			RUC,
			DV,
			NOMBRE,
			DOCUMENTO,
			FECHA,
			CONCEPTO,
			TIPO_COMPRA,
			sum(MONTO - ITBMS) as MONTO,
			sum(ITBMS) as ITBMS
		from (
		<!--- UNICAMENTE SOLICITUDES DE PAGO MANUAL RECLASIFICADOS A CONCEPTOS DE COMPRA A INCLUIR EN EL REPORTE --->
		select
			<!--- TIPO_PERSONA: F=1=Fisica, J=2=Juridica, E=3=Extranjero --->
			case coalesce(sn.SNtipo, bt.TESBtipoId, cd.CDCtipo)
				when 'F' then '1' when 'J' then '2' when 'E' then '3' else '?' 
			end as TIPO_PERSONA,
			case 
				when #LvarGuion# = '-' then #LvarIdent_sin_digito#
				else op.TESOPbeneficiarioId
			end as RUC,
			case 
				when #LvarGuion# = '-' then #LvarDigito#
				else null
			end as DV,
			#preserveSingleQuotes(LvarNOMBRE)# as NOMBRE,
			dp.TESDPdocumentoOri as DOCUMENTO,
			<cf_dbfunction name="date_format" args="op.TESOPfechaPago,YYYYMMDD"> as FECHA,
			<!--- CONCEPTO COMPRA: 	Asociado al Concepto de Pago que está registrado en Detalle de Solicitud --->
			coalesce(rptcc.TESRPTCCcodigo, '??') as CONCEPTO,
			case 
				when coalesce(rptcc.TESRPTCCcodigo, '??') <> '6' 
					then 1
					else 2
			end as TIPO_COMPRA,
			<!--- Se obtiene el monto total del documento (luego se le quita el impuesto) --->
			dp.TESDPmontoPagoLocal as MONTO,
			<!--- La linea es o no es Credito Fiscal --->
			case 
				when dp.Icodigo is not null 
					then dp.TESDPmontoPagoLocal 
				when (
						select count(1)
						  from CFinanciera c
							inner join Impuestos i
							 on i.Ccuenta			= c.Ccuenta
							and i.Icompuesto		= 0
							and i.Icreditofiscal	= 1
						 where c.CFcuenta	= dp.CFcuentaDB
					) > 0
					then dp.TESDPmontoPagoLocal 
				else 0
			end as ITBMS
		  from TESdetallePago dp
			inner join TESordenPago op
				left join SNegocios sn
					on sn.SNid = op.SNid
				left join TESbeneficiario bt
					on bt.TESBid = op.TESBid
				left join ClientesDetallistasCorp cd
					on cd.CDCcodigo = op.CDCcodigo
			 on op.TESOPid 	= dp.TESOPid
			inner join TESRPTconcepto rptc
				inner join TESRPTconceptoCompras rptcc
					 on rptcc.TESRPTCCid = rptc.TESRPTCCid 
					and rptcc.TESRPTCCincluir = 1
				 on rptc.TESRPTCid = dp.TESRPTCid
		 where 
		<cfif isdefined("form.fecodigo") and len(trim(form.fecodigo))>
				dp.EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fecodigo#">
		   and 
	   </cfif>
				dp.TESDPtipoDocumento in (0,5)
		   	and dp.TESDPestado = 12 
			and op.TESOPfechaPago >=	<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaIni)#">
			and op.TESOPfechaPago <=	<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFin)#">
		) as TABLA_DERIVADA
		group by 
			TIPO_PERSONA,
			RUC,
			DV,
			NOMBRE,
			DOCUMENTO,
			FECHA,
			CONCEPTO,
			TIPO_COMPRA
		UNION
		<!--- UNICAMENTE FACTURAS DE CXP Tipo TRANSACCION 'C=Credito' RECLASIFICADOS A CONCEPTOS DE COMPRA A INCLUIR EN EL REPORTE --->
		select
			<!--- TIPO_PERSONA: F=1=Fisica, J=2=Juridica, E=3=Extranjero --->
			case sn.SNtipo
				when 'F' then '1' when 'J' then '2' when 'E' then '3' else '?' 
			end as TIPO_PERSONA,
			case 
				when #preserveSingleQuotes(LvarGuionSN)# = '-' then #preserveSingleQuotes(LvarIdent_sin_digitoSN)#
				else sn.SNidentificacion
			end as RUC,
			case 
				when #preserveSingleQuotes(LvarGuionSN)# = '-' then #preserveSingleQuotes(LvarDigitoSN)#
				else null
			end as DV,
			sn.SNnombre as NOMBRE,
			e.Ddocumento as DOCUMENTO,
			<cf_dbfunction name="date_format" args="e.Dfecha,YYYYMMDD"> as FECHA,
			<!--- CONCEPTO COMPRA: 	Asociado al Concepto de Pago que está registrado en Factura --->
			coalesce(rptcc.TESRPTCCcodigo, '??') as CONCEPTO,
			case 
				when coalesce(rptcc.TESRPTCCcodigo, '??') <> '6' 
					then 1
					else 2
			end as TIPO_COMPRA,
			+coalesce(e.Dtotal, 0.00)
			-coalesce(
					(
						select sum(round(d.DDimpuestoCF, 2))
						  from HDDocumentosCP d
						 where d.IDdocumento = e.IDdocumento
					)
					,0)			
			-coalesce(
					(
						select sum(round(d.DDtotallin, 2))
						  from HDDocumentosCP d
						  	inner join Impuestos i
							 on i.Ccuenta			= d.Ccuenta
							and i.Icompuesto		= 0
							and i.Icreditofiscal	= 1
						 where d.IDdocumento	= e.IDdocumento
						   and d.DDimpuestoCF	= 0
					)
					,0)			
			as MONTO,
			+coalesce(
					(
						select sum(round(d.DDimpuestoCF, 2))
						  from HDDocumentosCP d
						 where d.IDdocumento = e.IDdocumento
					)
					,0) 
			+coalesce(
					(
						select sum(round(d.DDtotallin, 2))
						  from HDDocumentosCP d
						  	inner join Impuestos i
							 on i.Ccuenta			= d.Ccuenta
							and i.Icompuesto		= 0
							and i.Icreditofiscal	= 1
						 where d.IDdocumento	= e.IDdocumento
						   and d.DDimpuestoCF	= 0
					)
					,0)			
			as ITBMS
		  from HEDocumentosCP e
		  	inner join CPTransacciones t
				on t.Ecodigo = e.Ecodigo
				and t.CPTcodigo = e.CPTcodigo
			inner join SNegocios sn
				on sn.Ecodigo	= e.Ecodigo
				and sn.SNcodigo	= e.SNcodigo
			inner join TESRPTconcepto rptc
				inner join TESRPTconceptoCompras rptcc
					 on rptcc.TESRPTCCid = rptc.TESRPTCCid 
					and rptcc.TESRPTCCincluir = 1
				 on rptc.TESRPTCid = e.TESRPTCid
		 where 
	 	<cfif isdefined("form.fecodigo") and len(trim(form.fecodigo))>
				e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fecodigo#">
		   and 
	   </cfif>
				t.CPTtipo = 'C'
			and	e.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaIni)#">
			and e.Dfecha <=	<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFin)#">
		 order by FECHA, DOCUMENTO
	</cfquery>

	<cfif isdefined("form.btnGenerar2")>
		<cf_QueryToFile query="#lista#" filename="CompraTerceros.xls">
		<cfabort>
	</cfif>
</cfif>

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo, Edescripcion
	from Empresas
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cfset titulo = 'INFORME DE COMPRAS E IMPORTACIONES DE BIENES Y SERVICIOS - frm.43'>

<cfsetting 	enablecfoutputonly="no">
<cf_templateheader title="#titulo#">
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td width="50%" valign="top">
				<form name="formFiltro" method="post" action="ReporteComprasTerceros.cfm" style="margin: 0" onsubmit="javascript: return validar(this);">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap align="right"><strong>&nbsp;Empresa:</strong>&nbsp;</td>
							<td nowrap align="left"><!--- rsEmpresas --->
								<cfoutput>
									<select name="fEcodigo">
										<option value="" >- No especificada -</option>
										<cfloop query="rsEmpresas">
											<option value="#rsEmpresas.Ecodigo#" <cfif isdefined("rsEmpresas.Ecodigo") and isdefined("form.fEcodigo") and  form.Ecodigo eq rsEmpresas.Ecodigo >selected</cfif>>#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
										</cfloop>
									</select>
								</cfoutput>
							</td>
						</tr>
						<tr>
							<td nowrap align="right"><strong>&nbsp;Fecha Inicial:</strong>&nbsp;</td>
							<td nowrap align="left"><cf_sifcalendario value="#form.FechaIni#" name="FechaIni" form="formFiltro" tabindex="1"></td>
						</tr>
						<tr>
							<td nowrap align="right"><strong>&nbsp;Fecha Final:</strong>&nbsp;</td>
							<td nowrap align="left"><cf_sifcalendario value="#form.FechaFin#" name="FechaFin" form="formFiltro"  tabindex="1"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td nowrap align="left">
								
							</td>
							<td nowrap align="left">
								<input type="submit" name="btnGenerar2" value="Download" tabindex="1">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					<br>
				</form>
	
					<cfif isdefined("form.btnGenerar1")>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						maxrows="40"
						desplegar="CARGO,TIPO_REGISTRO,COD_INFO,CONCEPTO,CUENTA,RUC,DIGITO,TIPO_PROVEEDOR,BENEFICIARIO,MONEDA_DOC,MONTO_DOC,CREDITO_FISCAL,PAGA_FACTURA,FECHA_FACTURA,TIPO_DOC,TIPO_DOC,DOC_DOC,BANCO,FECHA_DOC,DESCRIPCION_DOC"
						etiquetas="CARGO,TIPO_REGISTRO,COD_INFO,CONCEPTO,CUENTA,RUC,DIGITO,TIPO_PROVEEDOR,BENEFICIARIO,MONEDA_DOC,MONTO_DOC,CREDITO_FISCAL,PAGA_FACTURA,FECHA_FACTURA,TIPO_DOC,TIPO_DOC,DOC_DOC,BANCO,FECHA_DOC,DESCRIPCION_DOC"
						formatos="S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S,S"
						align="left,left,left,left,left,left,left,left,left,right,right,left,center,left,left,left,left,center,left"
						form_method="post"
						showLink="no"
						keys=""
						navegacion="#navegacion#"
					/>		
				</cfif>			
	
			 </td>
		  </tr>
		</table>
		
		<script language="javascript" type="text/javascript">
			function validar(f) {
				var error_msg = '';
				if (f.TESid.value == "") {
					error_msg += "\n - Debe indicar la tesorería con la cual debe trabajar.";
				}
				if (f.FechaIni.value == "") {
					error_msg += "\n - La fecha inicial no puede quedar en blanco.";
				}
				if (f.FechaFin.value == "") {
					error_msg += "\n - La fecha final no puede quedar en blanco.";
				}
				// Validacion terminada
				if (error_msg.length != "") {
					alert("Por favor revise los siguiente datos:"+error_msg);
					return false;
				}
				return true;
			}
			document.formFiltro.TESid.focus();
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>	



