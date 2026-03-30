<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>	
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Catálogo de Rendición'>
<cf_templatecss>
<cfif isdefined('url.COTRid')>
	<cfset form.COTRid= url.COTRid>
	<cfset form.modo='CAMBIO'>
</cfif>	


<!---<cfif isdefined("form.FCOTRCodigo") and len(trim(form.FCOTRCodigo)) gt 0 >
	<cfset filtro = filtro & "and COTRCodigo like '%#form.FCOTRCodigo#%'">
</cfif>
<cfif isdefined("form.FCOTRDescripcion") and len(trim(form.FCOTRDescripcion)) gt 0 >
	<cfset filtro = filtro & "and upper(COTRDescripcion) like upper('%#form.FCOTRDescripcion#%')">
</cfif>--->

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
			<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
				<cfset form.Pagina = url.Pagina>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
			<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
				<cfset form.Pagina = url.PageNum_Lista>
			</cfif>
			<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
			<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
				<cfset form.Pagina = form.PageNum>
			</cfif>
			<cfif isdefined('url.FCOTRCodigo')  and not isdefined('form.FCOTRCodigo')>
				<cfset form.ESNid = url.ESNid>
			</cfif>
			<cfif isdefined('url.FCOTRDescripcion') and not isdefined('form.FCOTRDescripcion')>
				<cfset form.FCOTRDescripcion = url.FCOTRDescripcion>
			</cfif>			
			
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="10">



<table width="100%" border="0" cellspacing="0" cellpadding="3">
<tr>	
	<td valign="top" width="50%"> 
		<cfinvoke component="sif.Componentes.pListas" 
		method="pListaRH"	 
		returnvariable="pListaTran">
		<cfinvokeargument name="tabla" value="COTipoRendicion"/>
		<cfinvokeargument name="columnas" value="COTRCodigo, COTRDescripcion, ' ' as nada, case when COTRGenDeposito = 0 then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' end as COTRGenDeposito, COTRid, case when COTRmodificar = 0 then  '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'  else  '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' end as COTRmodificar "/>
		<cfinvokeargument name="desplegar" value="COTRCodigo, COTRDescripcion, COTRGenDeposito, COTRmodificar"/>
		<cfinvokeargument name="etiquetas" value="Código, Descripción, Genera Deposito, Modificable"/>
		<cfinvokeargument name="formatos" value="S,S,U,U"/>		
		<cfinvokeargument name="showEmptyListMsg" value= "1"/>
		<!--- <cfinvokeargument name="filtro" value="CEcodigo=#session.CEcodigo# order by SNCidentificacion"/> --->
		<cfinvokeargument name="align" value="left, left, center, center"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="keys" value="COTRid"/>
		<cfinvokeargument name="irA" value="TiposDeRendicion.cfm"/>
		<cfinvokeargument name="mostrar_filtro" value="true"/>
		<cfinvokeargument name="filtrar_automatico" value="true"/>
		<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by COTRCodigo"/>
		<cfinvokeargument name="filtrar_por" value="COTRCodigo, COTRDescripcion,COTRGenDeposito,COTRmodificar"/>
		<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
		</cfinvoke> 
	</td>
	<td width="50%" valign="top"><cfinclude template="TiposDeRendicion-form.cfm"></td>	
</tr>  

</table>
<cf_web_portlet_end>	
<cf_templatefooter>
	
	
