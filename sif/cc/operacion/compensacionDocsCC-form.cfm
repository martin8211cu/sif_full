<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_CompDocs = t.Translate('TIT_CompDocs','Compensaci&oacute;n de Documentos de CXP y CXC')>
<cfset LB_DocNet = t.Translate('LB_DocNet','Compensaci&oacute;n de Documentos')>
<cfset LB_DocANetCXC = t.Translate('LB_DocANetCXC','Documento a Compensar CXC')>
<cfset LB_DocANetCXP = t.Translate('LB_DocANetCXP','Documento a Compensar CXP')>
<cfset MSG_CompDoct = t.Translate('MSG_CompDoct','Compensaci&oacute;n de Documentos de CxC y CxP: No se permiten Anticipos de Efectivo','/sif/cc/operacion/Compensacion.xml')>
<cfset MSG_AplAntCxC1 = t.Translate('MSG_AplAntCxC1','Aplicación de Anticipos de CxC: No se permiten Documentos de CxP','/sif/cc/operacion/Compensacion.xml')>
<cfset MSG_AplAntCxC2 = t.Translate('MSG_AplAntCxC2','Aplicación de Anticipos de CxC: No se permiten Documentos a favor de CxC que no sean de Anticipos','/sif/cc/operacion/Compensacion.xml')>
<cfset MSG_AplAntCxP1 = t.Translate('MSG_AplAntCxP1','Aplicación de Anticipos de CxP: No se permiten Documentos de CxC','/sif/cc/operacion/Compensacion.xml')>
<cfset MSG_AplAntCxP2 = t.Translate('MSG_AplAntCxP2','Aplicación de Anticipos de CxP: No se permiten Documentos a favor que no sean de Anticipos','/sif/cc/operacion/Compensacion.xml')>
<cfset MSG_CompAnt = t.Translate('MSG_CompAnt','Compensaci&oacute;n de Anticipos de CxC y CxP: No se permiten Documentos que no son Anticipos de Efectivo','/sif/cc/operacion/Compensacion.xml')>
<cfset LB_SubTit = t.Translate('LB_SubTit','Lista de Documentos a Compensar CXC')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Compensacion.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','Compensacion.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Noseha = t.Translate('LB_Noseha',' -- No se ha agregado ning&uacute;n documento CxC-- ','Neteo1.xml')>
<cfset LB_AntEfe = t.Translate('LB_AntEfe','(ANTICIPO EFECTIVO)')>
<cfset LB_FavorSFE= t.Translate('LB_FavorSFE','(a favor Cliente sin flujo de efectivo)')>


<cf_templateheader title="#TIT_CompDocs#">

	<cf_web_portlet_start titulo="#TIT_CompDocs#">
		<cfoutput>
			<!--- Define el Tipo de Compensacion para las pantallas comunes --->
			<cfset TipoCompensacion = 1>
			<!--- Pasa Lave que puede venir por url al form --->
			<cfif isdefined("url.idDocCompensacion") and len(trim(url.idDocCompensacion))>
				<cfset form.idDocCompensacion = url.idDocCompensacion>
			</cfif>

			<cf_dbfunction name="op_concat" returnvariable="_CAT">
			<cfif isDefined("form.idDocCompensacion") AND form.idDocCompensacion NEQ "" >
				<cfquery name="rslistacxc" datasource="#session.dsn#">
					SELECT CASE
				           WHEN d.CCTtipo = 'C'
				                AND
				                  (SELECT count(1)
				                   FROM DDocumentos det
				                   WHERE det.Ddocumento = c.Ddocumento
				                     AND det.CCTcodigo = c.CCTcodigo
				                     AND det.Ecodigo = c.Ecodigo ) = 0 THEN 1
				           WHEN d.CCTtipo = 'C' THEN 2
				           ELSE 3
				       END AS ANTs,
				       e.SNnombre,
				       d.CCTcodigo,
				       c.Ddocumento,
				       d.CCTcodigo #_CAT# ': ' #_CAT# d.CCTdescripcion #_CAT# CASE
				                                                                  WHEN d.CCTtipo = 'C'
				                                                                       AND
				                                                                         (SELECT count(1)
				                                                                          FROM DDocumentos det
				                                                                          WHERE det.Ddocumento = c.Ddocumento
				                                                                            AND det.CCTcodigo = c.CCTcodigo
				                                                                            AND det.Ecodigo = c.Ecodigo ) = 0 THEN ' #LB_AntEfe#'
				                                                                  WHEN d.CCTtipo = 'C' THEN ' #LB_FavorSFE#'
				                                                                  ELSE ' (a cobrar)'
				                                                              END AS CCTdescripcion,
				         a.idDocCompensacion,
				         b.idDetalle,
				         CASE CCTtipo
				             WHEN 'D' THEN c.Dsaldo
				             ELSE c.Dsaldo * -1
				         END AS Dsaldo,
				         CASE CCTtipo
				             WHEN 'D' THEN b.Dmonto
				             ELSE b.Dmonto * -1
				         END AS Dmonto,
				         d.CCTtipo,
				         r.Rcodigo AS RcodigoCxC,
				         r.Rporcentaje
					FROM DocCompensacion a
					INNER JOIN DocCompensacionDCxC b
					INNER JOIN Documentos c
					INNER JOIN CCTransacciones d ON d.CCTcodigo = c.CCTcodigo
					AND d.Ecodigo =c.Ecodigo
					LEFT JOIN Retenciones r ON r.Ecodigo = c.Ecodigo
					AND r.Rcodigo = c.Rcodigo
					INNER JOIN SNegocios e ON e.SNcodigo = c.SNcodigo
					AND e.Ecodigo = c.Ecodigo ON c.Ddocumento = b.Ddocumento
					AND c.CCTcodigo = b.CCTcodigo
					AND c.Ecodigo = b.Ecodigo ON b.idDocCompensacion = a.idDocCompensacion
					AND b.Ecodigo = a.Ecodigo
					WHERE a.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
					  AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					ORDER BY 1,
					         2,
					         3,
					         4
				</cfquery>
			</cfif>
			<!--- Pintado del Form  --->
			<br>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			  	<tr><td class="subTitulo" style="text-transform:uppercase" align="center"><strong>#LB_DocNet#</strong></td></tr>
			  	<tr><td><cfinclude template="FormateoCompensacion.cfm"></td></tr>
			</table>
			<br>
			<cfif (modoComp neq "ALTA")>
				<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td valign="top" width="50%">
							<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr><td class="subTitulo" style="text-transform:uppercase" align="center"><strong>#LB_DocANetCXC#</strong></td></tr>
							  	<tr><td>&nbsp;</td></tr>
							  	<tr><td valign="top"><cfinclude template="DocCC-form.cfm"></td></tr>
							  	<tr><td valign="top"><cfinclude template="DocCC-list.cfm"></td></tr>
							</table>
						</td>
						<td valign="top" width="50%">
							<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr><td class="subTitulo" style="text-transform:uppercase" align="center"><strong>#LB_DocANetCXP#</strong></td></tr>
								<tr><td>&nbsp;</td></tr>
							  	<tr><td valign="top"><cfinclude template="DocCP-form.cfm"></td></tr>
							  	<tr><td valign="top"><cfinclude template="DocCP-list.cfm"></td></tr>
							</table>
						</td>
				  	</tr>
				</table>
			<br>
			</cfif>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>