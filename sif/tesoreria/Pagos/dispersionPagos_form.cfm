

<cfquery name="miTesoreria" datasource="#session.dsn#">
	select TESid,TEScodigo,TESdescripcion,Edescripcion
	from Tesoreria t
		inner join Empresas e
			on e.Ecodigo=t.EcodigoAdm
	WHERE t.CEcodigo  = #session.CEcodigo# and e.Ecodigo = #session.Ecodigo#
</cfquery>
<cfset session.Tesoreria.TESid = miTesoreria.TESid>

<cfinclude template="../../Utiles/sifConcat.cfm">


<cfset navegacion="i=1">
<cfif isDefined('url.TESOPnumero_F')><cfset form.TESOPnumero_F = url.TESOPnumero_F></cfif>
<cfif isDefined('url.Beneficiario_F')><cfset form.Beneficiario_F = url.Beneficiario_F></cfif>
<cfif isDefined('url.TESOPfechaPago_F')><cfset form.TESOPfechaPago_F = url.TESOPfechaPago_F></cfif>
<cfif isDefined('url.CBidPago_F')><cfset form.CBidPago_F = url.CBidPago_F></cfif>
<cfif isDefined('url.EcodigoPago_F')><cfset form.EcodigoPago_F = url.EcodigoPago_F></cfif>
<cfif isDefined('url.MISO4217PAGO_F')><cfset form.MISO4217PAGO_F = url.MISO4217PAGO_F></cfif>
<cfif isDefined('url.TESMPcodigo')><cfset form.TESMPcodigo = url.TESMPcodigo></cfif>


<cfquery name="disp_query" datasource="#session.DSN#">
	Select op.TESOPid,
		TESOPnumero,
		TESOPbeneficiario #_Cat# ' <strong>' #_Cat# coalesce(TESOPbeneficiarioSuf,'') #_Cat# '</strong>' as TESOPbeneficiario,
		TESOPfechaPago,
		op.Miso4217Pago,
		Edescripcion as empPago,
		Bdescripcion as bcoPago,
		CBcodigo,
		TESOPtotalPago,
		case mp.TESTMPtipo
			when 1 then 'CHK ' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
			when 2 then 'TRI ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 3 then 'TRE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 4 then 'TRM ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
			when 5 then 'TCE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
		end as DocPago,
		TESOPmsgRechazo,				
		10 as PASO,
		case op.TESOPestado
			when  10 then 'Preparación'
			when  11 then 'En Emisión'
			when  110 then 'Sin Aplicar'
			when  12 then 'Aplicada'
			when  13 then 'Anulada'
			when 101 then 'Aprobación'
			when 103 then 'Rechazada'
			else 'Estado desconocido'
		end as TESOPestado,
		coalesce(op.TESTLid,op.TESCFLid) as Lote,
	   op.TESMPcodigo as TESMPcodigo
	from TESordenPago op
		left join CuentasBancos cb
			inner join Bancos b
				on b.Bid 	= cb.Bid
				on cb.CBid	= CBidPago
		left join TESmedioPago mp
			on mp.TESid 		= #session.Tesoreria.TESid#
			and mp.CBid			= op.CBidPago
			and mp.TESMPcodigo 	= op.TESMPcodigo
		left outer join Empresas e
			on e.Ecodigo=op.EcodigoPago
	where op.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
		<cfif isdefined("form.TESOPnumero_F") and form.TESOPnumero_F neq ''>
			<cfset navegacion="#navegacion#&TESOPnumero_F=#form.TESOPnumero_F#">
			and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPnumero_F#">
		</cfif>
		<cfif isdefined("form.Beneficiario_F")>
			<cfset navegacion="#navegacion#&Beneficiario_F=#form.Beneficiario_F#">
			and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'')) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
		</cfif>
		<cfif isdefined("form.TESOPfechaPago_F") and form.TESOPfechaPago_F neq ''>
			<cfset navegacion="#navegacion#&TESOPfechaPago_F=#form.TESOPfechaPago_F#">
			and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
		</cfif>
		<cfif isdefined('form.CBidPago_F') and form.CBidPago_F NEQ ''>
			<cfset navegacion="#navegacion#&CBidPago_F=#form.CBidPago_F#">
			and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#listGetAt(form.CBidPago_F,1,',')#">
		<cfelse>
			and CBidPago = <cfqueryparam cfsqltype="cf_sql_numeric" value="-1">
		</cfif>	
		<cfif isdefined('form.EcodigoPago_F') and form.EcodigoPago_F NEQ ''>
			<cfset navegacion="#navegacion#&EcodigoPago_F=#form.EcodigoPago_F#">
			and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
		</cfif>				
		<cfif isdefined('form.MISO4217PAGO_F') and form.MISO4217PAGO_F NEQ ''>
			<cfset navegacion="#navegacion#&MISO4217PAGO_F=#form.MISO4217PAGO_F#">
			and op.Miso4217Pago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#"> 
		</cfif>			
		<cfif isdefined('form.TESMPcodigo') and form.TESMPcodigo NEQ ''>
			<cfset navegacion="#navegacion#&TESMPcodigo=#form.TESMPcodigo#">
			and op.TESMPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#"> 
		</cfif>
		and TESOPestado = 11
		AND mp.TESTMPtipo <> 1
		and TESTLid is null
		and TESCFLid is null
		and op.TESTPid is not null
</cfquery>

<cfset MedioPagosHTML = StructNew()>




<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<form name="formFiltro" method="post"  action="dispersionPago.cfm" style="margin: '0' ">
				<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td align="right" nowrap>
							<strong><cf_translate key=LB_CuentaPago>Cuenta Pago</cf_translate>:</strong>
						</td>
						<td  colspan="4">
							<cf_cboTESCBid name="CBidPago_F" Ccompuesto="yes" none="yes" Dcompuesto="yes" all="no" onChange="updateMedioPago(value);" tabindex="-1" >
							<cfloop query ="Request.rsTESctasBancos">
								<cfsavecontent variable='tempvar'>
									<cf_cboTESMPcodigo name="TESMPcodigo" value="0" CBid="#Request.rsTESctasBancos.CBID#" CBidValue="#Request.rsTESctasBancos.CBID#">
								</cfsavecontent>
								<cfset MedioPagosHTML["#Request.rsTESctasBancos.CBID#"] = "#rereplace(tempvar,"<script.+script>",'',"all")#">
								
							</cfloop>
						</td>
					</tr>
					<tr>
						<td nowrap align="right">
							<strong><cf_translate key=LB_TrabajarConTesoreria>Trabajar con Tesorería</cf_translate>:</strong>&nbsp;
						</td>
						<td colspan="2">
							<cf_cboTESid onchange="this.form.submit();" tabindex="1">
						</td>
						<td align="right"><strong><cf_translate key=LB_EmpresaPago>Empresa&nbsp;Pago</cf_translate>:</strong></td>
						<td>
							<cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap align="right">
							<strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong>
						</td>
						<td  colspan="2">
							<cfparam name="form.Beneficiario_F" default="">
							<input type="text" name="Beneficiario_F" value="<cfoutput>#form.Beneficiario_F#</cfoutput>" size="40" tabindex="1">
						</td>
						<td align="right" nowrap>
							<strong><cf_translate key=LB_MonedaPago>Moneda Pago</cf_translate>:</strong>
						</td>
						<td >
							<cfquery name="rsMonedas" datasource="#session.DSN#">
								select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
								from Monedas m 
									inner join TESempresas e
										 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
										and e.Ecodigo = m.Ecodigo
							</cfquery>
							
							<select name="Miso4217Pago_F" tabindex="1">
								<option value="">(Todas las Monedas)</option>
								<cfloop query="rsMonedas">
									<option value="<cfoutput>#rsMonedas.Miso4217#</cfoutput>" 
										<cfif isdefined('form.Miso4217Pago_F') and form.Miso4217Pago_F EQ rsMonedas.Miso4217> selected </cfif> >
									 <cfoutput>#rsMonedas.Mnombre#</cfoutput>
									</option>
								</cfloop>
							</select>
						</td>
					</tr> 
					<tr>
						<td nowrap align="right"><strong><cf_translate key=LB_NumOrden>Num.Orden</cf_translate>:</strong></td>
						<td colspan="2">
							<cfparam name="form.TESOPnumero_F" default="">
							<input type="text" name="TESOPnumero_F" value="<cfoutput>#form.TESOPnumero_F#</cfoutput>" size="22" tabindex="1">
						</td>
						<td nowrap align="right" valign="middle">
							<strong><cf_translate key=LB_HastaFecha>Hasta Fecha</cf_translate>:</strong>
						</td>
						<td nowrap valign="middle">
							<cfset fechadoc = ''>
							<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
								<cfset fechadoc = LSDateFormat(form.TESOPfechaPago_F,'dd/mm/yyyy') >
							</cfif>
							<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESOPfechaPago_F" tabindex="1">												
						</td>
					</tr>
					<tr>
						<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
						<td colspan="2" nowrap name="medioPagoSelect">
							<cfset session.tesoreria.TESMPcodigo = "">
							<select>
								<option value="" selected>Escoja una cuenta</option>
							</select>
						</td>
						<td align="right" nowrap>
							<strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong>
						</td>
						<td nowrap valign="middle">
							<select name="TESOPestado_F" id="TESOPestado_F" tabindex="1" disabled>
								<option value="11" selected><cf_translate key=LB_EnEmision>En Emisión</cf_translate></option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="middle">
							<input name="btnFiltrar" type="submit" onclick="javascript: if (window.funcFiltrar) return funcFiltrar();" id="btnFiltrar" value="FILTRAR" tabindex="2">
						</td>
					</tr>
				</table>
				
			</form>
		</td>
	</tr>
	
	<tr>
		<td>
			<cfif isdefined("disp_query")>
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#disp_query#"
					desplegar="TESOPnumero,TESOPbeneficiario,TESOPfechaPago,TESOPestado,empPago,CBcodigo,BcoPago,TESMPcodigo,Lote,DocPago,Miso4217Pago,TESOPtotalPago"
					etiquetas="Num.<BR>Orden,Beneficiario,Fecha Pago,Estado,Empresa Pago,Cuenta Pago,Banco,Medio de Pago,Lote,Doc<BR>Pago,Moneda<BR>Pago,Monto Pagar"
					formatos="S,S,D,S,S,S,S,S,S,S,S,M"
					align="right,left,center,left,left,left,left,left,left,left,right,right"
					maxrowsquery="5000"
					MaxRows="50"
					ira="dispersionPago.cfm"
					form_method="post"
					formName="formFiltro"
					showEmptyListMsg="yes"
					keys="TESOPid,CBcodigo"
					checkboxes="S"
					checkall="S"
					checkbox_function ="funcChk(this)"
					botones="Generar"
					navegacion="#navegacion#"
					EmptyListMsg="--- No se encontraron registros para la cuenta ---"
				>
				</cfinvoke>
			</cfif>
		</td>
	</tr>
</table>


<script type="text/javascript" language="JavaScript">
	
	<cfoutput> var #toScript(MedioPagosHTML,'mediosPagos')# </cfoutput>
	var id = document.getElementsByName('CBidPago_F')[0].value.split(',')[0];
	if(id != ""){
		document.getElementsByName('medioPagoSelect')[0].innerHTML=mediosPagos[id];
		for(var i = 0; i < document.getElementsByName('TESMPcodigo')[0].length; i++ ){
			<cfif isdefined('form.TESMPcodigo')>
				if('<cfoutput>#form.TESMPcodigo#</cfoutput>' == document.getElementsByName('TESMPcodigo')[0][i].value)
				document.getElementsByName('TESMPcodigo')[0][i].selected = true
			</cfif>
		}
	};
	
	function funcFiltrar(){
		if(document.getElementsByName('CBidPago_F')[0].value == ""){alert("ESCOJA UNA CUENTA"); return false;}
		return true;
	}

	function ValidarSeleccion(){
        var checked = false;
        var chks = document.getElementsByName('chk');
		for (var i = 0; i < chks.length; i++){
			if(chks[i].checked){checked = true;}
		}
        if(!checked){
            alert("No ha seleccionado registros para exportar");
            return false;
        }
        return true;
    }

    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }
	
	function funcGenerar(){		
		return ValidarSeleccion();
	}
	
	function updateMedioPago(id){
		var id = document.getElementsByName('CBidPago_F')[0].value.split(',')[0]
		if(id == ""){mediosPagos['-'] = '<select><option value="" selected>Escoja una cuenta</option></select>'; id = '-';}
		document.getElementsByName('medioPagoSelect')[0].innerHTML=mediosPagos[id];
	}

	function funcFiltroChkAllformFiltro(c){
        var chks = document.getElementsByName('chk');
		for (var i = 0; i < chks.length; i++){
			chks[i].checked = c.checked;
		}
	}
	
	
</script>
