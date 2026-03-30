<cfinvoke key="LB_ContabilidadElectronica" default="Contabilidad Electr&oacute;nica" returnvariable="LB_ContabilidadElectronica" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacionCE.xml"/>
<cfinvoke key="LB_BalanzaComprobacion" default="Balanza de Comprobaci&oacute;n SAT" returnvariable="LB_BalanzaComprobacion" component="sif.Componentes.Translate" method="Translate" xmlfile="BalComprobacionCE.xml"/>

<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cf_templateheader title="#LB_ContabilidadElectronica#">
	<cfinclude template="../../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="#LB_BalanzaComprobacion#">
		<cfset varEmpElimina =  ObtenerDato(1310)>
		<cfif varEmpElimina.Pvalor EQ '' or varEmpElimina.Pvalor NEQ Session.Ecodigo>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
			      <br/>
			      <tr>
				      <td align="center">Este proceso solo se puede usar en una Empresa que este configurada como Empresa de Eliminaci&oacute;n.</td>
				  </tr>
				  <tr>
					  <td align="center"><a href="../../../../otrassol/consolidacion/Catalogos/ParametrosCtaEliminacion.cfm" style="color:#456ABA"> Parámetro de Eliminaci&oacute;n</a></td>
				  </tr>
			</table>
			<br>
		<cfelse>
			<cfinclude template="formBalComprobacionCE.cfm">
			<hr>
			<cfinclude template="listaBalComprobacionCE.cfm">
		</cfif>
    <cf_web_portlet_end>
<cf_templatefooter>