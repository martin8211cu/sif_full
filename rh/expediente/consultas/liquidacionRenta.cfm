<!--- Modificado en Notepad --->
<!---/-------------------------------------------------------------------------------------
------------------------------CONSULTA DE LIQUIDACION DE RENTA-----------------------------
--------------------------------------------------------------------------------------/--->
<cfsilent>
<!---/-------------------------------------------------------------------------------------
------------------------------TRADUCCIONES UTILIZADAS EN LA PANTALLA-----------------------
--------------------------------------------------------------------------------------/--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Consulta_de_Renta_Liquidacion"
	Default="Consulta de Renta (Liquidaci&oacute;n)"
	returnvariable="LB_Consulta_de_Renta_Liquidacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ERROR_DEID"
	Default="Error. No se encontr&oacute; Vigencias de Renta Sin Aplicar!"
	returnvariable="MSG_ERROR_EIRid"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ayuda"
	Default="Ayuda"
	returnvariable="LB_Ayuda"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Este_reporte_muestra_un_listado___"
	Default="Este reporte muestra un listado de la liquidación de Renta
			de los empleados de la empresa, revisada por cada empleado."
	returnvariable="MSG_TxtAyuda"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Filtro"
	Default="Filtro"
	returnvariable="LB_Filtro"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Vigencias_de_Renta_sin_Liquidar"
	Default="Vigencias de Renta sin Liquidar"
	returnvariable="LB_Vigencias_de_Renta_sin_Liquidar"/>
<!---/-------------------------------------------------------------------------------------
------------------------------OBTIENE LAS TABLAS DE RENTA VIGENTES-------------------------
--------------------------------------------------------------------------------------/--->
<cfquery name="rsIRc" datasource="#session.dsn#">
	select Pvalor as IRcodigo
	from RHParametros 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#"> 
	and Pcodigo = 30
</cfquery>
<cfquery name="rsIRs" datasource="sifcontrol">
	select a.EIRid, 
		<cf_dbfunction name="date_part"   args="mm, a.EIRdesde"> as mesDesde,
		<!--- datepart(mm,a.EIRdesde) as mesDesde,  --->
		<cf_dbfunction name="date_part"   args="yy, a.EIRdesde"> as periodoDesde,
		<!--- datepart(yy,a.EIRdesde) as periodoDesde,  --->
		<cf_dbfunction name="date_part"   args="mm, a.EIRhasta"> as mesHasta,
		<!--- datepart(mm,a.EIRhasta) as mesHasta, ---> 
		<cf_dbfunction name="date_part"   args="yy, a.EIRhasta"> as periodoHasta,
		<!--- datepart(yy,a.EIRhasta) as periodoHasta,  --->		
		b.IRcodigo, b.IRdescripcion, a.EIRdesde, a.EIRhasta
	from EImpuestoRenta a
		inner join ImpuestoRenta b
		on a.IRcodigo = b.IRcodigo
	where rtrim(a.IRcodigo) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIRc.IRcodigo#">
</cfquery>
<cfif rsIRs.recordcount eq 0>
	<cfthrow message="#MSG_ERROR_EIRid#">
</cfif>
<cfif (isdefined("Url.EIRid") and len(trim(Url.EIRid)) gt 0 and Url.EIRid gt 0)>
	<cfset Form.EIRid = Url.EIRid>
</cfif>
<cfif not (isdefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0 and Form.EIRid gt 0)>
	<cfset Form.EIRid = rsIRs.EIRid>
</cfif>
</cfsilent>
<cf_templateheader title="#LB_Consulta_de_Renta_Liquidacion#">
	<cf_web_portlet_start titulo="#LB_Consulta_de_Renta_Liquidacion#">
	<!---/-------------------------------------------------------------------------------------
	-------------------------FILTRO DE TABLAS VIGENTES-----------------------------------------
	--------------------------------------------------------------------------------------/--->
	<cfoutput>
		<br>
		<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td valign="top">
			<cf_web_portlet_start titulo="#LB_Ayuda#">
				<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">	
					<tr>
						<td>
							#MSG_TxtAyuda#
						</td>
					</tr>
				</table>
			<cf_web_portlet_end>
		</td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		<td valign="top">
			<cf_web_portlet_start>
				<form name="filtro1" action="liquidacionRentaSql.cfm" method="post" style="margin:0;">
					<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0">	
						<tr><td class="tituloListas">&nbsp;</td></tr>
						<tr>
							<td class="tituloListas" align="left" nowrap><strong>#LB_Vigencias_de_Renta_sin_Liquidar# :</strong>&nbsp;</td>
						</tr>
						<tr>
							<td class="tituloListas" align="left">
								<select name="EIRid">
									<cfloop query="rsIRs">
										<option value="#rsIRs.EIRid#" <cfif isdefined("form.EIRid") and form.EIRid eq rsIRs.EIRid>selected</cfif>>#rsIRs.IRcodigo#-#rsIRs.IRdescripcion# (#LSDateFormat(rsIRs.EIRdesde,'dd/mm/yyyy')#-#LSDateFormat(rsIRs.EIRhasta,'dd/mm/yyyy')#)</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr><td class="tituloListas">&nbsp;</td></tr>
						<tr>
							<td class="tituloListas">
								<cf_botones values="Filtrar">
							</td>
						</tr>
						<tr><td class="tituloListas">&nbsp;</td></tr>
					</table>
				</form>
			<cf_web_portlet_end>
		</td>
		<td>&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr><td colspan="5">&nbsp;</td></tr>
		</table>
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>