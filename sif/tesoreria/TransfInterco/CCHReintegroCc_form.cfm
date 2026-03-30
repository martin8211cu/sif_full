<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined ('url.TESRnumero') and (not isdefined('form.TESRnumero') or len(trim(form.TESRnumero)) eq 0)>
	<cfset form.TESRnumero=#url.TESRnumero#>
</cfif>

<cfif isdefined('form.TESRnumero') and len(trim(form.TESRnumero)) gt 0>
	<cfset modo='CAMBIO'>
<cfelse>
	<cfset modo='ALTA'>
</cfif>

<cfquery name="TCsug" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa, m.Miso4217
	from Htipocambio tc
		inner join Monedas m
			on m.Mcodigo = tc.Mcodigo     
	where tc.Ecodigo = #Session.Ecodigo#
		and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
		and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsEmpresa">
	select Miso4217
	  from Empresas e
		inner join Monedas m
			on m.Mcodigo = e.Mcodigo
	 where e.Ecodigo = #session.Ecodigo#
</cfquery>
<cfset LvarMiso4217LOC = rsEmpresa.Miso4217>
	
<cfif modo neq 'ALTA'>
	<cfquery name="rsform" datasource="#session.dsn#">
		select a.CBid,a.TESRdescripcion,a.TESRestado,TESRmonto,TESRnumero,CBidOri, TESMPcodigoOri, TESRtcOri, Miso4217, TESRmsgRechazo,
				case a.TESRestado 
					when 0  then 'En Preparacion'
					when 1  then 'En Registro Transferencias'
					when 2  then 'Transferencia Aplicada'
					when 11  then 'En Emisión' 
					when 12  then 'Reintegro Emitido' 
					when 13  then 'Rechazada'
				end as estado

			from TESreintegro a
				left join CuentasBancos cb on cb.CBid = CBidOri
				left join Monedas m on m.Mcodigo = cb.Mcodigo
		where a.TESRnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESRnumero#">
	</cfquery>	
	
	<cfset CBid=rsform.CBid>
	<cfset disabled = true>
	<cfset CBidOri = rsform.CBidOri>
<cfelse>
	<cfset CBid=''>
	<cfset disabled = false>
	<cfset CBidOri ='-1'>
</cfif>

<cfoutput>	
<form name="form1" action="CCHReintegroCc_sql.cfm" method="post">
	<table width="100%" align="center" border="0">
		<input type="hidden" name="Miso4217Loc" id="Miso4217Loc"  value="#LvarMiso4217Loc#" />
		<input type="hidden" name="modo" id="modo"  value="#modo#" />
		<input type="hidden" name="CBidDst" <cfif modo eq 'CAMBIO'> value='#CBid#'</cfif>/>
		<input type="hidden" name="TESRnumero" <cfif modo eq 'CAMBIO'> value='#rsForm.TESRnumero#'</cfif>/>
		<input type="hidden" tabindex="1" name="fecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		<tr>
			<td align="right">
				<strong>Num.Transacci&oacute;n:&nbsp;</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					-- Nueva Solicitud de Transacci&oacute;n --
				<cfelse>
					<strong>#rsForm.TESRnumero#</strong>
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Estado:&nbsp;</strong>
			</td>
			<td>	
				<cfif modo EQ "ALTA">
					<strong>NUEVA</strong>
				<cfelseif rsForm.TESRestado EQ 13>
					<font color="FF0000"><strong>RECHAZADA</strong></font>
				<cfelse>
					<strong>#rsForm.estado#</strong>
				</cfif>
			</td>
		</tr>

		<tr>
			
			<td align="right"><strong>Cuenta a reintegrar:</strong>&nbsp;</td>
			<td>
				<cf_cboTESCBid name="CBid" reintegro="true" value="#CBid#" Ccompuesto="yes" Dcompuesto="yes" none="yes" tabindex="1" disabled="#disabled#"> 
			</td>
		</tr>
		<tr>
			
			<td align="right"><strong>Cuenta de Pago:</strong>&nbsp;</td>
			<td>
				<cf_cboTESCBid name="CBidOri" value="#CBidOri#" Dcompuesto="yes" Ccompuesto="yes" none="yes" tabindex="1" onchange="limpiaMedioPago(this);sugerirTC();" >
				<input type="hidden" id="CuentaOrigenBD" name="CuentaOrigenBD" value="#CBidOri#"/>
				<input type="hidden" id="CBidOriCL" name="CBidOriCL" value="#ListFirst(CBidOri,',')#"/>
			</td>
		</tr>
		<tr>			
			<td align="right"><strong>Medio de Pago:</strong>&nbsp;</td>
			<td>
				<cfset valuesArraySN = ArrayNew(1)>
				<cfif isdefined("rsform.CBidOri") and len(trim(rsform.CBidOri)) AND isdefined("rsform.TESMPcodigoOri") and len(trim(rsform.TESMPcodigoOri))>
					<cfquery datasource="#Session.DSN#" name="rsSN">
						select 
						TESMPcodigo ,
						TESMPdescripcion #LvarCNCT#
							case TESTMPtipo
								when 1 then ' (CHK)'
								when 2 then ' (TRI)'
								when 3 then ' (TRE)'
								when 4 then ' (TRM)'
								else ' (???)'
							end as TESMPdescripcion
						from TESmedioPago			
						where TESid = #session.Tesoreria.TESid# 
						and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.CBidOri#">
						and TESTMPtipo<>1 
						and TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsform.TESMPcodigoOri#">
					</cfquery>
					<cfset ArrayAppend(valuesArraySN, rsSN.TESMPcodigo)>
					<cfset ArrayAppend(valuesArraySN, rsSN.TESMPdescripcion)>
					
				</cfif> 
				<cf_conlis
					Campos="TESMPcodigo,TESMPdescripcion"
					valuesArray="#valuesArraySN#"
					Desplegables="S,S"
					Modificables="S,N"
					Size="10,40"
					tabindex="5"
					Title="Lista de Medios de Pago"
					Tabla="TESmedioPago cf "
					Columnas="cf.TESMPcodigo,TESMPdescripcion #LvarCNCT#
								case TESTMPtipo
									when 1 then ' (CHK)'
									when 2 then ' (TRI)'
									when 3 then ' (TRE)'
									when 4 then ' (TRM)'
									else ' (???)'
								end as TESMPdescripcion"
					Filtro=" cf.TESid = #session.Tesoreria.TESid#  and cf.CBid = $CBidOriCL,numeric$ and TESTMPtipo<>1 order by cf.TESMPcodigo"
					Desplegar="TESMPcodigo,TESMPdescripcion"
					Etiquetas="Codigo,Descripcion"
					filtrar_por="cf.TESMPcodigo,TESMPdescripcion"
					Formatos="S,S"
					Align="left,left"
					form="form1"
					Asignar="TESMPcodigo,TESMPdescripcion"
					Asignarformatos="S,S"
					onChange="escondeAplicar();"
					funcion="escondeAplicar"
				/>
			</td>
		</tr>		
		<tr>
			<td align="right">
				<strong>Descripci&oacute;n:</strong>&nbsp;
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="descrip" maxlength="150" size="50" onChange="document.getElementById('GenerarOP').style.display='none';">
				<cfelse>
					<input type="text" name="descrip" maxlength="150" size="50" value="#rsForm.TESRdescripcion#" <cfif rsForm.TESRestado NEQ 0 > disabled="disabled" </cfif> onChange="document.getElementById('GenerarOP').style.display='none';">
				</cfif>
			</td>
		</tr>
	</table>
	<cfif modo neq 'ALTA'>
		<table width="100%" align="center" border="0">
		  	<tr>
				<td align="right" width="17%">
					<strong>Monto:</strong>
				</td>
				<td width="17%">
					<cf_inputNumber name="montoA" size="20" value="#rsForm.TESRmonto#" enteros="13" decimales="2" maxlenght="15" readOnly="yes" onChange="document.getElementById('GenerarOP').style.display='none';">				
				</td>
				<td align="right" width="15%"><strong>Tipo de Cambio:&nbsp;</strong></td>
				<td>
					<input 	type="text" name="TESRtcOri" id="TESRtcOri" tabindex="1"
							value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsForm.TESRtcOri, '9.9999')#<cfelseif rsform.Miso4217 EQ LvarMiso4217LOC>1.0000<cfelse>0.0000</cfif>" 
							size="18" maxlength="18" style="text-align:right;" 
							onFocus="this.value=qf(this); this.select();" 
							onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
							onBlur="javascript: fm(this,4);" 
							onChange="document.getElementById('GenerarOP').style.display='none';"
						<cfif rsform.Miso4217 EQ LvarMiso4217LOC>
							disabled
						</cfif>
					>
				</td>
			</tr>
			<cfif modo eq 'CAMBIO' and rsForm.TESRestado eq 13> <!---Rechazada--->
				<tr>
					<td align="right">
						<strong>Motivo de Rechazo:</strong>
					</td>
					<td colspan="3">
						<font color="FF0000"><strong>#rsForm.TESRmsgRechazo#</strong></font>
						
					</td>
				</tr>
			</cfif>
		</table>
	</cfif>		
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Agregar" value="Agregar" onClick="javascript: habilitarValidacion(); "/><!---onClick="javascript: habilitarValidacion(); "--->
					<input type="submit" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelseif modo eq 'CAMBIO' and rsForm.TESRestado eq 0><!---EN PROCESO--->
				<td colspan="4" align="center">
					<input type="submit" name="Modificar" value="Modificar" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" id="GenerarOP" name="GenerarOP" value="Generar OP" onClick="return Validar(this);"/>
					<input type="submit" id="ManualTF" name="ManualTF" value="Registro Manual" onClick="return Validar(this,'manual');"/>
					<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Nuevo" value="Nuevo" />
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			</cfif>
		</tr>
	</form>
	<cfif modo eq 'CAMBIO'>
		<tr>
			<td colspan="2">
				<cfinclude template="CCHReintegroCc_detalles.cfm">
			</td>
		</tr>
	</cfif>
</table>
</cfoutput>

<cf_qforms>
<script type="text/javascript" language="javascript" src="../../../CFIDE/scripts/wddx.js"></script>
<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		objForm.descrip.required = false;	
		objForm.CBid.required = false;	
		
	}

	function habilitarValidacion() {
		objForm.descrip.required = true;	
		objForm.CBid.required = true;		
		
	}
	objForm.descrip.description = "Descripcion";
	objForm.CBid.description = "Cuenta a Reintegrar";	
	objForm.CBidOriCL.description = "Cuenta Bancaria de Pago";
	
	
	
	function Validar(o, tipo)
	{	
			
		var LvarMSG='';
		var LvarOri = document.getElementById("CBidOri").value.split(",");
		var LvarCtaOriBD = document.getElementById("CuentaOrigenBD").value;			
				
		if(LvarOri[0] != LvarCtaOriBD)
		{
			alert("Presiones el boton Modificar antes de Generar OP");				
			return false;  
		}
		var LvarDst = document.getElementById("CBid").value.split(",");
		if (LvarOri[0] == LvarDst[0])
		{
			LvarMSG += "\n\t- Las Cuentas Origen y Destino no pueden ser iguales";
		}

		if (LvarOri[0] == "")
		{
			LvarMSG += "\n\t- La Cuenta de Pago es requerida";
		}
		else if (LvarOri[2] != LvarDst[2] && tipo != 'manual')
		{
			LvarMSG += "\n\t- Las Cuentas Origen y Destino deben estar en la misma moneda";
		}

		if (document.getElementById("TESMPcodigo").value == "" && tipo != 'manual')
		{
			LvarMSG += "\n\t- El Medio de Pago es requerido";
		}
		else if (document.getElementById("TESMPcodigo").value != "" && tipo == 'manual')
		{
			LvarMSG += "\n\t- No se debe indicar Medio de Pago con Registro Manual de Transferencia";
		}

		<cfif isdefined('rsForm.TESRmonto') and rsForm.TESRmonto EQ 0>
		LvarMSG += "\n\t- Debe escoger documentos a Reintegrar";
		</cfif>
		<cfif isdefined('rsForm.TESRtcOri') and rsForm.TESRtcOri EQ 0>
		LvarMSG += "\n\t- El Tipo de Cambio es Requerido";
		</cfif>

		if (LvarMSG!='')
		{
			alert(LvarMSG);							  
			return false;
		}
		else
		{	
			document.getElementById("CBid").disabled=false;	
			document.getElementById("TESRtcOri").disabled=false;		  
			document.forms["form1"].submit();
		}  
	}
	
	function sugerirTC() 
	{	
		var LvarValue = document.getElementById("CBidOri").value;
		var m = "";
		
		if (LvarValue != "")
		{
			m	= LvarValue.split(",")[2];
		}
		tc = document.getElementById("TESRtcOri");
		
		if(! m || ! tc)
			return;
		tc.disabled = false;
		if(m == "<cfoutput>#LvarMiso4217LOC#</cfoutput>")  
		{
			tc.value = "1.0000";
			tc.disabled = true;	
		}
		else
		{
			<cfoutput>
			<cfloop query="TCsug">
			if (m == "#TCsug.Miso4217#")
			{
				tc.value = "#TCsug.TCcompra#";
			}
			else
			</cfloop>
			</cfoutput>
			{ 
				tc.value = "0.0000";					
			}	
		}
	}
	
	function limpiaMedioPago()
	{ 
		document.getElementById("TESMPcodigo").value='';
		document.getElementById("TESMPdescripcion").value='';
		document.getElementById("CBidOriCL").value = document.getElementById("CBidOri").value.split(",")[0];
		if(document.getElementById('GenerarOP')) document.getElementById('GenerarOP').style.display='none';
		if(document.getElementById('ManualTF')) document.getElementById('ManualTF').style.display='none';
	}

	function escondeAplicar()
	{
		if(document.getElementById('GenerarOP')) document.getElementById('GenerarOP').style.display='none';
		if(document.getElementById('ManualTF')) document.getElementById('ManualTF').style.display='none';
	}
</script>
