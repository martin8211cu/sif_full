<cf_template >
	<cf_templatearea name="title">Facturas</cf_templatearea>
	<cf_templatearea name="left">
		<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	</cf_templatearea>
<cf_templatearea name="header">
<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	
		Facturas		

	</cf_templatearea>
	<cf_templatearea name="body">
		<table width="100%">

			<tr>
				<td width="1%"><cfinclude template="/home/menu/menu.cfm"></td>
				<td>
			
		<cfif isdefined("Url.FACcodigo") and not isdefined("Form.FACcodigo")>
			<cfparam name="Form.FACcodigo" default="#Url.FACcodigo#">
		</cfif>	
		<cfif isdefined("Url.codApersona") and not isdefined("Form.codApersona")>
			<cfparam name="Form.codApersona" default="#Url.codApersona#">
		</cfif>
	
		<cfparam name="Form.FACcodigo" default="">
		<cfif isdefined('form.FACcodigo') and form.FACcodigo EQ "">
			<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
				<cfset titulo = "Facturas"> 
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">			
				
				<cfinclude template="encAlumno.cfm">
				<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
					<cfinclude template="facturas_form.cfm">
				</cfif>
			<cfelse>
				<cfset titulo = "Lista de Facturas">
				<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				
		 		<cfinclude template="encAlumno.cfm">			
				<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>				
					<cfinclude template="facturas_lista.cfm">
				</cfif>					
			</cfif>
		<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
			<cfparam name="form.modo" default="CAMBIO">
			<cfset titulo = "Facturas"> 
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			
			<cfinclude template="encAlumno.cfm">
			<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
				<cfinclude template="facturas_form.cfm">
			</cfif>
		<cfelse>
			<cfset titulo = "Lista de Facturas">
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			
			<cfinclude template="encAlumno.cfm">
			<cfif isdefined('form.codApersona') and form.codApersona NEQ ''>
				<cfinclude template="facturas_lista.cfm">			
			</cfif>
		</cfif>
			</td>
			</tr>

		</table>

	
	</cf_templatearea>
	<cf_templatearea name="right">
	

				
	</cf_templatearea>
</cf_template>
