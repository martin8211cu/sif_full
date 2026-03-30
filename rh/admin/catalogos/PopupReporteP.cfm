<cfif isdefined('url.RHPcodigo') and LEN(TRIM(url.RHPcodigo))>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined('url.formato') and LEN(TRIM(url.formato)) and not isdefined('form.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfparam name="form.formato" default="Flashpaper">

		<form name="form1" action="PopupReporteP.cfm" method="post">
			<cfoutput>
			<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#">
			</cfoutput>
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td align="right"><strong><cf_translate key="LB_Formato">Formato</cf_translate>:&nbsp;</strong>
					<select name="formato" tabindex="1" onchange="javascript: document.form1.submit();">
						<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>
						<option value="pdf" <cfif isdefined('formato') and formato EQ 'pdf'>selected</cfif>>Adobe PDF</option>
						<option value="HTML" <cfif isdefined('formato') and formato EQ 'HTML'>selected</cfif>>HTML</option>
					</select>
				</td>
				<td width="15%" align="left">
					<cf_botones values="Regresar" names="Regresar">
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2" align="center">
					<!--- Requiere que esté definido el RHPcodigo--->
			
					<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) gt 0>
						<cfset form.RHPcodigo = url.RHPcodigo>
					</cfif>
			
					<cfif not isdefined("form.RHPcodigo") or len(trim(form.RHPcodigo)) eq 0>
						<strong><cf_translate key="LB_DebeSeleccionarUnPuestoMostrarElReporte">Debe seleccionar un puesto mostrar el reporte.</cf_translate></strong>
						<cfabort>
					</cfif>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_AdministraciondePuestos"
						Default="Administración de Puestos"
						returnvariable="LB_AdministraciondePuestos"/>
					<iframe id="ReporteP" frameborder="0" name="ReporteP" width="950"  height="600" 
							style="visibility:visible;border:none; vertical-align:top" 
							src="../catalogos/formPuestosReport.cfm?RHPcodigo=<cfoutput>#form.RHPcodigo#</cfoutput>&Formato=<cfoutput>#form.formato#</cfoutput>"></iframe>

				</td>	
			</tr>
		</table>	
		</form>
<script>
	function funcRegresar(){
		window.close();
	}
</script>		