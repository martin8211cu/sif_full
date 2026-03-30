<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<cfoutput>#pNavegacion#</cfoutput>
			<table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">

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
				
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL LISTA DE VALORES--->
				<cfif isdefined("url.Pagina2") and len(trim(url.Pagina2))>
					<cfset form.Pagina2 = url.Pagina2>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
				<cfif isdefined("url.PageNum_Lista2") and len(trim(url.PageNum_Lista2))>
					<cfset form.Pagina2 = url.PageNum_Lista2>
				</cfif>
				<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
				<cfif isdefined("form.PageNum2") and len(trim(form.PageNum2))>
					<cfset form.Pagina2 = form.PageNum2>
				</cfif>
				
				<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo)) and not isdefined("form.Ccodigo")>
					<cfset form.Ccodigo = url.Ccodigo >
				</cfif>
				<cfif isdefined("url.CDcodigo") and len(trim(url.CDcodigo)) and not isdefined("form.CDcodigo")>
					<cfset form.CDcodigo = url.CDcodigo >
				</cfif>

				<tr> 
					<td valign="top" width="50%" >
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="15">
						<cfset navegacion = "">
						<cfset navegacion = "&Ccodigo=#form.Ccodigo#">
						<cfif isdefined('form.CDcodigo')>
						<cfset navegacion = navegacion &"&CDcodigo=#form.CDcodigo#">
						</cfif>
						<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaRH"
						returnvariable="pListaRet"> 
							<cfinvokeargument name="tabla" value="ClasificacionesDato"/> 
							<cfinvokeargument name="columnas" value="CDcodigo, Ccodigo, CDdescripcion"/> 
							<cfinvokeargument name="desplegar" value="CDdescripcion"/> 
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n"/> 
							<cfinvokeargument name="formatos" value=""/> 
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# 
																	and Ccodigo=#form.Ccodigo# 
																	order by CDdescripcion"/> 
							<cfinvokeargument name="align" value="left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="ClasificacionesDato.cfm"/> 
							<cfinvokeargument name="keys" value="CDcodigo"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="MaxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke> 
					</td>
					<td valign="top" width="50%"><cfinclude template="formClasificacionesDato.cfm"></td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>