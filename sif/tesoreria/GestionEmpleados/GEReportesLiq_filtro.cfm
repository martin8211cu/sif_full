<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" 
xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MsgError1" default="La forma de Pago no puede quedar en  blanco."
returnvariable="LB_MsgError1" xmlfile ="GEReportesLiq_filtro.xml"/>


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
					<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_FormaPago>Forma de Pago</cf_translate>:</strong></td>
					<td align="left" valign="top"nowrap="nowrap">
						<select name="FormaPago" id="FormaPago">
						<option value="">--</option>
						<option value="0"><cf_translate key=LB_Tesoreria>Tesoreria</cf_translate> </option>
						<cfif rsCajaChica.RecordCount>
							<cfoutput query="rsCajaChica" group="CCHid">
								<option value="#rsCajaChica.CCHid#">#rsCajaChica.CCHcodigo#/#rsCajaChica.CCHdescripcion#-#rsCajaChica.Miso4217#</option>
							</cfoutput>
						</cfif>
						<option value="ALL"><cf_translate key=LB_Todos>TODOS</cf_translate></option>                       
						</select>
					</td>
				</tr>
				<tr>
				<td align="right" valign="top" nowrap="nowrap"><strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong></td>
				<td>
				  <select name="estadoLid" id="estadoLid" >
				     <option value="1"><cf_translate key=LB_Liquidadas>Liquidadas</cf_translate></option>
				     <option value="2"><cf_translate key=LB_AprobadosNoEntregados>Aprobadas No entregadas</cf_translate></option> 
 				     <option value="3"><cf_translate key=LB_Todos>Todos</cf_translate></option>					 
				  </select>
				</td>
				</tr>			
				<tr>
				<cfset fechainicial=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong><cf_translate key=LB_FechaDesde>Fecha desde</cf_translate>:</strong></td>
					<td><cf_sifcalendario name="desde" value="#fechainicial#" tabindex="1"></td>
				</tr>
				<tr>
				<cfset fechafinal=DateFormat(Now(),'DD/MM/YYYY')>
					<td align="right" nowrap="nowrap"><strong><cf_translate key=LB_FechaHasta>Fecha hasta</cf_translate>:</strong></td>
					<td><cf_sifcalendario name="hasta"  value="#fechafinal#" tabindex="1"></td>
				</tr>
				<tr><td align="center" colspan="5">
                	<cfoutput><input type="button" value="#BTN_Consultar#" name="Generar" id="Generar" onclick="return sbSubmit();"/></cfoutput>
                </td></tr>
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
				error_msg += "#LB_MsgError1#";
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