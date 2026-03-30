<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif isdefined("Form.CAMBIO")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif not isdefined ('form.MIGDid') and isdefined ('url.MIGDid') and trim(url.MIGDid) >
	<cfset form.MIGDid=url.MIGDid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsDireccion">
		select 
				MIGDid,
				CodFuente,
				MIGDcodigo,
				MIGDnombre,
				case Dactiva
					when  0 then 'Inactivo'
					when  1 then 'Activo'
				else 'Estado desconocido'
				end as Dactiva
		from MIGDireccion
		where MIGDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGDid#">
	</cfquery> 
	<cfquery name="rsSub_Direcciones" datasource="#session.dsn#">
		select Dactiva,MIGSDcodigo,	MIGSDdescripcion
		from MIGSDireccion
		where MIGDid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGDid#">
		and Dactiva=1
	</cfquery>
</cfif>


<cfoutput>
	<form method="post" name="form1" action="MIGDireccionSQL.cfm" onSubmit="return validar(this);">
	<table >
		<tr valign="baseline"> 
			<td nowrap align="right">Codigo Direcci&oacute;n: </td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsDireccion.MIGDcodigo)#
					<input type="hidden" name="MIGDid" id="MIGDid" value="#htmlEditFormat(rsDireccion.MIGDid)#" tabindex="1">
				<cfelse>
					<input type="text" name="MIGDcodigo" id='MIGDcodigo' maxlength="10" value="" size="20" tabindex="1" onFocus="javascript: this.select();">
				</cfif>	
			</td>
		</tr>		
		<tr valign="baseline"> 
			<td nowrap align="right">Descripci&oacute;n Direcci&oacute;n:</td>
			<td align="left"><input type="text" name="MIGDnombre" id='MIGDnombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsDireccion.MIGDnombre)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<!---<tr valign="baseline"> 
			<td nowrap align="right">Estado:</td>
			<td align="left">
				<select name="Dactiva" size="1" tabindex="1">
					<option value="" ><cfif modo NEQ 'ALTA'>#rsDireccion.Dactiva#</cfif></option>
					<option value="" >-Seleccione un Estado-</option>					
					<option value="0" >Inactivo</option>
					<option value="1" >Activo</option>
			
				</select> 
			</td>
		</tr>--->
		<tr> 
			<td colspan="2" align="center" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr> 
			<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" include="Lista" tabindex="1"></td>
		</tr>
	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) ){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.form1.MIGDcodigo.value; 
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,""); 
		if (Codigo.length==0){
			error_msg += "\n - El codigo de la Dirección no puede quedar en blanco.";
			error_input = formulario.MIGDcodigo;
		}
	</cfif>	
		desp = document.form1.MIGDnombre.value; 
		desp = desp.replace(/(^\s*)|(\s*$)/g,""); 
		if (desp.length==0){
			error_msg += "\n - La descripción no puede quedar en blanco.";
			error_input = formulario.MIGDnombre;
		}
		
		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGDcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGDcodigo;
		}
				
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>