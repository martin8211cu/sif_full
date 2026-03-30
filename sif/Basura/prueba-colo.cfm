<cfif isdefined("url.textfield") and not isdefined("form.textfield")>
	<cfset form.textfield = url.textfield>
</cfif>
<cfset modo = iif(isdefined("form.textfield"),DE("CAMBIO"),DE("ALTA"))>

<cfset session.dsn = "minisif">
<!--- esete query trae las monedas --->
<cfif isdefined("form.textfield2")>
<cfquery name="rs" datasource="#session.dsn#">
	select * from Monedas
	where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.textfield2#" null="#len(form.textfield2) eq 0#">
</cfquery>
</cfif>
<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 1 as textfield
	</cfquery>
</cfif>
<cfdump var="#form#">
<form name="form1" method="post" action="prueba-colo.cfm">
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td ><div align="center">
      <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
				<!---
				<cfloop query="rs">
        <tr>
          <td class="etiqueta"><strong>#Mcodigo# </strong></td>
          <td><input type="text" name="textfield" <cfif modo neq "ALTA">value="#rsForm.textfield#"</cfif>></td>
          <td class="etiqueta"><strong>#Mnombre#</strong></td>
          <td><select name="select">
          </select></td>
        </tr>
				</cfloop>
				--->
        <tr>
          <td class="etiqueta"><strong>Campo 2</strong></td>
          <td><input type="text" name="textfield2"></td>
          <td class="etiqueta"><strong>Campo 4</strong></td>
          <td><select name="select2">
          </select></td>
        </tr>
        <tr>
          <td colspan="4"><cf_botones modo="#modo#"></td>
        </tr>
      </table>
    </div></td>
  </tr>
</table>
</cfoutput>
</form>