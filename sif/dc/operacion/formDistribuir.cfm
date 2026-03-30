<cfif isdefined("Form.Cambio")>
  <cfset modo="CAMBIO">
  <cfelse>
  <cfif not isdefined("Form.modo")>
    <cfset modo="ALTA">
    <cfelseif #Form.modo# EQ "CAMBIO">
    <cfset modo="CAMBIO">
    <cfelse>
    <cfset modo="ALTA">
  </cfif>
</cfif>

<cfif isdefined(url.IDgd) and url.IDgd neq "" and not isdefined("Form.IDgd")>
	<cfset Form.IDgd = #url.IDgd#>
</cfif>

<cfquery datasource="#Session.DSN#" name="rsGrpDist">
select IDgd, DCdescripcion 
from DCGDistribucion 
where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDgd#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Edescripcion from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsget_periodo">
	select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 30
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsget_mes">
	select ltrim(rtrim(Pvalor)) as Pvalor from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Pcodigo = 40
</cfquery>	

<!--- Obtiene el Tipo de Distribución 
	- En caso de ser tipo 5 se invoca a la distribucion por conductores
	- El Resto de los Tipos invocan a la distribución Actual
--->
<cfquery datasource="#Session.DSN#" name="rsDistCond">
Select IDdistribucion
from DCDistribucion
where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDgd#">
  and Tipo = 5
</cfquery>
<cfif rsDistCond.recordcount gt 0>
	<cfset DistxCond = 1>
	<cfset LvarIDdistribucion=rsDistCond.IDdistribucion>
</cfif>

	
<!---<cfinclude template="Funciones.cfm">--->
<cfset periodo="#rsget_periodo.Pvalor#">
<cfset mes="#rsget_mes.Pvalor#">

<form method="post" name="form1" action="SQLDistribuir.cfm">
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>			
			<td width="40%" align="right" style="padding-right: 20px" nowrap>
				<b>Período Contable</b>
			</td>
			<td align="left" style="padding-right: 10px">
				<cfoutput>#periodo#</cfoutput>
				<input type="hidden" name="periodo" value="<cfoutput>#periodo#</cfoutput>">
			</td>
			<td align="right" style="padding-left: 10px; padding-right: 20px" nowrap>
				<b>Mes Contable</b>
			</td>
			<td width="40%" align="left">
				<cfoutput>#mes#</cfoutput>
				<input type="hidden" name="mes" value="<cfoutput>#mes#</cfoutput>">
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<br/>
				<cfif isdefined("Form.showMessage")>
					<script language="JavaScript" type="text/javascript">
						alert("Proceso de Distribución Finalizado Exitosamente");
					</script>
				</cfif>
				¿Desea realizar el proceso de distribución para el grupo: <cfoutput>#rsGrpDist.DCdescripcion#</cfoutput> ? 
			</td>
		</tr>
		<tr>
			<td align="center" colspan="4">
				<br/>
				<cfoutput>
				<input type="hidden" name="IDgd" value="#rsGrpDist.IDgd#">
				<cfif isdefined("LvarIDdistribucion") and LvarIDdistribucion neq "">
					<input type="hidden" name="IDdistribucion" value="#LvarIDdistribucion#">
				</cfif>
				</cfoutput>
				<cfif isdefined("DistxCond") and DistxCond eq 1>

					<p>
					<table align="center" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="middle">
							<input type="checkbox" name="chkSimular" value="1">
						</td>			
						<td>Exportar Simulación a Excel</td>
					</tr>
					</table>
					</p>
					<input type="hidden" name="Simular" value="S">
					<input type="button" name="btnSimular" value="Simular Distribución" onclick="javascript:if (confirm('¿Está seguro de efectuar la simulación de la distribucion?')){ CambiarDireccionamiento('S'); }"/>
					<input type="button" name="btnRegresar" value="Regresar" onclick="javascript:return Regresar();"/>
					<input type="button" name="btnCierre" value="Realizar Distribución" onclick="javascript:if (confirm('¿Está seguro de efectuar el proceso de distribucion?')){ CambiarDireccionamiento('D'); };"/>
				<cfelse>
					<input type="submit" name="btnSimular" value="Simular Distribución" onclick="javascript:return confirm('¿Está seguro de efectuar la simulación de la distribucion?');"/>
					<input type="button" name="btnRegresar" value="Regresar" onclick="javascript:return Regresar();"/>
					<input type="submit" name="btnCierre" value="Realizar Distribución" onclick="javascript:return confirm('¿Está seguro de efectuar el proceso de distribucion?');"/>
				</cfif>
			</td>
		</tr>
	</table>
</form>
 

<script>
function Regresar()
{
	document.location = '../catalogos/formgrupos.cfm?IDgd=<cfoutput>#form.IDgd#</cfoutput>';	
}
function CambiarDireccionamiento(tipo)
{
	if (tipo == 'D'){
		document.form1.Simular.value = 'N';
	}
	document.form1.action = 'SQLDistribuirConductor.cfm';
	document.form1.submit();
}
</script>
