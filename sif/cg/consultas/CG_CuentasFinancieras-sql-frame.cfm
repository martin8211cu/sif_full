<!--- 
PROCESANDO LA FECHA 

PARA QUE LA HORA DE LA FECHA INICIAL SEA 00:00:00
Y LA HORA DE LA FECHA FINAL SEA  23:59:59
--->

<cfset diaini = Mid(url.fechaini,1,2)>
<cfset mesini = Mid(url.fechaini,4,2)>	
<cfset anioini = Mid(url.fechaini,7,4)>

<cfset diafin = Mid(url.fechafin,1,2)>
<cfset mesfin = Mid(url.fechafin,4,2)>	
<cfset aniofin = Mid(url.fechafin,7,4)>

<CFSET fechaini = CreateDateTime(anioini, mesini,diaini, 00,00,0)>
<CFSET fechafin = CreateDateTime(aniofin, mesfin,diafin, 23,59,59)>


<cfquery name="rsReporte" datasource="#session.DSN#">

	select a.CFformato,a.CFdescripcion,BMUfechaAlta
	from CFinanciera a
	where a.CFdescripcionF is null
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.BMUfechaAlta  between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaini#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechafin#">
    and a.CFformato != Cmayor 
	and a.CFmovimiento = 'S'	
	order by a.BMUfechaAlta,a.CFformato
</cfquery>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion 
	from Empresas
 	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfif rsReporte.recordcount gt 0>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	    <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
			isLink = False 
			typeReport = #typeRep#
			fileName = "cg.catalogos.consultas.detalleCatalogo"/>
	<cfelse>
		<cfreport format="#URL.formato#" template= "CG_CuentasFinancieras.cfr" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edesc" value="#rsEmpresa.Edescripcion#">
			<cfreportparam name="fechaini" value="#fechaini#">
			<cfreportparam name="fechafin" value="#fechafin#">
		</cfreport>
	</cfif>
<cfelse>
		<cf_templatecss>
		<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
			<tr>
				<td align="right" nowrap>
					<input type="button"  id="Regresar" name="Regresar" value="Regresar" onClick="regresar();">
				</td>
			</tr>
			<tr><td><hr></td></tr>
			<tr>
				<td align="center">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td align="center">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td align="center">&nbsp;
					
				</td>
			</tr>
			<tr>
				<td align="center">&nbsp;
					
				</td>
			</tr>									
			<tr>
				<td align="center">
				<b><font style="font-size:14px" >Para este rango de fechas, no hay información para mostrar...</font></b>
				</td>
			</tr>
		</table>
		<script language="javascript1.2" type="text/javascript">
			function regresar() {
				parent.document.location.href="CG_CuentasFinancieras.cfm";
			}
		</script>	

</cfif>

