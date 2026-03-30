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
        <td valign="top"><cf_sifimportar EIcodigo="DANIM" mode="in"></td>
        <td valign="top"><cf_sifimportar EIcodigo="CG01" mode="out"></td>
    </tr>
</table>
</body>
</html>
