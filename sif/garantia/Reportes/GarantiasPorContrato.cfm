<!---<cfquery name="rsMonedas" datasource="#Session.DSN#" result="variable">
	select distinct a.Mcodigo, a.Mnombre 
	from Monedas a 
	inner join CMProceso b
		on b.Mcodigo = a.Mcodigo 
	where b.Ecodigo = #Session.Ecodigo# 
</cfquery> --->
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

<cfset fecha= DateFormat(Now(),'mm/dd/yyyy')> 

<cf_templateheader title="GARANTIAS - REPORTES">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantias Por Contrato'>

<form name="form1" method="get" action="GarantiasPorContratoInfo.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
		  		<table  width="100%" cellpadding="2" cellspacing="0" border="0">
            		<tr><td colspan="5">&nbsp;</td></tr>
					<!---<tr>
						<td width="19%" align="right"><strong>Fecha&nbsp;Inicial:</strong></td>
						<td width="23%"><cf_sifcalendario name="fechaDes" id="fechaDes" tabindex="1" 
					onchange="obtenerTC(this.form);" onblur="obtenerTC(this.form);" value="#fecha#"></td>
						<td width="1%">&nbsp;</td>
						<td width="13%" align="right" nowrap><strong>&nbsp;Fecha&nbsp;Final:</strong></td>
						<td width="41%"><cf_sifcalendario name="fechaHas" id="fechaHas" tabindex="1" 
					onchange="obtenerTC(this.form);" onblur="obtenerTC(this.form);" value="#fecha#"></td>
					</tr>--->
					<tr>						
						<td nowrap align="right"><strong>Proceso:</strong></td>
						<td align="left">
							<select name="Proceso" tabindex="1">
								<option value="-1">Todas</option>
								<cfoutput query="rsGarantiasContrato"> 
									<option value="#rsGarantiasContrato.CMPid#">#rsGarantiasContrato.CMPProceso#</option>
								</cfoutput> 
							</select> 
						</td>
					<!---</tr>					
            		<tr>--->
						<!---<td align="right"><strong>Moneda:</strong></td>
						<td colspan="4">
							<select name="Moneda" tabindex="1">
								<option value="-1">Todas</option>								
								<cfoutput query="rsMonedas">
									<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
								</cfoutput>
							</select>
						</td>--->
						<td align="right"><strong>Estado:</strong></td>
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
						</td>
					</tr> 
					<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="right"><strong>Desde:</strong></td>
						<td width="23%"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1"></td>		
						<td width="13%" align="right" nowrap><strong>Hasta:</strong></td>
						<td width="41%"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					</tr>
				
            		<tr><td colspan="5">&nbsp;</td></tr>
					<tr>
						<td width="19%" align="right"><strong>Provedor: </strong></td>
						<td><cf_sifsociosnegocios2 SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1"></td>						
						<td width="19%" align="right"><strong>Seguimiento</strong></td>
						<td><input name="Seguimiento" type="checkbox" id="Seguimiento" tabindex="1"/> 							</td>
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
