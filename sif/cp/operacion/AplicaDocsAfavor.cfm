<!---
	Modificado por: Ana Villavicencio
	Fecha: 02 de noviembre del 2005
	Motivo: Mejora en la forma del manejo de los datos y el despliegue de los mismos.
 --->

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_AplicDoc = t.Translate('TIT_AplicDoc','Aplicaci&oacute;n de Documentos')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_MontoMoneda = t.Translate('LB_MontoMoneda','Monto en Moneda de Pago')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_TransaccionM = t.Translate('LB_TransaccionM','Transacción','/sif/generales.xml')>
<cfset LB_Linea = t.Translate('LB_Linea','L&iacute;nea')>
<cfset LB_Totales = t.Translate('LB_Totales','Totales')>

<cfif isdefined("url.Aplicar")>
	<cfset Form.Aplicar="#url.Aplicar#">
</cfif>

<cf_templateheader title="SIF - Cuentas por Pagar">

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>

				<td valign="top">
					<cfparam name="PageNum_rsLineas" default="1">
						<cfif isDefined("Form.Aplicar") and Len(Trim(Form.IDpago)) NEQ 0>
							<cfset request.error.backs = 1 >
							<!--- ejecuta el proc.--->
							<cfinvoke component="sif.Componentes.CP_PosteoDocsFavorCxP"
							  method="CP_PosteoDocsFavorCxP"
								ID 			= "#Form.IDpago#"
								Ecodigo 	= "#Session.Ecodigo#"
								CPTcodigo 	= "#Form.CPTcodigo#"
								Ddocumento 	= "#Form.Ddocumento# - #form.docrefb#"
								usuario 	= "#Session.usuario#"
								Usucodigo	= "#Session.Usucodigo#"
								fechaDoc 	= "S"
								debug 		= "N"	/>

							<cfset params = '?pageNum_Lista=1' >
							<cfif isdefined('form.PageNum_Lista') and len(trim(form.PageNum_Lista))>
								<cfset params = '?pageNum_Lista=#form.PageNum_Lista#' >
							</cfif>

							<cfif isdefined('form.filtro_CPTdescripcion') and len(trim(form.filtro_CPTdescripcion)) >
								<cfset params = params & '&filtro_CPTdescripcion=#form.filtro_CPTdescripcion#' >
							</cfif>
							<cfif isdefined('form.filtro_Ddocumento') and len(trim(form.filtro_Ddocumento))>
								<cfset params =  params & '&filtro_Ddocumento=#form.filtro_Ddocumento#' >
							</cfif>
							<cfif isdefined('form.filtro_EAfecha') and len(trim(form.filtro_EAfecha)) >
								<cfset params =  params & '&filtro_EAfecha=#form.filtro_EAfecha#' >
							</cfif>
							<cfif isdefined('form.filtro_EAusuario') and len(trim(form.filtro_EAusuario)) >
								<cfset params =  params & '&filtro_EAusuario=#form.filtro_EAusuario#' >
							</cfif>
							<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1 >
								<cfset params =  params & '&filtro_Mnombre=#form.filtro_Mnombre#' >
							</cfif>

							<cfif isdefined('form.hfiltro_CPTdescripcion') and len(trim(form.hfiltro_CPTdescripcion)) >
								<cfset params = params & '&hfiltro_CPTdescripcion=#form.hfiltro_CPTdescripcion#' >
							</cfif>
							<cfif isdefined('form.hfiltro_Ddocumento') and len(trim(form.hfiltro_Ddocumento))>
								<cfset params =  params & '&hfiltro_Ddocumento=#form.hfiltro_Ddocumento#' >
							</cfif>
							<cfif isdefined('form.hfiltro_EAfecha') and len(trim(form.hfiltro_EAfecha)) >
								<cfset params =  params & '&hfiltro_EAfecha=#form.hfiltro_EAfecha#' >
							</cfif>
							<cfif isdefined('form.hfiltro_EAusuario') and len(trim(form.hfiltro_EAusuario)) >
								<cfset params =  params & '&hfiltro_EAusuario=#form.hfiltro_EAusuario#' >
							</cfif>
							<cfif isdefined('form.hfiltro_Mnombre') and len(trim(form.hfiltro_Mnombre)) and form.hfiltro_Mnombre neq -1 >
								<cfset params =  params & '&hfiltro_Mnombre=#form.hfiltro_Mnombre#' >
							</cfif>


							<cflocation url="listaDocsAfavor.cfm#params#" addtoken="no">
					</cfif>
						<cfset IDpago = "">
						<cfif not isDefined("Form.NuevoE")>
							<cfif isDefined("Form.datos") and Len(Trim(Form.datos)) NEQ 0 >
								<cfset arreglo = ListToArray(Form.datos,"|")>
								<cfset IDpago = Trim(arreglo[1])>
							<cfelseif isdefined("Form.IDpago")>
								<cfset IDpago = Trim(Form.IDpago)>
								<cfif isdefined("Form.DAlinea")>
									<cfset DAlinea = Form.DAlinea>
								</cfif>
							</cfif>
						</cfif>
						<cfif Len(Trim(IDpago)) NEQ 0>

							<cfquery name="rsLineas" datasource="#Session.DSN#">
							select
								<cf_dbfunction name="to_char" args="a.ID"> as IDpago,
								<cf_dbfunction name="to_char" args="a.DAlinea"> as DAlinea,
								a.DAtransref,
								a.DAdocref,
								c.Mnombre,
								<cf_dbfunction name="to_char" args="b.Mcodigo"> as Mcodigo,
								a.DAtipocambio,
								a.DAtotal,
								a.DAmonto as DAmonto,
								<cf_dbfunction name="to_char" args="a.DAidref"> as DAidref
								from DAplicacionCP a, EDocumentosCP b, Monedas c
								where a.ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDpago#">
								  and a.Ecodigo =  #Session.Ecodigo#
								  and a.DAidref = b.IDdocumento
								  and b.Mcodigo = c.Mcodigo
							</cfquery>

							<cfquery name="rsTotalLineas" dbtype="query">
								select sum(DAmonto) as DAmonto
								from rsLineas
							</cfquery>

							<cfset MaxRows_rsLineas=10>
							<cfset StartRow_rsLineas=Min((PageNum_rsLineas-1)*MaxRows_rsLineas+1,Max(rsLineas.RecordCount,1))>
							<cfset EndRow_rsLineas=Min(StartRow_rsLineas+MaxRows_rsLineas-1,rsLineas.RecordCount)>
							<cfset TotalPages_rsLineas=Ceiling(rsLineas.RecordCount/MaxRows_rsLineas)>
						</cfif>
                    <cfoutput>
	                <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_AplicDoc#'>
					</cfoutput>
		<table width="100%" border="0">
			<tr>
				<td valign="top">
					<cfset regresar = "listaDocsAfavor.cfm">
					<cfinclude template="../../portlets/pNavegacionCP.cfm">
				</td>
			</tr>
			<tr><td width="77%" valign="top"> <cfinclude template="formDocsAfavorOPE.cfm"></td></tr>
			<cfif Len(Trim("IDpago")) NEQ 0>
				<cfif modo NEQ "ALTA">

				<cfif rsLineas.recordCount GT 0>
				<script language="JavaScript">
					document.getElementById("btnAgregar").style.display = 'none';
				</script>
					<tr>
						<td>
							<!--- registro seleccionado --->
							<cfif isDefined("DAlinea") and Len(Trim(DAlinea)) GT 0 >
								<cfset seleccionado = DAlinea ><cfelse><cfset seleccionado = "" ></cfif>
								<form action="AplicaDocsAfavor.cfm" method="post" name="form2">
									<input name="datos" type="hidden" value="">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr bgcolor="#E2E2E2" class="subTitulo" >
                                        	<cfoutput>
											<td width="1%"  height="21">&nbsp;</td>
											<td width="7%" ><strong>&nbsp;#LB_Linea#</strong></td>
											<td width="10%"><strong>&nbsp;#LB_Transaccion#</strong></td>
											<td width="36%"><strong>&nbsp;#LB_Documento#</strong></td>
											<td width="10%"><strong>&nbsp;#LB_Moneda#</strong></td>
											<td width="20%" align="right"><strong>#LB_MontoMoneda#</strong></td>
                                            </cfoutput>
										</tr>
										<cfoutput query="rsLineas">
											<tr height="15" <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>
											style="cursor: pointer;"
											onMouseOver="style.backgroundColor='##E4E8F3';"
											onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"
											onClick="javascript:Editar('#rsLineas.IDpago#|#rsLineas.DAlinea#');">
												<cfset punto = "">
												<td><cfif modoDet NEQ 'ALTA' and rsLineas.DAlinea EQ seleccionado><img src="/cfmx/sif/imagenes/addressGo.gif" height="12" width="12" border="0"></cfif></td>
												<td>#CurrentRow#</td>
												<td nowrap>
													<cfif Len(Trim(#rsLineas.DAtransref#)) GT 30>
														<cfset punto = " ...">
													</cfif>
													#Mid(rsLineas.DAtransref,1,30)#</td>
													<td>#rsLineas.DAdocref# <input type="hidden" name="docdet#CurrentRow#" value="#rsLineas.DAdocref#"></td>
													<td nowrap>#rsLineas.Mnombre#</td>
													<td><div align="right">#LSCurrencyFormat(rsLineas.DAmonto,'none')#</div></td>
												</tr>
												</cfoutput>
												<tr>
													<td colspan="4">&nbsp;</td>
													<td><div align="right"><font size="1"><strong>
														<cfif rsTotalLineas.RecordCount GT 0 >
														<cfoutput>#LB_Totales#:</cfoutput>
														</cfif>
													</strong></font></div></td>
													<td><div align="right"><font size="1"><strong>
														<cfif rsTotalLineas.RecordCount GT 0 >
															<cfoutput>#LSCurrencyFormat(rsTotalLineas.DAmonto,'none')#</cfoutput>
														</cfif>
														</strong></font></div></td>
													</tr>
												</table>

												<cfoutput>
												<input type="hidden" name="pageNum_Lista" value="<cfif isdefined('form.PageNum_Lista') and len(trim(form.PageNum_Lista))>#form.PageNum_Lista#<cfelse>1</cfif>" />
												<input type="hidden" name="filtro_CPTdescripcion" value="<cfif isdefined('form.filtro_CPTdescripcion') and len(trim(form.filtro_CPTdescripcion))>#form.filtro_CPTdescripcion#</cfif>" />
												<input type="hidden" name="filtro_Ddocumento" value="<cfif isdefined('form.filtro_Ddocumento') and len(trim(form.filtro_Ddocumento)) >#form.filtro_Ddocumento#</cfif>" />
												<input type="hidden" name="filtro_EAfecha" value="<cfif isdefined('form.filtro_EAfecha') and len(trim(form.filtro_EAfecha)) >#form.filtro_EAfecha#</cfif>" />
												<input type="hidden" name="filtro_EAusuario" value="<cfif isdefined('form.filtro_EAusuario') and len(trim(form.filtro_EAusuario)) >#form.filtro_EAusuario#</cfif>" />
												<input type="hidden" name="filtro_Mnombre" value="<cfif isdefined('form.filtro_Mnombre') and len(trim(form.filtro_Mnombre)) and form.filtro_Mnombre neq -1 >#form.filtro_Mnombre#<cfelse>-1</cfif>" />

												<input type="hidden" name="hfiltro_CPTdescripcion" value="<cfif isdefined('form.hfiltro_CPTdescripcion') and len(trim(form.hfiltro_CPTdescripcion)) >#form.hfiltro_CPTdescripcion#</cfif>" />
												<input type="hidden" name="hfiltro_Ddocumento" value="<cfif isdefined('form.hfiltro_Ddocumento') and len(trim(form.hfiltro_Ddocumento)) >#form.hfiltro_Ddocumento#</cfif>" />
												<input type="hidden" name="hfiltro_EAfecha" value="<cfif isdefined('form.hfiltro_EAfecha') and len(trim(form.hfiltro_EAfecha)) >#form.hfiltro_EAfecha#</cfif>" />
												<input type="hidden" name="hfiltro_EAusuario" value="<cfif isdefined('form.hfiltro_EAusuario') and len(trim(form.hfiltro_EAusuario)) >#form.hfiltro_EAusuario#</cfif>" />
												<input type="hidden" name="hfiltro_Mnombre" value="<cfif isdefined('form.hfiltro_Mnombre') and len(trim(form.hfiltro_Mnombre)) and form.hfiltro_Mnombre neq -1 >#form.hfiltro_Mnombre#<cfelse>-1</cfif>" />
												</cfoutput>

											</form>
										</td>
									</tr>
								<cfelse>
									<tr>
                                    	<cfoutput>
										<td class="listaCorte" align="center">
                                        <cfset LB_DocSinDet = t.Translate('LB_DocSinDet','El documento no tiene l&iacute;neas de detalle')>
										#LB_DocSinDet#
										</td>
                                        </cfoutput>
									</tr>
									<tr>
										<td>&nbsp;
										</td>
									</tr>
								</cfif>
							</cfif>
						</cfif>
					</table>

<script language="JavaScript1.2">
function Editar(data) {
	if (data!="") {
		document.form2.action='AplicaDocsAfavor.cfm';
		document.form2.datos.value=data;
		document.form2.submit();
	}
	return false;
}

var element = document.form2.docdet1;
if (typeof(element) != 'undefined' && element != null)
{
	document.form1.docrefb.value=document.form2.docdet1.value
}

</script>

	                <cf_web_portlet_end>
				</td>
			</tr>
		</table>
	<cf_templatefooter>