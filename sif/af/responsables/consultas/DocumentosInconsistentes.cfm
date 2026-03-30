<!---*********************************
	Módulo    : Control de Reponsables
	Nombre   : Reporte de Documentos Inconsistentes
	Descripción : Muestra una consulta de todos los vales inconsistentes para un centro de custodia.
	***********************************
	Hecho por: Steve Vado Rodríguez
	Creado    : 20/04/2006
	***********************************
	Modificado por: Dorian Abarca Gómez
	Modificado: 18 Julio 2006
	Moficaciones:
	1. Se modifica para que se imprima y baje a excel con el cf_htmlreportsheaders.
	2. Se verifica uso de jdbcquery.
	3. Se verifica uso de cf_templateheader y cf_templatefooter.
	4. Se verifica uso de cf_web_portlet_start y cf_web_portlet_end.
	5. Se agrega cfsetting y cfflush.
	6. Se envían estilos al head por medio del cfhtmlhead.
	7. Se mantienen filtros de la consulta.
	***************************** --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>
		<form name="form1" action="DocumentosInconsistentesRep.cfm" method="post">
		<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td valign="top"width="20%"> 
					<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
					<div align="center">
						<p align="justify">
							Muestra una consulta de todos los vales inconsistentes para un centro de custodia.
						</p>
					</div>
					<cf_web_portlet_end> 
				</td>
				<td width="5%">&nbsp;</td>
				<td width="75%">
					<fieldset><legend>Filtros para el Reporte</legend>
					<table width="100%" border="0">
						<tr>
							<td nowrap>Centro de Custodia:</td>
							<td>
								<cfquery name="rsCRCC" datasource="#Session.Dsn#">
									select a.CRCCid as value,<cf_dbfunction name="concat" args="rtrim(a.CRCCcodigo) ,' - ',rtrim(a.CRCCdescripcion)"> as description
									from CRCentroCustodia a
									where a.Ecodigo = #Session.Ecodigo# 
									order by a.CRCCcodigo
								</cfquery>
								<select name="CRCCid" id="CRCCid" tabindex="1">
								<cfloop query="rsCRCC">	
									<option value="#value#" <cfif isdefined("form.CRCCid") and form.CRCCid eq value>selected</cfif>>#description#</option>
								</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="4" align="center">
								<cf_botones values="Consultar,Limpiar" tabindex="1">
							</td>
							<cfset Error1 = "El Centro Funcional del documento no es válido para el Centro de Custodia.">
							<cfset Error2 = "El Centro Funcional del documento no es igual al Centro Funcional del empleado.">
							<cfset Error3 = "La Categoría y Clase del Activo no es válida para el Centro de Custodia.">
							<cfset Error4 = "El Activo tiene una Categoría Clase que solo puede ser usada por un Centro de Custodia distinto.">
							<cfset Error5 = "El Empleado del documento se encuentra inactivo.">
							<cfset Error6 = "El Centro Funcional del documento no corresponde al Centro Funcional del activo para el período de auxiliares.">
							<cfset Error7 = "El Centro de Custodia del documento no existe.">
							<cfset Error8 = "El Centro Funcional del documento no existe.">
							<cfset Error9 = "El Activo del documento no existe.">
							<cfset Error10 = "El Empleado del documento no existe.">
							<input type="hidden" name="Error1" value="#Error1#">
							<input type="hidden" name="Error2" value="#Error2#">
							<input type="hidden" name="Error3" value="#Error3#">
							<input type="hidden" name="Error4" value="#Error4#">
							<input type="hidden" name="Error5" value="#Error5#">
							<input type="hidden" name="Error6" value="#Error6#">
							<input type="hidden" name="Error7" value="#Error7#">
							<input type="hidden" name="Error8" value="#Error8#">
							<input type="hidden" name="Error9" value="#Error9#">
							<input type="hidden" name="Error10" value="#Error10#">
						</tr>
					</table>
					</fieldset>
				</td> 
			</tr>
		</table> 
		</form> 
		</cfoutput>
		<script>
			document.form1.CRCCid.focus();
		</script>

	<cf_web_portlet_end>
<cf_templatefooter>