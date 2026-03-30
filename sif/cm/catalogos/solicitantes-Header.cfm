<!--- Pantalla --->
<cfif isdefined("Session.Compras.Solicitantes") and isdefined("Session.Compras.Solicitantes.Pantalla")>
	<cfif Session.Compras.Solicitantes.Pantalla EQ 0>
		<cfset titulo = "Lista de Solicitantes">
		<cfset indicacion = "Seleccione un Solicitante o defina uno nuevo">
		<!---ok--->
	<cfelseif Session.Compras.Solicitantes.Pantalla EQ 1>
		<cfset titulo = "Solicitantes">
		<cfif isdefined("Session.Compras.Solicitantes.CMSid") and len(Session.Compras.Solicitantes.CMSid)><cfset _boton_="Guardar"><cfelse><cfset _boton_="Agregar"></cfif>
		<cfset indicacion = "Realice las modificaciones necesarias y presione #_boton_# o #_boton_# y Continuar >>">
		<!---ok--->
	<cfelseif Session.Compras.Solicitantes.Pantalla EQ 2>
		<cfquery name="rsTipoSolic" datasource="#session.dsn#">
			select CMSnombre
			from CMSolicitantes
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
		</cfquery>
		<cfset titulo = "Centros Funcionales por Solicitante">
		<cfset indicacion = "Solicitante: #rsTipoSolic.CMSnombre#">
		<!---ok--->
	<cfelseif Session.Compras.Solicitantes.Pantalla EQ 3>
		<cfquery name="rsTipoSolic" datasource="#session.dsn#">
			select CMSnombre
			from CMSolicitantes
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Solicitantes.CMSid#">
		</cfquery>
		<cfset titulo = "Especialización de Solicitante">
		<cfset indicacion = "Solicitante: #rsTipoSolic.CMSnombre#">
		<!---ok--->
	</cfif>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
			<td width="1%" align="right">
				<cfif isdefined("Session.Compras.Solicitantes") and isdefined("Session.Compras.Solicitantes.Pantalla") and Len(Trim(Session.Compras.Solicitantes.Pantalla)) and (Session.Compras.Solicitantes.Pantalla EQ "0" or Session.Compras.Solicitantes.Pantalla GT "3")>
					&nbsp;
				<cfelseif isdefined("Session.Compras.Solicitantes") and isdefined("Session.Compras.Solicitantes.Pantalla") and Len(Trim(Session.Compras.Solicitantes.Pantalla))>
					<img border="0" src="/cfmx/sif/imagenes/number#Session.Compras.Solicitantes.Pantalla#_64.gif" align="absmiddle">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<tr>
						<td class="tituloPersona" align="left" style="text-align:left" nowrap>#indicacion#</td>
					</tr>
				</table>
			</td>
	  </tr>
	</table>
</cfoutput>