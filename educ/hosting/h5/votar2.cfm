<cfparam name="url.id" type="numeric" default="0">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
-->
</style></head>

<body>
<table width="769" height="362" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <th width="765" height="360" valign="top" scope="row"><table width="77%" height="129"  border="0" align="left" cellpadding="0" cellspacing="0">
      <tr>
        <th width="26%" height="79" valign="top" scope="row"><img src="images/sitioh5_11.jpg" width="208" height="79"></th>
        <th width="19%" scope="row"><img src="images/internah5_12.jpg" width="140" height="79"></th>
        <th width="37%" scope="row"><img src="images/internah5_13.jpg" width="295" height="79"></th>
        <th width="18%" scope="row"><p align="left"><img src="images/internah5_14.jpg" width="118" height="79"></p>          </th>
      </tr>
      <tr>
        <th height="50" colspan="4" valign="top" scope="row"><div align="right"><img src="images/votar.jpg" width="500" height="50"></div></th>
        </tr>
    </table>      <p>&nbsp;</p>
    <p align="left"><br>
    </p>    
    <p align="left">&nbsp;</p>
    <p align="center">&nbsp;</p>
    <p align="center">Vota por tu favorita hoy mismo y cuantas veces quieras!<br>
      </p>
    <div align="center">
      <form action="votar.cfm" method="post" onSubmit="return validar(this);"><table width="60%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <th width="46%" scope="row">Votar por:</th>
            <th width="54%" scope="row">
			<cfquery datasource="h5_votacion" name="concursante">
				select concursante,nombre_concursante
				from Concursante order by 2
			</cfquery>
			<select name="concursante" size="1" style="width:220px">
              <option value=""> - Selecciona a tu favorita - </option>
			  <cfoutput query="concursante">
              <option value="#concursante.concursante#" <cfif concursante.concursante is url.id>selected</cfif>>#concursante.nombre_concursante#</option></cfoutput>
               </select></th>
          </tr>
          <tr>
            <th scope="row">Nombre Completo: </th>
            <th scope="row"><input name="name" type="text" size="30" style="width:214px"></th>
          </tr>
          <tr>
            <th scope="row">Correo Electronico:</th>
            <th scope="row"><input name="email" type="text" size="30" style="width:214px"></th>
          </tr>
          <tr>
            <th scope="row">&nbsp;</th>
            <th scope="row">&nbsp;</th>
          </tr>
          <tr>
            <th colspan="2" scope="row"><input type="submit" name="Submit" value="Votar"></th>
          </tr>
      </table></form>
    </div>
    <p>&nbsp;</p></th>
  </tr>
</table>
<script type="text/javascript">
<!--
	function validar(f) {
		if (f.concursante.value == "") {
			alert("Selecciona a tu favorita para votar por ella ! ");
			f.concursante.focus();
			return false;
		}
		return true;
	}
//--></script>
</body>
</html>
