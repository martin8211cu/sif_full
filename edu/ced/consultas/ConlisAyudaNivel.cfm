<cfinclude  template="../../Utiles/general.cfm">
<html>
<head>
<title>Ayuda del Portal: </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="../../css/edu.css" rel="stylesheet" type="text/css">
</head>


<body>
<form action="" method="post" name="conlis">
  <table width="100%" height="274" border="0" cellspacing="0">
    <tr> 
      <td height="32" bgcolor="#006699" class="titulo"> <div align="center"><font color="#FFFFFF">Ayuda 
          de Niveles</font></div>
        <div align="right"><font color="#FFFFFF"> </font></div></td>
    </tr>
    <tr> 
      <td><p><strong>E</strong>n la ventana principal, en el lado <strong>izquierdo</strong> 
          de su pantalla, se mostrarán los niveles que usted ha estipulado como 
          parte de la oferta académica de la institución. </p></td>
    </tr>
    <cfoutput> </cfoutput> 
    <tr>
      <td><p><strong>E</strong>n la ventana principal, en el lado <strong>Derecha</strong> 
          de su pantalla, se mostrarán los atributos correspondientes para ese 
          nivel, a saber:</p>
        <p><font size="2"><strong>Descripcion:</strong></font> Es el nombre descriptivo 
          del nivel, este puede ser: bimestral, trimestral y semestral o la combinación 
          de varios rubros. Ej: Primaria, Secundaria, Etc...</p>
        <p><strong><font size="2">Porcentaje M&iacute;nimo de Aprovechamiento:</font></strong> 
          Es la nota minima de requerida, para que el alumno apruebe ese nivel. 
        </p>
        <p> <strong><font size="2">Orden:</font></strong> Es el orden de precedencia 
          en el tiempo, de ese nivel, ej: Maternal antes que Primaria. Se utilizan 
          números en múltiplos de 10. </p></td>
    </tr>
    <tr> 
      <td align="center">
<p> <input name="Cerrar" type="button" value="Cerrar" onClick="javascript:window.close();">
        </p>
        </td>
    </tr>
    <tr>
     
    </tr>
  </table>

</form>
</body>
</html>

