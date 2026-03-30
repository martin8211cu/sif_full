<cfparam name="url.msg" default="">
<!---<cfif url.Usucodigo is 1>
	<!--- proteger a pso --->
	<cflocation url="index.cfm">
</cfif>
--->
<cf_templateheader title="Detalle de ingreso de Usuarios"><cf_web_portlet_start titulo="Detalle de Ingreso de Usuarios">
<cfinclude template="/home/menu/pNavegacion.cfm">

<!---<cfquery datasource="asp" name="usuario">
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
</cfif>--->

<cfquery datasource="minisif" name="bloqueos" maxrows="100">
	select c.Pid,c.Pnombre,c.Papellido1,c.Papellido2,a.bloqueo, a.fecha, a.razon, case when a.desbloqueado = 1 then 'Si' else 'No' end as desbloq
	from UsuarioBloqueo a
    	inner join Usuario b
        on b.Usucodigo = a.Usucodigo
        inner join DatosPersonales c
        on c.datos_personales = b.datos_personales
	where <!---Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Usucodigo#">
    and---> a.Usucodigo != 1 <!--- proteger a pso --->
	order by c.Pid,c.Pnombre,c.Papellido1,c.Papellido2,a.bloqueo desc
</cfquery>

<cfquery datasource="aspmonitor" name="login_incorrecto" maxrows="100">
	select c.Pid,c.Pnombre,c.Papellido1,c.Papellido2,a.LIcuando, a.LIip, a.LIalias, a.LIlogin, a.LIrazon, a.LIcontador, a.LIbloqueo
	from LoginIncorrecto a
    	inner join Usuario b
        on b.Usucodigo = a.Usucodigo
        inner join DatosPersonales c
        on c.datos_personales = b.datos_personales
	where<!--- Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric"   value="#url.Usucodigo#">
	  and---> a.LIcontador is not null
      and a.Usucodigo != 1 <!--- proteger a pso --->
	order by c.Pid,c.Pnombre,c.Papellido1,c.Papellido2,LIcuando desc
</cfquery>

<!---<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>

<cfset sesion_bloqueo_cant = Politicas.trae_parametro_cuenta("sesion.bloqueo.cant","#url.CEcodigo#")>
<cfset sesion_bloqueo_duracion = Politicas.trae_parametro_cuenta("sesion.bloqueo.duracion","#url.CEcodigo#")>
<cfset sesion_bloqueo_periodo = Politicas.trae_parametro_cuenta("sesion.bloqueo.periodo","#url.CEcodigo#")>--->


	<cfif bloqueos.RecordCount>
	<div class="subTitulo tituloListas"><strong>Bloqueos</strong></div>
	<cfinvoke 
		component="sif.Componentes.pListas"
		method="pListaQuery"
		query="#bloqueos#"
		desplegar="Pid,Pnombre,Papellido1,Papellido2,fecha,bloqueo,razon,desbloq"
		etiquetas="Id,Nombre,Apellido1,Apellido2,Fecha,Bloqueado Hasta,Raz&oacute;n,Desbloqueado"
		formatos="V, V, V, V, V, V, V, V"
		align="left, left, left, left, left, left, left, left"
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
		desplegar="Pid,Pnombre,Papellido1,Papellido2,LIcuando, LIip, LIalias, LIlogin, LIrazon, LIcontador, LIbloqueo"
		etiquetas="Id,Nombre,Apellido 1,Apellido 2,Fecha,Direccion IP,cuenta,login,Raz&oacute;n,Contador,Bloqueado"
		formatos="V,V,V,V,V,V,V,V,V,V,V"
		align="left,left,left,left,left,left,left,left,left,left,left"
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
