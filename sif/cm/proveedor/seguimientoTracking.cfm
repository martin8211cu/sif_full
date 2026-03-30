<cf_templateheader title="Compras - Consulta de Embarques">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Trackings '>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<cfset parametros = "">
			<cfif isdefined("form.ETidtracking_move1") and len(trim(form.ETidtracking_move1))>
				<cfset parametros = parametros & "&ETidtracking_move1=" & form.ETidtracking_move1 >
			</cfif>
			
			<cfif isdefined("form.Consultar")>
				<cfset pantalla = 1>
				<cfset archivo ='seguimientoTracking-filtro.cfm' >
			<cfelse>
				<cfif isdefined("url.pantalla")>
					<cfif url.pantalla EQ 1>
						<cfset archivo ='seguimientoTracking-filtro.cfm' >
					</cfif>
					<cfif url.pantalla EQ 2>
						<cfset archivo ='seguimientoTrackingRango-filtro.cfm' >
					</cfif>
				<cfelse>
					<cfset pantalla = 2>
					<cfset archivo ='seguimientoTrackingRango-filtro.cfm' >
				</cfif>
			</cfif>
			
			<cf_rhimprime datos="/sif/cm/proveedor/seguimientoTracking-form.cfm" paramsuri="#parametros#"> 
            <cfinclude template="seguimientoTracking-form.cfm">			        	
						
			<DIV align="center"><input name="btnRegresar" type="button" class="btnAnterior" value="Regresar" onClick="javascript:location.href='<cfoutput>#archivo#</cfoutput>'" ></DIV>
			<br>
		<cf_web_portlet_end>
	<cf_templatefooter>
