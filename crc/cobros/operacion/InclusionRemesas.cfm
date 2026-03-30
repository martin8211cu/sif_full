<cfif isdefined('url.NumLote') or isdefined('form.NumLote') >
<cf_templatecss>
<cfelse>
<cf_templateheader title="Inclusión de Remesas">

	<cf_navegacion name="Config" navegacion=""> 
</cfif> 
	<cfparam name="Attributes.entrada"		default="">	  
	<cfset titulo = 'Inclusión de Remesas'>	
    	
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">																						
	<cfif (isdefined ('form.ERid') and len(trim(form.ERid)) gt 0)  or isdefined ('url.ERid') or isdefined ('form.Nuevo') or isdefined ('form.btnNuevo') or isdefined ('url.Nuevo') or isdefined ('form.NumLote')>
		<cfinclude template="InclusionRemesas_form.cfm"> 
	<cfelse>
		<cfinclude template="InclusionRemesas_lista.cfm">
	</cfif>		
	<cf_web_portlet_end>
	<cfif not(isdefined('url.NumLote') or isdefined('form.NumLote'))>
   	  <cf_templatefooter>
    </cfif>
