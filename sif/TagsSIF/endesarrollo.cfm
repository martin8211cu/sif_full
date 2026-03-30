<!--- TAG para dar mantenimiento temporal, y que el usuario no vea errores desagradables al visualizar la página.
	Así se usa: <cf_endesarrollo ip="[ip de la pc desde la que se va a dar mantenimiento al proceso***]">
	*** Todas las demás ip sol observarán un mensaje de mantenimiento, y un link para regresar.
 --->
<cfparam name="Attributes.ip" default="" type="String">
<cfif session.sitio.ip neq Attributes.ip>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<p><em>
					<strong>En Desarrollo&nbsp;:&nbsp;</strong><br>
					<br>
						Este Proceso se encuentra en mantenimiento, les ofrecemos las disculpas del caso.
		  </em></p>			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<p>	
					<br>
					<a href="##" onClick="history.back()">Atrás.</a>
				</p>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3" align="center">
			<p>
				<br>
				<br>
				<br>
				<br>
				<br>
				<strong><h6><cfoutput>#Year(Now())#</cfoutput> (c) SOIN Soluciones Integrales S.A. </h6></strong>
			</p>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>