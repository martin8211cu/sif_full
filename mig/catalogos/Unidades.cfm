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

<cf_templateheader title="	Unidades">
	<cfinclude template="../portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Unidades'>	
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr> 
					<td valign="top" width="40%">
						<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="Unidades"
						columnas="Ucodigo, Udescripcion, Uequivalencia"
						desplegar="Ucodigo, Udescripcion, Uequivalencia"
						etiquetas="C&oacute;digo, Descripci&oacute;n, Equivalencia"
						formatos="S,S,S"
						filtro="Ecodigo=#session.Ecodigo#  order by Ucodigo"
						align="left,left,left"
						checkboxes="N"
						keys="Ucodigo"
						MaxRows="15"
						pageindex="1"
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="Ucodigo, Udescripcion,Uequivalencia"
						ira="Unidades.cfm">
					</td>
					<td width="60%" valign="top">
						<cfinclude template="formUnidades.cfm">
					</td>
				</tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>