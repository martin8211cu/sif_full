<!--- 
	Creado por Israel Rodiguez.
		Fecha: 05-OCT-2017.
		Motivo: Nuevo reporte pintado en HTML donde se muestran los pagos realizado y  que no  tienen  un  CFDI relacionado.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_PagosR 	= t.Translate('TIT_PagosR','Pagos Realizados sin CFDI Relacionado')>
<cfset LB_SocioNegocio 	= t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset LB_RecPago 	  = t.Translate('LB_RecPago','Recibo de Pago')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>



<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_PagosR#'>

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
<cfoutput>
	<form name="form1" method="post" action="PagosSinCFDI33_sql.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset><legend>#LB_DatosRep#</legend>
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
						<td align="right"><strong>#LB_RecPago#:</strong></td>
						<td> 
							<input name="LvarRecibo" id="LvarRecibo" type="text" value="<cfif isdefined("form.LvarRecibo") and len(trim(form.LvarRecibo))>#form.LvarRecibo#</cfif>" size="30" tabindex="1">
						</td>
					</tr>
					<tr>
						<!---<td align="right" width="10%"><strong>#LB_Formato#&nbsp;</strong></td>
						<td>
						<select name="Formatos" id="Formatos" tabindex="1">
							<option value="1" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 1>selected</cfif>>HTML</option>
							<!--- <option value="2" <cfif isdefined("form.formatos") and len(trim(form.formatos)) and form.formatos eq 2>selected</cfif>>EXCEL</option> --->
						</select>
						</td>--->
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>	
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form = 'form1'>
<cfoutput>
<script language="javascript" type="text/javascript">
	//objForm.SNcodigo.required=false;
	//objForm.SNcodigo.description='#LB_SocioNegocio#';
	objForm.FechaI.required=true;
	objForm.FechaI.description='#LB_Fecha_Desde#';
	objForm.FechaF.required=true;
	objForm.FechaF.description='#LB_Fecha_Hasta#';
	document.form1.SNnumero.focus();
</script>
</cfoutput>