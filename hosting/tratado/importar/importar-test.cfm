<html>
<head>
<title>Prueba de importaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>

<body>

<cfinclude template="../portlets/pEmpresas2.cfm">

<table border="1" cellspacing="0" cellpadding="2">
    <tr>
        <td valign="top">Prueba de importaci&oacute;n</td>
        <td valign="top">Prueba de exportaci&oacute;n</td>
    </tr>
    <tr>
        <td valign="top"><cf_sifimportar EIcodigo="CONSULTA" mode="in" /></td>

        <td valign="top"><cf_sifimportar EIcodigo="CONSULTA" mode="out"/></td>
<!---

        <td valign="top"><cf_sifimportar EIcodigo="CG01" mode="out">
			<cf_sifimportarparam name="IDcontable" value="2500000000002497">
		</cf_sifimportar></td>
--->
    </tr>
</table>
</body>
</html>
