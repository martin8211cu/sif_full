<!--- modificado en notepad --->
<cfsilent>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ContabilizaNominaDesdeHistoricoDeNominasX"
	Default="Contabiliza N&oacute;mina desde Hist&oacute;rico de N&oacute;minas"
	returnvariable="LB_ContabilizaNominaDesdeHistoricoDeNominas"/>
</cfsilent>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_web_portlet_start titulo="#LB_ContabilizaNominaDesdeHistoricoDeNominas#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>
				<cfinclude template="contabilizaNominaH-form.cfm">
			</td>
		  </tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>