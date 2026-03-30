<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<cfquery name ="rsPlantilla" datasource="sdc">
select nombre from CuentaClienteEmpresarial where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.sitio.cliente_empresarial#">
</cfquery>

<cf_template>
	<cf_templatearea name="title">
	<style type="text/css">
<!--
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
}
.style3 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.style5 {color: #FF0000; font-style: italic; font-family: Verdana, Arial, Helvetica, sans-serif;}
.style6 {
	color: #666666;
	font-size: 12px;
}
.style7 {color: #666666}
-->
    </style>
<cfoutput>Contáctenos</cfoutput></cf_templatearea>	<cf_templatearea name="header">
	<cfinclude template="pUbica.cfm"></cf_templatearea>
	<cf_templatearea name="body">
	<cfinclude template="pNavegacion.cfm">
	

<table width="100%">
  <tr>
    <td colspan="2"><div align="right" class="style5"><strong>Contáctenos</span></div></td>
  </tr>
</table>
</cf_templatearea></cf_template>