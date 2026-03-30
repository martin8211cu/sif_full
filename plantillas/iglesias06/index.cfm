<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<style type="text/css">
<!--
.style5 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	color: #695E3C;
	font-size: 18px;
	font-weight: bold;
}
.style6 {
	font-size: 12px;
	font-weight: bold;
}
.style7 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
}
.style10 {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
	color: #993300;
	font-weight: bold;
}
-->
</style>
<table width="100%"><tr><td>
<cf_template>
	<cf_templatearea name="title"><cfoutput>#iif(len(trim(session.enombre)) gt 0,DE(session.enombre),DE(session.cenombre))#</cfoutput></cf_templatearea>	
	<cf_templatearea name="header"><cfinclude template="/plantillas/iglesias06/pUbica.cfm"></cf_templatearea>
	<cf_templatearea name="left"><cfinclude template="/hosting/publico/pMenu.cfm"></cf_templatearea>	
	<cf_templatearea name="body">
<cfoutput>

<table  width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <th scope="col"><div align="left"><span class="style5">El Plan de Dios para los 
                hombres </span></div></th>
  </tr>
  <tr>
    <td>
</br>
<ol>
                <li><span  class="style6">Dios le ama y ha creado y ha creado un maravilloso 
                  Plan especialmente para usted.</span> 
                  <p>
          "Porque de tal manera amó Dios al mundo, que ha dado a su Hijo unigénito , para que todo aquel que en él cree, no se pierda, mas tenga vida eterna." Juan 3:16. Vea también Juan 10:10.</p>
    </li>
      <li><span class="style6">El Hombre es pecador y el pecado le separa de Dios.</span>
        <p>
          "Por cuanto todos pecaron, y están destituidos de la gloria de Dios." Romanos 3:23. Vea también Romanos 6:23.</p>
      </li>
      <li><span class="style6">JESUCRISTO es la provisión de Dios para el pecador. Solamente a través de El puede usted acercarse a Dios.</span>
        <p>
          "Mas Dios muestra su amor para con nosotros, en que siendo aún pecadores , Cristo murió por nosotros." Romanos 5:8. Vea también Juan 14:6 y 2 Corintios 5:21.</p>
      </li>
      <li><span class="style6">Por medio de un acto de nuestra propia voluntad debemos recibir a CRISTO. La invitación es personal.</span>
        <p>
          " Mas a todos los que le recibieron, a los que creen en su nombre, les dio potestad de ser hechos hijos de Dios." Juan 1:12. Vea también Apocalipsis 3:20.</p>
      </li>
  </ol>
</td>
  </tr>
  <tr>
    <td><div align="center">
      <table width="100%"  border="0" align="left" cellpadding="0" cellspacing="0">
        <tr>
          <td align="center" width=""><span class="style6">Visite el templo, comparta una sonrisa con Dios!!!</span></br></td>
        </tr>
        <tr>
          <td align="center" width=""><img src="images/sonrisa.gif" width="156" height="113"></td>
        </tr>
      </table>
      </div></td>
    </tr>
</table>
</cfoutput></cf_templatearea></cf_template>
</td></tr>
</table>