<!--- Opciones del Menú --->
<!--- Consulta las opciones que van en el menú --->
<cfif isdefined("session.Usucodigo") and isdefined("session.EcodigoSDC")> <!--- Usucodigo --->
<style type="text/css">
		<!--
		.style77 {font-size: 12px; color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; }
		-->
</style>
<table border="0" width="100%" cellpadding="2" cellspacing="0" style="width: inherit;" >
	<!--- Pintado de las opciones --->
	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/iglesias/index.cfm">Inicio</a></td>
		<td width="5%">&nbsp;</td>
	</tr>
	
	<tr><td height="1%" colspan="2"><hr color="#000000" size="1" ></td></tr>

	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/iglesias/Parametros.cfm" >Par&aacute;metros Generales</a></td>
		<td width="5%">&nbsp;</td>
	</tr>

	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/iglesias/afiliacion/afiliacion.cfm" >Registro de Feligreses</a></td>
		<td width="5%">&nbsp;</td>
	</tr>

	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/iglesias/actividades/actividades.cfm" >Actividades y Eventos</a></td>
		<td width="5%">&nbsp;</td>
	</tr>

	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/iglesias/donacion.cfm" >Donaciones</a></td>
		<td width="5%">&nbsp;</td>
	</tr>

	<cfquery name="rsParametros" datasource="#Session.DSN#">
		select Pvalor
		from MEParametros
		where Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="40">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif rsParametros.RecordCount gt 0 and len(trim(rsParametros.Pvalor)) gt 0>
		<cfquery name="rsCheckUser" datasource="asp">
			select e.Ecodigo
			from vUsuarioProcesos vup, Empresa e
			where e.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParametros.Pvalor#">
			and vup.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			and vup.SScodigo = 'TIENDA'
			and vup.Ecodigo = e.Ecodigo
		</cfquery>
		<cfif rsCheckUser.RecordCount gt 0>
		<tr>
			<td width="5%">&nbsp;</td>
			<td class="style77"><a href="/cfmx/home/menu/empresa.cfm?seleccionar_EcodigoSDC=<cfoutput>#rsCheckUser.Ecodigo#</cfoutput>" >Administraci&oacute;n de la Tienda</a></td>
			<td width="5%">&nbsp;</td>
		</tr>
		</cfif>
	</cfif>
	
	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/hosting/publico/index.cfm" >Mi Iglesia<br><font color="#000099"><cfoutput>#Session.Iglesia_a_la_que_asisto#</cfoutput></font></a></td>
		<td width="5%">&nbsp;</td>
	</tr>

	<tr><td height="1%" colspan="2"><hr color="#000000" size="1" ></td></tr>
	
	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/home/menu/passch.cfm">Cambiar Contrase&ntilde;a</a></td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td class="style77"><a href="/cfmx/home/public/logout.cfm" >Salir</a></td>
		<td width="5%">&nbsp;</td>
	</tr>
</table>
</cfif> <!--- Usucodigo --->