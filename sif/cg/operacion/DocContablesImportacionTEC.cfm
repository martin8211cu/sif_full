<cf_templateheader title="Importaci&oacute;n de Documentos Contables">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importaci&oacute;n de Documentos Contables">
		<cfinclude template="../../portlets/pNavegacion.cfm">
        
		<!---Variables del Encabezado--->
		<cfif not isdefined('form.ECIid')   and     isdefined('url.ECIid')>    <cfset form.ECIid   = url.ECIid>    </cfif>
        <cfif not isdefined('form.ECIid_F') and     isdefined('url.ECIid_F')>  <cfset form.ECIid_F = url.ECIid_F>  </cfif>
        <cfif     isdefined("form.ECIid")   and not isdefined("form.ECIid_F")> <cfset form.ECIid_F = form.ECIid >  </cfif>
        <cfif     isdefined("form.ECIid_F") and not isdefined("form.ECIid")>   <cfset form.ECIid   = form.ECIid_F> </cfif>
        
        <cfif isdefined('Form.ECIid')>
        	 <cfset Session.ImportarAsientos.ECIid = Form.ECIid>
             <cfset navegacion = "ECIid=#form.ECIid#">
        <cfelseif isdefined('Session.ImportarAsientos.ECIid')>
        	<cfset Form.ECIid = Session.ImportarAsientos.ECIid>
            <cfset navegacion = "ECIid=#form.ECIid#">
        </cfif>
       
		<cfif isdefined("Form.btnImportar")>
			<cfinclude template="DocContablesImportacion-impform.cfm">
		<cfelse>
			<cfinclude template="DocContablesImportacion-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>