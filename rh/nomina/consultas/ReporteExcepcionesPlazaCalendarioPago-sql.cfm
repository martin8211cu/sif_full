<!--- ETIQUETAS --->

<!--- CONSULTA DE DATOS --->
<!--- Calendario de Pagos --->
<cfif isdefined("form.dependencias")>
	<cfinvoke component="rh.Componentes.RH_Funciones" method="CFDependencias"
		CFid = "#form.CFid#"
		Nivel = 5
		returnvariable="Dependencias"/>
	<cfset Centros = ValueList(Dependencias.CFid)>
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	Select cb.CBcc, cp.Tcodigo, cp.CPdesde, cp.CPhasta, cb.CBdescripcion, cp.CFComplemento,(select  cp.CFComplemento +' ('+pcd.PCDdescripcion+')'
            from FPActividadD ae
                inner join PCDCatalogo pcd
                    on pcd.PCEcatid = ae.PCEcatid
            where ae.FPADNivel=(select max(x.FPADNivel) from FPActividadD x where cp.FPAEid=x.FPAEid )
            and ae.FPAEid = cp.FPAEid
            and pcd.PCDvalor = right(cp.CFComplemento,ae.FPADLogitud)
            ) as descripcion  
	from CalendarioPagos cp
	inner join CuentasBancos cb
		on cp.CBid = cb.CBid
	where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isDefined("Form.Tcodigo")  and len(trim(form.Tcodigo))>
			and cp.Tcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Tcodigo#">
		</cfif>
		<cfif isDefined("Form.Fdesde") and len(trim(form.Fdesde))>
			and cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Fdesde#">
		</cfif>
		<cfif isDefined("Form.Fhasta") and len(trim(form.Fhasta))>
			and cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Fhasta#">	
		</cfif>
</cfquery>

<!--- Plazas --->

<cfquery name="rsDatosPlaza" datasource="#session.DSN#">

	Select cf.CFcodigo, cf.CFdescripcion, rp.RHPcodigo, rp.RHPdescripcion, rp.CFComplemento, rp.FPAEid,
		case when lt.LTid > 0 and <cf_dbfunction name="now"> between lt.LTdesde and lt.LThasta 
		    then 
		dt.DEapellido1 +' '+ dt.DEapellido2 +' '+ dt.DEnombre
		else ' Vacante '
		end as Ocupacion,
		 (select  rp.CFComplemento +' ('+pcd.PCDdescripcion+')'
            from FPActividadD ae
                inner join PCDCatalogo pcd
                    on pcd.PCEcatid = ae.PCEcatid
            where ae.FPADNivel=(select max(x.FPADNivel) from FPActividadD x where rp.FPAEid=x.FPAEid )
            and ae.FPAEid = rp.FPAEid
            and pcd.PCDvalor = right(rp.CFComplemento,ae.FPADLogitud)
            ) as descripcion
		from RHPlazas rp
		    inner join CFuncional cf
		    on cf.CFid=rp.CFid
		    and cf.Ecodigo = rp.Ecodigo
		    left join LineaTiempo lt
		        inner join DatosEmpleado dt 
		        on dt.DEid = lt.DEid
		        and dt.Ecodigo = lt.Ecodigo
		    on lt.RHPid =rp.RHPid

		    where rp.FPAEid is not null 
			and rp.CFComplemento is not null
			<!---and <cf_dbfunction name="now"> between lt.LTdesde and lt.LThasta---> 
			and rp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isDefined("Form.RHPid2") and len(trim(form.RHPid2))>
				and rp.RHPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPid2#">
			</cfif>

</cfquery>
<!--- Centro Funcional y Dependencias --->

<cfquery name="rsCFuncional" datasource="#session.DSN#">

	Select cf.CFdescripcion, rp.RHPdescripcion,
		 (select  cf.CFComplemento +' ('+pcd.PCDdescripcion+')'
            from FPActividadD ae
                inner join PCDCatalogo pcd
                    on pcd.PCEcatid = ae.PCEcatid
            where ae.FPADNivel=(select max(x.FPADNivel) from FPActividadD x where cf.FPAEid=x.FPAEid )
            and ae.FPAEid = cf.FPAEid
            and pcd.PCDvalor = right(cf.CFComplemento,ae.FPADLogitud)
            ) as descripcion
		from CFuncional cf
		    inner join RHPlazas rp
		    on cf.RHPid=rp.RHPid
		    and cf.Ecodigo = rp.Ecodigo
		    where cf.FPAEid is not null 
			and cf.CFComplemento is not null
			<cfif isdefined('form.dependencias')>
				and cf.CFid in (#Centros#)
			</cfif>
			and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isDefined("Form.CFid") and len(trim(form.CFid)) and not isdefined("form.dependencias")>
				and cf.CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CFid#">
			</cfif>
			<cfif isDefined("Form.RHPid2") and len(trim(form.RHPid2))>
				and rp.RHPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHPid2#">
			</cfif>
</cfquery>

<!--- IMPRESION DE DATOS --->
<cfoutput>	
<cfset LvarFileName = "Reporte Excepciones por Plaza de CalendarioPago.xls">
<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" colspan="6">
	<tr>
		<td align="center">	
			<cf_htmlReportsHeaders 
			title="ReporteExcepcionesPlazaCalendarioPago"
			FileName="#LvarFileName#"
			irA="ReporteExcepcionesPlazaCalendarioPago.cfm">


		<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0" colspan="6">
			<tr>	
				<td align="center" colspan="6"><strong><font size="2">
				<cf_EncReporte Titulo="Reporte de Excepciones por Plaza y Calendarios de Pago">

				<cfif Form.TipoFiltro EQ "CP">
					<cfif rsDatos.RecordCount GT 0>
						<tr class="tituloListas">
							<td><strong>TIPO DE NOMINA</strong></td>
							<td><strong>FECHA DESDE</strong></td>
							<td><strong>FECHA HASTA</strong></td>
							<td><strong>CUENTA BANCO</strong></td>
							<td><strong>FUENTE FINANCIAMIENTO</strong></td>
						</tr>
						

						<cfloop query="rsDatos">
							<tr>
								<td>#rsDatos.Tcodigo#</td>
								<td>#LSDATEFORMAT(rsDatos.CPdesde, "dd-mm-yyyy")#</td>
								<td>#LSDATEFORMAT(rsDatos.CPhasta, "dd-mm-yyyy")#</td>
								<td>#rsDatos.CBcc# &nbsp;-&nbsp; #ltrim(rsDatos.CBdescripcion)#</td>
								<td>#rsDatos.descripcion#</td>
						
							</tr>
						</cfloop>
						<tr>
							<td>&nbsp;</td>
						</tr>						
						<tr>
							<td colspan="6" align="center" class="letra">---Fin del Reporte---</td>
						</tr>
					<cfelse>
						<tr>
							<td colspan="6" align="center"><b>----- No Se Encontraron Registros -----</b></td>
						</tr>
					</cfif>
				</cfif>
				<cfif Form.TipoFiltro EQ "P">
					<cfif rsDatosPlaza.RecordCount GT 0>
						<tr class="tituloListas">
							<td><strong>CENTRO FUNCIONAL</strong></td>
							<td><strong>PLAZA</strong></td>
							<td><strong>FUENTE DE FINANCIAMIENTO</strong></td>
							<td><strong>OCUPACION</strong></td>
						</tr>
						
						
						<cfloop query="rsDatosPlaza">
							<tr>
								<td>#rsDatosPlaza.CFdescripcion#</td>
								<td>#rsDatosPlaza.RHPcodigo# - #rsDatosPlaza.RHPdescripcion# </td>
								<td>#rsDatosPlaza.descripcion#</td>
								<td> #rsDatosPlaza.Ocupacion# </td>
							</tr>
						</cfloop>
						<tr>
							<td>&nbsp;</td>
						</tr>	
						<tr>
							<td colspan="6" align="center"><b>----- FIN DEL REPORTE -----</b></td>
						</tr>
					<cfelse>
						<tr>
							<td colspan="6" align="center"><b>----- No Se Encontraron Registros -----</b></td>
						</tr>
					</cfif>
				</cfif>
				<cfif Form.TipoFiltro EQ "CFD">
					<cfif rsCFuncional.RecordCount GT 0>
						<tr class="tituloListas">
							<td><strong>CENTRO FUNCIONAL</strong></td>
							<td><strong>PLAZA</strong></td>
							<td><strong>FUENTE DE FINANCIAMIENTO</strong></td>
						</tr>
						
						
						<cfloop query="rsCFuncional">
							<tr>
								<td>#rsCFuncional.CFdescripcion#</td>
								<td>#rsCFuncional.RHPdescripcion# </td>
								<td>#rsCFuncional.descripcion# </td>
							</tr>
						</cfloop>
						<tr>
							<td>&nbsp;</td>
						</tr>	
						<tr>
							<td colspan="6" align="center"><b>----- FIN DEL REPORTE -----</b></td>
						</tr>
					<cfelse>
						<tr>
							<td colspan="6" align="center"><b>----- No Se Encontraron Registros -----</b></td>
						</tr>
					</cfif>
				</cfif>
				</td>
			</tr>		
			</table>			
		</td>
	</tr>
</table>
</cfoutput>