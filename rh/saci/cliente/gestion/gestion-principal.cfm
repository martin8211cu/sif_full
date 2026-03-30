	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="250" valign="top" style="padding-right: 5px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top">
					<cfinclude template="gestion-arbol.cfm">
				</td>
			  </tr>
			  <tr>
				<td valign="top">
					<cfinclude template="gestion-ayuda.cfm">
				</td>
			  </tr>
			</table>
		</td>
		<td valign="top" width="75%">
				<cfif ExisteLog>
					<cfinclude template="gestion-log.cfm">					<!---Pintado de Login--->
				
				<cfelseif ExistePaquete>
					<cfinclude template="gestion-paquetes.cfm">				<!---Pintado Paquetes--->
					
				<cfelseif ExisteCuenta>
					<cfinclude template="gestion-cuenta.cfm">				<!---Pintado de informacion sobre la cuenta--->
				
				<cfelseif ExisteTrafico>
					<cf_web_portlet_start titulo="Gesti&oacute;n de Servicios">
						<cfinclude template="gestion-trafico.cfm">			<!---Pintado de informacion sobre la pantalla de consultas de trafico--->
					<cf_web_portlet_end> 
				
				<cfelseif ExisteCambioPass>
					<cf_web_portlet_start titulo="Cambio de Passwords">
						<cfinclude template="gestion-cambioPasswords.cfm">	<!---Pintado de informacion sobre el cambio de password--->
					<cf_web_portlet_end> 

				<cfelseif ExisteAddServicio>
					<cf_web_portlet_start titulo="Agregar Servicios">
						<cfinclude template="gestion-servicios.cfm">		<!---Pintado de informacion sobre el cambio de password--->
					<cf_web_portlet_end>

				<cfelseif ExisteInfoServ>
					<cf_web_portlet_start titulo="Informaci&oacute;n de Servicios">
						<cfinclude template="gestion-infoServicios.cfm">		<!---Pintado de informacion sobre los servicios --->
					<cf_web_portlet_end>		
				<cfelseif ExisteRecarga>
					<cf_web_portlet_start titulo="Recarga de Tarjetas de Prepago">
						<cfinclude template="gestion-recarga.cfm">		<!---Pintado de recarga de tarjetas de prepago --->
					<cf_web_portlet_end>		
				<cfelseif ExisteCliente>
					<cfinclude template="gestion-cliente.cfm">				<!---Pintado de informacion del cliente--->
				<cfelse>
					&nbsp;		
				</cfif>
		</td>
	  </tr>
	</table>