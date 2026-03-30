<cfif isdefined("form.QPTid") and len(trim(form.QPTid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>
<cfif modo NEQ 'ALTA'>
	<cflocation url="Traslado.cfm?QPTid=#QPTid#">
</cfif>

	<cfquery name="rsForm" datasource="#session.dsn#">
			select 
				e.QPTid,
				e.OcodigoOri, 
				e.OcodigoDest, 
				oo.Odescripcion as OficinaOri,
				od.Odescripcion as OficinaDest,
				e.QPTtrasDocumento, 
				e.QPTtrasDescripcion, 
				oo.Oficodigo, 
				od.Oficodigo, 
				BMFecha as Fecha
			from QPassTraslado e
				inner join Oficinas oo
				on oo.Ecodigo = e.Ecodigo
				and oo.Ocodigo = e.OcodigoOri
			
				inner join Oficinas od
				on od.Ecodigo = e.Ecodigo
				and od.Ocodigo = e.OcodigoDest
			where e.Ecodigo = #session.Ecodigo# 
            and exists(
                        select 1
                        from QPassUsuarioOficina f
                        where f.Usucodigo = #session.Usucodigo#
                        and  f.Ecodigo = #session.Ecodigo#
                        and f.Ecodigo = oo.Ecodigo
                        and f.Ocodigo = oo.Ocodigo
                       )
		</cfquery>

	<cfquery name="rsOficinas" datasource="#Session.DSN#" >
		select 
			a.Ocodigo,
			a.Oficodigo,
			a.Odescripcion 
				from Oficinas a
				inner join QPassUsuarioOficina b 
				on a.Ocodigo = b.Ocodigo
				and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = #session.Ecodigo#
			and b.Usucodigo = #session.Usucodigo#
			order by a.Oficodigo
	</cfquery>

	<cfquery name="rsOficinasD" datasource="#Session.DSN#" >
		select 
			a.Ocodigo,
			a.Oficodigo,
			a.Odescripcion 
				from Oficinas a
			where a.Ecodigo = #session.Ecodigo#
			order by a.Oficodigo
	</cfquery>

<cfoutput>
	<fieldset>
		<form action="TrasladoQPass_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
			<table width="80%" align="center" border="0" >
				<tr>
				<!---Nmero del Documento --->
					<td align="right"><strong>Documento:</strong></td>
					<td colspan="2">
						<cfif modo eq "ALTA">
							&nbsp;&nbsp; ---Nuevo Documento--- 
						<cfelseif modo eq "CAMBIO">
							#rsForm.QPTtrasDocumento#
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
						<input type="text" name="QPTtrasDescripcion" maxlength="201" size="40" id="QPTtrasDescripcion" tabindex="0" style="border-spacing:inherit" value="" />
				</tr>			
				<tr>
					<td align="right"><strong>Sucursal Origen:</strong></td>
					<td>
					<!---Pinta La Oficina Inicial--->
							<select name="OficinaIni" tabindex="1">
							 	<cfloop query="rsOficinas">
									<option value="#rsOficinas.Ocodigo#"<cfif modo NEQ "ALTA"><cfif rsForm.OcodigoOri eq #rsOficinas.OcodigoOri#>selected</cfif></cfif> >#rsOficinas.Oficodigo#-#rsOficinas.Odescripcion#</option>
								</cfloop>
							</select>
						</td> 
				</tr>	
				<tr>
					<td align="right"><strong>Sucursal Destino:</strong></td>
					<td>
					<!---Pinta La Oficina Destino--->
							<select name="OficinaDes" tabindex="1">
							 	<cfloop query="rsOficinasD">
									<option value="#rsOficinasD.Ocodigo#"<cfif modo NEQ "ALTA"><cfif rsForm.OficinaDest eq #rsOficinasD.OficinaDest#>selected</cfif></cfif> >#rsOficinasD.Oficodigo#-#rsOficinasD.Odescripcion#</option>
							</cfloop>
							</select>
						</td> 
				</tr>					
				<tr><td colspan="3"></td></tr>
				<tr valign="baseline"> 
					<td colspan="3" align="center" nowrap>
						<cfif isdefined("form.QPTid") and isdefined("form.QPTid")> 
							<cf_botones modo="#modo#" tabindex="1">
						<cfelse>
							<cf_botones modo="#modo#" tabindex="1">
						</cfif> 
					</td>
				</tr>
				<tr>
					<td colspan="3">
						<input type="hidden" name="Pagina3" 
						value="
							<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
								#form.pagenum3#
							<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
								#url.PageNum_lista3#
						</cfif>">
					</td>
				</tr>
			</table>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
		objForm.QPTtrasDescripcion.description = "Descripcin";
		
	function habilitarValidacion() 
	{
		objForm.QPTtrasDescripcion.required = true;
	}
	
	function validar(formulario){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
		if (document.form1.OficinaIni.value == document.form1.OficinaDes.value) {
			error_msg += "Las sucursales deben ser distintas" 
			error_input = formulario.OficinaIni;
			}				

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}    
</script>
</cfoutput>