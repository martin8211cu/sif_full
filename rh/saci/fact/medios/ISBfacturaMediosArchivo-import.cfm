<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<cfquery datasource="#Session.dsn#" name="param225">
	select Pvalor 
		from ISBparametros 
	where Pcodigo = 225 
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset pv = "-1">
<cfif param225.RecordCount gt 0 and len(trim(param225.Pvalor))>
	<cfset pv = param225.Pvalor>
</cfif>
				
<body>
<form action="ISBfacturaMediosArchivo-apply.cfm" method="post" enctype="multipart/form-data" name="form1" id="form1" onsubmit="return verificarParam225();">
<input type="hidden" name="tab" value="liq" />
  <table width="600" border="0" cellspacing="0" cellpadding="2">
    <tr>
      <td colspan="2" class="subTitulo">Carga de archivo de liquidación </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>Seleccione el archivo que desea cargar </td>
      <td><input type="file" name="archivo" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td><input type="submit" name="Cargar" value="Cargar" class="btnSiguiente" /></td>
      <td>&nbsp;</td>
    </tr>
  </table>
  <script language="javascript1.2" type="text/javascript">
  	function verificarParam225(){
		<cfif pv eq "-1">
			alert("¡Se debe parametrizar el Motivo de Bloqueo automático de medios por Morosidad para continuar!");
			return false;
		<cfelse>
			return true;
		</cfif>
	}
  </script>
</form>
</body>
</html>
