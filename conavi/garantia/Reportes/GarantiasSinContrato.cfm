<cfset fecha= DateFormat(Now(),'mm/dd/yyyy')> 

<cf_templateheader title="CONAVI GARANTIAS - REPORTES">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantias Sin Contrato'>

<form name="form1" method="get" action="GarantiasSinContratoInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td align="right"><strong>Estado:</strong></td>
						<td colspan="5">
							<select name="Estado" tabindex="1">
								<option value="-1">Todas</option>
								<option value="1">Vigente</option>
								<option value="2">Edicion</option>
								<option value="3">En proceso de Ejecución</option>
								<option value="4">En Ejecución</option>
								<option value="5">Ejecutada</option>
								<option value="6">En proceso Liberación</option>
								<option value="7">Liberada</option>
								<option value="8">Devuelta</option> 
							</select>
						</td>
						<td width="19%" colspan="5" align="right"><strong>Seguimiento</strong></td>
						<td colspan="5"><input name="Seguimiento" type="checkbox" id="Seguimiento" tabindex="1"/> 						</td>
					</tr> 
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="right" colspan="5"><strong>Desde:</strong></td>
						<td width="23%" ><cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>		
						<td width="13%" align="right" colspan="5"><strong>Hasta:</strong></td>
						<td width="41%" colspan="3"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>				
					        		
            		<tr><td colspan="5">&nbsp;</td></tr>
            		<tr><td colspan="5">&nbsp;</td></tr>
            		<tr>
						<td colspan="15" align="center">
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
