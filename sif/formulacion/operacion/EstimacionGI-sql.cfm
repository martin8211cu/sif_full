<cfparam name="param" default="">
<cf_navegacion name="CurrentPage" default="EstimacionGI.cfm">
<cfif (not isdefined('form.FPEEid') or not len(trim(form.FPEEid))) and isdefined('url.FPEEid')>
	<cfset form.FPEEid = url.FPEEid>
</cfif>
<cfif (not isdefined('form.FPCCid') or not len(trim(form.FPEEid))) and isdefined('url.FPCCid')>
	<cfset form.FPCCid = url.FPCCid>
</cfif>
<cfif (not isdefined('form.tab') or not len(trim(form.tab))) and isdefined('url.tab')>
	<cfset form.tab = url.tab>
</cfif>
<cfif (not isdefined('form.CPPid') or not len(trim(form.CPPid))) and isdefined('url.CPPid')>
	<cfset form.CPPid = url.CPPid>
</cfif>
<cfif (not isdefined('form.FPTVid') or not len(trim(form.FPTVid))) and isdefined('url.FPTVid')>
	<cfset form.FPTVid = url.FPTVid>
</cfif>
<cfif (not isdefined('form.FPEPid') or not len(trim(form.FPEPid))) and isdefined('url.FPEPid')>
	<cfset form.FPEPid = url.FPEPid>
	<cfset form.tab = -1>
</cfif>
<cfif isdefined('btnEliminar')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="BajaDetalleEstimacion">
		<cfinvokeargument name="FPEEid" 			value="#form.FPEEid#">
		<cfinvokeargument name="FPEPid" 			value="#url.FPEPid#">
		<cfinvokeargument name="FPDElinea" 			value="#url.FPDElinea#">
	</cfinvoke>
	<cfset param &= "FPEEid=#form.FPEEid#&tab=-1&FPEPid=#url.FPEPid#">
<cfelseif isdefined('btnEnviarAprobar')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="fnValidarInconsistencias">
		<cfinvokeargument name="FPEEid" value="#form.FPEEid#">
	</cfinvoke>
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="EnviarAprobarEstimacion">
			<cfinvokeargument name="FPEEid" value="#form.FPEEid#">
			<cfinvokeargument name="IrA" 	value="#CurrentPage#">
		</cfinvoke>
	</cftransaction>
	<cfset form.tab = iif(form.tab eq -1, '1',form.tab)>
	<cfset param &= "FPEEid=#form.FPEEid#&tab=#form.tab#">
<cfelseif isdefined('btnAprobar')>
	<cfif isdefined('esGrupal')>
		<cfset lvarCPPid = form.CPPid>
		<cfset lvarFPTVTipo = 4>
		<cfquery datasource="#session.dsn#" name="rsEInc">
			select FPEEid
			from FPEEstimacion
			where Ecodigo = #session.Ecodigo# 
			  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarCPPid#">
			  and FPEEestado = 0
		</cfquery>
		<cfset lvarFPEEid = ValueList(rsEInc.FPEEid)>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="rsEE">
			select FPTVTipo,CPPid
			from FPEEstimacion a 
				inner join TipoVariacionPres b
					on a.FPTVid = b.FPTVid
			where a.Ecodigo = #session.Ecodigo# and a.FPEEid = #form.FPEEid#
		</cfquery>
		<cfset lvarCPPid = rsEE.CPPid>
		<cfset lvarFPTVTipo = rsEE.FPTVTipo>
		<cfset lvarFPEEid = form.FPEEid>
	</cfif>
	<cfif lvarFPTVTipo eq -1>
		<cfset CurrentPage = "EstimacionGI-Admin.cfm">	
	<cfelse>
		<cfset CurrentPage = "VariacionPresupuestal-Admin.cfm">
	</cfif>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="fnValidarInconsistencias">
		<cfinvokeargument name="FPEEid" value="#lvarFPEEid#">
		<cfinvokeargument name="IrA" value="#CurrentPage#">
	</cfinvoke>
	<!---=========== Si es variacion no modifica monto se necesita esta query, ya que el traslado se genera inmediatamente =============--->
	<cfif lvarFPTVTipo eq 1>
		<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="rsQueryGeneral">
			<cfinvokeargument name="CPPid" 		value="#lvarCPPid#">
			<cfinvokeargument name="FPEEestado" value="1">
		</cfinvoke>
		<cfset Request.rsQueryGeneral = rsQueryGeneral>
	</cfif>
	<cfif isdefined('esGrupal')>
		<cfinvoke component="sif.Componentes.PCG_Traslados" method="fnCrearTablasTemporales">
			<cfinvokeargument name="CPPid" 			value="#lvarCPPid#">
			<cfinvokeargument name="FPEEestado" 	value="0">
		</cfinvoke>
		<cfquery dbtype="query" name="rsNivelesEquilibrio">	
			select PCDcatid, PCDdescripcion,
				sum(IngresosEstimacion) as TotalIngresos,
				sum(EgresosEstimacion)  as TotalEgresos,
				sum(IngresosPlan) as TotalIngresosPlan,
				sum(EgresosPlan) as TotalEgresosPlan
			from Request.query
			group by PCDcatid, PCDdescripcion
			having
			  sum(IngresosPlan) - sum(IngresosEstimacion) <> 0
			  or 
			  sum(EgresosPlan) - sum(EgresosEstimacion)  <> 0
			order by PCDdescripcion
		</cfquery>	
		<cfif rsNivelesEquilibrio.recordcount gt 0>
			<html>
			<head></head>
			<body>
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr style="font-weight:bold;">
					<td colspan="13" align="center" style="font-size:24px">Los siguientes niveles de equilibrio estan desequilibrados</td>
				</tr>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr style="font-weight:bold" align="center">
					<td colspan="2" nowrap>Nivel</td>
					<td colspan="2" nowrap>Total Egresos</td>
					<td colspan="2" nowrap>Total Egresos En Plan</td>
					<td colspan="2" nowrap>Diferencia</td>
					<td colspan="2" nowrap>Total Ingresos</td>
					<td colspan="2" nowrap>Total Ingresos En Plan</td>
					<td nowrap>Diferencia</td>
				</tr>
				<cfset i = 0>
				<cfoutput query="rsNivelesEquilibrio">
					<tr class="<cfif i mod 2 eq 0>listaPar<cfelse>listaNon</cfif>">
						<cfset lvarDifE = rsNivelesEquilibrio.TotalEgresosPlan - rsNivelesEquilibrio.TotalEgresos>
						<cfset lvarDifI = rsNivelesEquilibrio.TotalIngresosPlan - rsNivelesEquilibrio.TotalIngresos>
						<td nowrap>#rsNivelesEquilibrio.PCDdescripcion#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalEgresos,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalEgresosPlan,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(lvarDifE,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalIngresos,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(rsNivelesEquilibrio.TotalIngresosPlan,',9.0000')#</td><td>&nbsp;</td>
						<td align="right" nowrap>#numberformat(lvarDifI,',9.0000')#</td>
					</tr>
					<cfset i = i + 1>
				</cfoutput>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr style="font-weight:bold;">
					<td colspan="13">El proceso no puede continuar hasta que los niveles esten equilibrados.</td>
				</tr>
				<tr><td colspan="13">&nbsp;</td></tr>
				<tr>
					<td colspan="13">
						<form name="form1" action="VariacionPresupuestal-Admin.cfm" method="post"><cf_botones values="Regresar"></form>
					</td>
				</tr>
			</table>
			</body>
			</html>
			<cfabort>
		</cfif>
	</cfif>
	<cftransaction>
		<cfif isdefined('esGrupal')>
			<cfquery dbtype="query" name="rsTraslados">	
				select count(1) cantidad from Request.query
				where IngresosEstimacion -  IngresosPlan <> 0 or EgresosEstimacion - EgresosPlan <> 0
			</cfquery>
			<cfif rsTraslados.recordcount eq 0 or rsTraslados.cantidad eq 0>
				<cfthrow message="No existe movimientos en la estimaciones por lo que no se generaran traslados, debe de existir movimientos para continuar con el proceso, Proceso cancelado.">
			<cfelse>
				<cfinvoke component="sif.Componentes.PCG_Traslados" method="ALTATrasladoMasivo">
					<cfinvokeargument name="CPPid" 			value="#lvarCPPid#">
					<cfinvokeargument name="FPEEestado" 	value="0">
				</cfinvoke>
				<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
					<cfinvokeargument name="FPEEestado" 	value="5">
					<cfinvokeargument name="Filtro" 		value="CPPid = #lvarCPPid# and FPTVid = #form.FPTVid# and FPEEestado = 0">
				</cfinvoke>
			</cfif>
		<cfelse>
			<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="GuardarHVersion">
				<cfinvokeargument name="FPEEid" value="#form.FPEEid#">
			</cfinvoke>
			<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AprobarEstimacion">
				<cfinvokeargument name="FPEEid" value="#form.FPEEid#">
			</cfinvoke>
		</cfif>
	</cftransaction>
<cfelseif isdefined('btnRechazar')>
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="RechazarEstimacion">
			<cfinvokeargument name="FPEEid" value="#form.FPEEid#">
		</cfinvoke>
	</cftransaction>
	<cfset param &= "FPEEid=#form.FPEEid#&tab=#form.tab#">
<!---==========Agrega una nueva linea de la estimacion de Ingresos y Egresos=================--->
<cfelseif isdefined('btnAgregar_ALL')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="AltaDetalleEstimacion">
			<cfinvokeargument name="FPEEid" 					value="#form.FPEEid_ALL#">
			<cfinvokeargument name="FPEPid" 					value="#form.FPEPid_ALL#">
			<cfinvokeargument name="DPDEdescripcion" 			value="#form.DPDEdescripcion_ALL#">
			<cfinvokeargument name="DPDEjustificacion" 			value="#form.DPDEjustificacion_ALL#">
			<cfinvokeargument name="Mcodigo" 					value="#form.Mcodigo_ALL#">
			<cfinvokeargument name="Dtipocambio" 				value="#form.Dtipocambio_ALL#">
			<cfinvokeargument name="DPDEcantidad" 				value="#form.DPDEcantidad_ALL#">
			<cfinvokeargument name="DPDEcosto" 					value="#form.DPDEcosto_ALL#">
			<cfinvokeargument name="FPAEid" 					value="#form.CFComplemento_ALLId#">
			<cfinvokeargument name="CFComplemento" 				value="#form.CFComplemento_ALL#">
			<cfinvokeargument name="DPDMontoTotalPeriodo" 		value="#replace(form.DPDMontoTotalPeriodo_ALL,',','','ALL')#">
		 <cfif isdefined('form.DPDEfechaIni_ALL') and len(trim(form.DPDEfechaIni_ALL))>
			<cfinvokeargument name="DPDEfechaIni" 				value="#form.DPDEfechaIni_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEfechaFin_ALL') and len(trim(form.DPDEfechaFin_ALL))>
			<cfinvokeargument name="DPDEfechaFin" 				value="#form.DPDEfechaFin_ALL#">
		</cfif>
		<cfif isdefined('form.Ucodigo_ALL') and len(trim(form.Ucodigo_ALL))>
			<cfinvokeargument name="Ucodigo" 					value="#form.Ucodigo_ALL#">
		</cfif>
		<cfif isdefined('form.Aid_ALL')>
			<cfinvokeargument name="Aid" 			    		value="#form.Aid_ALL#">
		</cfif>
		<cfif isdefined('form.Cid_ALL')>
			<cfinvokeargument name="Cid" 			    		value="#form.Cid_ALL#">
		</cfif>
		<cfif isdefined('form.FPCid_ALL')>
			<cfinvokeargument name="FPCid" 			    		value="#form.FPCid_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEcantidadPeriodo_ALL')>
			<cfinvokeargument name="DPDEcantidadPeriodo" 		value="#form.DPDEcantidadPeriodo_ALL#">
		</cfif>
		<cfif isdefined('form.OBOid') and len(trim(form.OBOid))>
			<cfinvokeargument name="OBOid" 			    		value="#form.OBOid#">
		</cfif>
		<cfif isdefined('form.DPDEcontratacion_ALL') and len(trim(form.DPDEcontratacion_ALL))>
			<cfinvokeargument name="DPDEcontratacion" 			value="#form.DPDEcontratacion_ALL#">
		</cfif>
		<cfif isdefined('form.DPDEmontoMinimo_ALL') and len(trim(form.DPDEmontoMinimo_ALL))>
			<cfinvokeargument name="DPDEmontoMinimo" 			value="#replace(form.DPDEmontoMinimo_ALL,',','','ALL')#">
		</cfif>
		<cfif isdefined('form.VariacionNueva')>
				<cfinvokeargument name="DPDEmontoAjuste" 		value="#replace(form.DPDMontoTotalPeriodo_ALL,',','','ALL')#">
		<cfelse>
			<cfif isdefined('form.DPDEmontoAjuste_ALL') and len(trim(form.DPDEmontoAjuste_ALL))>
				<cfinvokeargument name="DPDEmontoAjuste" 		value="#replace(form.DPDEmontoAjuste_ALL,',','','ALL')#">
			</cfif>
		</cfif>
	</cfinvoke>
	<cfset param &= "FPEEid=#form.FPEEid_ALL#&tab=-1&FPEPid=#form.FPEPid_ALL#">
<!---==========Modifica una linea existente de la estimacion de Ingresos y Egresos=================--->
<cfelseif isdefined('btnModificar_ALL')>
	<cfset param &= "FPEEid=#form.FPEEid_ALL#&tab=-1&FPEPid=#form.FPEPid_ALL#">
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FPDEstimacion"
		redirect="#form.CurrentPage#?#param#"
		timestamp="#form.ts_rversion#"
		field1="FPEEid" 
		type1="numeric" 
		value1="#form.FPEEid_ALL#"
		field2="FPEPid" 
		type2="numeric" 
		value2="#form.FPEPid_ALL#"
		field3="FPDElinea" 
		type3="numeric" 
		value3="#form.FPDElinea_ALL#">
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CambioDetalleEstimacion">
				<cfinvokeargument name="FPEEid" 				value="#form.FPEEid_ALL#">
				<cfinvokeargument name="FPEPid" 				value="#form.FPEPid_ALL#">
				<cfinvokeargument name="FPDElinea" 				value="#form.FPDElinea_ALL#">
				<cfinvokeargument name="DPDEdescripcion" 		value="#form.DPDEdescripcion_ALL#">
				<cfinvokeargument name="DPDEjustificacion" 		value="#form.DPDEjustificacion_ALL#">
				<cfinvokeargument name="Mcodigo" 				value="#form.Mcodigo_ALL#">
				<cfinvokeargument name="Dtipocambio" 			value="#form.Dtipocambio_ALL#">
				<cfinvokeargument name="DPDEcantidad" 			value="#form.DPDEcantidad_ALL#">
				<cfinvokeargument name="DPDEcosto" 				value="#replace(form.DPDEcosto_ALL,',','','ALL')#">
				<cfinvokeargument name="FPAEid" 				value="#form.CFComplemento_ALLId#">
				<cfinvokeargument name="CFComplemento" 			value="#form.CFComplemento_ALL#">
				<cfinvokeargument name="DPDMontoTotalPeriodo" 	value="#replace(form.DPDMontoTotalPeriodo_ALL,',','','ALL')#">
			<cfif isdefined('form.DPDEfechaIni_ALL') and len(trim(form.DPDEfechaIni_ALL))>
				<cfinvokeargument name="DPDEfechaIni" 			value="#form.DPDEfechaIni_ALL#">
			</cfif>
			<cfif isdefined('form.DPDEfechaFin_ALL') and len(trim(form.DPDEfechaFin_ALL))>
				<cfinvokeargument name="DPDEfechaFin" 			value="#form.DPDEfechaFin_ALL#">
			</cfif>
			<cfif isdefined('form.Ucodigo_ALL') and len(trim(form.Ucodigo_ALL))>
				<cfinvokeargument name="Ucodigo" 				value="#form.Ucodigo_ALL#">
			</cfif>
			<cfif isdefined('form.Aid_ALL')>
				<cfinvokeargument name="Aid" 			   		value="#form.Aid_ALL#">
			</cfif>
			<cfif isdefined('form.Cid_ALL')>
				<cfinvokeargument name="Cid" 			    	value="#form.Cid_ALL#">
			</cfif>
			<cfif isdefined('form.FPCid_ALL') and len(trim(form.FPCid_ALL))>
				<cfinvokeargument name="FPCid" 			   		value="#form.FPCid_ALL#">
			</cfif>
			<cfif isdefined('form.DPDEcantidadPeriodo_ALL')>
				<cfinvokeargument name="DPDEcantidadPeriodo" 	value="#form.DPDEcantidadPeriodo_ALL#">
			</cfif>
			<cfif isdefined('form.OBOid') and len(trim(form.OBOid))>
				<cfinvokeargument name="OBOid" 			    value="#form.OBOid#">
			</cfif>
			<cfif isdefined('form.DPDEcontratacion_ALL') and len(trim(form.DPDEcontratacion_ALL))>
				<cfinvokeargument name="DPDEcontratacion" 			    value="#form.DPDEcontratacion_ALL#">
			</cfif>
			<cfif isdefined('form.DPDEmontoMinimo_ALL') and len(trim(form.DPDEmontoMinimo_ALL))>
				<cfinvokeargument name="DPDEmontoMinimo" 			    value="#replace(form.DPDEmontoMinimo_ALL,',','','ALL')#">
			</cfif>
			<cfif isdefined('form.VariacionNueva')>
				<cfinvokeargument name="DPDEmontoAjuste" 			value="#replace(form.DPDMontoTotalPeriodo_ALL,',','','ALL')#">
			<cfelse>
				<cfif isdefined('form.DPDEmontoAjuste_ALL') and len(trim(form.DPDEmontoAjuste_ALL))>
					<cfinvokeargument name="DPDEmontoAjuste" 			value="#replace(form.DPDEmontoAjuste_ALL,',','','ALL')#">
				</cfif>
			</cfif>
		</cfinvoke>
	</cftransaction>
<cfelseif isdefined('btnNuevo_ALL')>
	<cfset param &= "FPEEid=#form.FPEEid_ALL#&tab=-1&FPEPid=#form.FPEPid_ALL#">
<cfelseif isdefined('btnModificarFecha')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CambioEncabezadoEstimacion">
		<cfinvokeargument name="FPEEid" 			value="#form.FPEEid_key#">
		<cfinvokeargument name="FPEEFechaLimite" 	value="#LSparsedatetime(form.fecha)#">
	</cfinvoke>
	<cfset param = "FPEEid=#form.FPEEid_key#&tab=#form.tab#">	
<cfelseif isdefined('btnAgregardetalles')>
	<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="GetEncabezadoEstimacion" returnvariable="Encabezado">
		<cfinvokeargument name="FPEEid" 			value="#form.FPEEid#">
	</cfinvoke>
	<cfquery name="rsYaCargados" datasource="#session.dsn#">
		select count(1) as cantidad
		from FPDEstimacion
		where FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEEid#">
		and PCGDid is not null
	</cfquery>
	<cfif rsYaCargados.cantidad eq 0>
		<cftransaction>
			<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CopiarDetalles" returnvariable="detalles">
				<cfinvokeargument name="CPPid" 			value="#Encabezado.CPPid#">
				<cfinvokeargument name="CFid" 			value="#Encabezado.CFid#">
				<cfinvokeargument name="FPEEid" 			value="#form.FPEEid#">
			</cfinvoke>
		</cftransaction>
	</cfif>
	<cfset param = "FPEEid=#form.FPEEid#&tab=#form.tab#">	
<cfelseif isdefined('btnDescartar')>
	<cfif isdefined('form.FPECid')>
		<cftransaction>
			<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CambioEstadoMasivo">
				<cfinvokeargument name="FPEEestado" value="7">
				<cfinvokeargument name="Filtro" 	value="FPECid = #form.FPECid#">
			</cfinvoke>
			<cfquery datasource="#session.dsn#">
				delete from FPEstimacionesCongeladas
				where Ecodigo = #session.Ecodigo#
				  and FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPECid#">
			</cfquery>
		</cftransaction>
		<cfset CurrentPage = "Congeladas.cfm">
	<cfelse>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="CambioEncabezadoEstimacion">
			<cfinvokeargument name="FPEEid" 			value="#form.FPEEid#">
			<cfinvokeargument name="FPEEestado" 			value="7">
		</cfinvoke>
	</cfif>
<cfelseif isdefined('btnFiltrar_ALL')>
	<cfset param &= "FPEEid=#form.FPEEid_ALL#&tab=-1&FPEPid=#form.FPEPid_ALL#">
<cfelseif isdefined('btnCongelar')>
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="fnCongelar">
			<cfinvokeargument name="CPPid" 				value="#form.CPPid#">
			<cfinvokeargument name="FPEEestado" 		value="#FPEEestado#">
			<cfinvokeargument name="FPVCdescripcion" 	value="#url.descripcion#">
		</cfinvoke>
	</cftransaction>
<cfelseif isdefined('btnDescongelar')>
	<cftransaction>
		<cfinvoke component="sif.Componentes.FPRES_EstimacionGI" method="fnDescongelar">
			<cfinvokeargument name="FPECid" 	value="#form.FPECid#">
			<cfinvokeargument name="CPPid" 		value="#form.CPPid#">
		</cfinvoke>
	</cftransaction>
	<cfset CurrentPage = "Congeladas.cfm">
</cfif>
<cfoutput>
<html><head></head><body>
<form name="form1" action="#CurrentPage#" method="post">
	<cfif isdefined('Equilibrio')>
		<input type="hidden" name="Equilibrio" 		value="#Equilibrio#" />
	</cfif>
	<cfloop list="#param#" index="i" delimiters="&">
		<input type="hidden" name="#listGetAt(i,1,'=')#" 		value="#listGetAt(i,2,'=')#" />
	</cfloop>
</form>
<script language="javascript1.2" type="text/javascript">
	document.form1.submit();
</script>
</body></html>
</cfoutput>