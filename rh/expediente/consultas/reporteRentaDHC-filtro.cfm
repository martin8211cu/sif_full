<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Reporte_de_Renta_DHC"
	Default="Reporte de Renta (DHC)"
	returnvariable="LB_Reporte_de_Renta_DHC"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tablas_de_Renta"
	Default="Tablas de Renta"
	returnvariable="LB_Tablas_de_Renta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_No_se_encontro_Tabla_de_Renta_vigente"
	Default="Error. No se encontr&oacute; Tabla de Renta vigente."
	returnvariable="MSG_ERROR_EIRid"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Reporte"
	Default="Reporte"
	xmlFile="/rh/generales.xml"
	returnvariable="BTN_Reporte"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Seleccionar"
	Default="Seleccionar"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Seleccionar"/>


<cf_templateheader title="#LB_Reporte_de_Renta_DHC#">
	<cf_web_portlet_start titulo="#LB_Reporte_de_Renta_DHC#">
	<cfquery name="rsIRc" datasource="#session.dsn#">
		select Pvalor as IRcodigo
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#"> 
		and Pcodigo = 30
	</cfquery>
	<!---
	<cfquery name="rsEIRidsaplicados" datasource="#session.dsn#">
		select EIRid 
	  	from RHLiquidacionRenta
	  	where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarDEid#">
	  	and Estado = 10
	</cfquery>
	--->
	<cfquery name="rsIRs" datasource="sifcontrol">
		select a.EIRid, 
			<cf_dbfunction name="date_part" args="mm,a.EIRdesde"> as mesDesde,
			<!--- datepart(mm,a.EIRdesde) as mesDesde, --->
			<cf_dbfunction name="date_part" args="yy,a.EIRdesde"> as periodoDesde,
			<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
			<cf_dbfunction name="date_part" args="mm,a.EIRhasta"> as mesHasta,
			<!--- datepart(mm,a.EIRhasta) as mesHasta,  --->
			<cf_dbfunction name="date_part" args="yy,a.EIRhasta"> as periodoHasta,
			<!--- datepart(yy,a.EIRhasta) as periodoHasta,  --->
			b.IRcodigo, 
			b.IRdescripcion, a.EIRdesde, a.EIRhasta
		from EImpuestoRenta a
			inner join ImpuestoRenta b
			on a.IRcodigo = b.IRcodigo
		where a.IRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIRc.IRcodigo#">
		  <!---and not <cf_whereInList Column="a.EIRid" ValueList="#ValueList(rsEIRidsaplicados.EIRid)#" cfsqltype="cf_sql_numeric">--->
		order by a.EIRdesde, a.EIRhasta
	</cfquery>
	<cfif rsIRs.recordcount eq 0>
		<cfthrow message="#MSG_ERROR_EIRid#">
	</cfif>

	<cfoutput>
	<table width="100%" align="left" border="0" cellpadding="3" cellspacing="0">	
		<form name="filtro" action="reporteRentaDHC.cfm" method="post" style="margin:0;">
			<tr>
				<td width="35%" align="right" nowrap><strong>#LB_Tablas_de_Renta#:</strong>&nbsp;</td>
				<td width="65%" align="left">
					<select name="EIRid" >
						<option value="">- #LB_Seleccionar# - </option>
						<cfloop query="rsIRs">
							<option value="#rsIRs.EIRid#" <cfif isdefined("form.EIRid") and form.EIRid eq rsIRs.EIRid>selected</cfif>>#rsIRs.IRcodigo#-#rsIRs.IRdescripcion# (#LSDateFormat(rsIRs.EIRdesde,'dd/mm/yyyy')#-#LSDateFormat(rsIRs.EIRhasta,'dd/mm/yyyy')#)</option>
						</cfloop>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><input type="submit" class="btnFiltrar" name="Reporte" value="#BTN_Reporte#" /></td>
			</tr>
		</form>
	</table>
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>	
	