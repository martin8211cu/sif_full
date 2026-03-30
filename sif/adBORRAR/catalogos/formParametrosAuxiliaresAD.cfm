<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 19-7-2005.
		Motivo: Se quita un botón de aceptar duplicado. Alguién lo dejó por error
	Modificado por Rodolfo Jiménez Jara
		Fecha: 01/09/2005.
		Motivo: Se agregó parámetro	740 de No contabiliza el costo de ventas ni ajustes, valore 1= No contabiliza, 0 = Sí Contabiliza
		
	Modificado por: Ana Villavicencio Rosales
	Fecha: 05 de Setiembre del 2005
	Motivo: Se agregó el parámetro 750 Indicador del idioma en letras. Se colocó en un nuevo apartado Invetarios.
	
	Modificado por:Ana Villavincencio
	Fecha: 12 de setiembre del 2005
	Motivo: Eliminar el apartado de inventarios para el idioma del monto en letras para facturas.  Parametro 750.
	
 --->

<cfset hayCuentaBalAsi = 0 >
<cfset hayCuentaDifCambAsi  = 0>
<cfset hayCuentaEstimacion  = 0>
<cfset hayVencimiento1 = 0 >
<cfset hayVencimiento2 = 0 >
<cfset hayVencimiento3 = 0 >
<cfset hayVencimiento4 = 0 >
<cfset hayTipoRequisicion = 0 >
<cfset haySolicitante = 0 >
<cfset hayAutorizacion 	= 0 >
<cfset hayConsReq 		= 0 >
<cfset haycalculoImp = 0 >
<cfset haySupervisor = 0 >
<cfset hayCierreCaja = 0 >
<cfset hayAumentaConsecutivo = 0 >
<cfset hayPlanCuentas = 0 >
<cfset hayValidaProduccion = 0 >
<cfset haySocioImportacion = 0 >
<cfset hayTransaccionCP = 0 >
<cfset hayTransaccionCC = 0 >
<cfset hayImpuestos = 0 >
<cfset hayNomina = 0 >
<cfset hayTransaccionCCInterfaz = 0>
<cfset hayTransaccionCPInterfaz = 0>

<cfset hayFormatoCedulaJuridica = 0 >
<cfset hayFormatoCedulaFisica = 0 >
<cfset hayCierreConta = 0 >
<cfset hayFechaCierreConta = 0 >
<cfset hayVerClasifCC = 0 >
<cfset hayVerClasifCP = 0 >

<cfset hayNoContaCosto = 0 >

<cfset hayRepCotProveedoresLocal = 0 >
<cfset hayRepCotProveedoresImportacion = 0 >
<cfset hayRepCotProcesoLocal = 0 >
<cfset hayRepCotProcesoImportacion = 0 >

<cfset hayRolSolic = 0 >
<cfset hayRolComprador = 0 >
<cfset hayRecurrentes = 0 >

<cfset hayLeyenda = 0 >
<cfset hayLeyendaCxC = 0 >

<cfset hayVerAstDet = 0>
<cfset hayRetAuto = 0>
<cfset hayAutorizacionCustodia = 0>

<cfset hayUsuarioWS = 0>
 <!---Obtinen el Filtro de empresa, Segun si es corporativo o NO--->
 <cfquery name="rsConsultaCorp" datasource="asp">
	select *
	from CuentaEmpresarial
	where Ecorporativa is not null
	  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>
<cfif isdefined('session.Ecodigo') and isdefined('session.Ecodigocorp') and session.Ecodigo NEQ session.Ecodigocorp and rsConsultaCorp.RecordCount GT 0>
	  <cfset filtroE = " Ecodigo=#session.Ecodigo# ">
<cfelse>
	  <cfset filtroE = " Ecodigo is null ">								  
</cfif>
 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #Session.Ecodigo#  
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC --->
<cfset maskCedJ = ObtenerDato(620)>
<cfset maskCedF = ObtenerDato(630)>
<cfset NoModificar = 0 >

<cfset LvarSNCEid = ObtenerDato(695)>
<cfset LvarActEmp = ObtenerDato(1801).Pvalor>
<cfset LvarActEmpF = ObtenerDato(1803).Pvalor>
<cfset LvarConGastoI = ObtenerDato(1802).Pvalor>

<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC --->
<cfif maskCedJ.Recordcount GT 0 ><cfset hayFormatoCedulaJuridica = 1 ></cfif>
<cfif maskCedF.Recordcount GT 0 ><cfset hayFormatoCedulaFisica = 1 ></cfif>

<cfset maskFCorte = ObtenerDato(670)>
<cfset chkFCorte = ObtenerDato(700)>
<cfif maskFCorte.Recordcount GT 0 ><cfset hayFechaCierreConta = 1 ></cfif>
<cfif chkFCorte.Recordcount GT 0 ><cfset hayCierreConta = 1 ></cfif>

<cfset maskVerClasifCC = ObtenerDato(680)>
<cfif maskVerClasifCC.Recordcount GT 0 >
	<cfset hayVerClasifCC = 1 >
	<cfset ValorVerClasifCC = maskVerClasifCC.Pvalor>
<cfelse>
	<cfset ValorVerClasifCC = 0>
</cfif>

<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxP --->
<cfset maskVerClasifCP = ObtenerDato(690)>
<cfif maskVerClasifCP.Recordcount GT 0 ><cfset hayVerClasifCP = 1 ></cfif>
<cfif maskVerClasifCP.Recordcount GT 0 >
	<cfset hayVerClasifCP = 1 >
	<cfset ValorVerClasifCP = maskVerClasifCP.Pvalor>
<cfelse>
	<cfset ValorVerClasifCP = 0>
</cfif>

<!--- PARAMETRO NUEVO RELACIONADO CON LA PRESENTACION DEL ASIENTO EN FORMA DETALLADA --->
<cfset maskVerAstDet = ObtenerDato(930)>
<cfif maskVerAstDet.Recordcount GT 0 ><cfset hayVerAstDet = 1 ></cfif>
<cfif maskVerAstDet.Recordcount GT 0 >
	<cfset hayVerAstDet = 1 >
	<cfset ValorVerAstDet = maskVerAstDet.Pvalor>
<cfelse>
	<cfset ValorVerAstDet = 0>
</cfif>
<!---PARAMETRO 1600: CONSIDERAR TRASLADOS, RETIROS Y REVALUACIÓNES DEL ÚLTIMO PERIODO PARA LA REVALUACIÓN--->
<cfset ProRev = ObtenerDato(1600)>
<cfif ProRev.Recordcount GT 0><cfset ProRev =ProRev.Pvalor><cfelse><cfset ProRev =0></cfif>
<!--- PARAMETRO NUEVO RELACIONADO CON LA APLICACION DE RETIROS DE FORMA AUTOMATICA --->
<cfset maskRetAuto = ObtenerDato(960)>
<cfif maskRetAuto.Recordcount GT 0 ><cfset hayRetAuto = 1 ></cfif>
<cfif maskRetAuto.Recordcount GT 0 >
	<cfset hayRetAuto = 1 >
	<cfset ValorRetAuto = maskRetAuto.Pvalor>
<cfelse>
	<cfset ValorRetAuto = 0>
</cfif>

<!--- PARAMETRO NUEVO RELACIONADO CON LA AUTORIZACION EN AUTOGESTION POR ENCARGADO DE CENTRO DE CUSTODIA --->
<cfset maskAutorizacionCustodia = ObtenerDato(990)>
<cfif maskAutorizacionCustodia.Recordcount GT 0 ><cfset hayAutorizacionCustodia = 1 ></cfif>
<cfif maskAutorizacionCustodia.Recordcount GT 0 >
	<cfset hayAutorizacionCustodia = 1 >
	<cfset ValorAutorizacionCustodia = maskAutorizacionCustodia.Pvalor>
<cfelse>
	<cfset ValorAutorizacionCustodia = 0>
</cfif>


<cfquery name="rsExistenDatosSNCorp" datasource="#session.DSN#">
	select count(1) as cantidad
	from SNegocios
	where SNidentificacion is not null
	and Ecodigo = #session.Ecodigo#
	and SNcodigo <> 9999
</cfquery>

<cfif isdefined('rsExistenDatosSNCorp') and rsExistenDatosSNCorp.cantidad GT 0>
	<cfset NoModificar = 1 >
</cfif>


<cfset definidos = ObtenerDato(5)>
<cfset existenParametrosDefinidos = false >
<cfif definidos.RecordCount GT 0 >
	<cfif definidos.Pvalor NEQ "N" >
		<cfset existenParametrosDefinidos = true >
	</cfif>
</cfif>
<cfset vencimiento = "">

<cfquery name="rsTipoRequisicion" datasource="#Session.DSN#">
	select Ecodigo, TRcodigo, TRdescripcion, ts_rversion from TRequisicion 
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset trequisicion = "">

<cfset solicitante = "">

<cfquery name="rsTransaccionCP" datasource="#Session.DSN#">
	select CPTcodigo, CPTdescripcion 
	from CPTransacciones 
	where Ecodigo=#Session.Ecodigo# 
	  and CPTpago = 0
</cfquery>

<cfquery name="rsTransaccionCC" datasource="#Session.DSN#">
	select CCTcodigo, CCTdescripcion 
	from CCTransacciones 
	where Ecodigo=#Session.Ecodigo# 
	  and CCTpago = 0
</cfquery>

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo=#Session.Ecodigo# 
</cfquery>
<!---<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>--->
<cfset maskNoContaCosto = ObtenerDato(740)>
<cfif maskNoContaCosto.Recordcount GT 0 >
	<cfset hayNoContaCosto = 1 >
	<cfset ValorNoContaCosto = maskNoContaCosto.Pvalor>
<cfelse>
	<cfset ValorNoContaCosto = 0>
</cfif>

<!--- Parámetro Nuevo Relacionado con la Leyenda de Balance General y Estado de Resultados --->
<cfset leyenda = ObtenerDato(920)>
<cfif leyenda.Recordcount GT 0 ><cfset hayLeyenda = 1 ></cfif>

<cfset leyendaCxC = ObtenerDato(921)>
<cfif leyendaCxC.Recordcount GT 0 ><cfset hayLeyendaCxC = 1 ></cfif>

<!--- Parámetro Tipo de Transacción en Depositos de Peaje --->
<cfset ValorTipoTransPeaje = ObtenerDato(1800).Pvalor>
<cfset ValorCuentadePeaje = ObtenerDato(1804).Pvalor>

<!-----  Valores para Banco y cuentas de Peaje  ------>
<cfset Pid="">
<cfset Bid="">
<cfset BTid="">
<cfset PAdocumento="">
<cfset PAdescripcion="">
<cfset PAmonto=0.0>
<cfset PAfecha=Dateformat(now(),'dd/mm/yyyy')>
<cfset Mcodigo="">
<cfset Mnombre="">
<cfset CBid="">
<cfset CBcodigo="">
<cfset CBdescripcion="">
<cfset tipoCambio=1>

<cfif ValorCuentadePeaje neq ''> <!----Si ya existe una cuenta -------> 					

	<cfset CBid= #ValorCuentadePeaje#> 
	<cfquery name="rsCuentaBanco" datasource="#session.dsn#">
		Select cb.CBid,cb.CBcodigo,cb.CBdescripcion, b.Bid 
	   from  CuentasBancos cb 
			inner join Bancos b 
				on cb.Bid = b.Bid 
				and cb.Ecodigo = b.Ecodigo 
			inner join Monedas m 
				on m.Mcodigo = cb.Mcodigo
			  where cb.CBid = #CBid#
	</cfquery>		
		<cfif rsCuentaBanco.recordcount gt 0>		
			<cfset Bid = rsCuentaBanco.Bid>
			<cfset CBcodigo=rsCuentaBanco.CBcodigo>
			<cfset CBdescripcion=rsCuentaBanco.CBdescripcion> 
		</cfif>
</cfif>
<!----------->

   
<!---Codigo 2600 = Cuenta de ingreso por Financiamiento--->
<cfquery name="rsCFcuentaFinanciamiento" datasource="#Session.DSN#">
	select Pvalor as CFcuentac,
		   Pvalor as Cformato,
		   '' as Cdescripcion,
		   '' as Ccuenta
	from Parametros
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 2600
</cfquery>
<!---Codigo 2800 = Cuenta de Egresos por Amortización de préstamos--->
<cfquery name="rsCFcuentacAmortizacion" datasource="#Session.DSN#">
	select Pvalor as CFcuentac,
		   Pvalor as Cformato,
		   '' as Cdescripcion,
		   '' as Ccuenta
	from Parametros
	where Ecodigo = #Session.Ecodigo# 
	and Pcodigo = 2800
</cfquery>
<!---Codigo 2920: Incluir el Socio de Negocios en las Lineas de la Poliza Contable para CXC y CXP--->
<cfif ObtenerDato(2920).recordCount GT 0 and ObtenerDato(2920).Pvalor EQ 1><cfset SNPoliza =1><cfelse><cfset SNPoliza =0></cfif>

<script language="JavaScript1.2" >

	function validaCedula(){
		var dato = document.form1.NoModificar.value;

		if (dato == '1'){
			alert('La cédula no puede ser modificada, ya hay datos relacionados.');
			return false;
		}
	}

	//Valida solo X mayúsculas y -. Llamar en evento onKeyPress Ejem. onKeyPress="return acceptX(event)"
	function acceptX(evt){	
		// NOTE: Backspace = 8, Enter = 13, '0' = 48, '9' = 57	
		var key = nav4 ? evt.which : evt.keyCode;	
		return (key <= 13 || key == 88 || key == 45); 
	}	
	// valida los campos
	function valida() {
		<cfif not existenParametrosDefinidos >		
			alert('¡No están definidos los parámetros generales!');
			return false;
		</cfif>		
				
		if(document.form1.chkRCDND.checked){
			if((document.form1.RCDND.value == '') || (document.form1.RCDND.value <= 0) || (document.form1.RCDND.value > 16)){
				alert("Error,el campo 'Cantidad de Digitos en Número de Documento' es requerido y no puede ser cero ni mayor que 16 !");
				return false;				
			}
		}
		
		if(document.form1.chkAgrupacionOrdenes.checked && document.form1.selFrecAgrupOC.value == 'M')
		{
			if(document.form1.txtDiaMesAgrupOC.value == '' || document.form1.txtDiaMesAgrupOC.value <= 0 || document.form1.txtDiaMesAgrupOC.value > 31)
			{
				alert("Error, el campo 'El día' es requerido, debe ser mayor a 0 y menor a 32!");
				return false;
			}
		}
		
		return true;
	}	

	var popUpWin=0;
	 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doSolicitantes() {
		popUpWindow("ConlisSolicitantesCM.cfm?form=form1&id=CMSid&nombre=CMSnombre",250,200,650,350);
	}

	function doSupervisor() {
		popUpWindow("ConlisUsuariosFA.cfm",250,200,650,350);
	}

	function doSocioImportacion() {
		popUpWindow("ConlisSocioImportacion.cfm",250,200,650,350);
	}
	
	function cantDig(ck){
		var _divCantDig = document.getElementById("divCantDig");

		if(ck.checked)
			_divCantDig.style.display = '';
		else
			_divCantDig.style.display = 'none';
	}
	
	function reestablecerDiasSemana()
	{
		document.form1.chkAgruparD.checked = false;
		document.form1.chkAgruparL.checked = false;
		document.form1.chkAgruparK.checked = false;
		document.form1.chkAgruparM.checked = false;
		document.form1.chkAgruparJ.checked = false;
		document.form1.chkAgruparV.checked = false;
		document.form1.chkAgruparS.checked = false;
	}
	
	function cambiaAgrupacionOrdenes()
	{
		if(document.form1.chkAgrupacionOrdenes.checked)
		{
			document.getElementById("trFrecAgrupOC").style.display = '';
		}
		else
		{
			document.getElementById("trFrecAgrupOC").style.display = 'none';
			document.getElementById("trDiasSemanaAgrupOC").style.display = 'none';
			document.getElementById("trDiaMesAgrupOC").style.display = 'none';
			
			document.form1.selFrecAgrupOC.value = 'D';
			reestablecerDiasSemana();
			document.form1.txtDiaMesAgrupOC.value = '1';
		}
	}
	
	function cambiaFrecAgrupOC(frecuencia)
	{
		if(frecuencia == 'D')
		{
			document.getElementById("trDiasSemanaAgrupOC").style.display = 'none';
			document.getElementById("trDiaMesAgrupOC").style.display = 'none';
			reestablecerDiasSemana();
			document.form1.txtDiaMesAgrupOC.value = '1';
		}
		else if(frecuencia == 'S')
		{
			document.getElementById("trDiasSemanaAgrupOC").style.display = '';
			document.getElementById("trDiaMesAgrupOC").style.display = 'none';
			document.form1.txtDiaMesAgrupOC.value = '1';
		}
		else if(frecuencia == 'M')
		{
			document.getElementById("trDiasSemanaAgrupOC").style.display = 'none';
			document.getElementById("trDiaMesAgrupOC").style.display = '';
			reestablecerDiasSemana();
		}
	}
	
</script>

<form action="SQLParametrosAuxiliaresAD.cfm" method="post" name="form1" onsubmit=" return FrameFunction();">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
				<table width="85%" border="0" cellpadding="2" cellspacing="2">
					<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Contabilidad General</font></b></td></tr>
					<tr>
					  <td colspan="2" nowrap align="center">
					    <table border="0">
								<tr> 
									<td colspan="3">Cuenta Financiera de Balance para ajustar diferencias de Tipos de Cambio en Asientos:</td>
								</tr>							
								<tr> 
									<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>
									<cfset rsCuentaBalAs = ObtenerDato(25)>
									<cfif rsCuentaBalAs.RecordCount GT 0 >
										<cfset hayCuentaBalAsi = 1 >
									</cfif>
									
									
									<cfquery datasource="#session.dsn#" name="param25">
										select Pvalor
										from Parametros
										where Ecodigo = #Session.Ecodigo#  
										and Pcodigo = 25
									</cfquery>
									
									<cfquery name="rsCuentaBalAs" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										from CFinanciera
										where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#param25.Pvalor#" null="#Len(Trim(param25.Pvalor)) EQ 0#" >
									</cfquery>
									
									<cfif isdefined('rsCuentaBalAs') and rsCuentaBalAs.RecordCount GT 0 and rsCuentaBalAs.CFcuenta NEQ ''>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										query="#rsCuentaBalAs#" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaBalanceAsi"
										Cformato="FCBalanceAsi" 
										Cmayor="MCBalanceAsi" 												
										>
										<cfelse>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaBalanceAsi"
										Cformato="FCBalanceAsi" 
										Cmayor="MCBalanceAsi" 												
										>							
									</cfif> 
								</td>								
							</tr>
							
							
							<!--- *************************************************** --->
							 <tr> 
								
								<td colspan="2" align="right" nowrap="nowrap">Cuenta de diferencial cambiario para conversión de estados:&nbsp;</td>
								<td>
									<cfset rsCuentaDifCambAs = ObtenerDato(810)>
									<cfif rsCuentaDifCambAs.RecordCount GT 0 >
										<cfset hayCuentaDifCambAsi = 1 >
									</cfif>
									
									<cfquery datasource="#session.dsn#" name="param810">
										select Pvalor
										from Parametros
										where Ecodigo = #Session.Ecodigo#  
										and Pcodigo = 810
									</cfquery>
									<cfquery name="rsCuentaDifCambAs" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										from CFinanciera
										where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#param810.Pvalor#" null="#Len(Trim(param810.Pvalor)) EQ 0#" >
									</cfquery>
									
									<cfif isdefined('rsCuentaDifCambAs') and rsCuentaDifCambAs.RecordCount GT 0 and rsCuentaDifCambAs.CFcuenta NEQ ''>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										query="#rsCuentaDifCambAs#" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaDifCambAsi"
										Cformato="FCDifCambAsi" 
										Cmayor="MCDifCambAsi">
									<cfelse>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="CCuentaDifCambAsi"
										Cformato="FCDifCambAsi" 
										Cmayor="MCDifCambAsi" 												
										>							
									</cfif> 
								</td>								
							</tr>
                            <!---►►►Parametros 3600: Cuenta de Diferencial Cambiario Primera conversión de estados B15◄◄◄--->
                             <tr> 
								<td colspan="2" align="right" nowrap="nowrap">Cuenta de diferencial cambiario primera conversión de estados B15:&nbsp;</td>
								<td>
									<cfset rsCFcuentaB15_P = ObtenerDato(3600)>
								
									<cfquery name="rsCtaB15_P" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										from CFinanciera
                                        <cfif rsCFcuentaB15_P.Recordcount and LEN(TRIM(rsCFcuentaB15_P.Pvalor))>
											where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuentaB15_P.Pvalor#">
                                        <cfelse>
                                         	where 1=2
                                        </cfif>
									</cfquery>
									
									<cfif rsCtaB15_P.RecordCount>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										query="#rsCtaB15_P#" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="B15PCcuenta"
										Cformato="B15PCformato" 
										Cmayor="B15PCmayor">
									<cfelse>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="B15PCcuenta"
										Cformato="B15PCformato" 
										Cmayor="B15PCmayor">												
									</cfif> 
								</td>								
							</tr>
                            <!---►►►Parametros 3700: Cuenta de Diferencial Cambiario Segunda conversión de estados B15◄◄◄--->
                             <tr> 
								<td colspan="2" align="right" nowrap="nowrap">Cuenta de diferencial cambiario segunda conversión de estados B15:&nbsp;</td>
								<td>
									<cfset rsCFcuentaB15_S = ObtenerDato(3700)>
								
									<cfquery name="rsCtaB15_S" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										from CFinanciera
                                        <cfif rsCFcuentaB15_S.Recordcount and LEN(TRIM(rsCFcuentaB15_S.Pvalor))>
											where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFcuentaB15_S.Pvalor#">
                                        <cfelse>
                                         	where 1=2
                                        </cfif>
									</cfquery>
									
									<cfif rsCtaB15_S.RecordCount>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										query="#rsCtaB15_S#" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="B15SCcuenta"
										Cformato="B15SCformato" 
										Cmayor="B15SCmayor">
									<cfelse>
										<cf_cuentas 
										conexion="#Session.DSN#" 
										conlis="S" 
										auxiliares="N" 
										movimiento="S" 
										form="form1"
										frame="frame1"
										descwidth="50"
										Ccuenta="B15SCcuenta"
										Cformato="B15SCformato" 
										Cmayor="B15SCmayor">												
									</cfif> 
								</td>								
							</tr>
							
							<!--- *************************************************** --->
							<tr>
							  <td>&nbsp;</td>
							  <td align="right" nowrap>Validar Fecha de Asientos contra Periodo y Mes antes de Generar o Aplicar:&nbsp;</td>
							  <td>
							  	<input type="checkbox" name="chkCierreConta" value="S" <cfif chkFCorte.Pvalor EQ 'S'> checked</cfif>>
							  </td>
							</tr>
							<tr>
							  <td>&nbsp;</td>
							  <td align="right" nowrap>Fecha de Cierre de Contabilidad:&nbsp;</td>
							  <td><cf_sifcalendario form="form1" value="#LSDateFormat(maskFCorte.Pvalor,'dd/mm/yyyy')#" name="fechacierreConta"></td>
							</tr>
							<tr>
							  <td>&nbsp;</td>
							  <td align="right" nowrap>Leyenda para Balance General y Estado de Resultados:&nbsp;</td>
							  <td><input name="verLeyenda" type="text" size="50" maxlength="100" value="<cfoutput>#HTMLEditFormat(leyenda.Pvalor)#</cfoutput>"></td>
							</tr>
							 <tr> 
								
								<td colspan="2" align="right" nowrap="nowrap">Cuenta contable de balance para reversi&oacute;n de estimaci&oacute;n:&nbsp;</td>
								<td>
									<cfset param980 = ObtenerDato(980)>
									<cfif param980.RecordCount GT 0 >
										<cfset hayCuentaEstimacion = 1 >
									</cfif>

									<cfquery name="rsCuentaEstimacion" datasource="#Session.DSN#">
										select CFdescripcion, CFcuenta, CFformato, Ccuenta
										from CFinanciera
										where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#param980.Pvalor#" null="#Len(Trim(param980.Pvalor)) EQ 0#" >
									</cfquery>

									<cfif isdefined('rsCuentaEstimacion') and rsCuentaEstimacion.RecordCount GT 0 and rsCuentaEstimacion.CFcuenta NEQ ''>
										<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CCuentaEstimacion" Cformato="FCEstimacion" Cmayor="MCEstimacion" query="#rsCuentaEstimacion#">
									<cfelse>
										<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" Ccuenta="CCuentaEstimacion" Cformato="FCEstimacion" Cmayor="MCEstimacion">
									</cfif> 
								</td>								
							</tr>
							<!--- Agregar descripción de cuenta en consulta Pólizas Contables --->
							<cfset rsAgregarDesc = ObtenerDato(981)>
							<cfset hayAgregarDesc = 0 >
							<cfif rsAgregarDesc.RecordCount GT 0 >
								<cfset hayAgregarDesc = 1 >
								<cfset AgregarDesc = rsAgregarDesc.Pvalor>
							<cfelse>
								<cfset AgregarDesc = '0' >
							</cfif>	
							<tr>
								<td>&nbsp;</td>
								<td align="right" nowrap>Agregar descripci&oacute;n de cuenta en consulta P&oacute;lizas Contables:&nbsp;</td>		
								<td><input type="checkbox" name="chkAgregarDesc" <cfif AgregarDesc eq '1'>checked</cfif> ></td>
							</tr>
							
                            <!--- Importar Asientos Contables con Centro Funcional --->
							<cfset rsImportaConCF = ObtenerDato(982)>
							<cfset hayImportaConCF = 0 >
							<cfif rsImportaConCF.RecordCount GT 0>
								<cfset hayImportaConCF = 1 >
								<cfset LvarImportaConCF = rsImportaConCF.Pvalor>
							<cfelse>
								<cfset LvarImportaConCF = '0' >
							</cfif>	
							<tr>
								<td>&nbsp;</td>
								<td align="right" nowrap>Importar Asientos Contables con Centro Funcional:&nbsp;</td>		
								<td><input type="checkbox" name="chkImportaConCF" <cfif LvarImportaConCF eq '1'>checked</cfif> ></td>
							</tr>
                            
                            <!--- En el cierre de auxiliares no generar en bancos asientos de diferencial cambiario --->
							<cfset rsParam = ObtenerDato(2210)>
                            <cfset hayMBAsientoDifCam = 0 >
							<cfif rsParam.RecordCount GT 0>
								<cfset hayMBAsientoDifCam = 1 >
								<cfset LvarMBAsientoDifCam = rsParam.Pvalor>
							<cfelse>
								<cfset LvarMBAsientoDifCam = '0' >
							</cfif>	
							<tr>
								<td>&nbsp;</td>
								<td align="right" nowrap>Cierre de auxiliares no genera en Bancos asientos de diferencial cambiario:&nbsp;</td>		
								<td><input type="checkbox" name="chkMBAsientoDifCam" <cfif LvarMBAsientoDifCam eq '1'>checked</cfif> ></td>
							</tr>

                            <!--- Descripcion Alterna de Valores de Catálogos --->
							<cfset rsParam = ObtenerDato(99)>
                            <cfset hayPlanCtasDescAlterna = 0 >
							<cfif rsParam.RecordCount GT 0>
								<cfset hayPlanCtasDescAlterna = 1 >
								<cfset LvarPlanCtasDescAlterna = rsParam.Pvalor>
							<cfelse>
								<cfset LvarPlanCtasDescAlterna = '0' >
							</cfif>	
							<tr>
								<td>&nbsp;</td>
								<td align="right" nowrap>Utilizar Descripción Alterna de Valores de Catálogos Corporativos al Generar Cuentas Financieras:&nbsp;</td>		
								<td>
									<input type="checkbox" 	name="chkPlanCtasDescAlterna" value="1" <cfif LvarPlanCtasDescAlterna eq '1'>checked</cfif>>
							        <input type="hidden" 	name="hayPlanCtasDescAlterna" value="#hayPlanCtasDescAlterna#">
								</td>
							</tr>
						  </table>	
						</td>
						<td width="20%" valign="middle">
						<!---
						<table width="100%" class="ayuda">
						<tr><td>Poner Ayuda</td></tr>
						</table>
						--->
						</td>
					</tr>				
				<!--- TRAMITES --->
				<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Trámites</font></b></td></tr>
				<cfset rsWS_CFusuario = ObtenerDato(3500)>
				<cfif rsWS_CFusuario.RecordCount GT 0 >
					<cfset hayWS_CFusuario = 1 >
					<cfset WS_CFusuario = rsWS_CFusuario.Pvalor>
				<cfelse>
					<cfset hayWS_CFusuario = 0 >
					<cfset WS_CFusuario = '' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Determinacion de Centro Funcional por Usuario:&nbsp;</td>		
					<td>
						<input type="hidden" name="hayWS_CFusuario" value="<cfoutput>#hayWS_CFusuario#</cfoutput>">
						
						<select name="WS_CFusuario">
							<option value="">Nombramientos de Recursos Humanos</option>
							<option value="USU" <cfif WS_CFusuario EQ "USU">selected</cfif>>Usuarios por Centro Funcional</option>
							<option value="EMP" <cfif WS_CFusuario EQ "EMP">selected</cfif>>Importacion de Empleados por Centro Funcional</option>
						</select>
					</td>
				</tr>
				<!--- PRESUPUESTO --->
				<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Control de Presupuesto</font></b></td></tr>
				<cfset rsTrasladosAbierto = ObtenerDato(549)>
				<cfif rsTrasladosAbierto.RecordCount GT 0 >
					<cfset hayTrasladosAbierto = 1 >
					<cfset TrasladosAbierto = rsTrasladosAbierto.Pvalor>
				<cfelse>
					<cfset hayTrasladosAbierto = 0 >
					<cfset TrasladosAbierto = 'N' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Permitir Cuentas con Control Abierto en Traslados de Presupuesto:&nbsp;</td>		
					<td>
						<input type="hidden" name="hayTrasladosAbierto" value="<cfoutput>#hayTrasladosAbierto#</cfoutput>">
						<input type="checkbox" value="S" name="chkTrasladosAbierto" <cfif TrasladosAbierto eq 'S'>checked</cfif> >
					</td>
				</tr>

				<cfset rsCPresupuestoDeVersion = ObtenerDato(541)>
				<cfif rsCPresupuestoDeVersion.RecordCount GT 0 >
					<cfset hayCPresupuestoDeVersion = 1 >
					<cfset CPresupuestoDeVersion = rsCPresupuestoDeVersion.Pvalor>
				<cfelse>
					<cfset hayCPresupuestoDeVersion = 0 >
					<cfset CPresupuestoDeVersion = 'N' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Crear Cuentas de Presupuesto en la Versión de Formulación:&nbsp;</td>		
					<td>
						<input type="hidden" name="hayCPresupuestoDeVersion" value="<cfoutput>#hayCPresupuestoDeVersion#</cfoutput>">
						<input type="checkbox" value="S" name="chkCPresupuestoDeVersion" <cfif CPresupuestoDeVersion eq 'S'>checked</cfif> >
					</td>
				</tr>
				<!--- VENCIMIENTOS --->
				<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Vencimientos</font></b></td></tr>
					<tr>
						<td colspan="2" nowrap align="center">
							<table border="0" width="1%">
								<tr> 
									<cfset venc = ObtenerDato(310)>
									<cfif venc.RecordCount GT 0 >
										<cfset hayVencimiento1 = 1 >
										<cfset vencimiento = venc.Pvalor>
									</cfif>
									<td width="1%" align="right" nowrap >1&ordm; Vencimiento:&nbsp;</td>
									<td width="1%" >
										<input name="vencimiento1" alt="1º vencimiento" style="text-align:right" 
											onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" 
											value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
									</td>
									
									<cfset venc = ObtenerDato(320)>
									<cfif venc.RecordCount GT 0 >
										<cfset hayVencimiento2 = 1 >
										<cfset vencimiento = venc.Pvalor>
									</cfif>
									<td width="1%" align="right" nowrap >&nbsp;2&ordm; Vencimiento:&nbsp;</td>
									<td>
										<input name="vencimiento2" alt="2º vencimiento" style="text-align:right" 
											onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
											onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" 
											value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
									</td>
								</tr>
								<tr> 
									<cfset venc = ObtenerDato(330)>
									<cfif venc.RecordCount GT 0 >
									<cfset hayVencimiento3 = 1 >
									<cfset vencimiento = venc.Pvalor>
								</cfif>
								<td width="1%" align="right" nowrap >3&ordm; Vencimiento:&nbsp;</td>
								<td>
									<input name="vencimiento3" alt="3º vencimiento" style="text-align:right" 
										onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
										onFocus="javascript:this.select();" onChange="javascript:fm(this,0);"  type="text" 
										value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
								</td>
								
								<cfset venc = ObtenerDato(340)>
								<cfif venc.RecordCount GT 0 >
									<cfset hayVencimiento4 = 1 >
									<cfset vencimiento = venc.Pvalor>
								</cfif>
								<td width="1%" align="right" nowrap >&nbsp;4&ordm; Vencimiento:&nbsp;</td>
								<td>
									<input name="vencimiento4" alt="4º vencimiento" style="text-align:right" 
										onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
										onFocus="javascript:this.select();" onChange="javascript:fm(this,0);"  type="text" 
										value="<cfoutput>#vencimiento#</cfoutput>" size="4" maxlength="4">
								</td>
							</tr>
						</table>
					</td>
					<td valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Poner Ayuda</td></tr>
					</table>
					--->
					</td>
				
				</tr>
				
				<!--- COMPRAS --->
				<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Compras</font></b></td></tr>
				
				<cfset rsNomina = ObtenerDato(520)>
				<cfif rsNomina.RecordCount GT 0 >
					<cfset hayNomina = 1 >
					<cfset interfazNomina = rsNomina.Pvalor>
				<cfelse>
					<cfset interfazNomina = 'N' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Integraci&oacute;n con Recursos Humanos:&nbsp;</td>		
					<td><input type="checkbox" name="chkNomina" <cfif interfazNomina eq 'S'>checked</cfif> ></td>
				</tr>
				
				<cfset aprobar = ObtenerDato(410)>
				<cfif aprobar.RecordCount GT 0 >
					<cfset hayAutorizacion = 1 >
					<cfset aprobacion = aprobar.Pvalor>
				<cfelse>
					<cfset aprobacion = '1' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Aprobar Solicitudes de Compra:&nbsp;</td>		
					<td><input type="checkbox" name="chkAutorizar" <cfif aprobacion eq '1'>checked</cfif> ></td>
				</tr>
				
				<cfset publicar = ObtenerDato(570)>
				<cfset hayPublicacion = 0 >
				<cfif publicar.RecordCount GT 0 >
					<cfset hayPublicacion = 1 >
					<cfset publicacion = publicar.Pvalor>
				<cfelse>
					<cfset publicacion = '1' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Publicar Procesos de Compra:&nbsp;</td>		
					<td><input type="checkbox" name="chkPublicar" <cfif publicacion eq '1'>checked</cfif> ></td>
				</tr>
				
				<cfset rsJerarquia = ObtenerDato(580)>
				<cfset hayJerarquia = 0 >
				<cfif rsJerarquia.RecordCount GT 0 >
					<cfset hayJerarquia = 1 >
					<cfset jerarquia = rsJerarquia.Pvalor>
				<cfelse>
					<cfset jerarquia = '0' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Utiliza jerarqu&iacute;a para aprobar:&nbsp;</td>		
					<td><input type="checkbox" name="chkJerarquia" <cfif jerarquia eq '1'>checked</cfif> ></td>
				</tr>

				<!--- Parametro para validar para compras directas bienes en contratos --->
				<cfset rsValidarCDC = ObtenerDato(710)>
				<cfset hayValidarCDC = 0 >
				<cfif rsValidarCDC.RecordCount GT 0 >
					<cfset hayValidarCDC = 1 >
					<cfset validarCDC = rsValidarCDC.Pvalor>
				<cfelse>
					<cfset validarCDC = '0' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Validar para compras directas bienes en contratos:&nbsp;</td>		
					<td><input type="checkbox" name="chkValidarCDC" <cfif validarCDC eq '1'>checked</cfif> ></td>
				</tr>
				
				<cfset nivelA = ObtenerDato(530)>
				<input type="hidden" name="hayNivelA" value="<cfif nivelA.RecordCount gt 0 and len(trim(nivelA.Pvalor))>1<cfelse>0</cfif>">
				<tr>
					<td nowrap align="right">Nivel m&aacute;ximo de Clasificaciones de Art&iacute;culos:&nbsp;</td>
					<td><input name="MaxNivelA" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" value="<cfif nivelA.RecordCount gt 0 and len(trim(nivelA.Pvalor))><cfoutput>#nivelA.Pvalor#</cfoutput><cfelse>1</cfif>" size="4" maxlength="4"></td>
				</tr>
				
				<cfset nivelS = ObtenerDato(540)>
				<input type="hidden" name="hayNivelS" value="<cfif nivelS.RecordCount gt 0 and len(trim(nivelS.Pvalor))>1<cfelse>0</cfif>">
				<tr>
					<td nowrap align="right">Nivel m&aacute;ximo de Clasificaciones de Conceptos:&nbsp;</td>
					<td><input name="MaxNivelS" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" value="<cfif nivelS.RecordCount gt 0 and len(trim(nivelS.Pvalor))><cfoutput>#nivelS.Pvalor#</cfoutput><cfelse>1</cfif>" size="4" maxlength="4"></td>
				</tr>
				
				<!--- --->
				<cfset CantPPC = ObtenerDato(535)>
				<input type="hidden" name="hayCantPPC" value="<cfif CantPPC.RecordCount gt 0 and len(trim(CantPPC.Pvalor))>1<cfelse>0</cfif>">
				<tr>
					<td nowrap align="right">Cantidad de Proveedores a Invitar en el Proceso de Compra:&nbsp;</td>
					<td><input name="MaxCantPPC" style="text-align:right" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" type="text" value="<cfif CantPPC.RecordCount gt 0 and len(trim(CantPPC.Pvalor))><cfoutput>#CantPPC.Pvalor#</cfoutput><cfelse>1</cfif>" size="4" maxlength="4"></td>
				</tr>
				<!--- --->
				
				
				<cfset ConsReq = ObtenerDato(361)>
				<cfif ConsReq.RecordCount GT 0 >
					<cfset hayConsReq = 1 >
					<cfset valorConsReq = ConsReq.Pvalor>
				<cfelse>
					<cfset valorConsReq = '0' >
				</cfif>	
				<tr>
					<td align="right" nowrap>Consecutivos separados para las requisiciones :&nbsp;</td>		
					<td><input type="checkbox" name="chkConsReq" <cfif valorConsReq eq '1'>checked</cfif> ></td>
				</tr>
				
				<tr> 
					<cfset req = ObtenerDato(360)>
					<cfif req.RecordCount GT 0 >
						<cfset hayTipoRequisicion = 1 >
						<cfset trequisicion = req.Pvalor>
					</cfif>
					<td width="39%" align="right" nowrap>Requisici&oacute;n Default:&nbsp;</td>
					
					<td width="35%">
						<select name="TipoRequisicion">	  
							<cfif rsTipoRequisicion.RecordCount EQ 0>
							<option value="-1"></option>
							</cfif>
							<cfoutput query="rsTipoRequisicion">
							<option value="#rsTipoRequisicion.TRcodigo#" <cfif trim(rsTipoRequisicion.TRcodigo) eq trim(trequisicion)> selected </cfif> >#rsTipoRequisicion.TRdescripcion#</option>
							</cfoutput>
						</select>
					</td>
					<td rowspan="4" valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Poner Ayuda</td></tr>
					</table>
					--->							
					</td>
				</tr>
				
				<tr>
					<cfset solic = ObtenerDato(370)>
					<cfif solic.RecordCount GT 0 >
						<cfset haySolicitante = 1 >
						<cfset solicitante = solic.Pvalor>
						<cfif Len(Trim(solicitante)) GT 0>
							<cfquery name="rsSolicitante" datasource="#Session.DSN#">
								select CMSnombre from CMSolicitantes 
								where Ecodigo = #Session.Ecodigo#
								and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#solicitante#">
							</cfquery>
						</cfif>
					</cfif>
					<td align="right" nowrap>Solicitante Default:&nbsp;</td>
					<td nowrap> 
						<input name="CMSnombre" type="text" value="<cfif Len(Trim(solicitante)) GT 0><cfoutput>#rsSolicitante.CMSnombre#</cfoutput></cfif>" id="CMSnombre" size="40" maxlength="80" readonly tabindex="-1">
						<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Solicitantes" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doSolicitantes();"></a> 
						<input name="CMSid" type="hidden" id="CMSid" value="<cfoutput>#solicitante#</cfoutput>">
					</td>
				</tr>
				
				<cfset cantDig = ''>
				<cfset cantDig = ObtenerDato(720)>
				<cfif cantDig.RecordCount GT 0 >
					<cfset cantDig = cantDig.Pvalor>
				<cfelse>	
					<cfset cantDig = '' >
				</cfif>				

				<tr nowrap>
					<td align="right" nowrap>Cantidad de d&iacute;gitos en n&uacute;mero de Documentos de Recepci&oacute;n:&nbsp;</td>
					<td>
						<table width="100%"  border="0">
						  <tr>
							<td width="8%">
								<input type="checkbox" <cfif isdefined('cantDig') and cantDig NEQ ''> checked</cfif> name="chkRCDND" onClick="javascript: cantDig(this);">
							</td>
							<td width="92%">
								<div id="divCantDig" style="display:none">
									Cantidad de D&iacute;gitos: &nbsp;&nbsp;
									
									<input name="RCDND" style="text-align:right" 
										onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" 
										onFocus="javascript:this.select();" onChange="javascript:fm(this,0);" 
										type="text" value="<cfoutput>#cantDig#</cfoutput>" 
										size="4" maxlength="4">
								</div>
							</td>
						  </tr>
						</table>
					</td>
				</tr>
				
				<cfset MultCont = ''>
				<cfset MultCont = ObtenerDato(730)>
				<cfif MultCont.RecordCount GT 0 >
					<cfset MultCont = MultCont.Pvalor>
				<cfelse>
					<cfset MultCont = '' >
				</cfif>
				<tr nowrap>
					<td align="right" nowrap>M&uacute;tiples contratos simult&aacute;neamente para art&iacute;culos o servicios</td>
					<td>
						<table width="100%"  border="0">
						  <tr>
							<td width="8%">
								<input value="1" type="checkbox" <cfif isdefined('MultCont') and MultCont NEQ ''> checked</cfif> name="chkmultiples">
							</td>
						 </tr>
						</table>
					</td>
				</tr>
				
				<!--- Parámetro que habilita la Aprobación de Excesos de Tolerancia para Documentos de Recepción --->
				<cfset rsAprobarTolerancia = ObtenerDato(760)>
				<cfset hayAprobarTolerancia = 0>
				<cfif rsAprobarTolerancia.RecordCount GT 0>
					<cfset hayAprobarTolerancia = 1>
					<cfset aprobarTolerancia = rsAprobarTolerancia.Pvalor>
				<cfelse>
					<cfset aprobarTolerancia = '0'>
				</cfif>
				<tr>
					<td align="right" nowrap>Aprobación de Excesos de Tolerancia para Documentos de Recepción:&nbsp;</td>
					<td><input type="checkbox" name="chkAprobarTolerancia" <cfif aprobarTolerancia eq '1'>checked</cfif>></td>
				</tr>
				
				<!--- Parámetro que habilita la Funcionalidad de Agrupación de Ordenes de Compra --->
				<cfset rsAgrupacionOrdenes = ObtenerDato(770)>
				<cfset hayAgrupacionOrdenes = 0>
				<cfif rsAgrupacionOrdenes.RecordCount GT 0>
					<cfset hayAgrupacionOrdenes = 1>
					<cfset AgrupacionOrdenes = rsAgrupacionOrdenes.Pvalor>
				<cfelse>
					<cfset AgrupacionOrdenes = '0'>
				</cfif>
				<tr>
					<td align="right" nowrap>Habilitar Funcionalidad de Agrupación de Ordenes de Compra:&nbsp;</td>
					<td><input type="checkbox" name="chkAgrupacionOrdenes" onClick="javascript: cambiaAgrupacionOrdenes();" <cfif AgrupacionOrdenes eq '1'>checked</cfif>></td>
				</tr>
				
				<!--- Parámetros de Frecuencia de Ejecución del Proceso de Agrupación de Ordenes de Compra --->
				
				<!--- Parámetro principal de frecuencia de ejecución del proceso
					  de agrupación (diariamente, semanalmente, mensualmente) --->
				<cfset rsFrecAgrupOC = ObtenerDato(780)>
				<cfset hayFrecAgrupOC = 0>
				<cfif rsFrecAgrupOC.RecordCount GT 0>
					<cfset hayFrecAgrupOC = 1>
					<cfset FrecAgrupOC = rsFrecAgrupOC.Pvalor>
				<cfelse>
					<cfset FrecAgrupOC = 'D'>
				</cfif>
				
				<tr id="trFrecAgrupOC" style="display:<cfif AgrupacionOrdenes eq '0'>none</cfif>">
					<td align="right" nowrap>Ejecutar Proceso de Agrupación:&nbsp;</td>
					<td>
						<select name="selFrecAgrupOC" onChange="javascript: cambiaFrecAgrupOC(this.value);">
							<option value="D" <cfif FrecAgrupOC eq 'D'>selected</cfif>>Diariamente</option>
							<option value="S" <cfif FrecAgrupOC eq 'S'>selected</cfif>>Semanalmente</option>
							<option value="M" <cfif FrecAgrupOC eq 'M'>selected</cfif>>Mensualmente</option>
						</select>
					</td>
				</tr>
				
				<!--- Parámetro de días de la semana que se va a realizar el proceso de agrupación
					  (usado cuando el parámetro de frecuencia sea semanalmente) --->
				<cfset rsDiasSemanaAgrupOC = ObtenerDato(790)>
				<cfset hayDiasSemanaAgrupOC = 0>
				<cfif rsDiasSemanaAgrupOC.RecordCount GT 0>
					<cfset hayDiasSemanaAgrupOC = 1>
					<cfset DiasSemanaAgrupOC = rsDiasSemanaAgrupOC.Pvalor>
				<cfelse>
					<cfset DiasSemanaAgrupOC = '0000000'>
				</cfif>

				<tr id="trDiasSemanaAgrupOC" style="display:<cfif AgrupacionOrdenes eq '0' or FrecAgrupOC neq 'S'>none</cfif>">
					<td align="right" nowrap>Los días:&nbsp;</td>
					<td>
						<table>
							<tr>
								<td>Domingo</td>
								<td><input type="checkbox" name="chkAgruparD" <cfif Mid(DiasSemanaAgrupOC, 1, 1) eq '1'>checked</cfif>></td>
								<td>Lunes</td>
								<td><input type="checkbox" name="chkAgruparL" <cfif Mid(DiasSemanaAgrupOC, 2, 1) eq '1'>checked</cfif>></td>
								<td>Martes</td>
								<td><input type="checkbox" name="chkAgruparK" <cfif Mid(DiasSemanaAgrupOC, 3, 1) eq '1'>checked</cfif>></td>
								<td>Miércoles</td>
								<td><input type="checkbox" name="chkAgruparM" <cfif Mid(DiasSemanaAgrupOC, 4, 1) eq '1'>checked</cfif>></td>
							</tr>
							<tr>
								<td>Jueves</td>
								<td><input type="checkbox" name="chkAgruparJ" <cfif Mid(DiasSemanaAgrupOC, 5, 1) eq '1'>checked</cfif>></td>
								<td>Viernes</td>
								<td><input type="checkbox" name="chkAgruparV" <cfif Mid(DiasSemanaAgrupOC, 6, 1) eq '1'>checked</cfif>></td>
								<td>Sábado</td>
								<td><input type="checkbox" name="chkAgruparS" <cfif Mid(DiasSemanaAgrupOC, 7, 1) eq '1'>checked</cfif>></td>
								<td colspan="2">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				
				<!--- Parámetro de día del mes que se va a realizar el proceso de agrupación 
					  (usado cuando el parámetro de frecuencia sea mensualmente) --->
				<cfset rsDiaMesAgrupOC = ObtenerDato(800)>
				<cfset hayDiaMesAgrupOC = 0>
				<cfif rsDiaMesAgrupOC.RecordCount GT 0>
					<cfset hayDiaMesAgrupOC = 1>
					<cfset DiaMesAgrupOC = rsDiaMesAgrupOC.Pvalor>
				<cfelse>
					<cfset DiaMesAgrupOC = '1'>
				</cfif>
				
				<tr id="trDiaMesAgrupOC" style="display:<cfif AgrupacionOrdenes eq '0' or FrecAgrupOC neq 'M'>none</cfif>">
					<td align="right" nowrap>El día:&nbsp;</td>
					<td>
						<cf_monto decimales="0" size="2" name="txtDiaMesAgrupOC" form="form1" value="#DiaMesAgrupOC#">
					</td>
				</tr>
				

				<cfquery name="rsCot" datasource="#session.DSN#">
					select FMT01COD, FMT01DES
					from FMT001
					where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
					and FMT01TIP = 15	<!--- Tipo de reportes de Cotizacion de Compras --->
				</cfquery>


				<cfset repcot = ObtenerDato(820)>
				<cfif repcot.RecordCount GT 0 >
					<cfset hayRepCotProveedoresLocal = 1 >
				</cfif>
				<tr>
					<td align="right">Formato Cotizaci&oacute;n de Proveedores Local</td>
					<td>
						<select name="repCotTipo1">
							<option value="" >-seleccionar-</option>
							<cfoutput query="rsCot">
								<option value="#rsCot.FMT01COD#" <cfif trim(repcot.Pvalor) eq trim(rsCot.FMT01COD) >selected</cfif> >#rsCot.FMT01DES#</option>
							</cfoutput>
						</select>
					</td>
				</tr>

				<cfset repcot = ObtenerDato(830)>
				<cfif repcot.RecordCount GT 0 >
					<cfset hayRepCotProveedoresImportacion = 1 >
				</cfif>
				<tr>
					<td align="right">Formato Cotizaci&oacute;n de Proveedores Importaci&oacute;n</td>
					<td>
						<select name="repCotTipo2">
							<option value="" >-seleccionar-</option>
							<cfoutput query="rsCot">
								<option value="#rsCot.FMT01COD#" <cfif trim(repcot.Pvalor) eq trim(rsCot.FMT01COD) >selected</cfif> >#rsCot.FMT01DES#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				
				<cfset repcot = ObtenerDato(840)>
				<cfif repcot.RecordCount GT 0 >
					<cfset hayRepCotProcesoLocal = 1 >
				</cfif>
				<tr>
					<td align="right">Formato Cotizaci&oacute;n de Proceso Local</td>
					<td>
						<select name="repCotTipo3">
							<option value="" >-seleccionar-</option>
							<cfoutput query="rsCot">
								<option value="#rsCot.FMT01COD#" <cfif trim(repcot.Pvalor) eq trim(rsCot.FMT01COD) >selected</cfif> >#rsCot.FMT01DES#</option>
							</cfoutput>
						</select>
					</td>
				</tr>

				<cfset repcot = ObtenerDato(850)>
				<cfif repcot.RecordCount GT 0 >
					<cfset hayRepCotProcesoImportacion = 1 >
				</cfif>
				<tr>
					<td align="right">Formato Cotizaci&oacute;n de Proceso Importaci&oacute;n</td>
					<td>
						<select name="repCotTipo4">
							<option value="" >-seleccionar-</option>
							<cfoutput query="rsCot">
								<option value="#rsCot.FMT01COD#" <cfif trim(repcot.Pvalor) eq trim(rsCot.FMT01COD) >selected</cfif> >#rsCot.FMT01DES#</option>
							</cfoutput>
						</select>
					</td>
				</tr>
				
				<cfset rolsolic = ObtenerDato(860)>
				<cfif rolsolic.RecordCount GT 0 >
					<cfset hayRolSolic = 1 >
				</cfif>
				<cfquery name="roles" datasource="asp" >
					select SRcodigo, SRdescripcion
					from SRoles
					where SScodigo='SIF'
					and SRcodigo in ( 	select distinct SRcodigo
									from SProcesosRol
									where SScodigo='SIF'
									and SMcodigo='CM'  )
					order by SRdescripcion
				</cfquery>
				<tr>
					<td align="right">Rol default para Solicitantes</td>
					<td>
						<select name="rolsolic">
							<option value="" >-seleccionar-</option>
							<cfoutput query="roles">
								<option value="#roles.SRcodigo#" <cfif trim(rolsolic.Pvalor) eq trim(roles.SRcodigo) >selected</cfif> >#roles.SRdescripcion#</option>
							</cfoutput>
						</select>
					</td>
				</tr>

				<cfset rolcomprador = ObtenerDato(870)>
				<cfif rolcomprador.RecordCount GT 0 >
					<cfset hayRolComprador = 1 >
				</cfif>
				<tr>
					<td align="right">Rol default para Compradores</td>
					<td>
						<select name="rolcomprador">
							<option value="" >-seleccionar-</option>
							<cfoutput query="roles">
								<option value="#roles.SRcodigo#" <cfif trim(rolcomprador.Pvalor) eq trim(roles.SRcodigo) >selected</cfif> >#roles.SRdescripcion#</option>
							</cfoutput>
						</select>
					</td>
				</tr>

				<cfset LvarCorreoAprobador = ObtenerDato(735)>
				<tr>
					<td align="right">Envio de correo al aprobador (traslado de Presupuesto):&nbsp;</td>
					<td>
						<input name="chkCorreoAprobador" type="checkbox" value="1" <cfif isdefined("LvarCorreoAprobador") and LvarCorreoAprobador.Pvalor eq 1>checked="checked"</cfif>>
					</td>
				</tr>

				<tr> 
					<cfset req = ObtenerDato(545)>
					<cfif req.RecordCount GT 0 >
						<cfset hayPrecioUdec = 1 >
						<cfset LvarPrecioUdec = req.Pvalor>
					<cfelse>
						<cfset hayPrecioUdec = 0 >
						<cfset LvarPrecioUdec = 4>
					</cfif>
					<td width="39%" align="right" nowrap>Número de decimales para Precio Unitario:&nbsp;</td>
					
					<td width="35%">
						<select name="PrecioUdec" onchange="if(this.form.PrecioUdecRPT.selectedIndex > this.form.PrecioUdec.selectedIndex) this.form.PrecioUdecRPT.selectedIndex = this.form.PrecioUdec.selectedIndex;">
							<option value="2" <cfif LvarPrecioUdec EQ 2>selected</cfif>>15 enteros 2 decimales</option>
							<option value="3" <cfif LvarPrecioUdec EQ 3>selected</cfif>>14 enteros 3 decimales</option>
							<option value="4" <cfif LvarPrecioUdec EQ 4>selected</cfif>>13 enteros 4 decimales</option>
							<option value="5" <cfif LvarPrecioUdec EQ 5>selected</cfif>>12 enteros 5 decimales</option>
							<option value="6" <cfif LvarPrecioUdec EQ 6>selected</cfif>>11 enteros 6 decimales</option>
							<option value="7" <cfif LvarPrecioUdec EQ 7>selected</cfif>>10 enteros 7 decimales</option>
							<option value="8" <cfif LvarPrecioUdec EQ 8>selected</cfif>>09 enteros 8 decimales</option>
						</select>
					</td>
					<td rowspan="4" valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Poner Ayuda</td></tr>
					</table>
					--->							
					</td>
				</tr>

				<tr> 
					<cfset req = ObtenerDato(546)>
					<cfif req.RecordCount GT 0 >
						<cfset hayPrecioUdecRPT = 1 >
						<cfset LvarPrecioUdecRPT = req.Pvalor>
					<cfelse>
						<cfset hayPrecioUdecRPT = 0 >
						<cfset LvarPrecioUdecRPT = 2>
					</cfif>
					<td width="39%" align="right" nowrap>Decimales del Precio Unitario en Reportes:&nbsp;</td>
					
					<td width="35%">
						<select name="PrecioUdecRPT" onchange="if(this.form.PrecioUdecRPT.selectedIndex > this.form.PrecioUdec.selectedIndex) this.form.PrecioUdecRPT.selectedIndex = this.form.PrecioUdec.selectedIndex;">	  
							<option value="2" <cfif LvarPrecioUdecRPT EQ 2>selected</cfif>>15 enteros 2 decimales</option>
							<option value="3" <cfif LvarPrecioUdecRPT EQ 3>selected</cfif>>14 enteros 3 decimales</option>
							<option value="4" <cfif LvarPrecioUdecRPT EQ 4>selected</cfif>>13 enteros 4 decimales</option>
							<option value="5" <cfif LvarPrecioUdecRPT EQ 5>selected</cfif>>12 enteros 5 decimales</option>
							<option value="6" <cfif LvarPrecioUdecRPT EQ 6>selected</cfif>>11 enteros 6 decimales</option>
							<option value="7" <cfif LvarPrecioUdecRPT EQ 7>selected</cfif>>10 enteros 7 decimales</option>
							<option value="8" <cfif LvarPrecioUdecRPT EQ 8>selected</cfif>>09 enteros 8 decimales</option>
						</select>
					</td>
					<td rowspan="4" valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Poner Ayuda</td></tr>
					</table>
					--->							
					</td>
				</tr>
				
				<tr> 
					<cfset req = ObtenerDato(548)>
					<cfif req.RecordCount GT 0 >
						<cfset hayCPcompras = 1 >
						<cfset LvarCPcompras = req.Pvalor>
					<cfelse>
						<cfset hayCPcompras = 0 >
						<cfset LvarCPcompras = 0>
					</cfif>
					<td width="39%" align="right" nowrap>Control de Presupuesto en Compras de Artículos de Inventario:&nbsp;</td>
					
					<td width="35%">
						<select name="CPcompras">	  
							<option value="0" <cfif LvarCPcompras EQ 0>selected</cfif>>Controlar el Consumo</option>
							<option value="1" <cfif LvarCPcompras EQ 1>selected</cfif>>Controlar la Compra</option>
						</select>
					</td>
					<td rowspan="4" valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Poner Ayuda</td></tr>
					</table>
					--->							
					</td>
				</tr>
				<!---►►►Parametro 4100:Controlar existencias de artículos en solicitudes de requisición◄◄◄--->
                <cfset chkContExisSol = ObtenerDato(4100).Pvalor>
                <tr>
                	<td align="right">Controlar existencias de artículos en solicitudes de requisición:</td>
                    <td><input name="chkContExisSol" type="checkbox" value="1" <cfif chkContExisSol EQ 1>checked="checked"</cfif>></td>
                </tr>
				<!--- FACTURACION --->
				<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Facturaci&oacute;n</font></b></td></tr>
				<cfset rsSupervisor = ObtenerDato(430)>
				<cfif rsSupervisor.RecordCount GT 0 >
					<cfset haySupervisor = 1 >
					<cfset supervisor = rsSupervisor.Pvalor>
				<cfelse>	
					<cfset supervisor = '' >
				</cfif>
				<tr>
					<td align="right">Supervisor de Cierre de Cajas:&nbsp;</td>
					<td>
						<cfif Len(Trim(supervisor)) GT 0>
						<cfquery name="rsNombre" datasource="asp">
							select 
								{fn concat({fn concat({fn concat({fn concat(
								Pnombre , ' '  )}, Papellido1 )}, ' ' )}, Papellido2 )}as Nombre  
							from Usuario a, DatosPersonales b
							where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#supervisor#">
							and a.datos_personales=b.datos_personales
						</cfquery>
						<cfset nombre = rsNombre.Nombre >
						<cfelse>
							<cfset nombre = '' >
						</cfif>
						<input name="FANombreSupervisor" type="text" value="<cfoutput>#nombre#</cfoutput>" id="FANombreSupervisor" size="40" maxlength="80" readonly tabindex="-1">
						<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Usuarios de SIF" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doSupervisor();"></a>
						<input name="FASupervisor" type="hidden" id="FASupervisor" value="<cfoutput>#supervisor#</cfoutput>">
					</td>
					<td valign="middle">
					<!---
					<table width="100%" class="ayuda">
					<tr><td>Falta Ayuda</td></tr>
					</table>
					--->
					</td>
				</tr>
				
				<cfset rsCierreCaja = ObtenerDato(500)>
				<cfif rsCierreCaja.RecordCount GT 0 >
					<cfset hayCierreCaja = 1 >
					<cfset cierreCaja = rsCierreCaja.Pvalor>
				<cfelse>	
					<cfset cierreCaja = '' >
				</cfif>
				<tr>
					<td align="right">Usa Cierre de Caja:&nbsp;</td>
					<td><input type="checkbox" name="chkCierreCaja" <cfif trim(cierreCaja) eq 'S'>checked</cfif> ></td>
				</tr>
				
				<cfset rsAumentaConsecutivo = ObtenerDato(510)>
				<cfif rsAumentaConsecutivo.RecordCount GT 0 >
					<cfset hayAumentaConsecutivo = 1 >
					<cfset aumentaConsecutivo = rsAumentaConsecutivo.Pvalor>
				<cfelse>	
					<cfset aumentaConsecutivo = '' >
				</cfif>
				<tr>
					<td align="right" nowrap>Modifica n&uacute;mero de factura al reimprimir:&nbsp;</td>
					<td><input type="checkbox" name="chkAumentaConsecutivo" <cfif trim(aumentaConsecutivo) eq 'S'>checked</cfif> ></td>
				</tr>
				
				<tr>
					<td align="right" nowrap>Cuenta de Ingresos por intereses corrientes:&nbsp;</td>
						<cfset cuentaCorrientes = ObtenerDato(550)>	
						<cfif cuentaCorrientes.RecordCount gt 0 and len(trim(cuentaCorrientes.Pvalor))>
							<cfquery name="rsCuentaCor" datasource="#session.DSN#">
								select Ccuenta, Cmayor, Cformato, Cdescripcion
								from CContables
								where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaCorrientes.Pvalor#">
							</cfquery>
							<cfset hayCorrientes = 1 > 
						<cfelse>
							<cfset hayCorrientes = 0 > 
						</cfif>
						
						<td>
							<cfif isdefined("rsCuentaCor") and rsCuentaCor.RecordCount gt 0>
								<cf_cuentas frame="frCuentaCorrientes" Ccuenta="CCorrientes" Cformato="FCCorrientes" Cmayor="MCCorrientes" Cdescripcion="DCCorrientes" form="form1" query="#rsCuentaCor#" >
								<cfelse>
								<cf_cuentas frame="frCuentaCorrientes" Ccuenta="CCorrientes" Cformato="FCCorrientes" Cmayor="MCCorrientes" Cdescripcion="DCCorrientes" form="form1" >
							</cfif>
						</td>
						<td>&nbsp;</td>
					</tr>
					
					<tr>
						<td align="right" nowrap>Cuenta de Ingresos por intereses moratorios:&nbsp;</td>
							<cfset cuentaMoratorios = ObtenerDato(560)>	
							<cfif cuentaMoratorios.RecordCount gt 0 and len(trim(cuentaMoratorios.Pvalor))>
								<cfquery name="rsCuentaMor" datasource="#session.DSN#">
									select Ccuenta, Cmayor, Cformato, Cdescripcion
									from CContables
									where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cuentaMoratorios.Pvalor#">
								</cfquery>
								<cfset hayMoratorios = 1 > 
							<cfelse>
								<cfset hayMoratorios = 0 > 
							</cfif>
							
							<td>
								<cfif isdefined("rsCuentaMor") and rsCuentaMor.RecordCount gt 0>
									<cf_cuentas frame="frCuentaMoratorios" Ccuenta="CMoratorios" Cformato="FCMoratorios" Cmayor="MCMoratorios" Cdescripcion="DCMoratorios" form="form1" query="#rsCuentaMor#" >
									<cfelse>
									<cf_cuentas frame="frCuentaMoratorios" Ccuenta="CMoratorios" Cformato="FCMoratorios" Cmayor="MCMoratorios" Cdescripcion="DCMoratorios" form="form1" >
								</cfif>
							</td>
							<td>&nbsp;</td>
						</tr>
						
						<!--- Producción y Transformación de Inventario --->
						<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Producci&oacute;n y Transformaci&oacute;n de Inventario</font></b></td></tr>
						<!--- 490. Valida Producción antes que Ventas o Mantener Costo de Venta Pendientes --->	
						<cfset rsValidaProduccion = ObtenerDato(490)>
						<cfif rsValidaProduccion.RecordCount GT 0 >
							<cfset hayValidaProduccion = 1 >
							<cfset ValidaProduccion = rsValidaProduccion.Pvalor>
						<cfelse>	
							<cfset ValidaProduccion = '' >
						</cfif>
						<tr>
							<td width="39%" align="right" nowrap>Mantener Costo de Ventas Pendiente:&nbsp;</td>
							<td><input type="checkbox" name="chkValidaProduccion" <cfif trim(ValidaProduccion) eq '1'>checked</cfif> ></td>
							<td rowspan="5" valign="middle">
								<!---
								<table width="100%" class="ayuda">
								<tr><td>Poner Ayuda</td></tr>
								</table>
								--->							
							</td>
						
						</tr>
						
						<!--- 441. Moneda de Valuación de Inventarios --->	
						<cfquery name="rsMonedas" datasource="#Session.DSN#">
							select Mcodigo, Mnombre from Monedas
							where Ecodigo = #Session.Ecodigo#
						</cfquery>
						
						<cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
							select Mcodigo from Empresas 
							where Ecodigo = #Session.Ecodigo#
						</cfquery>

						<cfset rsMcodigoValuacionIV = ObtenerDato(441)>
						<cfif rsMcodigoValuacionIV.RecordCount GT 0 AND rsMcodigoValuacionIV.Pvalor NEQ "">
							<cfset hayMcodigoValuacionIV = true>
							<cfset McodigoValuacionIV = rsMcodigoValuacionIV.Pvalor>
						<cfelse>	
							<cfset hayMcodigoValuacionIV = false>
							<cfset McodigoValuacionIV = rsMonedaEmpresa.Mcodigo>
						</cfif>
						<tr>
							<td width="39%" align="right" nowrap>Moneda Valuación Inventarios:&nbsp;</td>
							<td>
								<select name="McodigoValuacionIV" <cfif hayMcodigoValuacionIV> disabled </cfif>>
									<cfoutput query="rsMonedas">
										<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ McodigoValuacionIV> selected </cfif>>#rsMonedas.Mnombre#</option>
									</cfoutput>
								</select>
							</td>
							<td rowspan="5" valign="middle">
							</td>
						
						</tr>

						<!--- 450. Socio para Importaciones --->
						<cfset rsSocioImportacion = ObtenerDato(450)>
						<cfif rsSocioImportacion.RecordCount GT 0 >
							<cfset haySocioImportacion = 1 >
							<cfset SocioImportacion = rsSocioImportacion.Pvalor>
						<cfelse>	
							<cfset SocioImportacion = '' >
						</cfif>
						<tr>
							<td width="39%" align="right" nowrap>Socio de Importaci&oacute;n:&nbsp;</td>
							<td>
								<cfif Len(Trim(SocioImportacion)) GT 0>
									<cfquery name="rsNombreSocio" datasource="#session.DSN#">
									select SNnombre from SNegocios
									where SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#SocioImportacion#">
                                    and Ecodigo = #session.Ecodigo#
									</cfquery>
									<cfset nombre = rsNombreSocio.SNnombre >
								<cfelse>
									<cfset nombre = '' >
								</cfif>
								<input name="NombreSocioImportacion" type="text" value="<cfoutput>#nombre#</cfoutput>" id="NombreSocioImportacion" size="40" maxlength="80" readonly tabindex="-1">
								<a href="#" tabindex="-1"><img src="../../imagenes/Description.gif" alt="Lista de Socios de Negocio" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doSocioImportacion();"></a>
								<input name="SocioImportacion" type="hidden" id="SocioImportacion" value="<cfoutput>#SocioImportacion#</cfoutput>">
							</td>
						</tr>
						
						<!--- 460. Tipo de TRansaccion CxP para Importaciones--->
						<tr> 
							<cfset transaccion_cp = ''>
							<cfset trcp = ObtenerDato(460)>
							<cfif trcp.RecordCount GT 0 >
								<cfset hayTransaccionCP = 1 >
								<cfset transaccion_cp = trcp.Pvalor>
							</cfif>
							<td align="right">Transacci&oacute;n CxP para Importaciones:&nbsp;</td>
							<td>
								<select name="TransaccionCP">
									<cfoutput query="rsTransaccionCP">
									<option value="#rsTransaccionCP.CPTcodigo#" <cfif rsTransaccionCP.CPTcodigo eq transaccion_cp > selected </cfif> >#rsTransaccionCP.CPTdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						
						<!--- 480. Tipo de TRansaccion CxC para Importaciones--->
						<tr> 
							<cfset transaccion_cc = ''>
							<cfset trcc = ObtenerDato(480)>
							<cfif trcc.RecordCount GT 0 >
								<cfset hayTransaccionCC = 1 >
								<cfset transaccion_cc = trcc.Pvalor>
							</cfif>
							<td width="39%" align="right" nowrap>Transacci&oacute;n CxC para Importaciones:&nbsp;</td>
							<td>
								<select name="TransaccionCC">
									<cfoutput query="rsTransaccionCC">
									<option value="#rsTransaccionCC.CCTcodigo#" <cfif rsTransaccionCC.CCTcodigo eq transaccion_cc > selected </cfif> >#rsTransaccionCC.CCTdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						
						<!--- 470. Tipo de TRansaccion CxC para Importaciones--->
						<tr> 
							<cfset impuesto = ''>
							<cfset impu = ObtenerDato(470)>
							<cfif impu.RecordCount GT 0 >
								<cfset hayImpuesto = 1 >
								<cfset impuesto = impu.Pvalor>
							</cfif>
							<td width="39%" align="right" nowrap>Impuesto para Importaciones:&nbsp;</td>
							<td>
								<select name="Icodigo">
									<cfoutput query="rsImpuestos">
									<option value="#rsImpuestos.Icodigo#" <cfif trim(rsImpuestos.Icodigo) eq trim(impuesto) >selected</cfif> >#rsImpuestos.Idescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td width="39%" align="right" nowrap>No contabiliza el Costo de Ventas ni Ajustes:&nbsp;</td>
							<td><input type="checkbox" name="chkValorNoContaCosto"<cfif trim(ValorNoContaCosto) eq '1'>checked</cfif>></td>
						</tr>
						
						<tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Interfaces</font></b></td></tr>
						
						<!--- 590. Código de Transacción para CxP --->
						<tr> 
							<cfset transaccion_cp = ''>
							<cfset trcp = ObtenerDato(590)>
							<cfif trcp.RecordCount GT 0 >
								<cfset hayTransaccionCPInterfaz = 1 >
								<cfset transaccion_cp = trcp.Pvalor>
							</cfif>
							<td align="right">Transacci&oacute;n CxP por Defecto:&nbsp;</td>
							<td>
								<select name="CPTransInterfaz">
									<cfoutput query="rsTransaccionCP">
									<option value="#rsTransaccionCP.CPTcodigo#" <cfif rsTransaccionCP.CPTcodigo eq transaccion_cp > selected </cfif> >#rsTransaccionCP.CPTdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						
						
						<!--- 600. Código de Transacción para CxC --->
						<tr> 
							<cfset transaccion_cc = ''>
							<cfset trcc = ObtenerDato(600)>
							<cfif trcc.RecordCount GT 0 >
								<cfset hayTransaccionCCInterfaz = 1 >
								<cfset transaccion_cc = trcc.Pvalor>
							</cfif>
							<td width="39%" align="right" nowrap>Transacci&oacute;n CxC por Defecto:&nbsp;</td>
							<td>
								<select name="CCTransInterfaz">
									<cfoutput query="rsTransaccionCC">
										<option value="#rsTransaccionCC.CCTcodigo#" <cfif rsTransaccionCC.CCTcodigo eq transaccion_cc > selected </cfif> >#rsTransaccionCC.CCTdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
						     <cfset LvarAsientoAut = ObtenerDato(2400)>	
							<td width="39%" align="right" nowrap>Aplicar Asientos Importados Automáticamente:&nbsp;</td>
							<td>
							<input name="AsientosAutom" type="checkbox" <cfif LvarAsientoAut.Pvalor eq '1'>checked</cfif> />
							</td>
						</tr>

						<!--- FORMA DE CALCULO DE IMPUESTOS EN COMPRAS, CXP y CXC --->
                        <cfset calculo = ObtenerDato(420)>
                        <cfif calculo.RecordCount GT 0 >
                            <cfset haycalculoImp = 1 >
                        </cfif>		
                        <tr><td colspan="3" align="center" class="listaPar"><hr size="0"><b><font size="2">Manejo del Descuento a nivel de Documento para calcular Impuestos en CXC y CXP</font></b></td></tr>
                        <tr><td colspan="3" align="center"><font style="font-size:10px">(El Descuento a nivel de Línea siempre disminuye la base del Impuesto y el Ingreso)</font></td></tr>
                        <tr>
                            <td align="right" nowrap>Forma de Cálculo del Impuesto:&nbsp;</td>
                            <td>
                                <select name="CalculoImp">
                                    <option value="1" <cfif trim(calculo.Pvalor) eq 1>selected</cfif> >Calcular Impuesto sin rebajar el Descuento Documento</option>
                                    <option value="0" <cfif trim(calculo.Pvalor) eq 0>selected</cfif> >Prorratear Descuento Documento y calcular Impuesto</option>
                                </select>
                            </td>
                        </tr>

						<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Cuentas por Cobrar</font></b>
							</td>
						</tr>
						<!---FORMATO DE MASCARA PARA CEDULA DE SOCIO JURIDICO (MODIFICACIONES REQUERIDAS PAR CXC)--->
						<tr> 
							<td align="right" nowrap>M&aacute;scara de C&eacute;dula de Socio Jur&iacute;dico:&nbsp;</td>
							<td>
								<input name="mascaraCedJ" type="text" size="50" maxlength="100" 
									onChange="javascript: validaCedula();"
									onKeyPress="return acceptX(event)"
									value="<cfoutput>#maskCedJ.Pvalor#</cfoutput>">
							</td>
							<td width="20%">&nbsp;</td>
						</tr>
						<!--- FORMATO DE MASCARA PARA CEDULA DE SOCIO FISICO (MODIFICACIONES REQUERIDAS PAR CXC)--->
						<tr> 
							<td align="right" nowrap>M&aacute;scara de C&eacute;dula de Socio F&iacute;sico:&nbsp;</td>
							<td>
								<input name="mascaraCedF" type="text" size="50" maxlength="100" 
									onChange="javascript: validaCedula();"
									onKeyPress="return acceptX(event)"								 
									value="<cfoutput>#maskCedF.Pvalor#</cfoutput>">
							</td>
							<td width="20%">&nbsp;</td>
						</tr>
						<tr> 
							<td align="right" nowrap>Mostrar Clasificaci&oacute;n:&nbsp;</td>
							<td>
								<input name="VerClasificaCC" type="checkbox" <cfif ValorVerClasifCC eq 1>checked</cfif>  >
							</td>
							<td width="20%">&nbsp;</td>
						</tr>
						<!--- Clasificación a utilizar en el reporte de Consolidado Contable --->
						<tr> 
							<td align="right" nowrap>Clasificación Reporte Consolidado Contable</td>
							<td>
							
								<cfif isdefined('LvarSNCEid') and LvarSNCEid.recordcount gt 0>
									<cfquery name="rsClasif" datasource="#session.DSN#">	
										select SNCEid, SNCEcodigo, SNCEdescripcion
										from SNClasificacionE
										where #filtroE#
										  and SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNCEid.Pvalor#">
								</cfquery>
									<cf_sifSNClasificacion form="form1" tabindex="1" query="#rsClasif#">
								<cfelse>
									<cf_sifSNClasificacion form="form1" tabindex="1">
								</cfif>
							</td>
							<td width="20%">&nbsp;</td>
						</tr>

						<cfset hayDescDoc = 0>
						<cfset descDoc = ObtenerDato(421)>
						<cfif descDoc.RecordCount GT 0 >
							<cfset hayDescDoc = 1 >
						</cfif>		

						<tr>
							<td align="right" nowrap>Forma de Contabilizar Descuento Documento:&nbsp;</td>
							<td>
								<select name="descDoc">
									<option value="D" <cfif trim(descDoc.Pvalor) eq "D" >selected</cfif> >Utilizar Cuenta de Descuentos de CxC</option>
									<option value="I" <cfif trim(descDoc.Pvalor) eq "I" >selected</cfif> >Prorratear Descuento Documento y Disminuir Cuenta Ingreso</option>
								</select>
							</td>
						</tr>
						<!---Concatenar Socio de Negocio a las lineas de las Facturas de CXC y CXP--->
						<tr>
							<td align="right" nowrap>Incluir Socio de Negocios en las líneas de la póliza Contable:&nbsp;</td>
							<td><input name="SNPoliza" value="1" type="checkbox" <cfif SNPoliza eq 1>checked</cfif>></td>
						</tr>
                        
                        <tr>
                          <td align="right" nowrap>Leyenda para Estados de Cuenta CxC:&nbsp;</td>
                          <td><input name="verLeyendaCxC" type="text" size="70" maxlength="100" value="<cfoutput>#HTMLEditFormat(leyendaCxC.Pvalor)#</cfoutput>"></td>
                        </tr>

						<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxP --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Cuentas por Pagar</font></b>
							</td>
						</tr>
						<tr> 
							<td align="right" nowrap>Mostrar Clasificaci&oacute;n:&nbsp;</td>
							<td>
								<input name="VerClasificaCP" type="checkbox" <cfif ValorVerClasifCP eq 1>checked</cfif>>
							</td>
							<td width="20%">&nbsp;</td>
						</tr>

						<cfset rsRecurrentes = ObtenerDato(880)>
						<cfset hayRecurrentes = 0 >
						<cfif rsRecurrentes.recordcount gt 0 >
							<cfset hayRecurrentes = 1 >
						</cfif>
						<tr> 
							<td align="right" nowrap>No permitir el mismo documento recurrente para varias facturas en un mismo per&iacute;odo y mes:&nbsp;</td>
							<td>
								<input name="chkRecurrentes" type="checkbox" <cfif not (rsRecurrentes.Pvalor eq 0) >checked</cfif>>
							</td>
							<td width="20%">&nbsp;</td>
						</tr>
						
						<tr>
							<td align="right">Tipo de Movimiento Bancario Pago de Renta</td>
                            <td><cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
								<cfset Lvar_BTidPR = ObtenerDato(2000).Pvalor>
								<cfquery name="rsBTransacciones" datasource="#session.dsn#">
									select BTid, BTcodigo #_Cat#' - '#_Cat# BTdescripcion Descripcion
									from BTransacciones 
									where Ecodigo = #Session.Ecodigo#  
                                    order by BTid
								</cfquery>
								<select name="BTidPR">
									<cfoutput query="rsBTransacciones">
										<option value="#rsBTransacciones.BTid#"
											<cfif Lvar_BTidPR eq rsBTransacciones.BTid>
												selected
											</cfif>
										>
											#rsBTransacciones.Descripcion#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr> 
						
				<!--- --->
						 <tr>
							<td><div align="right">Oficina Estimación de Avance:&nbsp;</div></td>
							<cfset Lvar_Oficina = ObtenerDato(2900).Pvalor>
							<cfquery name="rsOficinas" datasource="#Session.DSN#">
								select Ocodigo, Odescripcion from Oficinas 
								where Ecodigo = #Session.Ecodigo#
								order by Ocodigo                      
							</cfquery>

							<td><select name="Ocodigo" tabindex="1">
								 <cfoutput query="rsOficinas">
										<option value="#rsOficinas.Ocodigo#"
											<cfif Lvar_Oficina eq rsOficinas.Ocodigo>
												selected
											</cfif>
										>
											#rsOficinas.Odescripcion#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr>
							
						 <tr>
							<td><div align="right">Tipo de Transacción para la Estimación de Avance:&nbsp;</div></td>
							<cfset Lvar_Transaccion = ObtenerDato(2910).Pvalor>
							<cfquery name="rsTransac" datasource="#Session.DSN#">
								select CPTcodigo, CPTdescripcion , CPTtipo
								from CPTransacciones 
								where Ecodigo= #session.Ecodigo#
								and CPTpago = 0
								and NOT CPTdescripcion like '%Tesorer_a%'
								and CPTtipo = 'C'
							</cfquery>

							<td><select name="Transaccion" tabindex="1">
								 <cfoutput query="rsTransac">
										<option value="#rsTransac.CPTcodigo#"
											<cfif Lvar_Transaccion eq rsTransac.CPTcodigo>
												selected
											</cfif>
										>
											#rsTransac.CPTcodigo#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr>
				<!--- --->					
						
						<tr><td colspan="3">&nbsp;</td></tr>

						<!---BANCOS --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Bancos</font></b>
							</td>
						</tr>

						<cfquery name="btransacciones" datasource="#session.DSN#">
							select BTid, BTcodigo, BTdescripcion, BTtipo 
							from BTransacciones 
							where Ecodigo=#Session.Ecodigo#
						</cfquery>	
						<tr> 
							<cfset rsMBOrigen = ObtenerDato(160)>
							<cfset origenmb = ''>
							<cfset hayMBOrigen = 0 >
							<cfif rsMBOrigen.RecordCount GT 0 >
								<cfset hayMBOrigen = 1 >
								<cfset origenmb = rsMBOrigen.Pvalor>
							</cfif>
							<td width="39%" align="right" nowrap>Tipo de movimiento origen para transferencias bancarias:&nbsp;</td>
							
							<td width="35%">
								<select name="origenmb">	  
									<cfif rsMBOrigen.RecordCount EQ 0>
									<option value="-1"></option>
									</cfif>
									<cfoutput query="btransacciones">
										<cfif btransacciones.BTtipo eq 'C'>
										<option value="#btransacciones.BTid#" <cfif trim(btransacciones.BTid) eq trim(origenmb)> selected </cfif> >#trim(btransacciones.BTcodigo)# - #btransacciones.BTdescripcion#</option>
										</cfif>
									</cfoutput>
								</select>
							</td>
							<td rowspan="4" valign="middle">
							<!---
							<table width="100%" class="ayuda">
							<tr><td>Poner Ayuda</td></tr>
							</table>
							--->							
							</td>
						</tr>

						<tr> 
							<cfset rsMBDestino = ObtenerDato(170)>
							<cfset destinomb = ''>
							<cfset hayMBDestino = 0 >
							<cfif rsMBDestino.RecordCount GT 0 >
								<cfset hayMBDestino = 1 >
								<cfset destinomb = rsMBDestino.Pvalor>
							</cfif>
							<td width="39%" align="right" nowrap>Tipo de movimiento destino para transferencias bancarias:&nbsp;</td>
							
							<td width="35%">
								<select name="destinomb">	  
									<cfif rsMBDestino.RecordCount EQ 0>
									<option value="-1"></option>
									</cfif>
									<cfoutput query="btransacciones">
										<cfif btransacciones.BTtipo eq 'D'>
										<option value="#btransacciones.BTid#" <cfif trim(btransacciones.BTid) eq trim(destinomb)> selected </cfif> >#trim(btransacciones.BTcodigo)# - #btransacciones.BTdescripcion#</option>
										</cfif>
									</cfoutput>
								</select>
							</td>
							<td rowspan="4" valign="middle">
							<!---
							<table width="100%" class="ayuda">
							<tr><td>Poner Ayuda</td></tr>
							</table>
							--->							
							</td>
						</tr>
						
						<!---ACTIVOS FIJOS--->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Activos Fijos</font></b>
							</td>
						</tr>
						<tr>
							<td align="right">Diferencia de Meses de Saldos para Reevaluaci&oacute;n:&nbsp;</td>
							<td>
								<!--- Este parámetro es solo visible, no modificable, porque no se puede cambiar en ningún momento, cuando se 
								realiza la implementación del sistema se deja listo. --->
								<cfoutput>#ObtenerDato(900).Pvalor#</cfoutput>
							</td>
						</tr> 
						
						<tr>
							<td align="right">Control de Transacciones de Control de Responsables:&nbsp;</td>
							<td>
								<!--- Este parámetro es solo visible, no modificable, porque no se puede cambiar en ningún momento, cuando se 
								realiza la implementación del sistema se deja listo. --->
								<cfif ObtenerDato(970).Pvalor eq 1>Activo<cfelse>Inactivo</cfif>
							</td>
						</tr> 						
						
						<tr>
							<td align="right">Tipo de Documento para Vales de Adqusici&oacute;n:&nbsp;</td>
							<td>
								<cfset Lvar_CRTDid = ObtenerDato(910).Pvalor>
								<cfquery name="rsCRTipoDocumento" datasource="#session.dsn#">
									select CRTDid, CRTDcodigo, CRTDdescripcion
									from CRTipoDocumento
									where Ecodigo = #Session.Ecodigo#  
								</cfquery>
								<select name="P910">
									<cfoutput query="rsCRTipoDocumento">
										<option value="#rsCRTipoDocumento.CRTDid#"
											<cfif Lvar_CRTDid eq rsCRTipoDocumento.CRTDid>
												selected
											</cfif>
										>
											#rsCRTipoDocumento.CRTDcodigo# - #rsCRTipoDocumento.CRTDdescripcion#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr> 
						
						<tr>
							<td align="right">Asiento Contable de deprecici&oacute;n detallado:&nbsp;</td>
							<td>
								<input name="VerAstDet" type="checkbox" <cfif ValorVerAstDet eq 1>checked</cfif>>
							</td>
						</tr> 						
						
						
						<tr> 
							<cfset rsMeses = ObtenerDato(940)>
							<cfset destinomeses = ''>
							<cfset haymeses = 0 >
							<cfif rsMeses.RecordCount GT 0 >
								<cfset haymeses = 1 >
								<cfset destinomeses = rsMeses.Pvalor>
							</cfif>

							<td align="right" nowrap>Meses para calcular Fecha de Inicio de Depreciación:&nbsp;</td>
							
							<td>
								<select name="cbomesesdep">
									<option value=""></option>
									<cfloop from="1" to="12" step="1" index="ind">
										<option value="<cfoutput>#ind#</cfoutput>" <cfif trim(ind) eq trim(destinomeses)> selected </cfif> ><cfoutput>#ind#</cfoutput></option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr> 
							<cfset rsMeses1 = ObtenerDato(950)>
							<cfset destinomeses1 = ''>
							<cfset haymeses1 = 0 >
							<cfif rsMeses1.RecordCount GT 0 >
								<cfset haymeses1 = 1 >
								<cfset destinomeses1 = rsMeses1.Pvalor>
							</cfif>
							<td align="right" nowrap>Meses para calcular Fecha de Inicio de Revaluación:&nbsp;</td>
							
							<td>
								<select name="cbomesesrev">  
									<option value=""></option>
									<cfloop from="1" to="12" step="1" index="ind">
										<option value="<cfoutput>#ind#</cfoutput>" <cfif trim(ind) eq trim(destinomeses1)>selected="selected"</cfif>><cfoutput>#ind#</cfoutput></option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">Considerar traslados, retiros y Revaluaciónes del último periodo en la Revaluación:&nbsp;</td>
							<td>
								<input name="ProRev" type="checkbox" <cfif ProRev eq 1>checked</cfif>>
							</td>
						</tr>
						<tr>
							<td align="right">Aplicar retiros automáticamente:&nbsp;</td>
							<td>
								<input name="RetAuto" type="checkbox" <cfif ValorRetAuto eq 1>checked</cfif>>
							</td>
						</tr>
							
						<tr>
							<td align="right">Traspasos de documentos en autogestion autorizados por el jefe del Centro de Custodia:&nbsp;</td>
							<td>
								<input name="AutorizacionCustodia" type="checkbox" <cfif ValorAutorizacionCustodia eq 1>checked</cfif>>
							</td>
						</tr>
						<cfset ValesMejora= ObtenerDato(1300)>
						<tr>
							<td align="right">NO Permitir Vales por Mejora de Activos Fijos:&nbsp;</td>
							<td>
								<input name="ValesMejora" type="checkbox" <cfif ValesMejora.Pvalor eq 1>checked</cfif>>
							</td>
						</tr>
						<cfset configNoMej= ObtenerDato(3100)>
						<tr>
							<td align="right">Activar Configuración "No permite mejoras o adiciones":&nbsp;</td>
							<td>
								<input name="configNoMej" type="checkbox" value="1" <cfif configNoMej.Pvalor eq 1>checked</cfif>>
							</td>
						</tr>
						
						<cfset OrigenA = ObtenerDato(1110)>
						<tr>
							<td nowrap align="right">Etiqueta "Origen" de los Vales:&nbsp;</td>
							<td><input name="Origen" style="text-align:left" type="text" value="<cfif OrigenA.RecordCount gt 0 and len(trim(OrigenA.Pvalor))><cfoutput>#OrigenA.Pvalor#</cfoutput><cfelse></cfif>" size="25" maxlength="100"></td>
						</tr>
						
						<!--- Quick Pass --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Quick Pass</font></b>
							</td>
						</tr>
						<tr>
							<td align="right">Moneda de la Cuenta de Saldos&nbsp;</td>
                            <td>
								<cfset Lvar_Mcodigo = ObtenerDato(447).Pvalor>
								<cfquery name="rsQPcuentaSaldos" datasource="#session.dsn#">
									select Mcodigo, Mnombre
									from Monedas
									where Ecodigo = #Session.Ecodigo#  
                                    order by Mnombre
								</cfquery>
								<select name="P447">
									<cfoutput query="rsQPcuentaSaldos">
										<option value="#rsQPcuentaSaldos.Mcodigo#"
											<cfif Lvar_Mcodigo eq rsQPcuentaSaldos.Mcodigo>
												selected
											</cfif>
										>
											#rsQPcuentaSaldos.Mnombre#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr> 
						<!--- Peaje --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Peaje</font></b>
							</td>
						</tr>
						<tr>
							<td align="right">Tipo de Transacci&oacute;n:&nbsp;</td>
                            <td><cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
								<cfset Lvar_BTid = ObtenerDato(1800).Pvalor>
								<cfquery name="rsBTransacciones" datasource="#session.dsn#">
									select BTid, BTcodigo #_Cat#' - '#_Cat# BTdescripcion Descripcion
									from BTransacciones 
									where Ecodigo = #Session.Ecodigo#  
                                    order by BTid
								</cfquery>
								<select name="BTid">
									<cfoutput query="rsBTransacciones">
										<option value="#rsBTransacciones.BTid#"
											<cfif Lvar_BTid eq rsBTransacciones.BTid>
												selected
											</cfif>
										>
											#rsBTransacciones.Descripcion#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">Banco:</td>
							<td>
								<cfquery datasource="#Session.DSN#" name="rsBancos">
									select Bid as BancoId, Bdescripcion as bancoDescripcion
									from Bancos 
									where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
									order by Bdescripcion
								</cfquery>
								<cfset selected="selected">			
								<select name="Bid" tabindex="1" onchange="javascript:limpiarCuenta();">
								<option value="">-- Seleccione un Banco --</option>
								<cfloop query="rsBancos">
									<option value="<cfoutput>#rsBancos.BancoId#</cfoutput>" <cfif #Bid# eq #rsBancos.BancoId#> selected="selected"</cfif>><cfoutput>#BancoDescripcion#</cfoutput></option>
								</cfloop>						
								</select>
							</td>
						</tr>
						<tr>
							<td align="right">Cuenta Bancaria: <input type="hidden" name="fecha" value="<cfoutput>#PAfecha#</cfoutput>"/></td>		
							<td>
								<cf_conlis title="Lista de Cuentas Bancarias"
								campos = "CBid, CBcodigo, CBdescripcion, Mcodigo" 
								values="#CBid#,#CBcodigo#,#CBdescripcion#,#Mcodigo#"
								desplegables = "N,S,S,N" 
								modificables = "N,S,N,N" 
								size = "0,0,40,0"
								tabla="CuentasBancos cb
								inner join Monedas m 
								on cb.Mcodigo = m.Mcodigo
								inner join Empresas e
								on e.Ecodigo = cb.Ecodigo
								left outer join Htipocambio tc
								on 	tc.Ecodigo = cb.Ecodigo
								and tc.Mcodigo = cb.Mcodigo
								and tc.Hfecha  <= $fecha,date$
								and tc.Hfechah >  $fecha,date$ "
								columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo, 
								m.Mnombre,
								round(
								coalesce(
								(	case 
								when cb.Mcodigo = e.Mcodigo then 1.00 
								else tc.TCcompra 
								end
								)
								, 1.00)
								,2) as EMtipocambio"
								filtro="cb.Ecodigo = #Session.Ecodigo# and cb.Bid = $Bid,numeric$ order by Mnombre, Hfecha"
								desplegar="CBcodigo, CBdescripcion"
								etiquetas="C&oacute;digo, Descripci&oacute;n"
								formatos="S,S"
								align="right,right"
								asignar="CBid, CBcodigo, CBdescripcion, Mcodigo, Mnombre, EMtipocambio"
								asignarformatos="S,S,S,S,S,M"
								showEmptyListMsg="true"
								debug="false"
								tabindex="1">
							</td>
						</tr>						

						<tr>
							<td align="right">Concepto de Ingreso:</td>
                      		<td>
								<cfif LvarConGastoI neq '' >
									<cfset hayValorConceptoIngreso = 1 >
								
										<cfquery name="Concep" datasource="#Session.DSN#">
											select a.FPCid,a.FPCcodigo,a.FPCdescripcion,b.FPCCExigeFecha
												from FPConcepto a inner join FPCatConcepto b on b.FPCCid =  a.FPCCid
											where a.FPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarConGastoI#" null="#Len(Trim(LvarConGastoI)) EQ 0#" >
										</cfquery>
								</cfif>
							
								<cfif len(trim(LvarConGastoI)) GT 0>
									<cfset ValuesArray=ArrayNew(1)>
									<cfset ArrayAppend(ValuesArray,Concep.FPCid)>
									<cfset ArrayAppend(ValuesArray,Concep.FPCcodigo)>
									<cfset ArrayAppend(ValuesArray,Concep.FPCdescripcion)>	
									<cfset ArrayAppend(ValuesArray,Concep.FPCCExigeFecha)>	
								<cfelse>
									<cfset ValuesArray=ArrayNew(1)>
								</cfif>
										<cf_conlis
										Campos="FPCid_ALL, FPCcodigo_ALL, FPCdescripcion_ALL,FPCCExigeFecha_ALL"
										ValuesArray="#ValuesArray#"
										Desplegables="N,S,S,N"
										Modificables="N,S,N,N"
										Size="0,10,30,0"
										Title="Lista de Conceptos"
										Tabla="FPConcepto a inner join FPCatConcepto b on b.FPCCid =  a.FPCCid"
										Columnas="FPCid as FPCid_ALL, 
												  FPCcodigo as FPCcodigo_ALL, 
												  FPCdescripcion as FPCdescripcion_ALL,
												  FPCCExigeFecha as FPCCExigeFecha_ALL"
										Filtro="a.Ecodigo = #Session.Ecodigo# and b.FPCCtipo = 'I' 
										order by FPCcodigo, FPCdescripcion"
										Desplegar="FPCcodigo_ALL, FPCdescripcion_ALL"
										Etiquetas="Código,Descripción"
										filtrar_por="FPCcodigo, FPCdescripcion"
										Formatos="S,S"
										Align="left,left"
										Asignar="FPCid_ALL, FPCcodigo_ALL, FPCdescripcion_ALL,FPCCExigeFecha_ALL"
										Asignarformatos="I,S,S,I"
										form="form1"
										funcion="fnExigeFechas"
										/>
							</td>
						</tr>

						<tr>
							<td align="right">Actividad Empresarial:</td>
							<td>
								<cfif LvarActEmp neq '' >
									<cfset hayValorActividadEmpresarial = 1 >
								</cfif>
								
								<cfif LvarActEmpF neq '' >
									<cfset hayValorActividadEmpresarialFormato = 1 >
								</cfif>
								
								 <cfif isdefined('hayValorActividadEmpresarial') and hayValorActividadEmpresarial eq 1 
								 and isdefined('hayValorActividadEmpresarialFormato') and hayValorActividadEmpresarialFormato eq 1>
										<cf_ActividadEmpresa etiqueta="" formname="form1" name="CFComplemento_ALL" idActividad="#LvarActEmp#" valores="#LvarActEmpF#" style="border:solid 1px ##CCCCCC; background:inherit;">
						 		<cfelse>
										<cf_ActividadEmpresa name="CFComplemento_ALL" formname="form1">
								 </cfif>
							</td>
						</tr>
						
                        <!--- Garantia --->
						<tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Garantía</font></b>
							</td>
						</tr>
						<tr>
							<td align="right">Transacción Bancaria para Depósitos de Garantía:&nbsp;</td>
                            <td><cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
								<cfset LvarBTid = ObtenerDato(1810).Pvalor>
								<cfquery name="rsBTranGarantia" datasource="#session.dsn#">
									select BTid, BTcodigo #_Cat#' - '#_Cat# BTdescripcion Descripcion
									from BTransacciones 
									where Ecodigo = #Session.Ecodigo#  
                                    order by BTid
								</cfquery>
								<select name="BTidGarantia">
									<cfoutput query="rsBTranGarantia">
										<option value="#rsBTranGarantia.BTid#"
											<cfif LvarBTid eq rsBTranGarantia.BTid>
												selected
											</cfif>
										>
											#rsBTranGarantia.Descripcion#
										</option>
									</cfoutput>									
								</select>
							</td>
						</tr> 
						<!---Plan de Compras Gobierno--->
                        <tr>
							<td colspan="3" align="center" class="listaPar">
								<hr size="0"><b><font size="2">Plan de Compras Gobierno</font></b>
							</td>
						</tr>
						<tr>
							<td align="right">Cuenta de ingreso por Financiamiento:</td>
							<td><cf_cajascuenta index="1" tabindex="-1" objeto="CFcuentaFinanciamiento" query="#rsCFcuentaFinanciamiento#"></td> <!---Pcodigo 2600--->
						</tr>
						<tr>
							<td align="right">Cuenta de Egresos por Amortización de préstamos:</td>
							<td><cf_cajascuenta index="2" tabindex="-1" objeto="CFcuentacAmortizacion" query="#rsCFcuentacAmortizacion#"></td>    <!---Pcodigo 2800--->
						</tr>
						
                        <tr><td colspan="3">&nbsp;</td></tr>
						<tr> 
								<td colspan="3"><div align="center"> 
								<input type="submit" name="Aceptar" class="btnGuardar" value="Aceptar" onClick="javascript: return valida();">		  		  
							</div></td>
						</tr>
					</table>
			  </td>	
			</tr>	
		</table>	
		
		<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
		<cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>
		<cfoutput>
		<input type="hidden" name="hayCuentaBalAsi" value="#hayCuentaBalAsi#">
		<input type="hidden" name="hayCuentaDifCambAsi" value="#hayCuentaDifCambAsi#">
		<input type="hidden" name="hayCuentaEstimacion" value="#hayCuentaEstimacion#">
		<input type="hidden" name="hayVencimiento1" value="#hayVencimiento1#">
		<input type="hidden" name="hayVencimiento2" value="#hayVencimiento2#">
		<input type="hidden" name="hayVencimiento3" value="#hayVencimiento3#">
		<input type="hidden" name="hayVencimiento4" value="#hayVencimiento4#">
		<input type="hidden" name="hayTipoRequisicion" value="#hayTipoRequisicion#">
		<input type="hidden" name="haySolicitante" value="#haySolicitante#">
		<input type="hidden" name="hayAutorizacion" value="#hayAutorizacion#">
		<input type="hidden" name="hayConsReq" value="#hayConsReq#">
		<input type="hidden" name="hayPublicacion" value="#hayPublicacion#">
		<input type="hidden" name="hayJerarquia" value="#hayJerarquia#">
		<input type="hidden" name="hayValidarCDC" value="#hayValidarCDC#">
		<input type="hidden" name="hayAprobarTolerancia" value="#hayAprobarTolerancia#">
		
		<!--- Parámetros de agrupación de órdenes de compra --->
		<input type="hidden" name="hayAgrupacionOrdenes" value="#hayAgrupacionOrdenes#">
		<input type="hidden" name="hayFrecAgrupOC" value="#hayFrecAgrupOC#">
		<input type="hidden" name="hayDiasSemanaAgrupOC" value="#hayDiasSemanaAgrupOC#">
		<input type="hidden" name="hayDiaMesAgrupOC" value="#hayDiaMesAgrupOC#">
		
		<input type="hidden" name="haycalculoImp" value="#haycalculoImp#">
		<input type="hidden" name="hayDescDoc" value="#hayDescDoc#">
		<input type="hidden" name="haySupervisor" value="#haySupervisor#">
		<input type="hidden" name="hayPrecioUdec" value="#hayPrecioUdec#">
		<input type="hidden" name="hayPlanCuentas" value="#hayPlanCuentas#">
		<input type="hidden" name="hayCierreCaja" value="#hayCierreCaja#">
		<input type="hidden" name="hayAumentaConsecutivo" value="#hayAumentaConsecutivo#">
		<input type="hidden" name="hayValidaProduccion" value="#hayValidaProduccion#">
		<input type="hidden" name="haySocioImportacion" value="#haySocioImportacion#">
		<input type="hidden" name="hayTransaccionCP" value="#hayTransaccionCP#">
		<input type="hidden" name="hayTransaccionCC" value="#hayTransaccionCC#">
		<input type="hidden" name="hayImpuestos" value="#hayImpuestos#">
		<input type="hidden" name="hayNomina" value="#hayNomina#">
		<input type="hidden" name="hayCorrientes" value="#hayCorrientes#">
		<input type="hidden" name="hayMoratorios" value="#hayMoratorios#">
		<input type="hidden" name="hayTransaccionCPInterfaz" value="#hayTransaccionCPInterfaz#">
		<input type="hidden" name="hayTransaccionCCInterfaz" value="#hayTransaccionCCInterfaz#">
		<!--- PARAMETROS NUEVOS RELACIONADO CON LOS CAMBIOS PEDIDOS PARA EL MODULO CxC --->
		<input type="hidden" name="hayFormatoCedulaJuridica" value="#hayFormatoCedulaJuridica#">
		<input type="hidden" name="hayFormatoCedulaFisica" value="#hayFormatoCedulaFisica#">
		<input type="hidden" name="NoModificar" value="#NoModificar#">
		
		<!--- PARAMETROS DE FECHA DE CIERRE DE CONTABILIDAD --->
		<input type="hidden" name="hayCierreConta" value="#hayCierreConta#">
		<input type="hidden" name="hayFechaCierreConta" value="#hayFechaCierreConta#">
		<!--- PARAMETRO DE MOSTRAR CLASIFICACION CUENTAS POR COBRAR--->
		<input type="hidden" name="hayVerClasifCC" value="#ValorVerClasifCC#">
		
		<!--- PARAMETRO DE MOSTRAR CLASIFICACION CUENTAS POR PAGAR--->
		<input type="hidden" name="hayVerClasifCP" value="#ValorVerClasifCP#">

		<input type="hidden" name="hayMBOrigen" value="#hayMBOrigen#">
		<input type="hidden" name="hayMBDestino" value="#hayMBDestino#">

		<!--- PARAMETRO DE NO CONTABILIZAR COSTO DE VENTAS NI AJUSTES --->
		<input type="hidden" name="hayNoContaCosto" value="#ValorNoContaCosto#">
	
		<!--- Reportes de Compras --->
		<input type="hidden" name="hayRepCotProveedoresLocal" value="#hayRepCotProveedoresLocal#">
		<input type="hidden" name="hayRepCotProveedoresImportacion" value="#hayRepCotProveedoresImportacion#">
		<input type="hidden" name="hayRepCotProcesoLocal" value="#hayRepCotProcesoLocal#">
		<input type="hidden" name="hayRepCotProcesoImportacion" value="#hayRepCotProcesoImportacion#">

		<!--- Roles de Solicitante y Comprador --->
		<input type="hidden" name="hayRolSolic" value="#hayRolSolic#">	
		<input type="hidden" name="hayRolComprador" value="#hayRolComprador#">	
		
		<input type="hidden" name="hayRecurrentes" value="#hayRecurrentes#">
		
		<!--- Parámetros nuevo para Leyenda de Balance General y Estado de Resultados --->
		<input type="hidden" name="hayLeyenda" value="#hayLeyenda#">
        <input type="hidden" name="hayLeyendaCxC" value="#hayLeyendaCxC#">
		<input type="hidden" name="hayAgregarDesc" value="#hayAgregarDesc#">
        <input type="hidden" name="hayImportaConCF" value="#hayImportaConCF#">
        <input type="hidden" name="hayMBAsientoDifCam" value="#hayMBAsientoDifCam#">
        
		
		<!--- PARAMETRO DE MOSTRAR ASIENTO EN FORMA DETALLADA --->
		<input type="hidden" name="hayVerAstDet" value="#ValorVerAstDet#">		

		<!--- PARAMETRO PARA APLICAR RETIROS AUTOMATICAMENTE --->
		<input type="hidden" name="hayRetAuto" value="#ValorRetAuto#">
		
		<!--- PARAMETRO PARA TRANSACCION PEAJE --->
		<input type="hidden" name="hayTipoTransPeaje" value="#ValorTipoTransPeaje#">
		<input type="hidden" name="hayCuentaMovPeaje" value="#ValorCuentadePeaje#">	
			
	</cfoutput>
	</form>
<cfoutput>	
<script language="javascript" type="text/javascript">
	cantDig(document.form1.chkRCDND);
</script>

<script language="javascript1.2" type="text/javascript">
	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction(){
		window.cuentasIframe1.RetornaCuenta();
		window.cuentasIframe2.RetornaCuenta();
		///window.cuentasIframe3.RetornaCuenta();
		return true;
	}
			
</script>
</cfoutput>
<cfoutput>
<cf_qforms>
<script language="javascript" type="text/javascript">
	function limpiarCuenta(){		   
	objForm.CBid.obj.value="";
    objForm.CBcodigo.obj.value="";
	objForm.CBdescripcion.obj.value="";
	}
</script>
</cfoutput>
