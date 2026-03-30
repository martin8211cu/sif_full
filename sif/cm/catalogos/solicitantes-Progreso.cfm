<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
<cfset pagina = "/sif/cm/catalogos/" & CurrentPage>
<cfif acceso_uri(pagina)>
	<cfoutput>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
		<table border="0" cellpadding="2" cellspacing="0">
			<!--- 0, Página Inicial --->
			<tr>
				<td style="border-bottom: 1px solid black; ">
					<cfif Session.Compras.Solicitantes.Pantalla EQ "0">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					<cfelse>
						&nbsp;
					</cfif>
				</td>
				<td align="center" style="border-bottom: 1px solid black; "> <img src="/cfmx/sif/imagenes/home.gif" border="0"> </td>
				<td class="etiquetaProgreso" style="border-bottom: 1px solid black; " nowrap><a href="javascript: goPage('0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;"><strong>Lista de Solicitantes</strong></a></td>
				<td rowspan="100" width="1%">&nbsp;&nbsp;&nbsp;</td>
			</tr>

			<!--- 1, Solicitantes --->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Compras.Solicitantes.Pantalla") and Compare(Session.Compras.Solicitantes.Pantalla,"1") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Compras.Solicitantes.Pantalla EQ "1">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/number1_16.gif" border="0"> </td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('1');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Solicitantes</a></td>
			</tr>

			<!--- 2, Solicitantes por Centro Funcional --->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Compras.Solicitantes.Pantalla") and Compare(Session.Compras.Solicitantes.Pantalla,"2") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Compras.Solicitantes.Pantalla EQ "2">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/number2_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('2');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Centros Funcionales por Solicitante</a></td>
			</tr>

			<!--- 3, Especializacion de Solicitantes --->
			<tr>
				<td width="1%" align="right">
					<cfif isdefined("Session.Compras.Solicitantes.Pantalla") and Compare(Session.Compras.Solicitantes.Pantalla,"3") GT 0>
						<img src="/cfmx/sif/imagenes/w-check.gif" border="0">
					<cfelseif Session.Compras.Solicitantes.Pantalla EQ "3">
						<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
					</cfif>
				</td>
				<td align="right"><img src="/cfmx/sif/imagenes/number3_16.gif" border="0"></td>
				<td class="etiquetaProgreso" nowrap><a href="javascript: goPage('3');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">Especialización de Solicitantes</a></td>
			</tr>
		</table>
		<cf_web_portlet_end> 
		<form name="formOpt" action="#CurrentPage#" method="post">
			<input type="hidden" name="opt" value="">
		</form>
		<script language="javascript" type="text/javascript">
			function goPage(opt) {
				<cfif not isdefined("Session.Compras.Solicitantes.CMSid") or (isdefined("Session.Compras.Solicitantes.CMSid") and len(trim(Session.Compras.Solicitantes.CMSid)) eq 0)>
					if (opt == 2 || opt == 3) {alert("Debe seleccionar un Solicitante!"); return;}
				</cfif>
				document.formOpt.opt.value = opt;
				document.formOpt.submit();
			}
		</script>
	</cfoutput>
</cfif>