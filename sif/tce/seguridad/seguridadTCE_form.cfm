<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("URL.us") and not isdefined("Form.us")>
	<cfset Form.us = URL.us>
</cfif>

<cfset LvarNomUsuario = "">
<cfif modo neq 'ALTA'>

	<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<cfquery name="rsRetornaUsuario" datasource="#session.dsn#">
	Select Usulogin #LvarCNCT# ' - ' #LvarCNCT# dp.Pnombre #LvarCNCT# ' ' #LvarCNCT# dp.Papellido1 #LvarCNCT# ' ' #LvarCNCT# dp.Papellido2 as Usuario
	from Usuario u
			inner join DatosPersonales dp
				on dp.datos_personales = u.datos_personales	
	where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>

	<cfif rsRetornaUsuario.recordcount gt 0>
		<cfset LvarNomUsuario = rsRetornaUsuario.Usuario>
	</cfif>

</cfif>

<form name="form1" action="seguridadTCE_sql.cfm" method="post" style="margin:0;">
<table width="100%" border="0">
	<tr>
		<td colspan="2" width="1%" nowrap="nowrap" align="left" style="border-bottom: 1px solid black; padding-bottom: 5px;">
			<strong>Usuarios con Permiso para Conciliar</strong>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" nowrap><strong>Usuario:</strong></td>
	</tr>
	<tr>
		<cfif modo eq 'ALTA'>
			<td>
				<cf_sifusuario conlis="true" size="40">
			</td>
		<cfelse>
			<td>
				<cfoutput>#LvarNomUsuario#</cfoutput> 
			</td>
		</cfif>
	</tr>
	<tr>
		<td align="center">
        	<cfoutput>
			<cfif  modo EQ 'ALTA'>
				<input type="submit" name="Alta" id="Alta" value="Agregar">
			<cfelse>
				<input type="hidden" name="Usucodigo" value="#Form.Usucodigo#" />
            	<input type="hidden" name="user" value="#Form.us#" />
				<input type="submit" name="Delete" id="Delete" value="Eliminar Usuario">
				<input type="button" name="Nuevo" value="Nuevo Usuario" onclick=" javascript: document.location = 'SeguridadTCE.cfm'"/>
			</cfif>
            </cfoutput>
		</td>
	</tr>
</table>
</form>


<cf_qforms>
<script language="javascript1.1" type="text/javascript">
	<cfif  modo EQ 'ALTA'>
		objForm.Usucodigo.required = true;
		objForm.Usucodigo.description="Usuario";
	</cfif>
</script>
