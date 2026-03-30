<!--- VARIABLES DE TRADUCCION --->
<cfsilent>
<cfinvoke key="LB_Liquidacion_de_Renta" default="Liquidación de Renta" returnvariable="LB_Liquidacion_de_Renta" component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="770" default="" returnvariable="UrlRenta"/>
<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cf_templateheader title="#LB_Liquidacion_de_Renta#">
	<cf_web_portlet_start titulo="#LB_Liquidacion_de_Renta#">
		<cfif isdefined('UrlRenta') and LEN(TRIM(UrlRenta))>
			<cfinclude template="#UrlRenta#">
		<cfelse>
			<table width="80%" cellpadding="3" cellspacing="3" align="center">
				<tr><td></td></tr>
				<tr><td align="center"><strong><cf_translate key="LB_MSGRuta">No se ha definido el proceso de Liquidación</cf_translate></strong></td></tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>