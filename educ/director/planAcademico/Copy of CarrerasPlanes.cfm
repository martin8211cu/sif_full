<!-- InstanceBegin template="/Templates/tUniv.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template >
	<cf_templatearea name="title">
	<!-- InstanceBeginEditable name="titulo" -->
		Carreras y Planes de Estudio
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="left">
	<!--- Coloque #N/A# para que desaparezca la zona left: #N/A# = pantalla completa --->
	<!-- InstanceBeginEditable name="left" -->
			<cfinclude template="/home/menu/menu.cfm"> 
		<!-- InstanceEndEditable -->			
	</cf_templatearea>
	<cf_templatearea name="header">
	<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/educ.css">
	<cf_templatecss>
	<!-- InstanceBeginEditable name="Encabezado" -->
			Definición de Carreras y Planes de Estudio
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="body">
	<!-- InstanceBeginEditable name="cuerpo" -->
	
		<cfif isdefined("Url.Mcodigo") and not isdefined("Form.Mcodigo")>
			<cfparam name="Form.Mcodigo" default="#Url.Mcodigo#">
		</cfif>
		<cfif isdefined("Url.Nivel") and not isdefined("Form.Nivel")>
			<cfparam name="Form.Nivel" default="#Url.Nivel#">
		</cfif>
		<cfif isdefined("Url.T") and not isdefined("Form.T")>
			<cfparam name="Form.T" default="#Url.T#">
		</cfif>


	
		<cfinclude template="../../queries/qryEscuela.cfm">
		<cfif isdefined("session.CarrerasPlanes.EScodigo")>
			<cfquery name="qryUltimoPlan" dbtype="query">
				select * from rsEscuela where EScodigo = '#session.CarrerasPlanes.EScodigo#'
			</cfquery>
			<cfif qryUltimoPlan.recordCount GT 1>
				<cfparam name="Form.EScodigo"  default="#session.CarrerasPlanes.EScodigo#">
				<cfparam name="Form.CARcodigo" default="#session.CarrerasPlanes.CARcodigo#">
			<cfelse>
				<cfparam name="Form.EScodigo" default="#rsEscuela.EScodigo#">
				<cfparam name="Form.CARcodigo" default="">
				<cfparam name="Form.PEScodigo" default="">
			</cfif>
			<!--- <cfparam name="Form.PEScodigo" default="#session.CarrerasPlanes.PEScodigo#"> --->
		<cfelseif rsEscuela.recordcount EQ 0>
			<cfthrow message="USTED NO TIENE DEFINIDA UNA ESCULA PARA TRABAJAR, FAVOR CONTACTESE CON LA DIRECCION">
		<cfelse>
			<cfparam name="Form.EScodigo" default="#rsEscuela.EScodigo#">
			<cfparam name="Form.CARcodigo" default="">
			<cfparam name="Form.PEScodigo" default="">
		</cfif>
		<cfparam name="url.nivel" default="1">
		<!--- <cfparam name="url.modo" default="LISTA"> --->
		<cfparam name="Form.nivel" default="#url.nivel#">
		<!--- <cfparam name="Form.modo" default="#url.modo#"> --->
		
		<cfif not isdefined('form.modo')>
			<cfparam name="Form.modo" default="LISTA">
		</cfif>
		
		
		<cfset session.CarrerasPlanes.EScodigo  = form.EScodigo>
		<cfset session.CarrerasPlanes.CARcodigo = form.CARcodigo>
		<cfif isdefined('form.PEScodigo')>
			<cfset session.CarrerasPlanes.PEScodigo = form.PEScodigo>		
		</cfif>

		<cfif form.modo EQ "LISTA">
			<cfset titulo = "Carreras y Planes">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Planes Académicos">
			<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">				
			<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td valign="top">
					<table border="0" cellpadding="2" cellspacing="0">
					<tr>
					<td class="fileLabel" align="right" nowrap><cfoutput>#session.parametros.Escuela#</cfoutput>:</td>
						<td>
							<form name="form0" method="post" action="CarrerasPlanes.cfm" style="margin: 0">
								<select name="EScodigo" onChange="javascript: document.form0.submit();">
									<cfoutput query="rsEscuela">
									<option value="#EScodigo#" <cfif isDefined("Form.EScodigo") and Trim(Form.EScodigo) EQ EScodigo> selected </cfif> >#ESnombre#</option>
									</cfoutput>
								</select>
							</form>
						</td>
					</tr>
					<tr>
						<td valign="top" colspan="2">
							<cfinclude template="CarrerasPlanes_arbol.cfm">
						</td>
					</tr>
					</table>								
				</td>
			  </tr>
			</table>
		<cfelse>
			<cfparam name="session.TABS.TabsPlan" default="1">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarItems[1] = "Planes Académicos">
			<cfset navBarLinks[1] = "/cfmx/educ/director/menuPlanAcadem.cfm">				
			<cfset navBarItems[2] = "Carreras y Planes">
			<cfset navBarLinks[2] = "/cfmx/educ/director/planAcademico/CarrerasPlanes.cfm">				

			<cfif Form.nivel EQ 2>
				<cfif session.TABS.TabsPlan EQ 1>
					<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ "">
						<cfset form.Modo = "CAMBIO">
					<cfelse>
						<cfset form.Modo = "ALTA">
					</cfif>
					<cfset titulo = "Plan">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfelseif form.modo EQ "MPcambio">
					<cfset navBarItems[3] = "Bloques">
					<cfset navBarLinks[3] = "/cfmx/educ/director/planAcademico/CarrerasPlanes.cfm?modo=CAMBIO&nivel=2">				
					<cfset titulo = "Materia">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfelseif form.modo EQ "MPalta">
					<cfset navBarItems[3] = "Bloques">
					<cfset navBarLinks[3] = "/cfmx/educ/director/planAcademico/CarrerasPlanes.cfm?modo=CAMBIO&nivel=2">				
					<cfset titulo = "Materia">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				<cfelse>
					<cfset titulo = "Bloques">
					<cfinclude template="../../portlets/pNavegacionAdmin.cfm">
				</cfif>
			</cfif>

			<cfif isdefined("Form.nivel") and Len(Trim(Form.nivel)) NEQ 0>
				<cfif Form.nivel EQ 1>
					<cfinclude template="Carreras_form.cfm">
				<cfelseif Form.nivel EQ 2>			
					<cfset varModo = ''>
					<cfset varT = ''>
					
					<cfif isdefined('form.modo') and form.modo NEQ ''>
						<cfset varModo = "#form.modo#">
					<cfelse>
						<cfset varModo = "ALTA">
					</cfif>				
					
					<cfinvoke 
					 component="educ.componentes.pTabs2"
					 method="fnTabsInclude">
						<cfinvokeargument name="pTabID" value="TabsPlan"/>
						<cfinvokeargument name="pTabs" value=
							 #"|Plan,PlanEstudios_form.cfm,Trabajar con los datos del plan de estudios"
							& "|documentaciones,documplanestudios.cfm,documentaciones del Plan de Estudios"														 
							& "|Materias,planestudiosbloques.cfm,construcción del Plan de Estudios"
							#
						/> 
						<cfparam name="Form.PBLsecuencia" default="">
						<cfparam name="Form.Mcodigo" default="">
						<cfparam name="Form.PEScodigo" default="">
						<cfparam name="Form.T" default="">
						<cfinvokeargument name="pDatos" value="T=#form.T#,Mcodigo=#form.Mcodigo#,Modo=#varModo#,Nivel=2,EScodigo=#form.EScodigo#,CARcodigo=#form.CARcodigo#,PEScodigo=#form.PEScodigo#,PBLsecuencia=#form.PBLsecuencia#"/>
						<cfinvokeargument name="pNoTabs" value="#(form.Modo EQ 'ALTA')#"/>
						<cfinvokeargument name="pWidth" value="100%"/>
					</cfinvoke>
				</cfif>
			</cfif>
		</cfif>					
		<!-- InstanceEndEditable -->
	</cf_templatearea>
	<cf_templatearea name="right">
	<!-- InstanceBeginEditable name="right" -->

		<!-- InstanceEndEditable -->			
	</cf_templatearea>
</cf_template>
<!-- InstanceEnd -->