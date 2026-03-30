<!--- Opciones del Menú --->
<!--- Consulta las opciones que van en el menú --->
<cfparam name="session.EcodigoSDC" default="0">
<div align="center"><img src="imagenes/left_top.jpg" alt="" width="198" height="16" border="0"></div>
<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
	<a href="/">Inicio</a>
</p>
<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
	<a href="/cfmx/hosting/publico/afiliacion/afiliacion.cfm">
	<cfif IsDefined("session.usucodigo") and session.Usucodigo GT 0>
		Mis Datos
	  <cfelse>
		Subscribirse
	</cfif>
	</a>
</p>
<cfif isdefined("session.MEpersona") and len(trim(session.MEpersona)) gt 0 >
	<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
		<a href="/cfmx/hosting/publico/familiares/familiares.cfm">Mis Familiares</a>
	</p>
	<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
		<a href="/cfmx/hosting/publico/donacion_registro.cfm" >
		Donar</a>
	</p>
	<cfquery datasource="#session.dsn#" name="hay_donaciones">
		select count(1) as cuantas
		from MEDDonacion a, MEPersona c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#" >
		  and a.MEpersona = c.MEpersona
	</cfquery>
	<cfif hay_donaciones.cuantas GT 0>
		<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
			<a href="/cfmx/hosting/publico/donacion_listado.cfm" >
				Mis Donaciones</a>
		</p>
	</cfif>
</cfif>
<cfif acceso_uri('/hosting/iglesias/index.cfm')>
	<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
		<a href="/cfmx/hosting/iglesias/index.cfm" >Administracion de Iglesia</a>
	</p>
</cfif>
<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from MEParametros
	where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>	
	<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
		<a href="/cfmx/tienda/tienda/public/index.cfm?ctid=<cfoutput>#rsParametros.Pvalor#</cfoutput>" >Tienda en L&iacute;nea</a>
	</p>
</cfif>
<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
	<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
		<a href="/cfmx/home/menu/passch.cfm">Cambiar Contrase&ntilde;a</a>
	</p>
</cfif>
<p class="left"><img src="imagenes/e_punct_w.gif" width="5" height="5" alt="" border="0" align="absmiddle">
	<a href="/cfmx/home/public/logout.cfm">Salir</a>
</p>