<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrASQLConci="SQLConciliacion.cfm">
<cfset LvarIrAMenu="/cfmx/sif/mb/MenuMB.cfm">
<cfset LvarIrAConciliAcumula="ConciliacionAcumulador.cfm">
<cfset LvarIrAListaPreConci="listaPreConciliacion.cfm">
<cfset LvarIrAConciLibre="Conciliacion-Libre.cfm">
<cfset LvarIrAConciAutoma="ConciliacionAutomatica.cfm">
<cfset LvarIrAConciliacion="Conciliacion.cfm">
<cfset LvarCBesTCE=0><!---Filtro para los querys TCE o CuentasBancarias--->
<cfif isdefined("LvarTCEFormConciliacion")>
   	<cfset LvarIrAConciAutoma="TCEConciliacionAutomatica.cfm">
	<cfset LvarIrAConciLibre="../../tce/operaciones/TCEConciliacion-Libre.cfm">
	<cfset LvarCBesTCE=1><!---Filtro para los querys TCE o CuentasBancarias--->
	<cfset LvarIrAConciliacion="TCEConciliacion.cfm">
	<cfset LvarIrAListaPreConci="TCElistaPreConciliacion.cfm">
	<cfset LvarIrAConciliAcumula="TCEConciliacionAcumulador.cfm">
	<cfset LvarIrAMenu="/cfmx/sif/tce/MenuTCE.cfm">
	<cfset LvarIrASQLConci="TCESQLConciliacion.cfm">

</cfif>
<!--- JARR se agrego el filtro por estado P --->
<cfquery name="rsEstadosCuenta" datasource="#Session.DSN#">
	select a.ECid, a.ECdescripcion, c.Bdescripcion, b.CBdescripcion,a.Bid
	from ECuentaBancaria a, CuentasBancos b, Bancos c
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      and b.CBesTCE = #LvarCBesTCE# 	
	  and a.EChistorico  IN ('N','P') 
	  and a.CBid = b.CBid 
	  and b.Bid = c.Bid	
	order by a.ECid
</cfquery>

<cfif rsEstadosCuenta.RecordCount EQ 0>

	<script>alert("No hay Estados de Cuenta por conciliar");</script>
	
	<!---Redireccion MenuMB.cfm o MenuTCE.cfm(TCE)--->
	<cflocation url="#LvarIrAMenu#" addtoken="no">
</cfif>

<!--- filtro de seleccionadps JCRUZ --->
<cfif IsDefined("url.FiltroSelectB")>
	<cfset form.FiltroSelectB="1">
</cfif>
<cfif IsDefined("url.FiltroSelectL")>
	<cfset form.FiltroSelectL="1">
</cfif>

<cfif isdefined('url.msg') and url.msg EQ 1>
	<script>alert('La suma de los Débitos-Créditos de los documentos no coinciden');</script>
</cfif>
<cfset filtroDefault = false>
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
	<cfset filtroBancos = " b.BTEdescripcion, a.CDBdocumento">
<cfelseif isDefined("Form.optTipoDoc_Fecha") or isDefined("url.optTipoDoc_Fecha")>
<cfset Form.optTipoDoc_Fecha="">
	<cfset filtroLibros = "  b.BTdescripcion, a.CDLfecha">
	<cfset filtroBancos = "  b.BTEdescripcion, a.CDBfechabanco">
<cfelseif isDefined("Form.optMonto") or isDefined("url.optMonto")>
<cfset Form.optMonto="">
	<cfset filtroLibros = " a.CDLmonto">
	<cfset filtroBancos = " a.CDBmonto">
<cfelse>
	<cfset filtroLibros = " a.CDLfecha">
	<cfset filtroBancos = " a.CDBfechabanco">
	<cfset filtroDefault = true>
</cfif>

<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid))>
	<cfset ECid = Form.ECid>
<cfelse>
	<cfset ECid = rsEstadosCuenta.ECid>
</cfif>

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
<!--- JARR Se obtiene la fecha de Auxiliares para filtrar --->
<cfif mes.Pvalor eq 12>
	<cfset lvarAnoMes = CreateDate((Periodo.Pvalor+1), 1,1)>
<cfelse>
	<cfset lvarAnoMes = CreateDate((Periodo.Pvalor), (mes.Pvalor+1),1)>
</cfif>

<cf_dbfunction name="now" args="#Session.DSN#" returnvariable="LvarFecha">

<cfquery name="rsEstadoDeCuenta" datasource="#Session.DSN#">
	select ec.ECid,
		ec.ECdescripcion,
		b.Bdescripcion, 
		cb.CBdescripcion, 
		ec.Bid,
		ec.CBid,
		coalesce(ec.ECdesde, #LvarFecha# ) as ECdesde,
		coalesce(ec.EChasta, #LvarFecha# ) as EChasta	
	from ECuentaBancaria ec
	inner join CuentasBancos cb
	   on cb.CBid = ec.CBid
	  and cb.Bid = ec.Bid
	  and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	inner join Bancos b
	   on b.Bid = cb.Bid
	  and b.Ecodigo = cb.Ecodigo
	where ec.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		and cb.CBesTCE = #LvarCBesTCE# 	
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
	select BTid, BTdescripcion as BTEdescripcion
	from BTransacciones b
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and exists ( select 1 
				 from BTransaccionesEq a 
				 where a.BTid= b.BTid 
				    and a.Ecodigo=b.Ecodigo
					and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoDeCuenta.Bid#"> )
</cfquery>

<cfparam name="form.BTid" default="#rsBTransacciones.BTid#"> <!--- por defecto toma el primer registro que encuentra --->
<cfif len(trim(form.BTid)) eq 0>
	<cfset form.BTid = 0 >
</cfif>


<!--- <cfset fecha_maxima = createdate( datePart('yyyy', rsEstadoDeCuenta.EChasta), datepart('m', rsEstadoDeCuenta.EChasta), datepart('d', rsEstadoDeCuenta.EChasta) )>
<cfset fecha_maxima = dateadd('d', 1, fecha_maxima ) > --->
<!--- <cfdump var="#fecha_maxima#"> --->

<cfset fecha_maxima = DateFormat(lvarAnoMes, "mmm-dd-yyyy")>
<!--- <cfset form.flFecha = lvarAnoMes> --->

<!--- JARR 23/07/2018 Se quito el filtro del ECid para poder ver los 
movimientos anteriores a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">--->
<!--- JARR 24072018 se agrego el filtro por banco --->
<!--- <cf_dump var="#form#"> --->
<cfquery name="rsMovLibrosNoConc" datasource="#Session.DSN#">
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

<!--- <cf_dump var="#rsMovLibrosNoConc#"> --->

<cfquery name="montoCDL" dbtype="query">
	select sum(CDLmonto) as CDLmonto from  rsMovLibrosNoConc where CDLacumular = 1
</cfquery>

<cfquery name="rsMovBancosNoConc" datasource="#Session.DSN#">
	select rtrim(a.BTEcodigo) as BTEcodigo, 
		tb.BTEdescripcion,
		c.DCReferencia as referencia,a.CDBlinea,a.CDBacumular,CDBUsucodigo,
		Pid,Pnombre,Papellido1,
		a.* 
	from CDBancos a 
	inner join BTransaccionesEq b
	   on b.Ecodigo = a.Ecodigo
	  and b.Bid = a.Bid
	  and b.BTEcodigo = a.BTEcodigo
	  and a.CDBconciliado <> 'S'
	  and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  
	inner join TransaccionesBanco tb
	   on b.Bid = tb.Bid
	  and b.BTEcodigo = tb.BTEcodigo

	left join DCuentaBancaria c
		on c.Linea = a.CDBlinref
	left join Usuario d
		on a.CDBUsucodigo= d.Usucodigo
	left join DatosPersonales e
	on d.datos_personales = e.datos_personales 
	where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#"> 
	<cfif isdefined('form.BTid')  and form.BTid NEQ -1>
	  and b.BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
	</cfif>
	
	  <cfif isdefined("form.fbDesc") and len(trim(form.fbDesc)) >
	  	and upper(CDBdocumento) like '%#ucase(form.fbDesc)#%'
	  </cfif>
	  
	  <cfif isdefined("form.FBRef") and len(trim(form.FBRef)) >
	  	and upper(c.DCReferencia) like '%#ucase(form.FBRef)#%'
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
	select round(coalesce((sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - sum(case CDLtipomov when 'C' then CDLmonto else 0 end)),0.00),2) as sumaDCL
	from CDLibros
	where  
	EXISTS (
		SELECT b.BTid 
		FROM BTransacciones b
		inner join MLibros c 
			on CDLibros.MLid = c.MLid
		left join Usuario d
			on CDLibros.CDLUsucodigo= d.Usucodigo
		WHERE b.BTid = CDLibros.CDLidtrans
		and CDLibros.CDLconciliado <> 'S'
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">						
		<cfif isdefined('form.BTid')  and form.BTid NEQ -1>
			and CDLibros.CDLidtrans = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
		</cfif>
		)
	
	and CDLacumular = 1
	and CDLUsucodigo=#session.Usucodigo#
</cfquery>


<cfif rsMontoL.sumaDCL EQ 0 >
	<cfset rsMontoL.sumaDCL=montoCDL.CDLmonto >
</cfif>

<cfquery name="rsMontoB" datasource="#session.DSN#">
	select coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
	sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00) as sumaDCB
	from CDBancos
	where
	EXISTS (
		SELECT tb.BTEdescripcion 
		FROM BTransaccionesEq b
		inner join TransaccionesBanco tb 
			on b.Bid = tb.Bid 
			and b.BTEcodigo = tb.BTEcodigo 
		left join DCuentaBancaria c 
			on c.Linea = CDBancos.CDBlinref 
		left join Usuario d 
			on CDBancos.CDBUsucodigo= d.Usucodigo 
		
		WHERE b.Ecodigo = CDBancos.Ecodigo
		and b.Bid = CDBancos.Bid 
		and b.BTEcodigo = CDBancos.BTEcodigo 
		and CDBancos.CDBconciliado <> 'S' 
		and CDBancos.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CDBancos.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
		<cfif isdefined('form.BTid')  and form.BTid NEQ -1>
			and b.BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
		</cfif>
		)
	and ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	and CDBacumular = 1
	and CDBUsucodigo=#session.Usucodigo#
</cfquery>
<style type="text/css">
<!--
.styleCaja{border-color:E2E2E2; background-color:E2E2E2;color:990000;font-size:14px;text-align:right;font-weight:bold;}
-->
</style>

<form name="frmGO" action="" method="post" style="margin: 0; ">
	<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
</form>

<!---Redireccion 6. SQLConciliacion.cfm o TCESQLConciliacion.cfm (TCE)--->
<form action="<cfoutput>#LvarIrASQLConci#</cfoutput>" method="post" name="form1">	
<input name="numChkLibros" type="hidden" id="numChkLibros" value="">
<input name="numChkBancos" type="hidden" id="numChkBancos" value="">
	<table width="100%" border="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><span style="font-size:10px"><strong>Cuenta:</strong></span></td>
			<td nowrap>
				<span style="font-size:10px">
					<cfif isDefined("Form.ECid")>
						<cfoutput>#rsEstadoDeCuenta.Bdescripcion# - #rsEstadoDeCuenta.CBdescripcion#</cfoutput>
					<cfelse>
						<cfoutput>#rsEstadosCuenta.getField(1,3)# - #rsEstadosCuenta.getField(1,4)#</cfoutput>
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
					
					<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>';
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
					
					<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>';
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
					
					<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>';
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
					
					<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>';
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
					
					<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
					document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>';
					document.form1.submit();
					"
					style="border:0; background:background-color"
					id="optMonto">
				<label for="optMonto"><span style="font-size:10px">Monto</span></label>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap><span style="font-size:10px"><strong>Filtrar por:</strong></span></td>
			<td>
				<!---5. Redireccion Conciliacion.cfm o TCEConciliacion.cfm (TCE)--->
 				<select name="BTid" onChange="document.form1.action = '<cfoutput>#LvarIrAConciliacion#</cfoutput>'; document.form1.submit();	">
					<cfoutput query="rsBTransacciones">
						<option value="#rsBTransacciones.BTid#" <cfif isdefined('form.BTid') and BTid EQ form.BTid>selected</cfif>>
							<span style="font-size:10px">#rsBTransacciones.BTEdescripcion#</span>
						</option>
					</cfoutput>
				</select>				
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
	<table width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td bgcolor="#A0BAD3">
				<table width="100%"  border="0">
				  <tr>
					<td align="left">
						<input name="Agregar" type="submit" value="Asignar" 
							onClick="javascript: return validaChecks();" >
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
			<!--- add JCRUZ--->
        		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
				<thead class="fixedHeader">
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td colspan="6">
							<table width="100%" cellpadding="1" style="border: 1px solid gray;">
								<tr>
									<td width="1%" nowrap="nowrap"><strong>Documento</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Referencia</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Fecha</strong></td>
									<td width="1%" nowrap="nowrap"><strong>D&eacute;bitos</strong></td>
									<td width="1%" nowrap="nowrap"><strong>Cr&eacute;ditos</strong></td>
									<td width="1%" align="center" nowrap="nowrap"><strong style="font-size:10px;">Seleccionados</strong></td>
									<td rowspan="2"><input type="submit" name="Filtrar" value="Filtrar" onclick="this.form.action='';"  align="center"/></td>
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
										<!--- <cfdump var="#rsMontoL#"> --->
										<cfoutput><input type="text" name="totalLibros" id="totalLibros" class="styleCaja" readonly="true" value="#LSNumberFormat(rsMontoL.sumaDCL,'9,9.99')#" /></cfoutput>
									</td>
								</tr>
							</table>
						</td>
		  			</tr> 
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20" > 
						<td width="5%" nowrap="nowrap">
							<cfoutput>
								<input name="chkTodosLibros" type="checkbox" value="" border="1" 
									onClick="fnAcumular(this,'#ECid#',-1,#BTid#);"
									style="border:0; background:background-color "
									id="chkTodosLibros" alt="Seleccionar Todos" title="Seleccionar Todos">
							</cfoutput>	
						</td>
						<td width="24%" align="left"><strong>Documento</strong></td>
						<td width="20%" align="left"><strong>Referencia</strong></td>
						<td width="10%" align="center"><strong>Fecha</strong></td>
						<td width="20%" align="right"><div align="right"><strong>D&eacute;bitos</strong></div></td>
						<td width="20%" align="right"><div align="right"><strong>Cr&eacute;ditos</strong></div></td>
					</tr>
					</thead>
					<tbody class="fixedtbody">
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
							<tr><td  title="Referencia: #referencia#" width="100%" colspan="5">&nbsp;</td></tr>
							</cfif>
							<tr height="15" bgcolor="F0F0F0">
								<td colspan="6" width="100%">&nbsp;<strong>#rsMovLibrosNoConc.BTdescripcion#</strong></td>
							</tr>
							<cfset transNoConc = rsMovLibrosNoConc.BTcodigo>
						</cfif>
						<tr <cfif rsMovLibrosNoConc.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>  
							<td width="5%" title="Referencia: #trim(referencia)# Usuario: #rsMovLibrosNoConc.Pnombre# #rsMovLibrosNoConc.Papellido1# cedula: #rsMovLibrosNoConc.Pid#" nowrap>
								<input name='chkLibros' type='checkbox' <cfif #rsMovLibrosNoConc.CDLacumular# eq 1> checked="checked"<cfelse><cfset lvarMarcarTodosL = false> </cfif> 
									value='#rsMovLibrosNoConc.ECid#|#rsMovLibrosNoConc.MLid#|#rsMovLibrosNoConc.BTcodigo#|#Replace(Replace(rsMovLibrosNoConc.CDLdocumento, "|", "1", "All"), ",", " ", "All")#|#rsMovLibrosNoConc.CDLfecha#|#rsMovLibrosNoConc.CDLmonto#|#rsMovLibrosNoConc.CDLtipomov#' 
									<cfif #rsMovLibrosNoConc.CDLUsucodigo# eq #Session.Usucodigo# or not len(trim('#rsMovLibrosNoConc.CDLUsucodigo#'))> <cfelse>disabled="disabled"</cfif>
									onClick="fnAcumular(this,'#ECid#','#rsMovLibrosNoConc.MLid#');javascript:document.form1.chkTodosLibros.checked= false;"  
									style="border:0;  background:background-color">
							</td>
							<td width="25%" nowrap>#rsMovLibrosNoConc.CDLdocumento#</td>
							<td width="20%" title="#referencia#" alt="#referencia#" nowrap>#mid(referencia,1,15)#</td>
							<td width="10%" align="center" nowrap>#LSDateFormat(rsMovLibrosNoConc.CDLfecha,'dd/mm/yyyy')#</td>
							<td width="20%" align="right" nowrap> 
								<cfif rsMovLibrosNoConc.CDLtipomov EQ 'D'>
									#LSCurrencyFormat(rsMovLibrosNoConc.CDLmonto, "none")# 
								</cfif>
							</td>
							<td width="20%" title="Referencia: #referencia#" align="right" nowrap>
								<cfif rsMovLibrosNoConc.CDLtipomov EQ 'C'>
									#LSCurrencyFormat(rsMovLibrosNoConc.CDLmonto, "none")# 
								</cfif>
							</td>
						</tr>
						<cfset cuantosRegLibros = cuantosRegLibros + 1 >
          			</cfoutput>
					</tbody>					
        		</table>
			</td>
        
      		<td valign="top"> 
        		<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0">
				<thead class="fixedHeader">
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20">
						<td colspan="6">
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
								 	<td align="left"><input type="text"   name="fbDesc" maxlength="80" size="7" 
										value="<cfif isdefined('form.fbDesc') and len(trim(form.fbDesc)) ><cfoutput>#form.fbDesc#</cfoutput></cfif>" />
									</td>
									<td align="left"><input type="text"   name="FBRef" maxlength="80" size="7" 
										value="<cfif isdefined('form.FBRef') and len(trim(form.FBRef)) ><cfoutput>#form.FBRef#</cfoutput></cfif>" />
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
								 
								<!---	<td align="left"><input type="text" name="fldebito" maxlength="80" size="20" 
										value="<cfif isdefined('form.flDesc') and len(trim(form.flDesc)) ><cfoutput>#form.flDesc#</cfoutput></cfif>" />
									</td>
									<td align="left"><input type="text" name="flcredito" maxlength="80" size="20" 
										value="<cfif isdefined('form.flDesc') and len(trim(form.flDesc)) ><cfoutput>#form.flDesc#</cfoutput></cfif>" />
									</td>--->
									
									
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
					<tr bgcolor="#E2E2E2" class="subTitulo" height="20"> 
						<td width="5%">
							<cfoutput>
								<input name="chkTodosBancos" type="checkbox" value="" border="1" onClick="fnAcumular(this,'#ECid#',-1,#BTid#);"
									style="border:0; background:background-color "
									id="chkTodosBancos" alt="Seleccionar Todos" title="Seleccionar Todos">
							</cfoutput>	
						</td>
				
						<td width="25%" align="left"><strong>Documento</strong></td>
						<td width="20%" align="left"><strong>Referencia</strong></td>
						<td width="10%" align="center"><strong>Fecha</strong></td>
						<td width="20%" align="right"><strong>D&eacute;bitos</strong></td>
						<td width="20%" align="right"><strong>Cr&eacute;ditos</strong></td>
					</tr>
					</thead>
					<tbody class="fixedtbody">
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
							<tr><td width="100%" colspan="6">&nbsp;</td></tr>
							</cfif>
							<tr height="15" bgcolor="F0F0F0">
								<td colspan="6" width="100%">&nbsp;<strong>#rsMovBancosNoConc.BTEdescripcion#</strong></td>
							</tr>
							<cfset transNoConc = rsMovBancosNoConc.BTEcodigo>
						</cfif>
						<tr <cfif rsMovBancosNoConc.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
							<td nowrap width="5%" title="Referencia: #trim(referencia)# Usuario: #rsMovBancosNoConc.Pnombre# #rsMovBancosNoConc.Papellido1# cedula: #rsMovBancosNoConc.Pid#"> 
								<input name='chkBancos' type='checkbox' <cfif #rsMovBancosNoConc.CDBacumular# eq 1> checked="checked" <cfelse><cfset lvarMarcarTodosB = false></cfif>  
									value='#rsMovBancosNoConc.ECid#|#rsMovBancosNoConc.CDBlinea#|#rsMovBancosNoConc.BTEcodigo#|#Replace(Replace(rsMovBancosNoConc.CDBdocumento, "|", "1","All"), ",", " ", "All")#|#rsMovBancosNoConc.CDBfecha#|#rsMovBancosNoConc.CDBmonto#|#rsMovBancosNoConc.CDBtipomov#'
									<cfif #rsMovBancosNoConc.CDBUsucodigo# eq #Session.Usucodigo# or not len(trim('#rsMovBancosNoConc.CDBUsucodigo#'))> <cfelse>disabled="disabled"</cfif>
									onClick=" fnAcumular(this,'#ECid#','#rsMovBancosNoConc.CDBlinea#'); javascript:document.form1.chkTodosBancos.checked= false;" 
									style="border:0; background:background-color ">
							</td>
							<td width="25%" nowrap>#rsMovBancosNoConc.CDBdocumento#</td>
							<td width="20%" title="#referencia#" alt="#referencia#" nowrap>#mid(referencia,1,15)#</td>
							<td width="10%" align="center" nowrap>#LSDateFormat(rsMovBancosNoConc.CDBfechabanco,'dd/mm/yyyy')#</td>
							<td width="20%" align="right" nowrap> 
								<cfif rsMovBancosNoConc.CDBtipomov EQ 'D'>
									#LSCurrencyFormat(rsMovBancosNoConc.CDBmonto,"none")# 
								</cfif>
							</td>
							<td width="20%" title="Referencia: #referencia#" align="right" nowrap>
								<cfif rsMovBancosNoConc.CDBtipomov EQ 'C'>
									#LSCurrencyFormat(rsMovBancosNoConc.CDBmonto,"none")# 
								</cfif>
							</td>
						</tr>
						<cfset cuantosRegBancos = cuantosRegBancos + 1 >
          			</cfoutput>
					<tbody>
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
						<input name="Agregar" type="submit" value="Asignar" onClick="javascript: return validaChecks();" >
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
</form>

<script language="JavaScript" type="text/javascript">

	function funcRegresar() {
	<!---4. Redireccion ConciliacionAutomatica.cfm o TCEConciliacionAutomatica.cfm (TCE)---> 
		document.frmGO.action='<cfoutput>#LvarIrAConciAutoma#</cfoutput>';
		document.frmGO.submit();
	}

	function funcSiguiente() {
		<!---3. Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm (TCE)---> 
 		document.frmGO.action='<cfoutput>#LvarIrAConciLibre#</cfoutput>';
		document.frmGO.submit();
	}

	function PreConciliacion(data) {
		
		<!---2. Redireccion listaPreConciliacion.cfm o TCElistaPreConciliacion.cfm (TCE)---> 
 		document.form1.action='<cfoutput>#LvarIrAListaPreConci#</cfoutput>';
		return false;
	}

	function validaChecks() {
		return (validaChecksLibros() && validaChecksBancos());
	}

	function validaChecksLibros() {
		<cfif cuantosRegLibros NEQ 0> 
			<cfif cuantosRegLibros EQ 1>
				if (document.form1.chkLibros.checked)					
					return true;
				else
					alert("Debe seleccionar al menos un documento de Libros");									
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chkLibros.length; i++) {
					if (document.form1.chkLibros[i].checked) bandera = true;						
				}
				if (bandera)
					return true;
				else
					alert("Debe seleccionar al menos un documento de Libros");											
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
				else
					alert("Debe seleccionar al menos un documento de Bancos");									
			<cfelse>
				var bandera = false;
				var i;
				for (i = 0; i < document.form1.chkBancos.length; i++) {
					if (document.form1.chkBancos[i].checked) bandera = true;						
				}
				if (bandera)
					return true;
				else
					alert("Debe seleccionar al menos un documento de Bancos");											
			</cfif>	 			
		<cfelse>
			alert("¡No existen documentos de Bancos!");							
		</cfif>
		return false;
	}
<!--- Estas dos funciones eran llamadas del checktodosLibros y bancos para marcar o demarcar todos, pero se sustituye por fnAcumular 
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



	function fnAcumular(detalle,ECid,ID,BTid){
		varSumaResta=detalle.checked;
		varNombre=detalle.name;
		varECid=ECid;
		varId=ID;
		//parametro que indica q es de equivalencia.
		varEqui='si';
		varBTid=document.form1.BTid.value;

		var params= '';
		<!---1. Redireccion  ConciliacionAcumulador.cfm o TCEConciliacionAcumulador.cfm TCE--->


		/*var nowDate = new Date('Sep-01-2018');
        var result = "";
        result += nowDate.format("dd/mm/yyyy") + " : dd/mm/yyyy <br/>";*/
		
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

		url = '<cfoutput>#LvarIrAConciliAcumula#</cfoutput>?SumaResta='+varSumaResta+'&Nombre='+varNombre+'&ECid='+varECid+'&id='+varId+'&Equivalencia='+varEqui+'&BTid='+varBTid+params;
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
						/*alert("totalLibros"+v1.trim()+"totalBancos"+ v2.trim());*/

						
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
