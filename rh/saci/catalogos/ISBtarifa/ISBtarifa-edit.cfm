<cf_templateheader title="Mantenimiento de Tarifas">
	
<cf_web_portlet_start titulo="Mantenimiento de Tarifas">
	<cfparam name="url.TAtarifa" default="">
	<cfparam name="url.TAlinea" default="">
	
	<table width="900" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td colspan="2" class="subTitulo">
				Encabezado de la tarifa
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<cfinclude template="ISBtarifa-form.cfm">
			</td>
		</tr>
		<cfif Len(url.TAtarifa)>
			<tr>
				<td colspan="2" class="subTitulo">
					Tipos de la tarifa
				</td>
			</tr>
			<tr>
				<td valign="top"><cfinclude template="ISBtarifaDetalle.cfm"></td>
				<td valign="top"><cfinclude template="ISBtarifaDetalle-form.cfm"></td>
			</tr>
		</cfif>
		<cfif Len(url.TAtarifa) and Len(url.TAlinea)>
			<tr>
				<td colspan="2" class="subTitulo">
					Horarios para esta tarifa
				</td>
			</tr>
			<tr>
				<td valign="top"><cfinclude template="ISBtarifaHorario.cfm"></td>
				<td valign="top"><cfinclude template="ISBtarifaHorario-form.cfm"></td>
			</tr>
		</cfif>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>

<script type="text/javascript">
<!--
	cambioUnidad(document.form1.TAunidades.value);
//-->
</script>