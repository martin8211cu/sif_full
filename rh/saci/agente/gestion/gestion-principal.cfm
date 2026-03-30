	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="230" valign="top" style="padding-right: 5px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" width="25%">
					<cf_web_portlet_start titulo="Cuentas">
						<!---<cfinclude template="gestion-arbol.cfm">--->
						<form name="formArbolGest" action="#CurrentPage#" method="get" style="margin: 0;">
							<cfinclude template="gestion-hiddens.cfm">
							<cfset id_cli="">
							<cfset id_cue="">
							<cfset id_contr="">
							<cfset id_cont="">
							<cfset id_log="">
							
							<cfif isdefined("form.cliente") and len(trim(form.cliente))>
								<cfset id_cli=form.cliente>
							</cfif>
							<cfif ExisteCuenta>		<cfset id_cue=form.CTid> 			</cfif>
							<cfif ExistePaquete>	<cfset id_contr=form.Contratoid> 	</cfif>
							<cfif ExisteContacto>	<cfset id_cont=form.Pcontacto> 		</cfif>
							<cfif ExisteLog>		<cfset id_log=form.LGnumero> 		</cfif>
							<cf_gestionArbol
								id_cliente="#id_cli#"
								id_cuenta="#id_cue#"
								id_contrato="#id_contr#"
								id_login="#id_log#"
								id_contacto="#id_cont#"
								trafico="#ExisteTrafico#"
								form="formArbolGest"
							>
							
						</form>
					<cf_web_portlet_end>
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
					<cfinclude template="gestion-log.cfm">	<!---Pintado de Login--->
				
				<cfelseif ExistePaquete>
					<cf_web_portlet_start titulo="Gesti&oacute;n de Servicios">
						<cfinclude template="gestion-paquetes.cfm">	<!---Pintado Paquetes--->
					<cf_web_portlet_end>
				
				<cfelseif ExisteContacto>
					<cf_web_portlet_start titulo="Gesti&oacute;n de Servicios">
						<cfinclude template="gestion-contacto.cfm">	<!---Pintado del contacto--->
					<cf_web_portlet_end>
				
				<cfelseif ExisteCuenta>
					<cf_web_portlet_start titulo="Gesti&oacute;n de Servicios">
						<cfinclude template="gestion-cuenta.cfm">	<!---Pintado de informacion sobre la cuenta--->
					<cf_web_portlet_end>
				
				<cfelseif ExisteTrafico>
					<cf_web_portlet_start titulo="Gesti&oacute;n de Servicios">
						<cfinclude template="gestion-trafico.cfm">	<!---Pintado de informacion sobre la pantalla de consultas de trafico--->
					<cf_web_portlet_end>
				
				<cfelseif ExisteCambioPass>
					<cf_web_portlet_start titulo="Cambio de Passwords">
						<cfinclude template="gestion-cambioPasswords.cfm">	<!---Pintado de informacion sobre el cambio de password--->
					<cf_web_portlet_end>
				</cfif>

		</td>
	  </tr>
	</table>