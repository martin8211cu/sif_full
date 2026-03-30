<cf_templateheader title="Cagar Saldos Contables Presupuestales">
	<!--- Obtiene el mes de Auxiliares --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 50
	</cfquery>
	<cfset LvarAuxAno = rsSQL.Pvalor>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.Ecodigo#
		   and Pcodigo = 60
	</cfquery>
	<cfset LvarAuxMes = rsSQL.Pvalor>
	<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>

	<cfquery name="rsSQL" datasource="#session.dsn#">
		select Pvalor
		  from Parametros
		 where Ecodigo = #session.ecodigo#
		   and Pcodigo = 45
	</cfquery>
	<cfset LvarMesFin = rsSQL.Pvalor>

    <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}" datasource="#session.dsn#" returnVariable="LvarDesde" isnumber="no">
    <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}" datasource="#session.dsn#" returnVariable="LvarHasta" isnumber="no">
	<!--- Obtiene el periodo de presupuesto --->
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CPPid, CPPestado, CPPfechaDesde, CPPfechaHasta, CPPanoMesDesde, CPPanoMesHasta, CPPtipoPeriodo,
			<cf_dbfunction name="concat" args=
				"case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				+ ' de ' + 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				+ ' ' + #preservesinglequotes(LvarDesde)#
				+ ' a ' + 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				+ ' ' + #preservesinglequotes(LvarHasta)#" delimiters="+">
			as CPPdescripcion
		  from CPresupuestoPeriodo
		 where Ecodigo = #session.Ecodigo#
		   and #LvarAuxAnoMes# between CPPanoMesDesde and CPPanoMesHasta
	</cfquery>
	
	
	<!--- Obtiene el periodo de presupuesto --->
	<cfif rsSQL.CPPid EQ "" OR rsSQL.CPPestado EQ "5">
		<cfset LvarCPPid 			= -1>
		<cfset LvarTipo				= "Período Fiscal">
		<cfset LvarMesN   			= 12>
		<cfif LvarMesFin EQ 12>
			<cfset LvarMesIni 		= 1>
			<cfset LvarAnoIni 		= LvarAuxAno>
			<cfset LvarAnoFin 		= LvarAuxAno>
		<cfelse>
			<cfset LvarMesIni = LvarMesFin+1>
			<cfif LvarMesIni LT LvarAuxMes>
				<cfset LvarAnoIni	 = LvarAuxAno - 1>
				<cfset LvarAnoFin 	= LvarAuxAno>
			<cfelse>
				<cfset LvarAnoIni 	= LvarAuxAno>
				<cfset LvarAnoFin 	= LvarAuxAno + 1>
			</cfif>
		</cfif>
		<cfset LvarAnoMesFin		= LvarAnoFin * 100 + LvarMesFin>
	<cfelseif rsSQL.CPPestado NEQ "1">
		<cf_errorCode	code = "50455"
						msg  = "No esta abierto el Período de Presupuesto @errorDat_1@"
						errorDat_1="#rsSQL.CPPdescripcion#"
		>
	<cfelse>
		<cfset LvarCPPid 			= rsSQL.CPPid>
		<cfset LvarTipo				= "Período de Presupuesto">
		<cfset LvarMesN   			= rsSQL.CPPtipoPeriodo>
		<cfset LvarAnoIni			= datepart("yyyy",rsSQL.CPPfechaDesde)>
		<cfset LvarMesIni			= datepart("m",rsSQL.CPPfechaDesde)>
		<cfset LvarAnoFin			= datepart("yyyy",rsSQL.CPPfechaHasta)>
		<cfset LvarMesFin			= datepart("m",rsSQL.CPPfechaHasta)>
		<cfset LvarAnoMesFin		= LvarAnoFin * 100 + LvarMesFin>
	</cfif>

	<cfif isdefined("form.btnCargar")>
		<!--- cboTipo eq 2: Se presiono btnCargar y se visualiza la pantalla --->
		<cfoutput>
		<BR><BR><BR>
		Cargando Saldos de Control de Presupuesto en Presupuesto Contable...
		<BR><BR><BR>
		POR FAVOR ESPERE
		</cfoutput>
		<iframe src="cargar.cfm?cargar" style="display:none">
	<cfelseif isdefined("url.Cargar")>
		<!--- cboTipo eq 2: La pantalla que visualiza ejecuta por iframe la carga --->
		<cfsetting requesttimeout="36000"> 
		<cfinvoke 	component="sif.Componentes.PRES_cargarSaldosContablesP" method="CargaPresupuestoConta"
					Ecodigo = "#session.Ecodigo#"
					CPPid	= "#rsSQL.CPPid#"
					
					returnvariable="LvarCantidad"
		/>
		<script language="javascript">
			alert ("Se cargaron <cfoutput>#LvarCantidad#</cfoutput> Saldos de Presupuesto Contable");
			parent.location.href="/cfmx/home/menu/modulo.cfm?s=SIF&m=PRES";
		</script>
	<cfelse>
		<form 	name="frmArranque" 
				enctype="multipart/form-data"
				method="post" action="cargar.cfm"
				>
			<table width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td align="center" style="font-size:18px; color:#0000CC; font-family:Verdana, Arial, Helvetica, sans-serif;">
					<cfif LvarCPPid EQ -1>
						Este proceso Carga la información de Presupuesto Contable para<BR>el Período Fiscal actual <cfoutput>#LvarAnoIni#</cfoutput>
					<cfelse>
						Este proceso Carga la información de Presupuesto Contable para<BR>el Período actual de Presupuesto <cfoutput>#rsSQL.CPPdescripcion#</cfoutput>
					</cfif>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>
						1) Las Cuentas Contables sin &nbsp;Cuenta de Presupuesto se cargan a partir de un <strong>archivo de importacion</strong><BR><BR>
					</td>
				</tr>
				<tr>
					<td>
						2) Las Cuentas Contables con Cuenta de Presupuesto se cargan a partir de los <strong>Saldos en Control de Presupuesto</strong><BR><BR>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2">
						Tipo de Carga:&nbsp;&nbsp;
						<select name="cboTipo"
							onchange="
								document.getElementById('divImportar').style.display = (this.value==1 ? '' : 'none');
								document.getElementById('tdCargar').style.display = (this.value==2 ? '' : 'none');
							"
						>
						<cfif LvarCPPid EQ -1>	
							<option value="1">Importar únicamente Cuentas sin Presupuesto (No hay Período de Presupuesto)</option>
						<cfelse>
							<option value="1">Importar Cuentas sin Presupuesto y Cargar Cuentas con Presupuesto</option>
							<option value="2">Cargar únicamente Cuentas con Presupuesto</option>
						</cfif>
						</select>
					</td>
				</tr>
				<tr>
					<td align="left" id="tdCargar"  style="display:none;">
						<BR><BR><BR><BR>
						<input type="submit" name="btnCargar" value="Solo Cargar con Presupuesto"
							onclick="
								if(this.form.archivo.value=='') 
									return confirm('¿Desea cargar únicamente Cuentas de Presupuesto?');
								return true;
							"
						>
					</td>
				</tr>
			</table>
		</form>
		<div id="divImportar" style="display:yes;">
		<cf_sifimportar eicodigo="SALDOSCONTAP" mode="in" width="100%" height="400">
		</div>
	</cfif>
<cf_templatefooter>

