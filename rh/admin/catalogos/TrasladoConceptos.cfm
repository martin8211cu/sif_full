<cfinvoke key="LB_BarraNavegacion" 				default="Traslado de Conceptos de liquidaci&oacute;n Entre Empresas"  returnvariable="LB_BarraNavegacion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoOrigen" 		default="Concepto Origen (S. A.) "    returnvariable="LB_ConceptoDePagoOrigen" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoDestino" 		default="Concepto Destino (Inc.)"  returnvariable="LB_ConceptoDePagoDestino" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoEquivalencia" 	default="Concepto Equivalencia (Inc.)"  returnvariable="LB_ConceptoDePagoEquivalencia" component="sif.Componentes.Translate"  method="Translate"/>

<cfquery name="rsParam" datasource="#session.DSN#">
	select coalesce(Pvalor,'#session.Ecodigo#') as  Pvalor
	from  RHParametros 
	where Pcodigo = 590 
	and Ecodigo   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>




<cf_templateheader title="#LB_BarraNavegacion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_BarraNavegacion#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfif isdefined('rsParam.Pvalor') and len(trim('rsParam.Pvalor')) and rsParam.Pvalor neq session.Ecodigo >
			<table width="98%" cellpadding="3" cellspacing="0">
				<tr>
					<td width="70%" valign="top">
						<cf_dbfunction name="string_part" args="b.CIdescripcion,1,20" returnvariable="LvarSubstringorigen">
						<cf_dbfunction name="string_part" args="c.CIdescripcion,1,20" returnvariable="LvarSubstringdestino">
						<cf_dbfunction name="string_part" args="d.CIdescripcion,1,20" returnvariable="LvarSubstringequivalencia">
						<cfquery name="rsLista" datasource="#session.DSN#">
							select 	a.CIidEmpOrigen
									,ltrim(rtrim(b.CIcodigo)) as cod_origen
									,case when <cf_dbfunction name="length" args="b.CIdescripcion"> > 20
									then <cf_dbfunction name="concat" args="#LvarSubstringorigen# + '...'" delimiters="+"> else b.CIdescripcion end as origen_des
									,ltrim(rtrim(c.CIcodigo)) as cod_destino
									,case when <cf_dbfunction name="length" args="c.CIdescripcion"> > 20
									then <cf_dbfunction name="concat" args="#LvarSubstringdestino# + '...'" delimiters="+"> else c.CIdescripcion end as destino_des
									,ltrim(rtrim(d.CIcodigo)) as cod_equivalencia
									,case when <cf_dbfunction name="length" args="d.CIdescripcion"> > 20
									then <cf_dbfunction name="concat" args="#LvarSubstringequivalencia# + '...'" delimiters="+"> else d.CIdescripcion end as equivalencia_des
							from RHTransferIncidencia a
								inner join CIncidentes b
									on a.CIidEmpOrigen = b.CIid
								inner join CIncidentes c
									on a.CIidEmpDestino = c.CIid
								inner join CIncidentes d
									on a.CIidEquivalencia = d.CIid	
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						</cfquery>
						<!--- <cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#rsLista#"
							desplegar="cod_origen,origen_des,cod_equivalencia,equivalencia_des,cod_destino,destino_des"
							etiquetas="#LB_ConceptoDePagoOrigen#,&nbsp;,#LB_ConceptoDePagoEquivalencia#,&nbsp;,#LB_ConceptoDePagoDestino#,&nbsp;"
							formatos="S,S,S,S,S,S"
							align="left,left,left,left,left,left"
							ira=""
							showEmptyListMsg="yes"
							keys="CIidEmpOrigen"	
							MaxRows="20"						
													
						/>	 --->
						
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#rsLista#"
							desplegar="origen_des,equivalencia_des,destino_des"
							etiquetas="#LB_ConceptoDePagoOrigen#,#LB_ConceptoDePagoEquivalencia#,#LB_ConceptoDePagoDestino#"
							formatos="S,S,S"
							align="left,left,left"
							ira=""
							showEmptyListMsg="yes"
							keys="CIidEmpOrigen"	
							MaxRows="25"						
						/>	
						
					</td>
					<td width="2%">&nbsp;</td>
					<td width="45%" valign="top">
						<cfinclude template="TrasladoConceptos-form.cfm">
					</td>
				</tr>
			</table>
		<cfelse>
			<cfoutput>
			<table width="100%" cellpadding="3" cellspacing="0" class="areaFiltro">
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center"><cf_translate key="Error_Misma_Empresa">Usted esta trabajando con la emprea origen para hacer movimientos de incidencias entre empresas (#session.Enombre#). No puede realizar movimientos a ella misma.</cf_translate></td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
			</cfoutput>
		</cfif>
				
		
	<cf_web_portlet_end>	
<cf_templatefooter>