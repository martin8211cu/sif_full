<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cf_templateheader title="Atenci&oacute;n de Prospectos">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<cfinclude template="prospectos-params.cfm">

	<cf_web_portlet_start titulo="Atenci&oacute;n de Prospectos">
		<cfif isdefined('form.PquienProsp') and form.PquienProsp NEQ ''>
			<cfinclude template="prospectos-form.cfm">
		<cfelse>
			<cfinclude template="prospectos-lista.cfm">
		</cfif>
	<cf_web_portlet_end>
	
<cf_templatefooter>
