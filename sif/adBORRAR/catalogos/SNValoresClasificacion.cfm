<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2">
						<cfif isdefined('url.PCEcatid') and not isdefined('form.PCEcatid')>
							<cfset form.PCEcatid= url.PCEcatid >
						</cfif>
						<cfif isdefined('url.SNCEid') and not isdefined('form.SNCEid')>
							<cfset form.SNCEid= url.SNCEid >
						</cfif>
					</td>
				</tr>
              	<tr>
					<td width="49%" valign="top"> 
					  <!---  VARIABLE LLAVE PARA CUANDO VIENE DEL SQL --->
						<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
							<cfset form.SNCEid = url.SNCEid>
						</cfif>
						<cfif isdefined("url.SNCDid") and len(trim(url.SNCDid))>
							<cfset form.SNCDid = url.SNCDid>
						</cfif>
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
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="15">
						<cfif not isdefined("Form.SNCEid")>
							<cflocation addtoken="no" url="SNClasificaciones.cfm">
						</cfif>
						<cfquery name="rsAct" datasource="#session.DSN#">
							select -1 as value, 'Todos' as description from dual
                            union
                            select 0 as value, 'Inactivo' as description from  dual
                            union
                            select 1 as value, 'Activo' as description from dual
                            order by 1
						</cfquery>
						<cfset navegacion = "">
						<cfif isdefined('form.SNCEid') and LEN(TRIM(form.SNCEid))>
							<cfset navegacion = navegacion & "&SNCEid=" & form.SNCEid>
						</cfif>
						<cfif isdefined('form.PCEcatid') and LEN(TRIM(form.PCEcatid))>
							<cfset navegacion = navegacion & "&PCEcatid=" & form.PCEcatid>
						</cfif>
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
							tabla="SNClasificacionD a, SNClasificacionE b" 
							columnas="a.SNCDid, a.SNCDvalor, a.SNCEid, a.SNCDdescripcion, 
									  b.SNCEdescripcion, b.PCEcatid, PCDcatid, 
									  case when a.SNCDactivo = 1 then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>' else '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>' end as Activo" 
							desplegar="SNCDvalor, SNCDdescripcion, Activo"
							etiquetas="Valor,Descripción, Activo"
							formatos=""
							filtro="a.SNCEid = #Form.SNCEid# and a.SNCEid = b.SNCEid"
							align="left, left, center"
							checkboxes="N"
							ira="SNValoresClasificacion.cfm"
							keys="SNCDid"
							maxrows="#form.maxrows#"
							>
						</cfinvoke>
					</td>
					<td width="50%"><cfinclude template="formSNValoresClasificacion.cfm"></td>
              	</tr>
              	<tr><td>&nbsp;</td></tr>
              	<tr><td>&nbsp;</td></tr>
            </table>
		<cf_templatefooter>
<cf_templatefooter>
