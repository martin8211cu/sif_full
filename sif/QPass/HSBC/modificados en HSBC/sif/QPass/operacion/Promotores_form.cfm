<cfif isdefined("url.QPEAPid") and len(trim(url.QPEAPid)) and not isdefined("form.QPEAPid")>
	<cfset form.QPEAPid = url.QPEAPid>
</cfif>

<cfif isdefined("form.QPEAPid") and len(trim(form.QPEAPid))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfif modo NEQ 'ALTA'>
	<cflocation url="TagPromotores.cfm?QPEAPid=#QPEAPid#" addtoken="no">
</cfif>

<cfif modo NEQ 'ALTA'>
    <cfquery name="rsForm" datasource="#session.dsn#">
        select 
            a.QPEAPid,
            b.Ocodigo, 
            c.Odescripcion as OficinaOri,
            b.QPPid, 
            b.QPPnombre as OficinaDest,
            a.QPEAPDocumento, 
            a.QPEAPDescripcion, 
            c.Oficodigo, 
            b.QPPcodigo
        from QPEAsignaPromotor  a
            inner join QPPromotor b
                on b.QPPid = a.QPPid
            inner join Oficinas c
                on c.Ecodigo  = b.Ecodigo
                and c.Ocodigo = b.Ocodigo
        
        where a.Ecodigo = #session.Ecodigo# 
        and exists(
                    select 1
                    from QPassUsuarioOficina f
                    where f.Usucodigo = #session.Usucodigo#
                    and  f.Ecodigo = #session.Ecodigo#
                    and f.Ecodigo = c.Ecodigo
                    and f.Ocodigo = c.Ocodigo
                   )
    </cfquery>
</cfif>    



<cf_dbfunction name='OP_CONCAT' returnvariable="_Cat">
<cfquery name="rsUsuarioEnvia" datasource="#Session.DSN#" >
	select 
        a.Usulogin,
        b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as Usuario
    from Usuario a
    	inner join DatosPersonales b
         on b.datos_personales = a.datos_personales
    where Usucodigo = #session.Usucodigo# 
</cfquery>

<cfquery name="rsPromotorDestino" datasource="#Session.DSN#" >
    select 
        a.QPPid,
        a.QPPcodigo,
        a.QPPnombre
    from QPPromotor a
   	   inner join QPassUsuarioOficina b
    	on b.Ocodigo = a.Ocodigo 
        and b.Usucodigo = #session.Usucodigo#
    where a.Ecodigo = #session.Ecodigo#
    and a.QPPestado = '1'
    order by QPPcodigo
</cfquery>


<cfoutput>
	<fieldset>
		<form action="TagPromotores_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); " onSubmit="return validar(this);"> 
			<table width="80%" align="center" border="0" >
				<tr>
				<!---Número del Documento --->
					<td align="right"><strong>Documento:</strong></td>
					<td colspan="2">
                    <cfif modo NEQ 'ALTA'>
                    	&nbsp;&nbsp; #rsForm.QPEAPDocumento#
						<input type="hidden" name="QPEAPDocumento" value="#rsForm.QPEAPDocumento#">
                    <cfelse>
                    	&nbsp;&nbsp; *** Por generar ***
                    </cfif>
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Descripci&oacute;n:</strong></td>
					<td colspan="2">
						<input type="text" name="QPEAPDescripcion" maxlength="201" size="40" id="QPEAPDescripcion" tabindex="0" style="border-spacing:inherit" value="" />
				</tr>			
				<tr>
					<td align="right"><strong>Usuario que envia:</strong></td>
					<td class="titulolistas" nowrap="nowrap">
					<!---Pinta La Oficina Inicial--->
							#rsUsuarioEnvia.Usulogin# -  #rsUsuarioEnvia.Usuario#
						</td> 
				</tr>	
				<tr>
					<td align="right"><strong>Promotor Destino:</strong></td>
					<td class="titulolistas">
					<!---Pinta La Oficina Destino--->
							<select name="QPPid" tabindex="1">
							 	<cfloop query="rsPromotorDestino">
									<option value="#rsPromotorDestino.QPPid#"<cfif modo NEQ "ALTA"><cfif rsForm.QPPid eq #rsPromotorDestino.QPPid#>selected</cfif></cfif> >#rsPromotorDestino.QPPcodigo#-#rsPromotorDestino.QPPnombre#</option>
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
		objForm.QPEAPDescripcion.description = "Descripción";
		
	function habilitarValidacion() 
	{
		objForm.QPEAPDescripcion.required = true;
	}
	
	function validar(formulario){
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('IrLista',document.form1)){
			var error_input;
			var error_msg = '';
	
	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
	}
}    
</script>
</cfoutput>