<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
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
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" -->
	  <cf_web_portlet_start titulo="Salarios por Puesto">
				<cfif isdefined("url.RHPcodigo") and not isdefined("form.RHPcodigo")>
					<cfset form.RHPcodigo = url.RHPcodigo >
				</cfif>

		  		<table width="100%" cellpadding="0" cellspacing="0">
					<cfset regresar = "/cfmx/rh/admin/catalogos/Puestos.cfm?modo=CAMBIO&RHPcodigo=#form.RHPcodigo#" >
					<cfset navBarItems = ArrayNew(1)>
					<cfset navBarLinks = ArrayNew(1)>
					<cfset navBarStatusText = ArrayNew(1)>			 
					<cfset navBarItems[1] = "Estructura Organizacional">
					<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
					<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
					<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					
					<tr>
						<!--- lista --->
						<td valign="top" width="45%">
							<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="SalarioPuesto a, RHPuestos b, NProfesional c"/>
								<cfinvokeargument name="columnas" value="convert(varchar, SPid) as SPid, a.RHPcodigo, SPsalario, NPdescripcion, convert(varchar, a.SPfechaini, 103) as vSPfechaini, convert( varchar, a.SPfechafin, 103) as vSPfechafin"/>
								<cfinvokeargument name="desplegar" value="NPdescripcion, vSPfechaini, vSPfechafin, SPsalario"/>
								<cfinvokeargument name="etiquetas" value="Nivel profesional, Fecha Inicial, Fecha Final, Salario"/>
								<cfinvokeargument name="formatos" value="V,D,D,M"/>
								<cfinvokeargument name="filtro" value="a.Ecodigo=#session.Ecodigo# and a.RHPcodigo='#form.RHPcodigo#' and a.RHPcodigo=b.RHPcodigo and a.Ecodigo=b.Ecodigo and a.NPcodigo=c.NPcodigo and a.Ecodigo=c.Ecodigo order by NPdescripcion, SPfechaini, SPfechafin"/>
								<cfinvokeargument name="align" value="left,right,right,right"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="SalarioPuesto.cfm"/>
							</cfinvoke>
						</td>

						<!--- mantenimiento --->
						<td valign="top"><cfinclude template="formSalarioPuesto.cfm"></td>
					</tr>
				</table>
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->