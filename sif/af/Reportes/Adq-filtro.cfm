<!--- 
	Creado por Gustavo Fonseca H.
		Motivo: Nueva consulta para exportación a Excel del módulo de Activos Fijos.
		Fecha:16-5-2006.
 --->

<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
			<cfoutput>
			<form name="form1" method="get" style="margin:0;" action="Adq_form.cfm">
				<table align="center" border="0" width="100%" cellpadding="2" cellspacing="0">
					<tr><td colspan="7">&nbsp;</td></tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Per&iacute;odo:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.periodoInicial") and len(trim(url.periodoInicial))>
								<cf_periodos name="periodoInicial" value="#url.periodoInicial#" tabindex="1">
							<cfelse>
								<cf_periodos name="periodoInicial" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Mes Inicial:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.mesInicial") and len(trim(url.mesInicial))>
								<cf_meses name="mesInicial" value="#url.mesInicial#" tabindex="1">
							<cfelse>
								<cf_meses name="mesInicial" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Mes Final:</strong>&nbsp;</td>
						<td>
							<cfif isdefined("url.mesFinal") and len(trim(url.mesFinal))>
								<cf_meses name="mesFinal" value="#url.mesFinal#" tabindex="1">
							<cfelse>
								<cf_meses name="mesFinal" tabindex="1">
							</cfif>
						
						</td>
					</tr>					
					<tr>
						<td colspan="7" align="center"> 	
							<input type="submit" onclick="Generar();"   class="btnNormal" name="btn_consultar" value="Generar" tabindex="1"/>
						</td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
				</table>
			</form>	
			</cfoutput>
		<cf_web_portlet_end>

		<cf_qforms>
		<script type="text/javascript" language="javascript1.2">
			objForm.periodoInicial.required = true;
			objForm.periodoInicial.description = 'Período';
			objForm.mesInicial.required = true;
			objForm.mesInicial.description = 'Mes Inicial';
			objForm.mesFinal.required = true;
			objForm.mesFinal.description = 'Mes Final';			
			function Generar(){
					document.form1.submit();
					}
		</script>
	<cf_templatefooter>