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
		  	<!---<cfif isdefined ('form.RCNid') and len(trim(form.RCNid)) gt 0 or isdefined ('url.RCNid') and len(trim(url.RCNid)) gt 0>--->
			<cfif (
					(isdefined ('form.Fdesde') and len(trim(form.Fdesde)) gt 0 ) or
					(isdefined ('form.Fhasta') and len(trim(form.Fhasta)) gt 0 ) or
					(isdefined ('form.Tcodigo') and len(trim(form.Tcodigo)) gt 0 ) or
					(isdefined ('form.CPcodigo') and len(trim(form.CPcodigo)) gt 0 ) 
					) and not isdefined("form.consultar")>
				<td>
					<cfinclude template="RepDedCargas-form.cfm">
				</td>
			<cfelse>
				<td>
					<cfinclude template="RepDedCargas-listas.cfm">
				</td>
			</cfif>
		  </tr>
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>