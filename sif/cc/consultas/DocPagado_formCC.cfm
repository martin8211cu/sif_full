<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 18-5-2006.
		Motivo: Nuevo reporte pintado en HTML.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_DocPag = t.Translate('TIT_DocPag','Documentos Pagados')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Desde = t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_DocCS = t.Translate('LB_DocCS','Documentos con Saldo')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>

<cf_templateheader title="#LB_TituloH#">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_DocPag#'>

<cfif isdefined("url.formatos") and not isdefined("form.formatos")>
	<cfset form.formatos = url.formatos>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.FechaI") and not isdefined("form.FechaI")>
	<cfset form.FechaI = url.FechaI>
</cfif>

<cfif isdefined("url.FechaF") and not isdefined("form.FechaF")>
	<cfset form.FechaF = url.FechaF>
</cfif>

<cfif isdefined("url.LvarRecibo") and not isdefined("form.LvarRecibo")>
	<cfset form.LvarRecibo = url.LvarRecibo>
</cfif>

<cfif isdefined("url.chk_DocSaldo") and not isdefined("form.chk_DocSaldo")>
	<cfset form.chk_DocSaldo = url.chk_DocSaldo>
</cfif>

<cfoutput>
	<form name="form1" method="post" action="DocPagado_sqlCC.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>#LB_DatosReporte#</legend>
				<table  width="100%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td nowrap align="right" width="47%"><strong>#LB_SocioNegocio#</strong></td>
						<td>
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cf_sifsociosnegocios2 tabindex="1" idquery="#form.SNcodigo#">
							<cfelse>
								<cf_sifsociosnegocios2 tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Documento#:</strong></td>
						<td> 
							<input name="LvarRecibo" id="LvarRecibo" type="text" value="<cfif isdefined("form.LvarRecibo") and len(trim(form.LvarRecibo))>#form.LvarRecibo#</cfif>" size="30" tabindex="1">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Fecha_Desde#:</strong></td>
						<td >
							<cfif isdefined("form.FechaI") and len(trim(form.FechaI))>
								<cf_sifcalendario form="form1" value="#form.FechaI#" name="FechaI" tabindex="1"> 
							<cfelse>	
								<cfset LvarFecha = createdate(year(now()),month(now()),1)>
								<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>#LB_Fecha_Hasta#:</strong></td>
						<td>
							<cfif isdefined("form.FechaF") and len(trim(form.FechaF))>
								<cf_sifcalendario form="form1" value="#form.FechaF#" name="FechaF" tabindex="1"> 
							<cfelse>
								<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><input type="checkbox" name="chk_DocSaldo" <cfif isdefined('form.chk_DocSaldo')>checked</cfif>   value="1" tabindex="1">&nbsp;</td>
						<td colspan="1" align="left">
							<strong>#LB_DocCS#</strong>
						</td>
					</tr>
					<tr>
						<td align="right" width="10%"><strong>#LB_Formato#&nbsp;</strong></td>
						<td>
						<select name="Formatos" id="Formatos" tabindex="1">
							<option value="1" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 1>selected</cfif>>HTML</option>
							<!--- <option value="2" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 2>selected</cfif>>EXCEL</option> --->
						</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<script language="javascript" type="text/javascript">
	objForm.SNcodigo.required=true;
	objForm.SNcodigo.description='#LB_SocioNegocio#';
	objForm.FechaI.required=true;
	objForm.FechaI.description='#LB_Fecha_Desde#';
	objForm.FechaF.required=true;
	objForm.FechaF.description='#LB_Fecha_Hasta#';
</script>
</cfoutput>
