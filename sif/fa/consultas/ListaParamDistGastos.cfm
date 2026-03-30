<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ParametrosReporteDistribucionGastos" default="Par&aacute;metros del Reporte de Distribuci&oacute;n de Gastos" returnvariable="LB_ParametrosReporteDistribucionGastos" xmlfile="ListaParamDistGastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="ListaParamDistGastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" xmlfile="ListaParamDistGastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Socio" default="Socio" returnvariable="LB_Socio" xmlfile="ListaParamDistGastos.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PorcentajeDistribucion" default="Distribuci&oacute;n" returnvariable="LB_PorcentajeDistribucion" xmlfile="ListaParamDistGastos.xml"/>


 <cfquery name="rsLista" datasource="#session.DSN#">
	select distinct pdg.Ecodigo,cuenta,descripcion,SNnombre,porcentajeDist,pdg.SNid
 	from FAParamDistGasto pdg
    inner join SNegocios sn on sn.Ecodigo=pdg.Ecodigo and pdg.SNid=sn.SNcodigo
	where pdg.Ecodigo=#session.Ecodigo#
    <cfif isdefined("Form.snid")>
   		 and pdg.SNid=#Form.snid#
    <cfelse>
    	<cfif isdefined("socio")>
	    	and pdg.SNid=#Form.socio# 
         </cfif>   
    </cfif>    
    order by 2
</cfquery>

<cf_templateheader title="#LB_ParametrosReporteDistribucionGastos#">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="#LB_ParametrosReporteDistribucionGastos#">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
			  		<td valign="top" width="30%">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query"            value="#rsLista#"/>
							<cfinvokeargument name="desplegar"        value="cuenta, descripcion,SNnombre, porcentajeDist "/>
							<cfinvokeargument name="etiquetas"        value="#LB_Cuenta#,#LB_Descripcion#,#LB_Socio#,%#LB_PorcentajeDistribucion#"/>
							<cfinvokeargument name="formatos"         value="V, V,V,I"/>
							<cfinvokeargument name="align"            value="left, left, center, right, right"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="ListaParamDistGastos.cfm "/>
							<cfinvokeargument name="maxrows"          value="500"/> 							
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="cuenta">
						</cfinvoke>
				    </td>
                    <td>
						<cfinclude template="formParamSNDistGasto.cfm">
				    </td>
				</tr>
			</table>             	
		<cf_web_portlet_end>
<cf_templatefooter>  