

<cfif isDefined("url.RHCMid") and len(trim(url.RHCMid)) NEQ 0>
	<cfset form.RHCMid = url.RHCMid>
</cfif>
	<!--- <cfdump var="#form#"> --->
	<!--- Omision de Marca de Entrada --->
	<cfquery name="rs0" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 0
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Omision de Marca de Salida --->
	<cfquery name="rs1" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 1
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Dia de Extra Ausencia --->
	<cfquery name="rs2" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 2
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Dia Ausencia--->
	<cfquery name="rs3" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 3
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Entrada Anticipada --->
	<cfquery name="rs4" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 4
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Llegada Tardia --->
	<cfquery name="rs5" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 5
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Salida Anticipada --->
	<cfquery name="rs6" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 6
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	
	<!--- Salida Tardia --->
	<cfquery name="rs7" datasource="#session.DSN#">
		select RHIid, RHIid,RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 7
			<!--- and RHIjustificada = 0 --->
	</cfquery>
	<!---  <cfdump  label="rs0" var="#rs0#">
	<cfdump  label="rs1" var="#rs1#">
	<cfdump  label="rs2" var="#rs2#">
	<cfdump  label="rs3" var="#rs3#">
	<cfdump  label="rs4" var="#rs4#">
	<cfdump  label="rs5" var="#rs5#">
	<cfdump  label="rs6" var="#rs6#">
	<cfdump  label="rs7" var="#rs7#"> --->
	
	<form name="form1" action="DetalleInconsistencias-sql.cfm" method="post">
	<input name="RHCMid" type="hidden" value="<cfoutput>#form.RHCMid#</cfoutput>">
	<table width="100%">
		<tr bordercolor="#CCCCCC" style="background-color:#F5F5F5 ">
			<td width="30%"	align="center"><strong>Inconsistencia</strong></td>
			<td width="40%"	align="center"><strong>Justificación</strong></td>
			<td width="15%"	align="center"><strong>Justificar</strong></td>
			
		</tr>
		<cfif isDefined("rs0")and rs0.RecordCount NEQ 0><cfoutput>
		<tr>
			<td align="center">Omisión de Marca de Entrada <input name="RHIid0" type="hidden" value="<cfoutput>#rs0.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion0" rows="2"><cfoutput>#rs0.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check0" type="checkbox" value="0"  <cfif rs0.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs1")and rs1.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center">Omision de Marca de Salida<input name="RHIid1" type="hidden" value="<cfoutput>#rs1.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion1" cols="40" rows="2"><cfoutput>#rs1.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check1" type="checkbox" value="0"  <cfif rs1.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		
		<cfif isDefined("rs2")and rs2.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center">Dia de Extra<input name="RHIid2" type="hidden" value="<cfoutput>#rs2.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion2" cols="40" rows="2"><cfoutput>#rs2.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check2" type="checkbox" value="0"  <cfif rs2.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs3")and rs3.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center">Dia Ausencia<input name="RHIid3" type="hidden" value="<cfoutput>#rs3.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion3" cols="40" rows="2"><cfoutput>#rs3.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check3" type="checkbox" value="0"   <cfif rs3.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs4")and rs4.RecordCount NEQ 0 ><cfoutput>
		<tr>
			
			<td align="center">Llegada Anticipada<input name="RHIid4" type="hidden" value="<cfoutput>#rs4.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion4" cols="40" rows="2"><cfoutput>#rs4.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check4" type="checkbox" value="0"   <cfif rs4.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs5")and rs5.RecordCount NEQ 0 ><cfoutput>
		<tr>
			
			<td align="center">Llegada Tardía<input name="RHIid5" type="hidden" value="<cfoutput>#rs5.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion5" cols="40" rows="2"><cfoutput>#rs5.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check5" type="checkbox" value="0"  <cfif rs5.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs6")and rs6.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center">Salida Anticipada<input name="RHIid6" type="hidden" value="<cfoutput>#rs6.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion6" cols="40" rows="2"><cfoutput>#rs6.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check6" type="checkbox" value="0"  <cfif rs6.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs7")and rs7.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center">Salida Tarde<input name="RHIid7" type="hidden" value="<cfoutput>#rs7.RHIid#</cfoutput>"></td>
			<td align="center"><textarea name="justificacion7" cols="40" rows="2"><cfoutput>#rs7.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check7" type="checkbox" value="0"  <cfif rs7.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif (isDefined("rs0")and rs0.RecordCount NEQ 0)or (isDefined("rs1")and rs1.RecordCount NEQ 0)or 
			(isDefined("rs2")and rs2.RecordCount NEQ 0)or (isDefined("rs3")and rs3.RecordCount NEQ 0)or 
			(isDefined("rs4")and rs4.RecordCount NEQ 0)or (isDefined("rs5")and rs5.RecordCount NEQ 0)or
			(isDefined("rs6")and rs6.RecordCount NEQ 0)or (isDefined("rs7")and rs7.RecordCount NEQ 0)>
		<tr>
			<td colspan="3" align="center"><input name="btnGrabar" type="submit" value="Grabar"></td>
		</tr>
		<cfelse>
		<tr>
			<td colspan="3" align="center">---No Hay Inconsistencias---</td>
		</tr>
		</cfif>
	</table>	
	</form>
