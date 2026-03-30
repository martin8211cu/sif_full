<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="MSG_UstedNoEstaAutorizadoParaVerEstaOpcion" default="Usted no est&aacute; autorizado para ver esta opci&oacute;n."returnvariable="MSG_UstedNoEstaAutorizadoParaVerEstaOpcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_RHAutogestion" default="RH - Autogesti&oacute;n" returnvariable="LB_RHAutogestion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<!--- SE VERIFICA SI EL USUARIO ES JEFE DE ALGUN CENTRO FUNCIONAL
	O LA PLAZA ASIGNADA A ESE USUARIO ES RESPONSABLE DE ALGUN  CENTRO FUNCIONAL --->
<cfif isdefined('url.TSub')>
	<!--- SE LLAMA FUNCION PARA VERIFICAR SI EL USUARIO ES JEFE DE UN CENTRO FUNCIONAL --->
	<cfquery name="rsDEidUsuario" datasource="#session.DSN#">
		select <cf_dbfunction name="to_number" args="llave"> as llave
		from UsuarioReferencia
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		  and STabla = 'DatosEmpleado'
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigosdc#">
	</cfquery>
	<cfif rsDEidUsuario.REcordCount EQ 0>
		<cfset vDEidUsuario = 0>
	<cfelse>
		<cfset vDEidUsuario = rsDEidUsuario.llave>
	</cfif>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="DeterminaJefe"
			deid = "#vDEidUsuario#"
			fecha = "#Now()#"
			returnvariable="rsJefe"/>
	<cfset form.Jefe = rsJefe.Jefe>
	<cfif not form.Jefe>
		<cf_throw message="#MSG_UstedNoEstaAutorizadoParaVerEstaOpcion#" errorcode="5000">
		<cfabort>
	<cfelse>
		<cfset form.CentroF = rsJefe.CFid>
		<cfset form.RHPid = rsJefe.RHPid>
	</cfif>
</cfif>
<cfif isdefined("url.Jefe") and LEN(TRIM(url.Jefe)) and not isdefined("form.Jefe")>
	<cfset form.Jefe= url.Jefe>
</cfif>
<cfif isdefined("url.CentroF") and LEN(TRIM(url.CentroF)) and not isdefined("form.CentroF")>
	<cfset form.CentroF= url.CentroF>
</cfif>

<!---   con esta variable mas el resultado de query siguiente permito o no modificar la informacion de
		datos personales y datos familiares desde este link (Tramites)   --->
<cfset form.EstoyEnGestion = "S">
<cfquery name="rsModificaDE" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Pcodigo = 560
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<!--- ******************************************************************************************* --->

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cfoutput>#LB_RHAutogestion#</cfoutput>
	</cf_templatearea>

	<cf_templatearea name="body">

<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 0>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2"  cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="../expediente/consultas/consultas-frame-header.cfm">
					<cfif isdefined("Form.o") and Len(Trim(Form.o))>
						<cfparam name="Form.tab" default="#Form.o#">
					</cfif>
					<cfset Form.DEid = rsEmpleado.DEid>
					<cfinclude template="frame-header.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr><td >
							<!--- OPARRALES 2018-05-22 Se comento debido a que genera conflicto con el encabezado --->
							<!--- <cfinclude template="/rh/portlets/pNavegacion.cfm"> --->
						</td></tr>
					</table>

					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
					 		<td><!--- class="tabContent" --->
								<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8,9,10', form.tab) )>
									<cfset form.tab = 1 >
								</cfif>
								<cfset tabChoice = form.tab>
								<br>
								<cf_tabs width="100%">
									<cfif not isdefined("form.Jefe")>
										<cf_tab text=#tabNames[1]# selected="#tabChoice eq 1#">
											<cfif tabChoice eq 1>
												<cfinclude template="../expediente/catalogos/datosEmpleado.cfm">
											</cfif>
										</cf_tab>
										<cf_tab text=#tabNames[2]# selected="#tabChoice eq 2#">
											<cfif tabChoice eq 2 >
												<cfinclude template="../expediente/catalogos/familiares.cfm">
											</cfif>
										</cf_tab>
									</cfif>
									<cf_tab text="#tabNames[3]#" selected="#tabChoice eq 3#">
										<cfif tabChoice eq 3 >
											<cfinclude template="../expediente/catalogos/acciones.cfm">
										</cfif>
									</cf_tab>
									<cfif not isdefined("form.Jefe")>
										<cf_tab text=#tabNames[4]# selected="#tabChoice eq 4#">
											<cfif tabChoice eq 4 >
												<cfinclude template="cargas.cfm">
											</cfif>
										</cf_tab>
										<cf_tab text=#tabNames[5]# selected="#tabChoice eq 5#">
											<cfif tabChoice eq 5 >
												<cfinclude template="deducciones.cfm">
											<cfelse>
												<div align="center">
													<b><cf_translate key="MSG_EsteModuloNoEstaDisponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b>
												 </div>
											</cfif>
										</cf_tab>
									</cfif>
									<cfif not isdefined("form.Jefe")>
										<cf_tab text="#tabNames[6]#" selected="#tabChoice eq 6#">
											<cfif tabChoice eq 6 >
												<cfset Lvar_EducAuto = 1>
												<cfinclude template="../capacitacion/expediente/educacion.cfm">
											<cfelse>
												<div align="center">
													<b><cf_translate key="MSG_EsteModuloNoEstaDisponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b>
												 </div>
											</cfif>
										</cf_tab>
										<cf_tab text="#tabNames[7]#" selected="#tabChoice eq 7#">
											<cfif tabChoice eq 7 >
												<cfset Lvar_EducAuto = 1>
												<cfinclude template="../capacitacion/expediente/experiencia.cfm">
											<cfelse>
												<div align="center">
													<b><cf_translate key="MSG_EsteModuloNoEstaDisponible">Este m&oacute;dulo no est&aacute; disponible</cf_translate></b>
												 </div>
											</cfif>
										</cf_tab>
									</cfif>
								</cf_tabs>
								<script language="javascript" type="text/javascript">
								function tab_set_current (n){
									var extra = '';
									//VARIABLE PARA EL CASO DE LA OPCION DE TRAMITES PARA SUBORDINADOS
									<cfif isdefined("form.Jefe")>
										extra = "&Jefe="+<cfoutput>#form.Jefe#</cfoutput>+"&CentroF="+<cfoutput>#form.CentroF#</cfoutput>;
									</cfif>
									location.href='autogestion.cfm?o='+escape(n)+'&tab='+escape(n)+extra;
								}
								</script>

					 		</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</cf_templatearea>
</cf_template>