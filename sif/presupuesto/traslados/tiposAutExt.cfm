<cf_templateheader title="Tipos de Autorización Externa">
	<cf_web_portlet_start titulo="Tipos de Autorización Externa">

		<cf_navegacion name="Ecodigo"	default="#session.Ecodigo# " navegacion="">
		<cf_navegacion name="CPTAEid"	default="" navegacion="">
		<table width="100%" align="center">
			<tr>
				<td width="48%" valign="top">
					<cfquery name="rsLista" datasource="#session.dsn#">
						select 
							CPTAEid,
							Ecodigo, 
							CPTAEcodigo,
							CPTAEdescripcion,
							BMUsucodigo 
						from CPtipoAutExterna
						where Ecodigo=#session.Ecodigo# 
					</cfquery>
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
						query="#rsLista#"
						columnas="CPTAEid,CPTAEcodigo,CPTAEdescripcion"
						desplegar="CPTAEcodigo,CPTAEdescripcion"
						etiquetas="Código, Tipo de Autorización Externa"
						formatos="S,S"
						align="left,left"
						ira="tiposAutExt.cfm"
						form_method="post"	
						showEmptyListMsg="yes"
						keys="CPTAEid"
						incluyeForm="yes"
						formName="formLista1"
						PageIndex="2"
						MaxRows="8"
					/>
				</td>
				<td width="48%" valign="top">
					<cfinclude template="tiposAutExt_form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
