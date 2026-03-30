<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>

	<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		
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
	
			<cfif isdefined("url.Rcodigo") and not isdefined("form.Rcodigo")>
				<cfset form.Rcodigo = url.Rcodigo >
			</cfif>
			<cfif isdefined('url.Empresa') and not isdefined('form.Empresa')>
				<cfset form.Empresa = url.Empresa>
			</cfif>
			

			<table width="95%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%">
						<cfset navegacion = '' >
						<cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo))>
							<cfset navegacion = navegacion &'&Rcodigo=#form.Rcodigo#' >
						</cfif>
						<cfif isdefined("form.Empresa") and len(trim(form.Empresa))>
							<cfset navegacion = navegacion &'&Empresa=#form.Empresa#' >
						</cfif>
						<cfset campos_extra = '' >
						<cfif isdefined("form.pagenum_lista")>
							<cfset campos_extra = ",'#form.pagenum_lista#' as pagenum_lista" >
						</cfif>
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="15">

						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							returnvariable="pListaReten">
							<cfinvokeargument name="tabla" value="Retenciones"/>
							<cfinvokeargument name="columnas" value="Rcodigo, Rdescripcion,Rporcentaje,Ecodigo as Empresa #preservesinglequotes(campos_extra)#"/>
							<cfinvokeargument name="desplegar" 	value="Rcodigo, Rdescripcion,Rporcentaje"/>
							<cfinvokeargument name="etiquetas"	value="Retención, Descripción, Porcentaje"/>
							<cfinvokeargument name="formatos" value="S,S,U"/>
							<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by Rcodigo"/>
							<cfinvokeargument name="align" 		value="left, left, left"/>
							<cfinvokeargument name="ajustar" 	value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" 		value="Retenciones.cfm"/>
							<cfinvokeargument name="keys" 		value="Empresa,Rcodigo"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>							
							<cfinvokeargument name="filtrar_por" value="Rcodigo,Rdescripcion,''"/>
						</cfinvoke> 
					</td>
					<td valign="top"><cfinclude template="formRetenciones.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>

<cf_web_portlet_end>
<cf_templatefooter>