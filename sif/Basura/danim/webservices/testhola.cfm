<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Untitled Document</title>
</head>

<body>

<cfparam name="url.CEcodigo" default="0">
<cfparam name="url.Ecodigo" default="0">

<cfinvoke 
 webservice="http://127.0.0.1:8300/cfmx/sif/Basura/danim/webservices/hola.cfc?wsdl"
 method="listadoCuentas"
 returnvariable="qCuenta">
</cfinvoke>
<cfinvoke 
 webservice="http://127.0.0.1:8300/cfmx/sif/Basura/danim/webservices/hola.cfc?wsdl"
 method="listadoEmpresas"
 CEcodigo="#url.CEcodigo#"
 returnvariable="qEmpresa">
</cfinvoke>
<cfinvoke 
 webservice="http://127.0.0.1:8300/cfmx/sif/Basura/danim/webservices/hola.cfc?wsdl"
 method="listadoCuentasMayor"
 CEcodigo="#url.CEcodigo#"
 Ecodigo="#url.Ecodigo#"
 returnvariable="qCuentas">
</cfinvoke>

<form name="form1" method="get" action="">
  <table border="1" cellpadding="5" cellspacing="0">
    <tr>
      <td colspan="2" bgcolor="#CCCCCC"><em><strong>Seleccione una empresa </strong></em></td>
    </tr>
    <tr>
      <td width="104">Cuenta </td>
      <td width="291"><select name="CEcodigo" onChange="this.form.Ecodigo.selectedIndex=-1;this.form.submit()">
	  <cfif (url.CEcodigo)EQ 0><option value="">-Seleccione una-</option></cfif>
	  <cfoutput query="qCuenta">
	  <option value="#HTMLEditFormat(CEcodigo)#" <cfif url.CEcodigo is qCuenta.CEcodigo>selected</cfif>>#HTMLEditFormat(CEnombre)#</option></cfoutput>
      </select></td>
    </tr>
    <tr>
      <td>Empresa</td>
      <td><select name="Ecodigo" onChange="this.form.submit()">
	  <cfif (url.Ecodigo) EQ 0><option value="">-Seleccione una-</option></cfif>
        <cfoutput query="qEmpresa">
          <option value="#HTMLEditFormat(Ecodigo)#" <cfif url.Ecodigo is qEmpresa.Ecodigo>selected</cfif>>#HTMLEditFormat(Enombre)#</option>
        </cfoutput>
      </select></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr> 
    <tr>
      <td colspan="2" bgcolor="#CCCCCC"><em><strong>Listado de cuentas de Mayor </strong></em></td>
    </tr>
    <tr bgcolor="#CCCCCC">
      <td><em>Cuenta</em></td>
      <td><em>Nombre</em></td>
    </tr><cfoutput query="qCuentas">
    <tr>
      <td>#HTMLEditFormat(Cmayor)#</td>
      <td>#HTMLEditFormat(Cdescripcion)#</td>
    </tr></cfoutput>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </table>
</form>
<a href="hola.cfc?wsdl">WSDL</a>
</body>
</html>
