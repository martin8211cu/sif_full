<cf_templateheader tilte="Compras - Orden de Compra">
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Orden de Compra'>
				<cfinclude template="../../portlets/pNavegacion.cfm">
						
				<cfset parametros = "">
				<cfif isdefined("form.EOidorden") and len(trim(form.EOidorden))>
					<cfset parametros = parametros & "&EOidorden=" & form.EOidorden >
				</cfif>
	
				<cf_rhimprime datos="/sif/cm/consultas/OrdenCompraLocal-html.cfm" paramsuri="#parametros#"> 
	
				<cfinclude template="OrdenCompraLocal-html.cfm">

				<br>
			<cf_web_portlet_end>
<cf_templatefooter>
