<!---
																													
 --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroCta" default = "N&uacute;mero Cuenta" returnvariable="LB_NumeroCta" xmlfile = "CRCTCParametrosTC.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Zonas" default = "Zonas" returnvariable="LB_Zonas" xmlfile = "CRCTCParametrosTC.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoCredito" default = "Monto Cr&eacute;dito" returnvariable="LB_MontoCredito" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoValeBlanco" default = "Monto Vale Empresa" returnvariable="LB_MontoValeBlanco" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CreditoAbierto" default = "Cr&eacute;dito Abierto" returnvariable="LB_CreditoAbierto" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_tarjetaCredito" default = "Tarjeta Cr&eacute;dito" returnvariable="LB_tarjetaCredito" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LimCredito" default = "L&iacute;mite Cr&eacute;dito" returnvariable="LB_LimCredito" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasGracia" default = "D&iacute;as de gr&aacute;fica" returnvariable="LB_DiasGracia" xmlfile = "CRCTCParametros.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Seguro" default = "Seguro" returnvariable="LB_Seguro" xmlfile = "CRCTCParametros.xml">






<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_SNegocio" default = "Socio de negocio" returnvariable="LB_SNegocio" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NomSocio" default = "Nombre socio negocio" returnvariable="LB_NomSocio" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Direccion" default = "Direcci&oacute;n" returnvariable="LB_Direccion" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Telefono" default = "Tel&eacute;fono" returnvariable="LB_Telefono" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Ciudad" default = "Ciudad" returnvariable="LB_Ciudad" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Estado" default = "Estado" returnvariable="LB_Estado" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CodPos" default = "C&oacute;digo Postal" returnvariable="LB_CodPos" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TCfechaNacimiento" default = "Fecha Nacimiento" returnvariable="LB_TCfechaNacimiento" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_TCfechaNacimiento" default = "Fecha Nacimiento" returnvariable="LB_TCfechaNacimiento" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoMaximoPorCorte" default = "Monto M&aacute;ximo por Corte" returnvariable="LB_MontoMaximoPorCorte" xmlfile = "CRCTCParametros.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Pais" default = "Pa&iacute;s" returnvariable="LB_Pais" xmlfile = "CRCTCParametros.xml">


<cfquery datasource="#session.dsn#" name="rsSNid">
	select * from CRCCuentas cc
		inner join SNegocios sn 
			on cc.SNegociosSNid = sn.SNid
	and cc.Ecodigo = #Session.Ecodigo#
	and sn.SNCodigo = #form.SNCodigo#
	and cc.Tipo = 'TC'
</cfquery>

<cfset LvarId = -1>
<cfset LvarSNId = -1>
<cfif rsSNid.RecordCount gt 0>
	<cfset LvarId = #rsSNid.id#>
	<cfset LvarSNId = #rsSNid.SNid#>
</cfif>

<cfquery datasource="#session.dsn#" name="rsTar">
	select * from CRCTarjeta cc
	where CRCCuentasid = #LvarId#
	and cc.Mayorista is null
	and cc.CRCTarjetaAdicionalid is null
</cfquery>

<cfquery datasource="#session.dsn#" name="rsZonas">
	select * from CRCZonas
</cfquery>
<!--- <cfif isdefined('form.idTC')>
 --->
	<cfquery datasource="#session.dsn#" name="rsParam">
		select * from CRCTCParametros cp
			inner join SNegocios sn
				on cp.SNegociosSNid = SNid
		where  sn.SNCodigo = #form.SNCodigo#
		<cfif trim(LvarId) neq ''>
			and CRCCuentasid = #LvarId#
		<cfelse>
			and TCLimiteCredito is not null
			and TCSeguro 		is not null
		</cfif>
	</cfquery>
<!--- </cfif> --->


<form action="CRCTCParametros-sql.cfm" method="post" name="form" onSubmit="return validarDGenerales(this);">
	<cfoutput>
	<cfif isdefined('rsParam') and rsParam.RecordCount GT 0>
		<input name="idTC" value="#rsParam.id#" size="60" maxlength="100" type="hidden">
	</cfif>
	<cfif isdefined('form.SNCodigo')>
		<input name="SNCodigo" value="#form.SNCodigo#" size="60" maxlength="100" type="hidden">
	</cfif>
		<input name="Tipo" id="Tipo" value="TC" size="60" maxlength="100" type="hidden">

		<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">
			<tbody>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_NumeroCta#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="NCuenta" id="NCuenta" readonly
				<cfif rsSNid.RecordCount GT 0>
					value="#rsSNid.Numero#"
				</cfif>
				size="20" maxlength="60" type="text"></td>
			</tr>
			<cfif rsTar.RecordCount GT 0>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_tarjetaCredito#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="NTarj" id="NTarj" readonly
					value="#rsTar.Numero#"
				size="20" maxlength="60" type="text"></td>
			</tr>
			</cfif>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_MontoCredito#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="TCLimiteCredito" id="TCLimiteCredito" 
				<cfif rsSNid.RecordCount GT 0>
					value="#LSNumberFormat(rsSNid.MontoAprobado,',9.00')#" readonly
				</cfif> 
				onKeyPress="return soloNumeros(event)"
				size="20" maxlength="60"
				type="text" required>
				<input type="hidden" name="TCLimiteCreditoHide" id="TCLimiteCreditoHide" value="#rsSNid.MontoAprobado#" >
				</td>
			</tr>
					
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
				<td nowrap="" align="right" style="width:50%"><strong>#LB_Seguro#:</strong>&nbsp;</td>
				<td nowrap="" align="" style="width:50%">
					<select name="TCSeguro" id="TCSeguro">
						<option value="0"
							<cfif isdefined('rsParam') and rsParam.TCSeguro eq 0>
								selected
							</cfif>
							>No</option>
						<option value="1"
							<cfif isdefined('rsParam') and rsParam.TCSeguro eq 1>
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
							<input type="submit" name="btnGenerarTar" id="btnGenerarTar" value="Generar Tarjeta"
								onclick="return funcValidarTC()"/>
						<cfelse>
							<cfif rsTar.Estado eq 'C'>
								<input type="hidden" name="numTC" value="#rsTar.numero#">
								<input type="submit" name="btnKillMasterTC" id="btnKillMasterTC" value="Generar Nueva Tarjeta"/>
								<br>
								<input type="checkbox" checked name="chkKillMasterTC" id="chkKillMasterTC"> Generar cargo por reimpresion de tarjeta
							</cfif>
						</cfif>
						<br>
						<input type="submit" name="btnGuardarTC" id="btnGuardarTC" 	value="Guardar."
							onclick="return funcValidarTC()"/>
					<cfelse>
						<input type="submit" name="btnGenerarTC" id="btnGenerarTC"	value="Generar Cuenta" 
						onclick="return funcValidarTC()"/>
						
					</cfif>
				</td>
			</tr>
		</table>
	</form>
	<cfif rsTar.RecordCount GT 0>
		<!---
			Tarjeta Adicional.
		--->
		<cfquery datasource="#session.dsn#" name="rsTarAdicional">
			select ta.id as idTCDet,* 
				from CRCTarjetaAdicional ta
				left join CRCTarjeta  ct
					on ct.CRCTarjetaAdicionalid = ta.id
				where ta.SNid = #LvarSNId# and  isNull(ta.esMayorista,0) <> 1 and ct.oldCRCCuentasid is null				
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
				query="#rsTarAdicional#"
				campos="SNnombre,Numero"
				desplegar="SNnombre,Numero"
				etiquetas="Nombre,TarjetaAdicional"
				formatos="S,S"
				align="left,left"
				ajustar="S,S"
				formName="formPlistas"
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
				<cfif isdefined('form.idTCDet') and form.idTCDet neq -1>
					<cfquery datasource="#session.dsn#" name="rsTarDet">
						select * from CRCTarjetaAdicional
						where id = #form.idTCDet#
					</cfquery>
					
					<cfquery datasource="#session.dsn#" name="rsValTar">
						select * from CRCTarjeta
						where CRCTarjetaAdicionalid = #form.idTCDet# and oldCRCCuentasid is null
					</cfquery>
					<input name="idTCDet" id="idTCDet" type="hidden" value="#form.idTCDet#">
				</cfif>
				<cfif isdefined('form.SNCodigo')>
					<input name="SNCodigo" value="#form.SNCodigo#" size="60" maxlength="100" type="hidden">
				</cfif>
				<input name="Tipo" id="Tipo" value="TC" size="60" maxlength="100" type="hidden">
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
						<td><input name="SNnombre1" id="SNnombre1" size="30" maxlength="255"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.SNnombre#"
						</cfif>
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Direccion#:</strong>&nbsp;</td>
						<td><input name="TCdireccion1" id="TCdireccion1" size="30" maxlength="255"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.TCdireccion1#"
						</cfif>
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Telefono#:</strong>&nbsp;</td>
						<td><input name="Telefono" id="Telefono" size="30" maxlength="30"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.Telefono#"
						</cfif>		
						onKeyPress="return valTelefono(event)"
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Ciudad#:</strong>&nbsp;</td>
						<td><input name="TCciudad"  id="TCciudad" size="30" maxlength="100"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.TCciudad#"
						</cfif>	
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Estado#:</strong>&nbsp;</td>
						<td><input name="TCestado" id="TCestado"  size="30" maxlength="100"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.TCestado#"
						</cfif>		
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_Pais#:</strong>&nbsp;</td>
						<td>
						<select tabindex="1" name="TCpais" id="TCpais">
							<cfloop query="rsPais">
								<option value="#rsPais.Ppais#" 
									<cfif isdefined('rsTarDet') and rsTarDet.TCpais eq  
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
						<td><input name="TCcodPostal" id="TCcodPostal"   size="30" maxlength="100"
						<cfif isdefined('rsTarDet')>
							value="#rsTarDet.TCcodPostal#"
						</cfif>	
						onKeyPress="return soloNumeros(event)"
						type="text"></td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_TCfechaNacimiento#:</strong>&nbsp;</td>
						<td>
						<cfif isdefined('rsTarDet')>
							<cf_sifcalendario  tabindex="3" form="form" name="TCfechaNacimiento" id="TCfechaNacimiento" 
							value="#LSDateFormat(rsTarDet.TCfechaNacimiento,'dd/mm/yyyy')#">
						<cfelse>
							<cf_sifcalendario  tabindex="3" form="form" name="TCfechaNacimiento"  id="TCfechaNacimiento">
						</cfif>
						</td>
					</tr>
					<tr>
						<td nowrap="" align="right"><strong>#LB_MontoMaximoPorCorte#:</strong>&nbsp;</td>
						<td><input name="montoMaxCorte" id="montoMaxCorte" size="30" maxlength="100"
						<cfif isdefined('rsTarDet')>
							value="#NumberFormat(rsTarDet.MontoMaximo,"00.00")#"
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
							<cfif isdefined('form.idTCDet') and form.idTCDet neq -1>
								<input type="submit" name="btnActualizarTA" id="btnActualizarTA" 	value="Actualizar"
								onclick="return funcValidarDet()"/>
								<input type="submit" name="btnEliminarTA"  	id="btnEliminarTA" 		value="Eliminar"/>
								<input type="submit" name="btnNuevoTA"  	id="btnNuevoTA" 		value="Nuevo"/>
								<cfif isdefined('rsValTar') and rsValTar.RecordCount LT 1>
									<input type="submit" name="btnGenerarTADet" id="btnGenerarTADet" 	value="Generar Tarjeta." onclick=""/>
								<cfelse>
									<cfif rsValTar.Estado eq 'C'>
										<input type="hidden" name="numTC" value="#rsValTar.numero#">
										<input type="submit" name="BtnKillAddTC" id="BtnKillAddTC" value="Generar Nueva Tarjeta"/>
										<br>
										<input type="checkbox" checked name="chkKillAddTC" id="chkKillAddTC"> Generar cargo por reimpresion de tarjeta
									</cfif>
								</cfif>
							<cfelse>
								<input type="submit" name="btnGuardarTA" id="btnGuardarTA"	 	value="Guardar" 
									onclick="return funcValidarDet()"/>
								
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
	//
	function funcSubmit(){
		//document.getElementById("formPlistas").submit;
		alert('Saludos');
	}
	//Solo permite ingresar numeros.
	function soloNumeros(e){
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
	}

	//Solo permite ingresar numeros gion espacio punto .
	function valTelefono(e){
        var keynum = window.event ? window.event.keyCode : e.which;
		console.log(keynum);
        if ((keynum == 8) || (keynum == 46) || (keynum == 45)|| (keynum == 32))
        return true;
         
        return /\d/.test(String.fromCharCode(keynum));
	}

	//Solo permite ingresar numeros.
	function funcValidarTC(){
		var 	LvarTCLimiteCredito	= document.getElementById("TCLimiteCredito").value;
		var 	LvarTCSeguro		= document.getElementById("TCSeguro").value;
		
		erroMsg = "Los siguientes campos no pueden estar vacios:";
		funcResult = true;
		
		if(LvarTCLimiteCredito == ''){erroMsg += "\n- Monto de Credito"; funcResult = false;}
		if(LvarTCSeguro == ''){erroMsg += "\n-Seguro"; funcResult = false;}
		
		if(!funcResult){alert(erroMsg);}

		return funcResult;
	}
	function funcValidarDet(){
		var 	LvarSNnombre		= document.getElementById("SNnombre1").value;
		var 	LvarTCdireccion1	= document.getElementById("TCdireccion1").value;
		var 	LvarTelefono		= document.getElementById("Telefono").value;
		var 	LvarTCciudad		= document.getElementById("TCciudad").value;
		var 	LvarTCestado 		= document.getElementById("TCestado").value;
		var 	LvarTCcodPostal		= document.getElementById("TCcodPostal").value;
		var 	LvarTCfecha			= document.getElementById("TCfechaNacimiento").value;
		var 	LvarTCpais			= document.getElementById("TCpais").value;
		var 	MontoCta 			= parseFloat(document.getElementById('TCLimiteCreditoHide').value);
		var 	MontoCtaT 			= document.getElementById('TCLimiteCredito').value;
		var 	MontoTar			= parseFloat(document.getElementById('montoMaxCorte').value);
		var 	MontoTarT			= document.getElementById('montoMaxCorte').value;
		
		erroMsg = "Los siguientes campos no pueden estar vacios:";
		funcResult = true;
		
		if(LvarSNnombre == ''){erroMsg += "\n- Nombre"; funcResult = false;}
		if(LvarTCdireccion1 == ''){erroMsg += "\n- Direcci&oacute;n"; funcResult = false;}
		if(LvarTelefono == ''){erroMsg += "\n- Tel&eacute;fono"; funcResult = false;}
		if(LvarTCciudad == ''){erroMsg += "\n- Ciudad"; funcResult = false;}
		if(LvarTCestado == ''){erroMsg += "\n- Estado"; funcResult = false;}
		if(LvarTCcodPostal == ''){erroMsg += "\n- Codigo Postal"; funcResult = false;}
		if(LvarTCfecha == ''){erroMsg += "\n- Fecha"; funcResult = false;}
		if(LvarTCfecha == ''){erroMsg += "\n- Fecha"; funcResult = false;}
		if(LvarTCpais == ''){erroMsg += "\n- Pa&iacute;s"; funcResult = false;}
		
		if(!funcResult){alert(erroMsg); return funcResult;}

		if((MontoTarT.split(".").length - 1) > 2){erroMsg = "Error al convertir el monto maximo de la tarjeta adicional ["+MontoTarT+"]"; funcResult = false;}
		if(!funcResult){alert(erroMsg); return funcResult;}

		if(MontoCta < MontoTar){erroMsg = "El monto maximo de la tarjeta adicional no debe exceder el monto maximo de la cuenta ["+MontoCtaT+"]"; funcResult = false;}
		if(!funcResult){alert(erroMsg);}

		return funcResult;

	}			
		
</script>
