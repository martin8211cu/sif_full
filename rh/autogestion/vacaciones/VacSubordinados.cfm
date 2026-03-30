<cfparam name="form.Nivel" default="1">
<cfparam name="form.imprimir" default="N">
<cfparam name="form.month" default="#month(now())#">
<cfparam name="form.year" default="#year(now())#">
<cfparam name="form.today" default="#now()#">


<cfif isdefined("url.imprimir")>
	<cfset form.imprimir = 'S'>
</cfif>
<cfif isdefined("url.year")>
	<cfset form.year = url.year>
</cfif>
<cfif isdefined("url.month")>
	<cfset form.month = url.month>
</cfif>

<cfif isdefined("url.limitar") and not isdefined("form.limitar")>
	<cfset form.limitar = 1>
</cfif>
<cfif isdefined("form.limitar")>
	<cfset form.Nivel = 1>
<cfelse>
	<cfset form.Nivel = 3>	
</cfif>



<!--- <cfdump var="#Form#"> --->

<cfquery name="RSDeid" datasource="#session.DSN#">
	select ltrim(rtrim(llave)) as Deid  from UsuarioReferencia  
	where  Usucodigo   = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">
	and STabla = 'DatosEmpleado'
	and Ecodigo = <cfqueryparam value="#session.EcodigoSDC#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfif RSDeid.recordCount GT 0>
	<cfinvoke component="rh.Componentes.RH_Funciones" 
		method="DeterminaJefe"
		DEid = "#RSDeid.DEid#"
		fecha = "#Now()#"
		returnvariable="esjefe">
		
	<cfif isdefined("form.imprimir") and form.imprimir eq 'S'>
		<table width="100%" border="0">
		  <tr>
				<td align="center">
					<cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
						<cfinvoke component="rh.Componentes.RH_Funciones" 
							method="DeterminaSubOrd"
							DEid = "#RSDeid.DEid#"
							fecha = "#Now()#"
							Nivel = "#form.Nivel#"
							returnvariable="RSsubordinados">	
						
						<cfif RSsubordinados.recordCount GT 0>
							<cfset subordinados = ValueList(RSsubordinados.DEid,",")>
						<cfelse>
							<cfset subordinados ="-1">
						</cfif>	
						<cfif isdefined("url.debug") and url.debug eq 1>
							<cfdump var="#subordinados#">
						</cfif>
						
						<cfinclude template="form_VacSubordinados.cfm">
					<cfelse>
						<font  style="font-size:20px"><cf_translate  key="LB_Usted_no_tiene_Subordinados_a_cargo">Usted no tiene subordinados a cargo o no es jefe</cf_translate></font>
					</cfif>		
				</td>
		  </tr>
		</table>
	<cfelse>
		<cf_template template="#session.sitio.template#">
			<cf_templatearea name="title">
				<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
			</cf_templatearea>
			
			<cf_templatearea name="body">
				<cf_templatecss>	
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MENU_Vacaciones_colaboradores"
						Default="Vacaciones colaboradores "
						returnvariable="MENU_Vacaciones_colaboradores"/>
						
				 <cf_web_portlet_start border="true" titulo="#MENU_Vacaciones_colaboradores#" skin="#Session.Preferences.Skin#">
						<table width="100%" border="0">
						  <tr>
								<td>
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
								</td>
						  </tr>
						  <tr>
								<td align="center">
									<cfif isdefined("esjefe.CFID") and len(trim(esjefe.CFID))>
										<cfinvoke component="rh.Componentes.RH_Funciones" 
											method="DeterminaSubOrd"
											DEid = "#RSDeid.DEid#"
											fecha = "#Now()#"
											Nivel = "#form.Nivel#"
											returnvariable="RSsubordinados">	
										
										<cfif RSsubordinados.recordCount GT 0>
											<cfset subordinados = ValueList(RSsubordinados.DEid,",")>
										<cfelse>
											<cfset subordinados ="-1">
										</cfif>	
										<cfif isdefined("url.debug") and url.debug eq 1>
											<cfdump var="#subordinados#">
										</cfif>
										
										<cfinclude template="form_VacSubordinados.cfm">
									<cfelse>
										<font  style="font-size:15px"><cf_translate key="LB_mensajealerta">Para accesar esta opci&oacute;n tiene que ser empleado y adem&aacute;s encargado de un centro funcional</cf_translate></font>
									</cfif>		
								</td>
						  </tr>
						</table>
				<cf_web_portlet_end>
			</cf_templatearea>
		</cf_template>
	</cfif>
<cfelse>
	<cf_template template="#session.sitio.template#">
		<cf_templatearea name="title">
			<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
		</cf_templatearea>
		
		<cf_templatearea name="body">
			<cf_templatecss>	
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MENU_Vacaciones_colaboradores"
					Default="Vacaciones colaboradores "
					returnvariable="MENU_Vacaciones_colaboradores"/>
			 <cf_web_portlet_start border="true" titulo="#MENU_Vacaciones_colaboradores#" skin="#Session.Preferences.Skin#">
			 	<table width="100%" border="0">
					<tr>
						<td>
							&nbsp;
						</td>
					</tr>
					<tr>
						<td align="center">
							<font  style="font-size:15px"><cf_translate key="LB_mensajealerta">Para accesar esta opci&oacute;n tiene que ser empleado y adem&aacute;s encargado de un centro funcional</cf_translate></font>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</cf_templatearea>
	</cf_template>
</cfif>


