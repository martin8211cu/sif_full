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
			<cfif isdefined('url.ESNid')  and not isdefined('form.ESNid')>
				<cfset form.ESNid = url.ESNid>
			</cfif>
			<cfif isdefined('url.filtro_GSNcodigo') and not isdefined('form.filtro_GSNcodigo')>
				<cfset form.filtro_GSNcodigo = url.filtro_GSNcodigo>
			</cfif>
			<cfif isdefined('url.filtro_GSNdescripcion') and not isdefined('form.filtro_GSNdescripcion')>
				<cfset form.filtro_GSNdescripcion = url.filtro_GSNdescripcion>
			</cfif>
	
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="10">
			<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr> 
					<td valign="top" width="50%">
						<cfinvoke component="sif.Componentes.pListas" 
						method="pListaRH"	 
						returnvariable="pListaTran">
							<cfinvokeargument name="tabla" value="GrupoSNegocios"/>
							<cfinvokeargument name="columnas" value="GSNid, GSNcodigo, GSNdescripcion"/>
							<cfinvokeargument name="desplegar" value="GSNcodigo,GSNdescripcion"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by GSNcodigo"/>
							<cfinvokeargument name="align" value="left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" value="GSNid"/>
							<cfinvokeargument name="irA" value="GrupoSocios.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value= "1"/>
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
						</cfinvoke> 
					</td>
					<td valign="top" width="50%"><cfinclude template="GrupoSocios-form.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr> 
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>
