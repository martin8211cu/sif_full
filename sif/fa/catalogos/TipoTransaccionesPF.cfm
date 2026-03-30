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
			<cfset navegacion= "">
			<cfif isdefined("url.PFTcodigo") and not isdefined("form.PFTcodigo")>
				<cfset form.PFTcodigo = url.PFTcodigo >
			</cfif>
			<!---<cfif isdefined('form.CCTcodigo') and LEN(TRIM(form.CCTcodigo))>
				<cfset navegacion = "PFTcodigo=" & form.PFTcodigo>
			</cfif>--->
			<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
			<cfparam name="form.Pagina" default="1">
			<cfparam name="form.MaxRows" default="15">
			<table width="95%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
							<cfinvokeargument name="tabla" value="FAPFTransacciones"/>
							<cfinvokeargument name="columnas" value="PFTcodigo,PFTdescripcion,PFTtipo"/>
							<cfinvokeargument name="desplegar" value="PFTcodigo,PFTdescripcion,PFTtipo"/>
							<cfinvokeargument name="etiquetas" value="Transacción, Descripción, Tipo"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="Ecodigo=#session.Ecodigo# order by PFTcodigo"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="keys" value="PFTcodigo"/>
							<cfinvokeargument name="irA" value="TipoTransaccionesPF.cfm"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>
						</cfinvoke> 
					</td>
					<td><cfinclude template="formTipoTransaccionesPF.cfm"></td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
								
		<cf_web_portlet_end>		
	<cf_templatefooter>