<style >
input{
	max-width:170px !important;
}
</style>
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cf_templatecss>
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
		<table style="width:inherit" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfif isdefined("Url.o") and not isdefined("Form.o")>
						<cfset Form.o = Url.o>
					</cfif>
					<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
						<cfset Form.sel = Url.sel>
					</cfif>
					<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
						<!--- se necesita para que se puede mandar por URL, desde tramites --->
						<cfset Form.DEid = Url.DEid>
					</cfif>
					<cfif isdefined("Url.RHAlinea") and not isdefined("Form.RHAlinea")>
						<!--- se necesita para que se puede mandar por URL, desde tramites --->
						<cfset Form.RHAlinea = Url.RHAlinea>
					</cfif>
					<!--- Parametros necesarios para entrar en modo consulta a la pantalla de acciones --->
					<cfset Form.Cambio = "CAMBIO">
					<cfset Lvar_Tramite = true>
					<cfset Request.ConsultaAcciones = 1>
					<table width="90%" border="0" cellspacing="0" cellpadding="0">
				  		<tr><td>
                        <cfinclude template="Acciones-form.cfm">
                        </td></tr>				  		<tr><td>&nbsp;</td></tr>
					</table>
				</td>	
			</tr>
		</table>	
</div>