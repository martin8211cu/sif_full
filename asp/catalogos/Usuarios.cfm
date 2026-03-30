<cf_templateheader title="Crear Usuarios">
	<cfif isdefined("Url.o") and not isdefined("Form.o")>
		<cfset Form.o = Url.o>
	</cfif>

	<script language="javascript" type="text/javascript">
		function showList(arg) {
			var a = document.getElementById("divUsuarios");
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

	<!--- Archivo que carga datos en session --->
	<cfinclude template="frame-config.cfm">

	<cfif not isdefined("Session.Progreso.CEcodigo")>
		<cfinclude template="Cuentas-lista.cfm">
	<cfelse>
		<div id="divUsuarios" style="display: none; ">
			<cfinclude template="Usuarios-lista.cfm">
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
					<cfinclude template="Usuarios-form.cfm">
				</td>
			</tr>
		</table>
		</div>
		<cfif isdefined("Form.o") and Form.o EQ 1>
			<script language="javascript" type="text/javascript">
				showList(true);
			</script>
		</cfif>
	</cfif>
<cf_templatefooter>