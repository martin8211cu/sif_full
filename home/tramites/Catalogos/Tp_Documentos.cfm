<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales 
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cfquery name="rstipos" datasource="#session.tramites.dsn#">
	SELECT id_tipodoc ,codigo_tipodoc ,nombre_tipodoc
	FROM TPTipoDocumento 
</cfquery>

<!---<cfquery name="rstiposserv" datasource="#session.tramites.dsn#">
	SELECT id_inst,id_tiposerv ,codigo_tiposerv ,nombre_tiposerv 
	FROM TPTipoServicio 
	order by id_inst,id_tiposerv
</cfquery>--->

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	SELECT id_inst,codigo_inst,nombre_inst
	FROM TPInstitucion 
	order by id_inst
</cfquery>

<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>

<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
	<cfset form.tab = 1 >
</cfif>	

<cfset modo = 'ALTA'>
	
<cfif isdefined("url.id_documento") and not isdefined("form.id_documento")>
	<cfset form.id_documento = url.id_documento >
</cfif>


<cfif isdefined("Form.id_documento") and len(trim(form.id_documento))>
	<cfset modo = 'CAMBIO'>
</cfif>		
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos'>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
			<cfif isdefined("form.id_documento") and len(trim(form.id_documento))>
				<cfquery name="inst" datasource="#session.tramites.dsn#">
					select codigo_documento, nombre_documento, id_tipo
					from TPDocumento
					where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">
				</cfquery>
				<cfoutput>
				<tr><td>
				<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
					<tr><td align="center" valign="middle">
						<font size="3" color="##003399">
						<strong>Documento:&nbsp;#trim(inst.codigo_documento)# - #inst.nombre_documento#</strong></font></td></tr>
				</table>
				</td></tr>
				</cfoutput>
			</cfif>
			<tr><td>&nbsp;</td></tr>	
			<tr><td>
				<cf_tabs width="100%" onclick="tab_set_current_doc">
					<cf_tab text="Datos Generales" selected="#form.tab eq 1#" id = "1">
						<cfif Form.tab EQ 1>
							<cfinclude template="TP_Documentos-form.cfm">
						</cfif>	
					</cf_tab>
					<cfif modo neq 'ALTA'>
						<cf_tab text="Conectividad" selected="#form.tab eq 2#" id= "2">
							<cfif Form.tab EQ 2>
								<cfinclude template="TP_documentosConexion.cfm"> 
							</cfif>	
						</cf_tab>
						<cf_tab text="Informaci&oacute;n adicional" selected="#form.tab eq 3#" id = "3">
							<cfif Form.tab EQ 3>
								<cfinclude template="TP_documentosInfAdicional.cfm"> 
							</cfif>	
						</cf_tab>
						<cf_tab text="Informaci&oacute;n Requerida" selected="#form.tab eq 4#" id = "4">
							<cfif Form.tab EQ 4>
								<cfoutput>
									<iframe src="/cfmx/home/tramites/Catalogos/tipo/DiccDato-form3.cfm?id_tipo=#inst.id_tipo#" height="350" scrolling="auto" style="width:100%"></iframe>
								</cfoutput>
							</cfif>	
						</cf_tab>
						
						<cf_tab text="Seguridad" selected="#form.tab eq 5#" id = "5">
							<cfif Form.tab EQ 5>
								<cfset items = "">
								<cfset items = ListAppend(items, "GEN-Datos Generales")>
								<cfset items = ListAppend(items, "CON-Conectividad")>
								<cfset items = ListAppend(items, "TXT-Información adicional")>
								<cf_permisos tipo_objeto="D" id_objeto="#Form.id_documento#" items="#items#">
							</cfif>
						</cf_tab>
					</cfif>
				</cf_tabs>
			</td></tr>
		</table>
	<cf_web_portlet_end>	
	<script type="text/javascript">
		<!--
		function tab_set_current_doc (n){
			<cfif isdefined("form.id_documento") and len(trim(form.id_documento))>
				location.href='Tp_Documentos.cfm?id_documento=<cfoutput>#JSStringFormat(form.id_documento)#</cfoutput>&tab='+escape(n);
			<cfelse>
				alert('Debe agregar o seleccionar un documento.');
			</cfif>
		}
		//-->
	</script>
	
	</cf_templatearea>
</cf_template>
