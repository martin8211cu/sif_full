
<cfset navegacion = "">
<cfif isdefined("form.idDocCompensacion")>
	<cfset navegacion = navegacion & "&idDocCompensacion=#form.idDocCompensacion#">
</cfif>

<cfset LB_SubTit = t.Translate('LB_SubTit','Lista de Documentos a Compensar CXP')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','Neteo1.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','Neteo1.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Noseha = t.Translate('LB_Noseha',' -- No se ha agregado ning&uacute;n documento CxP-- ','Neteo1.xml')>
<cfset LB_AntEfe = t.Translate('LB_AntEfe','(ANTICIPO EFECTIVO)')>
<cfset LB_FavorSFE= t.Translate('LB_FavorSFE','(a favor Sin Flujo Efectivo)')>

<cf_dbfunction name="op_concat" returnvariable="_CAT">
	<cfquery name="rslistacxc" datasource="#session.dsn#">
		SELECT CASE
	           WHEN d.CPTtipo = 'D'
	                AND
	                  (SELECT count(1)
	                   FROM DDocumentosCP det
	                   WHERE det.IDdocumento = c.IDdocumento ) = 0 THEN 1
	           WHEN d.CPTtipo = 'D' THEN 2
	           ELSE 3
	       END AS ANTs,
	       e.SNnombre,
	       d.CPTcodigo,
	       c.Ddocumento,
	       d.CPTcodigo #_CAT# ': ' #_CAT# d.CPTdescripcion #_CAT# CASE
	                                                                  WHEN d.CPTtipo = 'D'
	                                                                       AND
	                                                                         (SELECT count(1)
	                                                                          FROM DDocumentosCP det
	                                                                          WHERE det.IDdocumento = c.IDdocumento ) = 0 THEN ' #LB_AntEfe#'
	                                                                  WHEN d.CPTtipo = 'D' THEN ' #LB_FavorSFE#'
	                                                                  ELSE ' (a pagar)'
	                                                              END AS CPTdescripcion,
              a.idDocCompensacion,
              b.idDetalle,
              b.idDocumento,
              c.Ddocumento,
              CASE CPTtipo
                  WHEN 'C' THEN c.EDsaldo
                  ELSE c.EDsaldo * -1
              END AS EDsaldo,
              CASE CPTtipo
                  WHEN 'C' THEN b.Dmonto
                  ELSE b.Dmonto * -1
              END AS Dmonto,
              CPTtipo,
              e.SNnombre,
              r.Rcodigo AS RcodigoCxC,
              r.Rporcentaje
	FROM DocCompensacion a
	INNER JOIN DocCompensacionDCxP b
	INNER JOIN EDocumentosCP c
	INNER JOIN CPTransacciones d ON d.CPTcodigo = c.CPTcodigo
	AND d.Ecodigo =c.Ecodigo
	LEFT JOIN Retenciones r ON r.Ecodigo = c.Ecodigo
	AND r.Rcodigo = c.Rcodigo
	INNER JOIN SNegocios e ON e.SNcodigo = c.SNcodigo
	AND e.Ecodigo = c.Ecodigo ON c.IDdocumento = b.idDocumento
	AND c.CPTcodigo = b.CPTcodigo ON b.idDocCompensacion = a.idDocCompensacion
	WHERE a.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	  AND a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	ORDER BY 1,
	         2,
	         3,
	         4
	</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td align="center">&nbsp;</td></tr>
	<tr><td align="center"><cfoutput><strong>#LB_SubTit#</strong></cfoutput></td></tr>
	<tr><td align="center">&nbsp;</td></tr>
  	<tr>
	    <td>

			<cfinvoke component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pLista"
				formname="listacxp"
				query="#rslistacxc#"
				desplegar="Ddocumento,EDsaldo,Dmonto"
				etiquetas="#LB_Documento#,#LB_Saldo#,#LB_Monto#"
				formatos="S,M,M"
				align="left,right,right"
				cortes="SNnombre,CPTdescripcion"
				totales="EDsaldo,Dmonto"
				totalgenerales="EDsaldo,Dmonto"
				irA=""
				showEmptyListMsg="true"
				EmptyListMsg="#LB_Noseha#"
				navegacion="#navegacion#"
				PageIndex="3"/>
		</td>
  	</tr>
</table>