<!--- Pasa parámetros del url al form--->
<cfif isdefined("url.fecDesde") and len(trim(url.fecDesde))>
	<cfset form.fecDesde = url.fecDesde>
</cfif>
<cfif isdefined("url.fecHasta") and len(trim(url.fecHasta))>
	<cfset form.fecHasta = url.fecHasta>
</cfif>
<!--- parametros para la forma de imprimir --->
<cfset vparams = "">
<cfif isdefined("Form.fecDesde")>
	<cfset vparams = vparams & "&fecDesde=" & form.fecDesde>
</cfif>

<cfif isdefined("Form.fecHasta")>
	<cfset vparams = vparams & "&fecHasta=" & form.fecHasta>
</cfif>

<!--- Consulta de las horas registradas por todos los usuarios en el rango de fechas definido --->
<cfquery name="rsHoras" datasource="#Session.DSN#">
	select distinct CTAcodigo, sum(CTThoras) as horas,Usucodigo
	from CTReporteTiempos AS CTR
		left outer join CTTiempos AS CTT
			on CTT.CTRcodigo = CTR.CTRcodigo
	where CTR.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CTRfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecDesde#">
	  and CTRfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecHasta#">
	group by Usuario, CTAcodigo
</cfquery>

<!--- Consulta de las Actividades del Catálogo --->
<cfquery name="rsActividades" datasource="#Session.DSN#">
	select CTAcodigo, CTAdescripcion AS Descripcion
	from CTActividades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CTAcodigo
</cfquery>
<!--- Query de Queries: Consulta las Actividades en que han sido registradas horas por los usuarios --->
<cfquery name="rsActiv" dbtype="query">
	select distinct rsActividades.CTAcodigo, rsActividades.Descripcion
	from rsActividades, rsHoras
	where rsActividades.CTAcodigo = rsHoras.CTAcodigo
	and rsHoras.horas > 0
	order by rsActividades.CTAcodigo
</cfquery>
<!--- Consulta los datos personales de los usuarios que han registrado horas --->
<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	select Usucodigo as Usuario, Papellido1 || ' ' || Papellido2 || ' ' || Pnombre as Nombre, Usucodigo
	from DatosPersonales a inner join Usuario b on a.datos_personales = b.datos_personales
	where b.Usulogin in (
		select distinct Usuario 
			from CTReporteTiempos
			where Ecodigo = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#session.Ecodigo#">
			and CTRfecha >= <cfqueryparam cfsqltype = "cf_sql_timestamp" value = "#form.fecDesde#">
			and CTRfecha <= <cfqueryparam cfsqltype = "cf_sql_timestamp" value = "#form.fecHasta#">
	)
	and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
</cfquery>

<!--- Consulta los totales por Actividad para no llevar contadores --->
<cfquery name="rsActiTot" datasource="#Session.DSN#">
	select CTAcodigo, sum(CTThoras) as horas 
	from CTReporteTiempos AS CTR
		left outer join CTTiempos AS CTT
			on CTT.CTRcodigo = CTR.CTRcodigo
	where CTR.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and CTRfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecDesde#">
	and CTRfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.fecHasta#">
	group by CTAcodigo
	having sum(CTThoras) > 0
</cfquery>

<!--- Variables para le proceso de impresion y el corte de pagina --->

	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfparam name="PageNum_rs" default="1">
	<cfset MaxRows_rs = 100000>		
	<cfset StartRow_rs    = Min( (PageNum_rs-1) * MaxRows_rs + 1, Max(rsUsuarios.RecordCount, 1) )>
	<cfset StartRow_lista = StartRow_rs + (1-PageNum_rs) >
	<cfif StartRow_lista lte 1>
		<cfset StartRow_lista = 1>
	</cfif>
	
	<cfset EndRow_rs=Min(StartRow_rs+MaxRows_rs-1,rsUsuarios.RecordCount)>
	<cfset TotalPages_rs=Ceiling(rsUsuarios.RecordCount/MaxRows_rs)>

<cfsavecontent variable="encabezado1">
	<cfoutput>
		<tr> 
			<td colspan="#rsActiv.recordcount+2#" class="tituloAlterno" align="center">#session.Enombre#</td>
		</tr>
		<tr> 
			<td colspan="#rsActiv.recordcount+2#">&nbsp;</td>
		</tr>
		<tr> 
			<td colspan="#rsActiv.recordcount+2#" align="center"><b>Reporte de Actividades por Usuario</b></td>
		</tr>
		<tr> 
			<td colspan="#rsActiv.recordcount+2#" align="center">
				<b>Fecha del Reporte:&nbsp;</b> #LSDateFormat(fecDesde, 'dd-mm-yyyy')# &nbsp; 
				<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd-mm-yyyy')#
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr class="encabReporte">
			<td>&nbsp;</td>
			<cfloop query="rsActiv">
				<td align="center" nowrap>#rsActiv.Descripcion#</td>
			</cfloop>
			<td align="center"><b>Totales</b></td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
	</cfoutput>
</cfsavecontent>

<cfsavecontent variable="encabezado2">

</cfsavecontent>

<!--- Estilos para el reporte --->
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 10px;
		padding-bottom: 10px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>
<form style="margin:0; " name="form1" method="post">
	<link type="text/css" rel="stylesheet" href="/cfmx/sif/css/asp.css">
	<cfoutput>
		<cfif not isdefined("url.imprimir")>
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="../../portlets/pNavegacion.cfm">
						<cf_rhimprime datos="/sif/ControlTiempos/consultas/formActividadesXUsr.cfm" paramsuri="#vparams#">
					</td>	
				</tr>
			</table>	
		</cfif>
	</cfoutput>
	<!--- Form del Reporte --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding-left: 5px; padding-right: 10px" align="center">
			<cfif not isdefined("url.imprimir")>
				<cfoutput>
					<tr> 
						<td colspan="#rsActiv.recordcount+2#" class="tituloAlterno" align="center">#session.Enombre#</td>
					</tr>
					<tr> 
						<td colspan="#rsActiv.recordcount+2#">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="#rsActiv.recordcount+2#" align="center"><b>Reporte de Actividades por Usuario</b></td>
					</tr>
					<tr> 
						<td colspan="#rsActiv.recordcount+2#" align="center">
							<b>Fecha del Reporte:&nbsp;</b> #LSDateFormat(fecDesde, 'dd-mm-yyyy')# &nbsp; 
							<b>Hasta:&nbsp;</b>#LSDateFormat(fecHasta, 'dd-mm-yyyy')#
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr class="encabReporte">
						<td>&nbsp;</td>
						<cfloop query="rsActiv">
							<td align="center" nowrap>#rsActiv.Descripcion#</td>
						</cfloop>
						<td align="right"><b>Total</b></td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</cfoutput>
			</cfif>
			<cfset rsResultado = QueryNew("")>
			<cfset arreglo     = ArrayNew(1)>
			<cfset index = 0 >
			<cfset Puesto = 0>
			<cfoutput query="rsUsuarios" startrow="#StartRow_lista#" maxrows="#MaxRows_rs#">
				<cfif isdefined("url.imprimir")>
					<cfif currentRow mod 35 EQ 1>
						<cfif currentRow NEQ 1>
							<tr class="pageEnd"><td colspan="7">&nbsp;</td></tr>
						</cfif>
						#encabezado1#
						#encabezado2#
					</cfif>	
				</cfif>
				<cfset index = index + 1 >
				<tr>
					<cfset acumHUsuario = 0>
					<cfquery name="rs2" dbtype="query">
						select Usucodigo, horas
						from rsHoras, rsActiv
						where rsHoras.Usucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUsuarios.Usuario#">
						  and rsHoras.CTAcodigo = rsActiv.CTAcodigo
					</cfquery>
					<cfif isdefined("rs2") and rs2.RecordCount GT 0>					
						<td width="180" nowrap>#rsUsuarios.nombre#</td>
						<cfloop query="rs2">
							<td align="center">
								<cfif rs2.horas EQ 0>
									CERO
								<cfelseif rs2.horas GT 0>
									#LSNumberFormat (rs2.horas,',9.00')#
								</cfif>			
							</td>
							<cfset acumHUsuario = acumHUsuario + iif(rs2.horas NEQ "", de(rs2.horas),0.00)>
						</cfloop>
						<td align="right" colspan="#rsActiv.recordcount#">
							#LSNumberFormat(acumHUsuario,',9.00')#			
						</td>
					</cfif>
				</tr>	
			</cfoutput>
			<!--- Pintado de Totales por Actividad --->
			<tr>
				<td class="topline"><b>Totales</b></td>
				<cfoutput>
					<cfset granTotal = 0>
					<cfloop query="rsActiTot">
						<cfset granTotal = granTotal + rsActiTot.horas>
						<td align="center" class="topline" nowrap>#LSNumberFormat(rsActiTot.horas,',9.00')#</td>
					</cfloop>
					<td align="right" class="topline" nowrap>#LSNumberFormat(granTotal,',9.00')#</td>
				</cfoutput>
			</tr>	
			<cfoutput>
				<tr><td colspan="#rsActiv.recordcount+2#">&nbsp;</td></tr>
				<tr><td colspan="#rsActiv.recordcount+2#" class="topline">&nbsp;</td></tr>
				<tr><td colspan="#rsActiv.recordcount+2#" class="topline">&nbsp;</td></tr>			
				<tr>
					<td colspan="#rsActiv.recordcount+2#">
				  		<div align="center">------------------ Fin del Reporte ------------------</div>
					</td>
				</tr>
			</cfoutput>
		</table>

</form>