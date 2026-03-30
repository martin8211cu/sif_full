<cfsetting requesttimeout="#3600*24#">
<!--- PARÁMETROS REQUERIDOS --->
<cfparam name="url.ERNid" type="numeric">

<!--- Consultas --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
	select RCNid
	from ERNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>
<!--- RCalculoNomina --->
<cfquery name="RCalculoNomina" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERNomina.RCNid#">
</cfquery>

<cfset Titulo = "">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_EnviandoNotificacionDePagoSMS">Enviando Notificaci&oacute;n de Pago SMS</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style>
.cajasinbordeb {
	border: 0px none;
	background-color: #FFFFFF;
}
</style>
</head>

<body>

<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td nowrap><cf_translate  key="LB_EnviandoNotificacionDePagoMedianteSMS">Enviando Notificaci&oacute;n de Pago mediante SMS</cf_translate></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><table width="100%" height="50%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td id="td1" width="1%" height="21" bgcolor="#0099FF" ></td>
    <td id="td2" width = "100%" height="21" ></td>
	<td id="td1" width="1%" height="21" ><input type="text" name="txt1" id="txt1" value="1%" size="3" class="cajasinbordeb"></td>
  </tr>
</table>
&nbsp;</td>
  </tr>
<!---   <tr>
    <td>Hora de Inicio: <cfoutput>#Now()#</cfoutput></td>
  </tr> --->
</table>

<script language="javascript1.4" type="text/javascript">
	function aumentarStatus(strValor){
		var td1 = document.getElementById("td1");
		var txt1 = document.getElementById("txt1");
		td1.width = strValor;
		txt1.value = strValor;
	}
</script>

<cfflush>

<cfquery name="rsPlanilla" datasource="#Session.DSN#">
	select a.RCNid, b.DEid, b.DEemail, b.DEtelefono2 as celular
	from SalarioEmpleado a, DatosEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERNomina.RCNid#">
		and b.DEid = a.DEid
</cfquery>

<cfinclude template="EnviarEmails-funciones.cfm">

<cfloop query="rsPlanilla">
	<cfif len(trim(rsPlanilla.celular))>
	
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ElSalarioCorrespondienteAlPeriodoDel"
		Default="El salario correspondiente al periodo del"
		returnvariable="LB_ElSalarioCorrespondienteAlPeriodoDel"/> 

		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Al"
		Default="al"
		returnvariable="LB_Al"/> 	
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_LeHaSidoDepositado"
		Default="le ha sido depositado"
		returnvariable="LB_LeHaSidoDepositado"/> 	
		
		
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_DepositoDeSalario"
		Default="Deposito de Salario"
		returnvariable="LB_DepositoDeSalario"/> 
	
		<cfset info = "#LB_ElSalarioCorrespondienteAlPeriodoDel# #LSDateFormat(RCalculoNomina.RCdesde,'dd/mm/yyyy')# #LB_Al# #LSDateFormat(RCalculoNomina.RChasta,'dd/mm/yyyy')# #LB_LeHaSidoDepositado#" >
		<cfquery datasource="asp">
			insert into SMS ( SScodigo, SMcodigo, asunto, para, texto, fecha_creado, BMfecha, BMUsucodigo )
			values ( 'RH', 
					 'reppag',
					 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#session.Enombre#: #LB_DepositoDeSalario#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#rsPlanilla.celular#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar"   value="#info#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#"> )
		</cfquery>
	</cfif>

	<cfoutput>
	<script language="javascript1.4" type="text/javascript">
		aumentarStatus("#iif(Round(CurrentRow*100/RecordCount) gt 0,Round(CurrentRow*100/RecordCount),1)#%");
	</script>
	</cfoutput>
	<cfflush>
</cfloop>


<table width="50%"  border="0" align="center" cellpadding="0" cellspacing="0">
  <!--- <tr>
    <td>Hora de Fin: <cfoutput>#Now()#</cfoutput></td>
  </tr> --->
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td><cf_translate  key="LB_ProcesoCompletadoConExito">Proceso Completado con Éxito !</cf_translate></td>
  </tr>
</table>

</body>
</html>

<script language="javascript1.4" type="text/javascript">
	window.close();
</script>