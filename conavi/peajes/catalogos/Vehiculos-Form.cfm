<cfoutput>
<cfset check='no'>
<cfif modo neq 'ALTA' and isdefined('form.PVid') and len(trim('form.PVid'))>
	<cfquery name="rsSelectDatosVehiculos" datasource="#session.dsn#">
		select PVcodigo, PVdescripcion, PVoficial, ts_rversion
		from PVehiculos
		where PVid = #form.PVid# and Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset PVcodigo=rsSelectDatosVehiculos.PVcodigo>
	<cfset PVdescripcion=rsSelectDatosVehiculos.PVdescripcion>
	<cfset PVoficial=rsSelectDatosVehiculos.PVoficial>
<cfelse>
	<cfset PVcodigo="">
	<cfset PVdescripcion="">
	<cfset PVoficial="">
</cfif>

<cfform action="Vehiculos-SQL.cfm" method="post" name="form1">
	<table align="center">
		<tr> 
      		<td nowrap align="right">C&oacute;digo:</td>
      		<td>
				<cfinput id="codigo" name="codigo" type="text" maxlength="20"  width="18" value="#PVcodigo#">
			</td>
    	</tr>
	  		<td nowrap align="right">Descripci&oacute;n:</td>
      		<td>
				<input type="text" maxlength="50" name="descripcion" id="descripcion" value="#PVdescripcion#"  size="50"/> 
			</td>
    	</tr>
		<tr> 
      		<td nowrap align="right">Oficial:</td>
      		<td>
				<cfif modo NEQ "ALTA" and #PVoficial# EQ 1> <cfset check='yes'> </cfif>
				<cfinput id="oficial" name="oficial" type="checkbox"  tabindex="1" checked="#check#">
			</td>
    	</tr>
		<tr> 
      		<td colspan="2">
				<cf_botones modo="#modo#">
			</td>
    	</tr>
		
		<tr> 
      		<td colspan="2">
				<input type="hidden" name="modo" value="#modo#" />
				<input type="hidden" name="BMUsucodigo" value="#session.usucodigo#" />
				<input type="hidden" name="Ecodigo" value="#session.Ecodigo#" />
				<cfif modo neq "ALTA">
					<input type="hidden" id="PVid" name="PVid" value="#form.PVid#" />
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsSelectDatosVehiculos.ts_rversion#" returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</td>
    	</tr>
  	</table>
</cfform>
<cf_qforms form='form1'>
<script language="javascript1.2" type="text/javascript">
	objForm.codigo.description = "#JSStringFormat('Codigo')#";
	objForm.descripcion.description = "#JSStringFormat('Descripcion')#";
	objForm.codigo.required = true;
</script>
</cfoutput>
