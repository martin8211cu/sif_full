<!--- Opciones del Menú --->
<!--- Consulta las opciones que van en el menú --->
<cfparam name="session.EcodigoSDC" default="0">
<style type="text/css">
		<!--
		.style77 {font-size: 9px; color: #990000; font-family: Verdana, Arial, Helvetica, sans-serif; }
		-->
</style>
<table border="0" width="100%" cellpadding="2" cellspacing="0" style="width: inherit;" >
	<!--- Pintado de las opciones --->
	<tr>
		<td><div align="center"></div></td>
		<td class="style90"><div align="left"><a href="/" target="_top">Inicio</a></div></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr><td height="1%" colspan="2"><hr align="center" size="1" color="#000000" ></td></tr>
	<tr>
		<td><div align="center"></div></td>
		<td class="style77">
			<div align="left"><a href="/cfmx/hosting/publico/afiliacion/afiliacion.cfm">
			    <cfif IsDefined("session.usucodigo") and session.Usucodigo GT 0>
				    Mis Datos
		          <cfelse>
				    Registrarse
		    </cfif>
		    </a>
	        </div></td>
		<td>&nbsp;</td>
	</tr>
	
	<cfif isdefined("session.MEpersona") and len(trim(session.MEpersona)) gt 0 >
		<tr>
			<td><div align="center"></div></td>
			<td class="style77">
				<div align="left"><a href="/cfmx/hosting/publico/familiares/familiares.cfm">Mis Familiares</a>
	      </div></td>
			<td>&nbsp;</td>
		</tr>

		<tr>
			<td><div align="center"></div></td>
			<td class="style77"><div align="left"><a href="/cfmx/hosting/publico/donacion_registro.cfm" >
		    Donar</a></div></td>
			<td>&nbsp;</td>
		</tr>

		<cfquery datasource="#session.dsn#" name="hay_donaciones">
		select count(1) as cuantas
		from MEDDonacion a, MEPersona c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#" >
		  and a.MEpersona = c.MEpersona
		</cfquery>
		<cfif hay_donaciones.cuantas GT 0>
		<tr>
			<td><div align="center"></div></td>
			<td class="style77">
				<div align="left"><a href="/cfmx/hosting/publico/donacion_listado.cfm" >
				    Mis Donaciones 
					  </a>
		        </div></td>
			<td>&nbsp;</td>
		</tr>
		</cfif>

	</cfif>

	<cfif acceso_uri('/hosting/iglesias/index.cfm')>
		<tr>
			<td><div align="center"></div></td>
			<td class="style77"><div align="left"><a href="/cfmx/hosting/iglesias/index.cfm" >Administracion de Iglesia</a></div></td>
			<td>&nbsp;</td>
		</tr>
	</cfif>

	<cfquery name="rsParametros" datasource="#Session.DSN#">
		select Pvalor
		from MEParametros
		where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>	
	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/tienda/tienda/public/index.cfm?ctid=<cfoutput>#rsParametros.Pvalor#</cfoutput>" >Tienda en Linea</a></td>
		<td width="5%">&nbsp;</td>
	</tr>
	</cfif>
		
	<tr><td height="1%" colspan="2"><hr align="center" size="1" color="#000000" ></td></tr>
	
	<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
		<tr>
			<td><div align="center"></div></td>
			<td class="style77"><div align="left"><a href="/cfmx/home/menu/passch.cfm" target="_top">Cambiar Contrase&ntilde;a</a></div></td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</cfif>

	<tr>
		<td><div align="center"></div></td>
		<td class="style90"><div align="left"><a href="/cfmx/home/public/logout.cfm" >Salir</a></div></td>
		<td>&nbsp;</td>
	</tr>
</table>
