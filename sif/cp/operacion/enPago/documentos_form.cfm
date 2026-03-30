<cfif isdefined("form.CPCid") and form.CPCid NEQ "">
	<cfset MODO = "CAMBIO">
<cfelse>
	<cfset MODO = "ALTA">
</cfif>
<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">
<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#session.dsn#" name="rsForm">
		select
				c.CPCid,
				c.CPCtipo,
				case c.CPCtipo
					when 'M' then 'MULTA'
					when 'E' then 'EMBARGO'
					when 'C' then 'CESIÓN'
				end as Tipo,
				c.CPCdocumento,
				c.CPCdescripcion,
				c.CPCfecha,
				sno.SNcodigo as SNcodigoOri, sno.SNnombre as SNorigen,
				c.CPCnivel,
				case c.CPCnivel
					when 'S' then ''
					when 'O' then 'OC:'		#_Cat# (select <cf_dbfunction name="to_char" args="EOnumero" datasource="#session.dsn#"> from EOrdenCM where EOidorden = c.EOidorden)
					when 'D' then 'CxP:'	#_Cat# (select CPTcodigo #_Cat# '-' #_Cat# Ddocumento from HEDocumentosCP where IDdocumento = c.IDdocumento)
				end as DOC,
				c.EOidorden, c.IDdocumento,
			
				snd.SNcodigo as SNcodigoDst, snd.SNnombre as SNdestino,
			
				c.Mcodigo,m.Miso4217 as Miso4217Doc,
				c.CPCmonto,
				c.TESDPaprobadoPendiente,
				c.CPCmonto - c.CPCpagado - c.TESDPaprobadoPendiente as SaldoNeto,
	
				case c.CPCestado
					when 0 then 	'En Preparacion'
					when 1 then 	'En Aprobacion'
					when 2 then 	'Pendiente'
					when 3 then 	'Aprobado'
					when 4 then 	'Rechazado'
					when 5 then 	'Anulado'
					when 10 then 	'Pagado'
				end as estado,
				CPCdetalle,
			<cfif LvarTipoDoc EQ "APROBAR" OR LvarTipoDoc EQ "ANULAR">
				(select Usulogin from Usuario where Usucodigo = c.UsucodigoSolicita) as Solicita,
				CPCfechaSolicita,
			</cfif>
			<cfif LvarTipoDoc EQ "ANULAR">
				(select Usulogin from Usuario where Usucodigo = c.UsucodigoAprueba) as Aprobado,
				CPCfechaAprueba,
				CPCpagado,
			</cfif>
				c.ts_rversion
		from	CPCesion c
			inner join SNegocios sno
				on sno.SNid = c.SNidOrigen
			left join SNegocios snd
				on snd.SNid = c.SNidDestino
			inner join Monedas m
				 on m.Ecodigo = c.Ecodigo
				and m.Mcodigo = c.Mcodigo
		where c.Ecodigo	= #session.Ecodigo#
		  and c.CPCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCid#">
	</cfquery>
	<cfset LvarDocumento = rsForm.Tipo>
	<cfset LvarCPCtipo = rsForm.CPCtipo>
<cfelse>
	<cfset LvarDocumento = LvarTipoDoc>
	<cfset LvarCPCtipo = mid(LvarTipoDoc,1,1)>
</cfif>
<cfif LvarCPCtipo EQ "C">
	<cfset LvarDocumentos = "Cesiones">
<cfelseif LvarCPCtipo EQ "E">
	<cfset LvarDocumentos = "Embargos">
<cfelseif LvarCPCtipo EQ "M">
	<cfset LvarDocumentos = "Multas">
</cfif>
<cfquery datasource="#session.dsn#" name="rsMonedas">
	select Mcodigo, Miso4217
	  from Monedas
	 where Ecodigo  = #session.Ecodigo#
</cfquery>

<cfoutput>
<cfif LvarTipoDoc EQ "APROBAR" OR LvarTipoDoc EQ "ANULAR">
	<cfset LvarReadOnly = true>
	<cfset LvarReadOnlyBorder = 'readonly style="border:solid ##CCCCCC 1px"'>
<cfelse>
	<cfset LvarReadOnly = false>
	<cfset LvarReadOnlyBorder = "">
</cfif>
<form name="form1" action="documentos_sql.cfm" method="post" onSubmit="return validar(this);">
	<input type="hidden" name="CPCtipo" id="CPCtipo" value="#LvarCPCtipo#">
	<input type="hidden" name="root" id="root" value="#LvarRoot#">
	<cfif modo EQ "CAMBIO">
		<input type="hidden" name="CPCid" id="CPCid" value="#rsForm.CPCid#">
	<cfelse>
		<input type="hidden" name="CPCid" id="CPCid" value="-1">
	</cfif>
	<table border="0" align="center">
		<tr>
			<td>
				<strong>#LvarDocumento#:</strong>&nbsp;
			</td>
			<td colspan="1">
				<input type="text" name="CPCdocumento" id="CPCdocumento" size="20" tabindex = "1"
					<cfif modo EQ "CAMBIO">
						value="#rsForm.CPCdocumento#"
						readonly="true"
						style="border:none"
					</cfif>
				>
			</td>
		</tr>
		<tr>
			<td>
					<strong>Fecha:</strong>
			</td>
			<td>
					<cfparam name="rsform.CPCfecha" default="">
					<cf_sifcalendario name="CPCfecha" tabindex = "1" value="#dateFormat(rsform.CPCfecha,"DD/MM/YYYY")#" Readonly="#LvarReadOnly#">
			</td>
		</tr>
		<tr>
			<td>
				<strong>Proveedor:</strong>&nbsp;
			</td>
			<td colspan="3">
			<cfif modo NEQ "ALTA">
				<input name="SNnombre" type="text" readonly class="cajasinborde" tabindex="-1" 
					value="#rsForm.SNorigen#" size="40" maxlength="255" />
				<input type="hidden" name="SNcodigoOri" value="#rsForm.SNcodigoOri#" />
			<cfelse>
				<cf_sifsociosnegocios2 
					SNcodigo="SNcodigoOri" SNnombre="SNorigen" SNnumero="SNnumeroOri" 
					tabindex = "1" SNtiposocio="P" size="55" frame="frame1">
			</cfif>
			</td>
		</tr>

		<tr>
			<td>
				<strong>Descripcion:</strong>&nbsp;
			</td>
			<td colspan="3">
				<input type="text" name="CPCdescripcion" id="CPCdescripcion" size="55" maxlength="50" tabindex = "1"
					<cfif modo EQ "CAMBIO">
						value="#rsForm.CPCdescripcion#"
						#LvarReadOnlyBorder#
					</cfif>
				>
			</td>
		</tr>

		<tr>
			<td>
				<strong>Aplicar&nbsp;a:</strong>&nbsp;
			</td>
			<td colspan="1" nowrap>
				<select name="CPCnivel" id="CPCnivel"
					onchange="sbCPCnivelChange(this);"
					tabindex = "1"
				>
				<cfif LvarReadOnly>
					<cfif rsForm.CPCnivel EQ "S">
						<option value="S">Proveedor</option>
					<cfelseif rsForm.CPCnivel EQ "O">
						<option value="O">Orden Compra</option>
					<cfelseif rsForm.CPCnivel EQ "D">
						<option value="D">Documento CxP</option>
					</cfif>
				<cfelseif LvarCPCtipo EQ "E">
					<option value="S" <cfif modo EQ "CAMBIO" AND rsForm.CPCnivel EQ "S">selected</cfif>>Proveedor</option>
				<cfelse>
					<option value="O" <cfif modo EQ "CAMBIO" AND rsForm.CPCnivel EQ "O">selected</cfif>>Orden Compra	</option>
					<option value="D" <cfif modo EQ "CAMBIO" AND rsForm.CPCnivel EQ "D">selected</cfif>>Documento CxP</option>
				</cfif>
				</select>
			</td>
			<td id="TR_SN" style="width:185px;">
				<div style="width:185px;">
					&nbsp;
				</div>
			</td>
			<td id="TR_OC" style="display:none;width:185px">
				<cfif modo EQ "CAMBIO" and rsForm.CPCnivel EQ "O">
					<cfset LvarTraerFiltro = "a.EOidorden = #rsForm.EOidorden#">
				<cfelse>
					<cfset LvarTraerFiltro = "">
				</cfif>
				<div style="width:185px;">
				<cf_conlis 
						title="Lista de Ordenes de Compra"
					campos = "EOnumero, EOidorden" 
					desplegables = "S,N" 
					modificables = "S,N"
					size = "20"
					tabla="
							EOrdenCM a 
							inner join Monedas b 
								on a.Mcodigo = b.Mcodigo 
							inner join CMTipoOrden f 
								on a.Ecodigo =f.Ecodigo 
							   and a.CMTOcodigo = f.CMTOcodigo 
							"
					columnas="
							a.EOidorden, a.EOnumero, a.EOfecha, a.Mcodigo, b.Miso4217, a.EOtotal, f.CMTOdescripcion as tipo
								,(
								 select sum((g.DOcantidad - g.DOcantsurtida) * g.DOpreciou)	
								   from DOrdenCM g 
								  where g.EOidorden = a.EOidorden 
								) as EOsaldo
								,(
								 select sum(CPCmonto)	
								   from CPCesion
								  where EOidorden = a.EOidorden 
								    and CPCestado in (1,2,3)
									and CPCid != $CPCid,numeric$
								) as montoOtras
							  "
					filtro="
								a.Ecodigo = #session.Ecodigo#
							and a.SNcodigo = $SNcodigoOri,integer$
							and a.EOestado= 10 
							and ( 
								 select count(1) 
								   from DOrdenCM g 
								  where g.EOidorden = a.EOidorden 
									and g.DOcantidad - g.DOcantsurtida > 0 
								) > 0
							"
					desplegar="tipo, EOnumero, EOfecha, Miso4217, EOtotal, EOsaldo, montoOtras"
					filtrar_por="f.CMTOdescripcion, a.EOnumero, a.EOfecha, b.Miso4217, , , "
					etiquetas="Tipo,OC,Fecha,Moneda,Monto,Saldo,Otros"
					formatos="S,I,D,S,M,M,M"
					align="left,left,left,right,right,right,right"
					asignar="EOnumero, EOidorden, McodigoDoc=Mcodigo, Miso4217Doc=Miso4217, SaldoDoc=EOsaldo, montoOtras"
					asignarformatos="S,S,S,S,M,M"
					tabindex = "1"
					traerInicial="#LvarTraerFiltro NEQ ""#"
					traerFiltro="#LvarTraerFiltro#"
					readOnly="#LvarReadOnly#"
				>
				</div>
			</td>
			<td id="TR_CP" style="display:none;width:185px">
				<cfif modo EQ "CAMBIO" and rsForm.CPCnivel EQ "D">
					<cfset LvarTraerFiltro = "a.IDdocumento = #rsForm.IDdocumento#">
				<cfelse>
					<cfset LvarTraerFiltro = "">
				</cfif>
				<div style="width:185px;">
				<cf_conlis 
						title="Lista de Documentos CxP"
					campos = "CPTcodigo, Ddocumento, IDdocumento" 
					desplegables = "S,S,N" 
					modificables = "N,N,N"
					size = "2,20"
					tabla="EDocumentosCP a
							inner join CPTransacciones b
							   on b.Ecodigo = a.Ecodigo
							  and b.CPTcodigo = a.CPTcodigo
							  and b.CPTtipo = 'C' 
							inner join Monedas c
							   on c.Ecodigo = a.Ecodigo
							  and c.Mcodigo = a.Mcodigo
							"
					columnas="a.CPTcodigo, a.Ddocumento, a.IDdocumento, a.Mcodigo, c.Miso4217, a.EDsaldo, a.Dfecha, a.Dtotal
								,(
								 select sum(CPCmonto)	
								   from CPCesion
								  where IDdocumento = a.IDdocumento
								    and CPCestado in (1,2,3)
									and CPCid != $CPCid,numeric$
								) as montoOtras
							  "
					filtro="a.Ecodigo = #Session.Ecodigo# and a.SNcodigo = $SNcodigoOri,integer$ and a.EDsaldo > 0"

					desplegar="CPTcodigo, Ddocumento, Dfecha, Miso4217, Dtotal, EDsaldo, montoOtras"
					filtrar_por="a.CPTcodigo, a.Ddocumento, a.Dfecha, c.Miso4217, , , "
					etiquetas="Transacci&oacute;n,Documento,Fecha,Moneda,Monto,Saldo, Otros"
					formatos="S,S,D,S,M,M,M"
					align="left,left,left,right,right,right,right"
					asignar="CPTcodigo, Ddocumento, IDdocumento, McodigoDoc=Mcodigo, Miso4217Doc=Miso4217, SaldoDoc=EDsaldo, montoOtras"
					asignarformatos="S,S,S,S,S,M,M,M"
					tabindex = "1"

					traerInicial="#LvarTraerFiltro NEQ ""#"
					traerFiltro="#LvarTraerFiltro#"
					readOnly="#LvarReadOnly#"
				>
				</div>
			</td>
			<td nowrap id="TR_N_SN">
				<strong id="TR_N_SN_Saldo">Saldo <cfif modo EQ "CAMBIO" AND rsForm.CPCnivel EQ "O">O.C.<cfelse>Doc</cfif>:</strong>&nbsp;
				<input type="text" name="SaldoDoc" id="SaldoDoc"  size="30" disabled style="border:none" />
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap">
				<strong>Por un Monto de:</strong>&nbsp;
			</td>
			<td colspan="2" nowrap>
				<select name="Mcodigo" id="Mcodigo">
				<cfloop query="rsMonedas">
					<cfif NOT LvarReadOnly OR rsForm.Mcodigo EQ rsMonedas.Mcodigo>
					<option value="#Mcodigo#" <cfif modo EQ "CAMBIO" AND rsForm.Mcodigo EQ rsMonedas.Mcodigo>selected</cfif>>#Miso4217#</option>
					</cfif>
				</cfloop>
				</select>
				<input type="hidden" name="McodigoDoc"  id="McodigoDoc" value="#rsMonedas.Mcodigo#">
				<input type="text"   name="Miso4217Doc" id="Miso4217Doc" size="3" style="border:solid 1px ##AAAAAA;display:none" disabled/>
				<cfparam name="rsForm.CPCmonto" default="">
				<cf_inputNumber	name="CPCmonto" 
							value="#rsForm.CPCmonto#"
							enteros="15" decimales="2"
							tabindex = "1"	
							readOnly="#LvarReadOnly#"
				>
			</td>
			<td nowrap="nowrap" colspan="2">
				<strong title="Otras #LvarDocumentos# para la misma O.C.
o para el mismo Documento CxP">Otras #LvarDocumentos#:</strong>
				<input type="text" name="montoOtras" id="montoOtras" size="30" disabled style="border:none" />
			</td>
		</tr>
		<tr <cfif LvarCPCtipo EQ "M">style="visibility:hidden;"</cfif>>
			<td>
				<cfif LvarCPCtipo EQ "E">
					<strong>Autoridad&nbsp;Judicial:</strong>&nbsp;
				<cfelse>
					<strong>Cedido&nbsp;a:</strong>&nbsp;
				</cfif>
			</td>
			<td colspan="4">
			<cfif modo NEQ "ALTA">
				<input name="SNdestino" type="text" readonly class="cajasinborde" tabindex="-1" 
					value="#rsForm.SNdestino#" size="40" maxlength="255" />
				<input type="hidden" name="SNcodigoDst" value="#rsForm.SNcodigoDst#" />
			<cfelse>
				<cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
					<cf_sifsociosnegocios2 
						SNcodigo="SNcodigoDst" SNnombre="SNdestino" SNnumero="SNnumeroDst" 
						tabindex = "1" SNtiposocio="P"  size="55" idquery="#rsForm.SNcodigoDst#">
				<cfelse>
					<cf_sifsociosnegocios2 
						SNcodigo="SNcodigoDst" SNnombre="SNdestino" SNnumero="SNnumeroDst" 
						tabindex = "1" SNtiposocio="P" size="55" frame="frame1">
				</cfif>
			</cfif>
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap">
				<strong>Detalle:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				<cfparam name="rsForm.CPCdetalle" default="">
				<textarea name="CPCdetalle" id="CPCdetalle" rows="5" cols="80">#rsForm.CPCdetalle#</textarea>
			</td>
		</tr>
<cfif LvarTipoDoc EQ "APROBAR">
		<tr>
			<td nowrap="nowrap">
				<strong>Solicitado por:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				#rsForm.Solicita#, #dateFormat(rsForm.CPCfechaSolicita,"DD/MM/YYYY")# #timeFormat(rsForm.CPCfechaSolicita,"HH:MM:SS")#
			</td>
		</tr>

		<tr>
			<td nowrap="nowrap">
				<strong>Motivo de Rechazo:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				<input type="text" name="CPCmotivoRechazo" id="CPCmotivoRechazo" size="70" tabindex = "1" />
			</td>
		</tr>
<cfelseif LvarTipoDoc EQ "ANULAR">
		<tr>
			<td nowrap="nowrap">
				<strong>Solicitado por:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				#rsForm.Solicita#, #dateFormat(rsForm.CPCfechaSolicita,"DD/MM/YYYY")# #timeFormat(rsForm.CPCfechaSolicita,"HH:MM:SS")#
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap">
				<strong>Aprobado por:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				#rsForm.Aprobado#, #dateFormat(rsForm.CPCfechaAprueba,"DD/MM/YYYY")# #timeFormat(rsForm.CPCfechaAprueba,"HH:MM:SS")#
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap">
				<strong>TOTAL PAGADO:</strong>&nbsp;
			</td>
			<td nowrap>
				<strong>#numberFormat(rsForm.CPCpagado,",9.99")#</strong>
			</td>
			<td nowrap="nowrap" colspan="1">
				<strong>Pago Pendiente:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>#numberFormat(rsForm.TESDPaprobadoPendiente,",9.99")#</strong>
			</td>
			<td nowrap="nowrap" colspan="2">
				<strong>Saldo:</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>#numberFormat(rsForm.saldoNeto,",9.99")#</strong>
			</td>
		</tr>

		<tr>
			<td nowrap="nowrap">&nbsp;
				
			</td>
		</tr>
			
		<tr>
			<td nowrap="nowrap">
				<strong>Motivo de Anulacion:</strong>&nbsp;
			</td>
			<td colspan="4" nowrap>
				<input type="text" name="CPCmotivoRechazo" id="CPCmotivoRechazo" size="70" tabindex = "1" />
			</td>
		</tr>
</cfif>
		<tr>
			<td colspan="4">
				<cfif modo NEQ 'ALTA'>
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
						artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
					</cfinvoke>
					<input type="hidden" name="ts_rversion" value="#ts#">
				</cfif>
				<cfif LvarTipoDoc EQ "APROBAR">
					<cf_botones modo="#Modo#" tabindex = "1" Exclude="Alta,Baja,Cambio,Nuevo" Include="Aprobar,Rechazar,regresar">
				<cfelseif LvarTipoDoc EQ "ANULAR">
					<cf_botones modo="#Modo#" tabindex = "1" Exclude="Alta,Baja,Cambio,Nuevo" Include="Anular,Lista">
				<cfelse>
                <cfif modo NEQ 'ALTA'>
                	<cfset Include = "A_Aprobar,Lista">
                <cfelse>
                	<cfset Include = "Lista">
                </cfif>
					<cf_botones modo="#Modo#" tabindex = "1" Include="#Include#">
				</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>

<cfif NOT (LvarTipoDoc EQ "APROBAR" OR LvarTipoDoc EQ "ANULAR")>
<cf_qforms>
	<cf_qformsRequiredField name="CPCdocumento"		description="Número de Documento">
	<cf_qformsRequiredField name="CPCfecha"			description="Fecha de Documento">
	<cf_qformsRequiredField name="SNcodigoOri"		description="Proveedor">
	<cf_qformsRequiredField name="CPCdescripcion"	description="Descripcion">
	<cf_qformsRequiredField name="McodigoDoc"		description="Moneda">
	<cf_qformsRequiredField name="CPCmonto"			description="Monto que afecta el pago">

	<cfif LvarCPCtipo NEQ "M">
		<cf_qformsRequiredField name="SNcodigoDst"		description="Socio de Negocio Cesionario">
	</cfif>
</cf_qforms>
</cfif>
<script language="javascript">
	function validar(f)
	{

<cfif NOT (LvarTipoDoc EQ "APROBAR" OR LvarTipoDoc EQ "ANULAR")>

		if (document.form1.botonSel.value == 'Lista')
			return true;
		var LvarNivel = document.getElementById("CPCnivel").value;

		if (LvarNivel == "O")
		{
			
			if ((document.getElementById("EOnumero").value == ""))
			{
					alert ("El Campo Orden de Compra es requerido");
					return false;
			}
		}
		else if (LvarNivel == "D")
		{
			if (document.getElementById("IDdocumento").value == "")
			{
				alert ("El Campo Documento de CxP es requerido");
				return false;
			}
		}

		if (LvarNivel != "S")
		{
			LvarMonto = new Number(qf(document.getElementById("CPCmonto").value));
			LvarSaldo = new Number(qf(document.getElementById("SaldoDoc").value));
			LvarOtros = new Number(qf(document.getElementById("montoOtras").value));

			if (LvarMonto+LvarOtros > LvarSaldo)
			{
				alert ("El Monto Total que afecta el Pago " + (LvarMonto+LvarOtros) + " no puede ser mayor al Saldo del Documento " + LvarSaldo);
				return false;
			}
		}
</cfif>		
		return true;
	}
//	}
	
	function funcLista()
	{
		deshabilitarValidacion();
		return true;
	}
	
	
	function sbCPCnivelChange(cbo)
	{
		document.getElementById('TR_N_SN').style.visibility = (cbo.value != 'S') ? 'visible':'hidden';
		document.getElementById('TR_N_SN_Saldo').innerHTML = (cbo.value == 'O') ? 'Saldo O.C.:':'Saldo Doc.:';

		document.getElementById('TR_SN').style.display = (cbo.value == 'S') ? '':'none';
		document.getElementById('TR_OC').style.display = (cbo.value == 'O') ? '':'none';
		document.getElementById('TR_CP').style.display = (cbo.value == 'D') ? '':'none';

		document.getElementById('Miso4217Doc').style.display = (cbo.value != 'S') ? '':'none';
		document.getElementById('Mcodigo').style.display = (cbo.value == 'S') ? '':'none';
	}
	sbCPCnivelChange(document.getElementById("CPCnivel"));
<cfif LvarTipoDoc EQ "APROBAR">
	function funcAprobar()
	{
		var LvarDetalle = document.getElementById('CPCmotivoRechazo').value
		var LvarNivel = document.getElementById("CPCnivel").value;
		if (LvarDetalle != "")
		{
			alert('No puede indicar motivo de rechazo');
			document.getElementById('CPCmotivoRechazo').focus();
			return false;
		}
		else if (LvarNivel != "S")
		{
			LvarMonto = new Number(qf(document.getElementById("CPCmonto").value));
			LvarSaldo = new Number(qf(document.getElementById("SaldoDoc").value));
			LvarOtros = new Number(qf(document.getElementById("montoOtras").value));

			if (LvarMonto+LvarOtros > LvarSaldo)
			{
				alert ("El Monto Total que afecta el Pago " + (LvarMonto+LvarOtros) + " no puede ser mayor al Saldo del Documento " + LvarSaldo);
				return false;
			}
		}

		if (!confirm("¿Desea aprobar el Documento de Afectación de Pago: <cfoutput>#rsForm.Tipo# #rsForm.CPCdocumento#?</cfoutput>"))
			return false;
	}
	function funcRechazar()
	{
		var LvarDetalle = document.getElementById('CPCmotivoRechazo').value
		if (LvarDetalle == "")
		{
			alert('Indique un motivo de rechazo');
			document.getElementById('CPCmotivoRechazo').focus();
			return false;
		}
	}
<cfelseif LvarTipoDoc EQ "ANULAR">
	function funcAnular()
	{
		var LvarDetalle = document.getElementById('CPCmotivoRechazo').value
		if (LvarDetalle == "")
		{
			alert('Indique un motivo de anulación');
			document.getElementById('CPCmotivoRechazo').focus();
			return false;
		}
	}
</cfif>
</script>
