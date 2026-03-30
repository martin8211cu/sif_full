<cfquery name="rsGarantiasContrato" datasource="#Session.DSN#">
	select <!---a.CMPid, b.CMPid,---> distinct b.CMPProceso,a.CMPid, b.CMPid
	from COEGarantia a
	inner join CMProceso b
		on b.CMPid  = a.CMPid
	<!---inner join COEGarantia c
		on c.CMPid  = a.CMPid
		and c.COEGTipoGarantia = 2---> 
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
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Vencimiento de Garantias'>

<form name="form1" method="post" action="VencimientoGarantiasInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="5">&nbsp;</td></tr>
					<tr>						
						<td nowrap align="right"><strong>Proceso:</strong></td>
						<td  colspan="4" align="left">
							<select name="Proceso" tabindex="1">
								<option value="-1">Todas</option>
								<option value="0">--Sin Proceso--</option>
								<cfoutput query="rsGarantiasContrato"> 
									<option value="#rsGarantiasContrato.CMPid#">#rsGarantiasContrato.CMPProceso#</option>
								</cfoutput> 
							</select> 
					  </td>
					  <!---<td align="right"><strong>Estado:</strong></td>
						<td colspan="4">
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
						</td>--->
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
						<td align="rigth"><div align="right"><strong>Desde:</strong></div></td>
						<td width="2%" align="left"> <cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>
					    <td width="7%" align="left"><div align="right"><strong>Hasta:</strong></div></td>
     					<td width="39%" align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>	
						<td width="40%">&nbsp;</td>
					</tr>												
            		<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="12%" align="right"><strong>Provedor: </strong></td>
						<td colspan="4"><cf_sifsociosnegocios2 SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1"></td>							
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
//-->
</script>
