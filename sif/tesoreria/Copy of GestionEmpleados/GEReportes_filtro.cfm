<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<form  action="" method="post" name="form1" id="form1">
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select llave as DEid
			from UsuarioReferencia
			where Ecodigo= #session.Ecodigo#
			and STabla	= 'DatosEmpleado'
		</cfquery>
		<cfset LvarDEID=#rsSQL.DEid#>
		
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
					traerInicial="#LvarDEID NEQ ''#"
					traerFiltro="DEid=#LvarDEid#"
					funcion="funcCambiaDEid"
					fparams="DEid"
					/>   
				 	</td>
				</tr>
				<tr>
					<td align="right" valign="top" nowrap="nowrap"><strong>Estado:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="AFTRtipo" id="AFTRtipo" tabindex="1">
						<option value="-1">TODOS</option>
						<option value="0">En Preparación</option>
						<option value="1">En Aprobación</option>
						<option value="2">Aprobadas</option>
						<option value="3">Rechazadas</option>
						<option value="4">Finalizada</option>
						<option value="5">Por Reintegrar</option>
						<option value="4">Pagada</option>
						<option value="5">Liquidada</option>
						<option value="6">Terminada</option>
						</select>			
				  </td>
				</tr>
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
				<tr><td align="center" colspan="5"><input type="button" value="Consultar" name="Generar" id="Generar" onclick="return sbSubmit(this);"/></td></tr>
			</table>
	
	</form>
<script language="javascript">
	function sbSubmit()
	{
		/*validar();*/
		var x=validar();
		if (x == false){
		return false;
		}
		else{
		if (document.form1.DEid.value == "")
		{
			document.form1.action = "GEReportes_form.cfm";
		}
		else
		{
			document.form1.action = "ReporteTramitesform.cfm";
		}
		
			
		document.form1.submit();
		}
	}
	function validar()
	{
		var error_input;
      	var error_msg = '';

		if (document.form1.AFTRtipo.value != 0 && document.form1.AFTRtipo.value != 1 && document.form1.DEid.value=="")
		{	
			if (document.form1.desde.value == "")
			{
				error_msg += "\n - La Fecha Desde no puede quedar en blanco.";
				error_input = document.form1.desde;
			}
			if (document.form1.hasta.value == "")
			{
				error_msg += "\n - La Fecha Hasta no puede quedar en blanco.";
				error_input = document.form1.hasta;
			}
		}
		
		if (error_msg.length != "")
		{
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
		
	}
</script>