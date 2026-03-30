
	<cfif isdefined("Session.RolActual") and Session.RolActual eq 6>
		<cfset monitoreo_modulo="EDU EST">
		<cfinclude template="../monitoreo.cfm">
	<cfelseif isdefined("Session.RolActual") and Session.RolActual eq 7>
		<cfset monitoreo_modulo="EDU RES">
		<cfinclude template="../monitoreo.cfm">
	</cfif>
	
	<cfinclude template="commonDocencia.cfm"> 
	<cfset sbInitFromSession("cboSimple", "0",false)>
	<cfparam name="form.chkSinBlancos" default="">
	<cfif isdefined("url.N")>
	  <cfset form.cboNivel = url.N>
	  <cfset form.cboAlumno1 = url.E>
	  <cfset form.cboCurso1 = url.C>
	  <cfset form.cboPeriodo1 = url.P>
	<cfelse>
	  <cfparam name="Form.cboAlumno" default="-999">
	  <cfparam name="Form.cboCurso"  default="-1">
	  <cfparam name="Form.cboPeriodo" default="-1">
	  <cfscript>
		sbInitFromSession("cboAlumno1", form.cboAlumno,false);
		sbInitFromSession("cboCurso1", form.cboCurso,false);
		sbInitFromSession("cboPeriodo1", form.cboPeriodo,false);
		sbInitFromSession("cboNivel", "3",false);
	  </cfscript>
	</cfif>
	
	<cfset Form.cboAlumno = Form.cboAlumno1>
	<cfset Form.cboCurso = Form.cboCurso1>
	<cfset Form.cboPeriodo = Form.cboPeriodo1>
	
	<cfset LvarPeriodo=form.cboPeriodo1>
	<cfinclude template="qrysAlumnoCursoPeriodo.cfm">
	<cfif LvarPeriodo eq -1>
	  <cfset form.cboPeriodo1=LvarPeriodo>
	</cfif>
	
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
	<head>
	<title>Reporte de Progreso</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../css/edu.css" rel="stylesheet" type="text/css">
	<style type="text/css">
	<!--
	.CeldaHdr {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 10;
		font-weight:normal;
		color: #FFFFFF;
		background-color: #666666;
		vertical-align: middle;
		border-right: 1px solid #E6E6E6;
		margin: 0px;
		padding: 1px;
		text-align: center;
		width: 60px;
	}
	@media print {
		.CeldaHdr {color:#000000}
		input {display:none}
	}
	.LinPar {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 10px;
		font-weight: normal;
		background-color: #E6E6E6;
		text-align: right;
		vertical-align: middle;
		border: 0px solid;
		margin: 0px;
		padding: 0px;
		padding-right: 12px;
	}
	.LinImpar {
		font-family: Arial, Helvetica, sans-serif;
		font-size: 10px;
		font-weight: normal;
		background-color: #C0C0C0;
		text-align: right;
		vertical-align: middle;
		margin: 0px;
		padding: 0px;
		padding-right: 12px;
		border: 0px solid;
	}
	-->
	</style>
	<script language="JavaScript" src="/cfmx/edu/docencia/commonDocencia1_00.js"></script>
	<script language="JavaScript" type="text/JavaScript">
	function fnReload (LprmNivel, LprmCurso, LprmPeriodo)
	{
	  if (LprmNivel > 0)
	  {
		document.frmProgreso.cboNivel.value = LprmNivel;
		document.frmProgreso.cboCurso1.value = LprmCurso;
		document.frmProgreso.cboPeriodo1.value = LprmPeriodo;
	  }
	  document.frmProgreso.action="./reporteProgreso.cfm";
	  document.frmProgreso.submit();
	}
	function fnImprimir(LprmTipo)
	{
	  if (LprmTipo == 1)
	  {
		document.getElementById('DivCombos1').style.display='none';
		document.getElementById('DivCombos2').style.display='';
		fnCambiarTD(document.getElementById('TDalumno'), document.frmProgreso.cboAlumno1.options[document.frmProgreso.cboAlumno1.selectedIndex].text);
		fnCambiarTD(document.getElementById('TDcurso'), document.frmProgreso.cboCurso1.options[document.frmProgreso.cboCurso1.selectedIndex].text);
		fnCambiarTD(document.getElementById('TDperiodo'), document.frmProgreso.cboPeriodo1.options[document.frmProgreso.cboPeriodo1.selectedIndex].text);
		fnCambiarTD(document.getElementById('TDnivel'), document.frmProgreso.cboNivel.options[document.frmProgreso.cboNivel.selectedIndex].text);
		window.print();
	  }
	  else
	  {
		document.getElementById('DivCombos2').style.display='none';
		document.getElementById('DivCombos1').style.display='';
	  }
	}
	</script>
	</head>
	
	<body style="background-color: #E6E6E6">
	  <form name="frmProgreso" method="POST" action="" style="font:10px Verdana, Arial, Helvetica, sans-serif;">
	<div id="DivCombos1">
	 <table border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr>
		<td width="106">Alumno:</td>
		<td width="386"><select name="cboAlumno1"
					style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					onChange="fnReload(0);">
		<cfset LvarSelected="0">
		<cfset LvarFirst="">
		<cfoutput query="qryAlumnos">
		  <cfif currentRow eq 1><cfset LvarFirst=Codigo><cfset LvarPersonaAlumno="#Persona#"></cfif>
		  <option value="#Codigo#"
		  <cfif #form.cboAlumno1# eq #Codigo#> selected<cfset LvarSelected="1"><cfset LvarPersonaAlumno="#Persona#">
		  </cfif>>#Descripcion#</option>
		</cfoutput>              
		<cfif #LvarSelected# eq "0">
		  <cfif LvarFirst neq "">
			<cfset form.cboAlumno1=LvarFirst>
		  <cfelse>
			<cfset form.cboAlumno1="-999">
			<cfset LvarPersonaAlumno="-999">
		  </cfif>
		  
		</cfif>
		   </select>
		</td>
	  </tr>
	  <tr>
		<td width="106">Curso:</td>
		<td width="386"><select name="cboCurso1" 
					style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					onChange='fnReload(0);'>
			<option value="-1">* * TODOS LOS CURSOS * *</option>
		<cfset LvarSelected="0">
		<cfoutput query="qryCursos">
			<option value="#Codigo#"<cfif #form.cboCurso1# eq #Codigo#> selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
		</cfoutput>              
		<cfif #LvarSelected# eq "0" and form.cboCurso1 neq "-1">
		  <cfset form.cboCurso1="-1">
		</cfif>
		  </select>
		</td>
		<td width="201">&nbsp;</td>
	  </tr>
		<cfif #form.cboAlumno1# eq "-999" or #form.cboCurso1# eq "-999" or #form.cboPeriodo1# eq "-999">
		  <cfabort>
		</cfif>
	  <tr>
		<td width="106">Período:</td>
		<td width="386"><select name="cboPeriodo1" 
				style="font:10px Verdana, Arial, Helvetica, sans-serif;"
				onChange="fnReload(0);">
			<option value="-1">* * TODOS LOS PERIODOS * *</option>
		<cfset LvarSelected="0">
		<cfoutput query="qryPeriodos">
		  <option value="#Codigo#"<cfif (#form.cboPeriodo1# eq #Codigo#) > selected<cfset LvarSelected="1"></cfif>>#Descripcion#</option>
		</cfoutput>
		<cfif #LvarSelected# eq "0" and form.cboPeriodo1 neq "-1">
		  <cfset form.cboPeriodo1="-1">
		</cfif>
		</select>
		</td>
		<td width="201">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="106">Nivel de Datos:</td>
		<td width="386"><select name="cboNivel" 
					style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					onChange='fnReload(0);'>
			<option value="4" <cfif form.cboNivel eq "4">selected</cfif>>Por Curso</option>
			<option value="3" <cfif form.cboNivel eq "3">selected</cfif>>Por Periodo de Evaluacion</option>
			<option value="2" <cfif form.cboNivel eq "2">selected</cfif>>Por Concepto de Evaluacion</option>
			<option value="1" <cfif form.cboNivel eq "1">selected</cfif>>Por Evaluaciones</option>
		  </select>
		</td>
		<td width="201">
			<input name="btnImprimir" type="button" 
					onDblClick="alert('Alumno:'+document.frmProgreso.cboAlumno1.value+', Curso: '+document.frmProgreso.cboCurso1.value+', Period:'+document.frmProgreso.cboPeriodo1.value);" 
					onclick="fnImprimir(1);"
					value="Imprimir">
		</td>
	  </tr>
	  <tr>
		<td width="106">Tipo de Reporte:</td>
		<td width="386"><select name="cboSimple" 
					style="font:10px Verdana, Arial, Helvetica, sans-serif;"
					onChange='fnReload(0);'>
			<option value="0" <cfif form.cboSimple eq "0">selected</cfif>>Detalle de Calculos</option>
			<option value="1" <cfif form.cboSimple eq "1">selected</cfif>>Simple</option>
		  </select>
		</td>
	  </tr>
	  <tr>
		<td width="106"></td>
		<td><input name="chkSinBlancos" type="checkbox" class="LinPar" value="1"
				   <cfif form.chkSinBlancos eq "1">checked</cfif>
				   onClick="fnReload(0);">
		   Eliminar Líneas en Blanco
		</td>
	  </tr>
	 </table>
	</div>
	<div id="DivCombos2" style="display:none;">
	 <table border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr>
		<td width="106">Alumno:</td>
		<td width="386" id="TDalumno">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="106">Curso:</td>
		<td width="386" id="TDcurso">&nbsp;</td>
		<td width="201">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="106">Período:</td>
		<td width="386" id="TDperiodo">&nbsp;</td>
		<td width="201">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="106">Nivel de Datos:</td>
		<td width="386" id="TDnivel">&nbsp;</td>
		<td width="201">
			<input name="btnNormal" type="button" 
				  onclick="fnImprimir(0);"
				  value="Normal">
		</td>
	  </tr>
	 </table>
	</div>
	<div align="center" style="width:100%">
	<div style="font-size:14px;border:0px;font-weight: bold;">
	  REPORTE DE PROGRESO<br>
	  <cfif form.cboNivel eq "4">por Curso
	  <cfelseif form.cboNivel eq "3">por Periodo de Evaluacion
	  <cfelseif form.cboNivel eq "2">por Concepto de Evaluacion
	  <cfelseif form.cboNivel eq "1">por Evaluaciones
	  </cfif>
	</div>
	<br>
	<table cellspacing="0" cellpadding="0">
	  <thead style="display: table-header-group">
		<tr>
	  <cfif cboSimple eq "1">
		  <td class="CeldaHdr" style="width:300px">&nbsp;</td>
		<cfif form.cboNivel eq "1">
		  <td class="CeldaHdr">NOTA</td>
		  <cfset LvarBlanks=5>
		<cfelse>
		  <cfset LvarBlanks=4>
		</cfif>
		  <td class="CeldaHdr">%Ganado de Calificaciones Realizadas</td>
		  <td class="CeldaHdr">%Evaluado de Calificaciones Planeadas</td>
		  <td class="CeldaHdr">%Progreso Asignado</td>
	  <cfelseif form.cboNivel eq "1">
		  <cfset LvarBlanks=10>
		  <td class="CeldaHdr" style="width:300px">&nbsp;</td>
		  <td class="CeldaHdr">Pesos</td>
		  <td class="CeldaHdr">NOTA</td>
		  <td class="CeldaHdr">%Ganado de Calificaciones Realizadas</td>
		  <td class="CeldaHdr">%Evaluado de Calificaciones Planeadas</td>
		  <td class="CeldaHdr">%Contribucion al Progreso</td>
		  <td class="CeldaHdr">%Conceptos evaluados</td>
		  <td class="CeldaHdr">%Progreso del Periodo/Curso</td>
		  <td class="CeldaHdr">%Ajuste</td>
		  <td class="CeldaHdr">%Progreso Asignado</td>
	  <cfelseif form.cboNivel eq "2">
		  <cfset LvarBlanks=9>
		  <td class="CeldaHdr" style="width:300px">&nbsp;</td>
		  <td class="CeldaHdr">Pesos</td>
		  <td class="CeldaHdr">%Ganado de Calificaciones Realizadas</td>
		  <td class="CeldaHdr">%Evaluado de Calificaciones Planeadas</td>
		  <td class="CeldaHdr">%Contribucion al Progreso</td>
		  <td class="CeldaHdr">%Conceptos evaluados</td>
		  <td class="CeldaHdr">%Progreso del Periodo/Curso</td>
		  <td class="CeldaHdr">%Ajuste</td>
		  <td class="CeldaHdr">%Progreso Asignado</td>
	  <cfelseif form.cboNivel eq "3">
		  <cfset LvarBlanks=6>
		  <td class="CeldaHdr" style="width:300px">&nbsp;</td>
		  <td class="CeldaHdr">%Ganado de Calificaciones Realizadas</td>
		  <td class="CeldaHdr">%Evaluado de Calificaciones Planeadas</td>
		  <td class="CeldaHdr">%Progreso del Periodo/Curso</td>
		  <td class="CeldaHdr">%Ajuste</td>
		  <td class="CeldaHdr">%Progreso Asignado</td>
	  <cfelseif form.cboNivel eq "4">
		  <cfset LvarBlanks=6>
		  <td class="CeldaHdr" style="width:300px">CURSO</td>
		  <td class="CeldaHdr">%Ganado de Calificaciones Realizadas</td>
		  <td class="CeldaHdr">%Evaluado de Calificaciones Planeadas</td>
		  <td class="CeldaHdr">%Progreso del Curso</td>
		  <td class="CeldaHdr">%Ajuste</td>
		  <td class="CeldaHdr">%Progreso Asignado</td>
	  </cfif>
		</tr>
	  </thead>
	  <tbody>
	<cfquery datasource="#Session.Edu.DSN#" name="qryProgreso1">
	  exec sp_progreso
			@Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboAlumno1#">,
			@Ccodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboCurso1#">,
			@PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboPeriodo1#">,
			@Nivel    = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cboNivel#">
	</cfquery>
	<cfquery dbtype="query" name="qryProgreso">
	  select * from qryProgreso1 <cfif form.chkSinBlancos eq "1">  where ConDatos = 1</cfif>
	  order by Ecodigo, Ccodigo, PEcodigo, ECcodigo, ECcomponente
	</cfquery>
	<cfset LvarLinPar = "LinImpar">
	<cfset LvarAlumno = "">
	<cfset LvarCurso = "">
	<cfset LvarPeriodo = "">
	<cfset LvarConcepto = "">
	<cfset LvarNivel = form.cboNivel>
	<cfoutput query="qryProgreso">
	  <cfif LvarAlumno neq qryProgreso.Ecodigo>
		<cfset LvarAlumno = qryProgreso.Ecodigo>
		<cfset LvarCurso = "">
		<cfset LvarPeriodo = "">
		<cfset LvarConcepto = "">
		<cfif form.cboAlumno1 eq -1 or true>
		  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		  <tr><td class="#LvarLinPar#" style="font-size:14px;font-weight:bold;text-align:left;" colspan="#LvarBlanks#">
			<a href="javascript:fnReload(4,-1,-1);">
			  ALUMNO: #qryProgreso.Enombre#
			</a>
		  </td></tr>
		</cfif>
	  </cfif>
	  <cfif LvarNivel lte 3 and LvarCurso neq qryProgreso.Ccodigo and qryProgreso.Ccodigo neq 1e18>
		<cfset LvarCurso = qryProgreso.Ccodigo>
		<cfset LvarPeriodo = "">
		<cfset LvarConcepto = "">
		<cfif form.cboCurso1 eq -1 or true>
		  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		  <tr><td class="#LvarLinPar#" style="font-size:13px;font-weight:bold;text-align:left;" colspan="#LvarBlanks#">
			<a href="javascript:fnReload(3,#trim(qryProgreso.Ccodigo)#,-1);">
			  CURSO: #qryProgreso.Cnombre#
			</a>
		  </td></tr>
		</cfif>
	  </cfif>
	  <cfif LvarNivel lte 2 and LvarPeriodo neq qryProgreso.PEcodigo and qryProgreso.PEcodigo neq 1e18>
		<cfset LvarPeriodo = qryProgreso.PEcodigo>
		<cfset LvarConcepto = "">
		<cfif form.cboPeriodo1 eq -1 or true>
		  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		  <tr><td class="#LvarLinPar#" style="font-size:12px;font-weight:bold;text-align:left;" colspan="#LvarBlanks#">
			<a href="javascript:fnReload(2,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.PEcodigo)#);">
			  PERIODO: #qryProgreso.PEnombre#
			</a>
		  </td></tr>
		</cfif>
	  </cfif>
	  <cfif LvarNivel lte 1 and LvarConcepto neq qryProgreso.ECcodigo and qryProgreso.ECcodigo neq 1e18>
		<cfset LvarConcepto = qryProgreso.ECcodigo>
		<cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		<tr>
		  <td class="#LvarLinPar#" style="font-size:10px;font-weight:bold;text-align:left;">
			<a href="javascript:fnReload(1,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.PEcodigo)#);">
			  CONCEPTO: #qryProgreso.ECnombre#
			</a>
		  </td>
		<cfif form.cboSimple eq "1">
		  <td class="#LvarLinPar#" colspan="4">&nbsp;</td>
		<cfelse>
		  <td class="#LvarLinPar#">#qryProgreso.PesoConcepto#&nbsp;&nbsp;&nbsp;</td>
		  <td class="#LvarLinPar#" colspan="8">&nbsp;</td>
		</cfif>
		</tr>
	  </cfif>
	
	  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		<tr>
	  <cfif form.cboSimple eq "1">
		  <cfif LvarNivel eq 1>
			<cfif qryProgreso.Nivel eq 1>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.CEnombre#
			  </td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.Valor# neq "">#qryProgreso.Valor#=</cfif>#trim(qryProgreso.Nota)#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.Ganado#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.Evaluado#&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 2>
			  <cfif qryProgreso.ConDatos eq 1>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;" rowspan="2">Total Concepto:</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Ganado#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Evaluado#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Progreso#&nbsp;</td>
			</tr>
			<tr class="#LvarLinPar#">
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.ProgresoC#&nbsp;</td>
			  <cfelse>
				<cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
			  </cfif>
			<cfelseif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Resultado Periodo:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</tr>
			  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
			<tr class="CeldaHdr"><td colspan="10">&nbsp;</td></tr>
			</cfif>
		  <cfelseif LvarNivel eq 2>
			<cfif qryProgreso.Nivel eq 2>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(1,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.Ecodigo)#,#trim(qryProgreso.PEcodigo)#);">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.ECnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.ProgresoC#&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Resultado Periodo:</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</cfif>
		  <cfelseif LvarNivel eq 3>
			<cfif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(2,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.Ecodigo)#,#trim(qryProgreso.PEcodigo)#);">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.PEnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</cfif>
		  <cfelseif LvarNivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(3,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.Ecodigo)#,-1);">
				  #qryProgreso.Cnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
		  </cfif>
	  <cfelse>
		  <cfif LvarNivel eq 1>
			<cfif qryProgreso.Nivel eq 1>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.CEnombre#
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.Peso#&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.Valor# neq "">#qryProgreso.Valor#=</cfif>#trim(qryProgreso.Nota)#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.Ganado#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.Evaluado#&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 2>
			  <cfif qryProgreso.ConDatos eq 1>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;" rowspan="2">Total Concepto:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Ganado#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Evaluado#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.Progreso#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoConcepto#&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			</tr>
			<tr class="#LvarLinPar#">
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.ProgresoC#&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <cfelse>
				<cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
			  </cfif>
			<cfelseif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Resultado Periodo:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.ProgresoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoConcepto#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</tr>
			  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
			<tr class="CeldaHdr"><td colspan="10">&nbsp;</td></tr>
			</cfif>
		  <cfelseif LvarNivel eq 2>
			<cfif qryProgreso.Nivel eq 2>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(1,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.PEcodigo)#);">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.ECnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.PesoConcepto#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.ProgresoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoConcepto#&nbsp;</td>
			  <td class="#LvarLinPar#">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Resultado Periodo:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.ProgresoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoConcepto#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:3px double ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</cfif>
		  <cfelseif LvarNivel eq 3>
			<cfif qryProgreso.Nivel eq 3>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(2,#trim(qryProgreso.Ccodigo)#,#trim(qryProgreso.PEcodigo)#);">
				  &nbsp;&nbsp;&nbsp;#qryProgreso.PEnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			<cfelseif qryProgreso.Nivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">Contribucion Final Curso:</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#" style="border-top:1px solid ##333333"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
			</cfif>
		  <cfelseif LvarNivel eq 4>
			  <td class="#LvarLinPar#" style="width:300px;text-align:left;">
				<a href="javascript:fnReload(3,#trim(qryProgreso.Ccodigo)#,-1);">
				  #qryProgreso.Cnombre#
				</a>
			  </td>
			  <td class="#LvarLinPar#">#qryProgreso.GanadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#qryProgreso.EvaluadoC#&nbsp;</td>
			  <td class="#LvarLinPar#">#trim(qryProgreso.ProgresoF)#<cfif #qryProgreso.Valor# neq "">=#qryProgreso.Valor#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAjuste# neq "">#qryProgreso.ValorAjuste#<cfelse>#trim(qryProgreso.AjusteF)#</cfif>&nbsp;</td>
			  <td class="#LvarLinPar#"><cfif #qryProgreso.ValorAsignado# neq "">#qryProgreso.ValorAsignado#<cfelse>#trim(qryProgreso.ProgresoA)#</cfif>&nbsp;</td>
		  </cfif>
	  </cfif>
		</tr>
	</cfoutput>
	  <cfif LvarLinPar eq "LinImpar"><cfset LvarLinPar = "LinPar"><cfelse><cfset LvarLinPar = "LinImpar"></cfif>
		  <tr><td class="<cfoutput>#LvarLinPar#" colspan="#LvarBlanks#</cfoutput>">&nbsp;</td></tr>
	  </tbody>
	</table>
	</div>
	</form>
	</body>
	</html>
