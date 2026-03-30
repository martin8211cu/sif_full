<!---
																												
 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroCta" default = "N&uacute;mero Cuenta" returnvariable="LB_NumeroCta" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoCredito" default = "Monto Cr&eacute;dito" returnvariable="LB_MontoCredito" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoValeBlanco" default = "Monto Vale Empresa" returnvariable="LB_MontoValeBlanco" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CreditoAbierto" default = "Cr&eacute;dito Abierto" returnvariable="LB_CreditoAbierto" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_tarjetaCredito" default = "Tarjeta Cr&eacute;dito" returnvariable="LB_tarjetaCredito" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LimCredito" default = "L&iacute;mite Cr&eacute;dito" returnvariable="LB_LimCredito" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasGracia" default = "D&iacute;as de Gracia" returnvariable="LB_DiasGracia" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Seguro" default = "Seguro" returnvariable="LB_Seguro" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Zonas" default = "Zona" returnvariable="LB_Zonas" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LimCreD" default = "L&iacute;mite de Cr&eacute;dito" returnvariable="LB_LimCreD" xmlfile = "Distribuidor.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ciudad" default = "Ciudad" returnvariable="LB_Ciudad" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Estado" default = "Estado" returnvariable="LB_Estado" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CodPos" default = "C&oacute;digo Postal" returnvariable="LB_CodPos" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TCfechaNacimiento" default = "Fecha Nacimiento" returnvariable="LB_TCfechaNacimiento" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TCfechaNacimiento" default = "Fecha Nacimiento" returnvariable="LB_TCfechaNacimiento" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoMaximoPorCorte" default = "Monto M&aacute;ximo por Corte" returnvariable="LB_MontoMaximoPorCorte" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pais" default = "Pa&iacute;s" returnvariable="LB_Pais" xmlfile = "CRCTCParametros.xml">


<cfquery datasource="#session.dsn#" name="rsSNid">
	select cc.id as ctaID,* from CRCCuentas cc
		inner join SNegocios sn 
			on cc.SNegociosSNid = sn.SNid
	and cc.Ecodigo = #Session.Ecodigo#
	and sn.SNCodigo = #form.SNCodigo#
	and cc.Tipo = 'TM'
</cfquery>

<!--- 
<cfif isdefined('form.idTM') and form.idTM neq -1> --->
	<cfquery datasource="#session.dsn#" name="rsParam">
		select * from CRCTCParametros cp
			inner join SNegocios sn
				on cp.SNegociosSNid = SNid
		where  sn.SNCodigo = #form.SNCodigo#
		<cfif trim(rsSNid.ctaID) neq ''>
			and CRCCuentasid = #rsSNid.ctaID#
		<cfelse>
			and TMLimiteCredito is not null
			and TMDiasGracia   is not null
			and TMSeguro		is not null
		</cfif>
	</cfquery>
<!--- </cfif> --->
<cfset LvarId = -1>

<cfif rsSNid.RecordCount gt 0>
	<cfset LvarId = #rsSNid.id#>
	<cfset LvarSNId = #rsSNid.SNid#>
</cfif>

<cfquery datasource="#session.dsn#" name="rsTar">
	select * from CRCTarjeta cc
	where CRCCuentasid = #LvarId#
	and cc.Mayorista is not null
	and cc.CRCTarjetaAdicionalID is null
</cfquery>

<cfquery datasource="#session.dsn#" name="rsZonas">
	select * from CRCZonas
</cfquery>

<form action="CRCTCParametros-sql.cfm" method="post" name="form" onSubmit="return validarDGenerales(this);">
	<cfoutput>
		<cfif isdefined('rsParam') and rsParam.RecordCount GT 0>
			<input name="idTM" value="#rsParam.id#" size="60" maxlength="100" type="hidden">
		</cfif>
		<cfif isdefined('form.SNCodigo')>
			<input name="SNCodigo" value="#form.SNCodigo#" size="60" maxlength="100" type="hidden">
		</cfif>
		<input name="Tipo" id="Tipo" value="TM" size="60" maxlength="100" type="hidden">
		<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">
			<tbody>
			
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_NumeroCta#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="NCuenta" id="NCuenta" readonly
				<cfif rsSNid.RecordCount GT 0>
					value="#rsSNid.Numero#"
				</cfif>
				size="20" maxlength="100" type="text"></td>
			</tr>

			<cfif rsTar.RecordCount GT 0>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_tarjetaCredito#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="NTarj" id="NTarj" readonly
					value="#rsTar.Numero#"
				size="20" maxlength="60" type="text"></td>
			</tr>
			</cfif>
			
			<cfif rsSNid.RecordCount GT 0 and rsTar.RecordCount  LT 1>
				<tr>
					<td nowrap="" align="right" style="width:50%"><strong>#LB_Zonas#:</strong>&nbsp;</td>
					<td nowrap="" align="" style="width:50%">
						<select name="IdZonas" id="IdZonas">
							<cfloop query="rsZonas">	
								<option value="#rsZonas.id#">#rsZonas.Descripcion#</option>
							</cfloop>			
						</select>
					</td>
				</tr>
			</cfif>

			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_LimCreD#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="TMLimiteCredito"  id="TMLimiteCredito" 
					<cfif rsSNid.RecordCount GT 0>
						readonly
						value="#LSNumberFormat(rsSNid.MontoAprobado,',9.00')#"
					</cfif>
				onKeyPress="return soloNumeros(event,false)"
				size="20" maxlength="100" type="text" required></td>
			</tr>
			
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_DiasGracia#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="TMDiasGracia"  id="TMDiasGracia" 
					<cfif isDefined('rsParam')>
						value="#LSNumberFormat(rsParam.TMDiasGracia,',9')#"
					</cfif>
					onKeyPress="return soloNumeros(event,true)"
					size="20" maxlength="100" type="text" required></td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_Seguro#:</strong>&nbsp;</td>
				<td nowrap="" align="" style="width:50%">
					<select name="TMSeguro" id="TMSeguro">
						<option value="0"
							<cfif isdefined('rsParam') and rsParam.TMSeguro eq 0>
								selected
							</cfif>
						>No</option>
						<option value="1"
							<cfif isdefined('rsParam') and rsParam.TMSeguro eq 1>
								selected
							</cfif>
							>Si</option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" nowrap="">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" nowrap="" align="center" style="width:100%">
					<cfif rsSNid.RecordCount GT 0>
						<cfif rsTar.RecordCount LT 1>
							<input type="submit" name="btnGenerarTarTM" id="btnGenerarTarTM" value="Generar Tarjeta."
								onclick="return funcValidarTCM()"/>
						<cfelse>
							<cfif rsTar.Estado eq 'C'>
								<input type="hidden" name="numTC" value="#rsTar.numero#">
								<input type="submit" name="btnKillMayoristaTC" id="btnKillMayoristaTC" value="Generar Nueva Tarjeta"/>
								<br>
								<input type="checkbox" checked name="chkKillMayoristaTC" id="chkKillMayoristaTC"> Generar cargo por reimpresion de tarjeta
							</cfif>
						</cfif>
						<br>
						<input type="submit" name="btnGuardarTM" id="btnGuardarTM" 		value="Guardar."
								onclick="return funcValidarTCM()"/>
					<cfelse>
						<br>
						<input type="submit" name="btnGenerarTM" 	id="btnGenerarTM"	 value="Generar Cuenta"
							onclick="return funcValidarTCM()"/>
					</cfif>
				</td>
			</tr>
		</table>
	</cfoutput>
</form>
<cfoutput>
<cfif rsTar.RecordCount GT 0>
		<!---
			Tarjeta Adicional.
		--->
		<cfquery datasource="#session.dsn#" name="rsTarAdicionalM">
			select ta.id as idTCDetM,* 
				from CRCTarjetaAdicional ta
				left join CRCTarjeta  ct
					on ct.CRCTarjetaAdicionalid = ta.id	
				where ta.SNid = #LvarSNId# and  isNull(ta.esMayorista,0) = 1 and ct.oldCRCCuentasid is null				
		</cfquery>

		<cfquery datasource="#session.dsn#"  name="rsPais">
			select Ppais, Pnombre
			from Pais
			order by Pnombre
		</cfquery>
		<div class="row">
		<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">	
			<tr>
				<td colspan="2" align="center">&nbsp</td>
			</tr>
			<tr>
				<td colspan="2" align="center"><strong>Tarjeta Adicional.<strong></td>
			</tr>
			<tr>
				<td colspan="2" align="center">&nbsp</td>
			</tr>
		</table>
		<div class="col-md-6">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsTarAdicionalM#"
				campos="SNnombre,Numero"
				desplegar="SNnombre,Numero"
				etiquetas="Nombre,TarjetaAdicional"
				formatos="S,S"
				align="left,left"
				ajustar="S,S"
				formName="formPlistasM"
				irA="CRCTCParametros-sql.cfm"
				checkboxes="N"
				with="100%"
				>
			</cfinvoke>
		</div>
			<form action="CRCTCParametros-sql.cfm" method="post" name="form" onSubmit="return validarDGenerales(this);">
			<div class="col-md-6">
				<cfif rsTar.RecordCount GT 0>
					<input name="NTarj" id="NTarj" value="#rsTar.Numero#" type="hidden">
				</cfif>
				<cfif isdefined('form.idTCDetM') and form.idTCDetM neq -1>
					<cfquery datasource="#session.dsn#" name="rsTarDetM">
						select * from CRCTarjetaAdicional
						where id = #form.idTCDetM#
					</cfquery>
					
					<cfquery datasource="#session.dsn#" name="rsValTar">
						select * from CRCTarjeta
						where CRCTarjetaAdicionalid = #form.idTCDetM# and oldCRCCuentasid is null
					</cfquery>
					<input name="idTCDetM" id="idTCDetM" type="hidden" value="#form.idTCDetM#">
				</cfif>
				<cfif isdefined('form.SNCodigo')>
					<input name="SNCodigo" value="#form.SNCodigo#" size="60" maxlength="100" type="hidden">
				</cfif>
				<input name="Tipo" id="Tipo" value="TM" size="60" maxlength="100" type="hidden">
				<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">
					<tbody>
						<input name="SNid" size="10" 
							maxlength="255" readonly
							value="#LvarSNId#"
							type="hidden">
					<!--- <tr>
						<td nowrap="" align="right"><strong>#LB_SNegocio#:</strong>&nbsp;</td>
						<td></td>
					</tr> --->
					<tr>
						<td nowrap="" align="right"><strong>Nombre Completo:</strong>&nbsp;</td>
						<td><input name="SNnombre1M" id="SNnombre1M" size="30" maxlength="255" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.SNnombre#"
						</cfif>
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Direccion#:</strong>&nbsp;</td>
						<td><input name="TCdireccion1M" id="TCdireccion1M" size="30" maxlength="255" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.TCdireccion1#"
						</cfif>
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Telefono#:</strong>&nbsp;</td>
						<td><input name="TelefonoM" id="TelefonoM" size="30" maxlength="30" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.Telefono#"
						</cfif>		
						onKeyPress="return soloNumeros(event)"
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Ciudad#:</strong>&nbsp;</td>
						<td><input name="TCciudadM"  id="TCciudadM" size="30" maxlength="100" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.TCciudad#"
						</cfif>	
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Estado#:</strong>&nbsp;</td>
						<td><input name="TCestadoM" id="TCestadoM"  size="30" maxlength="100" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.TCestado#"
						</cfif>		
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Pais#:</strong>&nbsp;</td>
						<td>
						<select tabindex="1" name="TCpaisM" id="TCpaisM">
							<cfloop query="rsPais">
								<option value="#rsPais.Ppais#" 
									<cfif isdefined('rsTarDetM') and rsTarDetM.TCpais eq  
										rsPais.Ppais>selected</cfif>
									>
								#rsPais.Pnombre#
								</option>
							</cfloop>
						</select>
					</td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_CodPos#:</strong>&nbsp;</td>
						<td><input name="TCcodPostalM" id="TCcodPostalM"   size="30" maxlength="100" required=""
						<cfif isdefined('rsTarDetM')>
							value="#rsTarDetM.TCcodPostal#"
						</cfif>	
						onKeyPress="return soloNumeros(event)"
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_TCfechaNacimiento#:</strong>&nbsp;</td>
						<td>
						<cfif isdefined('rsTarDetM')>
							<cf_sifcalendario  tabindex="3" form="form" name="TCfechaNacimientoM" id="TCfechaNacimientoM" 
							value="#LSDateFormat(rsTarDetM.TCfechaNacimiento,'dd/mm/yyyy')#">
						<cfelse>
							<cf_sifcalendario  tabindex="3" form="form" name="TCfechaNacimientoM"  id="TCfechaNacimientoM">
						</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_MontoMaximoPorCorte#:</strong>&nbsp;</td>
						<td><input name="montoMaxCorteM" id="montoMaxCorteM" size="30" maxlength="100" 
						<cfif isdefined('rsTarDetM')>
							value="#NumberFormat(rsTarDetM.MontoMaximo,"00.00")#"
						</cfif>	
						onKeyPress="return soloNumeros(event)"
						type="text" required>
						</td>
					</tr>
					<tr>
						<td colspan="2" nowrap="">&nbsp;</td>
					</tr>
					<tr>	
						<cfquery datasource="#session.dsn#" name="rsTarAdi">
							select count(1) as conta from CRCTarjetaAdicional
						</cfquery>
						<td colspan="2" nowrap="" align="center">
							<cfif isdefined('form.idTCDetM') and form.idTCDetM neq -1>
								<input type="submit" name="btnActualizarTAM" id="btnActualizarTAM" 	value="Actualizar"
								onclick="return funcValidarDetM()"/>
								<input type="submit" name="btnEliminarTAM"  	id="btnEliminarTAM" 		value="Eliminar"/>
								<input type="submit" name="btnNuevoTAM"  		id="btnNuevoTAM" 		value="Nuevo"/>
								<cfif isdefined('rsValTar') and rsValTar.RecordCount LT 1>
									<input type="submit" name="btnGenerarTAMDet" id="btnGenerarTAMDet" 	value="Generar Tarjeta." onclick=""/>
								<cfelse>
									<cfif rsValTar.Estado eq 'C'>
										<input type="hidden" name="numTC" value="#rsValTar.numero#">
										<input type="submit" name="BtnKillAddTM" id="BtnKillAddTM" value="Generar Nueva Tarjeta"/>
										<br>
										<input type="checkbox" checked name="chkKillAddTM" id="chkKillAddTM"> Generar cargo por reimpresion de tarjeta
									</cfif>
								</cfif>
							<cfelse>
								<input type="submit" name="btnGuardarTAM" id="btnGuardarTAM"	 	value="Guardar" 
									onclick="return funcValidarDetM()"/>
								
							</cfif>
						</td>
					</tr>
				</table>
			</div>
			</form>
		</div>
	</cfif>
</cfoutput>
<script language="javascript" type="text/javascript">
	//Solo permite ingresar numeros.
	function soloNumeros(e,esEntero){
        var keynum = window.event ? window.event.keyCode : e.which;
		if(esEntero){
			if (e.key == '.'){ return false;}
		}
    	if ((keynum == 8) || (keynum == 46)){ return true;}
        return /\d/.test(String.fromCharCode(keynum));
	}
	//Solo permite ingresar numeros.
	function funcValidarTCM(){
		var 	LvarTMDiasGracia	= document.getElementById("TMDiasGracia").value;
		var 	LvarTMLimiteCredito	= document.getElementById("TMLimiteCredito").value;		

		erroMsg = "Los siguientes campos no pueden estar vacios:";
		funcResult = true;
		
		if(LvarTMDiasGracia == ''){erroMsg += "\n- Nombre"; funcResult = false;}
		if(LvarTMLimiteCredito == ''){erroMsg += "\n- L&iacute;mite Cr&eacute;dito"; funcResult = false;}
		
		if(!funcResult){alert(erroMsg);}

		return funcResult;

			
			
	}	

	function funcValidarDetM(){
		var 	LvarSNnombre		= document.getElementById("SNnombre1M").value;
		var 	LvarTCdireccion1M	= document.getElementById("TCdireccion1M").value;
		var 	LvarTelefonoM		= document.getElementById("TelefonoM").value;
		var 	LvarTCciudadM		= document.getElementById("TCciudadM").value;
		var 	LvarTCestadoM 		= document.getElementById("TCestadoM").value;
		var 	LvarTCcodPostalM		= document.getElementById("TCcodPostalM").value;
		var 	LvarTCfecha			= document.getElementById("TCfechaNacimientoM").value;
		var 	LvarTCpaisM			= document.getElementById("TCpaisM").value;
		var 	MontoCta 			= parseFloat(document.getElementById('TCLimiteCreditoMHideM').value);
		var 	MontoCtaT 			= document.getElementById('TCLimiteCreditoM').value;
		var 	MontoTar			= parseFloat(document.getElementById('montoMaxCorteM').value);
		var 	MontoTarT			= document.getElementById('montoMaxCorteM').value;
		
		erroMsg = "Los siguientes campos no pueden estar vacios:";
		funcResult = true;
		
		if(LvarSNnombre == ''){erroMsg += "\n- Nombre"; funcResult = false;}
		if(LvarTCdireccion1M == ''){erroMsg += "\n- Direcci&oacute;n"; funcResult = false;}
		if(LvarTelefonoM == ''){erroMsg += "\n- Tel&eacute;fono"; funcResult = false;}
		if(LvarTCciudadM == ''){erroMsg += "\n- Ciudad"; funcResult = false;}
		if(LvarTCestadoM == ''){erroMsg += "\n- Estado"; funcResult = false;}
		if(LvarTCcodPostalM == ''){erroMsg += "\n- Codigo Postal"; funcResult = false;}
		if(LvarTCfecha == ''){erroMsg += "\n- Fecha"; funcResult = false;}
		if(LvarTCfecha == ''){erroMsg += "\n- Fecha"; funcResult = false;}
		if(LvarTCpaisM == ''){erroMsg += "\n- Pa&iacute;s"; funcResult = false;}
		
		if(!funcResult){alert(erroMsg); return funcResult;}

		if((MontoTarT.split(".").length - 1) > 2){erroMsg = "Error al convertir el monto maximo de la tarjeta adicional ["+MontoTarT+"]"; funcResult = false;}
		if(!funcResult){alert(erroMsg); return funcResult;}

		if(MontoCta < MontoTar){erroMsg = "El monto maximo de la tarjeta adicional no debe exceder el monto maximo de la cuenta ["+MontoCtaT+"]"; funcResult = false;}
		if(!funcResult){alert(erroMsg);}

		return funcResult;

	}	



</script>
