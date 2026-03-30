<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

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
	                <cf_web_portlet_start titulo="Cargas Obrero Patronales">
				
			  <cfset filtro     = "Ecodigo = #Session.Ecodigo#" >
			  <cfset navegacion = "&btnFiltrar=Filtrar" >

				<script language="JavaScript1.2" type="text/javascript">
					function filtrar( form ){
						form.action = '';
						form.submit();
					}
					
					function limpiar(){
						document.filtro.fECcodigo.value		 = '';
						document.filtro.fECdescripcion.value = '';
						document.filtro.fECfecha.value		 = '';
						<cfset navegacion = '' >
					}
					
				</script>
					  
				<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
				<cfset fECcodigo = "">
				<cfset fECdescripcion = "">
				<cfset fECfecha = "">			
					
				<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") ><cfset form.btnFiltrar = url.btnFiltrar ></cfif>
				
				<cfif isdefined("url.fECcodigo") and not isdefined("form.fECcodigo") ><cfset form.fECcodigo = url.fECcodigo ></cfif>
				<cfif isdefined("form.fECcodigo")  AND Len(Trim(form.fECcodigo)) GT 0<!--- and isdefined("form.btnFiltrar")--->>
					
				
					<cfset filtro = filtro & " and upper(ECcodigo) like upper('%" & Trim(form.fECcodigo) & "%')" >
					<cfset fECcodigo = Trim(form.fECcodigo)>
					<cfset navegacion = navegacion & "&fECcodigo=#form.fECcodigo#" >
				</cfif>
				
								
				<cfif isdefined("url.fECdescripcion") and not isdefined("form.fECdescripcion") ><cfset form.fECdescripcion = url.fECdescripcion ></cfif>
				
				<cfif isdefined("form.fECdescripcion") AND Len(Trim(form.fECdescripcion)) GT 0 <!---and isdefined("form.btnFiltrar")--->>
					<cfset filtro = filtro & " and upper(ECdescripcion) like upper('%" & Trim(form.fECdescripcion) & "%')" >
					<cfset fECdescripcion = Trim(form.fECdescripcion)>
					<cfset navegacion = navegacion & "&fECdescripcion=#form.fECdescripcion#" >
				</cfif>
		
				<cfif isdefined("url.fECfecha") and not isdefined("form.fECfecha") ><cfset form.fECfecha = url.fECfecha ></cfif>
				
				<cfif isdefined("form.fECfecha") AND Len(Trim(form.fECfecha)) GT 0 <!---and isdefined("form.btnFiltrar") --->>
					<cfset filtro = filtro & " and ECfecha >= "& #LSPARSEDATETIME(LSDateFormat(Form.fECfecha,"DD/MM/YYY"))# &"" >
					<cfset fECfecha = Trim(form.fECfecha)>
					<cfset navegacion = navegacion & "&fECfecha=#form.fECfecha#" >
				</cfif>
				
					
		  
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr> 
					  <cfset regresar = "/cfmx/rh/indexAdm.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>			 
						<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
						<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
					  <td colspan="5" ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
					</tr>
					
					<tr>
						<td colspan="5">
			               <form style="margin: 0; " name="filtro" method="post" action="listaCargasOP.cfm">
								<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
									<!--- Filtros --->
									<cfoutput> 
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_CODIGO"
									Default="C&oacute;digo"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_CODIGO"/>
							
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_DESCRIPCION"
									Default="Descripci&oacute;n"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_DESCRIPCION"/>										
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_FECHA"
									Default="Fecha"
									XmlFile="/rh/generales.xml"
									returnvariable="LB_FECHA"/>		
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Filtrar"
									Default="Filtrar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Filtrar"/>
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Limpiar"
									Default="Limpiar"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Limpiar"/>			
									
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="BTN_Nuevo"
									Default="Nuevo"
									XmlFile="/rh/generales.xml"
									returnvariable="BTN_Nuevo"/>															

									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="LB_Prioridad"
									Default="Prioridad"
									returnvariable="LB_Prioridad"/>															
										
										<tr> 
											<td align="right" width="8%">#LB_CODIGO#:&nbsp;</td>
											<td width="1%"><input type="text" name="fECcodigo" value="#fECcodigo#" size="6" maxlength="5" onFocus="this.select();"></td>
											<td align="right" width="11%">#LB_DESCRIPCION#:&nbsp;</td>
											<td><input type="text" name="fECdescripcion" value="#fECdescripcion#" size="35" maxlength="35" onFocus="this.select();"></td>
											<td width="30%" align="right">#LB_FECHA#:&nbsp;</td>
											<td><cf_sifcalendario form="filtro" name="fECfecha" value="#fECfecha#"></td>
											<td nowrap="nowrap"><div align="right"> 
													<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#"  onClick="javascript:filtrar(this.form)">
											        <input type="button" name="btnLimpiar" value="#BTN_Limpiar#"  onclick="javascript:limpiar()" />
											</div>											</td>
										</tr>
									</cfoutput> 
										<!--- <tr> --->
								</table>
			               </form>
						</td>
					</tr>
		
					<tr>
						<td>
							<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaRH"
							 returnvariable="pListaRet">
								<cfinvokeargument name="tabla" value="ECargas"/>
								<cfinvokeargument name="columnas" value="ECid, ECcodigo, ECdescripcion, ECfecha, ECprioridad"/>
								<cfinvokeargument name="desplegar" value="ECcodigo, ECdescripcion, ECfecha, ECprioridad"/>
								<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_FECHA#,#LB_PRIORIDAD#"/>
								<cfinvokeargument name="formatos" value="V,V,D,V"/>
								<cfinvokeargument name="filtro" value="#filtro# order by ECprioridad, ECcodigo"/>
								<cfinvokeargument name="align" value="left,left,left,left"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="N"/>
								<cfinvokeargument name="irA" value="CargasOP.cfm"/>
								<cfinvokeargument name="keys" value="ECid"/>
								<cfinvokeargument name="botones" value="Nuevo"/>
								<cfinvokeargument name="showEmptyListMsg" value="true"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
							</cfinvoke>
					
						</td>
					</tr>
				</table>
	                <cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
<cf_templatefooter>