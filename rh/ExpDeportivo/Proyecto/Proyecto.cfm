<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Instituciones"
Default="Administraci&oacute;n de Instituciones"
returnvariable="LB_Administracion_de_Instituciones"/>

<cf_templateheader title="#LB_Administracion_de_Instituciones#">
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
		<cfinclude template="Proyecto-lista.cfm">
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
					<cfinclude template="Proyecto-form.cfm">
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