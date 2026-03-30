<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrASQLConciLibre="SQLConciliacion-Libre.cfm">
<cfset LvarIrAConciliacion="Conciliacion.cfm">
<cfset LvarIrAConciLibre="Conciliacion-Libre.cfm">
<cfset LvarIrAListaPreConci="listaPreConciliacion.cfm">
<cfset LvarIrAConciliAcumula="ConciliacionAcumulador.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfset LvarIrAMenu="/cfmx/sif/mb/MenuMB.cfm">

<cfif isdefined("LvarTCEFormConciliacionLibre")>
	<cfset LvarIrAConciLibre="TCEConciliacion-Libre.cfm">
	<cfset LvarIrAListaPreConci="TCElistaPreConciliacion.cfm">
	<cfset LvarIrAConciliAcumula="TCEConciliacionAcumulador.cfm">
	<cfset LvarIrASQLConciLibre="TCESQLConciliacion-Libre.cfm">
 	<cfset LvarIrAConciliacion="TCEConciliacion.cfm">
	<cfset LvarIrAlistECP="listaEstadosCuentaProcesoTCE.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
	<cfset LvarIrAMenu="/cfmx/sif/tce/MenuTCE.cfm">

</cfif>

<!--- JARR se agrego el filtro por estado P --->

<cfquery name="rsEstadosCuenta" datasource="#Session.DSN#">
	select a.ECid, a.ECdescripcion, c.Bdescripcion, b.CBdescripcion,a.Bid
	from ECuentaBancaria a, CuentasBancos b, Bancos c
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.EChistorico  IN ('N','P')
	  and a.CBid = b.CBid
	  and b.Bid = c.Bid
	  <!---Tarjeta de Credito 1 o CuentasBancarias 0--->
      and b.CBesTCE = #LvarCBesTCE#
	order by a.ECid
</cfquery>

<cfif rsEstadosCuenta.RecordCount EQ 0>
	<script>alert("No hay Estados de Cuenta por conciliar");</script>

	<!---Redireccion MenuMB.cfm o MenuTCE (TCE)--->
	<cflocation url="#LvarIrAMenu#" addtoken="no">
</cfif>

<cfif isdefined('url.msg') and url.msg EQ 1>
	<script>alert('La suma de los Débitos-Créditos de los documentos no coinciden');</script>
</cfif>

<!--- filtro de seleccionadps JCRUZ --->
<cfset filtroDefault = false>
<cfif IsDefined("url.FiltroSelectB")>
	<cfset form.FiltroSelectB="1">
</cfif>
<cfif IsDefined("url.FiltroSelectL")>
	<cfset form.FiltroSelectL="1">
</cfif>
<cfif isDefined("Form.optFecha") or isDefined("url.optFecha")>
<cfset Form.optFecha="">
	<cfset filtroLibros = " a.CDLfecha">
	<cfset filtroBancos = " a.CDBfechabanco">
<cfelseif isDefined("Form.optNumDoc") or isDefined("url.optNumDoc")>
<cfset Form.optNumDoc="">
	<cfset filtroLibros = " a.CDLdocumento">
	<cfset filtroBancos = " a.CDBdocumento">
<cfelseif isDefined("Form.optTipoDoc_NumDoc") or isDefined("url.optTipoDoc_NumDoc")>
<cfset Form.optTipoDoc_NumDoc="">
	<cfset filtroLibros = " b.BTdescripcion, a.CDLdocumento">
	<cfset filtroBancos = " tb.BTEdescripcion, a.CDBdocumento">
<cfelseif isDefined("Form.optTipoDoc_Fecha") or isDefined("url.optTipoDoc_Fecha")>
<cfset Form.optTipoDoc_Fecha="">
	<cfset filtroLibros = " a.CDLfecha ,b.BTdescripcion ">
	<cfset filtroBancos = "  a.CDBfechabanco , tb.BTEdescripcion">
<cfelseif isDefined("Form.optMonto") or isDefined("url.optMonto")>
<cfset Form.optMonto="">
	<cfset filtroLibros = " a.CDLmonto">
	<cfset filtroBancos = " a.CDBmonto">
<cfelse>
	<cfset filtroLibros = " a.CDLfecha">
	<cfset filtroBancos = " a.CDBfechabanco ">
	<cfset filtroDefault = true>
</cfif>

<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid))>
	<cfset ECid = Form.ECid>
<cfelse>
	<cfset ECid = rsEstadosCuenta.ECid>
</cfif>

<cfquery name="rsEstadoDeCuenta" datasource="#Session.DSN#">
	select a.ECid,
		a.ECdescripcion, <!--- estado de cuenta --->
		c.Bdescripcion, <!--- banco --->
		b.CBdescripcion, <!--- cuenta bancaria --->
		d.Cformato,  <!--- formato de cuenta --->
		a.Bid,
		a.CBid,
		coalesce(a.ECdesde, <cf_dbfunction name="now"> ) as ECdesde,
		coalesce(a.EChasta, <cf_dbfunction name="now"> ) as EChasta
	from ECuentaBancaria a, CuentasBancos b, Bancos c, CContables d
	where b.Ecodigo = #Session.Ecodigo#
	<!---Tarjeta de Credito 1 o CuentasBancarias 0--->
      and b.CBesTCE = #LvarCBesTCE#
	  and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	  and a.CBid = b.CBid
	  and b.Bid = c.Bid
	  and b.Ccuenta = d.Ccuenta
</cfquery>
<!--- JARR obtnenmos el id del banco --->
<cfset LvarBancoID = rsEstadoDeCuenta.Bid>
<cfset LvarCtaBancoID = rsEstadoDeCuenta.CBid>
<cfset vieneFiltro = false >
<cfif isDefined("Form.optFecha") or isDefined("Form.optNumDoc") or isDefined("Form.optTipoDoc_NumDoc")
	or isDefined("Form.optTipoDoc_Fecha") or isDefined("Form.optMonto")>
	<cfset vieneFiltro = true >
</cfif>


<cfquery name="rsBTransacciones" datasource="#session.DSN#" >
	select BTid, BTdescripcion
	from BTransacciones b
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	<!--- and exists ( select 1
				 from BTransaccionesEq a
				 where a.BTid= b.BTid
				    and a.Ecodigo=b.Ecodigo
					and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoDeCuenta.Bid#"> ) --->
</cfquery>

<cfquery name="rsTransaccionesB" datasource="#session.DSN#">
	select Bid,BTEcodigo,BTEdescripcion
	from TransaccionesBanco
	where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoDeCuenta.Bid#">
</cfquery>

<cfquery datasource="#session.dsn#" name="Periodo">
	select Pvalor from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 50
</cfquery>
<cfquery datasource="#session.dsn#" name="mes">
	select Pvalor from Parametros
	where Ecodigo = #session.Ecodigo#
	  and Pcodigo = 60
</cfquery>
<!--- JARR Se obtiene el mes de axuliares --->
<cfif mes.Pvalor eq 12>
	<cfset lvarAnoMes = CreateDate((Periodo.Pvalor+1), 1,1)>
<cfelse>
	<cfset lvarAnoMes = CreateDate((Periodo.Pvalor), (mes.Pvalor+1),1)>
</cfif>
<!---
<cfset fecha_maxima = createdate( datePart('yyyy', rsEstadoDeCuenta.EChasta), datepart('m', rsEstadoDeCuenta.EChasta), datepart('d', rsEstadoDeCuenta.EChasta) )>
<cfset fecha_maxima = dateadd('d', 1, fecha_maxima ) > --->


<!--- JARR 23/07/2018 Se quito el filtro del ECid para poder ver los
movimientos anteriores a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">--->
<!--- JARR 24072018 se agrego el filtro por banco --->
<cfset fecha_maxima = DateFormat(lvarAnoMes, "mmm-dd-yyyy")>
<cfquery name="rsMovLibrosNoConc" datasource="#Session.DSN#" maxrows="1000">
	select rtrim(BTcodigo) as BTcodigo,
		BTdescripcion,a.MLid,a.CDLacumular, CDLUsucodigo,
		c.MLreferencia as referencia,
		Pid,Pnombre,Papellido1,
		a.*
	from CDLibros a

	inner join BTransacciones b
	   on b.BTid = a.CDLidtrans
	  and a.CDLconciliado <> 'S'
	  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	inner join MLibros c
	   on a.MLid = c.MLid
	  	and c.Bid=#LvarBancoID#
		and c.CBid=#LvarCtaBancoID#
	left join Usuario d
		on a.CDLUsucodigo= d.Usucodigo
	left join DatosPersonales e
	on d.datos_personales = e.datos_personales

	where 1=1

	<cfif isdefined('form.BTid') and form.BTid NEQ -1>
	  and a.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
	</cfif>

	and CDLfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha_maxima#">

	<cfif isdefined("form.flDesc") and len(trim(form.flDesc)) >
	  	and upper(CDLdocumento) like '%#ucase(form.flDesc)#%'
	  </cfif>

	  <cfif isdefined("form.FLRef") and len(trim(form.FLRef)) >
	  	and upper(c.MLreferencia) like '%#ucase(form.FLRef)#%'
	  </cfif>

	  <cfif isdefined("form.flFecha") and len(trim(form.flFecha)) >
	  	and CDLfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.flFecha)#">
	  </cfif>

	 <cfif isdefined("form.flDebitos") and len(trim(form.flDebitos)) >
	 	and (CDLtipomov = 'D' and
		CDLmonto = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.flDebitos,",","","All")#"> )
	  </cfif>

	   <cfif isdefined("form.flCreditos") and len(trim(form.flCreditos)) >
	  	and	(CDLtipomov = 'C' and
		CDLmonto = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.flCreditos,",","","All")#"> )
	  </cfif>
	  <!--- filtrar solo los seleccionados--->
	  <cfif IsDefined("form.FiltroSelectL")>
		and a.CDLacumular = 1
	  </cfif>

	order by BTcodigo,#filtroLibros#
</cfquery>
<cfquery name="montoCDL" dbtype="query">
	select sum(CDLmonto) as CDLmonto from  rsMovLibrosNoConc where CDLacumular = 1
</cfquery>

<cfquery name="rsMovBancosNoConc" datasource="#Session.DSN#" maxrows="1000">
	select rtrim(a.BTEcodigo) as BTEcodigo,
		tb.BTEdescripcion,
		 c.DCReferencia,a.CDBlinea,a.CDBacumular,CDBUsucodigo,
		Pid,Pnombre,Papellido1,
		a.*
	from CDBancos a

	inner join TransaccionesBanco tb
	   on a.Bid = tb.Bid
	  and a.BTEcodigo = tb.BTEcodigo
	  and a.CDBconciliado <> 'S'
	  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

	inner join DCuentaBancaria c
		on c.Linea = a.CDBlinref
	left join Usuario d
		on a.CDBUsucodigo= d.Usucodigo
	left join DatosPersonales e
	on d.datos_personales = e.datos_personales

	where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	 <cfif isdefined('form.BTEcodigo')  and form.BTEcodigo NEQ -1>
	  and a.BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
	 </cfif>
	 <cfif isdefined("form.fbDesc") and len(trim(form.fbDesc)) >
	  	and upper(CDBdocumento) like '%#ucase(form.fbDesc)#%'
	 </cfif>
	 <cfif isdefined("form.fbReferencia") and len(trim(form.fbReferencia)) >
	  	and upper(ltrim(rtrim(DCReferencia))) like '%#ucase(form.fbReferencia)#%'
	 </cfif>
	 <cfif isdefined("form.fbFecha") and len(trim(form.fbFecha)) >
	  	and CDBfechabanco = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fbFecha)#">
	 </cfif>
	 <cfif isdefined("form.fbDebitos") and len(trim(form.fbDebitos)) >
	 	and (CDBtipomov = 'D' and
		CDBmonto = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.fbDebitos,",","","All")#"> )
	 </cfif>
	 <cfif isdefined("form.fbCreditos") and len(trim(form.fbCreditos)) >
	  	and	(CDBtipomov = 'C' and
		CDBmonto = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.fbCreditos,",","","All")#"> )
	 </cfif>
	 <!--- filtrar solo los seleccionados--->
	  <cfif IsDefined("form.FiltroSelectB")>
		and a.CDBacumular = 1
	  </cfif>
	order by a.BTEcodigo, #filtroBancos#
</cfquery>



<cfquery name="rsMontoL" datasource="#session.DSN#">
	select round(coalesce((sum(case  L.CDLtipomov when 'D' then  L.CDLmonto else 0 end) - sum(case  L.CDLtipomov when 'C' then  L.CDLmonto else 0 end)),0.00),2) as sumaDCL
	from CDLibros L
	where  1=1
	  and  L.CDLacumular = 1
	  and  L.CDLUsucodigo=#session.Usucodigo#
	  and L.CDLconciliado <> 'S'
	  and not exists(
		select M.MLid from MLibros M
		where  M.MLconciliado = 'S'
		and  M.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		and M.MLid=L.MLid
	  )
</cfquery>
<cfif rsMontoL.sumaDCL EQ 0 >
	<cfset rsMontoL.sumaDCL=montoCDL.CDLmonto >
</cfif>
<cfquery name="rsMontoB" datasource="#session.DSN#">
	select coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
	sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00) as sumaDCB
	from CDBancos
	where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	  and CDBacumular = 1
	  and CDBUsucodigo=#session.Usucodigo#
	  and BTid is null
	  and CDBconciliado <> 'S'
</cfquery>


<style type="text/css">
<!--
.style12 {font-size: 10px}
.style14 {font-size: 10px; font-weight: bold; }
.styleCaja{border-color:E2E2E2; background-color:E2E2E2;color:990000;font-size:14px;text-align:right;font-weight:bold;}
-->
</style>


<form name="frmGO" action="" method="post" style="margin: 0; ">
	<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
</form>

<!---Redireccion SQLConciliacion-Libre.cfm o TCESQLConciliacion-Libre.cfm(TCE)--->
<form action="<cfoutput>#LvarIrASQLConciLibre#</cfoutput>" method="post" name="form1">
<input name="numChkLibros" type="hidden" id="numChkLibros" value="">
<input name="numChkBancos" type="hidden" id="numChkBancos" value="">
<!--- <cfoutput>#LvarIrASQLConciLibre#</cfoutput> --->
	<table width="100%" border="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><span style="font-size:10px"><strong>Cuenta:</strong></span></td>
			<td nowrap>
				<span style="font-size:10px">
					<cfif isDefined("Form.ECid")>
						<cfoutput>#rsEstadoDeCuenta.Bdescripcion#: #rsEstadoDeCuenta.CBdescripcion#</cfoutput>
					<cfelse>
						<cfoutput>#rsEstadosCuenta.getField(1,3)#: #rsEstadosCuenta.getField(1,4)#</cfoutput>
					</cfif>
				</span>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap>
				<span style="font-size:10px"><cfoutput>#rsEstadoDeCuenta.ECdescripcion#</cfoutput></span>
				<input name="ECid" type="hidden" value="<cfoutput><cfif isdefined('Form.ECid') and LEN(Form.ECid) GT 0>#Form.ECid#</cfif></cfoutput>">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><span style="font-size:10px"><strong>Ordenar listas por:</strong></span></td>
			<td valign="bottom" nowrap>
				<input type="radio" name="optFecha" value="" <cfif isDefined("Form.optFecha") or filtroDefault> checked </cfif>
					onClick="javascript:
					document.form1.optNumDoc.checked=false;
					document.form1.optTipoDoc_NumDoc.checked=false;
					document.form1.optTipoDoc_Fecha.checked=false;
					document.form1.optMonto.checked=false;

					<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>';
					document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optFecha">
				<label for="optFecha"><span style="font-size:10px">Fecha</span></label>
				<input type="radio" name="optNumDoc" value="" <cfif isDefined("Form.optNumDoc") > checked </cfif>
					onClick="javascript:
					document.form1.optFecha.checked=false;
					document.form1.optTipoDoc_NumDoc.checked=false;
					document.form1.optTipoDoc_Fecha.checked=false;
					document.form1.optMonto.checked=false;

					<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>';
					document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optNumDoc">
				<label for="optNumDoc"><span style="font-size:10px"># Documento</span> </label>
				<input type="radio" name="optTipoDoc_NumDoc" value="" <cfif isDefined("Form.optTipoDoc_NumDoc") > checked </cfif>
					onClick="javascript:
					document.form1.optFecha.checked=false;
					document.form1.optNumDoc.checked=false;
					document.form1.optTipoDoc_Fecha.checked=false;
					document.form1.optMonto.checked=false;

					<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>';
			 		document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optTipoDoc_NumDoc">
				<label for="optTipoDoc_NumDoc"><span style="font-size:10px">Tipo y # Documento</span> </label>
				<input type="radio" name="optTipoDoc_Fecha" value="" <cfif isDefined("Form.optTipoDoc_Fecha") > checked </cfif>
					onClick="javascript:
					document.form1.optFecha.checked=false;
					document.form1.optNumDoc.checked=false;
					document.form1.optTipoDoc_NumDoc.checked=false;
					document.form1.optMonto.checked=false;

					<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>';
			 		document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optTipoDoc_Fecha">
				<label for="optTipoDoc_Fecha"><span style="font-size:10px">Tipo y Fecha del Documento</span> </label>
				<input type="radio" name="optMonto" value="" <cfif isDefined("Form.optMonto") > checked </cfif>
					onClick="javascript:
					document.form1.optFecha.checked=false;
					document.form1.optNumDoc.checked=false;
					document.form1.optTipoDoc_NumDoc.checked=false;
					document.form1.optTipoDoc_Fecha.checked=false;

					<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>';
 					document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optMonto">
				<label for="optMonto"><span style="font-size:10px">Monto</span></label>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<table width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td bgcolor="#A0BAD3">
				<table width="100%"  border="0">
					<tr>
						<td align="left">
							<input name="Agregar" type="submit" value="Asignar"
								onClick="javascript: if (!validaChecks()) {alert('Debe seleccionar al menos un documento.');return  false;}" >
							<input type="button" class="btnNormal"  tabindex="1" name="RegMB" value="RegistrarML"
                            onClick="javascript:VentanaRegMB(<cfoutput><cfif isdefined('ECid') and len(trim(#ECid#))>#ECid#</cfif></cfoutput>);">
						</td>
						<td align="right">
							<input type="button" name="Anterior" value="<< Anterior"
								onClick="javascript: funcRegresar();">
							<input type="button" name="Siguiente" value="Siguiente >>"
								onClick="javascript: funcSiguiente();" >
						</td>
				  	</tr>
				</table>
			</td>
		</tr>
	</table>
	<table width="100%" border="0">
		<tr>
			<td width="1%" ></td>
			<td width="50%" align="center" valign="top" class="tituloListas">Movimientos de Libros</td>
			<td width="49%" align="center" class="tituloListas">Movimientos de Bancos</td>
		</tr>
      	<tr class="subTitulo">
			<td>&nbsp;</td>
      		<td valign="top">
        		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td colspan="6">
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td align="right" nowrap><span style="font-size:10px"><strong>Filtrar por:</strong></span></td>
									<td>


										<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
 										<select name="BTid" onChange="document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>'; document.form1.submit();	">
											<option value="-1">--- Todas --</option>
											<cfoutput query="rsBTransacciones">
												<option value="#rsBTransacciones.BTid#" <cfif isdefined('form.BTid') and BTid EQ form.BTid>selected</cfif>>
													<span style="font-size:10px">#rsBTransacciones.BTdescripcion#</span>												</option>
											</cfoutput>
										</select>
									</td>
								</tr>
							</table>
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td width="1%" nowrap="nowrap"><strong>Documento</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Referencia</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Fecha</strong></td>
									<td width="1%" nowrap="nowrap"><strong>D&eacute;bitos</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Cr&eacute;ditos</strong></td>
									<td width="1%" align="center" nowrap="nowrap"><strong style="font-size:10px;">Seleccionados</strong></td>
									<td rowspan="2">
										<input type="submit" name="Filtrar" value="Filtrar" onclick="this.form.action='';"  align="center"/>
									</td>
								</tr>
								<tr>
									<td align="left"><input type="text" name="flDesc" maxlength="80" size="7"
										value="<cfif isdefined('form.flDesc') and len(trim(form.flDesc)) ><cfoutput>#form.flDesc#</cfoutput></cfif>" />
									</td>
									<td align="left"><input type="text" name="FLRef" maxlength="80" size="7"
										value="<cfif isdefined('form.FLRef') and len(trim(form.FLRef)) ><cfoutput>#form.FLRef#</cfoutput></cfif>" />
									</td>
										<cfset lfecha = '' >
										<cfif isdefined('form.flFecha') and len(trim(form.flFecha)) >
											<cfset lfecha = form.flFecha >
										</cfif>
									<td>
										<cf_sifcalendario name="flFecha" value="#lfecha#" >
									</td>
									<td>
										<cfif isdefined('form.flDebitos') and len(trim(form.flDebitos))>
											<cf_inputNumber name="flDebitos"  size="7" enteros="1000" decimales="2" comas= "true" value="#replace(form.flDebitos,",","","All")#">
										<cfelse>
											<cf_inputNumber name="flDebitos"  size="7" enteros="1000" decimales="2" comas= "true">
										</cfif>
									</td>
									<td>
										<cfif isdefined('form.flCreditos') and len(trim(form.flCreditos))>
											<cf_inputNumber name="flCreditos"  size="7" enteros="1000" decimales="2" comas= "true" value="#replace(form.flCreditos,",","","All")#">
										<cfelse>
											<cf_inputNumber name="flCreditos"  size="7" enteros="1000" decimales="2" comas= "true">
										</cfif>
									</td>
									<td align="center">
										<input type="checkbox" name="FiltroSelectL" <cfif IsDefined("form.FiltroSelectL")>checked="checked"</cfif> value="1">
									</td>
								</tr>
							</table>
						</td>
		  			</tr>
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td colspan="6">
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td align="left" nowrap><span style="font-size:10px"><strong>Total en Documentos Seleccionados:</strong></span></td>
									<td>
										<cfoutput><input type="text" name="totalLibros" id="totalLibros" class="styleCaja" readonly="true" value="#LSNumberFormat(rsMontoL.sumaDCL,'9,9.99')#" /></cfoutput>
									</td>
								</tr>
							</table>
						</td>
		  			</tr>
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td width="5%" nowrap="nowrap"class="style12">
						<cfoutput>
							<input name="chkTodosLibros" type="checkbox" value="" border="1"
								onClick="fnAcumular(this,'#ECid#',-1);"
								style="border:0; background:background-color "
								id="chkTodosLibros" alt="Seleccionar Todos" title="Seleccionar Todos">
						</cfoutput>
						</td>
						<td width="25%" align="left"><span class="style14">Documento</span></td>
						<td width="20%" align="left"><span class="style14">Referencia</span></td>
						<td width="10%" align="center"><span class="style14">Fecha</span></td>
						<td width="20%" align="right"><div align="right" class="style14">D&eacute;bitos</div></td>
						<td width="20%" align="right"><div align="right" class="style14">Cr&eacute;ditos</div></td>
					</tr>
					<cfset cuantosRegLibros = 0 >
					<cfset transNoConc = ''>
					<cfif rsMovLibrosNoConc.recordcount eq 0>
						<cfset lvarMarcarTodosL = false>
					<cfelse>
						<cfset lvarMarcarTodosL = true>
					</cfif>
					<cfoutput query="rsMovLibrosNoConc">
						<cfif rsMovLibrosNoConc.BTcodigo NEQ transNoConc>
							<cfif LEN(TRIM(transNoConc))>
								<tr><td width="100%" colspan="6">&nbsp;</td></tr>
							</cfif>
							<tr height="15" bgcolor="F0F0F0">
								<td width="100%" colspan="6"><span class="style12">&nbsp;<strong>#rsMovLibrosNoConc.BTdescripcion#</strong></span></td>
							</tr>
							<cfset transNoConc = rsMovLibrosNoConc.BTcodigo>
						</cfif>
						<tr <cfif rsMovLibrosNoConc.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
							<td width="5%" title="Referencia: #trim(referencia)# Usuario: #rsMovLibrosNoConc.Pnombre# #rsMovLibrosNoConc.Papellido1# cedula: #rsMovLibrosNoConc.Pid#" nowrap>
								<input name='chkLibros' type='checkbox' <cfif #rsMovLibrosNoConc.CDLacumular# eq 1> checked="checked"<cfelse><cfset lvarMarcarTodosL = false> </cfif>
									style="border:0;  background:background-color"
									<cfif #rsMovLibrosNoConc.CDLUsucodigo# eq #Session.Usucodigo# or not len(trim('#rsMovLibrosNoConc.CDLUsucodigo#'))> <cfelse>disabled="disabled"</cfif>
									onClick="fnAcumular(this,'#ECid#','#rsMovLibrosNoConc.MLid#');javascript:document.form1.chkTodosLibros.checked= false;"
									value='#rsMovLibrosNoConc.ECid#|#rsMovLibrosNoConc.MLid#|#Replace(Replace(rsMovLibrosNoConc.BTcodigo,"|","1","All"),","," ","All")#|#Replace(Replace(rsMovLibrosNoConc.CDLdocumento,"|","1","All"),","," ","All")#|#rsMovLibrosNoConc.CDLfecha#|#rsMovLibrosNoConc.CDLmonto#|#rsMovLibrosNoConc.CDLtipomov#'>							</td>
							<td width="25%" title="Referencia: #referencia#" nowrap><span class="style12">#rsMovLibrosNoConc.CDLdocumento#</span></td>
							<td width="20%" title="Referencia: #referencia#" alt="Referencia: #referencia#" nowrap><span class="style12">#mid(referencia, 1, 15)#</span></td>
							<td width="10%" title="Referencia: #referencia#" align="center" nowrap><span class="style12">#LSDateFormat(rsMovLibrosNoConc.CDLfecha,'dd/mm/yyyy')#</span></td>
							<td width="20%" title="Referencia: #referencia#" align="right" nowrap>
								<cfif rsMovLibrosNoConc.CDLtipomov EQ 'D'>
									<span class="style12">#LSCurrencyFormat(rsMovLibrosNoConc.CDLmonto, "none")#</span>
								</cfif>
							</td>
							<td width="20%" title="Referencia: #referencia#" align="right" nowrap>
								<cfif rsMovLibrosNoConc.CDLtipomov EQ 'C'>
									<span class="style12">#LSCurrencyFormat(rsMovLibrosNoConc.CDLmonto, "none")#</span>
								</cfif>
							</td>
						</tr>
						<cfset cuantosRegLibros = cuantosRegLibros + 1 >
          			</cfoutput>
        		</table>
			</td>

      		<td valign="top">
        		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">

					<tr bgcolor="#E2E2E2" height="20">
						<td colspan="6">
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td align="right" nowrap><span style="font-size:10px"><strong>Filtrar por:</strong></span></td>
									<td>

										 <!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm(TCE)--->
 										<select name="BTEcodigo" onChange="document.form1.action = '<cfoutput>#LvarIrAConciLibre#</cfoutput>'; document.form1.submit();	">
											<option value="-1">--- Todas --</option>
											<cfoutput query="rsTransaccionesB">
												<option value="#BTEcodigo#" <cfif isdefined('form.BTEcodigo') and BTEcodigo EQ form.BTEcodigo>selected</cfif>>
													<span style="font-size:10px">#BTEdescripcion#</span>
												</option>
											</cfoutput>
										</select>
									</td>
								</tr>
							</table>
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td width="1%" nowrap="nowrap"><strong>Documento</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Referencia</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Fecha</strong></td>
									<td width="1%" nowrap="nowrap"><strong>D&eacute;bitos</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Cr&eacute;ditos</strong></td>
									<td width="1%" align="center" nowrap="nowrap"><strong style="font-size:10px;">Seleccionados</strong></td>
									<td rowspan="2"><input type="submit" name="Filtrar" value="Filtrar" onclick="this.form.action='';" /></td>
								 </tr>
								 <tr>
								 	<td align="left"><input type="text"   name="fbDesc" maxlength="80" size="15"
										value="<cfif isdefined('form.fbDesc') and len(trim(form.fbDesc)) ><cfoutput>#form.fbDesc#</cfoutput></cfif>" />
									</td>
									<td align="left"><input type="text"   name="fbReferencia" maxlength="80" size="15"
										value="<cfif isdefined('form.fbReferencia') and len(trim(form.fbReferencia)) ><cfoutput>#form.fbReferencia#</cfoutput></cfif>" />
									</td>
										<cfset bfecha = '' >
										<cfif isdefined('form.fbFecha') and len(trim(form.fbFecha)) >
											<cfset bfecha = form.fbFecha >
										</cfif>
									<td>
										<cf_sifcalendario name="fbFecha" value="#bfecha#" >
									</td>
									<td>
										<cfif isdefined('form.fbDebitos') and len(trim(form.fbDebitos))>
											<cf_inputNumber name="fbDebitos"  size="7" enteros="1000" decimales="2" comas= "true" value="#replace(form.fbDebitos,",","","All")#">
										<cfelse>
											<cf_inputNumber name="fbDebitos"  size="7" enteros="1000" decimales="2" comas= "true">
										</cfif>
									</td>
									<td>
										<cfif isdefined('form.fbCreditos') and len(trim(form.fbCreditos))>
											<cf_inputNumber name="fbCreditos"  size="7" enteros="1000" decimales="2" comas= "true" value="#replace(form.fbCreditos,",","","All")#">
										<cfelse>
											<cf_inputNumber name="fbCreditos"  size="7" enteros="1000" decimales="2" comas= "true">
										</cfif>
									</td>
									<td align="center">
										<input type="checkbox" name="FiltroSelectB" <cfif IsDefined("form.FiltroSelectB")>checked="checked"</cfif> value="1">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td colspan="6">
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td align="left" nowrap><span style="font-size:10px"><strong>Total en Documentos Seleccionados:</strong></span></td>
									<td>
										<cfoutput><input type="text" name="totalBancos" id="totalBancos" readonly="true" class="styleCaja" value="#LSNumberFormat(rsMontoB.sumaDCB,'9,9.99')#" /></cfoutput>
									</td>
								</tr>
							</table>
						</td>
		  			</tr>
					<tr bgcolor="#E2E2E2" height="20">
						<td class="style12" width="5%">
							<cfoutput>
								<input name="chkTodosBancos" type="checkbox" value="" border="1" onClick="fnAcumular(this,'#ECid#',-1);"
								style="border:0; background:background-color "
								id="chkTodosBancos" alt="Seleccionar Todos" title="Seleccionar Todos">
							</cfoutput>
						</td>

						<td width="23%" align="left"><span class="style14">Documento</span></td>
						<td width="20%" align="left"><span class="style14">Referencia</span></td>
						<td width="10%"align="left"><span class="style14">Fecha</span></td>
						<td width="20%"align="right"><span class="style14">D&eacute;bitos</span></td>
						<td width="20%"align="right"><span class="style14">Cr&eacute;ditos</span></td>
					</tr>

					<cfset cuantosRegBancos = 0 >
					<cfset transNoConc = ''>
					<cfif rsMovBancosNoConc.recordcount eq 0>
						<cfset lvarMarcarTodosB = false>
					<cfelse>
						<cfset lvarMarcarTodosB = true>
					</cfif>
					<cfoutput query="rsMovBancosNoConc">
						<cfif rsMovBancosNoConc.BTEcodigo NEQ transNoConc>
							<cfif LEN(TRIM(transNoConc))>
								<tr><td colspan="6">&nbsp;</td></tr>
							</cfif>
							<tr height="15" bgcolor="F0F0F0">
								<td width="100%" colspan="6"><span class="style12">&nbsp;<strong>#rsMovBancosNoConc.BTEdescripcion#</strong></span></td>
							</tr>
							<cfset transNoConc = rsMovBancosNoConc.BTEcodigo>
						</cfif>
						<tr <cfif rsMovBancosNoConc.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
							<td width="5%" nowrap title="Referencia: #trim(DCReferencia)# Usuario: #rsMovBancosNoConc.Pnombre# #rsMovBancosNoConc.Papellido1# cedula: #rsMovBancosNoConc.Pid#">
								<input name='chkBancos' type='checkbox' <cfif #rsMovBancosNoConc.CDBacumular# eq 1> checked="checked" <cfelse><cfset lvarMarcarTodosB = false></cfif>
									 style="border:0; background:background-color"
									 <cfif #rsMovBancosNoConc.CDBUsucodigo# eq #Session.Usucodigo# or not len(trim('#rsMovBancosNoConc.CDBUsucodigo#'))> <cfelse>disabled="disabled"</cfif>
									onClick=" fnAcumular(this,#ECid#,#rsMovBancosNoConc.CDBlinea#); javascript:document.form1.chkTodosBancos.checked= false;"
									value='#rsMovBancosNoConc.ECid#|#rsMovBancosNoConc.CDBlinea#|#Replace(Replace(rsMovBancosNoConc.BTEcodigo,"|","1","All"),","," ","All")#|#Replace(Replace(rsMovBancosNoConc.CDBdocumento,"|","1","All"),","," ","All")#|#rsMovBancosNoConc.CDBfecha#|#rsMovBancosNoConc.CDBmonto#|#rsMovBancosNoConc.CDBtipomov#'>							</td>
							<td width="25%" title="Referencia: #DCReferencia#" nowrap><span class="style12">#rsMovBancosNoConc.CDBdocumento#</span></td>
							<td width="20%" title="Referencia: #DCReferencia#" align="left" nowrap><span class="style12"><cfif len(trim(DCReferencia)) gt 10>#mid(DCReferencia, 1, 15)#<cfelse>#trim(DCReferencia)#</cfif> </span></td>
							<td width="10%"title="Referencia: #DCReferencia#" align="left" nowrap><span class="style12">#LSDateFormat(rsMovBancosNoConc.CDBfechabanco,'dd/mm/yyyy')#</span></td>
							<td width="20%"title="Referencia: #DCReferencia#" align="right" nowrap>
								<cfif rsMovBancosNoConc.CDBtipomov EQ 'D'>
									<span class="style12">#LSCurrencyFormat(rsMovBancosNoConc.CDBmonto,"none")#</span>
								</cfif>
							</td>
							<td width="20%"title="Referencia: #DCReferencia#" align="right" nowrap>
								<cfif rsMovBancosNoConc.CDBtipomov EQ 'C'>
									<span class="style12">#LSCurrencyFormat(rsMovBancosNoConc.CDBmonto,"none")#</span>
								</cfif>
							</td>
						</tr>
						<cfset cuantosRegBancos = cuantosRegBancos + 1 >
          			</cfoutput>
        		</table>
			</td>
		</tr>
	</table>
	<table width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td bgcolor="#A0BAD3">
				<table width="100%"  border="0">
					<tr>
						<td align="left">
							<input name="Agregar" type="submit" value="Asignar"
							onClick="javascript: if (!validaChecks()) {alert('Debe seleccionar al menos un documento.');return  false;}" >
						</td>
						<td align="right">
							<input type="button" name="Anterior" value="<< Anterior" onClick="javascript: funcRegresar();" >
							<input type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: funcSiguiente();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<cfif rsMovBancosNoConc.recordcount gt 990 or rsMovLibrosNoConc.recordcount gt 990>
		<div align="center"><strong>Solo se muestran los primeros 1000 documentos de cada lista.</strong></div>
	</cfif>
</form>

<script language="JavaScript" type="text/javascript">

	function funcRegresar() {

		<!---Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
		document.frmGO.action='<cfoutput>#LvarIrAConciliacion#</cfoutput>';
		document.frmGO.submit();
	}

	function funcSiguiente() {
		<!---Redireccion listaPreConciliacion.cfm o TCElistaPreConciliacion.cfm(TCE)--->
		document.frmGO.action='<cfoutput>#LvarIrAListaPreConci#</cfoutput>';
		document.frmGO.submit();
	}

	function PreConciliacion(data) {
		<!---Redireccion listaPreConciliacion.cfm o TCElistaPreConciliacion.cfm(TCE)--->
		document.frmGO.action='<cfoutput>#LvarIrAListaPreConci#</cfoutput>';
	}


	function validaChecks() {
		return (validaChecksLibros() || validaChecksBancos());
	}

	function validaChecksLibros() {
		<cfif cuantosRegLibros NEQ 0>
			<cfif cuantosRegLibros EQ 1>
				if (document.form1.chkLibros.checked)
					return true;
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chkLibros.length; i++) {
					if (document.form1.chkLibros[i].checked) bandera = true;
				}
				if (bandera)
					return true;
			</cfif>
		<cfelse>
			alert("¡No existen documentos de Libros!");
		</cfif>
		return false;
	}

	function validaChecksBancos() {
		<cfif cuantosRegBancos NEQ 0>
			<cfif cuantosRegBancos EQ 1>
				if (document.form1.chkBancos.checked)
					return true;
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chkBancos.length; i++) {
					if (document.form1.chkBancos[i].checked) bandera = true;
				}
				if (bandera)
					return true;
			</cfif>
		<cfelse>
			alert("¡No existen documentos de Bancos!");
		</cfif>
		return false;
	}

<!--- Estas dos funciones eran llamadas del checktodosLibros y bancos para marcar o demarcar todos, pero se sustituye por fnAcumular
la cual llama un iFrame y realiza el trabajo pues se ocupa hacerlo en BD
		function MarcarLibros(c) {
		<cfif cuantosRegLibros GT 0>
		if (c.checked) {
			for (counter = 0; counter < document.form1.chkLibros.length; counter++)
			{
				if ((!document.form1.chkLibros[counter].checked) && (!document.form1.chkLibros[counter].disabled))
					{  document.form1.chkLibros[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chkLibros.disabled)) {
				document.form1.chkLibros.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chkLibros.length; counter++)
			{
				if ((document.form1.chkLibros[counter].checked) && (!document.form1.chkLibros[counter].disabled))
					{  document.form1.chkLibros[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chkLibros.disabled)) {
				document.form1.chkLibros.checked = false;
			}
		};
		</cfif>
	}

	function MarcarBancos(c) {
		<cfif cuantosRegBancos GT 0>
		if (c.checked) {
			for (counter = 0; counter < document.form1.chkBancos.length; counter++)
			{
				if ((!document.form1.chkBancos[counter].checked) && (!document.form1.chkBancos[counter].disabled))
					{  document.form1.chkBancos[counter].checked = true;}
			}
			if ((counter==0)  && (!document.form1.chkBancos.disabled)) {
				document.form1.chkBancos.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.form1.chkBancos.length; counter++)
			{
				if ((document.form1.chkBancos[counter].checked) && (!document.form1.chkBancos[counter].disabled))
					{  document.form1.chkBancos[counter].checked = false;}
			};
			if ((counter==0) && (!document.form1.chkBancos.disabled)) {
				document.form1.chkBancos.checked = false;
			}
		};
		</cfif>
	}--->

	function fnAcumular(detalle,ECid,ID){
		varSumaResta=detalle.checked;
		varNombre=detalle.name;
		varECid=ECid;
		varId=ID;

		var params= '';

		<cfif isdefined('form.BTid') and form.BTid NEQ -1>
			params= params+"&BTid=<cfoutput>#form.BTid#</cfoutput>";
		</cfif>
		<cfif isdefined("fecha_maxima") and len(trim(fecha_maxima)) >
			params= params+"&fecha_maxima=<cfoutput>#fecha_maxima#</cfoutput>";
		</cfif>
		<cfif isdefined("form.flDesc") and len(trim(form.flDesc)) >
			params= params+"&flDesc='<cfoutput>#form.flDesc#</cfoutput>'";
		</cfif>
		<cfif isdefined("form.FLRef") and len(trim(form.FLRef)) >
			params= params+"&FLRef='<cfoutput>#form.FLRef#</cfoutput>'";
		</cfif>
		<cfif isdefined("form.flFecha") and len(trim(form.flFecha)) >
		  	params= params+"&flFecha='<cfoutput>#form.flFecha#</cfoutput>'";
		</cfif>
		<cfif isdefined("form.flDebitos") and len(trim(form.flDebitos)) >
			params= params+"&flDebitos='<cfoutput>#form.flDebitos#</cfoutput>'";
		</cfif>
		<cfif isdefined("form.flCreditos") and len(trim(form.flCreditos)) >
			params= params+"&flCreditos='<cfoutput>#form.flCreditos#</cfoutput>'";
		</cfif>

		<cfif isdefined("LvarBancoID") and len(trim(LvarBancoID)) >
			params= params+"&LvarBancoID=<cfoutput>#LvarBancoID#</cfoutput>";
		</cfif>
		<cfif isdefined("LvarCtaBancoID") and len(trim(LvarCtaBancoID)) >
			params= params+"&LvarCtaBancoID=<cfoutput>#LvarCtaBancoID#</cfoutput>";
		</cfif>
		<!---Redireccion ConciliacionAcumulador.cfm o TCEConciliacionAcumulador.cfm(TCE) --->
		url = '<cfoutput>#LvarIrAConciliAcumula#</cfoutput>?SumaResta='+varSumaResta+'&Nombre='+varNombre+'&ECid='+varECid+'&id='+varId+params;

		ajax=fnAjax();
		ajax.open("GET", url,true);
		ajax.onreadystatechange=function(){
			if(ajax.readyState==1){
				//Sucede cuando se esta cargando la pagina
				//contenedor.innerHTML = "cargando()";//<-- Aca puede ir una precarga
			}else if(ajax.readyState==4){
				//Sucede cuando la pagina se cargó
				if(ajax.status==200){
					//Todo OK
					//contenedor.innerHTML = ajax.responseText;
					String.prototype.trim = function(){ return this.replace(/^\s+|\s+$/g,'') }
					v1= ajax.responseText.split('|')[0];
					v2= ajax.responseText.split('|')[1];
					if (v1.trim()=="actualizar"){
						if (confirm(v2.trim())){
							window.location.reload(true);
						}
					}
					else{
						if (varNombre =='chkTodosLibros' || varNombre == 'chkTodosBancos'){
							window.location.reload(true);
						}
						v1= ajax.responseText.split('|')[0];
						v2= ajax.responseText.split('|')[1];
						if (varNombre =='chkLibros'){
							document.form1.totalLibros.value = v1.trim();
						}
						if (varNombre =='chkBancos'){
							document.form1.totalBancos.value = v2.trim();
						}
					}

				}else if(ajax.status==404){
					//La pagina no existe
					//contenedor.innerHTML = "La página no existe";
				}else{
					//Mostramos el posible error
					//contenedor.innerHTML = "Error:".ajax.status;
				}
			}
		}
		ajax.send(null);

	}

	function fnAjax(){
		var xmlhttp=false;
		try{
			xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
		}catch(e){
			try{
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}catch(E){
				xmlhttp = false;
			}
		}

		if(!xmlhttp && typeof XMLHttpRequest!='undefined'){
			xmlhttp = new XMLHttpRequest();
		}
		return xmlhttp;
	}

document.form1.chkTodosBancos.checked = <cfoutput>#lvarMarcarTodosB#</cfoutput>;
document.form1.chkTodosLibros.checked = <cfoutput>#lvarMarcarTodosL#</cfoutput>;



	//Llama el conlis
	function VentanaRegMB(ECid) {
		var params ="";

		params = "&form=form"+

		popUpWindowIns("/cfmx/sif/mb/operacion/popUp-RegistroMBperiodoAnterior.cfm?ECid="+ECid+params,window.screen.width*0.05 ,window.screen.height*0.05,window.screen.width*0.90 ,window.screen.height*0.90);
	}


	var popUpWinIns = 0;
	function popUpWindowIns(URLStr, left, top, width, height){
		if(popUpWinIns){
			if(!popUpWinIns.closed) popUpWinIns.close();
		}
		popUpWinIns = open(URLStr, 'popUpWinIns', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,scrolling=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}




</script>
