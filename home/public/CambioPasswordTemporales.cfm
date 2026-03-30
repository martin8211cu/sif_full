<cfflush interval="5">

Inicializando Componente se seguridad<br>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

Buscando todos los usuarios temporales<br>

<cfquery name="existe_login" datasource="asp">		
	select p.Pid, u.Usucodigo, p.Pemail1, p.datos_personales, p.Pnombre , p.Papellido1 , p.Papellido2, p.Pemail1, u.Usulogin 
	from Usuario u
		join DatosPersonales p
			on u.datos_personales = p.datos_personales
	where u.CEcodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="2">
	 and u.Usulogin <> 'Usuario.soin'
</cfquery>

<cftransaction>
	<cfoutput>
	<table border="1">
		<tr>
			
			<td>Identificación</td>
			<td>Nombre</td>
			<td>1° Apellido</td>
			<td>2° Apellido</td>
			<td>Login</td>
			<td>Resultado</td>
		</tr>
	<cfloop query="existe_login">
		<cfquery name="NEWLogin" datasource="asp">		
			select p.Pid, u.Usucodigo, u.Usulogin 
			from Usuario u
				inner join DatosPersonales p
					on u.datos_personales = p.datos_personales
			where u.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="41">
			  and Rtrim(p.Pid) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(existe_login.Pid)#">
		</cfquery>
		<tr>
			<td>#existe_login.Pid#</td>
			<td>#existe_login.Pnombre#</td>
			<td>#existe_login.Papellido1#</td>
			<td>#existe_login.Papellido2#</td>
		<cfif NEWLogin.Recordcount GT 1>
			<cfset usuario = sec.renombrarUsuario(NEWLogin.usucodigo, '', '') >
			<td>Mas de un Usuario con la Misma Identificacion '#existe_login.Pid#'</td>
			<td>0</td>
		<cfelseif NEWLogin.Recordcount EQ 0>
			
			<td>Identificación no encontrada en la nueva Vieja '#existe_login.Pid#'</td>
			<td>0</td>
		<cfelseif LEN(TRIM(NEWLogin.Usulogin))>
			<cfset usuario = sec.renombrarUsuario(NEWLogin.usucodigo, NEWLogin.Usulogin, '') >
			<cfquery datasource="asp">	
				update Usuario 
					set Utemporal = 0 
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existe_login.Usucodigo#">
			</cfquery>
			<td>#NEWLogin.Usulogin#</td>
			<td>1</td>
		<cfelse>
			<cfset usuario = sec.renombrarUsuario(NEWLogin.usucodigo, '', '') >
			<td>SIN LOGIN</td>
			<td>0</td>
		</cfif>
		</tr>
	</cfloop>
	</cfoutput>
</cftransaction>