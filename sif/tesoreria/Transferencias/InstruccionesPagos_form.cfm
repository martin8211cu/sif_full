<!---
	Creado por Gustavo Fonseca Hernández.
	Fecha: 10-6-2005.
	Motivo: Creación del Mantenimiento de Instrucciones de Pago de Socios de Negocios.
 --->

<!---
	Ing. Óscar Bonilla, MBA
	Fecha: 26/05/2010
	Hay que revisar cómo determinar que el Banco de Pago sea el mismo Banco Destino,
		cuando se paga con una cuenta de una empresa diferente a la Administradora

	La cuenta destino de TEF es por Tesorería (y por tanto depende de la Empresa Administradora)

	Banco Destino es empresarial de la empresa Administradora
	Banco de Pago es empresarial de la empresa de Pago
	Moneda es empresarial pero es el mismo Miso4217 en cada empresa

	Socio de Negocio es empresarial de la empresa original S.P.
	Beneficiario Contado es Corporativo
	Cliente Detallista es Corporativo
 --->
<style type="text/css">
<!--
.style1 {
	color: #FF0000;
	font-weight: bold;
}
-->
</style>

<cf_navegacion name="ID">
<cf_navegacion name="TIPO">
<cf_navegacion name="TESTPid" default="0">

<cfset CAMBIO = 0>

<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC">
	<cfif form.TIPO EQ "SNC">
		<cfset LvarTITULO = "Socio de Negocios Corportativo">
	<cfelse>
		<cfset LvarTITULO = "Socio de Negocios">
	</cfif>
	<cfset LvarTipoId = "SNidP">
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select a.SNidentificacion as IDENTIFICACION, a.SNnombre as NOMBRE, a.SNid as ID, Ppais, id_direccion, SNCBidPago_Origen, SNMedPago_Origen, SNcodigo
		  from SNegocios a
		 where a.SNidCorporativo is null
		   and a.SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
	<cfquery name="rsCHK" datasource="#session.DSN#">
		select count(1) as resultado
		  from TEStransferenciaP
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and SNidP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
<cfelseif form.TIPO EQ "BT">
	<cfset LvarTITULO = "Beneficiario de Contado">
	<cfset LvarTipoId = "TESBid">
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select a.TESBeneficiarioId as IDENTIFICACION, a.TESBeneficiario as NOMBRE, a.TESBid as ID, <CF_jdbcquery_param cfsqltype="cf_sql_char" value="null"> as Ppais, id_direccion,
				Ecodigo, DEid, SNCBidPago_Origen, SNMedPago_Origen
		  from TESbeneficiario a
		 where a.TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
	<cfquery name="rsCHK" datasource="#session.DSN#">
		select count(1) as resultado
		  from TEStransferenciaP
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and TESBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
<cfelseif form.TIPO EQ "CD">
	<cfset LvarTITULO = "Cliente Detallista">
	<cfset LvarTipoId = "CDCcodigo">
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select a.CDCidentificacion as IDENTIFICACION, a.CDCnombre as NOMBRE, a.CDCcodigo as ID, Ppais, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">  as id_direccion, SNCBidPago_Origen, SNMedPago_Origen
		  from ClientesDetallistasCorp a
		 where a.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
	<cfquery name="rsCHK" datasource="#session.DSN#">
		select count(1) as resultado
		  from TEStransferenciaP
		 where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tesoreria.TESid#">
		   and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
	</cfquery>
</cfif>


<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	<cfquery datasource="#session.dsn#" name="data">
		select TESTPcuenta,
				TESTPid,
				Miso4217,
				TESTPtipo,
				a.Bid,
				TESTPcodigoTipo,
				TESTPcodigo,
				TESTPtipoCtaPropia,
				TESTPbanco,
				TESTPbancoID,
				TESTPdireccion,
				TESTPciudad,
				Ppais,
				TESTPtelefono,
				TESTPinstruccion,
				TESTPestado,
				UsucodigoAlta,
				TESTPfechaAlta,
				UsucodigoBaja,
				TESTPfechaBaja,
				a.BMUsucodigo,
				cb.CBcodigo, cb.CBdescripcion,
				a.ts_rversion,
                TESTPtipoDet
 		   from TEStransferenciaP a
			left join CuentasBancos cb
				on cb.CBid = a.CBid
		  where TESTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESTPid#">
		    and TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
            and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	</cfquery>
</cfif>

<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >

<cfquery name="rsLista" datasource="#session.DSN#">
	select 	TESTPid,
			TESid,
			TESTPcuenta as TESTPcuentab,
			Mnombre,
			a.Bid,
			TESTPcodigoTipo,
			case  TESTPcodigoTipo
				when  0 then 'Nacional'
				when  1 then 'ABA'
				when  2 then 'SWIFT'
				when  3 then 'IBAN'
				when 10 then 'Otro'
			end as tipoC,
			TESTPcodigo,
			TESTPbanco as TESTPbancob,
			case when TESTPestado = 1
				then <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#checked#">
				else <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#unchecked#">
			end as TESTPestadob,
			case when TESTPtipoCtaPropia = 1
				then <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#checked#">
				else <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#unchecked#">
			end as Propia,
			Pnombre,
			#LvarTipoId# as ID,
			'#form.TIPO#' as TIPO
	from TEStransferenciaP a
		left join Pais p
			on p.Ppais = a.Ppais
		inner join Monedas m
			on m.Miso4217 = a.Miso4217
			and m.Ecodigo = #session.Ecodigo#
	where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.tesoreria.TESid#">
		and #LvarTipoId# = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID#">
		and TESTPestado < 2
</cfquery>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Miso4217, Mcodigo, Mnombre
	from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre
</cfquery>

<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	<cfset CAMBIO = data.RecordCount>
</cfif>
<style type="text/css">
<!--
.SinBorde {
 	border:none;
}
-->
</style>


<cfif rsSocio.Ppais EQ "" and rsSocio.id_direccion NEQ "">
	<cfquery name="rsDir" datasource="#session.DSN#">
		select Ppais
		  from Direcciones
		 where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSocio.id_direccion#">
	</cfquery>
	<cfset rsSocio.Ppais = rsDir.Ppais>
</cfif>
<cfif rsSocio.Ppais EQ "">
	<cfset rsSocio.Ppais = "-1">
</cfif>

<cfquery name="rsPais" datasource="#session.DSN#">
	select p.Ppais, p.Pnombre
			, case when p.Ppais = '#rsSocio.Ppais#' then 0 else 1 end as orden
		  from Pais p
	 order by orden, Pnombre
</cfquery>

<cfquery name="rsBancos" datasource="#session.DSN#">
	select 	Bid,
			Bdescripcion,
			case when coalesce(rtrim(Bdireccion),' ')	= ' ' then '(Registrar en Bancos...)' else Bdireccion	end	as Bdireccion,
			case when coalesce(rtrim(Btelefon),' ')		= ' ' then '(Registrar en Bancos...)' else Btelefon		end	as Btelefon,
			case when coalesce(rtrim(BcodigoACH),' ')	= ' ' then '(Registrar en Bancos...)' else BcodigoACH	end	as BcodigoACH,
			case when coalesce(rtrim(Iaba),' ')			= ' ' then '(Registrar en Bancos...)' else Iaba			end	as Iaba,
			case when coalesce(rtrim(BcodigoSWIFT),' ')	= ' ' then '(Registrar en Bancos...)' else BcodigoSWIFT	end	as BcodigoSWIFT,
			case when coalesce(rtrim(BcodigoIBAN),' ')	= ' ' then '(Registrar en Bancos...)' else BcodigoIBAN	end	as BcodigoIBAN,
			case when coalesce(rtrim(BcodigoOtro),' ')	= ' ' then '(Registrar en Bancos...)' else BcodigoOtro	end	as BcodigoOtro
	  from Bancos
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	 order by Bdescripcion
</cfquery>

<script language="javascript">
	var Bcos = {
	<cfoutput query="rsBancos">
		<cfif rsBancos.currentRow GT 1>
			,
		</cfif>
			 B#rsBancos.Bid# : {des : '#JSstringFormat(rsBancos.Bdescripcion)#', dir : '#JSstringFormat(rsBancos.Bdireccion)#', tel : '#rsBancos.Btelefon#', ach : '#rsBancos.BcodigoACH#', aba: '#rsBancos.Iaba#', swift: '#rsBancos.BcodigoSWIFT#', iban:'#rsBancos.BcodigoIBAN#', otro:'#rsBancos.BcodigoOtro#'}
	</cfoutput>
			};

	function sbCambiarBco()
	{
		var LvarBid = document.form1.Bid.value;
		if (LvarBid == "")
		{
			document.form1.TESTPtipoCtaPropia.checked=false;
			document.form1.TESTPtipoCtaPropia.disabled=true;
			document.form1.TESTPbanco.disabled			= false;
			document.form1.TESTPdireccion.disabled		= false;
			document.form1.TESTPtelefono.disabled		= false;
			document.form1.TESTPcodigo.disabled			= false;
			return;
		}

		LvarBid = "B" + LvarBid;

		LvarBco = Bcos[LvarBid];
		document.form1.TESTPbanco.value		= LvarBco.des;
		document.form1.TESTPdireccion.value	= LvarBco.dir;
		document.form1.TESTPtelefono.value	= LvarBco.tel;
		document.form1.TESTPcodigo.value	= LvarBco.ach;
		//document.form1.TESTPcodigoTipo.selectedIndex = 0;

		//document.form1.TESTPtipoCtaPropia.checked	= false;
		document.form1.TESTPtipoCtaPropia.disabled	= (document.form1.TESTPcodigoTipo.selectedIndex > 0);

		document.form1.TESTPbanco.disabled			= true;
		document.form1.TESTPdireccion.disabled		= true;
		document.form1.TESTPtelefono.disabled		= true;
		document.form1.TESTPcodigo.disabled			= true;
	}

	function sbCambiarCodigoTipo()
	{
		var LvarBid = document.form1.Bid.value;
		if (LvarBid == "")
		{
			document.form1.TESTPtipoCtaPropia.checked=false;
			document.form1.TESTPtipoCtaPropia.disabled=true;
			return;
		}

		LvarBid = "B" + LvarBid;
		LvarBco = Bcos[LvarBid];

		var LvarTip = document.form1.TESTPcodigoTipo.value;
		if (LvarTip == "0")
		{
			document.form1.TESTPcodigo.value	= LvarBco.ach;
		}
		else if (LvarTip == "1")
			document.form1.TESTPcodigo.value	= LvarBco.aba;
		else if (LvarTip == "2")
			document.form1.TESTPcodigo.value	= LvarBco.swift;
		else if (LvarTip == "3")
			document.form1.TESTPcodigo.value	= LvarBco.iban;
		else
			document.form1.TESTPcodigo.value	= LvarBco.otro;

		document.form1.TESTPtipoCtaPropia.disabled=(LvarTip != "0");
	}

	function fnCambioCBidPago(f) {
		<!--- \sif\tesoreria\Solicitudes\ajaxTESMedioPago.cfm --->
		<!--- CBidPago --->
	    var ajaxRequest; // The variable that makes Ajax possible!
	    var vID_tipo_gasto = '';
	    var vmodoD = '';
		var CBidPago = f.CBidPago.value;
	    try {
	        // Opera 8.0+, Firefox, Safari
	        ajaxRequest = new XMLHttpRequest();
	    } catch (e) {
	        // Internet Explorer Browsers
	        try {
	            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
	        } catch (e) {
	            try {
	                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
	            } catch (e) {
	                // Something went wrong
	                alert("Your browser broke!");
	                return false;
	            }
	        }
	    }
	    ajaxRequest.open("GET", '/cfmx/sif/tesoreria/Solicitudes/ajaxTESMedioPago.cfm?modo=solPagoCxP&CBidPago='+CBidPago, false);
	    ajaxRequest.send(null);
	    document.getElementById("medioPago").innerHTML = ajaxRequest.responseText;
	}
</script>
<form action="InstruccionesPagos_sql.cfm" method="post" name="form1" id="form1" style="margin:0,0,0,0">
	<input name="ID" type="hidden" value="<cfoutput>#form.ID#</cfoutput>">
	<input name="TIPO" type="hidden" value="<cfoutput>#form.TIPO#</cfoutput>">
	<input name="TESTPid" type="hidden" value="<cfoutput>#data.TESTPid#</cfoutput>">
	<table summary="Tabla de entrada" border="0">
		<tr>
			<td class="subTitulo" colspan="5">
				<font size="+1">
			    Cuentas Bancarias pertenecientes al <cfoutput>#LvarTITULO#</cfoutput>
				</font>
			</td>
		</tr>

		<tr>
			<td colspan="5">
				<table>
					<tr>
						<td>
							<strong>Identificaci&oacute;n:&nbsp;</strong>
						</td>
						<td>
							<cfoutput>#rsSocio.identificacion#</cfoutput>
						</td>
					</tr>
					<tr>
						<td>
							<strong>Nombre:&nbsp;</strong>
						</td>
						<td>
							<cfoutput>#rsSocio.nombre#</cfoutput>
							<cfif isdefined("rsSocio.Ecodigo") and rsSocio.Ecodigo NEQ "">
								<strong>(Corresponde a la Empresa del Sistema Ecodigo=<cfoutput>#rsSocio.Ecodigo#</cfoutput>)</strong>
							</cfif>
							<cfif isdefined("rsSocio.DEid") and rsSocio.DEid NEQ "">
								<strong>(Corresponde a un Empleado de la Empresa)</strong>
							</cfif>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<cfif form.TIPO EQ "SN" OR form.TIPO EQ "SNC" OR form.TIPO EQ "BT">
			<tr><td colspan="3" align="center"><strong>Cuenta&nbsp;Origen</strong></td></tr>
			<tr><td colspan="3">&nbsp;</td></tr>
			<tr align="left">
				<td colspan="4" width="100%">
						<table cellpadding="2" cellspacing="0" border="0">
							<tr>
								<td valign="top" align="right"><strong><cf_translate key=LB_CuentaPago>Cuenta</cf_translate>:&nbsp;</strong></td>
								<td colspan="3">
									<cfset session.tesoreria.CBidPago = -1>
									<cfset LvarCBidPago = "">
									<!--- value="#rsForm.CBidPago#" --->
									<cf_cboTESCBid name="CBidPago" value="#rsSocio.SNCBidPago_Origen#" Ccompuesto="yes" Dcompuesto="yes" none="yes"
									cboTESMPcodigo="TESMPcodigo" onchange="return fnCambioCBidPago(this.form);GvarCambiado=true;" tabindex="1"
									CBid = "#LvarCBidPago#">

									<cfoutput>
										<cfif form.TIPO EQ "SN">
											<input type="hidden" name="SNcodigo" value="#rsSocio.SNcodigo#" tabindex="-1">
										<cfelseif form.TIPO EQ "SNC">
											<input type="hidden" name="SNcodigo" value="#rsSocio.SNcodigo#" tabindex="-1">
										<cfelseif form.TIPO EQ "BT">
											<input type="hidden" name="TESBid" value="#rsSocio.ID#" tabindex="-1">
										</cfif>
									</cfoutput>
								</td>
							</tr>
							<tr>
								<td valign="top" align="right"><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
								<td colspan="3" nowrap>
									<cfset session.tesoreria.TESMPcodigo = "">
									<div id="medioPago">
										<cf_cboTESMPcodigo name="TESMPcodigo" value="#rsSocio.SNMedPago_Origen#" CBid="CBidPago" CBidValue="" onChange="GvarCambiado=true; sbTESMPcodigoChange(this);">
									</div>
								</td>
							</tr>
						</table>
				</td>
			</tr>
		</cfif>

		<tr><td colspan="3" align="center"><strong>Cuenta&nbsp;Destino</strong></td></tr>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr align="left">
			<td colspan="4" width="125%">
				<!--- <fieldset> <legend><strong>Cuenta&nbsp;Destino</strong></legend> --->
					<table cellpadding="2" cellspacing="0" border="0">
						<tr>
							<td align="right" nowrap><strong>Cuenta&nbsp;Bancaria:&nbsp;</strong></td>
							<td colspan="2">
								<input name="TESTPcuentab"  type="text" size="60" maxlength="100" tabindex="1"
									value="<cfif isdefined("data") and  data.recordcount eq 1><cfoutput>#data.TESTPcuenta#</cfoutput></cfif>">							</td>
						</tr>
					<cfif data.CBcodigo NEQ "">
						<tr>
							<td align="right" nowrap><strong>Corresponde a:&nbsp;</strong></td>
							<td colspan="3">
								<cfoutput>
								<strong>#data.CBcodigo# - #data.CBdescripcion#</strong>
								</cfoutput>
								(Ir al módulo de Bancos para darle mantenimiento a la cuenta: <a href="/cfmx/sif/mb/catalogos/BancosLista.cfm"><font style="font-weight:bolder; text-decoration:underline; color:#0033FF;" >Bancos</font></a>)
							</td>
						</tr>
					</cfif>
						<tr>
							<td align="right" nowrap><strong>Moneda:</strong></td>
							<td colspan="1">
								<select name="Miso4217" tabindex="1">
									<cfoutput query="rsMonedas">
										<option value="#rsMonedas.Miso4217#" <cfif rsMonedas.Miso4217 EQ data.Miso4217>selected</cfif>>#rsMonedas.Mnombre#</option>
									</cfoutput>
								</select>
							</td>
							<td align="right">
								<strong>Tipo:</strong>
							</td>
							<td align="left" nowrap>
								<select name="TESTPtipo" tabindex="1">
									<option value=""></option>
									<option value="1" <cfif data.TESTPtipo EQ "1">selected</cfif>>Cuenta Corriente</option>
									<option value="2" <cfif data.TESTPtipo EQ "2">selected</cfif>>Cuenta Ahorros</option>
								</select>
                                <input type="text" name="TESTPtipoDet" id="TESTPtipoDet" size="10" value="<cfif isdefined("data.TESTPtipoDet") and  len(trim(data.TESTPtipoDet)) gt 0><cfoutput>#data.TESTPtipoDet#</cfoutput></cfif>" />
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Banco:</strong></td>
							<td colspan="2">
								<select name="Bid" tabindex="1" onchange="sbCambiarBco();">
									<option value="">(Escoger Banco para Transferencias Interbancarias Nacionales)</option>
									<cfoutput query="rsBancos">
										<option value="#rsBancos.Bid#" <cfif rsBancos.Bid EQ data.Bid>selected</cfif>>#rsBancos.Bdescripcion#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>C&oacute;digo&nbsp;Interbancario:</strong></td>
							<td>
								<select name="TESTPcodigoTipo" tabindex="1" onchange="sbCambiarCodigoTipo();">
									<option value="0" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 0>selected</cfif>>Nacional</option>
									<option value="1" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 1>selected</cfif>>ABA</option>
									<option value="2" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 2>selected</cfif>>SWIFT</option>
									<option value="3" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 3>selected</cfif>>IBAN</option>
									<option value="10" <cfif isdefined("data") and  data.TESTPcodigoTipo EQ 10>selected</cfif>>Especial</option>
								</select>
								<input name="TESTPcodigo"  type="text" size="40" maxlength="100" tabindex="1"
									value="<cfif isdefined("data") and len(trim(data.TESTPcodigo))><cfoutput>#data.TESTPcodigo#</cfoutput></cfif>">
							</td>
							<td align="right">
								<input type="checkbox" name="TESTPtipoCtaPropia" value="1" <cfif isdefined("data") and  data.TESTPtipoCtaPropia EQ 1>checked</cfif>>
							</td>
							<td>
								<strong>Cuenta Propia dentro del mismo Banco de Pago</strong>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Nombre&nbsp;del&nbsp;Banco:&nbsp;</strong></td>
							<td colspan="3">
								<input name="TESTPbanco" type="text" size="100" maxlength="100" tabindex="1"
									value="<cfif isdefined("data") and len(trim(data.TESTPbanco))><cfoutput>#data.TESTPbanco#</cfoutput></cfif>" >							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Banco&nbsp;ID:</strong></td>
							<td colspan="3">
								<input name="TESTPbancoID" type="text" size="50" maxlength="50" tabindex="1"
									value="<cfif isdefined("data") and len(trim(data.TESTPbancoID))><cfoutput>#data.TESTPbancoID#</cfoutput></cfif>" >							</td>
						</tr>
						<tr>
							<td rowspan="3" align="right" nowrap><strong>Direcci&oacute;n:&nbsp;</strong></td>
							<td rowspan="3">
								<textarea name="TESTPdireccion" rows="5" cols="50" tabindex="1"><cfif isdefined("data") and len(trim(data.TESTPdireccion))><cfoutput>#data.TESTPdireccion#</cfoutput></cfif></textarea>
							</td>
							<td align="right"><strong>Ciudad:&nbsp;</strong></td>
							<td>
								<input name="TESTPciudad" type="text" size="20" maxlength="100" tabindex="1"
									value="<cfif isdefined("data") and len(trim(data.TESTPciudad))><cfoutput>#data.TESTPciudad#</cfoutput></cfif>" />
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Pa&iacute;s:&nbsp;</strong></td>
							<td>
								<select name="Ppais" tabindex="1">
									<option value=""></option>
									<cfoutput query="rsPais">
										<option value="#rsPais.Ppais#" <cfif rsPais.Ppais EQ data.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
									</cfoutput>
								</select>
							</td>
						</tr>
						<tr>
							<td align="right"><strong>Tel&eacute;fono:&nbsp;</strong></td>
							<td>
								<input name="TESTPtelefono"  type="text" size="13" maxlength="100" tabindex="1"
										value="<cfif isdefined("data") and len(trim(data.TESTPtelefono))><cfoutput>#data.TESTPtelefono#</cfoutput></cfif>">										</td>
						</tr>

						<tr>
							<td align="right" nowrap><strong>Instrucciones:&nbsp;</strong></td>
							<td colspan="3"><textarea name="TESTPinstruccion" style="width:100%" tabindex="1"><cfif isdefined("data") and len(trim(data.TESTPinstruccion))><cfoutput>#data.TESTPinstruccion#</cfoutput></cfif></textarea></td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Default:</strong>&nbsp;</td>
							<td colspan="3">
								<input name="chkTESTPestado" tabindex="1"
									<cfif rsCHK.resultado EQ 0 or (rsCHK.resultado EQ 1 and CAMBIO) or (data.TESTPestado eq 1)>checked disabled</cfif>
									value="1" type="checkbox" >
								<cfif rsCHK.resultado EQ 0 or (rsCHK.resultado EQ 1 and CAMBIO) or (data.TESTPestado eq 1)>
									<input type="hidden" name="chkTESTPestado" value="1">
								</cfif>							</td>
						</tr>
				</table>
				<!--- </fieldset> --->

			</td>
		</tr>
		<tr>
			<td class="formButtons" colspan="5">
				<cfif isdefined("data") and data.RecordCount>
					<cfif data.CBcodigo NEQ "" AND data.TESTPcodigoTipo EQ "0">
					<cf_botones modo='CAMBIO' include="IrLista" exclude="cambio,baja" includevalues="Ir a Lista" tabindex="1">
					<cfelse>
					<cf_botones modo='CAMBIO' include="IrLista" includevalues="Ir a Lista" tabindex="1">
					</cfif>
				<cfelse>
					<cf_botones modo='ALTA' include="IrLista" includevalues="Ir a Lista" tabindex="1">
				</cfif>
			</td>
		</tr>
  </table>
	<cfoutput>
	<cfset ts = "">
	<cfif isdefined("form.TESTPid")	and len(trim(form.TESTPid))>
	  <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
	  </cfinvoke>
	  <input type="hidden" name="ts_rversion" value="<cfif CAMBIO>#ts#</cfif>" size="32">
	</cfif>
	</cfoutput>
</form>
<fieldset><legend><strong>Lista Cuentas Destino</strong></legend>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
	<tr>
		<td width="100%">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
				query="#rsLista#"
				desplegar="Pnombre, TESTPbancob, tipoC, Propia, TESTPcuentab, Mnombre, TESTPestadob"
				etiquetas="Pais, Banco, Tipo, Propia, Cuenta, Moneda, Default"
				formatos="S,S,S,S,S,S,S"
				ajustar="yes"
				showEmptyListMsg="yes"
				align="left,left,left,left,left,left,left"
				ira="InstruccionesPagos.cfm"
				form_method="get"
				keys="TESTPid, ID, TIPO"
				usaAjax="false"
				PageIndex="2"
				linearoja="TESTPcodigoTipo EQ 0 and Bid EQ ''"
			/>
		</td>
	</tr>
</table>
</fieldset>
<font color="##FF0000">(*) Debe indicar Banco para Códigos de Banco Nacional</font>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	function validaform()
	{
		var esBco = objForm.Bid.getValue() != "";
		var Extranjero = objForm.TESTPcodigoTipo.getValue() != 0;

		//objForm.Bid.getValue() != '' && objForm.TESTPcodigoTipo.getValue() != 0
		objForm.Bid.required = (!Extranjero && !esBco);
		objForm.Bid.description="Referencia a Bancos cuando es Código Nacional";

		objForm.TESTPcuentab.required = true;
		objForm.TESTPcuentab.description="Cuenta Bancaria";
		objForm.Miso4217.required = true;
		objForm.Miso4217.description="Moneda";
		objForm.TESTPcodigo.required = true;
		objForm.TESTPcodigo.description="Código Banco";
		objForm.TESTPbanco.required = true;
		objForm.TESTPbanco.description="Nombre del Banco";
		objForm.TESTPdireccion.required = true;
		objForm.TESTPdireccion.description="Dirección";
		objForm.TESTPciudad.required = Extranjero;
		objForm.TESTPciudad.description="Ciudad";
		objForm.Ppais.required = Extranjero;
		objForm.Ppais.description="Pais";
		objForm.TESTPtelefono.required = Extranjero;
		objForm.TESTPtelefono.description="Teléfono";
		objForm.TESTPtipo.required = form1.TESTPtipoCtaPropia.checked;
		objForm.TESTPtipo.description = "Tipo cuando es Cuenta Propia";
	}

	function NOvalidaform()
	{
		objForm.TESTPcuentab.required = false;
		objForm.Miso4217.required = false;
		objForm.TESTPcodigo.required = false;
		objForm.TESTPbanco.required = false;
		objForm.TESTPdireccion.required = false;
		objForm.TESTPciudad.required = false;
		objForm.TESTPtelefono.required = false;
	}

	function funcAlta()
	{
		validaform();
	}
	function funcCambio()
	{
		validaform();
	}

	function funcIrLista()
		{
			NOvalidaform();
			location.href = 'InstruccionesPagos.cfm?TIPO=<cfoutput>#form.TIPO#</cfoutput>';
			return false;
		}
	document.form1.TESTPcuentab.focus();
	sbCambiarBco();
//-->
</script>