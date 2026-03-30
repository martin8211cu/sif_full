<!--- Definición del modo --->
<cfif isdefined('url.OCTid') and len(trim(url.OCTid)) and not isdefined('form.OCTid')>
	<cfset form.OCTid = url.OCTid>
</cfif>
<cfif isdefined('url.Aid') and len(trim(url.Aid)) and not isdefined('form.Aid')>
	<cfset form.Aid = url.Aid>
</cfif>
<cfset modo="ALTA">
<cfset modoDet = 'ALTA'>
<cfif isdefined("form.OCOid") and len(trim(form.OCOid))>
	<cfset modo="CAMBIO">
</cfif>
<cfif isdefined('form.OCOid') and form.OCOid GT 0
	and isdefined('form.OCTid') and form.OCTid GT 0 and isdefined('form.Aid') and form.Aid GT 0>
	<cfset modoDet = 'CAMBIO'>	
<cfelse>
	<cfset form.OCTid = -1>
	<cfset form.Aid = -1>
</cfif>

<cfset navegacion ="">
<cfif NOT isdefined("form.OCOtipoOD") OR len(trim(form.OCOtipoOD)) EQ 0	>
	<cfset form.OCOtipoOD = LvarOCOtipoOD>
</cfif>

<cfquery name="rsSQL" datasource="#session.DSN#">
	select Mcodigo, (select Miso4217 from Monedas where Mcodigo = e.Mcodigo) as Miso4217
	  from Empresas e
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfset LvarMcodigoLocal = rsSQL.Mcodigo>

<cfif modo eq 'ALTA'>
	<cfset mododet = "ALTA">
	<cfset LvarMcodigo = rsSQL.Mcodigo + 2>
	<cfset LvarMiso4217 = rsSQL.Miso4217>
<cfelse>
	<cfquery name="rsData" datasource="#session.DSN#">
		select 
			OCOtipoOD, 
			OCOnumero, 
			OCOfecha, 
			CFcuenta, 0 as Ccuenta,
			OCOobservaciones,
			CFcuenta,
			SNid, Ocodigo, 
			Mcodigo, (select Miso4217 from Monedas where Mcodigo = i.Mcodigo) as Miso4217,
			OCOtotalOrigen, OCOtipoCambio
		from OCotros i
		where OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">
	</cfquery>

	<cfset LvarMcodigo = rsData.Mcodigo>
	<cfset LvarMiso4217 = rsData.Miso4217>

	<cfquery name="rsListaDet" datasource="#session.DSN#">
		select 
			ip.OCOid, 
			ip.OCTid, 
			t.OCTtipo,
			t.OCTtransporte,
			case OCTtipo 
				when 'B' then 'Barco' 
				when 'A' then 'Avion' 
				when 'T' then 'Terrestre' 
				when 'F' then 'Ferrocarril' 
				when 'O' then 'Otro' 
			end as Tipo,
			ip.Aid, a.Acodigo , a.Adescripcion, a.Ucodigo,
		<cfif LvarOCOtipoOD EQ "O">
			OCCid_O, OCCcodigo,
		<cfelse>
			OCIid_D, OCIcodigo,
			OCid_D, OCcontrato,
		</cfif>
			OCODmontoOrigen
		from OCotrosDetalle ip
			inner join Articulos a
				 on a.Aid = ip.Aid
			inner join OCtransporte t
				on t.OCTid = ip.OCTid
		<cfif LvarOCOtipoOD EQ "O">
			inner join OCconceptoCompra cc
				 on cc.OCCid = ip.OCCid_O
		<cfelse>
			inner join OCconceptoIngreso cc
				 on cc.OCIid = ip.OCIid_D
			inner join OCordenComercial oc
				 on oc.OCid = ip.OCid_D
		</cfif>
		where ip.OCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">
	</cfquery>

	<cfquery name="rsDataDet" dbtype="query">
		select *
		  from rsListaDet
		 where OCOid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCOid#">
		   and OCTid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		   and Aid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
	</cfquery>
	<cfif rsDataDet.recordCount GT 0>
		<cfset mododet = "CAMBIO">
	<cfelse>
		<cfset mododet = "ALTA">
	</cfif>
</cfif>

<cfoutput>
	<form name="form1" action="OC_OTROS_sql.cfm" method="post">
		<input name="OCOid" type="hidden" value="<cfif isdefined('form.OCOid') and len(trim(form.OCOid))>#form.OCOid#</cfif>">
		<input name="OCOnumero" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsData.OCOnumero#</cfif>">
		<fieldset>
			<table cellpadding="0" cellspacing="3" border="0" align="center" width="10%">
				<tr>
					<td align="right"><strong>Tipo:&nbsp;</strong></td>
					<td align="left">
					<cfif LvarOCOtipoOD EQ "O">
						<strong>Movimiento Origen Otros Costos</strong>
					<cfelse>
						<strong>Movimiento Destino Otros Ingresos</strong>
					</cfif>
						<input name="OCOtipoOD" value="#LvarOCOtipoOD#" type="hidden">
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Documento:</strong>&nbsp;</td>
					<td align="left">
						<cfif modo NEQ 'ALTA'>
							#rsData.OCOnumero#
						<cfelse>
							<strong>DOCUMENTO NUEVO</strong>
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Fecha:&nbsp;</strong></td>
					<td align="left">
						<cfif modo neq 'ALTA'>
							<cf_sifCalendario value="#dateformat(rsData.OCOfecha,'dd/mm/yyyy')#" name="OCOfecha" form="form1" >
						<cfelse>
							<cf_sifCalendario value="#dateformat(now(),'dd/mm/yyyy')#" name="OCOfecha" form="form1" >
						</cfif>
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Cuenta Financiera a <cfif LvarOCOtipoOD EQ "O">Acreditar<cfelse>Debitar</cfif>:&nbsp;</strong></td>
					<td align="left">
						<cfif modo EQ 'CAMBIO'>
							<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50" query="#rsData#">
						<cfelse>
							<cf_cuentas conexion="#Session.DSN#" conlis="S" auxiliares="N" movimiento="S" form="form1" frame="frame1" descwidth="50">
						</cfif> 
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Oficina:&nbsp;</strong></td>
					<td align="left">
						<cfset valuesArraySN = ArrayNew(1)>
						<cfif modo EQ 'CAMBIO'>
							<cfquery datasource="#Session.DSN#" name="rsO">
								select Ocodigo,Oficodigo,Odescripcion
								  from Oficinas
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								   and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsData.Ocodigo#">
							</cfquery>
							<cfset ArrayAppend(valuesArraySN, rsO.Ocodigo)>
							<cfset ArrayAppend(valuesArraySN, rsO.Oficodigo)>
							<cfset ArrayAppend(valuesArraySN, rsO.Odescripcion)>
						</cfif>
						<cf_conlis
									Campos="Ocodigo,Oficodigo,Odescripcion"
									valuesArray="#valuesArraySN#"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,60"
									
									Title="Lista de Oficinas"
									Tabla="Oficinas"
									Columnas="Ocodigo,Oficodigo,Odescripcion"
									Filtro=" Ecodigo = #Session.Ecodigo#  order by Oficodigo"
									Desplegar="Oficodigo,Odescripcion"
									Etiquetas="Codigo,Oficina"
									Formatos="S,S"
									Align="left,left"
									form="form1"
						/>
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Socio de Negocios <cfif LvarOCOtipoOD EQ "O">Origen<cfelse>Destino</cfif>:&nbsp;</strong></td>
					<td align="left">
						<cfset valuesArraySN = ArrayNew(1)>
						<cfif modo EQ 'CAMBIO'>
							<cfquery datasource="#Session.DSN#" name="rsSN">
								select SNid,SNcodigo,SNidentificacion,SNnombre
								  from SNegocios
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								   and   SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsData.SNid#">
							</cfquery>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
						<cfelseif LvarOCOtipoOD EQ "O">
							<!--- Socio de negocio default interno, representa a la propia empresa --->
							<cfquery datasource="#Session.DSN#" name="rsSQL">
								select Pvalor as SNid
								  from Parametros
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								   and Pcodigo = 444
							</cfquery>
							<cfif rsSQL.SNid EQ "">
								<cf_errorCode	code = "50445" msg = "Falta definir en Parametros el Socio de Negocios default (propia Empresa) para Movs Origenes diferentes a CxP">
							</cfif>
							<cfquery datasource="#Session.DSN#" name="rsSN">
								select SNid,SNcodigo,SNidentificacion,SNnombre
								  from SNegocios
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								   and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.SNid#">
							</cfquery>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNid)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNcodigo)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNidentificacion)>
							<cfset ArrayAppend(valuesArraySN, rsSN.SNnombre)>
						</cfif>	
						<cf_conlis
									Campos="SNid,SNcodigo,SNidentificacion,SNnombre"
									valuesArray="#valuesArraySN#"
									Desplegables="N,N,S,S"
									Modificables="N,N,S,N"
									Size="0,0,30,60"
									
									Title="Lista de Socios de Negocio"
									Tabla="SNegocios"
									Columnas="SNid,SNcodigo,SNidentificacion,SNnombre"
									Filtro=" Ecodigo = #Session.Ecodigo#  order by SNnombre "
									Desplegar="SNidentificacion,SNcodigo,SNnombre"
									Etiquetas="Identificaci&oacute;n,Codigo,Nombre"
									filtrar_por="SNidentificacion,SNcodigo,SNnombre"
									Formatos="S,S,S"
									Align="left,left,left"
									form="form1"
									Asignar="SNid,SNcodigo,SNidentificacion,SNnombre"
									Asignarformatos="S,S,S,S"
						/>
					</td>
				</tr>
				<tr>
					<td nowrap align="right"><strong>Monto Total:&nbsp;</strong></td>
					<td align="left">
						<cfquery name="rsMonedas" datasource="#Session.DSN#">
							select m.Mcodigo, m.Mnombre, m.Miso4217,
								case 
									when m.Mcodigo = #LvarMcodigoLocal# then 1.0
									else coalesce(
										<cfif LvarOCOtipoOD EQ "O">TCcompra<cfelse>TCventa</cfif>
										,1.0)
								end as TC
							from Monedas m
								left join Htipocambio tc
									 on tc.Ecodigo = m.Ecodigo
									and tc.Mcodigo = m.Mcodigo
									and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							where m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by 2
						</cfquery>
						<cfset LvarTC = 1>
						<select name="Mcodigo" onchange="sbMcodigoChange(this);">
							<cfloop query="rsMonedas">
								<option value="#rsMonedas.Mcodigo#" <cfif rsMonedas.Mcodigo EQ LvarMcodigo> selected <cfset LvarTC = rsMonedas.TC></cfif>>#rsMonedas.Mnombre#</option>
							</cfloop>
						</select>
						<cfif modo EQ "CAMBIO">
							<cf_inputnumber name="OCOtotalOrigen" form="form1" enteros="15" decimales="2" value="#rsData.OCOtotalOrigen#">
						<cfelse>
							<cf_inputnumber name="OCOtotalOrigen" form="form1" enteros="15" decimales="2" value="0.00">
						</cfif>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<strong>Tipo Cambio:</strong> 
						<cfif Modo EQ "CAMBIO" AND rsData.OCOtipoCambio NEQ 0>
							<cfset LvarTC = rsData.OCOtipoCambio>
						</cfif>
						<cf_inputnumber name="OCOtipoCambio" form="form1" enteros="10" decimales="4" value="#numberFormat(LvarTC,",9.9999")#" readonly="#LvarMcodigo EQ LvarMcodigoLocal#" tabindex="-1">
						<script language="javascript">
							var LvarMcodigos = new Array();
							<cfloop query="rsMonedas">
								LvarMcodigos["M#rsMonedas.Mcodigo#"] = #rsMonedas.TC#;
							</cfloop>
							function sbMcodigoChange(cboMcodigo)
							{
						<cfif NOT (Modo EQ "CAMBIO" AND rsData.OCOtipoCambio NEQ 0)>
								document.getElementById("OCOtipoCambio").value = LvarMcodigos["M" + cboMcodigo.value];
						</cfif>
								if (cboMcodigo.value == #LvarMcodigoLocal#)
								{
									document.getElementById("OCOtipoCambio").readOnly = true;
									document.getElementById("OCOtipoCambio").value = "1.0000";
								}
								else
								{
									document.getElementById("OCOtipoCambio").readOnly = false;
								}
							}
						</script>
				</tr>

				<tr>
					<td align="right" valign="top"><strong>Observaciones:&nbsp;</strong></td>
					<td align="left"><textarea name="OCOobservaciones" id="OCOobservaciones" rows="5" cols="60" ><cfif modo NEQ 'ALTA'><cfoutput>#rsData.OCOobservaciones#</cfoutput></cfif></textarea></td>
				</tr>
			</table>
			<cfif modo EQ "ALTA">
				<cf_botones modo='#modo#' regresar='OC_OTROS_#LvarOCOtipoOD#O.cfm'>
			<cfelse>
				<cf_botones modo='#modo#' regresar='OC_OTROS_#LvarOCOtipoOD#O.cfm' include="btnAplicar, btnVer_Aplicacion" includevalues="Aplicar, Ver_Aplicacion">
			</cfif>

			<cfif modo NEQ 'ALTA'>
				<!--- Detalle --->
				<HR size="1" color="##CCCCCC"><br>

				<table cellpadding="0" cellspacing="3" border="0" align="center" style="width:58%" style=" border-collapse:collapse">
					<tr>
						<!--- TRANSPORTE --->
						<td align="right" id="TransporteLabel">
							<strong>Transporte:&nbsp;</strong>
						</td>
							<cfif mododet neq 'ALTA'>
								<td colspan="4">
									<cfswitch expression="#rsDataDet.OCTtipo#">
										<cfcase value="B">Barco - #rsDataDet.OCTtransporte#</cfcase>
										<cfcase value="A">Avión - #rsDataDet.OCTtransporte#</cfcase>
										<cfcase value="T">Terrestre - #rsDataDet.OCTtransporte#</cfcase>
										<cfcase value="F">Ferrocarril - #rsDataDet.OCTtransporte#</cfcase>
										<cfcase value="O">Otro Tipo - #rsDataDet.OCTtransporte#</cfcase>
									</cfswitch>
									<input name="OCTtipo" value="#rsDataDet.OCTtipo#" type="hidden">
									<input name="OCTid" value="#rsDataDet.OCTid#" type="hidden">
								</td>
							<cfelse>
								<td colspan="4">
								<table cellpadding="0" cellspacing="0" border="0" align="left">
								<tr>
								<td id="TransporteImput" align="left" style="width:1%" nowrap="nowrap">
									<select id="OCTtipo" name="OCTtipo" >
										<option value="B" <cfif rsDataDet.OCTtipo EQ "B">selected</cfif>>Barco</option>
										<option value="A" <cfif rsDataDet.OCTtipo EQ "A">selected</cfif>>Avion</option>
										<option value="T" <cfif rsDataDet.OCTtipo EQ "T">selected</cfif>>Terrestre</option>
										<option value="F" <cfif rsDataDet.OCTtipo EQ "F">selected</cfif>>Ferrocarril</option>
										<option value="O" <cfif rsDataDet.OCTtipo EQ "F">selected</cfif>>Otro Tipo</option>
									</select>
								</td>
										<td>
										<cf_conlis
											Title="Lista de Transportes"

											Campos="OCTid,OCTtransporte"
											Desplegables="N,S"
											Modificables="N,S"
											Size="0,12"
											
										
											Tabla="OCtransporte"
											Columnas="OCTid, OCTtipo,
												case OCTtipo 
													when 'B' then 'Barco' 
													when 'A' then 'Avion' 
													when 'T' then 'Terrestre' 
													when 'F' then 'Ferrocarril' 
													when 'O' then 'Otro' 
												end as OCTtipoD, OCTtransporte, OCTfechaPartida"
											Filtro="OCTestado = 'A' and Ecodigo = #session.Ecodigo#"
											Desplegar="OCTtipoD,OCTtransporte,OCTfechaPartida"
											Etiquetas="Tipo,Transporte,Fecha de Partida"
											filtrar_por="case OCTtipo 
													when 'B' then 'Barco' 
													when 'A' then 'Avion' 
													when 'T' then 'Terrestre' 
													when 'F' then 'Ferrocarril' 
													when 'O' then 'Otro' 
												end,OCTtransporte,' '"
											Formatos="S,S,UD"
											Align="left,left,left"
											form="form1"
											Asignar="OCTid,OCTtipo,OCTtransporte"
											Asignarformatos="S,C,S"
										/>
										</td>
									</tr>
									</table>
								</td>
							</cfif>
						</td>
					</tr>
				<cfif LvarOCOtipoOD NEQ "O">
					<tr>
						<td align="right"><strong>&nbsp;Orden&nbsp;Comercial&nbsp;Destino:&nbsp;</strong></td>
						<td nowrap>
							<cfif mododet neq 'ALTA'>
								<input 	type="text" value="#rsDataDet.OCcontrato#"  
										tabindex="-1" readonly style="border:solid 1px ##CCCCCC; background:inherit;"
										size="20">
								<input name="OCid_D" type="hidden" value="#rsDataDet.OCid_D#">
							<cfelse>
								<cf_conlis
									Title="Órdenes Comerciales Destino"
	
									Campos="OCid_D,OCcontrato"
									Desplegables="N,S"
									Modificables="N,S"
									Size="0,20"
									Columnas="
										OCid,OCcontrato,OCfecha, case OCtipoIC when 'C' then 'DC - Dst.Comercial' when 'I' then 'DI - Dst.Inventario' end as OCtipoIC"
									Tabla="
										OCordenComercial"
									Filtro=" 
										Ecodigo = #Session.Ecodigo# 
										and OCestado = 'A' 
										and OCtipoOD='D' 
										and OCtipoIC<>'V' 
										and (select count(1) from OCtransporteProducto where OCid = OCordenComercial.OCid and OCTid=$OCTid,numeric$) > 0
										
										order by OCfecha"
	
									Desplegar="OCcontrato,OCfecha, OCtipoIC"
									Etiquetas="Contrato, Fecha, Destino<BR>Tipo "
									filtrar_por="OCcontrato,Fecha,case OCtipoIC when 'C' then 'DC - Dst.Comercial' when 'I' then 'DI - Dst.Inventario' end"
									Formatos="S,D,S" 
									Align="left,left,left" 
									form="form1"
									Asignar="OCid_D=OCid,OCcontrato"
									Asignarformatos="S,S"
								/>
							</cfif>
						</td>
					</tr>
				</cfif>
					<tr>
						<td valign="top" align="right"><strong>Artículo:&nbsp;</strong></td>
						<td colspan="4" valign="top" nowrap="nowrap">
							<cfif mododet neq 'ALTA'>
								<input 	type="text" value="#rsDataDet.Acodigo#"  
										tabindex="-1" readonly style="border:solid 1px ##CCCCCC; background:inherit;"
										size="10">
								<input type="text" value="#rsDataDet.Adescripcion#"
										tabindex="-1" readonly style="border:solid 1px ##CCCCCC; background:inherit;"
										size="50">
								<input name="Aid" type="hidden" value="#form.aid#">
							<cfelse>
								<cfif rsData.OCOtipoOD EQ "O">
									<cfset LvarFiltroArts = "and b.OCPTtransformado = 0 and t.OCtipoOD='O'">
								<cfelse>
									<!--- No se filtra por t.OCtipoOD='D' porque se filtra por OCid --->
									<cfset LvarFiltroArts = "and t.OCid	= $OCid_D,numeric$">
								</cfif>
								<cf_conlis
									Title			="Lista de Artículos del Transporte"

									Campos			="Aid, Acodigo, Adescripcion"
									Desplegables	="N, S, S"
									Modificables	="N, S, N"
									Size			="0, 10, 50"
									Tabla			="OCproductoTransito b
														inner join Articulos a
														 on a.Aid = b.Aid
														inner join OCtransporteProducto t
														  on t.OCTid = b.OCTid
														 and t.Aid = b.Aid
													"
									Columnas		="a.Aid, a.Acodigo, a.Adescripcion, a.Ucodigo,  a.Ucodigo as Ucodigo2, 
														case b.OCPTentradasCantidad 
															when 0 then 0 
															else b.OCPTentradasCostoTotal/b.OCPTentradasCantidad 
														end as OCIcostoU, 
														b.OCPTentradasCantidad+b.OCPTsalidasCantidad as OCIexistencias"
									Filtro			="	b.Ecodigo = #session.Ecodigo#
														and b.OCTid = $OCTid,numeric$
														#LvarFiltroArts#
														"
									Desplegar		="Acodigo, Adescripcion, Ucodigo, OCIcostoU"
									Etiquetas		="Código,Descripción, Unidad, Unitario"
									filtrar_por		="Acodigo, Adescripcion, Ucodigo, OCIcostoU"
									Formatos		="S,S,S,M"
									Align			="left,left,left,right"
									form			="form1"
									Asignar			="Aid, Acodigo, Adescripcion, Ucodigo, Ucodigo2, OCIcostoU, OCIexistencias"
									Asignarformatos	="S, S, S, S, S, S, S"
											/>	
							</cfif>			
						</td>
					</tr>
				<cfif LvarOCOtipoOD EQ "O">
					<tr>
						<td align="right"><strong>&nbsp;Concepto&nbsp;Costo:&nbsp;</strong></td>
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select OCCid, OCCcodigo, OCCdescripcion
							  from OCconceptoCompra
							 where Ecodigo = #session.Ecodigo#
							   and OCCcodigo <> '00'
						</cfquery>
						
						<td nowrap>
							<select name="OCCid_O">
							<cfloop query="rsSQL">
								<option value="#rsSQL.OCCid#" <cfif ModoDet EQ "CAMBIO" AND rsSQL.OCCid EQ rsListaDet.OCCid_O>selected</cfif>>#rsSQL.OCCcodigo# - #rsSQL.OCCdescripcion#</option>
							</cfloop>
							</select>
						</td>
						<td align="right"><strong>&nbsp;Monto&nbsp;Costo:&nbsp;</strong></td>
						<td nowrap>
							<cf_inputnumber name="OCODmontoOrigen" form="form1" enteros="15" decimales="2" value="#rsDataDet.OCODmontoOrigen#">
							#LvarMiso4217#
						</td>
					</tr>
				<cfelse>
					<tr>
						<td align="right"><strong>&nbsp;Concepto&nbsp;Ingreso:&nbsp;</strong></td>
						<cfquery name="rsSQL" datasource="#session.DSN#">
							select OCIid, OCIcodigo, OCIdescripcion
							  from OCconceptoIngreso
							 where Ecodigo = #session.Ecodigo#
							   and OCIcodigo <> '00'
						</cfquery>
						
						<td nowrap>
							<select name="OCIid_D">
							<cfloop query="rsSQL">
								<option value="#rsSQL.OCIid#" <cfif ModoDet EQ "CAMBIO" AND rsSQL.OCIid EQ rsListaDet.OCIid_D>selected</cfif>>#rsSQL.OCIcodigo# - #rsSQL.OCIdescripcion#</option>
							</cfloop>
							</select>
						</td>
						<td align="right"><strong>&nbsp;Monto&nbsp;Ingreso:&nbsp;</strong></td>
						<td nowrap>
							<cf_inputnumber name="OCODmontoOrigen" form="form1" enteros="15" decimales="2" value="#rsDataDet.OCODmontoOrigen#">
							#LvarMiso4217#
						</td>
					</tr>
				</cfif>
					<tr><td>&nbsp;</td></tr>
				</table>
				<cfif mododet EQ "ALTA">
					<cf_botones modo='CAMBIO' mododet="ALTA" names="altaDet" values="Agregar">
				<cfelse>
					<cf_botones modo='CAMBIO' mododet="CAMBIO" names="cambioDet,bajaDet,NuevoDet" values="Modificar,Eliminar,Nueva">
				</cfif>
			</cfif>	

		<cf_qforms form="form1">
			<cf_qformsrequiredfield args="OCOfecha,Fecha">
			<cf_qformsrequiredfield args="CFcuenta,Cuenta Financiera">
			<cf_qformsrequiredfield args="SNid,Socio de Negocios">
			<cf_qformsrequiredfield args="Mcodigo, Moneda">
			<cf_qformsrequiredfield args="OCOtotalOrigen, Monto Total">
		</cf_qforms>
	</form>
	<cfif modo NEQ 'ALTA'>
		<cf_qforms form="form2">
			<cf_qformsrequiredfield args="OCTid,Transporte">
			<cf_qformsrequiredfield args="Aid,Artículo">
			<cfif LvarOCOtipoOD EQ "O">
				<cf_qformsrequiredfield args="OCCid_O,Concepto de Costo">
				<cf_qformsrequiredfield args="OCODmontoOrigen,Monto del Costo">
				<cfset LvarDesplegar = "Tipo,OCTtransporte,Acodigo,Adescripcion,OCCcodigo,OCODmontoOrigen">
				<cfset LvarEtiquetas = "Tipo,Transporte,Articulo,Descripcion,Concepto<BR>Costo,Costo<BR>#LvarMiso4217#">
				<cfset LvarFormatos	 = "S,S,S,S,S,M">
				<cfset LvarAlign	 = "left,left,left,left,left,right">
			<cfelse>
				<cf_qformsrequiredfield args="OCid_D,Orden Comercial Destino">
				<cf_qformsrequiredfield args="OCIid_D,Concepto de Ingreso">
				<cf_qformsrequiredfield args="OCODmontoOrigen,Monto del Ingreso">
				<cfset LvarDesplegar = "Tipo,OCTtransporte,OCcontrato,Acodigo,Adescripcion,OCIcodigo,OCODmontoOrigen">
				<cfset LvarEtiquetas = "Tipo,Transporte,O.C.Destino, Articulo,Descripcion,Concepto<BR>Ingreso,Ingreso<BR>#LvarMiso4217#">
				<cfset LvarFormatos	 = "S,S,S,S,S,S,M">
				<cfset LvarAlign	 = "left,left,left,left,left,left,right">
			</cfif>
		</cf_qforms>
		<cfinvoke component="sif.Componentes.pListas"
					method				="pListaQuery"
					returnvariable		="pListaRet"

					Query				= "#rsListaDet#"
					Desplegar			= "#LvarDesplegar#"
					Etiquetas			= "#LvarEtiquetas#"
					Formatos			= "#LvarFormatos#"
					Align				= "#LvarAlign#"
					Ajustar 			= "S"
					IrA					= "OC_OTROS_#LvarOCOtipoOD#O.cfm"
					Navegacion 			= "#navegacion#"
					IncluyeForm			= "yes"
					FormName			= "form2"
					Keys				= "OCOid, OCTid, Aid"
					showEmptyListMsg	= "true"
		>
	</cfif>

	</fieldset>

	
</cfoutput>
<script language="javascript">
	function funcNuevo()
	{
		deshabilitarValidacion_form2();
	}
	function funcBaja()
	{
		deshabilitarValidacion_form2();
	}
	function funcCambio()
	{
		deshabilitarValidacion_form2();
	}
	function funcbtnAplicar()
	{
		deshabilitarValidacion_form2();
	}
	function funcbtnVer_Aplicacion()
	{
		deshabilitarValidacion_form2();
	}
</script>


