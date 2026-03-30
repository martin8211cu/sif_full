<cf_template template="#session.sitio.template#">

<cf_templatearea name="title">
  Tramites Personales 
</cf_templatearea>

<cf_templatearea name="body">
<cf_templatecss>

<cfquery name="rstipos" datasource="#session.tramites.dsn#">
	SELECT id_tiporeq ,codigo_tiporeq ,nombre_tiporeq
	FROM TPTipoReq 
</cfquery>

<cfquery name="rstiposserv" datasource="#session.tramites.dsn#">
	SELECT id_inst,id_tiposerv ,codigo_tiposerv ,nombre_tiposerv 
	FROM TPTipoServicio 
	order by id_inst,id_tiposerv
</cfquery>

<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
	SELECT id_inst,codigo_inst,nombre_inst
	FROM TPInstitucion 
	order by id_inst
</cfquery>

<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>

<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8', form.tab) )>
	<cfset form.tab = 1 >
</cfif>	

<cfset modo = 'ALTA'>
	
<cfif isdefined("url.id_requisito") and not isdefined("form.id_requisito")>
	<cfset form.id_requisito = url.id_requisito >
</cfif>

<cfif isdefined("Form.id_requisito") and len(trim(form.id_requisito))>
	<cfset modo = 'CAMBIO'>
</cfif>		
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Requisitos'>
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td><cfinclude template="/home/menu/pNavegacion.cfm"></td></tr>
					<cfif isdefined("form.id_requisito") and len(trim(form.id_requisito))>
						<cfquery name="inst" datasource="#session.tramites.dsn#">
							select r.codigo_requisito, r.nombre_requisito, r.id_documento, r.id_vista
							from TPRequisito r
							where r.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
						</cfquery>
						<cfoutput>
						<tr><td>
						<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
							<tr><td align="center" valign="middle">
								<font size="3" color="##003399">
								<strong>Requisito:&nbsp;#trim(inst.codigo_requisito)# - #inst.nombre_requisito#</strong></font></td></tr>
						</table>
						</td></tr>
						</cfoutput>
					</cfif>
					<tr><td>&nbsp;</td></tr>			<tr><td>
				<cf_tabs width="100%" onclick="tab_set_current">
					<cf_tab id="1" text="Datos Generales" selected="#form.tab eq 1#">
						<cfif form.tab eq 1 >
							<cfinclude template="Tp_Requisitos-form.cfm">
						</cfif>
					</cf_tab>
					<cfif modo neq 'ALTA'>
						<cf_tab id="2" text="Validaci&oacute;n y Cumplimiento" selected="#form.tab eq 2#">
							<cfif form.tab eq 2 >
								<cfinclude template="TP_requisitosValidacionCumplimiento.cfm"> 
							</cfif>	
						</cf_tab>
						<cfif Len(inst.id_documento)>
							<cf_tab id="7" text="Datos de comprobaci&oacute;n" selected="#form.tab eq 7#">
								<cfif form.tab eq 7 >
								<cfinclude template="TP_requisitosRegDocumento.cfm"> 
								</cfif>
							</cf_tab>
						</cfif>
						<cfif Len(inst.id_documento)>
							<cf_tab id="8" text="Criterios de Aprobaci&oacute;n" selected="#form.tab eq 8#">
								<cfif form.tab eq 8 >
								<cfinclude template="TP_requisitosCriAprobacion.cfm"> 
								</cfif>	
							</cf_tab>
						</cfif>
						<cf_tab id="3" text="Informaci&oacute;n adicional" selected="#form.tab eq 3#">
							<cfif form.tab eq 3 >
								<cfinclude template="TP_requisitosInfAdicional.cfm"> 
							</cfif>								
						</cf_tab>
						<cf_tab id="4" text="Documentación adjunta" selected="#form.tab eq 4#">
							<cfif form.tab eq 4 >
								<cfinclude template="TP_requisitosDocs.cfm">
							</cfif>	
						</cf_tab>
						
						<cf_tab id="6" text="Pagos" selected="#form.tab eq 6#">
							<cfif form.tab eq 6 >
								<cfinclude template="TP_RequisitosPagos_form.cfm">
							</cfif>	
						</cf_tab>
						
						<cf_tab id="5" text="Seguridad" selected="#form.tab eq 5#">
							<cfif form.tab eq 5 >
								<cfset items = "">
								<cfset items = ListAppend(items, "GEN-Datos Generales")>
								<cfset items = ListAppend(items, "VYC-Validación y Cumplimiento")>
								<cfset items = ListAppend(items, "TXT-Información adicional")>
								<cfset items = ListAppend(items, "DOC-Documentación adjunta")>
								<cfset items = ListAppend(items, "PAG-Pagos")>
								
									<cf_permisos tipo_objeto="R" id_objeto="#Form.id_requisito#"
										items="#items#">
							</cfif>		
						</cf_tab>
						
						
						
					</cfif>
				</cf_tabs>
			</td></tr>
		</table>
		
		<script type="text/javascript">
			<!--
			function tab_set_current(n){
				<cfif isdefined("form.id_requisito") and len(trim(form.id_requisito))>
					location.href='Tp_Requisitos.cfm?id_requisito=<cfoutput>#JSStringFormat(form.id_requisito)#</cfoutput>&tab='+escape(n);
				<cfelse>
					alert('Debe agregar o seleccionar un Requisito.');
				</cfif>
			}
			//-->
		</script>
		
	<cf_web_portlet_end>	
	</cf_templatearea>
</cf_template>
