<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Tr&aacute;mites
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Tr&aacute;mites">

		<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
			<cfset form.id_tramite = url.id_tramite >
		</cfif>
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfset modo = 'ALTA'>
		<cfif isdefined("Form.id_tramite") and len(trim(form.id_tramite))>
			<cfset modo = 'CAMBIO'>
		</cfif>		
		
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>		

		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
					<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
						<cfquery name="inst" datasource="#session.tramites.dsn#">
							select codigo_tramite, nombre_tramite
							from TPTramite
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
						</cfquery>
						<cfoutput>
						<tr><td>
						<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
							<tr><td align="center" valign="middle">
								<font size="3" color="##003399">
								<strong>Tr&aacute;mite:&nbsp;#trim(inst.codigo_tramite)# - #inst.nombre_tramite#</strong></font></td></tr>
						</table>
						</td></tr>
						</cfoutput>
					</cfif>
					<tr><td>&nbsp;
					</td></tr>
			<tr><td>
				<cf_tabs width="100%" onclick="tab_set_current_tramite">
						<cf_tab id="1" text="Datos Generales" selected="#form.tab eq 1#">
					<cfif form.tab eq 1 >
							<cfinclude template="tramites-form.cfm">
					</cfif>
						</cf_tab>

					<cfif isdefined("form.id_tramite")>
							<cf_tab id="2" text="Informaci&oacute;n adicional" selected="#form.tab eq 2#">
						<cfif form.tab eq 2 >

								<cfinclude template="TP_TramitesInfAdicional.cfm"> 
						</cfif>
							</cf_tab>					

						

							<cf_tab id="3" text="Requisitos del Tr&aacute;mite" selected="#form.tab eq 3#">
						<cfif form.tab eq 3 >
								<cfinclude template="requisitos_tramite.cfm"> 
						</cfif>
							</cf_tab>

						
							<cf_tab id="4" text="Documentación adjunta" selected="#form.tab eq 4#">
						<cfif form.tab eq 4 >

								<cfinclude template="TP_TramitesDocs.cfm">
						</cfif>
							</cf_tab>
	
							<cf_tab id="6" text="Cierre del Tr&aacute;mite" selected="#form.tab eq 6#">
								<cfif form.tab eq 6 >
										<cfinclude template="cierre_tramite_form.cfm"> 
								</cfif>
							</cf_tab>

							<cf_tab id="5" text="Seguridad" selected="#form.tab eq 5#">
						<cfif form.tab eq 5 >

								<cfset items = "">
								<cfset items = ListAppend(items, "GEN-Datos Generales")>
								<cfset items = ListAppend(items, "TXT-Información adicional")>
								<cfset items = ListAppend(items, "REQ-Requisitos")>
								<cfset items = ListAppend(items, "DOC-Documentación adjunta")>
								<cfset items = ListAppend(items, "TRA-Cierre Trámites")>
								<cf_permisos tipo_objeto="T" id_objeto="#Form.id_tramite#"
									items="#items#">
						</cfif>
							</cf_tab>
					</cfif>
				</cf_tabs>
			</td></tr>
		</table>
		
		<script type="text/javascript">
			<!--
			function tab_set_current_tramite(n){
				<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
					location.href='tramites.cfm?id_tramite=<cfoutput>#JSStringFormat(form.id_tramite)#</cfoutput>&tab='+escape(n);
				<cfelse>
					alert('Debe agregar o seleccionar un Tr&aacute;mite.');
				</cfif>
			}
			//-->
		</script>
		
		
	<cf_web_portlet_end>
</cf_templatearea>
</cf_template>
