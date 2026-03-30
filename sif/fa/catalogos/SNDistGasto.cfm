<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_TituloHeader" default="Facturaci&oacute;n" returnvariable="LB_TituloHeader" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Titulo" default="Socio de Negocio para Distribucion de Gastos" returnvariable="LB_Titulo" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Socio" default="Socio" returnvariable="LB_Socio" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Markup" default="Markup" returnvariable="LB_Markup" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_DistribucionGasto" default="Distribuci&oacute;n de Gasto" returnvariable="LB_DistribucionGasto" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Si" default="S&iacute;" returnvariable="LB_Si" xmlfile = "SNDistGasto.xml">


 <cfquery name="rsLista" datasource="#session.DSN#">
	select SNnombre, sngd.Ecodigo, sngd.SNid,sngd.markup,
		case when DistGasto= 1 then '#LB_Si#' else 'NO' end  as DistGasto
	from SNGastosDistribucion sngd
	inner join SNegocios sn on sngd.Ecodigo=sn.Ecodigo and sngd.SNid=sn.SNcodigo
     where sn.Ecodigo=#session.Ecodigo#
</cfquery>
<cf_templateheader title="#LB_TituloHeader#">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="#LB_Titulo#">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="30%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="SNnombre,markup,DistGasto"/>
							<cfinvokeargument name="etiquetas"        value="#LB_Socio#,#LB_Markup#,#LB_DistribucionGasto#"/>
							<cfinvokeargument name="formatos"         value="V, I, V"/>
							<cfinvokeargument name="align"            value="left,right,center"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="SNDistGasto.cfm "/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="SNid">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="formSNDistGasto.cfm">
				    </td>
				</tr>
			</table>             	
		<cf_web_portlet_end>
<cf_templatefooter>  