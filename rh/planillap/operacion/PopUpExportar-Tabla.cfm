<cf_templatecss>
<cfif isdefined("url.RHTTid")>
	<cfparam name="form.RHTTid" default="#url.RHTTid#">
</cfif>
<cfif isdefined("url.RHEid")>
	<cfparam name="form.RHEid" default="#url.RHEid#">
</cfif>
<cfif isdefined("url.RHETEid")>
	<cfparam name="form.RHETEid" default="#url.RHETEid#">
</cfif>

<cfif isdefined("form.RHEid") and len(trim(form.RHEid)) and isdefined("form.RHETEid") and len(trim(form.RHETEid))>
	<cfquery name="rsTabla" datasource="#session.DSN#">
		select RHTTid 
		from RHETablasEscenario
		where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
			and RHETEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHETEid#">
	</cfquery>
</cfif>

<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr><td colspan="3" align="center"><strong style="color:##003366;font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Exportaci&oacute;n de Tablas Salariales</strong></td></tr>
	<tr><td colspan="3" align="center">
		<table width="95%" align="center"><tr><td>
		<hr>
		</td></tr></table>
	</td></tr>
	<tr>
		<td align="center" width="2%">&nbsp;</td>
		<td align="center" valign="top" width="55%">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Pasos de la importaci&oacute;n">
				<u>Seleccione la opci&oacute;n:</u> Generar HTML creará una página HTML con los datos, 
					y generar línea de encabezados un archivo de texto.<bR><br>
				<u>Importaci&oacute;n:</u>&nbsp;Una vez seleccionada presione el bot&oacute;n <strong>Generar</strong>.<br>							
			<cf_web_portlet_end>
		</td>					
		<td align="center" style="padding-left: 15px " valign="top">
			<cfif isdefined("rsTabla") and rsTabla.RecordCount NEQ 0>
				<cf_sifimportar EIcodigo="E_RH_TABSAL" mode="out">
					<cf_sifimportarparam name="Origen" value= "ES">
					<cf_sifimportarparam name="Vigencia" value= "0">
					<cf_sifimportarparam name="Escenario" value= "#form.RHEid#">
					<cfif isdefined("rsTabla.RHTTid") and len(trim(rsTabla.RHTTid))>
						<cf_sifimportarparam name="Tabla" value= "#rsTabla.RHTTid#"> 
					</cfif>
				</cf_sifimportar>
			<cfelse>
				<strong>Debe seleccionar el escenario y la tabla salarial</strong>
			</cfif>
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>

