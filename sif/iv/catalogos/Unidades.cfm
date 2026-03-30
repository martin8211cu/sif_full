
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
<!---	<cfdump var="#url.Pagina#">
    <cf_dump var="VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL = url.Pagina">--->
	<cfset form.Pagina = url.Pagina>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfdump var="#url.PageNum_Lista#">
    <cf_dump var="VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION = url.PageNum_Lista">
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
<!---	<cfdump var="#form.PageNum#">
    <cf_dump var="VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA = form.PageNum">--->
	<cfset form.Pagina = form.PageNum>
</cfif>		
<cfif isdefined('url.filtro_Ucodigo') and not isdefined('form.filtro_Ucodigo')>
	<cfset form.filtro_Ucodigo = url.filtro_Ucodigo>
</cfif>
<cfif isdefined('url.filtro_Udescripcion') and not isdefined('form.filtro_Udescripcion')>
	<cfset form.filtro_Udescripcion = url.filtro_Udescripcion>
</cfif>
<cfif isdefined('url.filtro_Uequivalencia') and not isdefined('form.filtro_Uequivalencia')>
	<cfset form.filtro_Uequivalencia = url.filtro_Uequivalencia>
</cfif>
<cfif isdefined('url.Ucodigo') and not isdefined('form.Ucodigo')>
	<cfset form.Ucodigo = url.Ucodigo>
</cfif>					
<cfif isdefined('url.Empresa') and not isdefined('form.Empresa')>
	<cfset form.Empresa = url.Empresa>
</cfif>					

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">					

<cf_templateheader title="	Inventarios">
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Unidades'>
        	
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td valign="top" width="40%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="Unidades"/>
							<cfinvokeargument name="columnas" value="Ecodigo as Empresa
																	, Ucodigo
																	, Udescripcion
																	, Uequivalencia
																	, '' as espacio"/> 
							<cfinvokeargument name="desplegar" value="Ucodigo, Udescripcion, Uequivalencia, espacio"/> 
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Equivalencia, "/>
							<cfinvokeargument name="formatos" value="V,V,M,U"/> 									
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
																	order by Udescripcion"/> 
							<cfinvokeargument name="align" value="left,left,Right,left"/>
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="Unidades.cfm"/> 									
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="Empresa,Ucodigo"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_por" value="Ucodigo, Udescripcion, Uequivalencia,''"/>									
							<cfinvokeargument name="filtrar_automatico" value="true"/>																											
						</cfinvoke>
					</td>
					<td width="60%" valign="top">
						<cfinclude template="formUnidades.cfm">
					</td>
				</tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>