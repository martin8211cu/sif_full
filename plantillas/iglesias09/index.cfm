<cfinclude template="/hosting/publico/ApplicationPublic.cfm">
<cf_template>
	<cf_templatearea name="title"></cf_templatearea>		
	<cf_templatearea name="left"><cfinclude template="pMenu.cfm"></cf_templatearea>	
	<cf_templatearea name="body">
		<table width="757" border="0" cellspacing="0" cellpadding="0">

			<tr>
				<td valign="top" background="imagenes/fon_top.jpg" height="138" width="463" class="right">
					&nbsp;<br>
					<p class="right"><img src="imagenes/e01.gif" width="30" height="30" alt="" border="0" hspace="10" align="left"><b>BIENVENIDO A<br>SU PORTAL CRISTIANO</b></p>
					<p>Bienvenido al portal cristiano SoyCristiano.net, en este sitio usted podr&aacute; enterarse de los aconteceres de nuestra iglesia, podr&aacute; contribuir al crecimiento, y podr&aacute; adquirir productos de inter&eacute;s cristiano. </p>
				</td>
				<td valign="top" background="imagenes/top03.jpg" style="background-repeat:no-repeat " height="138" width="294">
					<br><br><br>
					<cfinclude template="login-form2.cfm">
				</td>
			</tr>

			<tr>
				<td valign="top"><cfinclude template="indexcenter.cfm"></td>
				<td valign="top" background="imagenes/e03.gif">
					<cfinclude template="indexright.cfm">
				</td>
			</tr>

		</table>
	</cf_templatearea>
</cf_template>