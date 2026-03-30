<cfsetting requesttimeout="#3600*24#">
<!--- PARÁMETROS REQUERIDOS --->
<cfparam name="url.ERNid" type="numeric">

<!--- Consultas --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
	select RCNid
	from ERNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>

<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, RCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo
	and b.Ecodigo = c.Ecodigo
	and a.Mcodigo = c.Mcodigo 
	and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERNomina.RCNid#">
</cfquery>

<!--- RCalculoNomina --->
<cfquery name="rsNomina" datasource="#Session.DSN#">
	select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
	from RCalculoNomina a, TiposNomina b, CalendarioPagos c
	where a.Tcodigo = b.Tcodigo
	and a.Ecodigo = b.Ecodigo
	and a.RCNid = c.CPid
	and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERNomina.RCNid#">
</cfquery>

<!--- Empresa --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset Titulo = "">

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title><cf_translate  key="LB_EnviandoCorreos">Enviando Correos</cf_translate></title>
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
    <td><cf_translate  key="LB_EnviandoCorreos">Enviando Correos</cf_translate></td>
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
	select 	a.RCNid, b.DEid, b.DEemail,
			<cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2"> as nombre
	from SalarioEmpleado a, DatosEmpleado b
	where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsERNomina.RCNid#">
		and b.DEid = a.DEid
		and (a.SEliquido > 0 or a.SEdeducciones > 0 or a.SEincidencias > 0) <!--- (a.SEliquido != 0) --->

</cfquery>
<cfinclude template="EnviarEmailsDosTercios-funcionesImp.cfm">
<cfloop query="rsPlanilla">
	<cfset prueva=prepararCorreo(DEid, RCNid)>
</cfloop>

<cfset admin = getRHPvalor(180)>
<cfif len(trim(admin)) gt 0>
	<cfset EmailFromAdmin = Trim(getEmailFromAdmin(admin))>
<cfelse>		
	<cfset EmailFromAdmin = "">
</cfif>
<cfset dequien = Trim(getRHPvalor(190))>
<cfset Parametro170 = getRHPvalor(170)>

<cfloop query="rsPlanilla">
	<cfscript>	
		if ( len(trim(dequien)) gt 0 )
		{
			paraquien = "";
			
			if ( len(trim(Parametro170)) gt 0 and Parametro170 eq 1 )
			{
				paraquien = EmailFromAdmin;
			}
			else
			{
				if ( len(trim(DEemail)) gt 0 )
				{
					paraquien = DEemail;
				}
				else
				{
					emailJefe = getEmailFromJefe(DEid);
					if (len(trim(emailJefe)) gt 0)
					{
						paraquien = emailJefe;
					}
					else
					{
						paraquien = EmailFromAdmin;
					}
				}
			}
			mensaje = prepararCorreo(DEid, RCNid);
					
			if ( len(trim(paraquien)) gt 0 )
			{				
				enviarCorreo(dequien ,paraquien, titulo&" - (#nombre#)", mensaje);
			}
		}
	</cfscript>
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