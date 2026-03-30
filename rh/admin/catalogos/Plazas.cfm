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

		<script language="JavaScript1.2" type="text/javascript">
			function limpiar(){
				document.filtro.fRHPcodigo.value = "";
				document.filtro.fRHPdescripcion.value   = "";
			}
		</script>
		
		<cfset filtro = "Ecodigo = #Session.Ecodigo#">
		<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0 >
			<cfset filtro = filtro & " and RHPcodigo like '%#form.fRHPcodigo#%' " >
		</cfif>
		<cfif isdefined("form.fRHPdescripcion") and len(trim(form.fRHPdescripcion)) gt 0 >
			<cfset filtro = filtro & " and upper(RHPdescripcion) like '%#ucase(form.fRHPdescripcion)#%' " >
		</cfif>
		<cfset filtro = filtro & "order by RHPcodigo">
		<cf_web_portlet_start titulo="Plazas">
			<cfset regresar = "/cfmx/rh/indexEstructura.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="top" width="40%">
						<form name="filtro" method="post">
							<table border="0" width="100%" class="areaFiltro">
							  <tr> 
								<td>C&oacute;digo</td>
								<td>Descripci&oacute;n</td>
							  </tr>
							  <tr> 
								<td><input type="text" name="fRHPcodigo" value="<cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0 ><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();" ></td>
								<td><input type="text" name="fRHPdescripcion" value="<cfif isdefined("form.fRHPdescripcion") and len(trim(form.fRHPdescripcion)) gt 0 ><cfoutput>#form.fRHPdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="javascript:this.select();" ></td>
								<td><input type="submit" name="Filtrar" value="Filtrar"><input type="button" name="Limpiar" value="Limpiar" onClick="javascript:limpiar();"></td>
							  </tr>
							</table>
						  </form>						
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="RHPlazas"/>
							<cfinvokeargument name="columnas" value="convert(varchar, RHPid) as RHPid, RHPcodigo, RHPdescripcion"/>
							<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescripcion"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="V, V"/>
							<cfinvokeargument name="filtro" value="#filtro#"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="Plazas.cfm"/>
						</cfinvoke>
					</td>
					<td width="60%" valign="top"><cfinclude template="formPlazas.cfm"></td>
				</tr>
			</table>
		<cf_web_portlet_end>
		<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->