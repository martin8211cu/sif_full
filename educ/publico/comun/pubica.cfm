<cfif Not IsDefined("request.PORTLET_PUBICA1")>
	<cfset request.PORTLET_PUBICA1=1>
	<cfoutput>
	<cfparam name="LvarPubicaClass" default="left">

<table width="100%" class="#LvarPubicaClass#" cellpadding="0" cellspacing="0" border="0" align="center" style="font-weight: normal; font-size:11">
<tr><td nowrap>
	<strong>Bienvenido</strong>.<BR>
	<cfset LvarConectado=false>
	<cfif isdefined("Session.Usucodigo") and Len(trim(Session.Usucodigo)) GT 0>
		<cfquery name="rsNombre" datasource="asp">
			select distinct c.CEnombre as cliente,
					d.Pnombre || rtrim(' ' || d.Papellido1 || rtrim(' ' || d.Papellido2)) as nombre 
			from Usuario u, DatosPersonales d, CuentaEmpresarial c
			where u.Usucodigo = #Session.Usucodigo#
			  and u.CEcodigo = c.CEcodigo
			  and u.datos_personales = d.datos_personales
		</cfquery>
		
		
		<cfset meses="Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre">
		
		<cfif rsNombre.recordCount EQ 1>
			<cfset LvarConectado=true>
			<a href="/cfmx/home/menu/micuenta/" title="Ir a configuraci&oacute;n personal" >#rsNombre.nombre#</a><BR>
			<a href="/cfmx/home/public/logout.cfm" title="Desconectar mi usuario para liberar la sesión" >Desconectarme</a><BR>
		</cfif>
	</cfif>
	<cfif NOT LvarConectado>
		Ha entrado a nuestra Universidad<br>
            como invitado. <a href="/cfmx/home/menu/index.cfm" title="Firmarse como usuario del sistema y utilizar las opciones a las que tiene permiso el usuario"><font color="##003366">Ingrese 
            su usuario</font></a><BR>
		para ofrecerle más servicios.
	</cfif>
</td>
<td>&nbsp;&nbsp;</td>
</tr></table>
</cfoutput>
</cfif>		
