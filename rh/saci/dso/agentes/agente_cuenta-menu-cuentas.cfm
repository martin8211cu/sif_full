<!--- Obtener la lista de cuentas que posee la persona --->
<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select a.CTid, a.CUECUE, a.CTtipoUso
	from ISBcuenta a
	where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
	and a.CTtipoUso in ('A')
	<!---
	and a.CTtipoUso in ('A', 'F')
	--->
</cfquery>

<cfoutput>
	<cf_web_portlet_start tituloalign="left" titulo="Usar Cuenta ...">
		<script language="javascript" type="text/javascript">
			function goPage2(f, paso) {
				if (paso == 99) {
					f.paso.value = '1';
					f.cue.value = '';
					f.submit();
				} else if (paso == 98) {
					if (arguments[2] != undefined) {
						f.cue.value = arguments[2];
					}
					f.submit();
				} else {
					f.paso.value = paso;
					f.submit();
				}
			}
		</script>

		<form name="formCuadroCuentas" action="#CurrentPage#" method="get" style="margin: 0;">
			<cfinclude template="agente-hiddens.cfm">
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
			<!--- Mostrar las cuentas seleccionadas --->
			<cfloop query="rsCuentas">
			  <tr>
				<td>&nbsp;</td>
				<td align="center"><img src="/cfmx/saci/images/account.png" border="0"></td>
				<td  nowrap>
					<a href="javascript: goPage2(document.formCuadroCuentas, 98, '#rsCuentas.CTid#');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
						<cfif ExisteCuenta and rsCuentas.CTid EQ form.cue><strong></cfif>
							<cfif rsCuentas.CTtipoUso EQ 'U'>Cuenta <cfif rsCuentas.CUECUE GT 0>#rsCuentas.CUECUE#<cfelse>&lt;Por Asignar&gt;</cfif><cfelseif rsCuentas.CTtipoUso EQ 'A'>Cuenta de Acceso<cfelseif rsCuentas.CTtipoUso EQ 'F'>Cuenta de Facturaci&oacute;n</cfif>
						<cfif ExisteCuenta and rsCuentas.CTid EQ form.cue></strong></cfif>
					</a>
				</td>
			  </tr>
			</cfloop>
			</table>
		</form>
	<cf_web_portlet_end>  
</cfoutput>
