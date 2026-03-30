<cfparam name="action" default="TiposNominaUsuario.cfm">
<cfparam name="modo" default="ALTA">

<cfobject component="rh.Componentes.RH_TiposNominaPermisos" name="oPermisos">

<cfif not isdefined("form.btnNuevo")>
	<cfif isdefined("form.Alta")>
		
		<cfoutput><cfset qResult = oPermisos.Alta(Tcodigo=#form.Tcodigo#,Usucodigo=#form.Usucodigo#)></cfoutput>
	
	<cfelseif isdefined("form.Baja")>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
						<cfinvokeargument  name="nombreTabla" value="TiposNominaPermisos">	
						<cfinvokeargument name="nombreCampo" value="BMUsucodigo">	
						<cfinvokeargument name="condicion" value="Ecodigo = #session.Ecodigo# and rtrim(Tcodigo) ='#Trim(form.Tcodigo)#' and Usucodigo=#form.Usucodigo#">
						<cfinvokeargument name="necesitaTransaccion" value="false">
			</cfinvoke>
		
		<cfset sResult = oPermisos.Baja(Tcodigo=#form.Tcodigo#,Usucodigo=#form.Usucodigo#)>
	
	</cfif>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">

	<input name="especial" type="hidden" value="<cfif isdefined("Form.especial")>#Form.especial#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	<input type="hidden" id="Tcodigo" name="Tcodigo" value="<cfif isdefined("form.Tcodigo") and len(trim(form.Tcodigo)) neq 0><cfoutput>#form.Tcodigo#</cfoutput></cfif>">
	<input type="hidden" id="Tdescripcion" name="Tdescripcion" value="<cfif isdefined("form.Tdescripcion") and len(trim(form.Tdescripcion)) neq 0><cfoutput>#form.Tdescripcion#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>