<cfinvoke key="LB_BarraNavegacion" default="Conceptos de Ajuste para Liquidaci&aacute;n de aguinaldo"  returnvariable="LB_BarraNavegacion" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoParaAjuste" default="Concepto Ajuste"  returnvariable="LB_ConceptoDePagoParaAjuste" component="sif.Componentes.Translate"  method="Translate"/>
<cfinvoke key="LB_ConceptoDePagoRecalculoLiquidacion" default="Concepto Recalculo"  returnvariable="LB_ConceptoDePagoRecalculoLiquidacion" component="sif.Componentes.Translate"  method="Translate"/>
<cf_templateheader title="#LB_BarraNavegacion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_BarraNavegacion#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<table width="98%" cellpadding="3" cellspacing="0">
			<tr>
				<td width="52%" valign="top">
					<cfquery name="rsLista" datasource="#session.DSN#">
						select 	a.CIidrecalculo
								,<cf_dbfunction name="concat" args="b.CIcodigo,' - ',b.CIdescripcion"> as recalculo
								,<cf_dbfunction name="concat" args="c.CIcodigo,' - ',c.CIdescripcion"> as resultado
						from RHLiqRecalcular a
							inner join CIncidentes b
								on a.CIidrecalculo = b.CIid
							inner join CIncidentes c
								on a.CIidresultado = c.CIid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					</cfquery>
					<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsLista#"
						desplegar="resultado,recalculo"
						etiquetas="#LB_ConceptoDePagoParaAjuste#,#LB_ConceptoDePagoRecalculoLiquidacion#"
						formatos="S,S"
						align="left,left"
						ira=""
						showEmptyListMsg="yes"
						keys="CIidrecalculo"	
						MaxRows="20"						
						filtrar_automatico="true"
						mostrar_filtro="true"
						filtrar_por="resultado,recalculo"						
					/>				
					<!---navegacion="#navegacion#"---->		
				</td>
				<td width="2%">&nbsp;</td>
				<td width="45%" valign="top">
					<cfinclude template="recalcularliquidacion-form.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>