<cfparam name="url.Usucodigo" type="numeric">
<cfparam name="url.CEcodigo" type="numeric" default="0">
<cfparam name="url.msg" default="">
<cfparam name="url.error" default="0">
<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#url.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="reglas" data="#dataPoliticas#" returnvariable="reglas"/>
<cfif url.Usucodigo is 1>
	<!--- proteger a pso --->
	<cflocation url="index.cfm">
</cfif>

<cf_templateheader title="Cambiar Login a Usuarios"><cf_web_portlet_start titulo="Cambiar Login a Usuarios">
<cfinclude template="/home/menu/pNavegacion.cfm">

<cfquery datasource="asp" name="usuario">
	select c.CEcodigo, c.CEnombre, c.CEaliaslogin,
		u.Usucodigo, u.Usulogin, p.Pnombre, p.Papellido1, p.Papellido2,
		p.Pemail1,
		u.Uestado,
		up.AllowedAccess, up.PasswordSet
	from Usuario u
		join DatosPersonales p
			on u.datos_personales = p.datos_personales
		join CuentaEmpresarial c
			on c.CEcodigo = u.CEcodigo
		join UsuarioPassword up
			on up.Usucodigo = u.Usucodigo
	where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
	  and u.Usucodigo != 1 <!--- proteger a pso --->
</cfquery>

<cfif usuario.recordcount eq 0>
	<!--- Cuando el usuario no se pudo firmar para cambiar la contraseña e indicar la pregunta secreta, entonces no se debe tomar en cuenta la tabla UsuarioPassword en esta pantalla --->
	<cfquery datasource="asp" name="usuario">
        select c.CEcodigo, c.CEnombre, c.CEaliaslogin,
            u.Usucodigo, u.Usulogin, p.Pnombre, p.Papellido1, p.Papellido2,
            p.Pemail1,
            u.Uestado,
            1 as AllowedAccess, 
            <cf_dbfunction name="now"> as PasswordSet
        from Usuario u
            join DatosPersonales p
                on u.datos_personales = p.datos_personales
            join CuentaEmpresarial c
                on c.CEcodigo = u.CEcodigo
        where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
          and u.Usucodigo != 1 <!--- proteger a pso --->
    </cfquery>
</cfif>

<cfif usuario.recordcount eq 0>
	<cfthrow message="Usuario #url.Usucodigo# no válido en el sistema, favor contactar con el departamento de soporte." detail="Se debe revisar ese usuario en las tablas Usuario, DatosPersonales y CuentaEmpresarial">
</cfif>

<cfquery datasource="aspmonitor" name="bloqueos" maxrows="100">
	select bloqueo, fecha, razon, case when desbloqueado = 1 then 'Si' else 'No' end as desbloq
	from UsuarioBloqueo
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
	order by bloqueo desc
</cfquery>
<cfquery datasource="aspmonitor" name="login_incorrecto" maxrows="100">
	select LIcuando, LIip, LIalias, LIlogin, LIrazon, LIcontador, LIbloqueo
	from LoginIncorrecto
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#url.Usucodigo#">
	  and LIcontador is not null
	order by LIcuando desc
</cfquery>

<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cfset sesion_bloqueo_cant = Politicas.trae_parametro_cuenta("sesion.bloqueo.cant","#url.CEcodigo#")>
<cfset sesion_bloqueo_duracion = Politicas.trae_parametro_cuenta("sesion.bloqueo.duracion","#url.CEcodigo#")>
<cfset sesion_bloqueo_periodo = Politicas.trae_parametro_cuenta("sesion.bloqueo.periodo","#url.CEcodigo#")>

<cfoutput>
<form name="form1" id="form1" method="post" action="rename-sql.cfm" onsubmit="javascript: return validar();">
<input type="hidden" name="Usucodigo" value="#usuario.Usucodigo#">
<input type="hidden" name="CEcodigo" value="#usuario.CEcodigo#">
<table width="856" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td width="50">&nbsp;</td>
    <td width="137">&nbsp;</td>
    <td width="383">&nbsp;</td>
    <td width="273">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" class="subTitulo">Cambiar Login a Usuarios</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>

<cfif len(trim(url.msg))>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" valign="top"><div style="background-color:##<cfif url.error eq 1>FF0000<cfelse>009900</cfif>;color:white;font-weight:bold">#HTMLEditFormat(url.msg)#</div></td>
    <td>&nbsp;</td>
  </tr>
</cfif>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Cuenta Empresarial </td>
    <td valign="top">#HTMLEditFormat(usuario.CEnombre)#</td>
    <td>Reglas para la creación del usuario</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Alias</td>
    <td valign="top">#HTMLEditFormat(usuario.CEaliaslogin)#</td>
    <td rowspan="6">   <!---se agregan las reglas validas para crear el login--->      
		<cfif ArrayLen(reglas.erruser)>
        <ul>
        <li><cfoutput>#ArrayToList( reglas.erruser, '</li><li>')#</cfoutput></li>
        </ul>
        </cfif>
    </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Nombre</td>
    <td valign="top">
      #HTMLEditFormat(usuario.Pnombre)#
      #HTMLEditFormat(usuario.Papellido1)#
      #HTMLEditFormat(usuario.Papellido2)#
    </td>
    </tr>

  <tr>
    <td>&nbsp;</td>
    <td valign="top">Login</td>
    <td valign="top">#HTMLEditFormat(Trim (usuario.Usulogin) )#</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">E-mail</td>
    <td valign="top"><input type="text" size="40" maxlength="100" value="#HTMLEditFormat(Trim (usuario.Pemail1) )#" name="email" id="email" onFocus="javascript: this.select();"></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Nuevo Login</td>
    <td valign="top"><input type="text" 
							value="" 
							size="40" 
							maxlength="100" 
							name="newlogin" 
							id="newlogin"
							onFocus="javascript: this.select();" 
							onkeyup="valid_password( this.form.newlogin.value)">
			<img src="/cfmx/asp/admin/politicas/global/aceptado.gif" alt="ok" name="img_user_ok" width="13" height="12" id="img_user_ok" longdesc="Usuario aceptado" style="display:none" />
			<img src="/cfmx/asp/admin/politicas/global/rechazado.gif" alt="ok" name="img_user_mal" width="13" height="12" id="img_user_mal" longdesc="Usuario rechazado" />
	</td>
    </tr>

  <tr>
    <td>&nbsp;</td>
    <td colspan="2">      <table width="490" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="136" align="right"><input name="rename" type="submit" id="rename" value="Renombrar" disabled="disabled"></td>
        <td width="14">&nbsp;</td>
        <td width="180"><input name="back" type="button" id="back" value="Regresar" onclick="javascript:location.href='index.cfm?b=true&ctaemp='+this.form.ctaemp.value+'&s_login='+escape(this.form.s_login.value)+'&s_nombre='+escape(this.form.s_nombre.value)+'&s_email='+escape(this.form.s_email.value)+'&pageNum_lista='+this.form.pageNum_lista.value;"></td>
        <td width="14">&nbsp;</td>
        </tr>
    </table></td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
</table>


<input type="hidden" name="ctaemp" value="<cfif isdefined("url.ctaemp") and len(trim(url.ctaemp)) >#url.ctaemp#</cfif>" />
<input type="hidden" name="s_login" value="<cfif isdefined("url.s_login") and len(trim(url.s_login)) >#url.s_login#</cfif>" />
<input type="hidden" name="s_nombre" value="<cfif isdefined("url.s_nombre") and len(trim(url.s_nombre)) >#url.s_nombre#</cfif>" />
<input type="hidden" name="s_email" value="<cfif isdefined("url.s_email") and len(trim(url.s_email)) >#url.s_email#</cfif>" />
<input type="hidden" name="pageNum_lista" value="<cfif isdefined("url.pageNum_lista") and len(trim(url.pageNum_lista)) >#url.pageNum_lista#<cfelse>1</cfif>" />


</form>
</cfoutput>

<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta" returnvariable="dataPoliticas" CEcodigo="#url.CEcodigo#"/>
<cfinvoke component="home.Componentes.ValidarPassword" method="javascript" data="#dataPoliticas#"/>
<script type="text/javascript" language="javascript1.2">
	function trim(dato) {
		return dato.replace(/^\s*|\s*$/g,"");
	}

	function obid(s) {
		return document.all ? document.all[s] : document.getElementById(s);
	}
	
	function valid_password(u) {
		var valida = validarPassword(u, '');
		obid('img_user_ok').style.display = !valida.erruser.length ? '' : 'none';
		obid('img_user_mal').style.display = valida.erruser.length ? '' : 'none';
		if(valida.erruser.length==0){
			form1.rename.disabled="";
		}
		else{
			form1.rename.disabled="disabled";
		}
	}	

	function validar(){
		var msj = '';
		
		if ( trim(document.form1.email.value) == '' ){
			msj = msj + ' - El campo E-mail es requerido.\n';
		}

		if ( trim(document.form1.newlogin.value) == '' ){
			msj = msj + ' - El campo Nuevo Login es requerido.';		
		}
		
		if (msj!=''){
			alert('Se presentaron los siguientes errores: \n' + msj);
			return false;
		}
		
		return true;
	}

</script>

<cf_web_portlet_end>
<cf_templatefooter>
