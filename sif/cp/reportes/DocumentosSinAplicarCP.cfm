<!---
	Modificado por: DAG
	Fecha: 19/10/05
	Motivo: Se modificó el filtro para que sugiera como fecha inicial la fecha mas antigua de los documentos sin aplicar.
	Modificado por: Rebeca Corrales Alfaro
	Fecha: 01/06/05
	Motivo: Se modifica el diseño de la pantalla y  de los filtros, se deja un solo filtro para monedas, transaccion, oficina y socio de negocios para generar el reporte Documentos sin Aplicar
	Hecho Por Gustavo Fonseca H.
	Fecha: 30 - 5 -2005
	Motivo: Nuevo reporte.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_DocSinApl	= t.Translate('TIT_DocSinApl','Documentos&nbsp;sin&nbsp;Aplicar')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha&nbsp;Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha&nbsp;Final','/sif/generales.xml')>
<cfset LB_FiltrarPor	= t.Translate('LB_FiltrarPor','Filtrar por')>
<cfset LB_FecFact		= t.Translate('LB_FecFact','Fecha de Factura')>
<cfset LB_FecArr		= t.Translate('LB_FecArr','Fecha de Arribo')>
<cfset LB_Oficina 		= t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_Todas 		= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset MSG_Usuario 		= t.Translate('MSG_Usuario','Usuario','/sif/generales.xml')>
<cfset LB_Moneda 		= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Resumido	= t.Translate('LB_Resumido','Resumido')>
<cfset LB_Consulta	= t.Translate('LB_Consulta','Consulta')>
<cfset LB_DetDocto	= t.Translate('LB_DetDocto','Detallado por Documento')>

<cf_templateheader title="SIF - Cuentas por Pagar">
		<cfinclude template="../../portlets/pNavegacionCP.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_DocSinApl#'>
			<cfquery name="rsMonedas" datasource="#Session.DSN#">
				select distinct b.Mcodigo, b.Mnombre
				 from EDocumentosCxP a
				  inner join Monedas b
					 on b.Mcodigo = a.Mcodigo
					and b.Ecodigo = a.Ecodigo
				 where a.Ecodigo  = #Session.Ecodigo#
				order by Mnombre
			</cfquery>
			<cfquery name="rsTransacciones" datasource="#Session.DSN#">
				select distinct b.CPTcodigo, b.CPTdescripcion
				from EDocumentosCxP a
				  inner join CPTransacciones b
					 on a.Ecodigo   = b.Ecodigo
					and a.CPTcodigo = b.CPTcodigo
				where   a.Ecodigo   = #Session.Ecodigo#
				  and coalesce(b.CPTpago,0) != 1
				order by b.CPTcodigo desc
			</cfquery>

			<cfquery name="rsUsuarios" datasource="#Session.DSN#">
				select 'Todos' as EDusuario, '#LB_Todos#' as EDusuarioDESC  from dual
				union all
				select distinct EDusuario, EDusuario as EDusuarioDESC
				from EDocumentosCxP
				where Ecodigo =  #Session.Ecodigo#
				and CPTcodigo in (
					select CPTcodigo
					from CPTransacciones
					where coalesce(CPTpago, 0) != 1)
				order by EDusuario asc
			</cfquery>

			<cfquery name="minFec" datasource="#Session.DSN#">
				select min(b.EDfecha) as minFec
				from EDocumentosCxP b
				where Ecodigo =  #Session.Ecodigo#
			</cfquery>
			<cfif minFec.recordcount and len(trim(minFec.minFec))>
				<cfset Lvar_minFec = minFec.minFec>
			<cfelse>
				<cfset Lvar_minFec = now()>
			</cfif>
			<form name="form1" method="get" action="DocumentosSinAplicarResCP.cfm">
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr>
						<td valign="top">
						<fieldset><legend><cfoutput>#LB_DatosRep#</cfoutput></legend>
						  <table  width="100%" cellpadding="3" cellspacing="0" border="0">
							<tr>
							  <td colspan="6">&nbsp;</td>
							</tr>
                            <tr>
                            <cfoutput>
                            	<td colspan="2">&nbsp;</td>
                            	<td width="19%"><strong>#LB_Fecha_Inicial#:</strong></td>
                                <td width="30%"><strong>&nbsp;#LB_Fecha_Final#:</strong></td>
                                <td colspan="2">&nbsp;</td>
                            </cfoutput>
                            </tr>
							<tr>
                              	<td colspan="2">&nbsp;</td>
							  	<td><cf_sifcalendario name="fechaDes" value="#LSDateFormat(Lvar_minFec,'dd/mm/yyyy')#" tabindex="1"></td>
                                <td><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
                                <td colspan="2">&nbsp;</td>
							</tr>
                            <tr>
                           	 	<td align="left" colspan="2">&nbsp;</td>
							  	<td colspan="2">
                                <cfoutput>
                                	<strong>#LB_FiltrarPor#:</strong>&nbsp;
                              		<input type="radio" name="tipoFiltro" value="1" checked tabindex="1">#LB_FecFact#
									<input type="radio" name="tipoFiltro" value="2" tabindex="1">#LB_FecArr#
                                </cfoutput>
                              	</td>
                              	<td align="left" colspan="2">&nbsp;</td>
                            </tr>
							<tr>
                                <cfoutput>
                            	<td colspan="2">&nbsp;</td>
								<td><strong>#LB_Oficina#:</strong></td>
							  	<td nowrap><strong>#LB_Transaccion#:</strong></td>
                                <td colspan="2">&nbsp;</td>
                                </cfoutput>
							</tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            	<td><cf_sifoficinas tabindex="1"></td>
                              	<td align="left">
                                    <select name="Transaccion" tabindex="1">
                                        <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
                                        <cfoutput query="rsTransacciones">
                                            <option value="#rsTransacciones.CPTcodigo#">#rsTransacciones.CPTdescripcion#</option>
                                        </cfoutput>
                                    </select>
							  	</td>
                                <td colspan="2">&nbsp;</td>
                            </tr>
							<tr>
                                <cfoutput>
                            	<td colspan="2">&nbsp;</td>
							  	<td><strong>#LB_SocioNegocio#:</strong></td>
							  	<td nowrap><strong>#MSG_Usuario#:&nbsp;</strong> </td>
                                <td colspan="2">&nbsp;</td>
                                </cfoutput>
							</tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            	<td><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
                                <td nowrap align="left">
                                  <select name="Usuario" tabindex="1">
                                      <cfoutput query="rsUsuarios">
                                        <option value="#rsUsuarios.EDusuario#">#rsUsuarios.EDusuarioDESC#</option>
                                      </cfoutput>
                                  </select>
                              	</td>
                                <td colspan="2">&nbsp;</td>
                            </tr>
							<tr>
                            	<td colspan="2">&nbsp;</td>
							  	<td><strong><cfoutput>#LB_Moneda#:</cfoutput></strong></td>
							</tr>
							<tr>
                            	<td colspan="2">&nbsp;</td>
							  	<td>
                                  <select name="Moneda" tabindex="1">
                                    <option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
                                    <cfoutput query="rsMonedas">
                                      <option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
                                    </cfoutput>
                                  </select>
                                 </td>
							</tr>

							<tr>
                            	<td colspan="2">&nbsp;</td>
							  	<td><strong><cfoutput>#LB_Formato#&nbsp;</cfoutput></strong> </td>
							  	<td><strong><cfoutput>#LB_Consulta#:</cfoutput></strong> <strong>&nbsp;</strong></td>
							  	<td colspan="2">&nbsp;</td>
							</tr>
                            <tr>
                            	<td colspan="2">&nbsp;</td>
                            	<td>
                                	<select name="Formato" id="Formato" tabindex="1">
								  	<option value="2">PDF</option>
								  	<option value="4">EXCEL</option>
							  		</select>
                                </td>
                                <td align="left">
                                    <input type="radio" name="tipoResumen" value="1" checked onclick="this.form.action = 'DocumentosSinAplicarResCP.cfm';" tabindex="1">
                                    <cfoutput>#LB_Resumido#</cfoutput>
                                     <input type="radio" name="tipoResumen" value="2" onclick="this.form.action = 'DocumentosSinAplicarDetCP.cfm';" tabindex="1">
                                    <cfoutput>#LB_DetDocto#</cfoutput>
                                </td>
                                <td colspan="2">&nbsp;</td>
                            </tr>
							<tr>
							  <td colspan="6" align="right">&nbsp;</td>
							</tr>
							<tr>
							  <td colspan="6"></td>
							</tr>
							<tr>
							  <td colspan="6" align="center">
								<cfif isdefined("url.Docs") and url.Docs eq 1>
									<cf_botones values="Generar, Limpiar, Regresar" names="Generar, Limpiar, Regresar" tabindex="1" >
								<cfelse>
									<cf_botones values="Generar, Limpiar" names="Generar, Limpiar" tabindex="1" >
								</cfif>
							  </td>
							</tr>
						  </table>
						</fieldset>
						</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>


<cfif isDefined("url.tipo") and len(Trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>
<cfset params = '' >
<cfif isdefined('form.tipo')>
	<cfset params = params & 'tipo=#form.tipo#'>
</cfif>

<script language="javascript" type="text/javascript">
	document.form1.fechaDes.focus();

	function funcRegresar(){
		<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> //<!--- Facturas --->
			location.href = '../operacion/RegistroFacturasCP.cfm?<cfoutput>#params#</cfoutput>';
		<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> //<!--- Notas de Crédito --->
			location.href = '../operacion/RegistroNotasCreditoCP.cfm?<cfoutput>#params#</cfoutput>';
		</cfif>
		return false;
	}
</script>