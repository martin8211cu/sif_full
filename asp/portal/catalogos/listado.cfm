<cf_templateheader title="Listado de Aplicaciones">
	<cf_web_portlet_start titulo="Listado de Aplicaciones">
	<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfinclude template="frame-header.cfm">
		
<cfparam name="url.SScodigo" default="">
<cfparam name="url.SMcodigo" default="">
<cfparam name="url.mostrar" default="perm">

<cfquery datasource="asp" name="sistemas">
	select SScodigo, SSdescripcion
	from SSistemas
	order by lower(SScodigo)
</cfquery>
<cfquery datasource="asp" name="modulos">
	select SMcodigo, SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SScodigo#">
	order by lower(SMcodigo)
</cfquery>

<form name="form1" method="get" action="listado-sql.cfm">
  <table border="0" align="center" cellspacing="0" cellpadding="2" width="650">
    <tr>
      <td colspan="4" class="subTitulo">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" class="subTitulo">Seleccione el sistema o m&oacute;dulo que desea mostrar</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td width="29">&nbsp;</td>
      <td width="72">Sistema</td>
      <td width="171"><select name="SScodigo" onChange="form.action='';form.submit();">
	  <option value="">-Todos-</option>
	  <cfoutput query="sistemas">
	  <option value="#Trim(SScodigo)#" <cfif trim(SScodigo) is trim(url.SScodigo)>selected</cfif>>#HTMLEditFormat(Trim(SScodigo))# - #HTMLEditFormat(SSdescripcion)#</option>
	  </cfoutput>
      </select></td>
      <td width="19">&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>M&oacute;dulo</td>
      <td><select name="SMcodigo">
	  <cfif modulos.RecordCount Neq 1>
	  <option value="">-Todos-</option></cfif>
	  <cfoutput query="modulos">
	  <option value="#Trim(SMcodigo)#" <cfif trim(SMcodigo) is trim(url.SMcodigo)>selected</cfif>  >#HTMLEditFormat(Trim(SMcodigo))# - #HTMLEditFormat(SMdescripcion)#</option>
	  </cfoutput>
      </select></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="mostrar" id="perm" <cfif url.mostrar is 'perm'>checked</cfif> type="radio" value="perm" style="border:0;background-color:#ededed">        <label for="perm">Mostrar Permisos</label></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><input name="mostrar" id="comp" <cfif url.mostrar is 'comp'>checked</cfif> type="radio" value="comp" style="border:0;background-color:#ededed">
        <label for="comp">Mostrar Componentes</label></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <input name="mostrar" id="menu" <cfif url.mostrar is 'menu'>checked</cfif> type="radio" value="menu" style="border:0;background-color:#ededed">
		<label for="menu">Mostrar Men&uacute;es </label></td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" align="center"><input type="submit" name="Submit" value="Consultar" class="btnSiguiente"></td>
    </tr>
  </table>
</form>
<cf_web_portlet_end>
<cf_templatefooter>