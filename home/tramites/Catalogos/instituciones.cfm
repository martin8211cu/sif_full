<cf_template>
	<cf_templatearea name="title">Tr&aacute;mites Personales</cf_templatearea>
	<cf_templatearea name="body">
		<cf_templatecss>

		<cfif isdefined("url.id_inst") and not isdefined("form.id_inst")>
			<cfset form.id_inst = url.id_inst >
		</cfif>
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>

		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
		</script>
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>		
		


		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; ">
			<TR><TD valign="top">
				<cf_web_portlet_start border="true" titulo="Instituciones" skin="#Session.Preferences.Skin#">
				<cfinclude template="/home/menu/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
						<cfquery name="inst" datasource="#session.tramites.dsn#">
							select codigo_inst, nombre_inst
							from TPInstitucion
							where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
						</cfquery>
						<cfoutput>
						<tr><td>
						<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
							<tr><td align="center" valign="middle">
								<font size="3" color="##003399">
								<strong>Instituci&oacute;n:&nbsp;#trim(inst.codigo_inst)# - #inst.nombre_inst#</strong></font></td></tr>
						</table>
						</td></tr>
						</cfoutput>
					</cfif>
					<tr><td>&nbsp;</td></tr>
					
					<tr><td align="center">
						<cf_tabs width="100%" onclick="tab_set_current_inst">
							<cf_tab text="Datos Generales" id="1" selected="#form.tab eq 1#">
								<cfif form.tab eq 1 >
									<cfinclude template="institucion-form.cfm">
								</cfif>
							</cf_tab>
							<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
							<cf_tab text="Sucursales y Ventanillas" id="2" selected="#form.tab eq 2#">
								<cfif form.tab eq 2 >
								<cfinclude template="sucursal.cfm">
								</cfif>
							</cf_tab>
							
<!---  							<cf_tab text="Recursos" id="8" selected="#form.tab eq 8#">
								<cfif form.tab eq 8 >
									<cfinclude template="recursos/recursos.cfm">									
								</cfif>
							</cf_tab>		 --->

							<cf_tab text="Funciones" id="3" selected="#form.tab eq 3#">
								<cfif form.tab eq 3 >
									<cfinclude template="grupo.cfm">
								</cfif>
							</cf_tab>

							<cf_tab text="Funcionarios" id="4" selected="#form.tab eq 4#">
								<cfif form.tab eq 4 >
									<cfif isdefined("url.id_funcionario") and not isdefined("form.id_funcionario")>
										<cfset form.id_funcionario = url.id_funcionario >
									</cfif>

									<cfif isdefined("url.Nuevo") or isdefined("form.btnNuevo") or (isdefined("form.id_funcionario") and len(trim(form.id_funcionario)))>
										<cfinclude template="funcionarios.cfm"> 
									<cfelse>
										<cfinclude template="funcionarios-lista.cfm"> 
									</cfif>
								</cfif>
							</cf_tab>

							<cf_tab text="Servicios" id="5" selected="#form.tab eq 5#">
								<cfif form.tab eq 5 >
									<cfinclude template="tipo_servicio.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="Liquidaci&oacute;n" id="6" selected="#form.tab eq 6#">
								<cfif form.tab eq 6 >
									<cfinclude template="liquidacion.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="Seguridad" id="7" selected="#form.tab eq 7#">
								<cfif form.tab eq 7 >
									<cfset items = "">
									<cfset items = ListAppend(items, "GEN-Datos Generales")>
									<cfset items = ListAppend(items, "FUN-Funcionarios")>
									<cfset items = ListAppend(items, "SUC-Sucursales y Ventanillas")>
									<cfset items = ListAppend(items, "SRV-Servicios")>
									<cfset items = ListAppend(items, "GRP-Grupos")>
										<cf_permisos tipo_objeto="I" id_objeto="#Form.id_inst#"
											items="#items#">
								</cfif>			
							</cf_tab>
							</cfif>
						</cf_tabs>
					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
				<cf_web_portlet_end>
			</TD></TR>
		</table>

		<script type="text/javascript">
			<!--
			function tab_set_current_inst (n){
				<cfif isdefined("form.id_inst") and len(trim(form.id_inst))>
					location.href='instituciones.cfm?id_inst=<cfoutput>#JSStringFormat(form.id_inst)#</cfoutput>&tab='+escape(n);
				<cfelse>
					alert('Debe agregar o seleccionar una institución.');
				</cfif>
			}
			//-->
		</script>
	</cf_templatearea>
</cf_template>