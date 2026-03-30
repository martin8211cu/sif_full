<cfquery name="rsGarantiasContrato" datasource="#Session.DSN#">
	select distinct b.CMPProceso,a.CMPid, b.CMPid
	from COEGarantia a
	inner join CMProceso b
		on b.CMPid  = a.CMPid
	where b.Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsTiposRendicion" datasource="#Session.DSN#">
  select  
    COTRid,
	COTRCodigo,
	COTRDescripcion 
  from COTipoRendicion 
    where Ecodigo = #session.ecodigo#
</cfquery>

<cfset fecha= DateFormat(Now(),'mm/dd/yyyy')> 

<cf_templateheader title="GARANTIAS - REPORTES">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantias Recibidas'>

<form name="form1" method="post" action="GarantiasRecibidasInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="5">&nbsp;</td></tr>
			
				<tr>
					<td nowrap width="10%"> 
						<input type="radio" name="tipoResumen" value="1" checked id="tipoResumen1" tabindex="1">
						<label for="tipoResumen1" style="font-style:normal; font-variant:normal;">Resumido&nbsp;</label>
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen" value="2"  id="tipoResumen2" tabindex="1">
						<label for="tipoResumen2" style="font-style:normal; font-variant:normal;">Detallado por Documento</label>
					</td>
				</tr>
			
				<tr>
					<td align="right"><strong>Tipo Rendición:</strong></td>
						<td colspan="4">
							<select name="Trendicion" tabindex="1">
							    <option value="-1">Todos</option>
								<cfloop query="rsTiposRendicion">
								 <option value="<cfoutput>#rsTiposRendicion.COTRid#</cfoutput>"><cfoutput>#rsTiposRendicion.COTRCodigo# - #rsTiposRendicion.COTRDescripcion#</cfoutput></option>
								</cfloop>						
							</select>
						</td>
				
					</tr> 
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="right"><strong>Desde:</strong></td>
						<td width="23%"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>		
						<td width="13%" align="right" nowrap><strong>Hasta:</strong></td>
						<td width="41%"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
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
	
	/*function funcCambio(parmvalor){
		
	}
		funcCambio(1);*/

</script>
