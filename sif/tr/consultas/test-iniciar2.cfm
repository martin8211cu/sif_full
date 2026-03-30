<cfparam name="url.ProcessId" type="numeric">

<cfquery datasource="#session.dsn#" name="Tramites">
	select a.Name as PackageName, b.Name as ProcessName,
		a.PackageId, b.ProcessId
	from WfPackage a
		join WfProcess b
			on a.PackageId = b.PackageId
	where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
	order by PackageName, ProcessName
</cfquery>
<cfquery datasource="#session.dsn#" name="DataField">
	select b.Name, b.Description, b.Label, b.InitialValue, b.Prompt, b.Length, b.Datatype
	from WfDataField b
	where b.ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ProcessId#">
	  and b.Prompt = 1
	order by Name
</cfquery>

<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Inicio de Tr&aacute;mites
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">

<form name="form1" method="post" action="test-iniciar-go.cfm">


<style type="text/css">
<!--
.style1 { }
.style2 {
	font-size: larger;
	font-weight: bold;
}
-->
</style>
  <table  border="0" cellspacing="0" cellpadding="0">
  <cfoutput>
    <tr>
      <td valign="top"><span class="style2">Tr&aacute;mite</span></td>
      <td valign="top">&nbsp;</td>
      <td valign="top"><span class="style2">#HTMLEditFormat(Tramites.ProcessName)#</span></td>
    </tr></cfoutput>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td width="120" valign="top"><span class="style2">Descripci&oacute;n</span></td>
      <td width="23" valign="top">&nbsp;</td>
      <td width="325" valign="top"><input name="Description" type="text" size="40" maxlength="60" onFocus="this.select()">
	  <cfoutput>
	  <input type="hidden" name="ProcessId" value="#url.ProcessId#"></cfoutput>
	  </td>
    </tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top"><span class="style1">Descripci&oacute;n que se le dar&aacute; a esta instancia del tr&aacute;mite.</span></td>
    </tr>
    <tr>
      <td><span class="style1">Sujeto del tr&aacute;mite</span></td>
      <td>&nbsp;</td>
      <td><input name="subjectid" type="text" id="subjectid" value="<cfoutput>#session.Usucodigo#</cfoutput>" size="40" maxlength="7"></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Usucodigo del sujeto del tr&aacute;mite. El Valor predeterminado es el suyo </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  <cfoutput query="DataField">
    <tr>
      <td valign="top"><span class="style2">#Label#</span>        </td>
      <td valign="top">&nbsp;</td>
      <td valign="top"><input name="text_#Name#" type="text" value="#Trim(InitialValue)#" size="40" maxlength="#Length#" onFocus="this.select()"></td>
    </tr>
    <tr>
      <td valign="top">&nbsp;</td>
      <td valign="top">&nbsp;</td>
      <td valign="top"><span class="style1">#Description#</span></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </cfoutput>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="3"><input type="submit" name="Submit" value="Iniciar ahora !"></td>
    </tr>
  </table>
</form>

	</cf_templatearea>
</cf_template>