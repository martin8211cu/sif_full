<!--- <cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
</cfif>
<cfif isdefined('url.RHRCfdesde') and not isdefined('form.RHRCfdesde')>
	<cfparam name="form.RHRCfdesde" default="#url.RHRCfdesde#">
</cfif>
<cfif isdefined('url.id_agenda') and not isdefined('form.id_agenda')>
	<cfparam name="form.id_agenda" default="#url.id_agenda#">
</cfif>
<cfset params="">
<cfoutput>
	<cfif isdefined('form.RHRCfdesde') and form.RHRCfdesde NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?RHRCfdesde=#form.RHRCfdesde#">
		<cfelse>
			<cfset params = params & "&RHRCfdesde=#form.RHRCfdesde#">
		</cfif>
	</cfif>
	<cfif isdefined('form.id_requisito') and form.id_requisito NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?id_requisito=#form.id_requisito#">
		<cfelse>
			<cfset params = params & "&id_requisito=#form.id_requisito#">
		</cfif>
	</cfif>
	<cfif isdefined('form.id_agenda') and form.id_agenda NEQ ''>
		<cfif params EQ ''>
			<cfset params = "?id_agenda=#form.id_agenda#">
		<cfelse>
			<cfset params = params & "&id_agenda=#form.id_agenda#">
		</cfif>
	</cfif>			#params# --->

	<iframe src="/cfmx/home/tramites/Operacion/expediente/reg_agenda-form.cfm" id="iframe_gestion" 
		width="540" height="730" frameborder="1" vspace="0" hspace="0" style="border:0px solid red;margin:0;padding:0;width:540px">
	</iframe>
