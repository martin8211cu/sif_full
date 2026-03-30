

<cfif isDefined("url.RHCMid") and len(trim(url.RHCMid)) NEQ 0>
	<cfset form.RHCMid = url.RHCMid>
</cfif>
	
	<!--- Salida Anticipada --->
	<cfquery name="rs6" datasource="#session.DSN#">
		select RHIid, RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 6
			
	</cfquery>
	
	<!--- Salida Tardia --->
	<cfquery name="rs7" datasource="#session.DSN#">
		select RHIid, RHIid,RHIjustificacion as justificacion, RHIjustificada as justificada
		from RHInconsistencias 
		where  RHCMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCMid#">
			and RHItipoinconsistencia = 7
			
	</cfquery>
	<!----==================== TRADUCCION =================---->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Grabar"
		Default="Grabar"
		returnvariable="BTN_Grabar"/>	

	
	<form name="form1" action="DetalleInconsistenciasJsemanales-sql.cfm" method="post">
	<input name="RHCMid" type="hidden" value="<cfoutput>#form.RHCMid#</cfoutput>">
	<table width="100%">
		<tr bordercolor="#CCCCCC" style="background-color:#F5F5F5 ">
			<td width="30%"	align="center"><strong><cf_translate key="LB_Inconsistencia">Inconsistencia</cf_translate></strong></td>
			<td width="40%"	align="center"><strong><cf_translate key="LB_Justificacion">Justificación</cf_translate></strong></td>
			<td width="15%"	align="center"><strong><cf_translate key="LB_Justificar">Justificar</cf_translate></strong></td>
			
		</tr>
		<cfif isDefined("rs6")and rs6.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center"><cf_translate key="LB_Horas_Incompletas_de_Jornada_Semanal">Horas Incompletas de Jornada Semanal</cf_translate><input name="RHIid6" type="hidden" value="<cfoutput>#rs6.RHIid#</cfoutput>"></td>
			<td align="center"><textarea id="justificacion6"  name="justificacion6" cols="40" rows="2"><cfoutput>#rs6.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check6" type="checkbox" value="0"  <cfif rs6.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		<cfif isDefined("rs7")and rs7.RecordCount NEQ 0 ><cfoutput>
		<tr>
			<td align="center"><cf_translate key="LB_Horas_en_Exceso_de_Jornada_Semanal">Horas en Exceso de Jornada Semanal</cf_translate><input name="RHIid7" type="hidden" value="<cfoutput>#rs7.RHIid#</cfoutput>"></td>
			<td align="center"><textarea id="justificacion7" name="justificacion7" cols="40" rows="2"><cfoutput>#rs7.justificacion#</cfoutput></textarea></td>
			<td align="center"><input name="check7" type="checkbox" value="0"  <cfif rs7.justificada EQ 1>Checked</cfif>></td>
		</tr>
		</cfoutput> </cfif>
		
		<cfif (not isDefined("rs6")or rs6.RecordCount EQ 0)and (not isDefined("rs7")or rs7.RecordCount EQ 0)>
		<tr>
			<td colspan="3" align="center"><cf_translate key="LB_No_hay_Inconsistencias">---No Hay Inconsistencias---</cf_translate></td>
		</tr>
		<cfelse>
		<tr>
			<cfoutput><td colspan="3" align="center"><input name="Grabar" type="submit" value="#BTN_Grabar#"/></td></cfoutput>
		</tr>
		</cfif>
	</table>	
	</form>
