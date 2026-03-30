<table border="0" width="100%"  cellspacing="0" cellpadding="0">
<tr>
<td width="1%">&nbsp;</td>
<td>&nbsp;</td>
<td width="1%">&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>
<fieldset>
	<legend>B&uacute;squeda de Usuarios</legend>
	<cfoutput>
	<form action="#CurrentPage#" method="post" name="formBusquedaUsucodigo">
	<table border="0" width="100%"  cellspacing="0" cellpadding="0" class="AreaFiltro">
		  <tr>
			<td nowrap><strong>Login</strong></td>
			<td nowrap><strong>Nombre Usuario</strong></td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><input name="fUsulogin" type="text"></td>
			<td nowrap><input name="fUsunombre" type="text"></td>
			<td nowrap><input name="btnBuscar" type="submit" value="Buscar"></td>
		  </tr>
		 </table>
	</form>
	</cfoutput>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="rsGetUsucodigo" datasource="asp">
			select distinct a.Usucodigo, a.Usulogin, Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as Usunombre
			from Usuario a
				inner join DatosPersonales info
				on a.datos_personales = info.datos_personales
				inner join vUsuarioProcesos b
				on a.Usucodigo = b.Usucodigo
				inner join Empresa c
				on b.Ecodigo = c.Ecodigo
				and c.Ereferencia = #session.Ecodigo#
				and c.CEcodigo = #session.CEcodigo#
			where a.Utemporal = 0
				and a.Uestado = 1
			<cfif (isdefined("form.fUsulogin") and len(trim(form.fUsulogin)))>
				and upper(a.Usulogin) like '%#Ucase(form.fUsulogin)#%'
			</cfif>
			<cfif (isdefined("form.fUsunombre") and len(trim(form.fUsunombre)))>
				and upper(Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre) like '%#Ucase(form.fUsunombre)#%'
			</cfif>
			order by a.Usulogin
		</cfquery>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="25px" class="titulolistas">&nbsp;</td>
		<td width="45px" class="titulolistas"><strong>Login</strong></td>
		<td class="titulolistas"><strong>Nombre Usuario</strong></td>
	  </tr>
	 </table>
	<div style="overflow:auto; height: 265; margin:0;">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <cfif rsGetUsucodigo.recordcount>
	  <cfoutput query="rsGetUsucodigo">
	  	<tr onClick="
				javascript:
				document.formFoundUsucodigo.Usucodigo.value=#rsGetUsucodigo.Usucodigo#;
				document.formFoundUsucodigo.submit();"
	  		class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
			onmouseover="this.className='listaParSel';" 
			onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';"
			style="cursor:pointer;">
		<td width="25px"><cfif isdefined("form.Usucodigo") and Usucodigo EQ form.Usucodigo><img src="/cfmx/sif/imagenes/addressGo.gif"><cfelse>&nbsp;</cfif></td>
		<td width="45px">#Usulogin#</td>
		<td >#Usunombre#</td>
	  </tr></cfoutput>
	  <cfelse>
	  <tr><td align="center" colspan="2"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
	  </cfif>
	</table>
	<cfoutput>
	<form action="#CurrentPage#" method="post" name="formFoundUsucodigo">
		<input type="hidden" name="Usucodigo">
	</form>
	</cfoutput>
	</div>
</fieldset>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>