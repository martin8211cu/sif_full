<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: Se modifica para que funcione en Oracle y Sybase.
 --->

<cfif session.menues.SSCODIGO EQ 'IND'>
	<cfset botones="Nuevo, Importar">
	<cfset Action="CFuncional.cfm">
<cfelse>
	<cfset botones="Nuevo">
	<cfset Action="CFuncional-lista.cfm">	
</cfif>
<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
<cfinvoke component="mig.Componentes.Translate"
method="Translate"
Key="LB_ModuloIndicadores"
Default="Modulo Indicadores"
XmlFile="/rh/generales.xml"
returnvariable="LB_ModuloIndicadores"/>
<cf_templateheader title="#LB_ModuloIndicadores#">

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

	  <cfinclude template="../Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

	<cfinvoke component="mig.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeCentrosFuncionales"
		Default="Lista de Centros Funcionales"
		returnvariable="LB_ListaDeCentrosFuncionales"/>
	
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_ListaDeCentrosFuncionales#">
	  					
		<cfinclude template="../portlets/pNavegacion.cfm">
		<cfif isdefined("url.CFcodigof") and len(trim(url.CFcodigof))NEQ 0>
			<cfset form.CFcodigof=url.CFcodigof> 
		</cfif>
					
		<cfif isdefined("url.CFdescripcionf") and len(trim(url.CFdescripcionf))NEQ 0>
			<cfset form.CFdescripcionf=url.CFdescripcionf> 
		</cfif>
					
		<cfif isdefined("url.Ocodigof") and len(trim(url.Ocodigof))NEQ 0>
			<cfset form.Ocodigof=url.Ocodigof> 
		</cfif>
		<cfif isdefined("url.Dcodigof") and len(trim(url.Dcodigof))NEQ 0>
			<cfset form.Dcodigof=url.Dcodigof> 
		</cfif>
					
		<cfset navegacion = "">
					
		<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
			<cfset navegacion = navegacion  &  "CFcodigof="&form.CFcodigof>			
		</cfif>
					
		<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "CFdescripcionf="&form.CFdescripcionf>
				<cfelse> 	
					<cfset navegacion = navegacion & "CFdescripcionf="&form.CFdescripcionf>
			</cfif> 
		</cfif>
					
		<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Ocodigof="&form.Ocodigof>
				<cfelse> 	
					<cfset navegacion = navegacion & "Ocodigof="&form.Ocodigof>
			</cfif> 
		</cfif>
					
		<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
			<cfif len(trim(navegacion)) NEQ 0>	
					<cfset navegacion = navegacion & iif(len(trim(navegacion)),DE("&"),DE("?")) &  "Dcodigof="&form.Dcodigof>
				<cfelse> 	
					<cfset navegacion = navegacion & "Dcodigof="&form.Dcodigof>
			</cfif>
		</cfif>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	  					
					<table width="100%">
						<tr>
							<td class="tituloListas">
								<form name="form1" method="post" action="<cfoutput>#Action#</cfoutput>">
									<table width="100%">
										<tr>
											<td><cf_translate key="LB_Codigo" XmlFile="/mig/generales.xml">Código</cf_translate></td>
											<td><cf_translate key="LB_Descripcion" XmlFile="/mig/generales.xml">Descripción</cf_translate></td>
											<td><cf_translate key="LB_Oficina" XmlFile="/mig/generales.xml">Oficina</cf_translate></td>
											<td><cf_translate key="LB_Departamento" XmlFile="/mig/generales.xml">Departamento</cf_translate></td>
											<td></td>
										</tr>
										<tr>
											<td>
												<input name="CFcodigof" type="text" size="8" maxlength="10" tabindex="1"
													value="<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0><cfoutput>#form.CFcodigof#</cfoutput></cfif>"/>
											</td>
											<td>
												<input name="CFdescripcionf" type="text"  size="30" maxlength="60" tabindex="1"
													value="<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0><cfoutput>#form.CFdescripcionf#</cfoutput></cfif>"/>
											</td>
											<td>
												<cfquery name="rsOficinas" datasource="#session.DSN#">
												select Ocodigo, Oficodigo, Odescripcion  as  Odescripcion
												from Oficinas where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
												</cfquery>
												<select name="Ocodigof" tabindex="1">
													<option value=""></option>
													<cfloop query="rsOficinas">
														<option value="<cfoutput>#rsOficinas.Ocodigo#</cfoutput>" <cfif isdefined("form.Ocodigof") and form.Ocodigof EQ rsOficinas.Ocodigo> selected </cfif>><cfoutput>#rsOficinas.Oficodigo# - #rsOficinas.Odescripcion#</cfoutput></option>
													</cfloop>
												</select>								</td>
											<td>
												<cfquery name="rsDeptos" datasource="#session.DSN#">
												select Dcodigo, Deptocodigo, Ddescripcion 
												from Departamentos where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
												</cfquery>
												<select name="Dcodigof" tabindex="1">
													<option value=""></option>
													<cfloop query="rsDeptos">
														<option value="<cfoutput>#rsDeptos.Dcodigo#</cfoutput>" <cfif isdefined("form.Dcodigof") and form.Dcodigof EQ rsDeptos.Dcodigo> selected </cfif>><cfoutput>#rsDeptos.Deptocodigo# - #rsDeptos.Ddescripcion#</cfoutput></option>
													</cfloop>
												</select>								
											</td>
											<td>
												<cfinvoke component="mig.Componentes.Translate"
													method="Translate"
													Key="BTN_Filtro"
													Default="Filtro"
													returnvariable="BTN_Filtro"/>
	
												<input name="BTNfiltro" type="submit" value="<cfoutput>#BTN_Filtro#</cfoutput>" tabindex="1">
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
								
						<tr>
							<td>
									
								<cfquery name="rsCentros" datasource="#session.DSN#" >
								select distinct 
								a.CFid as CFpk,
								a.CFcodigo,
								a.CFdescripcion,  
								b.Oficodigo #_Cat# '-' #_Cat# b.Odescripcion as Oficina,  
								c.Deptocodigo #_Cat# '-'#_Cat# c.Ddescripcion as Depto,
								'<img border=''0'' src=''/cfmx/rh/imagenes/' #_Cat# (case a.CFcorporativo when 0 then 'un' else null end)  #_Cat# 'checked.gif''>'  as CFcorporativo, 
								a.CFid as primero,
								a.CFpath,
								a.CFnivel
											
									 <cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
										,<cfqueryparam cfsqltype="cf_sql_char" value="#form.CFcodigof#"> as CFcodigof
									</cfif>
											
									<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CFdescripcionf#"> as CFdescripcionf
									</cfif>
											
									<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
										,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigof#"> as Ocodigof
									</cfif>
											
									<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
										,<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigof#"> as Dcodigof
									</cfif>
											
								from  CFuncional a
											
								inner join Oficinas b
									on  b.Ocodigo=a.Ocodigo
									and b.Ecodigo=a.Ecodigo
											
								inner join	Departamentos c
									on c.Dcodigo=a.Dcodigo
									and  c.Ecodigo=a.Ecodigo
												
								where a.Ecodigo =  #session.Ecodigo# 
											
								<cfif isdefined("form.CFcodigof") and len(trim(form.CFcodigof))NEQ 0>
									and ltrim(rtrim(upper(a.CFcodigo))) like '%#trim(ucase(form.CFcodigof))#%'
								</cfif>
											
								<cfif isdefined("form.CFdescripcionf") and len(trim(form.CFdescripcionf))NEQ 0>
									and ltrim(rtrim(upper(a.CFdescripcion))) like '%#trim(ucase(form.CFdescripcionf))#%'
								</cfif>
											
								<cfif isdefined("form.Ocodigof") and len(trim(form.Ocodigof))NEQ 0>
									and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigof#">
								</cfif>
											
								<cfif isdefined("form.Dcodigof") and len(trim(form.Dcodigof))NEQ 0>
									and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Dcodigof#">
								</cfif>
											
								order by a.CFpath, a.CFcodigo, a.CFnivel
								</cfquery>
								<cfinvoke component="mig.Componentes.Translate"
									method="Translate"
									Key="LB_Codigo"
									Default="C&oacute;digo"
									returnvariable="LB_Codigo"/>
								<cfinvoke component="mig.Componentes.Translate"
									method="Translate"
									Key="LB_Descripcion"
									Default="Descripción"
									returnvariable="LB_Descripcion"/>
								<cfinvoke component="mig.Componentes.Translate"
									method="Translate"
									Key="LB_Oficina"
									Default="Oficina"
									returnvariable="LB_Oficina"/>
								<cfinvoke component="mig.Componentes.Translate"
									method="Translate"
									Key="LB_Departamento"
									Default="Departamento"
									returnvariable="LB_Departamento"/>
								<cfinvoke component="mig.Componentes.Translate"
									method="Translate"
									Key="LB_Corporativo"
									Default="Corporativo"
									returnvariable="LB_Corporativo"/>
								<cfinvoke
								Component= "commons.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsCentros#"/>
									<cfinvokeargument name="desplegar" value="CFcodigo,CFdescripcion,Oficina,Depto,CFcorporativo"/>
									<cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,#LB_Oficina#,#LB_Departamento#,#LB_Corporativo#"/>
									<cfinvokeargument name="formatos" value="V,V,V,V,IMAG"/>
									<cfinvokeargument name="align" value="left,left,left,left,center"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="/cfmx/mig/catalogos/CFuncional.cfm"/>
									<cfinvokeargument name="keys" value="CFpk"/>
									<cfinvokeargument name="botones" value="#botones#"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="maxrows" value="25"/> 	
								</cfinvoke>
							</td>
						</tr>
					</table>
				</td>	
			</tr>
		</table>	
<cf_web_portlet_end>
<cf_templatefooter>
<script language="JavaScript" type="text/JavaScript">
	function funcImportar(){
		location.href="/cfmx/mig/catalogos/CFuncional.cfm?importa=true";
		return false;
	}
</script>