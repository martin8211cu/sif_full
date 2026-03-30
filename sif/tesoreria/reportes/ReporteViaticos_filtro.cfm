<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="" method="post" name="form1" id="form1">
			<table width="100%">
				<tr>
				  <td nowrap="nowrap" align="right"><strong>Oficina desde: </strong> </td>
				  <td align="left"> 
					<cf_conlis title="LISTA DE OFICINAS"
					campos = "OcodigoIni, OficodigoIni,OdescripcionIni" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="OcodigoIni, OficodigoIni,OdescripcionIni"
					asignarformatos="S,S"
					tabla="Oficinas"
					columnas="Ocodigo as OcodigoIni, Oficodigo as OficodigoIni, Odescripcion as OdescripcionIni"
					filtro="Ecodigo = #Session.Ecodigo# order by Ocodigo"
					desplegar="OficodigoIni , OdescripcionIni"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontraron Oficinas --"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="Oficodigo,Odescripcion"
					index="1"			
					/>   
				 	</td>
				</tr>
				<tr>
				  <td nowrap="nowrap" align="right"><strong>Oficina Hasta: </strong> </td>
				  <td align="left"> 

					<cf_conlis title="LISTA DE OFICINAS"
					campos = "OcodigoFin,OficodigoFin, OdescripcionFin" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="OcodigoFin, OficodigoFin,OdescripcionFin"
					asignarformatos="S,S"
					tabla="Oficinas"
					columnas="Ocodigo as OcodigoFin, Oficodigo as OficodigoFin,Odescripcion as OdescripcionFin"
					filtro="Ecodigo = #Session.Ecodigo# order by Ocodigo"
					desplegar="OficodigoFin, OdescripcionFin"
					etiquetas="Codigo,Descripción"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg="-- No se encontraron Oficinas --"
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="Oficodigo,Odescripcion"
					index="1"			
					/>   
				 	</td>
				</tr>
				
				<tr>
				  <td nowrap="nowrap" align="right"><strong>Empleado: </strong> </td>
				  <td align="left"> 
					  <cf_conlis title="LISTA DE EMPLEADOS"
					campos = "DEid, DEidentificacion, DEnombre" 
					desplegables = "N,S,S" 
					modificables = "N,S,N" 
					size = "0,15,34"
					asignar="DEid, DEidentificacion, DEnombre"
					asignarformatos="S,S,S"
					tabla="DatosEmpleado"
					columnas="DEid, DEidentificacion, DEnombre #LvarCNCT#' '#LvarCNCT# DEapellido1 #LvarCNCT#' '#LvarCNCT# DEapellido2 as DEnombre"
					filtro="Ecodigo = #Session.Ecodigo#"
					desplegar="DEidentificacion, DEnombre"
					etiquetas="Identificacin,Nombre"
					formatos="S,S"
					align="left,left"
					showEmptyListMsg="true"
					EmptyListMsg=""
					form="form1"
					width="800"
					height="500"
					left="70"
					top="20"
					filtrar_por="DEidentificacion,DEnombre"
					index="1"			
					/>   
				 	</td>
				</tr>
				<tr>
				<cfset fechainicial=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong>Fecha desde:</strong></td>
					<td><cf_sifcalendario name="FechaDesde" value="#fechainicial#" tabindex="1"></td>
				</tr>
				<tr>
				<cfset fechafinal=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong>Fecha hasta:</strong></td>
					<td><cf_sifcalendario name="FechaHasta"  value="#fechafinal#" tabindex="1"></td>
				</tr>
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong>Tipo Viatico:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="tipoViatico" id="tipoViatico" tabindex="1">
						<option value="-1">TODOS</option>
						<option value="1"> Interior</option>
						<option value="2"> Exterior</option>
						</select>			
				  </td>
				</tr>
				<tr><td align="center" colspan="5"><input type="button" value="Consultar" name="Generar" id="Generar" onclick="return sbSubmit(this);"/></td></tr>
			</table>
	
	</form>
<cf_qforms form="form1">
<script language="javascript1" type="text/javascript">
	function sbSubmit()
	{

		var x=validar();
		if (x == false)
		{
			return false;
		}
		else
		{
			document.form1.action = "ReporteViaticos_form.cfm";
		}
		
			
		document.form1.submit();
		
	}
	function validar()
	{
		var error_input;
      	var error_msg = '';

			
			if (document.form1.FechaDesde.value == "")
			{
				error_msg += "\n - La Fecha Desde no puede quedar en blanco.";
				error_input = document.form1.FechaDesde;
			}
			if (document.form1.FechaHasta.value == "")
			{
				error_msg += "\n - La Fecha Hasta no puede quedar en blanco.";
				error_input = document.form1.FechaHasta;
			}
	
		
		if (error_msg.length != "")
		{
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		
	}
</script>
