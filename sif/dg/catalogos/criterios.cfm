
<cfif isdefined("url.DGCDid") and not isdefined("form.DGCDid")>
	<cfset form.DGCDid = url.DGCDid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
	<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGCDdescripcion")	and not isdefined("form.filtro_DGCDdescripcion")>
	<cfset form.filtro_DGCDdescripcion = url.filtro_DGCDdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGCDid") and len(trim(form.DGCDid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCDid, a.DGCDcodigo, a.DGCDdescripcion, a.CEcodigo
		from DGCriteriosDistribucion a	
		where a.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#" >
	</cfquery>
</cfif>
<cf_templateheader title="Criterios">
		<cf_web_portlet_start titulo="Criterios">
			<cfoutput>
			<form style="margin:0" action="criterios-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Criterios</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="left" valign="middle" width="1%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="15" maxlength="10" onfocus="this.select()" 
						name="DGCDcodigo" value="<cfif isdefined("data.DGCDcodigo")>#trim(data.DGCDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="80" maxlength="80" onfocus="this.select()" 
							name="DGCDdescripcion" value="<cfif isdefined("data.DGCDdescripcion")>#trim(data.DGCDdescripcion)#</cfif>">
					</td>
				</tr>	

				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" include="Regresar"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<cfif modo eq 'CAMBIO' >
				<input type="hidden" name="DGCDid" value="#form.DGCDid#" /> 
			</cfif>

			<cfif isdefined("form.filtro_DGCDcodigo")>
				<input type="hidden" name="filtro_DGCDcodigo" value="#form.filtro_DGCDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGCDdescripcion")>
				<input type="hidden" name="filtro_DGCDdescripcion" value="#form.filtro_DGCDdescripcion#"  /> 
			</cfif>
		</form>
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.DGCDcodigo.required = true;
			objForm.DGCDcodigo.description = 'Código';			
			objForm.DGCDdescripcion.required = true;
			objForm.DGCDdescripcion.description = 'Descripción';			
			
			function deshabilitarValidacion(){
				objForm.DGCDcodigo.required = false;
				objForm.DGCDdescripcion.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'criterios-lista.cfm';
			}
		</script>
		
	<cf_templatefooter>