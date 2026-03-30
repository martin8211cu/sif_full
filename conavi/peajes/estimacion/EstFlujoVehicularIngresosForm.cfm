<cf_templateheader title="Estimación del Flujo vehicular e Ingresos">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de flujo vehicular y estimación ingresos">	
	<form name="form1" action="EstFlujoVehicularIngresos.cfm" method="get" style="margin:0">
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
			<tr><td>&nbsp;</td></tr> 
			<tr>
				<td class="tituloListas" nowrap align="center">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Seleccione un año para ver las estimaciones: </strong>&nbsp;
					<select name="Periodo" onchange="this.form.submit();">
					    <option value="" selected="selected">Seleccione</option>
						<option value="2007">2007</option>
						<option value="2008">2008</option>
						<option value="2009">2009</option>
						<option value="2010">2010</option>
						<option value="2011">2011</option>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
						<option value="2021">2021</option>
						<option value="2022">2022</option>
						<option value="2023">2023</option>
						<option value="2024">2024</option>
						<option value="2025">2025</option>
						<option value="2026">2026</option>
						<option value="2027">2027</option>
						<option value="2028">2028</option>
						<option value="2029">2029</option>
						<option value="2030">2030</option>
					</select>
					</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</form>
	<cf_web_portlet_end>
	<script language="JavaScript1.2" type="text/javascript">
	document.form1.Periodo.focus();		
</script>
<cf_templatefooter>