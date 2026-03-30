<cfquery name="rsRHListaEvalDes" datasource="#session.DSN#">
	select   RHLEobservacion
	from RHListaEvalDes
	where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
	and DEid =     <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
</cfquery>

<cfquery name="rsRHEEvaluacionDes" datasource="#session.DSN#">
	select RHEEid, RHEEdescripcion, RHEEfdesde as inicio, RHEEfhasta as fin
	from RHEEvaluacionDes
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHEEid#">
</cfquery>
<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">

<cfset Empleado = sec.getUsuarioByRef(url.DEid, session.EcodigoSDC, 'DatosEmpleado')>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>
<html>
<head>
<title><cfoutput>#LB_RecursosHumanos#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<p>&nbsp;</p>
<cf_templatecss>
	<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
		<tr>
			<td align="right" nowrap>
				<input type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="imprimir();">
			</td>
		</tr>
		<tr><td><hr></td></tr>
	</table>
 	<cfoutput>
	<table width="100%" border="0">
		<tr>
			<td colspan="3" align="center" bgcolor="##CCCCCC"><strong><cf_translate  key="LB_Evaluacion">Evaluación</cf_translate></strong></td>
		</tr>      
		<tr>
			<td colspan="3" >
			#rsRHEEvaluacionDes.RHEEdescripcion#  
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<strong><cf_translate  key="LB_Inicio">Inicio</cf_translate></strong>
			</td> 
			<td>
				<cf_locale name="date" value="#rsRHEEvaluacionDes.inicio#"/>
			</td> 
		</tr>
		<tr>
			<td colspan="2">
				<strong><cf_translate  key="LB_Finalizacion">Finalización</cf_translate></strong>
			</td>
			<td>
			<cf_locale name="date" value="#rsRHEEvaluacionDes.fin#"/>
			</td>
		</tr>
		<tr>
			<td colspan="2" >
				<strong><cf_translate  key="LB_Empleado">Empleado</cf_translate></strong>
			</td>
			<td>
				#Empleado.PNOMBRE#&nbsp;&nbsp;#Empleado.PAPELLIDO1#&nbsp;&nbsp;#Empleado.PAPELLIDO2#
			</td>
		</tr>
		<tr>
		<td colspan="3" align="center" bgcolor="##CCCCCC"><strong><cf_translate  key="LB_PlanDeAccionATomar">Plan de acción a tomar</cf_translate></strong></td>
		</tr>  	  
		<tr>
			<td  colspan="3">
				<cfif not isdefined("rsRHListaEvalDes") or len(trim(rsRHListaEvalDes.RHLEobservacion)) gt 0>
				#rsRHListaEvalDes.RHLEobservacion#
				<cfelse>
				<cf_translate  key="LB_NoSeHaDefinidoUnPlanDeAccion">No se ha definido un plan de acción</cf_translate>
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>
	</table>
	</cfoutput>
</body>
</html>
<script language="javascript1.2" type="text/javascript">
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
</script>
