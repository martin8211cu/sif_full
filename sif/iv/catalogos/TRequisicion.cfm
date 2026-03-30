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
<cfif isdefined('url.filtro_TRdescripcion') and not isdefined('form.filtro_TRdescripcion')>
	<cfset form.filtro_TRdescripcion = url.filtro_TRdescripcion>
</cfif>
<cfif isdefined('url.TRcodigo') and not isdefined('form.TRcodigo')>
	<cfset form.TRcodigo = url.TRcodigo>
</cfif>
<cfif isdefined('url.Empresa') and not isdefined('form.Empresa')>
	<cfset form.Empresa = url.Empresa>
</cfif>								

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">	
	
<cf_templateheader title="Inventarios">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de requisici&oacute;n'>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0">
			<tr> 
				<td valign="top" width="40%">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH"returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 			  value="TRequisicion"/>
						<cfinvokeargument name="columnas" 		  value="Ecodigo as Empresa, TRcodigo, TRdescripcion, case when TRreversaCreditoFiscal = 1 then 'Reversar' else 'Mantener' end as Reversar"/> 
						<cfinvokeargument name="desplegar"		  value="TRdescripcion, Reversar"/> 
						<cfinvokeargument name="etiquetas" 		  value="Tipo de Requisici&oacute;n, Credito Fiscal"/> 
						<cfinvokeargument name="formatos"		  value="V,V"/> 
						<cfinvokeargument name="filtro" 		  value="Ecodigo = #Session.Ecodigo# Order by TRdescripcion"/> 
						<cfinvokeargument name="align" 			  value="left,center"/> 
						<cfinvokeargument name="ajustar"          value="N,N"/> 
						<cfinvokeargument name="checkboxes" 	  value="N,N"/> 
						<cfinvokeargument name="irA" 			  value="TRequisicion.cfm"/> 
						<cfinvokeargument name="showEmptyListMsg" value="true"/>
						<cfinvokeargument name="keys" 			  value="Empresa,TRcodigo"/> 
						<cfinvokeargument name="debug" 			  value="N"/>
						<cfinvokeargument name="maxRows" 		  value="#form.MaxRows#"/>	
						<cfinvokeargument name="mostrar_filtro"   value="false"/>
						<cfinvokeargument name="filtrar_automatico" value="false"/>																													
					</cfinvoke>									
				</td>
				<td valign="top" width="60%">
					<cfinclude template="formTRequisicion.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>