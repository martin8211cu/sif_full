<!--- Pantalla --->
<cfif isdefined("Session.Compras.Configuracion") and isdefined("Session.Compras.Configuracion.Pantalla")>
	<cfif Session.Compras.Configuracion.Pantalla EQ 0>
		<cfset titulo = "Lista de Tipos de Solicitud">
		<cfset indicacion = "Seleccione un Tipo de Solicitud o defina uno nuevo">
		<!---ok--->
	<cfelseif Session.Compras.Configuracion.Pantalla EQ 1>
		<cfset titulo = "Tipos de Solicitud">
		<cfif isdefined("Session.Compras.Configuracion.CMTScodigo") and len(Session.Compras.Configuracion.CMTScodigo)><cfset _boton_="Guardar"><cfelse><cfset _boton_="Agregar"></cfif>
		<cfset indicacion = "Realice las modificaciones necesarias y presione #_boton_# o #_boton_# y Continuar >>">
		<!---ok--->
	<cfelseif Session.Compras.Configuracion.Pantalla EQ 2>
		<cfquery name="rsTipoSolic" datasource="#session.dsn#">
			select CMTSdescripcion
			from CMTiposSolicitud
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CMTScodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
		</cfquery>
		<cfset titulo = "Centros Funcionales por Tipo de Solicitud">
		<cfset indicacion = "#rsTipoSolic.CMTSdescripcion#">
		<!---ok--->
	<cfelseif Session.Compras.Configuracion.Pantalla EQ 3>
		<cfquery name="rsTipoSolic" datasource="#session.dsn#">
			select b.CMTSdescripcion, c.CFdescripcion
			from CMTSolicitudCF a
			inner join CMTiposSolicitud b
				on b.Ecodigo = a.Ecodigo
				and b.CMTScodigo = a.CMTScodigo
			inner join CFuncional c
				on c.Ecodigo = a.Ecodigo
				and c.CFid = a.CFid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.CMTScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Compras.Configuracion.CMTScodigo#">
				and a.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.Configuracion.CFpk#">
		</cfquery>
		<cfset titulo = "Especialización de Tipos de Solicitud / Centro Funcional">
		<cfset indicacion = "#rsTipoSolic.CMTSdescripcion# - #rsTipoSolic.CFdescripcion#">
		<!---ok--->
	</cfif>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
			<td width="1%" align="right">
				<cfif isdefined("Session.Compras.Configuracion") and isdefined("Session.Compras.Configuracion.Pantalla") and Len(Trim(Session.Compras.Configuracion.Pantalla)) and (Session.Compras.Configuracion.Pantalla EQ "0" or Session.Compras.Configuracion.Pantalla GT "3")>
					&nbsp;
				<cfelseif isdefined("Session.Compras.Configuracion") and isdefined("Session.Compras.Configuracion.Pantalla") and Len(Trim(Session.Compras.Configuracion.Pantalla))>
					<img border="0" src="/cfmx/sif/imagenes/number#Session.Compras.Configuracion.Pantalla#_64.gif" align="absmiddle">
				<cfelse>
					&nbsp;
				</cfif>
			</td>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>					
					<td style="border-bottom: 1px solid black " nowrap>
					<strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<tr>
						<td class="tituloPersona" align="left" style="text-align:left" nowrap>#indicacion#</td>
					</tr>
				</table>
			</td>
	  </tr>
	</table>
</cfoutput>