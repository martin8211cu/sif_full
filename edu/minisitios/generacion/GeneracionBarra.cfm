<cfquery datasource="sdc" name="nombre">
	select Snombre
	from Sitio
	where Scodigo = #Scodigo#
</cfquery>

<html>
<link type='text/css' rel='stylesheet' href='shared/minisitio.css' >
<head>
<title><cfoutput>#nombre.Snombre#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td valign="top"  align="right">
        <!--- <a target="_top" href="/SDC/inicio.html"> --->
        <img src="/recursos/logo/LOGO-migestion2.gif"
            width="146px"
            border="0"
            alt="Regresar a migestion.net" >
       <!---  </a> --->
    </td>
 <td width="5%"></td>
    <td width="59%" background="shared/background.gif"> 
      <div align="center"><font size="+3"><cfoutput>#nombre.Snombre#</cfoutput></font></div>
    </td>
 <td width="5%"></td>
    <td valign="top" align="left">
	<cfoutput>
          <img src="/jsp/DownloadServlet/MiniSitios/logo.jpg?Scodigo=#Scodigo#" height="89px" border="0">
	</cfoutput>
    </td>

  </tr>
  <tr>
     <td colspan="4"><hr width="95%"></td>
  </tr>
  <tr>
     <td colspan="2" bgcolor="#005555"><font color="white" size="1" > 
     <script type="text/javascript">
     <!--
        var d = new Date;
        var meses = new Array("Enero", "Febrero", "Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre");
        var dias = new Array("Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo");
        document.writeln("<b><i>&nbsp&nbsp&nbsp&nbsp"+d.getDate() + " de " + meses[d.getMonth()] + " de " + d.getYear()+"</i></b>");
     -->
    </script>
    </td>
        <th colspan="3" bgcolor="#005555">
        <div align="left">
            <font size="2" color="white" valign="left"><i><b></b></i></font></div>
    </th>
  </tr>
</table>
</body>
</html>
