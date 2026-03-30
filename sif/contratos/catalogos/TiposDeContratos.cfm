<!--- JMRV. Inicio 07/08/2014 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cgo" Default= "C&oacute;digo" XmlFile="TipoContrato.xml" returnvariable="LB_Cgo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Dscn" Default= "Descripci&oacute;n" XmlFile="TipoContrato.xml" returnvariable="LB_Dscn"/>

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
<cfset navegacion= "">
<cfif isdefined("url.CTTCcodigo") and not isdefined("form.CTTCcodigo")>
	<cfset form.CCTcodigo = url.CTTCcodigo >
</cfif>
<cfif isdefined('form.CCTcodigo') and LEN(TRIM(form.CCTcodigo))>
	<cfset navegacion = "CTTCcodigo=" & form.CCTcodigo>
</cfif>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<!--- Filtro para la busqueda --->

<cf_templateheader title="Tipos de Contratos">
<cf_web_portlet_start titulo="Tipos de Contratos">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<table width="95%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top" width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
				<cfinvokeargument name="tabla" 		value="CTTipoContrato"/>
				<cfinvokeargument name="columnas" 	value="CTTCid,CTTCcodigo,CTTCdescripcion"/>
				<cfinvokeargument name="desplegar" 	value="CTTCcodigo,CTTCdescripcion"/>
				<cfinvokeargument name="etiquetas" 	value="#LB_Cgo#, #LB_Dscn#"/>
				<cfinvokeargument name="formatos" 	value="S,S"/>
				<cfinvokeargument name="filtro" 	value=""/>
				<cfinvokeargument name="align" 		value="left, left, left"/>
				<cfinvokeargument name="ajustar" 	value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" 		value="CTTCid"/>
				<cfinvokeargument name="irA"	 	value="TiposDeContratos.cfm"/>
				<cfinvokeargument name="maxRows" 	value="#form.MaxRows#"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</td>
		<td><cfinclude template="TiposDeContratos-form.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
