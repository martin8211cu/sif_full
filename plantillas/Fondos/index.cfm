<cfif isDefined("session.Usucodigo") and session.Usucodigo NEQ 0>
	<cflocation url="/cfmx/home/menu/index.cfm">
</cfif>
<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	Inicio
</cf_templatearea>
<cf_templatearea name="left">
<table width="192"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td background="images/bottom2.jpg" bgcolor="#FFFFFF" align="center" width="1%" headers="21" style="margin-top: 3; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold">Misión</td>
  </tr>
  <tr>
    <td background="images/fondo_rombos9.gif" style="color: #003399;
														font-family: Arial;
														font-style: normal;
														font-weight: lighter;
														font-size: 14px;">Proveer a nuestros Clientes de Innovaci&oacute;n e Infraestructura tecnol&oacute;gica para apoyar decididamente su desarrollo empresarial.</td>
  </tr>
  <tr>
    <td background="images/bottom2.jpg" bgcolor="#FFFFFF" align="center" width="1%" headers="21" style="margin-top: 3; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold;">Visión</td>
  </tr>
  <tr>
    <td background="images/fondo_rombos9.gif" style="color: #003399;
														font-family: Arial;
														font-style: normal;
														font-weight: lighter;
														font-size: 14px;">Mantenernos como una compa&ntilde;&iacute;a multinacional de vanguardia tecnol&oacute;gica, l&iacute;der en la distribuci&oacute;n de soluciones empresariales completas para la administraci&oacute;n corporativa de informaci&oacute;n en las &aacute;reas de Misi&oacute;n Cr&iacute;tica, Soporte a la Toma de Decisiones y Expansi&oacute;n del Negocio.</td>
  </tr>
  <tr>
    <td background="images/bottom2.jpg" bgcolor="#FFFFFF" align="center" width="1%" headers="21" style="margin-top: 3; margin-bottom: 0; color: #FFFFFF; font-size: 14px; font-weight:bold;">Lineas de Negocio</td>
  </tr>
  <tr>
  	<td>
		<img src="images/lineasnegocio.gif">
	</td>
  </tr>  
</table>
</cf_templatearea>
<cf_templatearea name="body">
<table width="800"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top"><cfinclude template="/plantillas/login02/pubica2.cfm"></td>
	<td rowspan="2" valign="top" width="216">
		<cfif FindNoCase("/login02/index.cfm",CGI.SCRIPT_NAME) NEQ 0 and isDefined("Session.Usucodigo") and Session.Usucodigo is 0>
		  <img border="0" src="images/bottom1.jpg" width="216" height="24">
		  <cfinclude template="/plantillas/login02/login-form2.cfm">
		  <img border="0" src="images/bottom1.jpg" width="216" height="24">
	  	</cfif>
	</td>
  </tr>
  <tr>
    <td valign="top" style="color: #003399;font-family: Arial;font-size: 14px;font-style: normal;font-weight: lighter;"><p align="justify">SOIN, Soluciones Integrales,S.A. se dedica a proveer a sus clientes de la m&aacute;s completa y avanzada tecnolog&iacute;a de informaci&oacute;n,brindando diversas soluciones empresariales a sistemas de misi&oacute;n cr&iacute;tica para mercados verticales.<br>
			Su estrategia se negocio se basa en la investigaci&oacute;n tecnol&oacute;gica permanente, entendimiento de la industria tecnol&oacute;gica, la representaci&oacute;n de productos l&iacute;deres y la transferencia de este conocimiento a sus clientes.<br>
			Cuenta con el mejor equipo humano,infraestructura tecnol&oacute;gica, un compendio de metodolog&iacute;as y las mejores pr&aacute;cticas a nivel mundial para garantizar &oacute;ptimos resultados en sus proyectos.</p>
	</td>
  </tr>
</table>
<script type="text/javascript">
<!--
llenarLogin(document.login);
-->
</script>
</cf_templatearea>
</cf_template>