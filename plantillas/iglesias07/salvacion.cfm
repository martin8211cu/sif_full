<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<cfquery name ="rsPlantilla" datasource="sdc">
select nombre from CuentaClienteEmpresarial where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.sitio.cliente_empresarial#">
</cfquery>

<cf_template>
	<cf_templatearea name="title">
	<style type="text/css">
<!--
.style2 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #000000;
}
.style3 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-weight: bold;
}
.style5 {color: #FF0000; font-style: italic; font-family: Verdana, Arial, Helvetica, sans-serif;}
.style6 {
	color: #666666;
	font-size: 12px;
}
.style7 {color: #666666}
-->
    </style>
<cfoutput>Salvación</cfoutput></cf_templatearea>	<cf_templatearea name="header">
	<cfinclude template="pUbica.cfm"></cf_templatearea>
	<cf_templatearea name="body">
	<cfinclude template="pNavegacion.cfm">
	

<table width="100%">
  <tr>
    <td colspan="2"><div align="right" class="style5"><strong>Cosas que se necesita saber y creer para tener vida eterna</strong> <span class="style7">--</span> <span class="style6">directamente de la Biblia.</span></div></td>
  </tr>
  <tr>
    <td width="76%"><p class="style3">Todos somos pecadores:</p>
      <p class="style2">Por cuanto todos pecaron, y est&aacute;n destituidos de la gloria de Dios. (Romanos 3:23)</p>
    <p class="style2">No podemos hacer nada bueno para pagar por nuestros pecados:</p>
    <p class="style2">No hay justo, ni aun uno... No hay quien haga lo bueno, no hay ni siquiera uno. (Romanos 3:10, 12b)</p>
    <p class="style2">Por las obras de la ley ning&uacute;n ser humano ser&aacute; justificado delante de &eacute;l. (Romanos 3:20)</p></td>
    <td width="24%"><img src="images/MiHijo.gif" width="250" height="186"></td>
  </tr>
  <tr><td colspan="2">
  <p class="style3">&nbsp;</p>
  <p class="style3">La muerte y el infierno es el precio de nuestros pecados:</p>  <p class="style2">La paga del pecado es muerte. (Romanos 6:23a)</p>
  <p class="style2">La muerte y el Hades fueron lanzados al lago de fuego. Esta es la muerte segunda. (Apocalipsis 20:14)</p>
  <p>&nbsp;</p>  <p class="style3">Jesucristo pag&oacute; el precio para salvarnos:</p>  <p class="style2">Cristo muri&oacute; por nuestros pecados, conforme a las Escrituras, y... resucit&oacute; al tercer d&iacute;a conforme a las Escrituras. (I Corintios 15:3-4)</p>
  <p class="style3">&nbsp;</p>
  <p class="style3">Tiene que creer que Jesucristo es su &uacute;nica esperanza para vida eterna:</p>  <p class="style2">Jes&uacute;s le dijo: Yo soy el camino, y la verdad, y la vida; nadie viene al Padre, sino por m&iacute;. (Juan 14:6)</p>
  <p><span class="style2">Cree en el Se&ntilde;or Jesucristo, y ser&aacute;s salvo, t&uacute; y tu casa. (Hechos 16:31)</span><br>
  </p>

</td>
</tr>
</table>
</cf_templatearea></cf_template>