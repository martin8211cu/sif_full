<!---*********************************
	Módulo    : Control de Reponsables
	Nombre   : Reporte de Activos en Tránsito
	***********************************
	Hecho por: Randall Colomer Villalta
	Creado    : 16 Junio 2006
	***********************************
	Modificado por: Dorian Abarca Gómez
	Modificado: 18 Julio 2006
	Moficaciones:
	1. Se modifica para que se imprima y baje a excel con el cf_htmlreportsheaders.
	2. Se modifica para que se pinte con el jdbcquery.
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
			<form method="post" name="form1" action="ActivosEnTransitoRep.cfm">
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td nowrap width="20%" valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td nowrap valign="top">	
										<cf_web_portlet_start border="true" titulo="Descripci&oacute;n" skin="info1">
											<div align="justify">
												<p> Este reporte debe de desplegar una lista de los activos en transito o transacciones de retiro, además se muestra en forma ordenada por fecha de transacciones. </p>
												<p> Debe de filtrar por un centro de custodia y un rango de fechas de transacciones. </p>
											</div>
										<cf_web_portlet_end>
									</td>
								</tr>
							</table>  
						</td>
						<td width="5%">&nbsp;</td>
						<td nowrap width="75%" valign="top">
							<fieldset><legend>Filtros para el Reporte</legend>
							<table width="100%"  border="0" cellspacing="2" cellpadding="2">
								<tr>
									<td nowrap width="42%" align="right"><strong>Centro de Custodia:</strong></td>
									<td nowrap>
										<cfquery name="rsCRCC" datasource="#Session.Dsn#">
											select a.CRCCid as value,<cf_dbfunction name="concat" args="rtrim(a.CRCCcodigo),' - ', rtrim(a.CRCCdescripcion) "> as description
											from CRCentroCustodia a
											where a.Ecodigo = #Session.Ecodigo# 
											order by a.CRCCcodigo
										</cfquery>
										<select name="CRCCid" id="CRCCid" tabindex="1">
											<option value="-1" selected >Todos</option>
											<cfloop query="rsCRCC">	
												<option value="#value#" <cfif isdefined("form.CRCCid") and form.CRCCid eq value>selected</cfif>>#description#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr>
									<td nowrap width="42%" align="right"><strong>Estado:</strong></td>
									<td nowrap>
										<cfset Lvar_listEstados = "Activos en Tránsito, Transacción de Retiro">
										<select name="Estado" id="Estado" tabindex="2">
											<cfset count = 0>
											<cfloop list="#Lvar_listEstados#" index="value">
												<cfset count = count + 1>
												<option value="#count#" <cfif isdefined("form.Estado") and form.Estado eq count>selected</cfif>>#value#</option>
											</cfloop>
										</select>
									</td>
								</tr>
								<tr >
									<td nowrap align="right"><strong>Fecha Inicial:</strong></td>
									<td nowrap>
										<cfparam name="Form.FechaInicio" default="#now()#">
										<cf_sifcalendario name="FechaInicio" tabindex="3" value="#LSDateFormat(Form.FechaInicio,'dd/mm/yyyy')#">
									</td>
								</tr>
								<tr>
									<td nowrap width="42%" align="right"><strong>Fecha Final:</strong></td>
									<td nowrap>
										<cfparam name="Form.FechaFinal" default="#now()#">
										<cf_sifcalendario name="FechaFinal" tabindex="4" value="#LSDateFormat(Form.FechaFinal,'dd/mm/yyyy')#">
									</td>
								</tr>
								<tr>
								  <td nowrap width="42%" align="right"><strong>Formato:</strong></td>
							  	  <td nowrap>
								  	<select name="formato" tabindex="1">
										<option value="pantalla">Pantalla</option>
										<option value="comas">Archivo Separado por Comas</option>
										<option value="tabs">Archivo Separado por Tabs</option>
									</select>
								  </td>
						      	</tr>
								<tr>
									<td align="center">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="2" align="center">
										<cf_botones values="Consultar,Limpiar" tabindex="4">
									</td>
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