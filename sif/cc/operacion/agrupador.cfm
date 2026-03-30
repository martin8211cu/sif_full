<cf_templateheader title="Agrupador de Generación de Recibos"> 
	<cf_navegacion name="AFTRdescripcion" navegacion="">
		<cfset titulo = 'Generaci&oacute;n de recibos'>
<!---		<cfdump var="#form#">--->
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<cfif isdefined ('url.EAid')>
			<cfset form.EAid=#url.EAid#>
		</cfif>
		<table width="100%">
		  <tr>
			<td valign="top">
			
			<cfif isdefined ('url.ErrorL') and len(trim(url.ErrorL)) gt 0>
				<cfloop list="#url.ErrorL#" delimiters="," index="bb">
					<cfset valor=#listgetat(bb, 1, ',')#>
					<cf_errorCode	code = "50169"
									msg  = "De los archivos que se generaron no se pudo aplicar el cobro a: @errorDat_1@"
									errorDat_1="#url.ErrorL#"
					>
				</cfloop>
			</cfif>
			
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select count(1) as cantidad from ConsecutivoCxC 
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			
			<cfif rsSQL.cantidad eq 0>
				<cfinclude template="agrupador_param.cfm">
			<cfelse>
				<cfif (isdefined('form.EAid') and len(trim(form.EAid)) or isdefined ('form.Nuevo') and len(trim(form.Nuevo)) gt 0 or isdefined ('url.Nuevo') )>
						<cfinclude template="agrupador_form.cfm">
					<cfelse>
						<cfinclude template="agrupador_lista.cfm">				
				</cfif>				
			</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


