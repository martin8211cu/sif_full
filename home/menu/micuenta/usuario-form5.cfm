<cfif findnocase('google',application.politicas_pglobal.auth.orden)>      
	<table width="100%">
		<tr>
			<td width="100%" align="center">
				<button type="button" class="btnNormal" target="_blank" style="text-align:center"  onClick="window.open('https://www.google.com/accounts/recovery?service=mail');"><cf_translate key="LB_IrGoogle" xmlFile="index.xml">Ir a cambio de contraseña de Google</cf_translate><i class="fa fa-external-link"></i></button>
    		</td>
    	</tr>	
    </table>
<cfelse>
	<cfif IsDefined('url.ok') and url.ok eq 1>
		<cfinclude template="usuario-form5ok.cfm">
	<cfelse>
		<cfinclude template="usuario-form5ch.cfm">
	</cfif>
</cfif>	