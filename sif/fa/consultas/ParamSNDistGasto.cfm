<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ParametrosReporteDistribucionGastos" default="Par&aacute;metros del Reporte de Distribucion de Gastos" returnvariable="LB_ParametrosReporteDistribucionGastos" xmlfile="ParamSNDistGasto.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_SocioNegocios" default="Par&aacute;metros del Reporte de Distribucion de Gastos" returnvariable="LB_SocioNegocios" xmlfile="ParamSNDistGasto.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" xmlfile="ParamSNDistGasto.xml"/>


<cfsetting enablecfoutputonly="yes">
 
<cfparam name="varControlFiltro" default="true">


 <cfquery name="rsSNDG" datasource="#session.dsn#">
        	select SNnombre, sngd.Ecodigo, sngd.SNid,sngd.markup
			from SNGastosDistribucion sngd
			inner join SNegocios sn on sngd.Ecodigo=sn.Ecodigo and sngd.SNid=sn.SNcodigo
		    where sn.Ecodigo=#session.Ecodigo#
		    and DistGasto= 1
            order by sngd.SNid
</cfquery>

<!--- AQUI EMPIEZA PANTALLA --->
<cfsetting enablecfoutputonly="no">
<cf_templateheader title="SIF - Facturación">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_ParametrosReporteDistribucionGastos#'>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td></td>
		</tr>
		<tr> 
			<td> 
            	<cfoutput>
				<form style="margin: 0" name="form1" action="../consultas/ListaParamDistGastos.cfm" method="post">
					<table width="100%" border="0" cellspacing="2" cellpadding="0" class="areaFiltro">
						<tr> 
							<td width="50%"><strong>#LB_SocioNegocios#:</strong></td>							
						</tr>
                        <tr> 
							<td>
					    		 <select name="socio" size="1" id="socio"tabindex="1">
                				 <cfloop query="rsSNDG">
                 	<option value="<cfoutput>#rsSNDG.SNid#</cfoutput>"  <cfif rsSNDG.SNid>selected</cfif>> <cfoutput> #HTMLEditFormat(rsSNDG.SNnombre)#</cfoutput></option>
                 </cfloop>
			  </select>
							</td><td>&nbsp;</td><td>&nbsp;</td>
                           </tr>
                           <tr>
                        	<td>&nbsp;</td>
                       		<td>&nbsp;</td>
                            <td>
                            	<input type="submit" name="Consultar" value="#BTN_Consultar#">
                            </td>
						</tr>
					</table>
				</form>
                </cfoutput>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2">

</script>