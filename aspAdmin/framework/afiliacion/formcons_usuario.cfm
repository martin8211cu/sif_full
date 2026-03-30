<cfset campos = "">
<cfset tabla = "">
<cfset filtro = "">
<cfset extra = "">
<cfset navegacion = "">

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.ap1") and not isdefined("Form.ap1")>
	<cfparam name="Form.ap1" default="#Url.ap1#" type="string">
</cfif>
<cfif isdefined("Url.ap2") and not isdefined("Form.ap2")>
	<cfparam name="Form.ap2" default="#Url.ap2#" type="string">
</cfif>
<cfif isdefined("Url.lg1") and not isdefined("Form.lg1")>
	<cfparam name="Form.lg1" default="#Url.lg1#" type="string">
</cfif>
<cfif isdefined("Url.lg2") and not isdefined("Form.lg2")>
	<cfparam name="Form.lg2" default="#Url.lg2#" type="string">
</cfif>
<cfif isdefined("Url.rol") and not isdefined("Form.rol")>
	<cfparam name="Form.rol" default="#Url.rol#" type="string">
</cfif>
<cfif isdefined("Url.filtrar") and not isdefined("Form.filtrar")>
	<cfparam name="Form.filtrar" default="#Url.filtrar#" type="string">
</cfif>

<cfif isdefined("Form.ap1")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ap1=" & Form.ap1>
</cfif>
<cfif isdefined("Form.ap2")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ap2=" & Form.ap2>
</cfif>
<cfif isdefined("Form.lg1")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "lg1=" & Form.lg1>
</cfif>
<cfif isdefined("Form.lg2")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "lg2=" & Form.lg2>
</cfif>
<cfif isdefined("Form.rol")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "rol=" & Form.rol>
</cfif>
<cfif isdefined("Form.filtrar")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrar=" & Form.filtrar>
</cfif>

<cfif isDefined("Form.ap2") and len(trim(Form.ap2))>
	<cfset Form.ap2 = Mid(Form.ap2,1,Len(Form.ap2)-1) & Chr(Asc(Right(Form.ap2,1))+1)>
</cfif>
<cfif isDefined("Form.lg2") and len(trim(Form.lg2))>
	<cfset Form.lg2 = Mid(Form.lg2,1,Len(Form.lg2)-1) & Chr(Asc(Right(Form.lg2,1))+1)>
</cfif>
<cfset inroles="">
<cfset aux = "">
<cfif isDefined("Form.rol")>
	<cfset roles=ListToArray(Form.rol)>
	<cfloop index="rol" from="1" to="#ArrayLen(roles)#">
		<cfif len(trim(roles[rol]))>
			<cfset inroles = inroles & aux & "'" & roles[rol] & "'">
			<cfset aux = ",">
		</cfif>
	</cfloop>
</cfif>

<cfinclude template="../portlets/pQuienSoy.cfm">

<cfif Session.secfw.soy_pso>
	<!--- Query para obtener el rol de agente,
		solamente si soy pso --->
	<cfset campos = "' Roles Personales' as nombre_cuenta_empresarial, null as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		u.Pnombre, u.Papellido1, u.Papellido2, u.Papellido1 + ' ' + u.Papellido2 as Papellidos, u.Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy pso',
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset tabla = "Rol r, UsuarioPermiso up, Usuario u">
	<cfset filtro = filtro & "r.empresarial = 0
		and r.interno = 1
		and r.activo = 1
		and r.rol = 'sys.agente'">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset filtro = filtro & " and r.rol in (" & inroles & ")">
	</cfif>
	<cfset filtro = filtro & " and up.rol = r.rol
		and up.activo = 1
		and u.activo = 1
		and u.Usucodigo = up.Usucodigo
		and u.Ulocalizacion = up.Ulocalizacion">
	<cfif len(trim(Form.ap1))>
		<cfset filtro = filtro & " and upper(u.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(Form.ap2))>
		<cfset filtro = filtro & " and upper(u.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(Form.lg1))>
		<cfset filtro = filtro & " and upper(u.Usulogin) >= upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(Form.lg2))>
		<cfset filtro = filtro & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>
  
	<cfset extra = extra & " union">
	<!--- Query para obtener los roles de TODOS los usuarios,
		porque pso es agente de todos --->
	<cfset extra = extra & " select ' Roles Personales' as nombre_cuenta_empresarial, null as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		u.Pnombre, u.Papellido1, u.Papellido2, u.Papellido1 + ' ' + u.Papellido2 as Papellidos, u.Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy pso, vale como agente de ' + u.Usulogin,
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset extra = extra & " from Usuario u, UsuarioPermiso up, Rol r">
	<cfset extra = extra & " 
		where u.activo = 1
		  and up.Usucodigo = u.Usucodigo
		  and up.Ulocalizacion = u.Ulocalizacion
		  and up.activo = 1
		  and u.activo = 1
		  and r.rol = up.rol">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset extra = extra & " and r.rol in (" & inroles& ")">
	</cfif>
	<!--- and r.interno = 0 --->
	<cfset extra = extra & " and r.empresarial = 0
		and r.activo = 1">
	<cfif len(trim(ap1))>
		<cfset extra = extra & " and upper(u.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(ap2))>
		<cfset extra = extra & " and upper(u.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(lg1))>
		<cfset extra = extra & " and upper(u.Usulogin) >= upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(lg2))>
		<cfset extra = extra & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>

	<cfset extra = extra & " union">
	<cfset extra = extra & " select cce.nombre as nombre_cuenta_empresarial, e.nombre_comercial as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		ue.Pnombre, ue.Papellido1, ue.Papellido2, ue.Papellido1 + ' ' + ue.Papellido2 as Papellidos, isnull(u.Pemail1,ue.Pemail1)as Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy pso, vale como admin de ' + cce.nombre,
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset extra = extra & " from CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Usuario u, Empresa e">
	<cfset extra = extra & " 
		where cce.activo = 1
		and e.Ecodigo = up.Ecodigo
		and e.activo = 1
		and ue.cliente_empresarial = cce.cliente_empresarial
		and ue.activo = 1
		and ue2.Usucodigo = ue.Usucodigo
		and ue2.Ulocalizacion = ue.Ulocalizacion
		and ue2.cliente_empresarial = ue.cliente_empresarial
		and ue2.activo = 1
		and up.Usucodigo = ue.Usucodigo
		and up.Ulocalizacion = ue.Ulocalizacion
		and up.Ulocalizacion = ue2.Ulocalizacion
		and up.cliente_empresarial = ue2.cliente_empresarial
		and up.activo = 1
		and u.Usucodigo = ue.Usucodigo
		and u.Ulocalizacion = ue.Ulocalizacion
		and u.activo = 1
		and r.rol = up.rol">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset extra = extra & " and r.rol in (" & inroles& ")">
	</cfif>
	<cfset extra = extra & " 
		and r.empresarial = 1
		and r.interno = 0
		and r.activo = 1">
	<cfif len(trim(ap1))>
		<cfset extra = extra & " and upper(ue.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(ap2))>
		<cfset extra = extra & " and upper(ue.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(lg1))>
		<cfset extra = extra & " and upper(u.Usulogin) >= upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(lg2))>
		<cfset extra = extra & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>
</cfif>

<cfif Session.secfw.soy_agente and not Session.secfw.soy_pso>
	<!--- Query para obtener los roles personales de mis usuarios,
		solamente si soy agente
		si soy pso no aplica porque en el query de arriba ya estan
		incluidos
		--->
	<cfset campos = "' Roles Personales' as nombre_cuenta_empresarial, null as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		u.Pnombre, u.Papellido1, u.Papellido2, u.Papellido1 + ' ' + u.Papellido2 as Papellidos, u.Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy agente de ' + u.Usulogin,
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset tabla = "Usuario u, UsuarioPermiso up, Rol r">
	<cfset filtro = filtro & "u.agente = " & Session.Usucodigo & " 
		and u.agente_loc = '" & Session.Ulocalizacion & "' 
		and u.activo = 1
		and up.Usucodigo = u.Usucodigo
		and up.Ulocalizacion = u.Ulocalizacion
		and up.activo = 1
		and u.activo = 1
		and r.rol = up.rol">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset filtro = filtro & " and r.rol in (" & inroles & ")">
	</cfif>
	<cfset filtro = filtro & " 
		and r.empresarial = 0
		and r.interno = 0
		and r.activo = 1">
	<cfif len(trim(ap1))>
	  <cfset filtro = filtro & " and upper(u.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(ap2))>
	  <cfset filtro = filtro & " and upper(u.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(lg1))>
	  <cfset filtro = filtro & " and upper(u.Usulogin) >= ? upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(lg2))>
	  <cfset filtro = filtro & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>
	  
	<cfset extra = extra & " union">
	
	<!--- Query para obtener los roles de los usuarios 
	de las empresas que yo administre --->
	<cfset extra = extra & " select cce.nombre as nombre_cuenta_empresarial, e.nombre_comercial as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		ue.Pnombre, ue.Papellido1, ue.Papellido2, ue.Papellido1 + ' ' + ue.Papellido2 as Papellidos, isnull(u.Pemail1,ue.Pemail1)as Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy admin de ' + cce.nombre,
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset extra = extra & " from UsuarioEmpresarial yo, CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Usuario u, Empresa e
		where yo.Usucodigo = " & Session.Usucodigo & " 
		  and yo.Ulocalizacion = '" & Session.Ulocalizacion & "' 
		  and yo.activo = 1
		  and yo.admin = 1
		  and e.Ecodigo = up.Ecodigo
		  and e.activo = 1
		  and cce.activo = 1
		  and cce.cliente_empresarial = yo.cliente_empresarial
		  and ue.cliente_empresarial = cce.cliente_empresarial
		  and ue.activo = 1
		  and ue2.Usucodigo = ue.Usucodigo
		  and ue2.Ulocalizacion = ue.Ulocalizacion
		  and ue2.cliente_empresarial = ue.cliente_empresarial
		  and ue2.activo = 1
		  and up.Usucodigo = ue.Usucodigo
		  and up.Ulocalizacion = ue.Ulocalizacion
		  and up.Ulocalizacion = ue2.Ulocalizacion
		  and up.cliente_empresarial = ue2.cliente_empresarial
		  and up.activo = 1
		  and u.Usucodigo = ue.Usucodigo
		  and u.Ulocalizacion = ue.Ulocalizacion
		  and u.activo = 1
		  and r.rol = up.rol">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset extra = extra & " and r.rol in (" & inroles & ")">
	</cfif>
	<cfset extra = extra & " and r.empresarial = 1
	  and r.interno = 0
	  and r.activo = 1">
	<cfif len(trim(ap1))>
	  <cfset extra = extra & " and upper(ue.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(ap2))>
	  <cfset extra = extra & " and upper(ue.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(lg1))>
	  <cfset extra = extra & " and upper(u.Usulogin) >= upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(lg2))>
	  <cfset extra = extra & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>
</cfif>

<cfif not Session.secfw.soy_agente and not Session.secfw.soy_pso>
	<!--- Query para obtener los roles de los usuarios 
		de las empresas que yo administre --->
	<cfset campos = "cce.nombre as nombre_cuenta_empresarial, e.nombre_comercial as nombre_empresa, r.rol, r.nombre as nombre_rol, up.id, u.Usulogin,
		ue.Pnombre, ue.Papellido1, ue.Papellido2, ue.Papellido1 + ' ' + ue.Papellido2 as Papellidos, isnull(u.Pemail1,ue.Pemail1)as Pemail1, u.Usutemporal, up.num_impreso, up.num_recibido, up.num_enviada,
		porque = 'soy admin de ' + cce.nombre,
		estado = case
			when u.Usutemporal = 0 then 'activo'
			when up.num_enviada <> 0 then 'Contraseña enviada'
			when up.num_recibido <> 0 then 'Respuesta recibida'
			when up.num_impreso <> 0 then 'Carta Impresa'
			else 'Sin afiliar'
		end
		">
	<cfset tabla = "UsuarioEmpresarial yo, CuentaClienteEmpresarial cce, UsuarioEmpresarial ue, UsuarioEmpresa ue2, UsuarioPermiso up, Rol r, Usuario u, Empresa e">
	<cfset filtro = filtro & "yo.Usucodigo = " & Session.Usucodigo & " 
	  and yo.Ulocalizacion = '" & Session.Ulocalizacion & "'
	  and yo.activo = 1
	  and yo.admin = 1
	  and e.Ecodigo = up.Ecodigo
	  and e.activo = 1
	  and cce.activo = 1
	  and cce.cliente_empresarial = yo.cliente_empresarial
	  and ue.cliente_empresarial = cce.cliente_empresarial
	  and ue.activo = 1
	  and ue2.Usucodigo = ue.Usucodigo
	  and ue2.Ulocalizacion = ue.Ulocalizacion
	  and ue2.cliente_empresarial = ue.cliente_empresarial
	  and ue2.activo = 1
	  and up.Usucodigo = ue.Usucodigo
	  and up.Ulocalizacion = ue.Ulocalizacion
	  and up.Ulocalizacion = ue2.Ulocalizacion
	  and up.cliente_empresarial = ue2.cliente_empresarial
	  and up.activo = 1
	  and u.Usucodigo = ue.Usucodigo
	  and u.Ulocalizacion = ue.Ulocalizacion
	  and u.activo = 1
	  and r.rol = up.rol">
	<cfif isDefined("roles") and ArrayLen(roles)>
		<cfset filtro = filtro & " and r.rol in (" & inroles & ")">
	</cfif>
	<cfset filtro = filtro & " and r.empresarial = 1
	  and r.interno = 0
	  and r.activo = 1">
	<cfif len(trim(ap1))>
	  <cfset filtro = filtro & " and upper(ue.Papellido1) >= upper('" & Form.ap1 & "')">
	</cfif>
	<cfif len(trim(ap2))>
	  <cfset filtro = filtro & " and upper(ue.Papellido1) <= upper('" & Form.ap2 & "')">
	</cfif>
	<cfif len(trim(lg1))>
	  <cfset filtro = filtro & " and upper(u.Usulogin) >= upper('" & Form.lg1 & "')">
	</cfif>
	<cfif len(trim(lg2))>
	  <cfset filtro = filtro & " and upper(u.Usulogin) <= upper('" & Form.lg2 & "')">
	</cfif>
</cfif>	  
  
<cfset extra = extra & " order by 1,4,7,6">

<!--- <cfoutput>
select #campos#
from #tabla#
where #filtro# #extra#
</cfoutput> --->

<cfinvoke 
 component="sif.Componentes.pListas"
 method="pLista"
 returnvariable="pListaRet">
	<cfinvokeargument name="tabla" value="#tabla#"/>
	<cfinvokeargument name="columnas" value="#campos#"/>
	<cfinvokeargument name="desplegar" value="Pnombre, Papellidos, Pemail1, nombre_empresa, id, Usulogin, estado"/>
	<cfinvokeargument name="etiquetas" value="Nombre, Apellidos, Correo, Empresa, Contrato, Login, Estado"/>
	<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
	<cfinvokeargument name="filtro" value="#filtro# #extra#"/>
	<cfinvokeargument name="align" value="left, left, left, left, left, left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value=""/>
	<cfinvokeargument name="cortes" value="nombre_cuenta_empresarial, nombre_rol"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="showLink" value="false"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>
