<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<style type="text/css">
<!--
*,td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
}
-->
</style>
</head>

<body>

<cfquery name="rsContents" datasource="asp" >
	select distinct
	  s.SScodigo,
	  coalesce( s.SShomeuri, '-') as SShomeuri,
	  
	  m.SMcodigo,
	  coalesce( m.SMhomeuri, '-') as SMhomeuri,
	  
	  p.SPcodigo,
	  coalesce( p.SPhomeuri, '-') as SPhomeuri,
	  
	  coalesce( c.SCuri, '-') as SCuri,
	  c.SCtipo
	from UsuarioProceso up, SSistemas s, SModulos m, SProcesos p, SComponentes c
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">

	  and up.SScodigo = s.SScodigo
	  and up.SScodigo = m.SScodigo
	  and up.SMcodigo = m.SMcodigo

	  and up.SScodigo = p.SScodigo
	  and up.SMcodigo = p.SMcodigo
	  and up.SPcodigo = p.SPcodigo

	  and up.SScodigo *= c.SScodigo
	  and up.SMcodigo *= c.SMcodigo
	  and up.SPcodigo *= c.SPcodigo
	order by SScodigo, SMcodigo, SPcodigo, SCuri
</cfquery>


<table border="0" cellpadding="0" cellspacing="0" width="600">
  <tr bgcolor="#0099FF">
    <td colspan="2">Sistema</td>
    <td colspan="2">M&oacute;dulo</td>
    <td colspan="2">Proceso</td>
    <td colspan="2">Componente</td>
  </tr>
  <cfoutput query="rsContents">
    <tr   <cfif (rsContents.CurrentRow MOD 7) mod 3 IS 1>style='background-color:##ccc'</cfif>>
      <td>#SScodigo#</td>
      <td>#SShomeuri#</td>
      <td>#SMcodigo#</td>
      <td>#SMhomeuri#</td>
      <td>#SPcodigo#</td>
      <td>#SPhomeuri#</td>
      <td>#SCuri#</td>
      <td>#SCtipo#</td>
    </tr>
  </cfoutput>
</table>
</body>
</html>
