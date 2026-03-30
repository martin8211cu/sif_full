<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfparam name="form.transportista" default="">
<cfquery name="data" datasource="#Session.DSN#" >
	Select convert(varchar,transportista) as transportista, nombre_transportista, orden, tracking_url
	from Transportista
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and transportista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.transportista#" null="#Len(Trim(form.transportista)) is 0#" >		  
</cfquery>

<SCRIPT SRC="/cfmx/tienda/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("/cfmx/tienda/js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

<form method="post" name="form1" action="transportista_go.cfm">
  
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Transportista:</td>
      <td>
	  	<cfoutput>
	  	<input type="text" name="nombre_transportista" value="# HTMLEditFormat( Trim(data.nombre_transportista) )#" size="40" onfocus="this.select()">
		<input name="transportista" type="hidden" value="#data.transportista#">
		</cfoutput>
	  </td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap>Tracking URL:</td>
      <td nowrap><cfoutput>
        <input type="text" name="tracking_url" value="# HTMLEditFormat( Trim(data.tracking_url) )#" size="40" maxlength="255" onfocus="this.select()">
      </cfoutput></td>
    </tr>
    <tr valign="baseline">
      <td align="right" nowrap>Orden:</td>
      <td nowrap><cfoutput>
        <input type="text" name="orden" value="# HTMLEditFormat( Trim(data.orden) )#" size="40" maxlength="4" onfocus="this.select()">
      </cfoutput></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><cfinclude template="/sif/portlets/pBotones.cfm"></td>
    </tr>
  </table>
</form>

<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.nombre_transportista.required = true;
	objForm.nombre_transportista.description="Nombre del transportista";		
</script>


