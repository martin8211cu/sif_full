<cf_templateheader title="Generaci&oacute;n del Archivo de Presupuesto">
	<cf_web_portlet_start titulo="Generaci&oacute;n del Archivo de Presupuesto SIPP (Contraloría)">
	<br>
	<cf_dbfunction name="OP_concat" returnvariable="_Cat">
	<cf_dbfunction name="date_part" 		args="mm,CPPfechaDesde" 	returnVariable="LvarMM_1" datasource="#session.dsn#">
	<cf_dbfunction name="date_format" 	args="CPPfechaDesde,YYYY" 	returnVariable="LvarYY_1" datasource="#session.dsn#">
	<cf_dbfunction name="date_part" 		args="mm,CPPfechaHasta" 	returnVariable="LvarMM_2" datasource="#session.dsn#">
	<cf_dbfunction name="date_format" 	args="CPPfechaHasta,YYYY" 	returnVariable="LvarYY_2" datasource="#session.dsn#">
	<!---Periodo Presupuestal Activo--->
	<cfquery name="rsCPPeriodo" datasource="#session.dsn#">
		select CPPid, 
			case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '*' end
				#_Cat# ' de ' #_Cat# 
				case #preserveSingleQuotes(LvarMM_1)# when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '*' end
				#_Cat# ' ' #_Cat# #preserveSingleQuotes(LvarYY_1)#
				#_Cat# ' a ' #_Cat# 
				case #preserveSingleQuotes(LvarMM_2)# when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '*' end
				#_Cat# ' ' #_Cat# #preserveSingleQuotes(LvarYY_2)#
			as CPPdescripcion
		  from CPresupuestoPeriodo d
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			and CPPestado in (0,1)
	</cfquery>
	
	<cfquery name="rsCuentas" datasource="#session.dsn#">
		select distinct b.FPTVTipo,FPTVDescripcion 
		from FPEEstimacion a
			inner join TipoVariacionPres b
			on b.FPTVid = a.FPTVid
		where a.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<form name="form1" action="GeneraArchivo_SQL.cfm" method="post" onsubmit="funcGenerar(this);">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
            <tr>
                <td align="right"></td>
				 <tr>
                <td align="right"><strong>Periodo:</strong></td>
                <td>
						<select name="CPPid" id="CPPid">
							<cfoutput query="rsCPPeriodo">
								<option value="#rsCPPeriodo.CPPid#">#CPPdescripcion#</option>
							</cfoutput>
						</select>
					</td>
            </tr>				
            <tr>
                <td align="right"><strong>Tipo:</strong></td>
                <td>
						<select name="FPTVTipo" onchange="ajaxFunction_CheckCuenta(value);" >
						  <option value="">-Seleccione-</option>
						  <option value="01">Presupuesto Inicial</option>
						  <option value="02">Presupuesto Extraordinario</option>
						  <option value="03">Modificaciones Externas</option>
						  <option value="04">Modificaciones Internas</option>
						  <option value="05">Informes de Ejecución</option>
						  <option value="06">Liquidación</option>
						</select> 
               </td>
				</tr>
			<!---se incluyen los checks --->
				<tr>
					<td colspan="4" align="center">
						<table cellspacing="2">
							<tr>
								<td>
									<div id="contenedor_Cuenta"></div>
								</td>
							</tr>
						</table>
                <td align="center"><cf_botones values="Generar" names="Generar" tabindex="1">
                </td>
            </tr>
				
				<tr>
					<td colspan="3" align="left">
						<table cellspacing="2" border="0">
							<tr>
								<td width="20%">&nbsp;</td>
								<td>
									<div id="Sec"><strong>N° Secuencia:</strong>
										<cf_inputNumber name="secuencia" value="" enteros="4" decimales="0">
									</div>
								</td>
							</tr>
						</table>
                </td>
            </tr>
            <tr> 
               <td valign="top"></td>
            </tr>
        </table>
    </form>
	<cf_web_portlet_end>
	<cf_templatefooter>
	<cf_qforms objForm="objForm1" form="form1">
		<cf_qformsRequiredField name="FPTVTipo"	description="Tipo">
		<cf_qformsRequiredField name="secuencia"	description="Secuencia">
	</cf_qforms>

<!---AJAX--->
<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
	function ajaxFunction_CheckCuenta(){
			var ajaxRequest;  // The variable that makes Ajax possible!
			var vID_cuenta ='';
			vID_cuenta = document.form1.FPTVTipo.value;
		try{
		// Opera 8.0+, Firefox, Safari
			ajaxRequest = new XMLHttpRequest();
		} 
		catch (e){
		// Internet Explorer Browsers
			try{
				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
			} 
			catch (e) {
				try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
				} 
				catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}	
		}		
		ajaxRequest.open("GET", '/cfmx/sif/formulacion/Parametros/CheckCuenta.cfm?FPTVTipo='+vID_cuenta, false);
		ajaxRequest.send(null);
		document.getElementById("contenedor_Cuenta").innerHTML = ajaxRequest.responseText;
	
	fnCheck(vID_cuenta);
	limpiar();
	}		
//-->

	function algunoMarcado(f) { 
		if(f.FPTVTipo.value == 05) 
			return true;
	
		if(f.FPTVTipo.value == '') 
			return true;
		if(!f.dato && f.FPTVTipo.value != '') 
			return false;	
		if (f.dato.value) {
			return (f.dato.checked);
		} else {
			for (var i=0; i<f.dato.length; i++) {
				if (f.dato[i].checked) return true;
			}
	}
		return false;
	}
	function funcGenerar(){ 
		if (!algunoMarcado(document.form1)){
			alert("Se presentaron los siguientes errores:\n - Debe marcar uno o más registros.");
			return false;
		}
	}
	
	
	function limpiar(){
		document.form1.secuencia.value = "";
	}
	
	
	function fnCheck(value){ 
		if(value == 02 || value == 03 || value == 04 || value == 05)//02- extraordinario - 03-No modifica monto 04-Modifica monto hacia abajo - 05-Modifica monto hacia Arriba
			 {	
				objForm1.secuencia.required=true;
				document.getElementById("Sec").style.display="";
			 }
		else
			{
				objForm1.secuencia.required=false;
				document.getElementById("Sec").style.display="none";	
			}
	}
		fnCheck("");
</script>



