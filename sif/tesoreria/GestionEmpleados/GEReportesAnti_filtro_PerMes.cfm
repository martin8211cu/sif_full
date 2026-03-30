<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="GEReportesAnti_form_PerMes.cfm" method="post" name="form1" id="form1">
	
	<!--- obtener lista de periodos --->
	<cfquery name="rsPeriodo" datasource="#session.DSN#">
		SELECT DISTINCT GEDEperiodo AS Periodo FROM GEanticipoDetEmpleado WHERE Ecodigo=#session.Ecodigo# ORDER BY Periodo desc
	</cfquery>		
		<table width="100%">				
			<tr>
				<td align="right" valign="top" width="40%"><strong>Peri&oacute;do:</strong></td>
				<td align="left" valign="top" width="60%">
					<select onchange="javascript:cambiarmes()" name="periodo" id="periodo" >											
					<option value="all">TODOS</option>                       
					<cfoutput query="rsPeriodo">
						<option value="#rsPeriodo.Periodo#"> #rsPeriodo.Periodo# </option>
					</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
			<td align="right" valign="top" nowrap="nowrap"><strong>Mes:</strong></td>
				<td align="left" valign="top" nowrap="nowrap">
					<select name="mes" id="mes">		
						<option value="all">TODOS</option>
					</select>				
				</td>
			</tr>				
			<tr><td align="center" colspan="5"><input type="submit" value="Consultar" name="Generar" id="Generar" /></td></tr>
		</table>
	
	</form>
<cfoutput>
<script language="javascript">
	
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
	<!---funciones para cargar el mmeses del periodo --->
	function cambiarmes()
	{
		//tomo el valor del select
		var periodo;
		periodo = document.form1.periodo[document.form1.periodo.selectedIndex].value;
		//
		if (periodo !="all") {
		   //Se cargan las opciones del combo
		   //selecciono el array de meses de acuerdo al periodo
		   meslist=eval("mes_" + periodo);
		   meslistval=eval("mes_val" + periodo);
		   //calculo el numero de elementos
		   num_meslist = meslist.length;
		   //
		   document.form1.mes.length = num_meslist;
		   //
		   for(i=0;i < num_meslist;i++){
			  document.form1.mes.options[i].value=meslistval[i];
			  document.form1.mes.options[i].text=meslist[i];
			  document.form1.mes.options[i].alt=meslist[i];
			  document.form1.mes.options[i].title=meslist[i];
		   }
		}else{
		   
		   document.form1.mes.length = 1
		  
		   document.form1.mes.options[0].value = "all"
		   document.form1.mes.options[0].text = "Todos"
		}
		//seleccionar como seleccionada la opción primera
		document.form1.mes.options[0].selected = true 

	}
	
	<!--- cargar los datos para el 2do select --->
	<cfquery name="rsMeses" datasource="#session.DSN#">
		SELECT DISTINCT 
			GEDEperiodo AS Periodo, GEDEmes AS Mes,
			CASE WHEN GEDEmes=1 THEN 'Enero'
			WHEN GEDEmes=2 THEN 'Febrero'
			WHEN GEDEmes=3 THEN 'Marzo'
			WHEN GEDEmes=4 THEN 'Abril'
			WHEN GEDEmes=5 THEN 'Mayo'
			WHEN GEDEmes=6 THEN 'Junio'
			WHEN GEDEmes=7 THEN 'Julio'
			WHEN GEDEmes=8 THEN 'Agosto'
			WHEN GEDEmes=9 THEN 'Setiembre'
			WHEN GEDEmes=10 THEN 'Octubre'
			WHEN GEDEmes=11 THEN 'Noviembre'
			WHEN GEDEmes=12 THEN 'Diciembre' END as Descripcion			
		FROM GEanticipoDetEmpleado 
		WHERE Ecodigo=#session.Ecodigo#
		ORDER BY Periodo desc
	</cfquery>
	
	<cfset tmpPold=0>
	<cfset tmpP="">
	<cfset acumulador="">
					
	<cfloop query="rsMeses"><cfset tmpP=rsMeses.Periodo><cfif tmpP NEQ tmpPold><cfoutput>
	var mes_#rsMeses.Periodo# = [];
	var mes_val#rsMeses.Periodo# = [];
	mes_val#rsMeses.Periodo#.push('all');
	mes_#rsMeses.Periodo#.push('Todos');</cfoutput></cfif><cfoutput>
	mes_#rsMeses.Periodo#.push('#rsMeses.Descripcion#');
	mes_val#rsMeses.Periodo#.push('#rsMeses.Mes#');</cfoutput><cfset tmpPold=tmpP></cfloop>
	
	cambiarmes();
</script>
</cfoutput>