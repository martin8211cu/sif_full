<cf_templateheader title="Transformaci&oacute;n de Productos en Transito">
<cfset  modo = 'ALTA'>
<cfif isdefined("form.OCTTid") and len(trim(form.OCTTid))>
	<cfset  modo = 'CAMBIO'>
	<cfquery name="rsDatos" datasource="#session.dsn#">
		Select 
			a.OCTid, 
			a.OCTTid,
			a.OCTTestado,
			b.OCTtipo, b.OCTtransporte,
			a.OCTTdocumento,
			a.OCTTfecha,
			a.OCTTmanual,
			a.OCTTobservaciones
		from  OCtransporteTransformacion a
			inner join OCtransporte b
				 on b.OCTid		= a.OCTid
				and b.Ecodigo	= a.Ecodigo
		where OCTTestado =0
		and a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
	</cfquery>
	<cfif rsDatos.OCTTestado NEQ "0">
		<cf_errorCode	code = "50446" msg = "El Documento no está Abierto">
	</cfif>


	<cfquery datasource="#session.dsn#">
		update OCtransporteTransformacionD
		   set OCTTDcantidad =
					(
						select 
								case 
									when pt.OCPTentradasCantidad <= 0 OR (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad) <= 0 then 0
									when (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad) < OCtransporteTransformacionD.OCTTDcantidad then (pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)
									else OCtransporteTransformacionD.OCTTDcantidad
								end
						  from OCproductoTransito pt
						 where pt.OCTid	= OCtransporteTransformacionD.OCTid
						   and pt.Aid	= OCtransporteTransformacionD.Aid
					)
		 where OCTTid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and Ecodigo		=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and OCTTDtipoOD	= 'O'
	</cfquery>

	<cfquery name="rsDatosOrigen" datasource="#session.dsn#">
		select
				a.Aid, a.Acodigo
				,min(pt.OCPTentradasCantidad)*100/100									as OCPTentradasCantidad
				,floor(min(pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)*100)/100	as Existencia
				,min(case when pt.OCPTtransformado=1 then 1 else 0 end)					as OCPTtransformado
				,coalesce(min(td.OCTTDcantidad),0)										as OCTTDcantidad
				,coalesce(
					sum (case when pt.OCPTentradasCantidad = 0 then 0 when cc.OCCcodigo = '00' then m.OCPTMmontoValuacion / pt.OCPTentradasCantidad end)
					,0) as CostoUniProd
				,coalesce(
					sum (case when pt.OCPTentradasCantidad = 0 then 0 when cc.OCCcodigo <> '00' then m.OCPTMmontoValuacion / pt.OCPTentradasCantidad end)
					,0) as CostoUniNoProd
				,coalesce(
					min (case when pt.OCPTentradasCantidad = 0 then 0 else pt.OCPTentradasCostoTotal/pt.OCPTentradasCantidad end)
					,0) as CostoUnitario
		  from OCproductoTransito pt
			inner join Articulos a
			   on a.Aid	= pt.Aid
			left join OCPTmovimientos m
				inner join OCconceptoCompra cc
					 on cc.OCCid		= m.OCCid
				 on m.OCTid	= pt.OCTid
				and m.Aid	= pt.Aid
				and m.OCPTMtipoOD = 'O' AND m.OCPTMtipoICTV in ('I','C','O')
			left join OCtransporteTransformacionD td
			   on td.OCTTid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
			  and td.OCTid			= pt.OCTid
			  and td.Aid			= pt.Aid
			  and td.OCTTDtipoOD	= 'O'
		 where pt.OCTid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.OCTid#">
		   and pt.Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and (
		   		select count(1)
				  from OCtransporteProducto tp
				 where tp.OCTid		= pt.OCTid
				   and tp.Aid		= pt.Aid
				   and tp.OCtipoOD	= 'O'
			) > 0
		 group by
				a.Aid, a.Acodigo
		order by a.Acodigo
	</cfquery>

	<cfquery datasource="#session.dsn#">
		update OCtransporteTransformacionD
		   set OCTTDcantidad =
		   		CASE 
					when
						(
							select count(1)
							  from OCtransporteProducto
							 where OCTid	= OCtransporteTransformacionD.OCTid
							   and Aid		= OCtransporteTransformacionD.Aid
							   and OCtipoOD	= 'O'
						)	> 0 then 0
					when
						(
							select count(1)
							  from OCproductoTransito pt
							 where pt.OCTid	= OCtransporteTransformacionD.OCTid
							   and pt.Aid	= OCtransporteTransformacionD.Aid
							   and (
									pt.OCPTtransformado = 1 OR 
									pt.OCPTentradasCantidad <> 0 OR 
									pt.OCPTsalidasCantidad <> 0
							   )
						)	> 0 then 0
					else OCTTDcantidad
				end
		 where OCTTid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and OCTTDtipoOD	= 'D'
	</cfquery>

	<cfquery name="rsDatosDestino" datasource="#session.dsn#">
		select
				a.Aid, a.Acodigo, 
				oc.OCcontrato,

				(
					select count(1)
					  from OCtransporteProducto
					 where OCTid	= tp.OCTid
					   and Aid		= tp.Aid
					   and OCtipoOD	= 'O'
				)													as Origenes,
				pt.OCPTtransformado,
				coalesce(pt.OCPTentradasCantidad,0)					as OCPTentradasCantidad,
				coalesce(pt.OCPTsalidasCantidad,0)					as OCPTsalidasCantidad,
				(pt.OCPTentradasCantidad + pt.OCPTsalidasCantidad)	as Existencia,
				OCTPcantidadTeorica,

				coalesce(td.OCTTDcantidad,0) as OCTTDcantidad,
				coalesce(td.OCTTDcostoTotal,0) as OCTTDcostoTotal

				, coalesce(OCTTDproporcionManualDst,0) as OCTTDproporcionManualDst 
		  from OCtransporteTransformacion t
		  	inner join OCtransporteProducto tp
				inner join Articulos a
				   on a.Aid	= tp.Aid
				inner join OCordenComercial oc
				   on oc.OCid	= tp.OCid
				inner join OCproductoTransito pt
				   on pt.OCTid	= tp.OCTid
				  and pt.Aid	= tp.Aid
			   on tp.OCTid		= t.OCTid
			  and tp.OCtipoOD	= 'D'
			left join OCtransporteTransformacionD td
			   on td.OCTTid			= t.OCTTid
			  and td.Aid			= tp.Aid
			  and td.OCTTDtipoOD	= 'D'
		 where t.OCTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and t.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		order by a.Aid, oc.OCcontrato
	</cfquery>



	<cfquery name="rsTotalDestino" datasource="#session.dsn#">
		select	coalesce(sum(td.OCTTDcantidad),0) as cantidad,
				coalesce(sum(td.OCTTDproporcionManualDst),0) as TotalManual_Dst
		  from OCtransporteTransformacionD td
		 where td.OCTTid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTTid#">
		   and td.Ecodigo	=  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		   and td.OCTTDtipoOD	= 'D'
	</cfquery>
	
</cfif>
	<style>
		.numOutput
		{
			font-size:9px; 
			text-align:right; 
			border:none;
		}
		.numInput
		{
			font-size:9px; 
			text-align:right; 
		}
	</style>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Transformaci&oacute;n de Productos en Transito">
					<script language="JavaScript" src="../../js/utilesMonto.js"></script>
					<form action="TransfProdTransito-sql.cfm" method="post" name="form1">
						<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
							<tr><td><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
							<cfif  modo NEQ 'ALTA'>
							<tr>
								<td>
								<a href="javascript: verEncabezado('Ecabezado');" ><img  id="img_Ecabezado" src="../../imagenes/abajo.gif"  width="10" height="10" border="0" >
									Ocultar encabezado	</a> 
								</td>
							</tr>
							</cfif>
							<cfoutput>
							<tr id="TR_Ecabezado">
								<td>
									<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
										<tr>
											<td width="10%" align="right" valign="top"><strong>Tipo:</strong>&nbsp;&nbsp;</td>
											<td width="20%">
												<strong>Transformación de Producto</strong>
											</td>
										</tr>

										<tr>
											<td width="10%" align="right" valign="top"><strong>Transporte:</strong>&nbsp;&nbsp;</td>
											<td width="20%">
										<cfif isdefined("rsDatos.OCTid") and len(trim(rsDatos.OCTid))>
												<cfswitch expression="#rsDatos.OCTtipo#">
													<cfcase value="B">Barco - #rsDatos.OCTtransporte#</cfcase>
													<cfcase value="A">Avión - #rsDatos.OCTtransporte#</cfcase>
													<cfcase value="T">Terrestre - #rsDatos.OCTtransporte#</cfcase>
													<cfcase value="F">Ferrocarril - #rsDatos.OCTtransporte#</cfcase>
													<cfcase value="O">Otro Tipo - #rsDatos.OCTtransporte#</cfcase>
												</cfswitch>
												<input name="OCTtipo" value="#rsDatos.OCTtipo#" type="hidden">
												<input name="OCTid" value="#rsDatos.OCTid#" type="hidden">
										<cfelse>
												<table cellpadding="0" cellspacing="0" border="0" align="left">
													<tr>
														<td id="TransporteImput" align="left" style="width:1%" nowrap="nowrap">
															<select id="OCTtipo" name="OCTtipo" >
																<option value="B">Barco</option>
																<option value="A">Avion</option>
																<option value="T">Terrestre</option>
																<option value="F">Ferrocarril</option>
																<option value="O">Otro Tipo</option>
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
											</cfif>
											</td>
										</tr>	
										<tr>
											<td width="10%" align="right" valign="top"><strong>Documento:</strong>&nbsp;&nbsp;</td>
											<td width="20%">
												<input 	
													type="text" 
													size="20" 
													maxlength="20" 
													tabindex="1"
													onfocus="this.select()" 
													name="OCTTdocumento" value="<cfif isdefined("rsDatos.OCTTdocumento") and len(trim(rsDatos.OCTTdocumento))>#rsDatos.OCTTdocumento#</cfif>"
												>
											</td>
										</tr>
										<tr>
											<td width="10%" align="right" valign="top"><strong>Fecha:</strong>&nbsp;&nbsp;</td>
											<td width="20%">
												<table cellpadding="0" cellspacing="0"><tr><td>
												<cfif isdefined("rsDatos.OCTTfecha") and len(rsDatos.OCTTfecha)>
													<cf_sifcalendario form="form1" name="OCTTfecha" value="#LSDateformat(rsDatos.OCTTfecha,'dd/mm/yyyy')#" tabindex="1">
												<cfelse>
													<cf_sifcalendario form="form1" name="OCTTfecha" tabindex="1" value="#dateFormat(now(),'dd/mm/yyyy')#">
												</cfif>	
												</td><td width="180">&nbsp;
												</td><td>
												<strong>Distribución Manual:</strong>
												<input type="checkbox" name="OCTTmanual" value="1"
													<cfif isdefined("rsDatos.OCTTmanual") and rsDatos.OCTTmanual EQ "1">
														checked
													</cfif>
												/>
												<cfif isdefined("rsDatos.OCTTmanual") and rsDatos.OCTTmanual EQ "1">
													<cfif rsTotalDestino.TotalManual_Dst NEQ 100>
														<font color="##FF0000"><strong>#rsTotalDestino.TotalManual_Dst#%</strong></font>
													<cfelse>
														<font color="##00CC00"><strong>#rsTotalDestino.TotalManual_Dst#%</strong></font>
													</cfif>
												</cfif>
												</td></tr></table>
											</td>
										</tr>
										<tr>
											<td width="10%" align="right" valign="top"><strong>Observaciones:</strong>&nbsp;&nbsp;</td>
											<td width="20%">
												<textarea tabindex="1" name="OCTTobservaciones" cols="70" rows="4"><cfif isdefined("rsDatos.OCTTobservaciones") and len(rsDatos.OCTTobservaciones)>#rsDatos.OCTTobservaciones#</cfif></textarea>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<cfif  modo EQ 'ALTA'>
										<cf_botones modo="#modo#" tabindex="1"></td>
									<cfelse>
										<cf_botones modo="#modo#" include='Aplicar,VerAplicacion' includevalues='Aplicar,Ver_Aplicacion' tabindex="1"></td>
									</cfif>	
								</td>
							</tr>	
							<tr>
								<td>	
							</cfoutput>
								<cfif  modo NEQ 'ALTA'>
									<input name="OCTTid" type="hidden" value="<cfoutput>#rsDatos.OCTTid#</cfoutput>">
									<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
										<tr>
											<td width="60%" valign="top">
												<!--- PRODUCTOS ORIGEN ------------------------------------------------------------------------------------>
												<fieldset><legend>Productos Origen</legend>
												<table width="100%" border="0">
													<tr>
														<td>
															<table width="100%" border="0" cellpadding="0" cellspacing="2">
																<tr bgcolor="#CCCCCC">
																	<td><strong>Producto</strong></td>
																	<td align="right"><strong>Existencia</strong></td>
																	<td align="right"><strong>Cantidad</strong></td>
																	<td align="right" nowrap>&nbsp;&nbsp;<strong>Costo Producto</strong></td>
																	<td align="right">&nbsp;&nbsp;<strong>Otros Costos</strong></td>
																</tr>
																<cfset LvarTotalCostoProd_Ori	= 0>
																<cfset LvarTotalCostoNoProd_Ori	= 0>
																<cfset LvarTotalCostoTotal_Ori	= 0>
																<cfset LvarAidOri="">
																<cfoutput>
																<cfloop query="rsDatosOrigen">
																	<cfset LvarOCs="">
																	<cfset LvarAidOri		= LvarAidOri & "#rsDatosOrigen.Aid#,">
																	<cfset LvarCantidad		= rsDatosOrigen.OCTTDcantidad>
																	<cfset LvarCostoProd 	= numberFormat(rsDatosOrigen.CostoUniProd	* LvarCantidad, "9.99")>
																	<cfset LvarCostoNoProd	= numberFormat(rsDatosOrigen.CostoUniNoProd	* LvarCantidad, "9.99")>
																	<cfset LvarCostoTotal	= numberFormat(rsDatosOrigen.CostoUnitario	* LvarCantidad, "9.99")>
																	<cfquery name="rsOCs" datasource="#session.dsn#">
																		select distinct oc.OCcontrato
																		  from OCtransporteProducto tp
																			inner join OCordenComercial oc
																			   on oc.OCid	= tp.OCid
																		 where tp.OCTid		= #rsDatos.OCTid#
																		   and tp.Aid		= #rsDatosOrigen.Aid#
																		   and tp.OCtipoOD	= 'O'
																		order by oc.OCcontrato
																	</cfquery>
																	<cfset LvarOCs = "">
																	<cfloop list="#ValueList(rsOCs.OCcontrato)#" index="LvarOC">
																		<cfset LvarOCs = LvarOCs & "<span style='font-size:9px; color:##0000CC; white-space:nowrap;'>" & trim(LvarOC) & "</span> ">
																	</cfloop>
																	<tr>
																		<td style="font-size:9px">
																			<input 	type="hidden"  name="Aid_Ori" value="#rsDatosOrigen.Aid#">
																			#rsDatosOrigen.Acodigo#<BR>(OC=#LvarOCs#)
																		</td>
																		<td align="right" style="font-size:9px">#numberFormat(rsDatosOrigen.existencia,',9.99')#</td>
																		<td style="font-size:9px" align="right">

																		<cfset LvarError = "">
																		<cfif rsDatosOrigen.OCPTtransformado EQ 1>
																			<cfset LvarError = "es un producto Transformado">
																		<cfelseif rsDatosOrigen.OCPTentradasCantidad EQ 0>
																			<cfset LvarError = "no ha tenido entradas">
																		<cfelseif rsDatosOrigen.Existencia LTE 0>
																			<cfset LvarError = "no tiene existencias">
																		</cfif>
																		<cfif LvarError NEQ "">
																			<cfset LvarError = "El Producto no puede mezclarse en una Transformación porque #LvarError#">
																			<input 	type="hidden" name="CantidadOri_#rsDatosOrigen.Aid#" id="CantidadOri_#rsDatosOrigen.Aid#" value="0">
																			<input 	type="text" 
																					value="N/A"
																					class="numInput" style="border:none; background-color:##CCCCCC; text-align:center; cursor:pointer;"
																					tabindex="-1" readonly="yes"
																					size="15"
																					title="#LvarError#"
																					onclick="alert('#LvarError#')"
																			>
																		<cfelse>
																			<input 	type="text" 
																					name="CantidadOri_#rsDatosOrigen.Aid#" id="CantidadOri_#rsDatosOrigen.Aid#" 
																					value="<cfif modo NEQ "ALTA">#numberFormat(LvarCantidad,',9.99')#<cfelse>0.00</cfif>" 
																					class="numInput" tabindex="1" 
																					size="15" maxlength="15"
																					onFocus="javascript:this.select();" 
																					onKeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
																					onBlur="javascript: fm(this,2); fnCantidadOri(this, '#rsDatosOrigen.Aid#', #rsDatosOrigen.Existencia#, #rsDatosOrigen.CostoUniProd#, #rsDatosOrigen.CostoUniNoProd#);" 
																					onChange="GvarCambiado=true;"
																			>
																		</cfif>
																		</td>
																		<td style="font-size:9px" align="right">
																			<input 	type="text"
																					name="CostoProd_#rsDatosOrigen.Aid#" id="CostoProd_#rsDatosOrigen.Aid#" 
																					value="#numberFormat(LvarCostoProd,',9.99')#" 
																					class="numOutput" tabindex="-1" readonly="yes"
																					size="15" maxlength="15"
																			>
																		</td>																			
																		<td style="font-size:9px" align="right">
																			<input 	type="text"
																					name="CostoNoProd_#rsDatosOrigen.Aid#" id="CostoNoProd_#rsDatosOrigen.Aid#" 
																					value="#numberFormat(LvarCostoNoProd,',9.99')#" 
																					class="numOutput" tabindex="-1" readonly="yes"
																					size="15" maxlength="15"
																			>
																		</td>	
																																		
																	</tr>
																	<cfset LvarTotalCostoProd_Ori	= LvarTotalCostoProd_Ori 	+ #LvarCostoProd#>
																	<cfset LvarTotalCostoNoProd_Ori	= LvarTotalCostoNoProd_Ori	+ #LvarCostoNoProd#>
																	<cfset LvarTotalCostoTotal_Ori	= LvarTotalCostoTotal_Ori	+ #LvarCostoTotal#>
																</cfloop>
																	<tr style="height:1px;">
																		<td  colspan="5"><hr></td>	
																	</tr>
																</cfoutput>
																<cfset LvarTotalCosto = LvarTotalCostoTotal_Ori>
																<tr>
																	<td  colspan="3">&nbsp; </td>	
																	<td align="right">
																		<input	type="text"
																				name="TotalCostoProd_Ori" id="TotalCostoProd_Ori" 
																				value="<cfoutput>#numberFormat(LvarTotalCostoProd_Ori,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="20"
																		>
																	</td>
																	<td align="right">
																		<input	type="text"
																				name="TotalCostoNoProd_Ori" id="TotalCostoNoProd_Ori" 
																				value="<cfoutput>#numberFormat(LvarTotalCostoNoProd_Ori,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="20"
																		>
																	</td>
																</tr>
																<tr>
																	<td colspan="3">&nbsp; </td>	
																	<td align="right">
																		<strong style="font-size:10px;">Costo Total:</strong>
																	</td>	
																	<td align="right">
																		<input 	type="text"
																				name="TotalCosto_Ori" id="TotalCosto_Ori" 
																				value="<cfoutput>#numberFormat(LvarTotalCosto,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="15" maxlength="15"
																		>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
												</fieldset>
											</td>
											<td width="40%" valign="top">
												<!--- PRODUCTOS DESTINO ------------------------------------------------------------------------------------>
												<fieldset><legend>Productos Destino</legend>
												<table width="100%" border="0">
													<tr>
														<td>
															<table width="100%" border="0" cellpadding="0"  cellspacing="2">
																<tr bgcolor="#CCCCCC">
																	<td ><strong>Producto</strong></td>
																	<td align="right"><strong>Cantidad</strong></td>
																	<td align="right">&nbsp;&nbsp;<strong>Costo</strong></td>
																	<cfif rsDatos.OCTTmanual eq "1">
																		<td align="right">&nbsp;&nbsp;<strong>Distribuc. Manual</strong></td>
																	</cfif>
																</tr>
																<cfset LvarTotalManual_Dst = 0>
																<cfset LvarTotalCosto_Dst = 0>
																<cfset LvarTotalCantidad_Dst  = 0>

																<cfset LvarAidDst="">
																<cfoutput query="rsDatosDestino" group="Aid">
																	<cfset LvarOCs="">
																	<cfset LvarAidDst=LvarAidDst & "#Aid#,">
																	<cfoutput group="OCcontrato">
																		<cfset LvarOCs = LvarOCs & "<span style='font-size:9px; color:##0000CC; white-space:nowrap;'>" & trim(OCcontrato) & "</span> ">
																	</cfoutput>
																	<tr>
																		<td style="font-size:9px">
																			<input 	type="hidden"  name="Aid_Dst" value="#rsDatosDestino.Aid#">
																			#rsDatosDestino.Acodigo#<BR>(OC=#LvarOCs#)
																		</td>
																		<td style="font-size:9px" align="right">
																		<cfset LvarError = "">
																		<cfif rsDatosDestino.Origenes NEQ 0>
																			<cfset LvarError = "está registrado en el Transporte tanto como Origen como Destino">
																		<cfelseif rsDatosDestino.OCPTtransformado EQ 1>
																			<cfset LvarError = "ya es producto Transformado">
																		<cfelseif rsDatosDestino.OCPTentradasCantidad NEQ 0>
																			<cfset LvarError = "ya ha tenido entradas">
																		<cfelseif rsDatosDestino.OCPTsalidasCantidad NEQ 0>
																			<cfset LvarError = "ya ha tenido salidas">
																		</cfif>
																		<cfif LvarError NEQ "">
																			<cfset LvarError = "El Producto no puede producirse en una Transformación porque #LvarError#">
																			<input 	type="hidden" name="CantidadDst_#rsDatosDestino.Aid#" id="CantidadDst_#rsDatosDestino.Aid#" value="0">
																			<input 	type="text" 
																					value="N/A"
																					class="numInput" style="border:none; background-color:##CCCCCC; text-align:center; cursor:pointer;"
																					tabindex="-1" readonly="yes"
																					size="15"
																					title="#LvarError#"
																					onclick="alert('#LvarError#')"
																			>
																		<cfelse>
																			<input type="button" value="?" 
																					onclick="GvarCambiado=true;this.form.CantidadDst_#rsDatosDestino.Aid#.value = #numberFormat(rsDatosDestino.OCTPcantidadTeorica,"9.99")#; this.form.CantidadDst_#rsDatosDestino.Aid#.focus();"
																					title="Cantidad registrada en el Transporte"
																					style="font-size:9px"
																				>
																			<input 	type="text" 
																					name="CantidadDst_#rsDatosDestino.Aid#" id="CantidadDst_#rsDatosDestino.Aid#" 
																					value="#numberFormat(rsDatosDestino.OCTTDcantidad,',9.99')#" 
																					class="numInput" tabindex="1" 
																					size="15" maxlength="15"
																					onFocus="javascript:this.select();" 
																					onKeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
																					onBlur="javascript: fm(this,2);fnDestinos();" 
																					onChange="GvarCambiado=true;"
																			>
																		</cfif>
																		</td>
																		<td style="font-size:9px" align="right">
																			<input 	type="text"
																					name="Costo_#rsDatosDestino.Aid#" id="Costo_#rsDatosDestino.Aid#" 
																					value="#numberFormat(rsDatosDestino.OCTTDcostoTotal,',9.99')#" 
																					class="numOutput" tabindex="-1" readonly="yes"
																					size="15" maxlength="15"
																					onFocus="javascript:this.select();" 
																					onKeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
																					onBlur="javascript: fm(this,4);fnDestinos();" 
																					onChange="GvarCambiado=true;"
																			>
																		</td>																																																				
																	<cfif rsDatos.OCTTmanual eq "1">
																		<cfset LvarTotalManual_Dst = LvarTotalManual_Dst + #rsDatosDestino.OCTTDproporcionManualDst#>
																		<td style="font-size:9px" align="right">
																			<cfif LvarError EQ "">
																			<input 	type="text"
																					name="Manual_#rsDatosDestino.Aid#" id="Manual_#rsDatosDestino.Aid#" 
																					value="#numberFormat(rsDatosDestino.OCTTDproporcionManualDst,',9.9999')#" 
																					class="numInput" tabindex="1" 
																					size="7" maxlength="7"
																					onFocus="javascript:this.select();" 
																					onKeyup="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
																					onBlur="javascript: fm(this,4);fnDestinos();" 
																					onChange="GvarCambiado=true;"
																			>%
																			</cfif>
																		</td>																																																				
																	</cfif>
																	</tr>
																	<cfset LvarTotalCosto_Dst = LvarTotalCosto_Dst + #rsDatosDestino.OCTTDcostoTotal#>
																	<cfset LvarTotalCantidad_Dst = LvarTotalCantidad_Dst + #rsDatosDestino.OCTTDcantidad#>
																</cfoutput>
																<cfif LvarTotalCantidad_Dst EQ 0>
																	<cfset LvarTotalCosto_Dst	= 0>
																	<cfset LvarCostoUnit_Dst	= 0>
																<cfelse>
																	<cfset LvarTotalCosto_Dst	= LvarTotalCosto>
																	<cfset LvarCostoUnit_Dst	= LvarTotalCosto_Dst/LvarTotalCantidad_Dst>
																</cfif>
																<tr>
																	<td  colspan="4"><hr></td>	
																</tr>
																<tr>
																	<td>&nbsp; </td>	
																	<td align="right">
																		<input 	type="text"
																				name="TotalCantidad_Dst" id="TotalCantidad_Dst"
																				value="<cfoutput>#numberFormat(LvarTotalCantidad_Dst,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="15" maxlength="15"
																		>
																	</td>	
																	<td align="right">
																		<input 	type="text"
																				name="TotalCosto_Dst" id="TotalCosto_Dst" 
																				value="<cfoutput>#numberFormat(LvarTotalCosto,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="15" maxlength="15"
																		>
																	</td>
																	<cfif rsDatos.OCTTmanual eq "1">
																	<td style="font-size:9px" align="right">
																		<input 	type="text"
																				name="TotalManual_Dst" id="TotalManual_Dst" 
																				value="<cfoutput>#numberFormat(LvarTotalManual_Dst,',9.9999')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="7" maxlength="7"
																		> %
																	</td>
																	</cfif>
																</tr>																
																<tr>
																	<td>&nbsp; </td>	
																	<td align="right">
																		<strong style="font-size:10px;">Costo Unitario:</strong>
																	</td>	
																	<td align="right">
																		<input 	type="text"
																				name="CostoUnit_Dst" id="CostoUnit_Dst" 
																				value="<cfoutput>#numberFormat(LvarCostoUnit_Dst,',9.99')#</cfoutput>" 
																				class="numOutput" tabindex="-1" readonly="yes"
																				size="15" maxlength="15"
																		>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
												</fieldset>
											</td>
										</tr>
										<tr>
											<td  colspan="2" align="center">
											<!---<input class="btnNormal" type="reset" name="Refrescar" value="Refrescar" tabindex="1">
											 <input type="submit" name="btnCalcular" class="btnNormal" value="Calcular" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcCalcular) return funcCalcular();" tabindex="1"> --->
											<td>
										</tr>
									</table>
								</cfif>								
								</td>
							</tr>
						</table>
					</form>
				<cf_web_portlet_end>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	
<cf_qforms>

<cfif  modo NEQ 'ALTA'>
	<cfset LvarAidOri = replace(LvarAidOri & ",", ",,", "", "ALL")>
	<cfset LvarAidDst = replace(LvarAidDst & ",", ",,", "", "ALL")>
	<script language="JavaScript" type="text/javascript">
		function toNumber(strNumber)
		{
			return Number(qf(strNumber));
		}
		
		function fnCantidadOri(obj, Aid, LvarExistencia, LvarCostoProd, LvarCostoNoProd)
		{
			if (obj.value == "") obj.value = "0.00";
			var LvarCantidad	= toNumber(obj.value);
			var objCostoProd	= document.getElementById("CostoProd_" + Aid);
			var objCostoNoProd	= document.getElementById("CostoNoProd_" + Aid);
	
			if (LvarCantidad > LvarExistencia)
			{
				if (confirm("La cantidad " + LvarCantidad + " es mayor a la existencia " + LvarExistencia + ". ¿Desea asignar la existencia?"))
					LvarCantidad = LvarExistencia;
				else
					LvarCantidad = 0;
			}
			if (LvarExistencia == 0 || LvarCantidad == 0)
			{
				obj.value 			 = "0.00";
				objCostoProd.value 	 = "0.00";
				objCostoNoProd.value = "0.00";
			}
			else
			{
				obj.value 			 = LvarCantidad;
				objCostoProd.value 	 = LvarCostoProd  * LvarCantidad;
				objCostoNoProd.value = LvarCostoNoProd * LvarCantidad;
			
				fm(objCostoProd,2)
				fm(objCostoNoProd,2)
				fm(obj,2)
			}
			
			var LvarAids 		 = "<cfoutput>#LvarAidOri#</cfoutput>".split(",");
			var LvarTotalCostoProd	 = 0;
			var LvarTotalCostoNoProd = 0;
			for (i=0; i<LvarAids.length; i++)
			{
				LvarTotalCostoProd	 += toNumber(document.getElementById("CostoProd_" + LvarAids[i]).value);
				LvarTotalCostoNoProd += toNumber(document.getElementById("CostoNoProd_" + LvarAids[i]).value);
			}
			document.form1.TotalCostoProd_Ori.value		= LvarTotalCostoProd;
			document.form1.TotalCostoNoProd_Ori.value	= LvarTotalCostoNoProd;
			document.form1.TotalCosto_Ori.value			= LvarTotalCostoProd + LvarTotalCostoNoProd;
			fm(document.form1.TotalCostoProd_Ori,2)
			fm(document.form1.TotalCostoNoProd_Ori,2)
			fm(document.form1.TotalCosto_Ori,2)
			fnDestinos();
		}
	
		function fnDestinos()
		{
			var LvarAids 		= "<cfoutput>#LvarAidDst#</cfoutput>".split(",");
			var LvarCantTotal 	= 0;
			var LvarCostoTotal	= toNumber(document.form1.TotalCosto_Ori.value);
			document.form1.TotalCosto_Dst.value	= document.form1.TotalCosto_Ori.value;
	
			var LvarCostoU 		= 0;
			for (var i=0; i<LvarAids.length; i++)
			{
				LvarCantTotal += toNumber(document.getElementById("CantidadDst_" + LvarAids[i]).value);
			}
	
			document.form1.TotalCantidad_Dst.value = LvarCantTotal;
			fm(document.form1.TotalCantidad_Dst,2)
	
			if (LvarCantTotal != 0)
				LvarCostoU = LvarCostoTotal / LvarCantTotal;
	
			for (var i=0; i<LvarAids.length; i++)
			{
				x = toNumber(document.getElementById("CantidadDst_" + LvarAids[i]).value) * LvarCostoU;
				document.getElementById("Costo_" + LvarAids[i]).value = Math.round(x*100)/100;
				fm(document.getElementById("Costo_" + LvarAids[i]),2)
			}
			document.form1.CostoUnit_Dst.value = LvarCostoU;
			fm(document.form1.CostoUnit_Dst,2)
	
			return true;
		}
	</script>
</cfif>
<script language="JavaScript" type="text/javascript">
	<!--//
	<cfif  modo EQ 'ALTA'>
		objForm.OCTid.description = "Transportes";
	</cfif>
	objForm.OCTTdocumento.description = "Documento";
	objForm.OCTTfecha.description = "Fecha";
	
	function verEncabezado(idx) {
		var tr = document.getElementById("TR_"+idx);
		var img = document.getElementById("img_"+idx);
		img.src = ((tr.style.display == "none") ? "../../imagenes/abajo.gif" : "../../imagenes/derecha.gif");
		tr.style.display = ((tr.style.display == "none") ? "" : "none");
	}	
	
	function habilitarValidacion() {
			<cfif  modo EQ 'ALTA'>
				objForm.OCTid.required = true;
			</cfif>
		objForm.OCTTdocumento.required = true;
		objForm.OCTTfecha.required = true;
	}

	function deshabilitarValidacion() {
		_allowSubmitOnError = true;
		<cfif  modo EQ 'ALTA'>
			objForm.OCTid.required = false;
		</cfif>
		objForm.OCTTdocumento.required = false;
		objForm.OCTTfecha.required = false;
	}			

	function funcAplicar()
	{
		if (!fnVerificado())
			return false;
		
		if (!confirm("¿Está seguro de que desea aplicar este documento?"))
			return false;

		return true;
	}

	function funcVerAplicacion()
	{
		return fnVerificado();
	}

	var GvarCambiado = false;
	function fnVerificado(){
		var LvarCostoTotal	= toNumber(document.form1.TotalCosto_Ori.value);
		var LvarCantidad	= toNumber(document.form1.TotalCantidad_Dst);

		if(GvarCambiado)
		{
			alert("Se modifico la información primero debe presionar <Modificar>");
			return false;
		}
		if(LvarCostoTotal == 0)
		{
			alert ("Debe escoger algún producto Origen");
			return false;
		}
		if(LvarCantidad == 0)
		{
			alert ("Debe escoger algún producto Destino");
			return false;
		}
		return true;
	}
	
	//-->
	</script>




