
<cfparam name="session.template" default="template034">
<cfif IsDefined("url.SetTemplate") and Len(url.SetTemplate) NEQ 0>
	<!--- este Replace es para despistar sobre la ubicación de los templates --->
	<cfset session.template = Replace(url.SetTemplate, 'standard','template')>
</cfif>
<cf_template template="/hosting/iglesias/#session.template#.cfm">
<html><!-- InstanceBegin template="/Templates/template.dwt.cfm" codeOutsideHTMLIsLocked="true" -->
<cf_templatearea name="title"><!-- InstanceBeginEditable name="Title" -->Iglesia Adventista de Tres Ríos<!-- InstanceEndEditable -->
</cf_templatearea>
<br>
<cf_templatearea name="body"><!-- InstanceBeginEditable name="Body" -->

<table width="100%" border="0">
  <tr>
    <td width="63%"><span class="style2 style6"><font face="arial, helvetica, verdana" 
      size=2><img src="images/pastor-8.jpg" width="271" height="211"></font></span></td>
    <td width="37%" rowspan="2" valign="top" ><table width="200" border="0">
        <tr>
          <td   bgcolor="#993300"><span class="style1"><strong> &nbsp;Noticias</strong></span></td>
        </tr>
        <tr>
          <td><span class="style2 style6"><em><strong>Bus</strong></em></span><span class="style2 style6"><em><strong>car el auxilio de la religi&oacute;n. </strong></em> Ante el deterioro social. <br>
            El deterioro del ser humano supera a los organismos y personas de buena voluntad que tienen una ardua labor al buscar el bienestar econ&oacute;mico, psicol&oacute;gico y espiritual de las personas, as&iacute; que hay que redoblar los esfuerzos para conseguirlo, pero s&oacute;lo se lograr&aacute; el resultado adecuado si cada persona afectada se pone a trabajar con ella misma, siendo la &uacute;nica responsable de sus actos y de su recuperaci&oacute;n <a href="http://edicion.yucatan.com.mx/noticias/noticia.asp?cx=11$4103060000$2452260" class="style13">...</a></span></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td valign="top"><span class="style2 style7">Bienvenido hermano al sitio oficial de nuestra iglesia. En ella podr&aacute; encontrar elementos de utilidad en nuestra lucha diaria por hacer llegar el evangelio a todas las criaturas. <br>
            <a href="?SetTemplate=standard042">[Bible]</a> <a href="?SetTemplate=standard555">[Musical]</a> <a href="?SetTemplate=standard034">[Computer Store]</a> </span></td>
  </tr>
</table>
<!-- InstanceEndEditable --></cf_templatearea>
<!-- InstanceEnd --></html>
</cf_template>