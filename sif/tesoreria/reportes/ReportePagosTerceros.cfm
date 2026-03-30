<cfsetting 	enablecfoutputonly="yes" requesttimeout="36000">
<cfset LvarDefault = createdate(datepart("YYYY",now()),datepart("m",now()),1)>
<cfset LvarDefault = dateAdd("m",-1,LvarDefault)>
<cf_navegacion name="FechaIni" default="#DateFormat(LvarDefault,"DD/MM/YYYY")#">
<cfset LvarDefault = dateAdd("m",1,LvarDefault)>
<cfset LvarDefault = dateAdd("d",-1,LvarDefault)>
<cf_navegacion name="FechaFin" default="#DateFormat(LvarDefault,"DD/MM/YYYY")#">
<cf_navegacion name="btnGenerar1">
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("form.btnGenerar1") OR isdefined("form.btnGenerar2")>
	<cf_dbfunction name="fn_len" returnvariable="LvarTesoBeneFLen">		
	<cfquery name="lista" datasource="#session.dsn#">	
		select
			<!----- CARGO: Solo cuando la Empresa Paga solicitudes de otras empresas--->
			case when dp.EcodigoOri <> dp.EcodigoPago then 'INTERCOMPANY' end as CARGO,
			'2' 	as TIPO_REGISTRO,
			'20' 	as COD_INFO,
			<!----- CONCEPTO: 	Está registrado en Detalle Pago--->
			coalesce(rptc.TESRPTCcodigo, '??') as CONCEPTO,
			rtrim(cf.CFformato) as CUENTA,
			case 
				when <cf_dbfunction name="sPart" args="TESOPbeneficiarioId,#LvarTesoBeneFLen#(TESOPbeneficiarioId)-2,1"> = '-' then <cf_dbfunction name="sPart" args="TESOPbeneficiarioId,1,#LvarTesoBeneFLen#(TESOPbeneficiarioId)-3">
				else op.TESOPbeneficiarioId
			end as RUC,
			case 
				when <cf_dbfunction name="sPart" args="TESOPbeneficiarioId,#LvarTesoBeneFLen#(TESOPbeneficiarioId)-2,1"> = '-' then <cf_dbfunction name="sPart" args="TESOPbeneficiarioId,#LvarTesoBeneFLen#(TESOPbeneficiarioId)-1,2">
				else null
			end as DIGITO,
			<!----- TIPO_PROVEEDOR: F=1=Fisica, J=2=Juridica--->
			case coalesce(sn.SNtipo, bt.TESBtipoId, cd.CDCtipo)
				when 'F' then '1' when 'J' then '2' when 'E' then '3' else '?' 
			end as TIPO_PROVEEDOR,
			op.TESOPbeneficiario #LvarCNCT# ' ' #LvarCNCT# op.TESOPbeneficiarioSuf as BENEFICIARIO,
			op.Miso4217Pago as MONEDA_PAGO,
			<cf_dbfunction name="to_number" args="dp.TESDPmontoPago"> as MONTO_PAGO,
			dp.TESDPdocumentoOri as PAGA_FACTURA,
			<!----- FECHA_FACTURA: Unicamente para TipoDocumento tipo 1=CxP--->
			case
				when dp.TESDPtipoDocumento = 1 then
					(select <cf_dbfunction name="date_format" args="Dfecha,DD-MM-YYYY"> from HEDocumentosCP cxp where cxp.IDdocumento = dp.TESDPidDocumento)
				else 
					<cf_dbfunction name="date_format" args="sp.TESSPfechaSolicitud,DD-MM-YYYY">
			end as FECHA_FACTURA,
			<!-----TIPO_PAGO:	CONTADO: tipo doc = 0 y 5 Manuales, PROVEEDORES: tipo Doc = 1 CxP, ADELANTOS: tipo Doc = 2 AdelantosCxP --->
			case
				when dp.TESDPtipoDocumento in (0,5) 	then 'CONTADO'
				when dp.TESDPtipoDocumento = 1 			then 'PROVEEDOR'
				when dp.TESDPtipoDocumento = 2 			then 'ANTICIPO'
				when dp.TESDPtipoDocumento in (3,4)		then 'DEVOLUCION'
				when dp.TESDPtipoDocumento = 10			then 'BANCOS'
				when dp.TESDPtipoDocumento = 100		then 'INTERFAZ'
				else '??????'
			end as TIPO_PAGO,
			case 
				when TESCFDnumFormulario is not null 	then 'CK'
				when TESTDid is not null 				then 'TR'
				else '??'
			end as TIPO_DOC,
			case 
				when TESCFDnumFormulario is not null 	then <cf_dbfunction name="to_char" args="TESCFDnumFormulario">
				when TESTDid is not null 				then (select TESTDreferencia from TEStransferenciasD t where t.TESid = op.TESid and t.CBid = op.CBidPago and t.TESMPcodigo = op.TESMPcodigo and t.TESTDid = op.TESTDid)
				else '???????'
			end as DOC_PAGO,
			coalesce(cb.CBcodigo, cb.CBcc) as BANCO,
			<cf_dbfunction name="date_format" args="op.TESOPfechaPago,DD-MM-YYYY"> as FECHA_PAGO,
			TESDPdescripcion as DESCRIPCION_PAGO
		  from TESdetallePago dp
			inner join TESsolicitudPago sp
				 on sp.TESSPid 	= dp.TESSPid
			inner join TESordenPago op
				inner join CuentasBancos cb
					on cb.CBid = op.CBidPago
				left join SNegocios sn
					on sn.SNid = op.SNid
				left join TESbeneficiario bt
					on bt.TESBid = op.TESBid
				left join ClientesDetallistasCorp cd
					on cd.CDCcodigo = op.CDCcodigo
				 on op.TESOPid 	= dp.TESOPid
			inner join CFinanciera cf
				 on cf.CFcuenta = dp.CFcuentaDB
			left join TESRPTconcepto rptc
				 on rptc.TESRPTCid = dp.TESRPTCid
		 where
         	
		 	<cfif isdefined("form.fecodigo") and len(trim(form.fecodigo))>
				dp.EcodigoOri = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#form.fecodigo#">
			   and 
		   </cfif>
		   		(
					<!---dp.TESDPestado = 12 
					and op.TESOPfechaPago >=	<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaIni)#">
			        and op.TESOPfechaPago <=	<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFin)#">--->
						dp.TESDPestado = 12 and 	op.TESOPfechaPago between      
    					<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaIni)#">
						and  
						<cf_jdbcquery_param cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FechaFin)#">
					
				)
           and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">      
		 order by FECHA_PAGO, TIPO_DOC, DOC_PAGO
	</cfquery>

	<cfif isdefined("form.btnGenerar2")>
		<cf_QueryToFile query="#lista#" filename="PagoTerceros.xls">
		<cfabort>
	</cfif>
</cfif>

<cfsetting 	enablecfoutputonly="no">

<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select Ecodigo, Edescripcion
	from Empresas
	where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>
<cf_templateheader title="Reporte de Pagos a Terceros">
	<cfset titulo = 'Reporte de Pagos a Terceros'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td width="50%" valign="top">
				<form name="formFiltro" method="post" action="ReportePagosTerceros.cfm" style="margin: 0" onsubmit="javascript: return validar(this);">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0">
						<tr><td>&nbsp;</td></tr>
						<!--- <tr>
							<td nowrap align="right"><strong>&nbsp;Trabajar con Tesorería:</strong>&nbsp;</td>
							<td nowrap align="left"><cf_cboTESid onchange="this.form.submit();" tabindex="1"></td>
						</tr> --->
									
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
						desplegar="CARGO,TIPO_REGISTRO,COD_INFO,CONCEPTO,CUENTA,RUC,DIGITO,TIPO_PROVEEDOR,BENEFICIARIO,MONEDA_PAGO,MONTO_PAGO,PAGA_FACTURA,FECHA_FACTURA,TIPO_PAGO,TIPO_DOC,DOC_PAGO,BANCO,FECHA_PAGO,DESCRIPCION_PAGO"
						etiquetas="CARGO,TIPO_REGISTRO,COD_INFO,CONCEPTO,CUENTA,RUC,DIGITO,TIPO_PROVEEDOR,BENEFICIARIO,MONEDA_PAGO,MONTO_PAGO,PAGA_FACTURA,FECHA_FACTURA,TIPO_PAGO,TIPO_DOC,DOC_PAGO,BANCO,FECHA_PAGO,DESCRIPCION_PAGO"
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
<!---  --->

