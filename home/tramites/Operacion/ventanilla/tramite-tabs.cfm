		<cf_templatecss>

		<cfif isdefined("url.id_instancia") and not isdefined("form.id_instancia")>
			<cfset form.id_instancia = url.id_instancia >
		</cfif>
		<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
			<cfset form.id_persona = url.id_persona >
		</cfif>

		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>

		<cfquery name="tramite" datasource="#session.tramites.dsn#">
			select id_tramite
			from TPInstanciaTramite
			where id_instancia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_instancia#">
			  and id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		</cfquery>
		
		
		<cfinvoke component="home.tramites.componentes.tramites"
			method="permisos_obj"
			id_funcionario="#session.tramites.id_funcionario#"
			tipo_objeto="T"
			id_objeto="#tramite.id_tramite#"
			puede_capturar="1"
			puede_modificar="1"
			puede_modo="or"
			returnvariable="puede_capturar_o_modificar" >
		</cfinvoke>
		<cfquery name="data" datasource="#session.tramites.dsn#">
			select 	p.id_persona,
					p.id_tipoident, 
					p.id_direccion, 
					p.identificacion_persona, 
					p.nombre, 
					p.apellido1, 
					p.apellido2, 
					p.nacimiento, 
					p.sexo, 
					p.casa, 
					p.oficina, 
					p.celular, 
					p.fax, 
					p.email1, 
					p.foto, 
					p.nacionalidad, 
					p.extranjero,
					coalesce(d.direccion1, d.direccion2) as direccion,
					p.ts_rversion
			from TPPersona p
			left join TPDirecciones d
			on p.id_direccion = d.id_direccion		
			where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
		</cfquery>

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
			<TR><TD valign="top" align="center">
			<!---
				ya va en el la plantilla de gobiernodigital, y 
				a veces confunde el hecho de que se pueda regresar
				al menu de inicio de tramites (menu.cfm)
				<cfinclude template="/home/menu/pNavegacion.cfm">
				
			--->
				<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
					
					<tr><td><br><cfinclude template="encabezado.cfm"></td></tr>

					<!--- ENCABEZADO --->
					<!---
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
					--->


					<tr><td>&nbsp;</td></tr>
					
					<tr><td align="center">
						<cf_tabs width="100%" onclick="tab_set_current_inst">
							<cf_tab text="Datos Generales" id="1" selected="#form.tab eq 1#">
								<cfif form.tab eq 1 >
									<cfinclude template="datos-generales.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="Requisitos" id="2" selected="#form.tab eq 2#">
								<cfif form.tab eq 2 >
								<cfinclude template="requisitos.cfm">
								</cfif>
							</cf_tab>
							
							<cfif puede_capturar_o_modificar>
 							<cf_tab text="Aprobaci&oacute;n y Captura" id="3" selected="#form.tab eq 3#">
								<cfif form.tab eq 3 >
									<cfinclude template="datos-variables.cfm">
								</cfif>
							</cf_tab>
							</cfif>

							<cf_tab text="Consulta" id="4" selected="#form.tab eq 4#">
								<cfif form.tab eq 4 >
									<cfinclude template="detalle.cfm">
								</cfif>
							</cf_tab>

						</cf_tabs>
					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
			</TD></TR>
		</table>
		<iframe id="ping_ventanilla" frameborder="0" style="width:0; height:0; visibility:hidden;" src="/cfmx/home/tramites/Operacion/ventanilla/ping_ventanilla.cfm"></iframe>

		<script type="text/javascript">
			<!--
			function tab_set_current_inst (n){
				<cfif isdefined("form.id_instancia") and len(trim(form.id_instancia))>
					location.href='tramite.cfm?id_instancia=<cfoutput>#JSStringFormat(form.id_instancia)#&id_persona=#JSStringFormat(form.id_persona)#</cfoutput>&tab='+escape(n);
				<cfelse>
					alert('Debe agregar o seleccionar un tramite.');
				</cfif>
			}
			//-->
		</script>
