<cfset Request.PNAVEGACION_SHOWN = 1>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Login
</cf_templatearea>
<cf_templatearea name="left">

</cf_templatearea>
<cf_templatearea name="body">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head><title>MiGesti&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="signup.css" rel="stylesheet" type="text/css">
</head>
<body>
<center><table border="0" width="585" cellspacing="0" cellpadding="0">
<tr>
      <td width="1%">&nbsp;</td>
      <td><table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
            <td align="right" valign="bottom" class="e"><a href="signup-ayuda.cfm">Ayuda</a> 
              - <a href="../public/logout.cfm">Iniciar 
              sesi&oacute;n </a></td>
          </tr></table>
        <hr size="1"></td></tr></table>
  <table border="0" cellspacing="4" cellpadding="4" width="585" class="g">
    <tr class="h"> 
      <td>Bienvenido, <cfoutput>#session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#</cfoutput> </td>
    </tr>
    <tr> 
      <td class="t"><p>Felicidades, ya ingres&oacute; por primera vez al portal.<br>
          Por favor, t&oacute;mese unos segundos para realizar la inscripci&oacute;n 
          al portal, que consta de dos sencillos pasos:</p>
        <ol>
          <!---<li>Leer el contrato de adhesi&oacute;n al portal,</li>--->
          <li>Seleccionar un usuario definitivo, y</li>
          <li>Cambiar su contrase&ntilde;a, que solamente usted conozca y que 
            le garantice la integridad de sus operaciones en el portal.</li>
        </ol>
        </td>
    </tr>
	
 	 <form method="post" name="f" action="signup2.cfm" >
	 <!---
		esto se incluye para evitar un error reportado
		en EAS 5.2 al enviar de un formulario vacío --->
	 <input type="hidden" name="dummy" value="empty"/>
	 <tr><td align="center">
    <table align="center" cellspacing="4" cellpadding="4" border="0" >
      <tr> 
        <td height="32" align="center"><p> 
            <input type="button" value="Cancelar" onClick="self.location.href='../public/logout.cfm'" />
            <input type="submit" value="Acepto &gt; " />
          </p></td>
      </tr>
    </table>
		  </td></tr>
  </form>
	
	
	
    <tr>
      <td class="err"><cfif IsDefined("url.error")><cfoutput>#url.error#</cfoutput></cfif></td>
    </tr>
  </table>
  <br />

<!---

  <form method="post" name="f" action="signup2.cfm" >
    <table width="585" cellspacing="4" cellpadding="4" border="0" class="g" >
      <!--DWLayoutTable-->
      <tr > 
        <td width="567" height="37" class="h">1. Lea el contrato. </td>
      </tr>

	<!---	
      <tr> 

        <td height="62" valign="top" class="t">
			<cfinclude template="signup-contrato.inc">
		</td>
        </tr>
		--->

      <tr> 
        <td height="32" align="center"><p> 
            <input type="button" value="No acepto" onClick="self.location.href='../public/logout.cfm'" />
            <input type="submit" value="Acepto &gt; " />
          </p></td>
      </tr>
    </table>
  </form>
--->  
  </center>
</body>
</html>

</cf_templatearea>
</cf_template>
