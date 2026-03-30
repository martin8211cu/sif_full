<cf_dbfunction name="now" returnvariable="hoy">
<cfif isdefined('form.chk_DocCliente')>
	<cfset chequeados = ListToArray(Form.chk_DocCliente, ',')>
	<cfset cuantos = ArrayLen(chequeados)>
	<cfset Socios = ''>
	<cfset DirSoc = ''>
	<cfset Moneda = ''>
	<cfloop index="CountVar" from="1" to="#cuantos#">
		<cfset valores = ListToArray(chequeados[CountVar],'|')>
		<cfset Moneda = ListAppend(Moneda,valores[1])>
		<cfset Socios = ListAppend(Socios,valores[2])>
		<cfset DirSoc = ListAppend(DirSoc,valores[3])>
	</cfloop>
	<cfquery name="rsParametros1" datasource="#session.DSN#">
		select Pvalor as p1
		from Parametros
		where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = 310
	</cfquery>
	<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
		<cfset p1 = rsParametros1.p1>
	<cfelse>
		<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
	</cfif>
	
	<cfquery name="rsParametros2" datasource="#session.DSN#">
		select Pvalor as p2
		from Parametros
		where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = 320
	</cfquery>

	<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
		<cfset p2 = rsParametros2.p2>
	<cfelse>
		<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
	</cfif>
	
	<cfquery name="rsParametros3" datasource="#session.DSN#">
		select Pvalor as p3
		from Parametros
		where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = 330
	</cfquery>
	<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
		<cfset p3 = rsParametros3.p3>
	<cfelse>
		<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
	</cfif>

	<cfquery name="rsParametros4" datasource="#session.DSN#">
		select Pvalor as p4
		from Parametros
		where Ecodigo =  #Session.Ecodigo# 
			and Pcodigo = 340
	</cfquery>
	<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
		<cfset p4 = rsParametros4.p4>
	<cfelse>
		<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
	</cfif>

</cfif>

<cfquery name="rsImpuestos" datasource="#Session.DSN#">
	select Icodigo, Idescripcion 
	from Impuestos 
	where Ecodigo =  #Session.Ecodigo# 
	<cfif isdefined('form.Calcular')>
		and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	</cfif>
	order by Idescripcion                                 
</cfquery>

<cfquery name="rsTransacciones" datasource="#session.dsn#">
	select CCTcodigo, CCTdescripcion
	from CCTransacciones
	where Ecodigo =  #Session.Ecodigo# 
	and CCTtipo = 'D' 
	<cfif isdefined('form.Calcular')>
		and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoD#">
	</cfif>
	order by 1
</cfquery>

<cf_templateheader title="Registro de Interés Moratorio">
		<cfinclude template="../../portlets/pNavegacionIV.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Registro de Intereses Moratorios">
			<form name="form1" method="post" action="DatosCalculoDocIntMCxC.cfm">				
				<cfoutput>
				<input name="SNCEid" 		type="hidden" value="#form.SNCEid#" 	tabindex="-1">
				<input name="SNCDid1" 		type="hidden" value="#form.SNCDid1#" 	tabindex="-1">
				<input name="SNCDid2" 		type="hidden" value="#form.SNCDid2#" 	tabindex="-1">
				<input name="SNCDvalor1" 	type="hidden" value="#form.SNCDvalor1#" tabindex="-1">
				<input name="SNCDvalor2" 	type="hidden" value="#form.SNCDvalor2#" tabindex="-1">
				<input name="SNcodigo" 		type="hidden" value="#form.SNcodigo#" 	tabindex="-1">
				<input name="SNnumero" 		type="hidden" value="#form.SNnumero#" 	tabindex="-1">
				<input name="SNcodigo2" 	type="hidden" value="#form.SNcodigo2#" 	tabindex="-1">
				<input name="SNnumero2" 	type="hidden" value="#form.SNnumero2#" 	tabindex="-1">
				<input name="CCTcodigoE"	type="hidden" value="#form.CCTcodigoE#" tabindex="-1">
				<input name="Corte" 		type="hidden" value="#form.Corte#" 		tabindex="-1">
				<input name="Generar" 		type="hidden" value="#form.Generar#" 	tabindex="-1">
				<cfif isdefined('form.chk_DocCliente')>
				<input name="chk_DocCliente" type="hidden" value="#form.chk_DocCliente#" tabindex="-1">
				</cfif>
				<cfif isdefined('form.chk_TodosDocCliente')>
				<input name="chk_TodosDocCliente" type="hidden" value="#form.chk_TodosDocCliente#" tabindex="-1">
				</cfif>
				<cfif isdefined('form.chk_AgrupaxCliente')>
				<input name="chk_AgrupaxCliente" type="hidden" tabindex="-1" value="#form.chk_AgrupaxCliente#">
				</cfif>
				<table width="75%" align="center"  border="0" cellspacing="2" cellpadding="2">
					<tr>
						<td align="right" valign="top" nowrap><strong>Documento:&nbsp;</strong></td>
						<td>
							<input name="DocIntMora" type="text" size="20" maxlength="20" tabindex="1" <cfif isdefined('form.Calcular')>class="cajasinborde" readonly</cfif>
							value="<cfif isdefined("Form.DocIntMora") and LEN(Form.DocIntMora) GT 0>#Form.DocIntMora#</cfif>">
						</td>
						<td align="right"><strong>Transacci&oacute;n:&nbsp;</strong></td>
						<td>
							<cfif isdefined('form.Calcular')>
								#rsTransacciones.CCTdescripcion#
								<input name="CCTcodigoD" type="hidden" value="#form.CCTcodigoD#" tabindex="-1">
							<cfelse>
								<select name="CCTcodigoD" tabindex="1">
									<cfloop query="rsTransacciones">
										<option value="#rsTransacciones.CCTcodigo#" 
										<cfif isdefined('Form.CCTcodigoD') and #rsTransacciones.CCTcodigo# EQ #Form.CCTcodigoD#>selected</cfif>>
											#rsTransacciones.CCTdescripcion#
										</option>
									</cfloop>
								</select>	
							</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>D&iacute;as:</strong>&nbsp;</td>
						<td align="left" colspan="4">
							<input name="DiasVenc" type="text"  <cfif isdefined('form.Calcular')>class="cajasinborde" readonly</cfif> 
								value="<cfif isdefined('form.DiasVenc') and LEN(TRIM(form.DiasVenc)) GT 0>#form.DiasVenc#<cfelse>0</cfif>" 
								tabindex="1" size="5">
						</td>
					</tr>
					<tr>
						<td align="right" valign="top" nowrap><p><strong>Tasa de Inter&eacute;s:&nbsp;</strong></p>    </td>
						<td colspan="4">
							<input name="Tasa" type="text" size="10" align="right" tabindex="1" <cfif isdefined('form.Calcular')>class="cajasinborde" readonly</cfif>
							value="<cfif isdefined('Form.Tasa') and LEN(Form.Tasa) GT 0>#Form.Tasa#<cfelse>#Trim(LSNumberFormat(0,"___.__"))#</cfif>"
							onChange="javascript: fm(this,2); valida(this);"
							onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}};">%
						</td>			
					</tr>
					<tr>
						<td align="right" valign="top" nowrap><strong>Concepto:&nbsp; </strong></td>
						<td colspan="4">
							<cfif isdefined('form.Cid') and LEN(Form.Cid)>
								<cfquery name="rsConcepto" datasource="#session.DSN#">
									select Cid, Ccodigo, Cdescripcion
									from Conceptos
									where Ecodigo =  #Session.Ecodigo# 
									and Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Cid#">
								</cfquery>
								<cfif isdefined('form.Calcular')>
									#rsConcepto.Ccodigo# - #rsConcepto.Cdescripcion#
									<input name="Cid" type="hidden" value="#form.Cid#" tabindex="-1">
								<cfelse>
									<cf_sifconceptos query= "#rsConcepto#" tabindex="1">
								</cfif>
							<cfelse>
								<cf_sifconceptos tabindex="1">
							</cfif>
						</td>
		
					</tr>
					<tr>
						<td align="right"><strong>Impuesto:</strong>&nbsp;</td>
						<td colspan="4">
							<cfif isdefined('form.Calcular')>
								#rsImpuestos.Idescripcion#
								<input name="Icodigo" type="hidden" value="#form.Icodigo#" tabindex="-1">
							<cfelse>
								<select name="Icodigo" tabindex="1">
									<cfloop query="rsImpuestos"> 
										<option value="#rsImpuestos.Icodigo#"  
											<cfif isdefined('form.Icodigo') and TRIM(rsImpuestos.Icodigo) EQ TRIM(form.Icodigo)>selected="selected"</cfif>>
											#rsImpuestos.Icodigo# - #rsImpuestos.Idescripcion#
										</option>
									</cfloop>
								</select> 
							</cfif>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="4">
							<input name="chk_AgrupaxCliente" id="chk_AgrupaxCliente" type="checkbox" tabindex="1" <cfif isdefined('form.Calcular')>disabled</cfif>
								<cfif isdefined('form.chk_AgrupaxCliente') and form.chk_AgrupaxCliente EQ 'on'>checked</cfif>>
							<label for="chk_AgrupaxCliente" style="font-style:normal;font-weight:normal"><strong>Agrupar por Cliente/Direcci&oacute;n</strong></label>
						</td>
					</tr>

					<tr><td colspan="4">&nbsp;</td></tr>
				</table>
				</cfoutput>
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="12">
							<cfif isdefined('form.Calcular')>
								<cf_botones values="Anterior,Aplicar" names="Anterior,Aplicar" tabindex="1">
							<cfelse>
								<cf_botones values="Anterior,Calcular Interés" names="Anterior,Calcular" tabindex="1">
							</cfif>
						</td>
					</tr>
					<tr><td colspan="12">&nbsp;</td></tr>
					<tr><td colspan="12" nowrap class="TituloAlterno" align="center" style="text-transform:uppercase ">Documentos Seleccionados</td></tr>
					<tr><td colspan="12">&nbsp;</td></tr>
					<cfoutput>
						<cfset chequeados = ListToArray(Form.chk_DocCliente, ',')>
						<cfset cuantos = ArrayLen(chequeados)>
						<cfset LvarListaNon = true>
						<cfset corte = ''>
						<cfloop index="CountVar" from="1" to="#cuantos#">
							<cfset valores = ListToArray(chequeados[CountVar],'|')>
							<cfset corte2 = valores[1] & '|' & valores[2] & '|' & valores[3]>
							<cfset pintar_titulo = false>
							<cfif corte NEQ corte2>
								<cfset pintar_titulo = true>
								<cfset Lvar_Moneda = valores[1]>
								<cfset Lvar_SNcodigo = valores[2]>
								<cfset Lvar_id_direccion = valores[3]>
								<!--- CONSULTA QUE TRAE EL ANALISIS DE SALDOS POR DIRECCION/SOCIO --->
								<cfquery name="rsSaldoSocio" datasource="#session.DSN#">
									select
									 m.Mnombre,
									 min(d.Mcodigo) as Mcodigo,
									 min(snd.SNnombre) as SNnombre, 
									 min(snd.SNDcodigo) as SNnumero,
									 min(snd.id_direccion) as id_direccion,
									 min(s.SNcodigo) as SNcodigo,	
									 sum(d.Dtotal * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Total,  
									 sum(d.Dsaldo * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) as Saldo,
									 sum(case when 
											d.Dvencimiento >= #hoy#
											and <cf_dbfunction name="date_part"	args="mm, d.Dfecha"> = <cf_dbfunction name="date_part"	args="mm, #hoy#">
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as Corriente,
									 sum(case when 
											d.Dvencimiento >= #hoy#
											and <cf_dbfunction name="date_part"	args="mm, d.Dfecha"> <> <cf_dbfunction name="date_part"	args="mm,#hoy#">
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as SinVencer,		  
									 sum(case when 
										  <cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#"> 
											between 0 and 30
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as P1,
									 sum(case when 
										  <cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#"> 
											between 31 and 60
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as P2,
									 sum(case when 
										  <cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#"> 
											between 61 and 90
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as P3,
									 sum(case when 
										  <cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#"> 
											between 91 and 120
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as P4,
									 sum(case when 
										  <cf_dbfunction name="datediff"	args="d.Dvencimiento,#hoy#"> >= 121
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as P5,
									 sum(case when 
											<cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#"> >= 0 
											and
											(
												<cf_dbfunction name="date_part"	args="mm, d.Dvencimiento"> <> <cf_dbfunction name="date_part"	args="mm, #hoy#"> 
											or
												<cf_dbfunction name="date_part"	args="yyyy, d.Dvencimiento"> <> <cf_dbfunction name="date_part"	args="yyyy, #hoy#">
											)
										  then Dsaldo else 0.00 end * case when t.CCTtipo = 'D' then 1.00 else -1.00 end) 
										  as Morosidad 
								
									from SNDirecciones snd
										inner join SNegocios s
											on s.SNid = snd.SNid
										inner join Documentos d
											on d.Ecodigo = snd.Ecodigo 
										   and d.SNcodigo = snd.SNcodigo 
										   and d.id_direccionFact = snd.id_direccion  
											   
										inner join Monedas m
											on m.Mcodigo = d.Mcodigo
											and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
										inner join CCTransacciones t
											on t.CCTcodigo = d.CCTcodigo 
											and t.Ecodigo = d.Ecodigo 
									where snd.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[3]#">
										and d.Dsaldo <> 0.00 
										and s.Ecodigo =  #Session.Ecodigo# 
									    and s.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#valores[2]#">
										group by  snd.id_direccion, s.SNcodigo, snd.SNnombre, snd.SNDcodigo, m.Mnombre
										order by  snd.id_direccion,s.SNcodigo, snd.SNnombre, snd.SNDcodigo, m.Mnombre								
								</cfquery>
								<cfif corte NEQ ''>
									<tr>
										<td colspan="8" align="right" width="85%"><strong>Total</strong></td>
										<td align="right" height="25" width="15%">#LSCurrencyFormat(Lvar_TotalCliente,'none')#</td>
										<cfif isdefined('form.Calcular')>
										<td align="right" height="25">
											#LSCurrencyFormat(Lvar_TotalMorosidadImpCli,'none')#
											<input name="TotalMorosidad" type="hidden" value="#Lvar_TotalMorosidadImpCli#|#Lvar_Moneda#|#Lvar_SNcodigo#|#Lvar_id_direccion#|#Lvar_TotalMorosidadCli#">
										</td>
										</cfif>
									</tr>
									<tr><td colspan="11">&nbsp;</td></tr>
								</cfif>
								<cfset Lvar_TotalCliente = 0>
								<cfset Lvar_TotalMorosidadCli = 0>
								<cfset Lvar_TotalMorosidadImpCli = 0>
								<cfset corte = valores[1] & '|' & valores[2] & '|' & valores[3]>
								<tr class="tituloListas" height="25">
									<td>&nbsp;</td>
									<td colspan="12"><span style="font-size:13px">Moneda: #rsSaldoSocio.Mnombre#</span></td>
								</tr>
								<!--- Encabezado --->
								<tr class="tituloListas">
									<td>&nbsp;</td>
									<td nowrap>&nbsp;&nbsp;#rsSaldoSocio.SNnombre#</td>
									<td align="center" nowrap>Corriente</td>
									<td align="center" nowrap>Sin Vencer</td>
									<td align="center" nowrap>De 0 a 30</td>
									<td align="center" nowrap>De 31 a 60</td>
									<td align="center" nowrap>De 61 a 90</td>
									<td align="center" nowrap>De 91 a 120</td>
									<td align="center" nowrap>De 121 o m&aacute;s</td>
									<td align="center" nowrap>Morosidad</td>
									<td align="center" nowrap>Saldo</td>
								</tr>
								<tr class="listapar" height="25">
									<td>&nbsp;</td>
									<td>&nbsp;&nbsp;<strong>C&oacute;digo:</strong>&nbsp;#SNnumero#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.Corriente,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.Sinvencer,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.P1,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.P2,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.P3,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.P4,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.P5,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.Morosidad,'none')#</td>
									<td align="right">#LSCurrencyFormat(rsSaldoSocio.Saldo,'none')#</td>
								</tr>
								<tr><td colspan="11">&nbsp;</td></tr>
								
							</cfif>					
							<!--- Detalle --->
							<cfif pintar_titulo>
								<tr >
									<td colspan="2">&nbsp;</td>
									<td colspan="2" class="tituloListas">Transacci&oacute;n</td>
									<td colspan="2" class="tituloListas">Documento</td>
									<td class="tituloListas">Fecha de Vencimiento</td>
									<td class="tituloListas">Moneda</td>
									<td class="tituloListas" align="right">Saldo</td>
									<cfif isdefined('form.Calcular')>
									<td class="tituloListas" align="right">Morosidad</td>
									</cfif>
								</tr>
							</cfif>
							<cfquery name="rsMoneda" datasource="#session.DSN#">
								select Mnombre, Mcodigo
								from Moneda
								where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valores[1]#">
							</cfquery>
							<cfif Lvar_SNcodigo EQ valores[2] 
								and Lvar_Moneda EQ valores[1]
								and Lvar_id_direccion EQ valores[3]>
								<tr>
									<td colspan="2">&nbsp;</td>
									<td nowrap="nowrap" colspan="2" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>#valores[5]#</td>
									<td nowrap="nowrap" colspan="2" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>#valores[6]#</td>
									<td nowrap class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>#LSDateFormat(valores[8],'dd/mm/yyyy')#</td>
									<td nowrap="nowrap" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>#rsMoneda.Mnombre#</td>
									<td nowrap="nowrap" class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(valores[7],'none')#</td>
									<cfif isdefined('form.Calcular')>
										<cfset Lvar_Impuesto = 0.00>
										<cfset Lvar_Morosidad = 0.00>
										
										<cfquery name="rsImpuesto" datasource="#session.DSN#">
											select Iporcentaje as Porcentaje, Icompuesto
											from Impuestos
											where Ecodigo =  #Session.Ecodigo# 
											  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
										</cfquery>
										<!--- SI EL IMPUESTO SELECCIONADO ES COMPUESTO SE TIENE QUE TOMAR LOS DATOS DE DIMPUESTOS--->
										<cfif rsImpuesto.Icompuesto>
											<cfquery name="rsImpuesto" datasource="#session.DSN#">
												select DIporcentaje as Porcentaje
												from DImpuestos
												where Ecodigo =  #Session.Ecodigo# 
												  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
											</cfquery>
										</cfif>
										<cfif isdefined('form.DiasVenc') and form.DiasVenc EQ 0>
										<!--- SI LOS DIAS ES CERO --->
										<!--- Impuesto = Saldo de la transaccion * % Tasa interés * %Impuesto --->
										<!--- Morosidad = (Saldo de la transaccion * % Tasa interés) + Impuesto --->
											<!--- SE HACE UN CICLO PARA EL CALCULO DE LOS IMPUESTOS --->
											<cfloop query="rsImpuesto">
												<cfset Lvar_Impuesto =  Lvar_Impuesto + (round((valores[7] * (form.Tasa/100) * (rsImpuesto.Porcentaje/100)) *100)/100)>
											</cfloop>
											<cfset Lvar_MorosidadImp = (valores[7] * (form.Tasa/100)) + Lvar_Impuesto>
											<cfset Lvar_Morosidad = (valores[7] * (form.Tasa/100))>
										<cfelse>
										<!--- SI LOS DIAS ES MAYOR A CERO --->
										<!--- Impuesto = Saldo de la transaccion * (% Tasa interés/30) * Dias * %Impuesto --->
										<!--- Morosidad = (Saldo de la transaccion * (% Tasa interés/30) * Dias) + Impuesto --->
											<!--- SE HACE UN CICLO PARA EL CALCULO DE LOS IMPUESTOS --->
											<cfloop query="rsImpuesto">
												<cfset Lvar_Impuesto =  Lvar_Impuesto + (round((valores[7] * ((form.Tasa/100)/30) * form.DiasVenc * (rsImpuesto.Porcentaje/100)) *100)/100)>
											</cfloop>
											<cfset Lvar_MorosidadImp = (valores[7] * ((form.Tasa/100)/30) * form.DiasVenc) + Lvar_Impuesto>
											<cfset Lvar_Morosidad = (valores[7] * ((form.Tasa/100)/30) * form.DiasVenc)>
										</cfif>
										<td class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(round(Lvar_MorosidadImp*100)/100,'none')#</td>
										<cfset Lvar_TotalMorosidadImpCli = Lvar_TotalMorosidadImpCli + Lvar_MorosidadImp>
										<cfset Lvar_TotalMorosidadCli = Lvar_TotalMorosidadCli + Lvar_Morosidad>
									</cfif>
								</tr>
								<cfset Lvar_TotalCliente = Lvar_TotalCliente + valores[7]>
								<cfif LvarListaNon><cfset LvarListaNon = false><cfelse><cfset LvarListaNon = true></cfif>
							</cfif>
						</cfloop>
						<cfif corte NEQ ''>
							<tr>
								<td colspan="8" align="right" width="85%"><strong>Total</strong></td>
								<td align="right" height="25" width="15%">#LSCurrencyFormat(Lvar_TotalCliente,'none')#</td>
								<cfif isdefined('form.Calcular')>
								<td align="right" height="25">
									#LSCurrencyFormat(Lvar_TotalMorosidadImpCli,'none')#
									<input name="TotalMorosidad" type="hidden" value="#Lvar_TotalMorosidadImpCli#|#Lvar_Moneda#|#Lvar_SNcodigo#|#Lvar_id_direccion#|#Lvar_TotalMorosidadCli#">
								</td>
								</cfif>
							</tr>
							<tr><td colspan="11">&nbsp;</td></tr>
						</cfif>
						<tr><td colspan="11">&nbsp;</td></tr>
					</cfoutput>
					<tr>
						<td colspan="11">
							<cfif isdefined('form.Calcular')>
								<cf_botones values="Anterior,Aplicar" names="Anterior,Aplicar" tabindex="1">
							<cfelse>
								<cf_botones values="Anterior,Calcular Interés" names="Anterior,Calcular" tabindex="1">
							</cfif>
						</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end> 
	<cf_templatefooter>

<cf_qforms>
	<cf_qformsRequiredField name="DocIntMora" description="Documento de Interés Moratorio">
	<cf_qformsRequiredField name="DiasVenc"   description="Días de Vencimiento">
	<cf_qformsRequiredField name="Tasa"       description="Tasa de Interés">
	<cf_qformsRequiredField name="Cid"        description="Concepto">
	<cf_qformsRequiredField name="Icodigo"    description="Impuesto">
	<cf_qformsRequiredField name="CCTcodigoD" description="Transacción">
</cf_qforms>	

<script src="../../js/utilesMonto.js" language="javascript1.2" type="text/JavaScript"></script>
<script language="JavaScript" type="text/javascript">
	function funcAnterior(){
		deshabilitarValidacion();
			<cfoutput>
		<cfif isdefined('form.Calcular')>
			document.form1.action = 'DatosCalculoDocIntMCxC.cfm';
		<cfelse>
		document.form1.action = 'listaDocInteresMoratorioCxC.cfm';
		</cfif>
		</cfoutput>
	}
	
	function funcAplicar(){
		if(confirm('Desea aplicar el interés Moratorio Calculado?')){
			document.form1.action = 'SQLRegistroInteresMoratorioCxC.cfm';
			 return true;
		}
		else return false;
	}
	
	function funcGenerar(){ 
		var nombre;
			tasa = document.form1.Tasa.value;

		if (tasa.name){
			p = tasa.value;
			nombre = tasa.name;
		}
		else 
			p = tasa;

		p = qf(p);
		
		if (p > 100) {
			alert('La tasa de interés digitada debe estar entre 0 y 100.');			
			eval("document.form1."+ nombre + ".value = '0.00'");
			eval("document.form1."+ nombre + ".focus();");
			return false;
		}
	} 

</script>

