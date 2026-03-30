<!--- Definición del modo --->
<cfif isdefined('url.OCTid') and len(trim(url.OCTid)) and not isdefined('form.OCTid')>
	<cfset form.OCTid = url.OCTid>
</cfif>
<cfif isdefined('url.Aid') and len(trim(url.Aid)) and not isdefined('form.Aid')>
	<cfset form.Aid = url.Aid>
</cfif>
<cfset modo="ALTA">
<cfset modoDet = 'ALTA'>
<cfif isdefined("form.OCIid") and len(trim(form.OCIid))>
	<cfset modo="CAMBIO">
</cfif>
<cfif isdefined('form.OCIid') and form.OCIid GT 0
	and isdefined('form.OCTid') and form.OCTid GT 0 and isdefined('form.Aid') and form.Aid GT 0>
	<cfset modoDet = 'CAMBIO'>	
<cfelse>
	<cfset form.OCTid = -1>
	<cfset form.Aid = -1>
</cfif>

<cfset navegacion ="">
<cfif NOT isdefined("form.OCItipoOD") OR len(trim(form.OCItipoOD)) EQ 0	>
	<cfset form.OCItipoOD = LvarOCItipoOD>
</cfif>

<cfquery name="rsSQL" datasource="#session.DSN#">
	select Miso4217
	  from Monedas
	 where Mcodigo = (select <cf_dbfunction name="to_number" args="Pvalor"> from Parametros where Ecodigo=#session.Ecodigo# and Pcodigo = 441)
</cfquery>

<cfset LvarMiso4217 = rsSQL.Miso4217>

<cfif LvarOCItipoOD EQ "O">
	<cfset LvarEtiquetaExistencias = "Existencias<BR>Almacén">
	<cfset LvarEtiquetaCantidad = "Cantidad<BR>Transportada">
	<cfset LvarTituloCantidad = "Cantidad&nbsp;Transportada">
<cfelse>
	<cfset LvarEtiquetaExistencias = "Existencias<BR>Tránsito">
	<cfset LvarEtiquetaCantidad = "Cantidad<BR>Recibida">
	<cfset LvarTituloCantidad = "Cantidad&nbsp;Recibida">
</cfif>

<cfif modo eq 'ALTA'>
	<cfset mododet = "ALTA">
<cfelse>
	<cfquery name="rsData" datasource="#session.DSN#">
		select 
			OCItipoOD, 
			OCInumero, 
			OCIfecha, 
			Alm_Aid,
			OCIobservaciones,
			i.OCid, oc.OCcontrato
		from OCinventario i
			left join OCordenComercial oc
				on oc.OCid = i.OCid
		where OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
	</cfquery>

	<cfif LvarOCItipoOD EQ "O">
		<cfquery datasource="#session.DSN#">
			insert into OCinventarioProducto
				(
					OCIid, OCTid, Aid, OCIcantidad, OCIcostoValuacion
				)
			select #form.OCIid#, tp.OCTid, tp.Aid, 0, 0
			  from OCordenProducto op
				inner join OCtransporteProducto tp
					 on tp.OCid = op.OCid
					and tp.Aid  = op.Aid
			 where op.OCid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsdata.OCid#">
			   and (
			   		select count(1) 
			   		  from OCinventarioProducto
					 where OCIid = #form.OCIid#
					   and OCTid = tp.OCTid
					   and Aid   = op.Aid
					) = 0
		</cfquery>	
	</cfif>

	<cfquery name="rsListaDet" datasource="#session.DSN#">
		select 
			ip.OCIid, 
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
			t.OCTtransporte as Transporte,
			ip.Aid, 
			OCIcantidad, 
		<cfif LvarOCItipoOD EQ "O">
			case 
				when Eexistencia = 0 then coalesce(Ecostou,0)
				else Ecostototal / Eexistencia
			end as OCIcostoU,

			case 
				when Eexistencia = 0 then coalesce(Ecostou,0)
				else OCIcantidad * Ecostototal / Eexistencia
			end as OCIcostoT,
			Eexistencia as OCIexistencias,
		<cfelse>
			case 
				when i.OCPTentradasCantidad = 0 then 0
				else i.OCPTentradasCostoTotal/i.OCPTentradasCantidad
			end as OCIcostoU,
			case 
				when i.OCPTentradasCantidad = 0 then 0
				else OCIcantidad*i.OCPTentradasCostoTotal/i.OCPTentradasCantidad 
			end as OCIcostoT,
			i.OCPTentradasCantidad+i.OCPTsalidasCantidad as OCIexistencias,
		</cfif>
			a.Acodigo , a.Adescripcion,
			a.Ucodigo
		from OCinventarioProducto ip
			inner join Articulos a
				 on a.Aid = ip.Aid
			inner join OCtransporte t
				on t.OCTid = ip.OCTid
		<cfif LvarOCItipoOD EQ "O">
			inner join OCinventario ie
				 on ie.OCIid = ip.OCIid
			left join Existencias i
				 on i.Aid		= ip.Aid
				and i.Alm_Aid	= ie.Alm_Aid
		<cfelse>
			inner join OCproductoTransito i
				 on i.OCTid = ip.OCTid
				and i.Aid = ip.Aid
		</cfif>
		where ip.OCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
	</cfquery>

	<cfquery name="rsDataDet" dbtype="query">
		select *
		  from rsListaDet
		 where OCIid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCIid#">
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
	<form 	name="form1" action="OC_INV_sql.cfm" method="post">
		<input name="OCIid" type="hidden" value="<cfif isdefined('form.OCIid') and len(trim(form.OCIid))>#form.OCIid#</cfif>">
		<input name="OCInumero" type="hidden" value="<cfif modo NEQ 'ALTA'>#rsData.OCInumero#</cfif>" tabindex="0">
		<fieldset>
			<table cellpadding="0" cellspacing="3" border="0" align="center" width="10%">
				<tr>
					<td align="right"><strong>Tipo:&nbsp;</strong></td>
					<td align="left">
					<cfif LvarOCItipoOD EQ "O">
						<strong>Movimiento Origen Salida de Inventario</strong>
					<cfelse>
						<strong>Movimiento Destino Entrada a Inventario</strong>
					</cfif>
						<input name="OCItipoOD" value="#LvarOCItipoOD#" type="hidden">
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Documento:</strong>&nbsp;</td>
					<td align="left">
						<cfif modo NEQ 'ALTA'>
							#rsData.OCInumero#
						<cfelse>
							<strong>DOCUMENTO NUEVO</strong>
						</cfif>
					</td>
				</tr>
			<cfif LvarOCItipoOD EQ "O">
				<tr>
					<td align="right" nowrap><strong>Orden Comercial OI:</strong>&nbsp;</td>
					<td align="left">
						<cfif modo NEQ 'ALTA'>
							#rsData.OCcontrato#
						<cfelse>
							<cf_conlis
								Campos="OCid,OCcontrato"
								Desplegables="N,S"
								Modificables="N,S"
								Size="0,20"
								tabindex="1"
								Title="Órdenes Comerciales de Origen Inventarios"
								Tabla="OCordenComercial"
								Columnas="OCid,OCcontrato,OCfecha"
								Filtro=" Ecodigo = #Session.Ecodigo# and OCestado = 'A' and OCtipoOD='O' and OCtipoIC='I' order by OCfecha"
								Desplegar="OCcontrato,OCfecha"
								Etiquetas="Contrato,Fecha"
								filtrar_por="OCcontrato,Fecha"
								Formatos="S,D" 
								Align="left,left" 
								form="form1"
								Asignar="OCid,OCcontrato"
								Asignarformatos="S,S"
							/>
						</cfif>
					</td>
				</tr>
			</cfif>
				<tr>
					<td align="right"><strong>Fecha:&nbsp;</strong></td>
					<td align="left">
						<cfif modo neq 'ALTA'>
							<cf_sifCalendario value="#dateformat(rsData.OCIfecha,'dd/mm/yyyy')#" name="OCIfecha" form="form1" tabindex="1">
						<cfelse>
							<cf_sifCalendario value="#dateformat(now(),'dd/mm/yyyy')#" name="OCIfecha" form="form1" tabindex="1">
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right"><strong>Almac&eacute;n:&nbsp;</strong></td>
					<td align="left">
						<cfif modo EQ 'CAMBIO'>
							<cf_sifalmacen Aid ="Alm_Aid" tabindex="1" id='#rsData.Alm_Aid#' form = 'form1'>
						<cfelse>
							<cf_sifalmacen Aid ="Alm_Aid" tabindex="1" frame="fralmacen" form = 'form1'>
						</cfif>
					</td>
				</tr>
				<tr>
					<td align="right" valign="top"><strong>Observaciones:&nbsp;</strong></td>
					<td align="left"><textarea tabindex="1" name="OCIobservaciones" id="OCIobservaciones" rows="5" tabindex="2"  cols="60" ><cfif modo NEQ 'ALTA'><cfoutput>#rsData.OCIobservaciones#</cfoutput></cfif></textarea></td>
				</tr>
			</table>
			<cfif modo EQ "ALTA">
				<cf_botones modo='#modo#' regresar='OC_INV_#LvarOCItipoOD#I.cfm'>
			<cfelse>
				<cf_botones modo='#modo#' regresar='OC_INV_#LvarOCItipoOD#I.cfm' include="btnAplicar, btnVer_Aplicacion" includevalues="Aplicar, Ver_Aplicacion">
			</cfif>

			<cfif modo NEQ 'ALTA'>
				<!--- Detalle --->
				<HR size="1" color="##CCCCCC"><br>

				<table cellpadding="0" cellspacing="3" align="center" border="0" style="width:58%"
					<cfif mododet EQ "ALTA" and LvarOCItipoOD EQ "O">
						onkeydown="alert('Escoja una línea de detalle'); return false;" onclick="alert('Escoja una línea de detalle'); return false;"
					</cfif>
				>
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
									<table>
									<tr>
								<td id="TransporteImput" align="left" style="width:1%" nowrap="nowrap">
									<select id="OCTtipo" name="OCTtipo" tabindex="2">
										<option value="B" <cfif rsDataDet.OCTtipo EQ "B">selected</cfif>>Barco</option>
										<option value="A" <cfif rsDataDet.OCTtipo EQ "A">selected</cfif>>Avion</option>
										<option value="T" <cfif rsDataDet.OCTtipo EQ "T">selected</cfif>>Terrestre</option>
										<option value="F" <cfif rsDataDet.OCTtipo EQ "F">selected</cfif>>Ferrocarril</option>
										<option value="O" <cfif rsDataDet.OCTtipo EQ "F">selected</cfif>>Otro Tipo</option>
									</select>
								</td>
										<td>
										<cf_conlis
											Campos="OCTid,OCTtransporte"
											Desplegables="N,S"
											Modificables="N,S"
											Size="0,12"
											tabindex="2"
										
											Title="Lista de Transportes"
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
										<cfif LvarOCItipoOD EQ "D" AND rsListaDet.recordCount EQ 0>
											<td nowrap="nowrap">
												&nbsp;&nbsp;&nbsp;
												Agregar&nbsp;productos
											</td>
											<td>
												<input type="submit" value="Sin Salidas" name="AgregarSinSalidas" onclick="return fnAgregarTransporte('S');">
												<input type="submit" value="Existentes"  name="AgregarExistentes" onclick="return fnAgregarTransporte('E');">
											</td>
										</cfif>
									</tr>
									</table>
								</td>
							</cfif>
						</td>
					</tr>
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
								<cfif rsData.OCItipoOD EQ "O">
									<cfset LvarFiltroArts = "and b.OCPTtransformado = 0 and t.OCtipoOD='O'">
								<cfelse>
									<!--- No se filtra por b.OCtipoOD='D' porque la OC se puede generar para el documento --->
									<cfset LvarFiltroArts = "and (b.OCPTentradasCantidad + b.OCPTsalidasCantidad) >0">
								</cfif>
								<cfif LvarOCItipoOD EQ "O">
									<cfset LvarCostoExistencia = 
												"
													case 
														when i.Eexistencia = 0 then coalesce(Ecostou,0)
														else i.Ecostototal / i.Eexistencia
													 end as OCIcostoU,
													 i.Eexistencia as OCIexistencias
												">
								<cfelse>
									<cfset LvarCostoExistencia = 
												"
													case 
														when b.OCPTentradasCantidad = 0 then 0 
														else b.OCPTentradasCostoTotal/b.OCPTentradasCantidad 
													end as OCIcostoU, 
													b.OCPTentradasCantidad+b.OCPTsalidasCantidad as OCIexistencias
												">
								</cfif>
								<cfset LvarJoin = ''>
								<cfif isdefined("rsData") and len(trim(rsData.OCid)) GT 0>
									<cfset LvarJoin = ' inner join OCtransporteProducto t
															 on t.OCTid	= b.OCTid
															and t.Aid	= b.Aid
															and t.OCid	= #rsData.OCid# '>
								</cfif>
								

								<cf_conlis
									Campos			="Aid, Acodigo, Adescripcion"
									Desplegables	="N, S, S"
									Modificables	="N, S, N"
									Size			="0, 10, 50"
									tabindex		="2"
									Title			="Lista de Artículos del Transporte"
									Tabla			="OCproductoTransito b
														inner join Articulos a
															 on a.Aid = b.Aid
														#LvarJoin#
														left join Existencias i
															 on i.Aid		= b.Aid
															and i.Alm_Aid	= #rsData.Alm_Aid#
													"
									Columnas		="a.Aid, a.Acodigo, a.Adescripcion, a.Ucodigo,  a.Ucodigo as Ucodigo2, 
														#LvarCostoExistencia#
													 "
									Filtro			="b.Ecodigo = #session.Ecodigo#
														and b.OCTid = $OCTid,numeric$
														#LvarFiltroArts#
														"
									Desplegar		="Acodigo, Adescripcion, OCIexistencias, Ucodigo, OCIcostoU"
									Etiquetas		="Código,Descripción, #LvarEtiquetaExistencias#, Unidad, Costo<BR>Unitario"
									filtrar_por		="Acodigo, Adescripcion, OCIexistencias, Ucodigo, OCIcostoU"
									Formatos		="S,S,M,S,M"
									Align			="left,left,right,left,right"
									form			="form1"
									Asignar			="Aid, Acodigo, Adescripcion, Ucodigo, Ucodigo2, OCIcostoU, OCIexistencias"
									Asignarformatos	="S, S, S, S, S, S, S"
											/>	
							</cfif>			
						</td>
					</tr>
					<tr>
						<td align="right">
						<cfif LvarOCItipoOD EQ "O">
							<strong>Existencias&nbsp;Almacén:&nbsp;</strong>
						<cfelse>
							<strong>Existencias&nbsp;Tránsito:&nbsp;</strong>
						</cfif>
						</td>
						<td>
							<input 	type="text"  align="right" name="OCIexistencias"
									value="#numberformat(rsDataDet.OCIexistencias,",9.0000")#"
									tabindex="-1" readonly style="border:solid 1px ##CCCCCC; background:inherit; text-align:right"
									size="24" />
						</td>
						<td>
							<input 	type="text" name="Ucodigo" value="<cfif isdefined('rsDataDet') and len(rsDataDet.Ucodigo)>#rsDataDet.Ucodigo#</cfif>" 
									tabindex="-1" readonly style="border:none; background:inherit;"
									size="6">
						</td>
						<td align="right"><strong>Costo&nbsp;Unitario:&nbsp;</strong></td>
						<td nowrap>
							<input 	type="text"  align="right" name="OCIcostoU"
									value="#rsDataDet.OCIcostoU#"
									tabindex="-1" readonly style="border:solid 1px ##CCCCCC; background:inherit; text-align:right"
									size="22" />
							#LvarMiso4217#
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td nowrap align="right" style="width:10%"><strong>#LvarTituloCantidad#:&nbsp;</strong></td>
						<td style="width:1%" align="left" nowrap="nowrap">
								<cf_inputnumber name="OCIcantidad" form="form1" enteros="15" decimales="4" tabindex="2" value="#rsDataDet.OCIcantidad#" onblur="fnCostoTotal();">
								&nbsp;<strong></strong>&nbsp;
								
						</td>
						<td>
							<input 	type="text" name="Ucodigo2" value="<cfif isdefined('rsDataDet') and len(rsDataDet.Ucodigo)>#rsDataDet.Ucodigo#</cfif>" 
									tabindex="-1" readonly style="border:none; background:inherit;"
									size="6">
						</td>
						<td align="right"><strong>&nbsp;Costo&nbsp;Línea:&nbsp;</strong></td>
						<td nowrap>
							<cf_inputnumber name="OCIcostoT" form="form1" enteros="15" decimales="2" tabindex="2" value="#rsDataDet.OCIcostoT#" readonly>
							#LvarMiso4217#
						</td>
					</tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				<cfif LvarOCItipoOD EQ "O">
					<cfif mododet NEQ "ALTA">
						<cf_botones modo='CAMBIO' mododet="CAMBIO" names="cambioDet" values="Modificar">
					</cfif>
				<cfelse>
					<cfif mododet EQ "ALTA">
						<cf_botones modo='CAMBIO' mododet="ALTA" names="altaDet,limpiarDet" values="Agregar,Limpiar">
					<cfelse>
						<cf_botones modo='CAMBIO' mododet="CAMBIO" names="cambioDet,bajaDet,NuevoDet" values="Modificar,Eliminar,Nueva">
					</cfif>
				</cfif>
			</cfif>	
		<cf_qforms form="form1">
			<cfif LvarOCItipoOD EQ "O" AND modo EQ 'ALTA'>
				<cf_qformsrequiredfield args="OCid,Orden Comercial OI">
			</cfif>
			<cf_qformsrequiredfield args="OCIfecha,Fecha">
			<cf_qformsrequiredfield args="Alm_Aid,Almacén">
		</cf_qforms>
	</form>
	<cfif modo NEQ 'ALTA'>
		<cf_qforms form="form2">
			<cf_qformsrequiredfield args="OCTid,Transporte">
			<cf_qformsrequiredfield args="Aid,Artículo">
			<cf_qformsrequiredfield args="OCIcantidad,#LvarTituloCantidad#">
		</cf_qforms>

		<cfinvoke component="sif.Componentes.pListas"
					method				="pListaQuery"
					returnvariable		="pListaRet"

					Query				= "#rsListaDet#"
					Desplegar			= "Tipo,Transporte,Acodigo,Adescripcion,OCIexistencias,OCIcantidad,OCIcostoT"
					Etiquetas			= "Tipo,Transporte,Articulo,Descripcion,#LvarEtiquetaExistencias#,#LvarEtiquetaCantidad#,Costo"
					Formatos			= "S,S,S,S,M,M,M"
					Align				= "left,left,left,left,right,right,right"
					Ajustar 			= "S"
					IrA					= "OC_INV_#LvarOCItipoOD#I.cfm"
					lineaRoja			= "OCIcantidad GT OCIexistencias"
					Navegacion 			= "#navegacion#"
					IncluyeForm			= "yes"
					FormName			= "form2"
					Keys				= "OCIid, OCTid, Aid"
					showEmptyListMsg	= "true"
		>

		<script language="javascript">
			function fnCostoTotal()
			{
				var LvarCantidad = new Number(qf(document.form1.OCIcantidad.value));
				var LvarCosto = new Number(qf(document.form1.OCIcostoU.value));
				var LvarMax = new Number(qf(document.form1.OCIexistencias.value));
				if (LvarCantidad >LvarMax)
				{
					alert("Cantidad máxima: " + LvarMax);
					document.form1.OCIcantidad.value = fm(LvarMax,4);
					document.form1.OCIcostoT.value = fm(LvarMax*LvarCosto,2);
				}
				else
				{
					document.form1.OCIcostoT.value = fm(LvarCantidad*LvarCosto,2);
				}
			}
			function fnAgregarTransporte(lTipo)
			{
				if (document.form1.OCTid.value == "")
				{
					alert ("El Campo Transporte es requerido para la inclusión masiva de sus productos");
					return false;
				}
				else if (lTipo == "S")
				{
					if (!confirm ("¿Desea incluir todos los productos que no han tenido Salidas en el Transporte?"))
						return false;
				}
				else if (!confirm ("¿Desea incluir todos los productos que todavía tienen Existencias en el Transporte?"))
					return false;

				objForm.Aid.required=false;
				objForm.OCIcantidad.required=false;
			}
		</script>
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
