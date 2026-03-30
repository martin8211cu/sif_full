<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset meses = "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre">
<cfset MaxElements = 10>

<cfquery name="rsPeriodo" datasource="#Session.DSN#">
	select CPPid, 
			CPPtipoPeriodo, 
			CPPfechaDesde, 
			CPPfechaHasta, 
			CPPfechaUltmodif, 
			CPPestado,
		   	case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end #_Cat# ': '
			#_Cat# <cf_dbfunction name="to_sdateDMY" args="max(CPPfechaDesde)"> #_Cat# ' - ' #_Cat# 
			<cf_dbfunction name="to_sdateDMY" args="max(CPPfechaHasta)"> as Periodo
	from CPresupuestoPeriodo
	where Ecodigo = #Session.Ecodigo#
	and CPPestado = 1
	and CPPid = #form.CPPid#
	group by CPPid, CPPtipoPeriodo, CPPfechaDesde, CPPfechaHasta, CPPfechaUltmodif, CPPestado
</cfquery>
<cfquery name="rsTraslado" datasource="#Session.DSN#">
	select a.CPDEid
		,a.CPPid
		,a.CPDEfecha 
		,a.CPDEfechaDocumento 
		,rtrim(a.CPDEnumeroDocumento) as CPDEnumeroDocumento 
		,a.CPDEdescripcion
		,a.CPDEmsgRechazo 
		,a.Usucodigo
		,a.CPCano
		,a.CPCmes 
		,a.CPDEtipoAsignacion
		,c.CFid as CFidOrigen
		,c.CFcodigo as CFcodigoOrigen
		,c.CFdescripcion as CFdescripcionOrigen
		,d.Ocodigo as OcodigoOrigen
		,d.Odescripcion as Oficina1
		,e.CFid as CFidDestino
		,e.CFcodigo as CFcodigoDestino
		,e.CFdescripcion as CFdescripcionDestino
		,f.Ocodigo as OcodigoDestino
		,f.Odescripcion as Oficina2
	from CPDocumentoE a
		inner join CFuncional c
			on c.CFid = a.CFidOrigen
		
		inner join Oficinas d
			on  d.Ecodigo = c.Ecodigo and d.Ocodigo = c.Ocodigo

		inner join CFuncional e
			on e.CFid = a.CFidDestino 

		inner join Oficinas f
			on  f.Ecodigo = e.Ecodigo and f.Ocodigo = e.Ocodigo
	where a.Ecodigo = #Session.Ecodigo#
	and a.CPPid = #Form.CPPid#
	and a.CPDEtipoDocumento = 'T'
	and a.CPDEaplicado = 0
	and a.CPDEenAprobacion = 1
	and exists(select 1 from CPDocumentoD g where g.CPDEid = a.CPDEid)
	order by CPDEid
</cfquery>
<cf_templateheader title="Aprobación de Traslados de Presupuesto">
<cf_web_portlet_start titulo="Aprobacion de Traslados de Presupuesto">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<cfflush interval="64">
<form method="post" name="form1" action="traslado-sql.cfm">
	<input type="hidden" name="CPPid" value="<cfoutput>#Form.CPPid#</cfoutput>">
	<input type="hidden" name="CPDEmsgrechazo" value="">
	
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0"><tr>
	  	<td colspan="4"align="center" nowrap class="tituloAlterno">Encabezado de Documento de Traslado de Presupuesto</td>
	</tr>
	<tr>
		<td align="right" class="fileLabel" nowrap>Per&iacute;odo:</td>
		<td nowrap><cfoutput>#rsPeriodo.Periodo#</cfoutput></td>
		<td align="left" nowrap class="fileLabel">Fecha Doc:</td>
		<td nowrap>
		<cfif modo EQ "CAMBIO">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 30
			</cfquery>
			<cfset LvarAuxAno = rsSQL.Pvalor>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Pvalor
				  from Parametros
				 where Ecodigo = #session.Ecodigo#
				   and Pcodigo = 40
			</cfquery>
			<cfset LvarAuxMes = rsSQL.Pvalor>
			<cfset LvarAuxAnoMes = LvarAuxAno*100+LvarAuxMes>
			<cfset LvarDocAnoMes = rsTraslado.CPCano*100+rsTraslado.CPCmes>

			<cfset fecha = DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')>
			<cfset LvarCPformTipo = "aprobacion">
			<cfif LvarCPformTipo NEQ "cancelados" AND LvarDocAnoMes LT LvarAuxAnoMes>
				<cfif LvarCPformTipo EQ "aprobacion">
					<script language="javascript">
						alert ("La fecha del documento no puede ser menor al Mes de Contabilidad");
						<cfset LvarNOTaprobar = true>
					</script>
				<cfelse>
					<font color="#FF0000"><strong>Anterior: <cfoutput>#DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')#</cfoutput></strong></font>
					<cfif DateFormat(Now(), 'yyyymm') EQ LvarAuxAnoMes>
						<cfset fecha = DateFormat(Now(), 'dd/mm/yyyy')>
					<cfelse>
						<cfset fecha = DateFormat(CreateDate(dateFormat(Now(), 'yyyy'),dateFormat(Now(), 'mm'),1),'dd/mm/yyyy')>
					</cfif>
					<cfset rsTraslado.CPCano = LvarAuxAno>
					<cfset rsTraslado.CPCmes = LvarAuxMes>
					<script language="javascript">
						alert ("La fecha del documento no puede ser menor al Mes de Contabilidad");
						<cfset LvarNOTsolicitar = true>
					</script>
				</cfif>
			</cfif>
		<cfelse>
			<cfset fecha = DateFormat(Now(), 'dd/mm/yyyy')>
		</cfif>
		<cf_sifcalendario name="CPDEfechaDocumento" form="form1" value="#fecha#" readonly="true">
        </td>
	</tr>
	<tr>
		<td class="fileLabel" align="right" nowrap>Descripci&oacute;n: </td>
		<td nowrap colspan="3">Variacion PCG del periodo <cfoutput>#rsPeriodo.Periodo#</cfoutput></td>
	</tr>
	<tr>
		<td colspan="4" align="center" nowrap>
			<input type="submit" name="btnAplicar"  value="Aprobar"    onClick="javascript: if ( confirm('¿Está seguro(a) de que desea APROBAR este documento de traslado de presupuesto?') ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}" <cfif isdefined("LvarNOTaprobar")>disabled</cfif>>
			<input type="submit" name="btnRechazar" value="Rechazar"   onClick="javascript: if ( fnProcessRechazo() ){ if (window.inhabilitarValidacion) inhabilitarValidacion(); return true; }else{ return false;}">
			<input type="button" name="btnRegresar" value="Ir a Lista" onClick="javascript: location.href='Traslados-lista.cfm';">
		</td>
	</tr>
	<tr>
	  	<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
	  	<td colspan="4" class="tituloAlterno">Detalle de Documento de Traslado de Presupuesto</td>
	</tr>
	<cfoutput query="rsTraslado">
		<cfquery name="rsPartidasOrigen" datasource="#Session.DSN#">
			select a.CPDDid, a.CPDEid, a.CPDDlinea, a.CPDDtipo, a.CPCano, a.CPCmes, a.CPcuenta, a.CPDDmonto, 
				   coalesce(a.CPDDpeso, 0) as CPDDpeso, b.CPformato, coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
				   a.CPPid
			from CPDocumentoD a
				inner join CPresupuesto b
					on b.CPcuenta = a.CPcuenta
			where a.CPPid = #Form.CPPid#
			  and a.CPDEid = #rsTraslado.CPDEid#
			  and b.Ecodigo = #Session.Ecodigo#
			  and a.CPDDtipo = -1
			order by a.CPDDlinea
		</cfquery>
		<cfquery name="rsPartidasDestino" datasource="#Session.DSN#">
			select a.CPDDid,a.CPDEid, a.CPDDlinea, a.CPDDtipo, a.CPCano, a.CPCmes, a.CPcuenta, a.CPDDmonto, 
				   coalesce(a.CPDDpeso, 0) as CPDDpeso, b.CPformato, coalesce(b.CPdescripcionF,b.CPdescripcion) as CPdescripcion,
				   a.CPPid
			from CPDocumentoD a
				inner join CPresupuesto b
					on b.CPcuenta = a.CPcuenta
			where a.CPPid = #Form.CPPid#
			  and a.CPDEid = #rsTraslado.CPDEid#
			  and b.Ecodigo = #Session.Ecodigo#
			  and a.CPDDtipo = 1
			order by a.CPDDlinea
		</cfquery>
	<tr><td colspan="4"><cf_web_portlet_start titulo="#CPDEdescripcion#">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="4" align="center"><strong>No. Documento:</strong>&nbsp;#rsTraslado.CPDEnumeroDocumento#&nbsp;&nbsp;&nbsp;
			&nbsp;&nbsp;&nbsp;<strong>Fecha Doc:</strong>&nbsp;#DateFormat(rsTraslado.CPDEfechaDocumento, 'dd/mm/yyyy')#
			&nbsp;&nbsp;&nbsp;<strong>A&ntilde;o:</strong>&nbsp;#rsTraslado.CPCano#
			&nbsp;&nbsp;&nbsp;<strong>Mes:&nbsp;</strong>#ListGetAt(meses, rsTraslado.CPCmes, ',')#
			&nbsp;&nbsp;&nbsp;<strong>Base Traslado:</strong> <cfif rsTraslado.CPDEtipoAsignacion EQ 2> Asignaci&oacute;n manual de montos<cfelseif rsTraslado.CPDEtipoAsignacion EQ 1>Distribuci&oacute;n equitativa <cfelseif rsTraslado.CPDEtipoAsignacion EQ 3>Distribuci&oacute;n por pesos</cfif>
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap class="fileLabel">Cuenta:</td></td>
			<td nowrap>
			<input name="cuenta#rsTraslado.CPDEid#" type="text" style="font-weight: bold; border: none; color:##0000FF; width: 100%" readonly>
			</td>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
			<td nowrap>
			<input name="mensaje#rsTraslado.CPDEid#" type="text" style="font-weight: bold; border: none; color:##FF0000; width: 100%" readonly>
			</td>
		</tr>
		<tr>
			<td width="50%" colspan="2" style="padding-right: 2px; " valign="top">
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="4" align="center"><strong>Centro Funcional Origen:&nbsp;</strong>#rsTraslado.CFcodigoOrigen#-#rsTraslado.CFdescripcionOrigen#</td>
				</tr>
				<tr>
					<td colspan="4" align="center"><strong>Partidas Origen</strong></td></td>
				</tr>
				<tr>
					<td width="1%">&nbsp;</td><td nowrap><strong>Cuenta Presupuesto</strong></td><td nowrap><strong>Descripción</strong></td><td align="right" nowrap><strong>Monto</strong></td>
				</tr>
				<cfset i = 1>
				<cfloop query="rsPartidasOrigen">
				<tr>
					<td height="25" align="right">
						#i#.<input type="hidden" name="O_CPcuenta#rsPartidasOrigen.CPDDid#" value="#rsPartidasOrigen.CPcuenta#">
					</td>
					<td height="25" nowrap>
						<input type="text" name="O_CPformato#rsPartidasOrigen.CPDDid#" value="#trim(rsPartidasOrigen.CPformato)#" size="30" tabindex="-1" readonly>
					</td>
					<td height="25" nowrap>
						<input type="text" name="O_CPdescripcion#rsPartidasOrigen.CPDDid#" value="#rsPartidasOrigen.CPdescripcion#" size="30" tabindex="-1" readonly>
					</td>
					<td height="25" nowrap align="right">
						<cfinvoke component="sif.Componentes.PRES_Presupuesto" 
							method="CalculoDisponible"
							returnvariable="LvarDisponible">
							<cfinvokeargument name="CPPid" value="#rsPartidasOrigen.CPPid#">
							<cfinvokeargument name="CPCano" value="#rsPartidasOrigen.CPCano#">
							<cfinvokeargument name="CPCmes" value="#rsPartidasOrigen.CPCmes#">
							<cfinvokeargument name="CPcuenta" value="#rsPartidasOrigen.CPcuenta#">
							<cfinvokeargument name="Ocodigo" value="#rsTraslado.OcodigoOrigen#">
							<cfinvokeargument name="TipoMovimiento" value="T">
							<cfinvokeargument name="Conexion" value="#Session.DSN#">
							<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
						</cfinvoke>
						<input type="hidden" name="O_disponible#rsPartidasOrigen.CPDDid#" value="#LvarDisponible.Disponible#">
						<cfif LvarDisponible.CPCPtipoControl EQ "0">
							<input type="hidden" name="O_validarDisponible#rsPartidasOrigen.CPDDid#" value="0">
							<input type="hidden" name="O_mensaje#rsPartidasOrigen.CPDDid#" value="Control Abierto, Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
						<cfelseif LvarDisponible.Disponible LTE 0>
							<input type="hidden" name="O_validarDisponible#rsPartidasOrigen.CPDDid#" value="1">
							<input type="hidden" name="O_mensaje#rsPartidasOrigen.CPDDid#" value="No tiene Presupuesto Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
						<cfelse>
							<input type="hidden" name="O_validarDisponible#rsPartidasOrigen.CPDDid#" value="1">
							<input type="hidden" name="O_mensaje#rsPartidasOrigen.CPDDid#" value="Máximo Disponible: #LSNumberFormat(LvarDisponible.Disponible, ',9.00')#">
						</cfif>
						<input type="text" name="O_CPDDmonto#rsPartidasOrigen.CPDDid#" size="20" maxlength="18" 
							onFocus="this.value=qf(this); this.select(); this.form.mensaje#rsTraslado.CPDEid#.value = this.form.O_mensaje#rsPartidasOrigen.CPDDid#.value; this.form.cuenta#rsTraslado.CPDEid#.value = this.form.O_CPformato#rsPartidasOrigen.CPDDid#.value + ' ' + this.form.O_CPdescripcion#rsPartidasOrigen.CPDDid#.value;" 
							onBlur="javascript: fm(this,2);" 
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							style="text-align: right;" 
							value="#LSNumberFormat(rsPartidasOrigen.CPDDmonto,',9.00')#" readonly>
					</td>
				</tr>
				<cfset i = i + 1>
				</cfloop>			
				</table>
			</td>
			<td width="50%" colspan="2" style="padding-right: 2px; " valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				<tr >
					<td colspan="4" align="center"><strong>Centro Funcional Destino:&nbsp;</strong>#rsTraslado.CFcodigoDestino#-#rsTraslado.CFdescripcionDestino#</td></td>
				</tr>
				<tr>
					<td colspan="4" align="center"><strong>Partidas Destino</strong></td></td>
				</tr>
				<tr>
					<td width="1%">&nbsp;</td><td nowrap><strong>Cuenta Presupuesto</strong></td><td nowrap><strong>Descripción</strong></td><td align="right" nowrap><strong>Monto</strong></td>
				</tr>
				<cfset i = 1>
				<cfloop query="rsPartidasDestino">
				<tr>
					<td height="25" align="right">
						#i#.<input type="hidden" name="D_CPcuenta#rsPartidasDestino.CPDDid#" value="#rsPartidasDestino.CPcuenta#">
					</td>
					<td height="25" nowrap>
						<input type="text" name="D_CPformato#rsPartidasDestino.CPDDid#" value="#rsPartidasDestino.CPformato#" size="30" tabindex="-1" readonly>
					</td>
					<td height="25" nowrap>
						<input type="text" name="D_CPdescripcion#rsPartidasDestino.CPDDid#" value="#rsPartidasDestino.CPdescripcion#" size="30" tabindex="-1" readonly>
					</td>
					<td height="25" align="right" nowrap>
						<input type="text" name="D_CPDDmonto#rsPartidasDestino.CPDDid#" size="20" maxlength="18" 
							onFocus="this.value=qf(this); this.select(); this.value=qf(this); this.select(); this.form.mensaje#rsTraslado.CPDEid#.value = ''; this.form.cuenta#rsTraslado.CPDEid#.value = '';" 
							onBlur="javascript: fm(this,2);" 
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
							style="text-align: right;" 
							value="#LSNumberFormat(rsPartidasDestino.CPDDmonto,',9.00')#" readonly>
					</td>
				</tr>
				<cfset i = i + 1>
				</cfloop>
				</table>
			</td>
		</tr></table>
	  	<cf_web_portlet_end>
	</td></tr><tr><td colspan="4">&nbsp;</td></tr></cfoutput>
</table>
</form>

<script language="JavaScript">

	function fnProcessRechazo(){
		var vReason = prompt('¿Está seguro(a) de que desea RECHAZAR este documento de traslado de presupuesto?, Debe digitar una razón de rechazo!','');
		if (vReason && vReason != ''){
			document.form1.CPDEmsgrechazo.value = vReason;
			return true;
		}
		if (vReason == '')
			alert('Debe digitar una razón de rechazo!');
		return false;
	}

</script>
<cf_web_portlet_end>
<cf_templatefooter>