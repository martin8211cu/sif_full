<cf_templateheader title="Crear Cuentas Empresariales">
	<cfif isdefined("Url.o") and not isdefined("Form.o")>
		<cfset Form.o = Url.o>
	</cfif>

	<script language="javascript" type="text/javascript">
		function showList(arg) {
			var a = document.getElementById("divCuentas");
			var b = document.getElementById("divForm");
			if (a != null && b != null) {
				if (arg) {
					a.style.display = ''
					b.style.display = 'none'
				} else {
					a.style.display = 'none'
					b.style.display = ''
				}
			}
		}
	
	</script>

	<!--- Codigo cuando se quiere crear una nueva cuenta empresarial se borra de session --->
	<cfif isdefined("Form.o") and Form.o EQ 2>
		<cfinclude template="Finalizar.cfm">
	</cfif>

	<!--- Archivo que carga datos en session --->
	<cfinclude template="frame-config.cfm">

	<div id="divCuentas" style="display: none; ">
		<cfinclude template="Cuentas-lista.cfm">
	</div>
	<div id="divForm">
		<table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="frame-header.cfm">
				</td>
			</tr>
			<tr>
				<td valign="top">
					<cfinclude template="Cuentas-form.cfm">
				</td>
			</tr>
		</table>
	</div>

	<cfif isdefined("Form.o") and Form.o EQ 1>
		<script language="javascript" type="text/javascript">
			showList(true);
		</script>
	</cfif>
<cf_templatefooter>