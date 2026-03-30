<cf_templateheader title="Compras -  Tipos de Orden de Compra">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Tipos de Orden de Compra'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="../../portlets/pNavegacion.cfm"> 
				</td>
			</tr>
			<tr> 
				<td valign="top" width="60%" style="padding-right: 10px;"> 
					<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
					<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >
					<cfquery name="rsLista" datasource="#session.DSN#">
						select CMTOcodigo, CMTOdescripcion, 
							   case CMTgeneratracking when 1 then '#checked#' else '#unchecked#' end as tracking,
							   case CMTOimportacion when 1 then '#checked#' else '#unchecked#' end as tipoimportacion,
							   case CMTOte when 1 then '#checked#' else '#unchecked#' end as tiempoentrega,
							   case CMTOtransportista when 1 then '#checked#' else '#unchecked#' end as transportista,
							   case CMTOtipotrans when 1 then '#checked#' else '#unchecked#' end as tipotransporte,
							   case CMTOincoterm when 1 then '#checked#' else '#unchecked#' end as incoterm,
							   case CMTOlugarent when 1 then '#checked#' else '#unchecked#' end as lugarentrega
						from CMTipoOrden
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						order by CMTOcodigo
					</cfquery>

					<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet"> 
						<cfinvokeargument name="query" value="#rsLista#"/> 
						<cfinvokeargument name="desplegar" value="CMTOcodigo, CMTOdescripcion, tracking, tipoimportacion, tiempoentrega, transportista, tipotransporte, incoterm, lugarentrega"/> 
						<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Genera Tracking, Importaci&oacute;n, TE, T, TT, ICT, LE"/>
						<cfinvokeargument name="formatos" value=""/> 
						<cfinvokeargument name="align" value="left,left,center,center,center,center,center,center,center"/> 
						<cfinvokeargument name="ajustar" value="N"/> 
						<cfinvokeargument name="checkboxes" value="N"/> 
						<cfinvokeargument name="irA" value="TiposOrdenCompra.cfm"/> 
						<cfinvokeargument name="keys" value="CMTOcodigo"/> 
					</cfinvoke> 
				</td>
				<td valign="top" width="40%">
					<cfinclude template="TiposOrdenCompra-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>