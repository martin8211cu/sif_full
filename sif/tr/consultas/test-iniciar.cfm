<cfquery datasource="#session.dsn#" name="Tramites">
	select a.Name as PackageName, a.Description as PackageDescription, b.Name as ProcessName,
		a.PackageId, b.ProcessId
	from WfPackage a
		join WfProcess b
			on a.PackageId = b.PackageId
	
	order by PackageName, ProcessName
</cfquery>


<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
		Inicio de Tr&aacute;mites
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">

<form name="form1" method="get" action="test-iniciar2.cfm">

  <table  border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td>Seleccione el tr&aacute;mite que desea iniciar:</td>
      <td><select name="ProcessId">
	  	<cfoutput query="Tramites" group="PackageId">
			<optgroup label="#HTMLEditFormat(PackageDescription)#">
				<cfoutput>
					<option value="#ProcessId#">#HTMLEditFormat(ProcessName)#</option>
				</cfoutput>
			</optgroup>
		</cfoutput>
      </select></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2"><input type="submit" name="Submit" value="Seleccionar &gt;&gt;"></td>
    </tr>
  </table>
</form>

	</cf_templatearea>
</cf_template>