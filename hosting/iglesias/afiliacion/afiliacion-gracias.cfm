<cfif isdefined("Form.btnRegistrar") and Form.btnRegistrar EQ 'GUARDAR'>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cf_template>
	<cf_templatearea name="title">
		<cfif modo EQ "ALTA">
			Registro de Feligr&eacute;s Aceptado
		<cfelse>
			Datos Actualizados
		</cfif>
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
	<cfoutput>
		<form name="form1" action="afiliacion.cfm" method="post">
			<input type="hidden" name="empr" value="#Form.empr#">
			<input type="hidden" name="btnNuevo" value="Nuevo">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; ">
					<span class="titulo">
					<cfif modo EQ 'ALTA'>
						El feligr&eacute;s #Form.Pnombre#&nbsp;#Form.Papellido1#&nbsp;#Form.Papellido2# ha sido registrado!
					<cfelse>
						Los datos del feligr&eacute;s #Form.Pnombre#&nbsp;#Form.Papellido1#&nbsp;#Form.Papellido2# han sido actualizados!
					</cfif>
					</span>
					<br>
					<br>
					<cfif isdefined("Form.chkGenerar")>
					Su cuenta de acceso al portal es:&nbsp; <strong>#Form.Pemail1#</strong>
					</cfif>
					<br>
					Para continuar registrando feligreses oprima el bot&oacute;n de "CONTINUAR".<br>
					Para ir a la lista de feligreses oprima el bot&oacute;n de "LISTA".<br>
				</td>
			  </tr>
			  <tr>
				<td align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td align="center">
					<input type="submit" name="btnContinuar" value="CONTINUAR">
					<input type="button" name="btnLista" value="LISTA" onClick="javascript: location.href='/cfmx/hosting/iglesias/afiliacion/afiliacion.cfm?empr=#Form.empr#';">
				</td>
			  </tr>
			</table>
		</form>
	</cfoutput>	
	</cf_templatearea>
</cf_template>
