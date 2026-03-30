<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="" method="post" name="form1" id="form1">
		
		<!---Query para la el combo de las cajas--->
		<cfquery  name="rsCajaChica" datasource="#session.dsn#">
			select 
				c.CCHid,
				c.CCHdescripcion,
				c.CCHcodigo,
				m.Miso4217
			from CCHica c
				inner join Monedas m
					on m.Mcodigo=c.Mcodigo
			where c. Ecodigo=#session.Ecodigo#
			and c.CCHestado='ACTIVA'
		</cfquery>
	
			<table width="100%">				
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong>Forma de Pago:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="FormaPago" id="FormaPago">
						<option value="">--</option>
						<option value="0">Tesoreria </option>
						<cfif rsCajaChica.RecordCount>
							<cfoutput query="rsCajaChica" group="CCHid">
								<option value="#rsCajaChica.CCHid#">#rsCajaChica.CCHcodigo#/#rsCajaChica.CCHdescripcion#-#rsCajaChica.Miso4217#</option>
							</cfoutput>
						</cfif>
						<option value="ALL">TODOS</option>                       
						</select>
					</td>
				</tr>
				<tr>
				<td align="right" valign="top" nowrap="nowrap"><strong>Estado:</strong></td>
				<td>
				  <select name="estadoLid" id="estadoLid" >
				     <option value="1">Liquidadas</option>
				     <option value="2">Aprobadas No entregadas</option> 
 				     <option value="3">Todos</option>					 
				  </select>
				</td>
				</tr>			
				<tr>
				<cfset fechainicial=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong>Fecha desde:</strong></td>
					<td><cf_sifcalendario name="desde" value="#fechainicial#" tabindex="1"></td>
				</tr>
				<tr>
				<cfset fechafinal=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong>Fecha hasta:</strong></td>
					<td><cf_sifcalendario name="hasta"  value="#fechafinal#" tabindex="1"></td>
				</tr>
				<tr><td align="center" colspan="5"><input type="button" value="Consultar" name="Generar" id="Generar" onclick="return sbSubmit();"/></td></tr>
			</table>
	
	</form>
<cfoutput>
<script language="javascript">
	function sbSubmit()
	{
		/*validar();*/
		var x=validar();
		if (x == false){
		return false;
		}
		else
		{	
			document.form1.action = "ReporteLiq_form.cfm";
		}		
			
		document.form1.submit();
		
	}
	function validar()
	{
		var error_input;
      	var error_msg = '';

		
			if (document.form1.FormaPago.value == "")
			{
				error_msg += "La Forma de pago no puede quedar en blanco.";
				error_input = document.form1.FormaPago;
			}			
		
		
		if (error_msg.length != "")
		{
			alert(error_msg);
			return false;
		}
		
	}
	

	
</script>
</cfoutput>