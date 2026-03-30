<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_templateheader title="Activos Fijos">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Clasificaci&oacute;n de Activos'>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="40%" valign="top">
			<cfif isdefined("Url.ACcodigo") >
				<cfset Form.ACcodigo = Url.ACcodigo>
			</cfif>
			<cfif isdefined("Form.ACcodigo")>
				<cfset navegacion = "&ACcodigo=#Form.ACcodigo#">
			<cfelse>
				<cflocation addtoken="no" url="ACategoria.cfm">
			</cfif>
			<cfset checked = "<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>">
			<cfset unchecked = "<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>">			
			<cfset tabla = "AClasificacion">
			<cfset columnas = "
				ACcodigo, 
				ACid, 
				ACcodigodesc #_Cat#' ' #_Cat# ACdescripcion as descrip, 
				case ACdepreciable when 'S' then '#checked#' else '#unchecked#' end as ACdepreciable, 
				case ACrevalua when 'S' then '#checked#' else '#unchecked#' end as ACrevalua">
			<cfset filtro = 
				"Ecodigo = #session.Ecodigo# and ACcodigo = #Form.ACcodigo# Order By ACcodigodesc">
			<cfinvoke
			 component="sif.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet"
				tabla="#tabla#"
				columnas="#columnas#"
				desplegar="descrip, ACdepreciable, ACrevalua,"
				etiquetas="Clasificaci&oacute;n, Dep., Rev."
				filtro="#filtro#"
				formatos="S,U,U"
				align="left, center, center"
				checkboxes="N"
				keys="ACcodigo, ACid"
				filtrar_automatico="true"
				mostrar_filtro="true"
				filtrar_por="ACcodigodesc #_Cat# ' ' #_Cat# ACdescripcion,&nbsp;,&nbsp;"
				ajustar="N"
				maxrows="35"
				pageindex="2"
				navegacion="#navegacion#"
				irA="AClasificacion.cfm">
			<cfoutput>
			<script language="javascript1.2" type="text/javascript">
				function funcFiltrar2() {
					document.lista.ACCODIGO.value = "#form.ACcodigo#";
					return true;
				}
			</script>
			</cfoutput>							
		</td> 
		<td valign="top"><cfinclude template="formAClasificacion.cfm"></td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter> 
	