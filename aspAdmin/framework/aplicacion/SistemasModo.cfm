<!-- MODO Encabezado de Formatos -->

<cfif isdefined("form.CAMBIO")>
	<cfset s_modo = "CAMBIO">
<cfelse>
	<cfif isdefined("url.s_modo") and not isdefined("form.s_modo")>
		<cfset s_modo="CAMBIO">
	<cfelseif not isdefined("form.s_modo")>
		<cfset s_modo="ALTA">
	<cfelseif form.s_modo EQ "CAMBIO">
		<cfset s_modo="CAMBIO">
	<cfelse>
		<cfset s_modo="ALTA">
	</cfif>
</cfif>

<cfif s_modo neq 'ALTA'>
	<!-- MODO Roles -->
	<cfif isdefined("form.Cambio")>
		<cfset r_modo = "CAMBIO">
	<cfelse>
		<cfif not isdefined("form.r_modo")>
			<cfset r_modo="ALTA">
		<cfelseif form.r_modo EQ "CAMBIO">
			<cfset r_modo="CAMBIO">
		<cfelse>
			<cfset r_modo="ALTA">
		</cfif>
	</cfif>
	
	<!-- MODO Modulos -->
	<cfif not isdefined("Form.m_modo")>
		<cfset m_modo="ALTA">
	<cfelseif form.m_modo EQ "CAMBIO">
		<cfset m_modo="CAMBIO">
	<cfelse>
		<cfset m_modo="ALTA">
	</cfif>

</cfif>