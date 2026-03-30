<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_TituloHeader" default="Metodo de Participacion"
returnvariable="LB_TituloHeader" xmlfile = "SNMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Titulo" default="Socio de Negocio para Metodo de Participacion" returnvariable="LB_Titulo" xmlfile = "SNDistGasto.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_Socio" default="Socio" returnvariable="LB_Socio"
xmlfile = "SNMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_CuentaC" default="Cuenta Creditos" returnvariable="LB_CuentaC"
xmlfile = "SNMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key ="LB_CuentaD" default="Cuenta Debitos" returnvariable="LB_CuentaD"
xmlfile = "SNMetodoParticipacion.xml">


 <cfquery name="rsLista" datasource="#session.DSN#">
	select sn.SNnombre, snmp.Ecodigo, snmp.SNid,snmp.FormatoCuentaC,snmp.FormatoCuentaD
	from SNMetodoParticipacion snmp
	inner join SNegocios sn on snmp.Ecodigo=sn.Ecodigo and snmp.SNid=sn.SNid
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
<!---							<cfinvokeargument name="desplegar"        value="SNnombre,FormatoCuentaC,FormatoCuentaD"/>--->
							<cfinvokeargument name="desplegar"        value="SNnombre"/>
<!---							<cfinvokeargument name="etiquetas"        value="#LB_Socio#,#LB_CuentaC#,#LB_CuentaD#"/>--->
							<cfinvokeargument name="etiquetas"        value="#LB_Socio#"/>
<!---							<cfinvokeargument name="formatos"         value="V, V, V"/>--->
							<cfinvokeargument name="formatos"         value="V"/>
<!---							<cfinvokeargument name="align"            value="left,left,left"/>--->
							<cfinvokeargument name="align"            value="left"/>
							<cfinvokeargument name="ajustar"          value="N"/>
							<cfinvokeargument name="irA" 			  value="SNMetodoParticipacion.cfm "/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys"             value="SNid">
						</cfinvoke>
				    </td>
				    <td>
						<cfinclude template="../../cg/catalogos/formSNMetodoParticipacion.cfm">
				    </td>
				</tr>
			</table>
		<cf_web_portlet_end>
<cf_templatefooter>