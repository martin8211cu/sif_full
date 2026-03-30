<!-- MODO Encabezado de Formatos -->
<!---
<cfif isdefined("form.CAMBIO")>
	<cfset ef_modo = "CAMBIO">
<cfelse>
	<cfif not isdefined("form.ef_modo")>
		<cfset ef_modo="ALTA">
	<cfelseif form.ef_modo EQ "CAMBIO">
		<cfset ef_modo="CAMBIO">
	<cfelse>
		<cfset ef_modo="ALTA">
	</cfif>
</cfif>--->

<cfif isdefined("form.CAMBIO")>
	<cfset ef_modo = "CAMBIO">
<cfelse>
	<cfif isdefined("url.ef_modo") and not isdefined("form.ef_modo")>
		<cfset ef_modo="CAMBIO">
	<cfelseif not isdefined("form.ef_modo")>
		<cfset ef_modo="ALTA">
	<cfelseif form.ef_modo EQ "CAMBIO">
		<cfset ef_modo="CAMBIO">
	<cfelse>
		<cfset ef_modo="ALTA">
	</cfif>
</cfif>

<cfif ef_modo neq 'ALTA'>
	<!-- MODO Detalle de Formatos -->
	<cfif isdefined("form.Cambio")>
		<cfset df_modo = "CAMBIO">
	<cfelse>
		<cfif not isdefined("form.df_modo")>
			<cfset df_modo="ALTA">
		<cfelseif form.df_modo EQ "CAMBIO">
			<cfset df_modo="CAMBIO">
		<cfelse>
			<cfset df_modo="ALTA">
		</cfif>
	</cfif>
	
	<!-- MODO Acciones por Formato -->
	<cfif not isdefined("Form.ac_modo")>
		<cfset ac_modo="ALTA">
	<cfelseif form.ac_modo EQ "CAMBIO">
		<cfset ac_modo="CAMBIO">
	<cfelse>
		<cfset ac_modo="ALTA">
	</cfif>

	<!-- MODO Usuarios por Formato -->
	<cfif not isdefined("Form.us_modo")>
		<cfset us_modo="ALTA">
	<cfelseif form.us_modo EQ "CAMBIO">
		<cfset us_modo="CAMBIO">
	<cfelse>
		<cfset us_modo="ALTA">
	</cfif>
</cfif>