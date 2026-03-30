<cfif isdefined("form.TPid") and len(trim(form.TPid))>
	<cfquery name="rsTarea" datasource="#session.DSN#">
		select TPid,TPxml,TPfecha
		from ISBtareaProgramada 
		where 	CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
				and TPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TPid#">
				and TPestado = 'P'
				and TPtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TPtipo#">
	</cfquery>
	
	<cfif form.TPtipo EQ 'CP'>		<!---cambio de paquete--->
		<cfsavecontent variable="XSL"><cfinclude template="/saci/xsd/cambioPaquete.xsl"></cfsavecontent>
	<cfelseif form.TPtipo EQ 'CFC'>	<!---cambio de forma de cobro--->
		<cfsavecontent variable="XSL"><cfinclude template="/saci/xsd/cambioFormaCobro.xsl"></cfsavecontent>
	<cfelseif form.TPtipo EQ 'RS'>	<!---retiro de servicio--->
		<cfsavecontent variable="XSL"><cfinclude template="/saci/xsd/retiroServicio.xsl"></cfsavecontent>
	<cfelseif form.TPtipo EQ 'RL'>	<!---retiro de login--->
		<cfsavecontent variable="XSL"><cfinclude template="/saci/xsd/retiroLogin.xsl"></cfsavecontent>
	</cfif>		
	
	
	<cfoutput>
	<form action="#CurrentPage#" name="listaTarea" method="post" style="margin: 0;">
		<cfinclude template="gestion-hiddens.cfm">
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
			<tr><td colspan="2"class="tituloAlterno">#form.TPdescripcion#</td></tr>
			
			<tr><td <cfif form.TPtipo NEQ 'RS' and form.TPtipo NEQ 'RL'>align="center"<cfelse>align="right"</cfif>><label>Fecha Programada</label>
				<cfif form.TPtipo EQ 'RS' or form.TPtipo EQ 'RL'></td><td></cfif>
				&nbsp;#LSDateFormat(rsTarea.TPfecha,'dd/mm/yyyy')#</td>
			</tr>
			
			<cfif form.TPtipo NEQ 'RS'>
			<tr><td colspan="2">
			</cfif>
					<cfoutput>#XmlTransform(rsTarea.TPxml, XSL)#</cfoutput>
			
			<cfif form.TPtipo NEQ 'RS'>
			</td></tr>
			</cfif>
			
			<tr><td colspan="2" align="center"><cf_botones names="Regresar" values="Regresar"></td></tr>
		</table>
	</form>
	</cfoutput>
	
</cfif>
