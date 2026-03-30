<cfif isDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
	<cflocation url="/cfmx/home/menu/index.cfm">
</cfif>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Inicio</cf_templatearea>
<cf_templatearea name="left">
<table width="16%" height="100" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber2" style="border-collapse: collapse">
        <tr>
          <td width="100%" height="27"><table width="98%"  border="0" align="left" cellpadding="0" cellspacing="0">
              <tr>
                <td bgcolor="#FFFFFF"><table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="98%" id="AutoNumber2">
                  <tr>
                    <td height="23" bgcolor="#FFFFFF"><table width="123%" height="100" border="0" cellpadding="0" cellspacing="0" bordercolor="#111111" id="AutoNumber2" style="border-collapse: collapse">
                        <tr>
                          <td width="100%" height="21" background="images/top1.jpg">
                            <p style="margin-top: 3; margin-bottom: 0; color: #FFFFFF; font-size: 14px;"><b> <font face="Verdana">Misi&oacute;n</font></b></td>
                        </tr>
                        <tr>
                          <td width="90%" background="images/fondo_rombos9.gif"><table width="190" border="0" cellspacing="3" cellpadding="3">
                              <tr>
                                <td width="177" class="paragraph  style14"><span class="style59">Proveer a nuestros Clientes de Innovaci&oacute;n e Infraestructura tecnol&oacute;gica para apoyar decididamente su desarrollo empresarial. </span></td>
                              </tr>
                          </table></td>
                        </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td width="100%" height="23" background="images/bottom1.jpg">
                      <p style="margin-top: 3; margin-bottom: 0; color: #FFFFFF; font-size: 14px;"><b> <font face="Verdana">Visi&oacute;n</font></b></td>
                  </tr>
                  <tr>
                    <td width="90%" background="images/fondo_rombos9.gif"><table width="189" border="0" cellspacing="3" cellpadding="3">
                        <tr>
                          <td width="177" class="paragraph  style14"><span class="style14 style18"><span class="style60">Mantenernos como una compa&ntilde;&iacute;a multinacional de vanguardia tecnol&oacute;gica, l&iacute;der en la distribuci&oacute;n de soluciones empresariales completas para la administraci&oacute;n corporativa de informaci&oacute;n en las &aacute;reas de Misi&oacute;n Cr&iacute;tica, Soporte a la Toma de Decisiones y Expansi&oacute;n del Negocio.</span></span></td>
                        </tr>
                    </table></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td bgcolor="#FFFFFF"><table width="189"  border="0" align="left" cellpadding="1" cellspacing="0">
                  <tr>
                    <td height="22" background="images/bottom1.jpg"><span class="style47"><font face="Verdana" size="2">L&iacute;neas de Negocio </font></span></td>
                  </tr>
                  <tr>
                    <td background="images/fondo_rombos7.gif"><span class="style14 style18"><span class="paragraph style14 style16"><img border="0" src="images/lineasnegocio.gif" width="189" height="115"></span></span></td>
                  </tr>
                </table></td>
              </tr>
              <tr>
                <td bgcolor="#FFFFFF"><span class="paragraph style14 style16"><img border="0" src="images/bottom1.jpg" width="191" height="30"></span></td>
              </tr>
          </table></td>
        </tr>
      </table>
</cf_templatearea>
<cf_templatearea name="body">


</head>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>


    <table width="100%">
      <tr>
        <td width="100%">
          <cfinclude template="/plantillas/light02/pubica2.cfm">
        </td>
        <td rowspan="4" valign="top">
          <cfif FindNoCase("/light02/index.cfm",CGI.SCRIPT_NAME) NEQ 0>
            <cfif isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
              <img border="0" src="images/bottom1.jpg" width="216" height="24">
              <cfinclude template="/plantillas/light02/login-form2.cfm">
              <img border="0" src="images/bottom1.jpg" width="216" height="24">
            </cfif>
          </cfif>
        </td>
      </tr>
      <tr>
        <td valign="top"> <br>
            <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber3">
              <tr>
                <td valign="top" width="80%"><div align="justify" class="style10">
                    <p class="style14">SOIN, Soluciones Integrales,S.A. se dedica a proveer a sus clientes de la m&aacute;s completa y avanzada tecnolog&iacute;a de informaci&oacute;n,brindando diversas soluciones empresariales a sistemas de misi&oacute;n cr&iacute;tica para mercados verticales.<br>
                Su estrategia se negocio se basa en la investigaci&oacute;n tecnol&oacute;gica permanente, entendimiento de la industria tecnol&oacute;gica, la representaci&oacute;n de productos l&iacute;deres y la transferencia de este conocimiento a sus clientes.<br>
                Cuenta con el mejor equipo humano,infraestructura tecnol&oacute;gica, un compendio de metodolog&iacute;as y las mejores pr&aacute;cticas a nivel mundial para garantizar &oacute;ptimos resultados en sus proyectos. </p>
                </div></td>
                <td width="65%" valign="top">[ productos ]</td>
              </tr>
              <tr>
                <td valign="top" colspan="2">
                  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber7" height="195">
                    <tr>
                      <td width="60%" valign="top" height="195">
                        <p style="margin: 0 15" align="justify">&nbsp; </p></td>
                      <td width="40%" valign="top" height="195">
                        <p align="left"></td>
                    </tr>
                </table></td>
              </tr>
          </table></td>
      </tr>
    </table>


<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>

</cf_templatearea>
</cf_template>