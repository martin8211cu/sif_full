<cfif isDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
	<cflocation url="/cfmx/home/menu/index.cfm">
</cfif>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Inicio
</cf_templatearea>
<cf_templatearea name="left"></cf_templatearea> <cf_templatearea name="body">
<table width="980"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="192" rowspan="2" valign="top"><table width="192"  border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td   bgcolor="#FFFFFF" align="center" width="1%" style="background-image:url(/cfmx/plantillas/login02/images/bottom2.jpg); margin-top: 3px; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold">Misi&oacute;n</td>
        </tr>
        <tr>
          <td   style="color: #003399;background-image:url(/cfmx/plantillas/login02/images/fondo_rombos9.gif);
														font-family: Arial;
														font-style: normal;
														font-weight: lighter;
														font-size: 14px;">Proveer a nuestros Clientes de Innovaci&oacute;n e Infraestructura tecnol&oacute;gica para apoyar decididamente su desarrollo empresarial.</td>
        </tr>
        <tr>
          <td   bgcolor="#FFFFFF" align="center" width="1%" style="background-image:url(/cfmx/plantillas/login02/images/bottom2.jpg);margin-top: 3px; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold;">Visi&oacute;n</td>
        </tr>
        <tr>
          <td   style="color: #003399;background-image:url(/cfmx/plantillas/login02/images/fondo_rombos9.gif);
														font-family: Arial;
														font-style: normal;
														font-weight: lighter;
														font-size: 14px;">Mantenernos como una compa&ntilde;&iacute;a multinacional de vanguardia tecnol&oacute;gica, l&iacute;der en la distribuci&oacute;n de soluciones empresariales completas para la administraci&oacute;n corporativa de informaci&oacute;n en las &aacute;reas de Misi&oacute;n Cr&iacute;tica, Soporte a la Toma de Decisiones y Expansi&oacute;n del Negocio.</td>
        </tr>
        <tr>
          <td   bgcolor="#FFFFFF" align="center" width="1%" style="background-image:url(/cfmx/plantillas/login02/images/bottom2.jpg);margin-top: 3px; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold;">Lineas de Negocio</td>
        </tr>
        <tr>
          <td><img src="images/lineasnegocio.gif" alt="L&iacute;neas de Negocio"> </td>
        </tr>
        </table></td>
    <td width="48" valign="top">&nbsp;</td>
    <td width="481" valign="top"><cfinclude template="/plantillas/login02/pubica2.cfm"></td>
	<td width="41" valign="top">&nbsp;</td>
	<td rowspan="2" valign="top" width="218">
		  <cfinclude template="login-form2.cfm">
	</td>
  </tr>
  <tr>
    <td valign="top" style="color: #003399;font-family: Arial;font-size: 14px;font-style: normal;font-weight: lighter;">&nbsp;</td>
    <td valign="top" style="color: #003399;font-family: Arial;font-size: 14px;font-style: normal;font-weight: lighter;"><p align="justify"><br>

      SOIN, Soluciones Integrales,S.A. se dedica a proveer a sus clientes de la m&aacute;s completa y avanzada tecnolog&iacute;a de informaci&oacute;n,brindando diversas soluciones empresariales a sistemas de misi&oacute;n cr&iacute;tica para mercados verticales.<br>
			Su estrategia se negocio se basa en la investigaci&oacute;n tecnol&oacute;gica permanente, entendimiento de la industria tecnol&oacute;gica, la representaci&oacute;n de productos l&iacute;deres y la transferencia de este conocimiento a sus clientes.<br>
			Cuenta con el mejor equipo humano,infraestructura tecnol&oacute;gica, un compendio de metodolog&iacute;as y las mejores pr&aacute;cticas a nivel mundial para garantizar &oacute;ptimos resultados en sus proyectos.</p>
	</td>
    <td valign="top" style="color: #003399;font-family: Arial;font-size: 14px;font-style: normal;font-weight: lighter;">&nbsp;</td>
  </tr>
</table>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
</cf_templatearea>
</cf_template>