<cfparam name="modo" 	 	  	 		 default="ALTA">
<cfparam name="MostrarValoreLista" 	 default="FALSE">

<cfif (isdefined('form.DRid') and len(trim(form.DRid)) GT 0) or (isdefined('url.DRid') and len(trim(url.DRid)))>
	<cfset modo = "CAMBIO">
	<cfif not isdefined('form.DRid') or len(trim(form.DRid)) EQ 0>
		<cfset form.DRid = url.DRid>
	</cfif>
</cfif>

<cf_templateheader title="Declaración Pago de Renta">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Declaración Pago de Renta">
					<cfif (isdefined('form.DRid') and len(trim(form.DRid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.DRid'))>
						<cfinclude  template="DPagoRenta-form.cfm">
					<cfelse>
						<cfinclude  template="DPagoRenta-lista.cfm">
					</cfif>
		<cf_web_portlet_end>
<cf_templatefooter>