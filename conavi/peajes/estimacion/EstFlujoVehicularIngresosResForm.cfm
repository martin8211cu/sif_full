<cf_templateheader title="Estimación del Flujo vehicular e Ingresos">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de flujo vehicular y estimación ingresos Resumido">	

    <cfquery name="rsPeajes" datasource="#session.dsn#">
	    select Pid, Pdescripcion from Peaje where Ecodigo = #session.ecodigo#
	</cfquery>
	<form name="form1" action="EstFlujoVehicularIngresosRes.cfm" method="get" style="margin:0" onsubmit="return validar()">
		<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0" >
			<tr><td width="48%">&nbsp;</td>
			</tr> 
			<tr>
				<td class="tituloListas" nowrap align="center">
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Seleccione un año para ver las estimaciones: </strong>&nbsp;
					<select name="Periodo">
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
			  <td width="31%">
					<strong>Seleccione el peaje:</strong>					
                   <select name="Peaje" id="Peaje">
					<option value="">Seleccione</option>
					  <cfoutput query="rsPeajes">
						<option value="#rsPeajes.Pid#">#rsPeajes.Pdescripcion#</option>
					</cfoutput>
					<option value="all">Todos</option>
					</select>
			  </td>
			  <td width="21%" align="left">
			      <input type="submit" name="Generar" value="Generar"/>
			  </td>
			 
			</tr>
		  <tr><td>&nbsp;</td></tr>
		</table>
	</form>
	<cf_web_portlet_end>
	<script language="JavaScript1.2" type="text/javascript">
	function validar()
	{
         if (document.form1.Periodo.value == "" || document.form1.Peaje.value == "") 
		 {
           alert("El año y Peaje son requeridos, selecione una opción.");
		   return false;
         }			
		 return true;
    }
</script>
<cf_templatefooter>