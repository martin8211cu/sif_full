<cfset fecha= DateFormat(Now(),'mm/dd/yyyy')> 

<cf_templateheader title="CONAVI GARANTIAS - REPORTES">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Garantias Devueltas'>

<form name="form1" method="post" action="GarantiasDevueltasInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="4">&nbsp;</td></tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td width="32%" align="right"><strong>Desde:</strong></td>
					  <td width="14%" ><cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>		
						<td width="11%" align="right"><strong>Hasta:</strong></td>
					  <td width="43%"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>				
					        		
            		<tr><td colspan="4">&nbsp;</td></tr>
            		<tr><td colspan="4">&nbsp;</td></tr>
            		<tr>
						<td colspan="4" align="center">
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
//-->
</script>
