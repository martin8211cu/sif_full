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
<cfif isdefined('url.filtro_Cdescripcion') and not isdefined('form.filtro_Cdescripcion')>
	<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion>
</cfif>								
<cfif isdefined('url.TRcodigo') and not isdefined('form.TRcodigo')>
	<cfset form.TRcodigo = url.TRcodigo>
</cfif>
<cfif isdefined('url.Dcodigo') and not isdefined('form.Dcodigo')>
	<cfset form.Dcodigo = url.Dcodigo>
</cfif>																
<cfif isdefined('url.Empresa') and not isdefined('form.Empresa')>
	<cfset form.Empresa = url.Empresa>
</cfif>								

<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="25">	

<cf_templateheader title="Inventarios">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cuentas por Requisici&oacute;n'>
			<table width="100%"  border="0" cellpadding="0" cellspacing="0">
			  <tr> 
					<td valign="top" width="50%">								
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="CTipoRequisicion a 
																inner join CContables b
																on a.Ccuenta = b.Ccuenta 
																and a.Ecodigo=b.Ecodigo
																
																inner join Departamentos d
																on a.Dcodigo=d.Dcodigo 
																   and a.Ecodigo=d.Ecodigo 
										
																inner join TRequisicion tr
																on a.TRcodigo=tr.TRcodigo 
																  and a.Ecodigo=tr.Ecodigo "/>
							<cfinvokeargument name="columnas" value="a.Ecodigo as Empresa
																	, a.Dcodigo
																	, a.TRcodigo
																	, Ddescripcion as Ddescripcion
																	, TRdescripcion
																	, b.Cdescripcion"/> 
							<cfinvokeargument name="desplegar" value="TRdescripcion, Cdescripcion"/> 
							<cfinvokeargument name="etiquetas" value="Requisici&oacute;n, Cuenta"/> 
							<cfinvokeargument name="formatos" value="V,V"/> 
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo#
																	order by Ddescripcion"/> 
							<cfinvokeargument name="align" value="left, left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="CTipoRequisicion.cfm"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="Empresa,TRcodigo,Dcodigo"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="Cortes" value="Ddescripcion"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>																													
						</cfinvoke>	
					</td>
					<td width="50%" valign="top">
						<cfinclude template="formCTipoRequisicion.cfm">
					</td>
				</tr>
			</table>
		 <cf_web_portlet_end>
<cf_templatefooter>