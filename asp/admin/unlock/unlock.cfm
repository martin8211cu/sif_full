
<cfparam name="url.Usucodigo" type="numeric">
<cfparam name="url.CEcodigo" type="numeric" default="0">
<cfparam name="url.msg" default="">
<cfif url.Usucodigo is 1>
	<!--- proteger a pso --->
	<cflocation url="index.cfm">
</cfif>

<cf_templateheader title="Desbloquear Usuario"><cf_web_portlet_start titulo="Desbloquear Usuario">
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
<cfif usuario.recordcount eq 0 >
	<cfquery datasource="asp" name="usuario">
        select c.CEcodigo, c.CEnombre, c.CEaliaslogin,
            u.Usucodigo, u.Usulogin, p.Pnombre, p.Papellido1, p.Papellido2,
            p.Pemail1,
            u.Uestado,
            0 as AllowedAccess, '#lsdateformat(now(),"yyyymmdd")#' as PasswordSet
        from Usuario u
            join DatosPersonales p
                on u.datos_personales = p.datos_personales
            join CuentaEmpresarial c
                on c.CEcodigo = u.CEcodigo
        where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
          and u.Usucodigo != 1 <!--- proteger a pso --->
	</cfquery>
	
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

<!---
<cfset sesion_bloqueo_cant      = Politicas.trae_parametro_global("sesion.bloqueo.cant")>
<cfset sesion_bloqueo_duracion  = Politicas.trae_parametro_global("sesion.bloqueo.duracion")>
<cfset sesion_bloqueo_periodo   = Politicas.trae_parametro_global("sesion.bloqueo.periodo")>
--->

<cfoutput>
<form name="form1" id="form1" method="post" action="unlock-sql.cfm">
<input type="hidden" name="Usucodigo" value="#usuario.Usucodigo#">
<input type="hidden" name="CEcodigo" value="#usuario.CEcodigo#">
<table width="636" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="55">&nbsp;</td>
    <td width="138">&nbsp;</td>
    <td width="386">&nbsp;</td>
    <td width="57">&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" class="subTitulo">Desbloqueo de usuarios </td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2"><em>&iquest;Qu&eacute; quiere hacer con este usuario? </em></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2" valign="top"><div style="background-color:##009900;color:white;font-weight:bold">#HTMLEditFormat(url.msg)#</div></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Cuenta Empresarial </td>
    <td valign="top">#HTMLEditFormat(usuario.CEnombre)#</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Alias</td>
    <td valign="top">#HTMLEditFormat(usuario.CEaliaslogin)#</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Login</td>
    <td valign="top">#HTMLEditFormat(Trim (usuario.Usulogin) )#</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Nombre</td>
    <td valign="top">
		#HTMLEditFormat(usuario.Pnombre)#
		#HTMLEditFormat(usuario.Papellido1)#
		#HTMLEditFormat(usuario.Papellido2)#
	</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">E-mail</td>
    <td valign="top"><input type="text" value="#HTMLEditFormat(Trim (usuario.Pemail1) )#" name="email" id="email"></td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Estado</td>
    <td valign="top"><cfif usuario.Uestado>Activo<cfelse>Inactivo</cfif></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Acceso</td>
    <td valign="top"><cfif usuario.AllowedAccess>Permitido<cfelse>Bloqueado</cfif></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">&Uacute;ltimo cambio de contrase&ntilde;a</td>
    <td valign="top">#usuario.PasswordSet#</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td valign="top">Pol&iacute;tica de bloqueos</td>
    <td valign="top">
	
	Si falla el login #sesion_bloqueo_cant#  veces, el usuario
		<cfif sesion_bloqueo_duracion >
  
 			se bloquea por <cfif sesion_bloqueo_duracion is 0>#sesion_bloqueo_periodo#<cfelse>#sesion_bloqueo_duracion#</cfif>
            minutos.
		<cfelse>
           requerir&aacute; reactivaci&oacute;n.
	    </cfif><br>
		Borrar contador despu&eacute;s de 
		    #sesion_bloqueo_periodo# minutos.
		
		</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="2">      <table width="490" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td width="136"><input name="lock" type="submit" id="lock" value="Bloquear"></td>
          <td width="160"><input name="unlock" type="submit" id="unlock" value="Desbloquear"></td>
          <td width="180"><input name="send" type="submit" id="send" value="Enviar contraseña por correo"></td>
          <td width="14">&nbsp;</td>
        </tr>
      </table></td>
    <td>&nbsp;</td>
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
</form>
</cfoutput>
	<cfif bloqueos.RecordCount>
	<div class="subTitulo tituloListas"><strong>Bloqueos</strong></div>

	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		query="#bloqueos#"
		desplegar="fecha,bloqueo,razon,desbloq"
		etiquetas="Fecha,Bloqueado Hasta,Raz&oacute;n,Desbloqueado"
		formatos="V, V, V, V"
		align="left, left, left, left"
		ajustar="N"
		Nuevo=""
		form_method="get"
		irA="javascript:void(0)"
		showEmptyListMsg="true"
		keys="">
	</cfinvoke>	</cfif>

	<cfif login_incorrecto.RecordCount>
	<div class="subTitulo tituloListas"><strong>Login incorrecto</strong></div>
	
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		query="#login_incorrecto#"
		desplegar="LIcuando, LIip, LIalias, LIlogin, LIrazon, LIcontador, LIbloqueo"
		etiquetas="Fecha,Direccion IP,cuenta,login,Raz&oacute;n,Contador,Bloqueado"
		formatos="V,V,V,V,V,V,V"
		align="left,left,left,left,left,left,left"
		ajustar="N"
		Nuevo=""
		form_method="get"
		irA="javascript:void(0)"
		showEmptyListMsg="true"
		keys="">
	</cfinvoke>
	</cfif>

<cf_web_portlet_end>
<cf_templatefooter>
