<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset LB_Documentos = t.Translate('LB_Documentos','Documentos')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Fecha_Inicial = t.Translate('LB_Fecha_Inicial','Fecha Inicial','/sif/generales.xml')>
<cfset LB_Fecha_Final 	= t.Translate('LB_Fecha_Final','Fecha Final','/sif/generales.xml')>
<cfset Oficina 			= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Transaccion 	= t.Translate('LB_Transaccion','Transacción')>
<cfset LB_SocioNegocio 	= t.Translate('LB_Socio_de_Negocios','Socio de Negocios','/sif/generales.xml')>
<cfset LB_USUARIO		= t.Translate('LB_USUARIO','Usuario','/sif/generales.xml')>
<cfset LB_Moneda 		= t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Todas 		= t.Translate('LB_Todas','Todas','/sif/generales.xml')>
<cfset LB_Formato 		= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Reporte 		= t.Translate('LB_Reporte','Reporte','/sif/generales.xml')>
<cfset LB_DoctosSApl 	= t.Translate('LB_DoctosSApl','Documentos sin Aplicar')>
<cfset LB_DoctosAplic 	= t.Translate('LB_DoctosAplic','Documentos Aplicados')>
<cfset BTN_Consultar 	= t.Translate('BTN_Consultar','Consulta','/sif/generales.xml')>
<cfset LB_Resumido 		= t.Translate('LB_Resumido','Resumido')>
<cfset LB_Detallado 	= t.Translate('LB_Detallado','Detallado por Documento')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>

<cfquery name="rsMonedas" datasource="#Session.DSN#" result="variable">
	select distinct a.Mcodigo, b.Mnombre
	from Monedas b , EDocumentosCxC a
	where a.Ecodigo = #Session.Ecodigo#
	  and b.Mcodigo = a.Mcodigo
	 order by Mnombre
</cfquery>

<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo = #Session.Ecodigo#
	  and coalesce(CCTpago,0) != 1
	order by CCTcodigo desc
</cfquery>

<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select '-1' as EDusuario, '#LB_Todos#' as EDusuarioDESC from dual

	union all

	select  EDusuario, EDusuario as EDusuarioDESC
	from EDocumentosCxC
	where Ecodigo = #Session.Ecodigo#
	  and CCTcodigo in (
	  					select CCTcodigo
						from CCTransacciones
						where coalesce(CCTpago, 0) != 1)
	group by EDusuario

	Union

	select  Dusuario as EDusuario, Dusuario as EDusuarioDESC
	from HDocumentos
	where Ecodigo = #Session.Ecodigo#
	  and CCTcodigo in (
	  					select CCTcodigo
						from CCTransacciones
						where coalesce(CCTpago, 0) != 1)
	group by Dusuario

	order by EDusuario asc
</cfquery>


<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Documentos#'>

<form name="form1" method="get" action="DocumentosInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend><cfoutput>#LB_DatosReporte#</cfoutput></legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="right"><strong><cfoutput>#LB_Fecha_Inicial#:</cfoutput></strong></td>
						<td width="23%"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
						<td width="1%">&nbsp;</td>
						<td width="13%" align="right" nowrap><strong><cfoutput>&nbsp;#LB_Fecha_Final#:</cfoutput></strong></td>
						<td width="41%"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong><cfoutput>#Oficina#:</cfoutput></strong></td>
						<td><cf_sifoficinas tabindex="1"></td>
						<td nowrap align="left">&nbsp;</td>
						<td nowrap align="right"><strong><cfoutput>#LB_Transaccion#:</cfoutput></strong></td>
						<td align="left">
							<select name="Transaccion" tabindex="1">
								<option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
								<cfoutput query="rsTransacciones">
									<option value="#rsTransacciones.CCTcodigo#">#rsTransacciones.CCTdescripcion#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right"><strong><cfoutput>#LB_SocioNegocio#:</cfoutput></strong></td>
						<td><cf_sifsociosnegocios2 ClientesAmbos="SI" tabindex="1"></td>
						<td align="left">&nbsp;</td>
						<td nowrap align="right"><strong><cfoutput>#LB_USUARIO#:</cfoutput></strong> </td>
						<td nowrap align="left">
							<select name="Usuario" tabindex="1">
							  <cfoutput query="rsUsuarios">
							  	<cfif isdefined("rsUsuarios") and len(trim(rsUsuarios.EDusuario))>
									<option value="#rsUsuarios.EDusuario#">#rsUsuarios.EDusuarioDESC#</option>
								</cfif>
							  </cfoutput>
							</select>
						</td>
					</tr>
            		<tr>
						<td align="right"><strong><cfoutput>#LB_Moneda#:</cfoutput></strong></td>
						<td colspan="4">
							<select name="Moneda" tabindex="1">
								<option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
								<cfoutput query="rsMonedas">
									<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
         			<tr><td colspan="5">&nbsp;</td></tr>
            		<tr>
              			<td align="right"><strong><cfoutput>#LB_Formato#</cfoutput></strong> </td>
              			<td>
							<select name="Formato" id="Formato" tabindex="1">
								<option value="3">HTML</option>
                  				<option value="1">FLASHPAPER</option>
                  				<option value="2">PDF</option>

              				</select>
						</td>
              			<td align="left">&nbsp;</td>
                        <cfoutput>
              			<td align="right"><strong>#LB_Reporte#:</strong></td>
              			<td align="left">
							<input type="radio" name="Reporte" id="Reporte1" value="1" tabindex="1" checked>
								<label for="Reporte1" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_DoctosSApl#</label>
							 <input type="radio" name="Reporte" id="Reporte2" value="2"  tabindex="1">
								<label for="Reporte2" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_DoctosAplic#</label>
						</td>
                        </cfoutput>
            		</tr>
					<tr>
                    <cfoutput>
						<td align="right" colspan="4"><strong>#BTN_Consultar#:</strong></td>
						<td align="left">
							<input type="radio" name="tipoResumen" id="tipoResumen1" value="1" tabindex="1" checked>
								<label for="tipoResumen1" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Resumido#</label>
							 <input type="radio" name="tipoResumen" id="tipoResumen2" value="2"  tabindex="1">
								<label for="tipoResumen2" style="font-style:normal; font-variant:normal; font-weight:normal">#LB_Detallado#</label>
						</td>
                    </cfoutput>
					</tr>
            		<tr><td colspan="5">&nbsp;</td></tr>
            		<tr><td colspan="5">&nbsp;</td></tr>
            		<tr>
						<td colspan="5">
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
	function funcLimpiar(){
		objForm2.obj.reset();
		return false;
	}

	function funcRegresar(){
		<cfif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'D'> //<!--- Facturas --->
			location.href = '../operacion/RegistroFacturas.cfm?<cfoutput>#params#</cfoutput>';
		<cfelseif isdefined("form.tipo") and len(trim(form.tipo)) and form.tipo eq 'C'> //<!--- Notas de Crédito --->
			location.href = '../operacion/RegistroNotasCredito.cfm?<cfoutput>#params#</cfoutput>';
		</cfif>
		return false;
	}
//-->
</script>