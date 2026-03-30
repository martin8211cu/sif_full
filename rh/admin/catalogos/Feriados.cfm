<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">

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
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_DiasFeriados"
						Default="D&iacute;as Feriados"
						returnvariable="LB_DiasFeriados"/>

                  <cf_web_portlet_start titulo="#LB_DiasFeriados#">
						<script language="JavaScript1.2" type="text/javascript">
							function funcRestablecer(){
								document.filtro.fRHFfecha.value = '01/01/<cfoutput>#datepart('yyyy', Now())#</cfoutput>';
							}
						</script>
						<table width="100%" cellpadding="0" cellspacing="0">
							<cfset regresar = "/cfmx/rh/indexEstructura.cfm" >
							<cfset navBarItems = ArrayNew(1)>
							<cfset navBarLinks = ArrayNew(1)>
							<cfset navBarStatusText = ArrayNew(1)>			 
							<cfset navBarItems[1] = "Estructura Organizacional">
							<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
							<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
							<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
							<tr>
								<!--- Lista de Feriados --->
								<td valign="top" width="50%">
									<form style="margin:0" name="filtro" method="post">
									
									
										<table width="100%" class="tituloListas">
											<tr>
												<td width="1%" nowrap><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate>:&nbsp;</td>
												<td>
													<cfoutput>
													<cfif isdefined("form.fRHFfecha") and len(trim(form.fRHFfecha)) gt 0 ><cfset fecha = form.fRHFfecha><cfelse><cfset fecha = "01/01/#datepart('yyyy', Now())#"></cfif>
													<cf_sifcalendario form="filtro" name="fRHFfecha"  value = "#fecha#" tabindex="1">
													</cfoutput>
												</td>
												<td align="right">
														<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Filtrar"
														Default="Filtrar"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Filtrar"/>
														<cfinvoke component="sif.Componentes.Translate"
														method="Translate"
														Key="BTN_Restablecer"
														Default="Restablecer"
														XmlFile="/rh/generales.xml"
														returnvariable="BTN_Restablecer"/>

													<cf_botones values="#BTN_Filtrar#,#BTN_Restablecer#" tabindex="1">
												</td>
											</tr>
										</table>
									</form>
								
									<cfset imagen1 = "<img src=/cfmx/rh/imagenes/checked.gif border=0>">
									<cfset imagen2 = "<img src=/cfmx/rh/imagenes/unchecked.gif border=0>">
		
									<cfset columna = "" >
									<cfif isdefined("form.btnFiltrar") and isdefined("form.fRHFfecha") and len(trim(form.fRHFfecha)) gt 0 >
										<cfset columna = ", '#form.fRHFfecha#' as fRHFfecha,  'Filtrar' as btnFiltrar" >
									<cfelse>
										<!---<cfset columna = ", '01/01/#datepart('yyyy', Now())#' as fRHFfecha, btnFiltrar='Filtrar'" >--->
										<cfset columna = ", 01/01/#datepart('yyyy', Now())# as fRHFfecha " >
									</cfif>
									
									<cfquery name="rslista" datasource="#session.DSN#">
										Select RHFid, RHFfecha, RHFdescripcion, 
												case RHFregional when 1 then '#imagen1#' when 0 then '#imagen2#' end as RHFregional,
												
												<cfif isdefined("form.btnFiltrar") and isdefined("form.fRHFfecha") and len(trim(form.fRHFfecha)) gt 0 >
														'#form.fRHFfecha#' as fRHFfecha,  'Filtrar' as btnFiltrar
												<cfelse>
														'01/01/#datepart('yyyy', Now())#' as fRHFfecha
												</cfif>										
										From RHFeriados
										Where Ecodigo= #session.Ecodigo# 
										
										<cfif isdefined("form.btnFiltrar") >
											<cfif isdefined("form.fRHFfecha") and len(trim(form.fRHFfecha)) gt 0 >
												and RHFfecha >= <cfqueryparam value="#LSParseDateTime(form.fRHFfecha)#"   cfsqltype="cf_sql_timestamp">
											</cfif>
										<cfelse>	
											and RHFfecha >= <cfqueryparam value="#LSParseDateTime('01/01/#datepart('yyyy', Now())#')#"   cfsqltype="cf_sql_timestamp">								
										</cfif>						
										order by RHFfecha 
									</cfquery>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Fecha"
										Default="Fecha"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Fecha"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Descripcion"
										Default="Descripci&oacute;n"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Descripcion"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Regional"
										Default="Regional"
										returnvariable="LB_Regional"/>
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaRet">
										<cfinvokeargument name="query" value="#rslista#"/>
										<cfinvokeargument name="desplegar" value="RHFfecha, RHFdescripcion, RHFregional"/>
										<cfinvokeargument name="etiquetas" value="#LB_Fecha#,#LB_Descripcion#,#LB_Regional#"/>
										<cfinvokeargument name="formatos" value="D,V,V"/>
										<cfinvokeargument name="align" value="left, left, center"/>
										<cfinvokeargument name="ajustar" value="N"/>
										<cfinvokeargument name="checkboxes" value="N"/>
										<cfinvokeargument name="irA" value="Feriados.cfm"/>
										<cfinvokeargument name="keys" value="RHFid"/>
										<cfinvokeargument name="formname" value="form"/>
										<cfinvokeargument name="showEmptyListMsg" value="true"/> 
									</cfinvoke>
								</td>
								<!--- mantenimiento --->
								<td valign="top" width="50%"><cfinclude template="formFeriados.cfm"></td>
							</tr>
						</table>		  
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>