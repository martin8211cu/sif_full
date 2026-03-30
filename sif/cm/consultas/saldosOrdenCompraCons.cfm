<cf_templateheader title="Compras - Saldos de Orden de Compra ">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Saldos por Orden de Compra'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
				
		<cfset parametros = "">
		<cfif isdefined("form.SNcodigoi") and len(trim(form.SNcodigoi))>
			<cfset parametros = parametros & "&SNcodigoi=" & form.SNcodigoi >
		</cfif>
		<cfif isdefined("form.SNcodigof") and len(trim(form.SNcodigof))>
			<cfset parametros = parametros  & "&SNcodigof=" &  form.SNcodigof >
		</cfif>
		
		<cfif isdefined("form.fechai") and len(trim(form.fechai))>
			<cfset parametros = parametros & "&fechai=" & form.fechai >
		</cfif>
		<cfif isdefined("form.fechaf") and len(trim(form.fechaf))>
			<cfset parametros = parametros  & "&fechaf=" & form.fechaf >
		</cfif>

		<!---- --->
		<cfif isdefined("form.EOidorden1") and len(trim(form.EOidorden1))>
			<cfset parametros = parametros & "&EOidorden1=" & form.EOidorden1 >
		</cfif>
		<cfif isdefined("form.EOidorden2") and len(trim(form.EOidorden2))>
			<cfset parametros = parametros & "&EOidorden2=" & form.EOidorden2 >
		</cfif>
		<!---- --->

		<cf_rhimprime datos="/sif/cm/consultas/saldosOrdenCompraCons-form.cfm" paramsuri="#parametros#"> 

		<cfinclude template="saldosOrdenCompraCons-form.cfm">
		
		<table width="100%"><tr><td><br></td></tr></table>
		
		<DIV align="center"><input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='saldosOrdenCompra.cfm'" ></DIV>
		<br>
	<cf_web_portlet_end>
<cf_templatefooter>