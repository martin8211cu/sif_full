<!---
																												
 --->

<link href="/cfmx/jquery/estilos/jquery.modallink/jquery.modalLink-1.0.0.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" language="JavaScript" src="/cfmx/jquery/librerias/jquery.modallink/jquery.modalLink-1.0.0.js">
</script>

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumeroCta" default = "N&uacute;mero Cuenta" returnvariable="LB_NumeroCta" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Categoria" default = "Categor&iacute;a" returnvariable="LB_Categoria" xmlfile = "Distribuidor.xml">



<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoCredito" default = "Monto Cr&eacute;dito" returnvariable="LB_MontoCredito" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_MontoValeBlanco" default = "Monto Vale Blanco" returnvariable="LB_MontoValeBlanco" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CreditoAbierto" default = "Cr&eacute;dito Abierto" returnvariable="LB_CreditoAbierto" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_tarjetaCredito" default = "Tarjeta Cr&eacute;dito" returnvariable="LB_tarjetaCredito" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_LimCredito" default = "L&iacute;mite Cr&eacute;dito" returnvariable="LB_LimCredito" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_DiasGracia" default = "D&iacute;as de gr&aacute;fica" returnvariable="LB_DiasGracia" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Seguro" default = "Seguro" returnvariable="LB_Seguro" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PermiteContraValor" default = "Permitir Contra-vale" returnvariable="LB_PermiteContraValor" xmlfile = "Distribuidor.xml">

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_PorcSobregiro" default = "Porcentaje de sobregiro por vale" returnvariable="LB_PorcSobregiro" xmlfile = "Distribuidor.xml">

<!--- Obtenemmos la cuenta generada. --->
<cfquery datasource="#session.dsn#" name="rsSNid">
	select cc.id as ctaID,* from CRCCuentas cc
		inner join SNegocios sn 
			on cc.SNegociosSNid = sn.SNid
	and cc.Ecodigo = #Session.Ecodigo#
	and sn.SNCodigo = #form.SNCodigo#
 	and cc.Tipo = 'D'
</cfquery>
<!--- 
<cfif isdefined('form.idD') and form.idD NEQ -1> --->
	<cfquery datasource="#session.dsn#" name="rsParam">
		select * from CRCTCParametros cp
			inner join SNegocios sn
				on cp.SNegociosSNid = SNid
		where  sn.SNCodigo = #form.SNCodigo#
		<cfif trim(rsSNid.ctaID) neq ''>
			and CRCCuentasid = #rsSNid.ctaID#
		<cfelse>
			and    DMontoValeCredito is not null
			and    DCreditoAbierto is not null
			and    DSeguro 	is not null
		</cfif>
	</cfquery>
	
<!--- </cfif> --->

 <!--- Obtenemos categorias --->
<cfquery datasource="#session.dsn#" name="rsCatDist">
	select * from CRCCategoriaDist
	where Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Tiendas externas. --->
<cfquery datasource="#session.dsn#" name="rsTienExter">
	select * from CRCTiendaExterna
	where Ecodigo 	= #Session.Ecodigo#
	and Activo 		= 1 
</cfquery>

<cfoutput>

<cfset LvarLista=StructNew()>
<cfloop list='#rsParam.TiendaExterna#' index="key">
	<cfset valor = replace(key,"-", "", "all")> 
	<cfset tmpL = ListToArray(valor,":",false,false)>
	<cfset LvarLista[tmpL[1]]=tmpL[2] >
</cfloop>

<div class="row">

<form action="CRCTCParametros-sql.cfm" method="post" name="form1" id="form1">
	<div class="col-md-4">
		<table class="PlistaTable" align="center" border="0" cellspacing="0" cellpadding="0" width="auto"
			width="100%">
			<tr>
				<th class="tituloListas" width="1%" align="center"> 
					
				</th>
				<th class="tituloListas" width="1%" align="center"> 
					&nbsp
				</th>
				<th class="tituloListas" align="left" valign="bottom"><strong> C&oacute;digo</strong></th>
				<th class="tituloListas" align="left" valign="bottom"><strong> Descripci&oacute;n</strong></th>
				<th class="tituloListas" align="left" valign="bottom"><strong> C&oacute;digo Ext</strong></th> 
			</tr>
			<cfset LvarCon = 0>
			<cfloop query="rsTienExter">
				<cfset LvarCon =  LvarCon+1>
				<tr class="listaNon" onmouseover="this.className='listaNonSel';" onmouseout="this.className='listaNon';">
					<td class="listaNon" width="1%" align="left">
						<input name="CodigoExt#LvarCon#" id="CodigoExt#LvarCon#" value="#rsTienExter.Codigo#"  style="border:none; background-color:inherit;" type="checkbox"
							<cfif StructKeyExists(LvarLista, "#rsTienExter.id#")>checked</cfif>
						>
					</td>
					<th class="tituloListas" width="1%" align="center"> 
						&nbsp
					</th>
					<td align="left" width="18" height="18" nowrap="" >
						#rsTienExter.Codigo#
					</td>
					<td align="left" width="18" height="18" nowrap="" >
						#rsTienExter.Descripcion#
					</td>
					<td align="left" width="18" height="18" nowrap="" >
						<input type="text" name="CodigoExt#LvarCon#" id="CodigoExt#LvarCon#"
							<cfif StructKeyExists(LvarLista, "#rsTienExter.id#")>value="#LvarLista[rsTienExter.id]#"<cfelse>value=""</cfif>
						>
					</td>
					 
				</tr>
			</cfloop>					
		</table>
	</div>

	<div class="col-md-8">	
		<cfif isdefined('rsParam') and rsParam.RecordCount GT 0>
			<input name="idD" value="#rsParam.id#" size="60" maxlength="100" type="hidden">
		</cfif>
		<cfif isdefined('form.SNCodigo')>
			<input name="SNCodigo" value="#form.SNCodigo#" size="60" maxlength="100" type="hidden">
		</cfif>
		<input name="Tipo" id="Tipo" value="D" size="60" maxlength="100" type="hidden">
		<table width="100%" cellspacing="0" cellpadding="2" border="0" align="center">
			<tbody>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_NumeroCta#:</strong>&nbsp;</td>
				<td style="width:50%">
				<input name="NCta" id="NCta" type="text" Disabled size="25" 
				<cfif rsSNid.RecordCount GT 0>
					value="#rsSNid.Numero#"
				</cfif>
				>
				</td>
			</tr>
		<!--- 	<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_Categoria#:</strong>&nbsp;</td>
				<td style="width:50%">
				<select name="IdTExt" id="IdTExt"  onchange="">
					<cfloop query="rsTienExter">
						<option value="#rsTienExter.id#">#rsTienExter.Descripcion#</option>	
					</cfloop>
				</select>
				<input name="IdTE" id="IdTE" type="text" Disabled size="25" 
					<cfif isDefined('form.IdTE')>
						value="#form.IdTE#"
					</cfif>
				>
				</td>
			</tr> --->
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_Categoria#:</strong>&nbsp;</td>
				<td style="width:50%">
				<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
				<cfset catsubsidio = objParams.getParametroInfo('30000508')>
				<cfif catsubsidio.codigo eq ''><cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no esta definido"></cfif>
				<cfif catsubsidio.valor eq ''><cfthrow message="El parametro (30000508 - Categoria para Seguro Subsidiado) no tiene valor"></cfif>
				<select name="NCat" id="NCat"  onchange="funcSeguro(this,#catsubsidio.valor#);" required >
					<cfloop query="rsCatDist">
						<option value="#rsCatDist.id#|#rsCatDist.Orden#"
							<cfif rsSNid.RecordCount GT 0 and rsSNid.CRCCategoriaDistid eq rsCatDist.id>
								selected 
							</cfif>	
						>#rsCatDist.Titulo#</option>	
					</cfloop>
				</select>
				</td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_MontoCredito#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="DMontoCredito"  id="DMontoCredito" required
				<cfif rsSNid.RecordCount GT 0>
					value="#LSNumberFormat(rsSNid.MontoAprobado,',9.00')#" disabled
				<cfelse>
					value=""
				</cfif>
				onKeyPress="return soloNumerosD(event,false)"
				size="25" type="text"></td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_MontoValeBlanco#:</strong>&nbsp;</td>
				<td style="width:50%"><input name="DMontoValeCredito" id="DMontoValeCredito" required
				<cfif isdefined('rsParam') and rsParam.RecordCount gt 0>
							
					value="#LSNumberFormat(rsParam.DMontoValeCredito,',9.00')#" 
				<cfelse>
					value="" 
				</cfif>
				onKeyPress="return soloNumerosD(event,false)"
				size="25" type="text"></td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_CreditoAbierto#:</strong>&nbsp;</td>
				<td style="width:50%">
					<input name="DCreditoAbierto" id="DCreditoAbierto" value="1" size="60" maxlength="60" type="checkbox"
					<cfif isdefined('rsParam')  and rsParam.RecordCount gt 0 and rsParam.DCreditoAbierto eq 1>
						checked
					</cfif>
					>
				</td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_Seguro#:</strong>&nbsp;</td>
				<td style="width:50%">
					<select name="Dseguro" id="DSeguro" required>
							<option value="0"
								<cfif isdefined('rsParam')  and rsParam.RecordCount gt 0 and rsParam.DSeguro eq 0>
									selected
								</cfif>
							>No</option>
							<option value="1"
								<cfif isdefined('rsParam')  and rsParam.RecordCount gt 0  and rsParam.DSeguro eq 1>
									selected
								</cfif>
							>Si</option>
							<option value="2"
								<cfif isdefined('rsParam')  and rsParam.RecordCount gt 0  and rsParam.DSeguro eq 2>
									selected
								</cfif>
							>Subsidiado</option>
					</select>
				</td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_PermiteContraValor#:</strong>&nbsp;</td>
				<td style="width:50%">
					<input name="PermiteContraValor" id="PermiteContraValor" value="1" size="60" maxlength="60" type="checkbox"
					<cfif isdefined('rsParam')  and rsParam.RecordCount gt 0 and rsParam.PermiteContraValor eq 1>
						checked
					</cfif>
					>
				</td>
			</tr>
			<tr>
				<td nowrap="" align="right" style="width:50%"><strong>#LB_PorcSobregiro#:</strong>&nbsp;</td>
				<td style="width:50%">
					<input name="PorcSobregiro" id="PorcSobregiro" required
					<cfif isdefined('rsParam') and rsParam.RecordCount gt 0> 
						value="#LSNumberFormat(rsParam.PorcSobregiro,',0.00')#" 
					<cfelse>
						value="" 
					</cfif>
					onKeyPress="return soloNumerosD(event,false)"
					size="10" type="text"> %
				</td>
			</tr>
			<tr>
				<td colspan="2" nowrap="" style="width:100%">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2" nowrap="" align="center" style="width:100%">
					<cfif rsSNid.RecordCount GT 0>
						<input type="submit" name="btnGuardarD" 	id="btnGuardarD"	 	value="Guardar." 
					onclick="return funcValidarSaveD()"/>
					<cfelse>
						<input type="submit" name="btnGenerarD" 	id="btnGenerarD"	 	value="Generar Cuenta." 
							onclick="return funcValidarGenD()"/>
					</cfif>
					
				</td>
			</tr>
		</table>
		</div>
	</form>
</div>	
</cfoutput>


<script language="javascript" type="text/javascript">
	
	//Solo permite ingresar numeros.
	function soloNumerosD(e,esEntero){
        var keynum = window.event ? window.event.keyCode : e.which;
		if(esEntero){
			if (e.key == '.'){ return false;}
		}
    	if ((keynum == 8) || (keynum == 46)){ return true;}
        return /\d/.test(String.fromCharCode(keynum));
	}
	//Solo permite ingresar numeros.
	function funcValidarGenD(){
		var 	LvarNCat				= document.getElementById("NCat").value;
		var 	LvarDMontoCredito		= document.getElementById("DMontoCredito").value;
		var 	LvarDMontoValeCredito	= document.getElementById("DMontoValeCredito").value;
		var 	LvarDseguro				= document.getElementById("Dseguro").value;
		
		erroMsg = "Los siguientes campos no pueden estar vacios:";
		funcResult = true;
		
		if(LvarNCat == ''){erroMsg += "\n- Categoria"; funcResult = false;}
		if(LvarDMontoCredito == ''){erroMsg += "\n- Monto de Credito"; funcResult = false;}
		if(LvarDMontoValeCredito == ''){erroMsg += "\n- Monto Vale Blanco"; funcResult = false;}
		if(LvarDseguro == ''){erroMsg += "\n- Seguro"; funcResult = false;}
		
		if(!funcResult){alert(erroMsg);}

		return funcResult;
	}
	
	function funcValidarSaveD(){
		var 	LvarDMontoValeCredito	= document.getElementById("DMontoValeCredito").value;
		var 	LvarDseguro				= document.getElementById("Dseguro").value;
																			
		if(LvarDMontoValeCredito ==  '' || LvarDseguro ==  ''){
			return false;
		}
		return true;
	}


	function funcSeguro(s,OrdenMax){
		var selOrden = s.value.split('|')[1];
		if(selOrden >= OrdenMax){
			document.getElementById('DSeguro').value = "2";
		}else{
			if(document.getElementById('DSeguro').value != 0){
				document.getElementById('DSeguro').value = 1;
			}else{
				document.getElementById('DSeguro').value = 0;
			}
		}
	}

	/*function Abrir_ventana(SNCodigo) {
		var opciones="toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=yes, width=508, height=365, top=85, left=140";

		window.open('CRCTCTiendasExtPopPup.cfm?SNCodigo='+SNCodigo+'&Tab=8',"",opciones);
	}*/
</script>
