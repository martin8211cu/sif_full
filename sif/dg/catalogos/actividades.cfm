
<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
	<cfset form.DGAid = url.DGAid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>
<cfif not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
	<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGAid, a.DGAcodigo, a.DGAdescripcion, a.CEcodigo
		from DGActividades a	
		where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGAid#" >
	</cfquery>
</cfif>
			<cfoutput>
			<form style="margin:0" action="actividades-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Actividades</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="42%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="15" maxlength="10" onfocus="this.select()" 
						name="DGAcodigo" value="<cfif isdefined("data.DGAcodigo")>#trim(data.DGAcodigo)#</cfif>" >
					</td>
				</tr>	

				<tr>
					<td align="right" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="40" maxlength="80" onfocus="this.select()" 
							name="DGAdescripcion" value="<cfif isdefined("data.DGAdescripcion")>#trim(data.DGAdescripcion)#</cfif>">
					</td>
				</tr>	


				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" include="Regresar"></td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<cfif modo eq 'CAMBIO' >
				<input type="hidden" name="DGAid" value="#form.DGAid#" /> 
			</cfif>

			<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
				<input type="hidden" name="filtro_DGAcodigo" value="#form.filtro_DGAcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
				<input type="hidden" name="filtro_DGAdescripcion" value="#form.filtro_DGAdescripcion#"  /> 
			</cfif>
		</form>
		</cfoutput>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.DGAcodigo.required = true;
			objForm.DGAcodigo.description = 'Código';			
			objForm.DGAdescripcion.required = true;
			objForm.DGAdescripcion.description = 'Descripción';			
			
			function deshabilitarValidacion(){
				objForm.DGAcodigo.required = false;
				objForm.DGAdescripcion.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'actividades-lista.cfm';
			}
		</script>
		
