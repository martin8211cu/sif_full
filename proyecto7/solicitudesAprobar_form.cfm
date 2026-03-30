<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cfif isdefined("url.TESSPid")>
	<cfset form.TESSPid = url.TESSPid>
</cfif>
<cfparam name="form.TESSPid" default="">
<script type="text/javascript" language="javascript1.2" src="../sif/js/utilesMonto.js"></script>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("LvarRechazoTesoreria")>
	<cfset LvarTitulo = 'Rechazo de Solicitudes de Pago en Tesorería'>
	<cfset LvarAction = 'solicitudesRechazar_sql.cfm'>
<cfelseif isdefined("LvarCambioTesoreria")>
	<cfset LvarTitulo = 'Cambio de Tesoreria a Solicitudes de Pago aprobadas'>
	<cfset LvarAction = 'solicitudesPasar_sql.cfm'>
<cfelse>
	<cfset LvarTitulo = 'Aprobación de Solicitudes de Pago'>
	<cfset LvarAction = 'solicitudesAprobar_sql.cfm'>
	<cfset LvarAprobacion = true>
</cfif>
	<cfif isdefined('form.TESSPid') and len(trim(form.TESSPid))>
		<cfset modo = 'CAMBIO'>
	<cfelse>
		<cf_errorCode	code = "50794" msg = "No se puede incluir una solicitud manualmente">
	</cfif>
	
	<cfquery datasource="#session.dsn#" name="rsForm">
		Select sp.TESid,
			s.SNcodigo,
			sp.TESSPtipoDocumento,
			case TESSPtipoDocumento
					when 0 		then 'Solicitud de Pago Manual'
					when 5 		then 'Solicitud de Pago Manual por Centro Funcional' 
					when 1 		then 'Solicitud de Pago de Documentos de CxP' 
					when 2 		then 'Solicitud de Pago de Anticipos a Proveedores de CxP' 
					when 3 		then 'Solicitud de Devolución de Anticipos a Clientes de CxC' 
					when 4 		then 'Solicitud de Devolución de Anticipos a Clientes de POS' 
					when 6 		then 'Solicitud de Pago de Anticipos a Empleado' 
					when 7 		then 'Solicitud de Pago de Liquidación a Gastos de Empleado' 
					when 8		then 'Solicitud de Pago para Fondos de Caja Chica'
					when 9 		then 'Solicitud de Pago para Reintegro de Caja Chica'
					when 10		then 'Solicitud de Transferencia entre Cuentas Bancarias' 
					when 100 	then 'Solicitud de Pago por Interfaz' 
					else 'Otro'
			end as Origen,
			sp.TESSPid, sp.TESSPestado, 
			sp.SNcodigoOri, sp.TESBid, tb.DEid,
			coalesce(s.SNnombre,s.SNnombrePago,TESBeneficiario,CDCnombre) as SNnombre, 
			sp.TESSPnumero, sp.TESSPfechaSolicitud, sp.TESSPfechaPagar,
			McodigoOri, m.Mnombre, sp.TESSPtotalPagarOri, TESSPtipoCambioOriManual,
			sp.TESSPmsgRechazo, sp.ts_rversion,
			E.Edescripcion, 
			sp.CFid, cf.CFcodigo, cf.CFdescripcion,
			
			{fn concat({fn concat(t.TEScodigo, ' - ')}, t.TESdescripcion)} as TESdescripcion, 
			adm.Edescripcion as ADMdescripcion

			,TESOPobservaciones
			,TESOPinstruccion
			,TESOPbeneficiarioSuf
			,sp.EcodigoOri

			,(select count(1) from TESdetallePago where TESSPid = sp.TESSPid and CPCid is not null) as Multas
		from TESsolicitudPago sp
			inner join Empresas E
				 on E.Ecodigo = sp.EcodigoOri
			inner join Monedas m
				 on m.Ecodigo = sp.EcodigoOri
				and m.Mcodigo = sp.McodigoOri
			inner join Tesoreria t
				inner join Empresas adm
					on adm.Ecodigo = t.EcodigoAdm
			   on t.TESid = sp.TESid
			left join CFuncional cf
				 on cf.CFid	= sp.CFid
			left join SNegocios s
				 on s.Ecodigo 	= sp.EcodigoOri
				and s.SNcodigo 	= sp.SNcodigoOri
			left join TESbeneficiario tb
				 on tb.TESBid	= sp.TESBid
			left join ClientesDetallistasCorp cd
				 on cd.CDCcodigo	= sp.CDCcodigo
		where sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
			and sp.TESid = #session.Tesoreria.TESid#
			<cfelse>
			and sp.EcodigoOri = #session.Ecodigo#
			</cfif>
	</cfquery>
	
	<cfset LvarTESid 			= rsForm.TESid>
	<cfset LvarTESdescripcion	= rsForm.TESdescripcion>
	<cfset LvarADMdescripcion	= rsForm.ADMdescripcion>

	<cfif isdefined("LvarAprobacion")>
		<!--- Determina la tesorería a Asignar --->
		<cfif rsForm.CFid EQ "">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	t_e.TESid
				  from Empresas e
						left join TESempresas te
							inner join Tesoreria t_e
								on t_e.TESid = te.TESid
							on te.Ecodigo = e.Ecodigo
				 where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.EcodigoOri#">
			</cfquery>
		<cfelse>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select 	coalesce(t_cf.TESid,t_e.TESid) as TESid
				  from CFuncional cf
					inner join Empresas e
						left join TESempresas te
							inner join Tesoreria t_e
								on t_e.TESid = te.TESid
							on te.Ecodigo = e.Ecodigo
						on e.Ecodigo = cf.Ecodigo
					left join TEScentrosFuncionales tcf
						inner join Tesoreria t_cf
							on t_cf.TESid = tcf.TESid
						on tcf.Ecodigo	= e.Ecodigo
					   and tcf.CFid		= cf.CFid
				  where cf.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
			</cfquery>
		</cfif>
		
		<cfif rsForm.TESid NEQ rsSQL.TESid>
			<cfset LvarTESid = rsSQL.TESid>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				update TESsolicitudPago
				   set TESid = #LvarTESid#
				 where TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			</cfquery>

			<cfquery name="rsSQL" datasource="#session.dsn#">
				select
					{fn concat({fn concat(t.TEScodigo, ' - ')}, t.TESdescripcion)} as TESdescripcion, 
					adm.Edescripcion as ADMdescripcion
				  from TESsolicitudPago sp
					inner join Tesoreria t
						inner join Empresas adm
							on adm.Ecodigo = t.EcodigoAdm
					   on t.TESid = sp.TESid
				 where sp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
			</cfquery>
			<cfset LvarTESdescripcion	= rsSQL.TESdescripcion>
			<cfset LvarADMdescripcion	= rsSQL.ADMdescripcion>

			<cfset rsForm.TESid 			= LvarTESid>
			<cfset rsForm.TESdescripcion	= LvarTESdescripcion>
			<cfset rsForm.ADMdescripcion	= LvarADMdescripcion>
		</cfif>
	</cfif>

	<cfoutput>
		<cf_onEnterKey enterActionDefault="none">
		<form action="#LvarAction#" onsubmit="return validar(this);" method="post" name="form1" id="form1">
            <input type="hidden" name="botonSel" id="botonSel" value="">
			<input type="hidden" name="TESSPid" value="#form.TESSPid#">
			<table style="width:inherit" align="center" summary="Tabla de entrada" border="0">
				<tr>
					<td align="center" colspan="4" bgcolor="##CCCCCC"><strong>#rsForm.Origen#</strong></td>
					
				</tr>

				<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
				<tr>
					<td valign="top" align="right"><strong>Empresa Origen:</strong></td>
					<td valign="top" colspan="2">
						<strong>#rsForm.Edescripcion#</strong>
						<input name="TESid" type="hidden" value="#session.Tesoreria.TESid#">
					</td>
				</tr>
				</cfif>

				<tr>
					<td valign="top" align="right">
						<strong>Núm. Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">						
						<strong>#LSNumberFormat(rsForm.TESSPnumero)#</strong>
						<input type="hidden" name="TESSPnumero" value="#rsForm.TESSPnumero#" onKeyUp="if(snumber(this,event,' ')){ if(Key(event)=='13') {this.blur();}}">
					</td>
					<td valign="top" align="right">
						<strong>Fecha Solicitud:&nbsp;</strong>
					</td>
					<td valign="top">
						<strong>#LSDateFormat(rsForm.TESSPfechaSolicitud,"DD/MM/YYYY")#</strong>
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Centro&nbsp;Funcional:&nbsp;</strong>
					</td>
					<td colspan="3">
						<strong>#rsForm.CFcodigo# - #rsForm.CFdescripcion#
					</td>
				</tr>									

				<tr>
					<td valign="top" nowrap align="right">
						<cfif rsForm.SNcodigoOri NEQ "">
							<strong>Socio de Negocio:&nbsp;</strong>
						<cfelseif rsForm.DEid NEQ "">
							<strong>Empleado:&nbsp;</strong>
						<cfelseif rsForm.TESBid NEQ "">
							<strong>Beneficiario:&nbsp;</strong>
						<cfelse>
							<strong>Cliente Detallista:&nbsp;</strong>
						</cfif>
					</td>
					<td valign="top" colspan="3">
						<strong>#rsForm.SNnombre# #rsForm.TESOPbeneficiarioSuf#</strong>
					</td>
				</tr>						

				<tr>
					<td valign="top" align="right">
						<strong>Moneda:&nbsp;</strong>
					</td>
					<td valign="top">
						<input type="text"
							disabled="yes"
							value="#rsForm.Mnombre#"
							style="text-align:left; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
						
					</td>

					<td rowspan="3" valign="top" align="right" nowrap>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Observaciones para OP:</strong>
					</td>
					<td rowspan="3" valign="top" valign="top">
						<textarea name="TESOPobservaciones"  rows="4" tabindex="-1" id="TESOPobservaciones"
								onkeypress="return false;"><cfif modo NEQ 'ALTA'>#trim(rsForm.TESOPobservaciones)#</cfif></textarea>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right">
					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select Mcodigo
						  from Empresas
						 where Ecodigo = #Session.Ecodigo#
					</cfquery>
					<cfif rsSQL.Mcodigo EQ rsForm.McodigoOri>
						<cfset LvarTClabel = "Tipo Cambio">
						<cfset LvarTC = 1>
					<cfelseif isdefined("rsForm.TESSPtipoDocumento") AND listFind("0,5",rsForm.TESSPtipoDocumento) AND isdefined("rsForm.TESSPtipoCambioOriManual") AND isnumeric(rsForm.TESSPtipoCambioOriManual)>
						<cfset LvarTClabel = "Tipo Cambio">
						<cfset LvarTC = rsForm.TESSPtipoCambioOriManual>
					<cfelse>
						<cfset LvarTClabel = "Tipo Cambio Histórico">
						<cfquery name="TCsug" datasource="#Session.DSN#">
							select tc.Hfecha, tc.TCcompra, tc.TCventa
							  from Htipocambio tc
							 where tc.Ecodigo = #Session.Ecodigo#
							   and tc.Mcodigo = #rsForm.McodigoOri#
							   and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
							   and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						</cfquery>
						<cfset LvarTC = TCsug.TCcompra>
					</cfif>
					<strong>#LvarTClabel#:&nbsp;</strong>
					</td>
					<td valign="top">
						<input type="text"
							value="#NumberFormat(LvarTC,",0.0000")#"
							disabled="yes"
							style="text-align:left; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" align="right" nowrap><strong>Total Pago Solicitado:&nbsp;</strong></td>
					<td valign="top">
						<input type="text"
							readonly="yes"
							value="<cfif  modo NEQ 'ALTA'>#numberFormat(rsForm.TESSPtotalPagarOri,",0.00")#<cfelse>0.00</cfif>"
							style="text-align:right; border:solid 1px ##CCCCCC;"
							tabindex="-1"
						>
					</td>
				</tr>

				<tr>
					<td valign="top" nowrap align="right">
						<strong>Fecha Pago Solicitado:&nbsp;</strong>
					</td>
					<td valign="top">
						<cfset fechaSol = LSDateFormat(Now(),'dd/mm/yyyy') >
						<cfif modo NEQ 'ALTA'>
							<cfset fechaSol = LSDateFormat(rsForm.TESSPfechaPagar,'dd/mm/yyyy') >
						</cfif>
						<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
							<input type="text"
								readonly="yes"
								value="#fechaSol#"
								style="text-align:right; border:solid 1px ##CCCCCC;"
								tabindex="-1"
							>
						<cfelse>
							<cf_sifcalendario form="form1" value="#fechaSol#" name="TESSPfechaPagar" tabindex="1">
						</cfif>
					</td>

					<td valign="top" nowrap align="right">
						<strong>Instrucción al Banco:&nbsp;</strong>
					</td>
					<td>
						<input type="text"
							name="TESOPinstruccion" 
							id="TESOPinstruccion"
							style="text-align:left; border:solid 1px ##CCCCCC;"
							tabindex="-1"
							maxlength="40"
							value="<cfif  modo NEQ 'ALTA'>#rsForm.TESOPinstruccion#</cfif>"
						>
					</td>
				</tr>			

				<tr>
					<td valign="top" align="right"><strong>Pagar en Tesorería:</strong></td>
					<td valign="top" colspan="3">
						<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
							<input type="text"
								readonly="yes"
								value="#LvarTESdescripcion# (Adm: #LvarADMdescripcion#)"
								style="text-align:left; border:solid 1px ##CCCCCC;"
								tabindex="-1"
							>
						<cfelse>
							<select name="cboCambioTESid" id="cboCambioTESid" onchange="sb_cboCambioTESid_OnChange();">
								<option value="">#LvarTESdescripcion# (Adm: #LvarADMdescripcion#)</option>
							</select>
						</cfif>
					</td>
				</tr>						
			<cfif isdefined("LvarRechazoTesoreria")>
				<tr>
					<td valign="top" align="right">
						<strong>Motivo Rechazo Anterior:</strong>
					</td>
					<td valign="top" colspan="3">
						<font style="color:##FF0000; font-weight:bold;">#rsForm.TESSPmsgRechazo#</font>
					</td>
				</tr>						
				<tr height="50">
					<td valign="top" align="right">
						<strong>Motivo de Rechazo:</strong>
					</td>
					<td valign="top" colspan="3">
						<textarea 	name="TESSPmsgRechazo" id="TESSPmsgRechazo"
									 rows="4"
									></textarea>
					</td>
				</tr>						
			<cfelse>
				<tr>
					<td valign="top" align="right">
					<cfif isdefined("form.chkCancelados")>
						<strong>Motivo Cancelacion:</strong>
					<cfelse>
						<strong>Motivo Rechazo Anterior:</strong>
					</cfif>
					</td>
					<td valign="top" colspan="3">
						<font style="color:##FF0000; font-weight:bold;">#rsForm.TESSPmsgRechazo#</font>
						<input type="hidden" name="TESSPmsgRechazo" value="">
					</td>
				</tr>						

			</cfif>
			<cfif isdefined("LvarCambioTesoreria")>
				<tr>
					<td valign="top" align="right"><strong>Nueva Tesorería de Pago:</strong></td>
					<td valign="top" colspan="3">
						<cfquery name="rsTesorerias" datasource="#session.dsn#">
							Select 	t.TESid, 
									{fn concat({fn concat(t.TEScodigo, ' - ')}, t.TESdescripcion)} as TESdescripcion, 
									t.EcodigoAdm, e.Edescripcion as ADMdescripcion
							  from Tesoreria t
								inner join Empresas e
									on e.Ecodigo = t.EcodigoAdm
							 where t.CEcodigo	= #session.CEcodigo#
							   and t.TESid <> #LvarTESid#
						</cfquery>
						<select name="cboCambioTESid" id="cboCambioTESid" onchange="sb_cboCambioTESid_OnChange();">
							<option value="">#LvarTESdescripcion# (Adm: #LvarADMdescripcion#)</option>
						<cfloop query="rsTesorerias">
							<option value="#rsTesorerias.TESid#">#rsTesorerias.TESdescripcion# (Adm: #rsTesorerias.ADMdescripcion#)</option>
						</cfloop>
						</select>
					</td>
				</tr>	
				<tr><td>&nbsp;</td></tr>					
			</cfif>
				<tr>
					<td colspan="4" class="formButtons" align="center">
						<cfif isdefined("LvarRechazoTesoreria")>
							<cfset LvarBotones 			= "Rechazar,btnSelFac">
							<cfset LvarBotonesValues	= "Rechazar,Lista Solicitudes">

							<cf_botones modo='#modo#' tabindex="1" 
								include="#LvarBotones#" 
								includevalues="#LvarBotonesValues#"
								exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
							>
						<cfelseif isdefined("LvarCambioTesoreria")>
							<cfset LvarBotones 			= "Pasar,btnSelFac">
							<cfset LvarBotonesValues	= "Pasar,Lista Solicitudes">

							<cf_botones modo='#modo#' tabindex="1" 
								include="#LvarBotones#" 
								includevalues="#LvarBotonesValues#"
								exclude="Cambio,Baja,Nuevo,Alta,Limpiar"
							>
						<cfelse>						
							<cfset LvarAprobar = true>
							<cfset LvarExclude = "Cambio,Baja,Nuevo">
                            <cfset LvarHomePage = "tesoreria.cfm">
							<cfinclude template="TESbtn_Aprobar.cfm">
						</cfif>
					</td>
				</tr>
			</table>
			<cfif modo NEQ 'ALTA'>
				<cfset ts = "">
				<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
					artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfif>

			<cfset LvarTitulo = 'Detalle de la Solicitud de Pago'>
				<cfquery datasource="#session.dsn#" name="listaDet">
					Select 	dp.TESDPid,
							TESDPmoduloOri,
							TESDPdocumentoOri,
							TESDPreferenciaOri,
							TESDPdescripcion #LvarCNCT# '<BR>' #LvarCNCT# CFformato as DescripcionCta, 
							TESDPfechaVencimiento,
							Miso4217Ori,
							TESDPmontoVencimientoOri, 
							TESDPmontoSolicitadoOri,
							cf.CFcodigo, o.Oficodigo
					  from TESdetallePago dp
						left join CFinanciera c
							on c.CFcuenta = dp.CFcuentaDB
						left join CFuncional cf
							inner join Oficinas o
								 on o.Ecodigo = cf.Ecodigo
								and o.Ocodigo = cf.Ocodigo
							on cf.CFid = dp.CFid
					<cfif isdefined("LvarRechazoTesoreria") OR isdefined("LvarCambioTesoreria")>
					 where TESid = #session.Tesoreria.TESid#
					<cfelse>
					 where EcodigoOri = #session.Ecodigo#
					</cfif>
					   and dp.TESSPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
					 order by TESDPdocumentoOri, TESDPreferenciaOri, TESDPid
				</cfquery>
				<input type="hidden" name="TESDPid" value="#listaDet.TESDPid#">
				
				<!---
					0,5. Pago Manual
					1. Pago Doc CxP
					2. Pago Ant CxP
					3. Devo Ant CxC
					4. Devo Ant POS
					6. Pago Anticipos Empleado
					7. Pago Liquidacion Empleado
					8. Fondeo Caja Chica
					9. Reintegro Caja Chica
				--->
				<cfif rsForm.TESSPtipoDocumento EQ 5>
					<!--- 5 = Manual por CF --->
					<cfset LvarDesplegar="CFcodigo, Oficodigo, TESDPmoduloOri,TESDPdocumentoOri,TESDPreferenciaOri,DescripcionCta, Miso4217Ori,TESDPmontoSolicitadoOri">
					<cfset LvarEtiquetas="Centro Funcional,Oficina,Origen, Documento, Referencia, Descripción<BR>Cta.Financiera, Moneda, Monto<BR>Solicitado">
					<cfset LvarFormatos="S,S,S,S,S,S,S,M">
					<cfset LvarAlign="left,left,left,left,left,left,center,right">
				<cfelseif listFind ("1,3,4", rsForm.TESSPtipoDocumento)>
					<!--- 1 = CxP, 3 = Devol. Anticipos CxC, 4 = Devol. Anticipos POS --->
					<cfif rsForm.TESSPtipoDocumento EQ 1>
						<cfset LvarFechaVence = "Fecha<BR>Vencimiento">
					<cfelse>
						<cfset LvarFechaVence = "Fecha<BR>Documento">
					</cfif>
					<cfset LvarDesplegar="TESDPmoduloOri,TESDPdocumentoOri,TESDPreferenciaOri,DescripcionCta, TESDPfechaVencimiento,Miso4217Ori,TESDPmontoVencimientoOri, TESDPmontoSolicitadoOri">
					<cfset LvarEtiquetas="Origen, Documento, Referencia, Descripción<BR>Cta.Financiera, #LvarFechaVence#, Moneda, Saldo<BR>Documento, Monto<BR>Solicitado">
					<cfset LvarFormatos="S,S,S,S,D,S,M,M">
					<cfset LvarAlign="left,left,left,left,center,center,right,right">
				<cfelseif rsForm.TESSPtipoDocumento EQ 2>
					<!--- 2 = Pago Anticipos CxP --->
					<cfset LvarDesplegar="TESDPmoduloOri,TESDPdocumentoOri,TESDPreferenciaOri,DescripcionCta, TESDPfechaVencimiento,Miso4217Ori,TESDPmontoSolicitadoOri">
					<cfset LvarEtiquetas="Origen, Documento, Referencia, Descripción<BR>Cta.Financiera,Fecha<BR>Documento, Moneda, Monto<BR>Solicitado">
					<cfset LvarFormatos="S,S,S,S,D,S,M">
					<cfset LvarAlign="left,left,left,left,center,center,right">
				<cfelse> <!--- 0 = Manual, 6 = Anticipo GE, 7 = Liquidacion GE, 8 = FONDEO CCh, 9 = Reintegro CCh --->
					<cfset LvarDesplegar="TESDPmoduloOri,TESDPdocumentoOri,TESDPreferenciaOri,DescripcionCta, Miso4217Ori,TESDPmontoSolicitadoOri">
					<cfset LvarEtiquetas="Origen, Documento, Referencia, Descripción<BR>Cta.Financiera, Moneda, Monto<BR>Solicitado">
					<cfset LvarFormatos="S,S,S,S,S,M">
					<cfset LvarAlign="left,left,left,left,center,right">
				</cfif>
				<!---Revisar los margenes de en la tablet--->
                <table style="width:inherit" align="center">
                    <tr>
                        <td>
                            <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
                                query="#listaDet#"
                                desplegar	= "#LvarDesplegar#"
                                etiquetas	= "#LvarEtiquetas#"
                                formatos	= "#LvarFormatos#"
                                align		= "#LvarAlign#"
                                showEmptyListMsg="yes"
                                incluyeForm="No"
                                showLink="No"
                                maxRows="0"
                            />		
                        </td>
                     </tr>	
                </table>				
			<table style="width:inherit" align="center">
				<tr><td>
				<cfinclude template="../sif/tesoreria/Solicitudes/solicitudesCP_Cesion.cfm">
				</td></tr>
			</table>
		</form>
	</cfoutput>
	<script language="javascript">
	<cfif isdefined("LvarRechazoTesoreria")>
		function validar(formulario)	
		{
			return (document.fnVerificarDet) ? fnVerificarDet() : true;
		}
		function funcRechazar(){
			if (document.form1.TESSPmsgRechazo.value.replace(/\s*/,"")=="")
			{
				alert('Debe digitar una razón de rechazo!');
				return false;
			}
				return confirm('¿Desea RECHAZAR la Solicitud de Pago # <cfoutput>#rsform.TESSPnumero#</cfoutput>?');
			return true;
		}

		function funcbtnSelFac()
		{
			location.href='solicitudesRechazar.cfm';
			return false;
		}
	<cfelseif isdefined("LvarCambioTesoreria")>
		function validar(formulario)	
		{
			return (document.fnVerificarDet) ? fnVerificarDet() : true;
		}
		function funcPasar()
		{
			if (document.form1.cboCambioTESid.value == "")
			{
				alert('No se ha cambiado la Tesoreria de Pago!');
				return false;
			}

			var LvarTesoreria = document.form1.cboCambioTESid.options[document.form1.cboCambioTESid.selectedIndex].text;
			var LvarPto = LvarTesoreria.indexOf("(Adm:");
			LvarTesoreria = " Tesoreria de Pago:\t" + LvarTesoreria.substring(0,LvarPto) + ",\n Administrada por:\t" + LvarTesoreria.substring(LvarPto+6);
			LvarTesoreria = LvarTesoreria.substring(0,LvarTesoreria.length-1);
			return confirm("¿Desea CAMBIAR LA TESORERÍA DE PAGO a\n" + LvarTesoreria + "?" );

			return true;
		}

		function funcbtnSelFac()
		{
			location.href='solicitudesPasar.cfm';
			return false;
		}
	<cfelse>
		function validar(formulario)	
		{
			var error_input;
			var error_msg = '';
			
			if (document.getElementById("TESSPfechaPagar").value == "") {
				error_msg += "\n - la Fecha de la Solicitud no puede quedar en blanco.";
				error_input = document.getElementById("TESSPfechaPagar");
			}				
					
			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				error_input.focus();
				return false;
			}
		
			var LvarCboCambioTESid = document.getElementById("cboCambioTESid");
			if(LvarCboCambioTESid && LvarCboCambioTESid.value != "")
			{
				var LvarTesoreria = LvarCboCambioTESid.options[LvarCboCambioTESid.selectedIndex].text;
				var LvarPto = LvarTesoreria.indexOf("(Adm:");
				LvarTesoreria = " Tesoreria de Pago:\t" + LvarTesoreria.substring(0,LvarPto) + ",\n Administrada por:\t" + LvarTesoreria.substring(LvarPto+6);
				LvarTesoreria = LvarTesoreria.substring(0,LvarTesoreria.length-1);
				return confirm("CAMBIO DE TESORERIA:\n\n¿Desea que el proceso de pago se realice en \n" + LvarTesoreria + "?" );
			}
			return true;
		}

		function funcRechazar(){
			var vReason = prompt('¿Desea RECHAZAR la Solicitud de Pago # <cfoutput>#rsform.TESSPnumero#</cfoutput>?, Debe digitar una razón de rechazo!','');
			if (vReason && vReason != ''){
				document.form1.TESSPmsgRechazo.value = vReason;
				document.form1.submit();
				return true;
			}
			if (vReason=='')
				alert('Debe digitar una razón de rechazo!');
			return false;
		}
	</cfif>
		function funcAprobar(){
			if(confirm('¿Desea ENVIAR AL PROCESO DE APROBACIÓN la Solicitud de Pago ## <cfoutput>#rsform.TESSPnumero#</cfoutput>?')){
				document.form1.submit();
			}
		}	
	</script>
</div>