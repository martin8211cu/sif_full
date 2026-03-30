<table border="0" width="100%"  cellspacing="0" cellpadding="0">
<tr>
<td width="1%">&nbsp;</td>
<td>&nbsp;</td>
<td width="1%">&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>
<!--- Aquí Va el Usuario --->
<fieldset>
<legend>Usuario</legend>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsUsuario" datasource="#session.dsn#">
	select Usucodigo, Usulogin, Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as Usunombre
	from Usuario a inner join DatosPersonales b on a.datos_personales = b.datos_personales
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
</cfquery>
<br>
<form action="PSUsuariosCentrosFuncionales-sql.cfm" method="post" onsubmit="javascript:return validacionCopiarSCM();" name="form1" >
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <cfoutput query="rsUsuario">
  <tr>
  	<td colspan="5" nowrap class="subtitulo"><strong>Informaci&oacute;n General</strong>&nbsp;</td>
  </tr>
  <tr>
	<td width="1%" nowrap>Login:</td>
	<td>#Usulogin#&nbsp;</td>
  </tr>
  <input type="hidden" value="#Usucodigo#" name="Usucodigo"/>
  <tr>
	<td width="1%" nowrap>Nombre:</td>
	<td>#Usunombre#&nbsp;</td>
    <td width="1%" nowrap>Copiar Seguridad A:</td>
    <td nowrap="nowrap" width="40">
    	<cf_conlis
        Campos="UsucodigoE,UsuloginE,UsunombreE"
        Desplegables="N,S,S"
        Modificables="N,S,N"
        Size="0,7,30"
        tabindex="5"
        Title="Lista de Usuarios"
        Tabla="Usuario a inner join DatosPersonales info on a.datos_personales = info.datos_personales
        	   inner join vUsuarioProcesos b
				on a.Usucodigo = b.Usucodigo
				inner join Empresa c
				on b.Ecodigo = c.Ecodigo
				and c.Ereferencia = #session.Ecodigo#
				and c.CEcodigo = #session.CEcodigo#"
        Columnas="distinct a.Usucodigo as UsucodigoE, a.Usulogin as UsuloginE, Pnombre #_Cat# ' ' #_Cat# Papellido1 #_Cat# ' ' #_Cat# Papellido2 as UsunombreE"
        Filtro="a.Utemporal = 0	and a.Uestado = 1 and a.Usucodigo <> #form.Usucodigo# order by a.Usulogin"
        Desplegar="UsuloginE,UsunombreE"
        Etiquetas="Login,Nombre"
        filtrar_por="Usulogin,Usunombre"
        Formatos="S,S"
        Align="left,left"
        form="form1"
        Asignar="UsucodigoE,UsuloginE,UsunombreE"
        Asignarformatos="S,S,S"											
       />
    </td>
    <td>	
       &nbsp;&nbsp;<input name="btnExpUsuarios" type="submit" value="Copiar Seguridad" title="Copiar Seguridad al usuario elegido" alt="Copiar Seguridad al usuario elegido">&nbsp;
    </td>
  </tr>
  <tr>
	<td>&nbsp;</td><td>&nbsp;</td>
	<td align="right"> Incluir:</td>
	<td colspan="2" ><label style="font-size:10px"><input type="checkbox" name="copiarSF" id="copiarSF" <cfif isdefined("form.copiarSF")> checked="checked"</cfif> />Seguridad Centro Funcional</label>
					 &nbsp;&nbsp;
					 <label style="font-size:10px"><input type="checkbox" name="copiarSC" id="copiarSC" <cfif isdefined("form.copiarSC")> checked="checked"</cfif>/>Seguridad Cuenta (Mascaras)</label></td>
	
  </tr>
  </cfoutput>
</table>
</form>
<br>
<div style="overflow:auto; height: 296; margin:0;" >
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><cfinclude template="PSUsuariosCentrosFuncionales.cfm"></td>
  </tr>
  <tr><td>&nbsp;</td></tr>
  <tr>
    <td valign="top">&nbsp;<cfinclude template="PSUsuariosMascaras.cfm"></td>
  </tr>
</table>
</div>
</fieldset>
<!--- Aquí termina el Usuario --->
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</table>
<script type="text/javascript">
	function validacionCopiarSCM()
	{
		var iduser = document.getElementById('UsuloginE');
	
		if(iduser!=null  && iduser.value!='')
		{
			if( (document.getElementById('copiarSF').checked) || (document.getElementById('copiarSC').checked))
			{
					return true;
			}else{
				alert('No se ha Seleccionado Permisos para Copiar');
				return false;
			}			
		}else
		{
			alert('No se ha Seleccionado Usuario para Copiar Permisos');
			return false;
		}
		return false;
	}
</script>
