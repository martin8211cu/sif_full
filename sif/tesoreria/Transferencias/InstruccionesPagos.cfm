<!--- 
	Creado por Gustavo Fonseca Hernández.
	Fecha: 10-6-2005.
	Motivo: Creación del Mantenimiento de Instrucciones de Pago de Socios de Negocios..
 --->

<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<cf_navegacion name="TIPO" default="SN" session>
<cf_navegacion name="TIPO_ESPECIAL" default="0" session>
<cf_navegacion name="Fnumero">
<cf_navegacion name="Fidentificacion">
<cf_navegacion name="Fnombre">
<cf_navegacion name="ID">


<cf_templateheader title="Cuentas Destino para Pago por Transferencias">
	<cfif form.TIPO EQ "SNC">
		<cfset form.TIPO = "SN">
	</cfif>
	<cfif form.TIPO EQ "SN">
		<cfset titulo = "Mantenimiento de Cuentas Destino para Pago por Transferencias a Socios de Negocios">
	<cfelseif form.TIPO EQ "BT">
		<cfset titulo = "Mantenimiento de Cuentas Destino para Pago por Transferencias a Beneficiarios de Contado">
	<cfelseif form.TIPO EQ "CD">
		<cfset titulo = "Mantenimiento de Cuentas Destino para Pago por Transferencias a Clientes Detallistas">
	</cfif>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<style type="text/css">
		<!--
		.style1 {
			color: #FF0000;
			font-weight: bold;
		}
		-->
		</style>
	
		<table width="100%" border="0">
			<tr>
				<td  nowrap valign="top">
				<cfif isdefined("form.ID")>
					<cfinclude template="InstruccionesPagos_form.cfm">
				<cfelse>
					<cfinclude template="InstruccionesPagos_filtro.cfm">
					<cfinclude template="InstruccionesPagos_#form.TIPO#_list.cfm">
				</cfif>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


