<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "START">
	<cfreturn>
</cfif>
<!---
	Autor Ing. Óscar Bonilla, MBA, 30-MAR-2011
	*
	* Implementa la condición SQL para una lista de valores aunque sean muchos valores (SQL tiene una limitación en la 
	*	cantidad de valores dentro de un IN (lista_valores).
	* Por default los valores son numéricos. El cfsqltype son los del <cfqueryparam>
	* Esta función es muy util, por ejemplo, para procesar masivamente todos los chkBoxes escogidos en el form.
	*
	* Utilización:
	*	<CF_whereInList column="CAMPO" valueList="1,2,3,..." cfSQLtype="cf_sql_integer">
	*		genera: (CAMPO in (1,2,3) OR CAMPO in (...))
	* Si el campo es STRING (por ejemplo cfSQLtype="cf_sql_char"), los valores no deben enviarse entre apóstrofes
	*
--->
<cfparam name="attributes.name"		default="TESRPTCid">
<cfparam name="attributes.value"	default="">
<cfparam name="attributes.TR"		default="">
<cfparam name="attributes.tabindex"	default="">
<!--- Permite interactual con tag cf_cuentas --->
<cfparam name="request.cf_conceptoPago"			default="#structNew()#">
<cfparam name="request.cf_conceptoPago.names"	default="">
<cfif not listfindnocase(request.cf_conceptoPago.names, attributes.name)>
	<cfthrow message="No se ha definido el attributes.cf_conceptoPago='#attributes.name#' en algún tag de cuentas">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select count(1) as cant
	  from TESRPTcuentas
	 where Ecodigo	= #session.Ecodigo#
</cfquery>
</cfsilent>
<cfif rsSQL.cant EQ 0>
	<script language="javascript">
	<cfoutput>
		function cf_conceptoPago#attributes.name#_verif()
		{
			return true;
		}
	</cfoutput>
	</script>
	<cfexit>
</cfif>

<cfparam name="session.cf_conceptoPago"				default="#structNew()#">
<cfparam name="session.cf_conceptoPago.TESRPTCid"	default="-1">
<cfparam name="session.cf_conceptoPago.SNid"		default="">
<cfparam name="session.cf_conceptoPago.CDCcodigo" 	default="">
<cfparam name="session.cf_conceptoPago.TESBid"		default="">

<cfset LvarSelected_SN	= "">
<cfset LvarSelected_TES	= "">
<cfset LvarSelected_POS	= "">
<cfset LvarSelected_BCO	= "">
<cfif attributes.CFcuenta EQ "">
	<cfset LvarDisabled_Escoger	= "S">
	<cfset LvarDisabled_N_A		= "N">
	<cfset LvarDisabled_Datos	= "S">
<cfelse>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cant
		  from CFinanciera cf
		  	inner join TESRPTcuentas tc
				 on tc.Ecodigo = cf.Ecodigo
				and cf.CFformato like tc.CFmascara
		 where cf.Ecodigo	= #session.Ecodigo#
		   and cf.CFcuenta	= #attributes.CFcuenta#
	</cfquery>
	<cfif rsSQL.cant EQ 0>
		<cfset LvarDisabled_Escoger	= "S">
		<cfset LvarDisabled_N_A		= "N">
		<cfset LvarDisabled_Datos	= "S">
	<cfelse>
		<cfset LvarDisabled_Escoger	= "N">
		<cfset LvarDisabled_N_A		= "N">
		<cfset LvarDisabled_Datos	= "N">
	</cfif>
</cfif>


<cfif attributes.value NEQ "">
	<cfset LvarTESRPTCid	= attributes.value>
<cfelse>
	<cfset LvarTESRPTCid	= session.cf_conceptoPago.TESRPTCid>
</cfif>

<!--- Inicializa cuando se envía datos MODO = CAMBIO --->
<cfif isdefined("attributes.SNid") 			AND attributes.SNid NEQ "" 		and attributes.value NEQ "">
	<cfset LvarActual		= true>
	<cfset LvarBtipo		= "S">
	<cfset LvarBid			= attributes.SNid>
	<cfset LvarSelected_SN	= "selected">
<cfelseif isdefined("attributes.TESBid") 	AND attributes.TESBid NEQ "" 	and attributes.value NEQ "">
	<cfset LvarActual		= true>
	<cfset LvarBtipo 		= "T">
	<cfset LvarBid			= attributes.TESBid>
	<cfset LvarSelected_TES	= "selected">
<cfelseif isdefined("attributes.CDCcodigo") AND attributes.CDCcodigo NEQ "" and attributes.value NEQ "">
	<cfset LvarActual		= true>
	<cfset LvarBtipo 		= "P">
	<cfset LvarBid			= attributes.CDCcodigo>
	<cfset LvarSelected_POS	= "selected">

<!--- Inicializa con ultimo cuando no se envía datos MODO = ALTA --->
<cfelseIF isdefined("attributes.SNid")		AND session.cf_conceptoPago.SNid NEQ "">
	<cfset LvarActual		= false>
	<cfset LvarBtipo		= "S">
	<cfset LvarBid			= session.cf_conceptoPago.SNid>
	<cfset LvarSelected_SN	= "selected">
	<cfset session.cf_conceptoPago.TESBid		= "">
	<cfset session.cf_conceptoPago.CDCcodigo 	= "">
<cfelseif isdefined("attributes.TESBid") 	AND session.cf_conceptoPago.TESBid NEQ "">
	<cfset LvarActual		= false>
	<cfset LvarBtipo		= "T">
	<cfset LvarBid			= session.cf_conceptoPago.TESBid>
	<cfset LvarSelected_TES	= "selected">
	<cfset session.cf_conceptoPago.SNid			= "">
	<cfset session.cf_conceptoPago.CDCcodigo 	= "">
<cfelseif isdefined("attributes.CDCcodigo") AND session.cf_conceptoPago.CDCcodigo NEQ "">
	<cfset LvarActual		= false>
	<cfset LvarBtipo		= "P">
	<cfset LvarBid			= session.cf_conceptoPago.CDCcodigo>
	<cfset LvarSelected_POS	= "selected">
	<cfset session.cf_conceptoPago.SNid			= "">
	<cfset session.cf_conceptoPago.TESBid		= "">

<!--- Inicializa en blanco --->
<cfelse>
	<cfset LvarActual	= false>
	<cfset LvarBtipo	= "">
	<cfset LvarBid		= "">
	<cfset LvarBident	= "">
	<cfset LvarBnombre	= "">
</cfif>

<!--- Obtiene beneficiario enviado o ultimo guardado --->
<cfif LvarBtipo EQ "S">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select SNid as Bid, SNidentificacion as Bident, SNnombre as Bnombre
		  from SNegocios
		 where Ecodigo 	= #session.Ecodigo#
		   and SNid		= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarBid#" voidNull>
	</cfquery>
	<cfset LvarBtipo	= "S">
	<cfset LvarBid		= rsSQL.Bid>
	<cfset LvarBident	= rsSQL.Bident>
	<cfset LvarBnombre	= rsSQL.Bnombre>
<cfelseif LvarBtipo EQ "T">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESBid as Bid, TESBeneficiarioId as Bident, TESBeneficiario as Bnombre
		  from TESbeneficiario
		 where CEcodigo 			= #session.CEcodigo#
		   and TESBid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarBid#">
	</cfquery>
	<cfset LvarBtipo	= "T">
	<cfset LvarBid		= rsSQL.Bid>
	<cfset LvarBident	= rsSQL.Bident>
	<cfset LvarBnombre	= rsSQL.Bnombre>
<cfelseif LvarBtipo EQ "P">
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CDCcodigo as Bid, CDCidentificacion as Bident, CDCnombre as Bnombre
		  from ClientesDetallistasCorp
		 where CEcodigo 			= #session.CEcodigo#
		   and CDCcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarBid#">
	</cfquery>
	<cfset LvarBtipo	= "P">
	<cfset LvarBid		= rsSQL.Bid>
	<cfset LvarBident	= rsSQL.Bident>
	<cfset LvarBnombre	= rsSQL.Bnombre>
</cfif>

<cfoutput>
<cfif attributes.TR NEQ "">
	<tr>
	<cfif listlen(attributes.TR) EQ 1>
		<td colspan="#attributes.TR#">
	<cfelse>
		<td colspan="#listGetAt(attributes.TR,1)#">
		<td colspan="#listGetAt(attributes.TR,2)#">
	</cfif>
</cfif>
<table cellpadding="0" cellspacing="0">
	<tr>
		<td nowrap><strong>Pagos a Terceros:</strong>&nbsp;</td>
		<td nowrap>
			<!--- En este tag SNid y TESBid deben enviarse en blanco, es otra funcionalidad --->
			<cf_cboTESRPTCid name="#attributes.name#" value="#attributes.value#" SNid="" TESBid="" tabindex="#attributes.tabindex#" cf_CPdisabled="#LvarDisabled_Escoger#,#LvarDisabled_N_A#,#LvarDisabled_Datos#" onchange="cf_conceptoPago#attributes.name#_onchange();">
		</td>
	</tr>
	<tr>
		<td nowrap>
			<strong>Beneficiario</strong>
			<select name="Btipo#attributes.name#" id="Btipo#attributes.name#"
					onchange=
						"
							this.form.Bid#attributes.name#.value		= '';
							this.form.Bident#attributes.name#.value		= '';
							this.form.Bnombre#attributes.name#.value	= '';
						"
				<cfif attributes.tabindex NEQ "">
					tabindex="#attributes.tabindex#"
				</cfif>
				<cfif NOT LvarActual>
					disabled
				</cfif>
			>
			<cfset LvarTipos = "">
			<cfif isdefined("attributes.SNid")>
				<option value="S" #LvarSelected_SN#>SN</option>
				<cfset LvarTipos = LvarTipos & "S">
			</cfif>
			<cfif isdefined("attributes.TESBid")>
				<option value="T" #LvarSelected_TES#>TES</option>
				<cfset LvarTipos = LvarTipos & "T">
			</cfif>
			<cfif isdefined("attributes.CDCcodigo")>
				<option value="P" #LvarSelected_POS#>POS</option>
				<cfset LvarTipos = LvarTipos & "P">
			</cfif>
			</select><strong>:</strong>&nbsp;
		</td>
		<td nowrap valign="bottom">
			<input name="Bid#attributes.name#"		id="Bid#attributes.name#"		type="hidden" 
				<cfif LvarActual>
					value="#LvarBid#"
				</cfif>
				>
			<input name="Bident#attributes.name#"	id="Bident#attributes.name#"	type="text" size="18"
					onchange="cf_conceptoPago#attributes.name#_query();"
				<cfif attributes.tabindex NEQ "">
					tabindex="#attributes.tabindex#"
				</cfif>
				<cfif LvarActual>
					value="#LvarBident#"
				<cfelse>
					disabled value=""
				</cfif>
			><input name="Bnombre#attributes.name#" id="Bnombre#attributes.name#" 
				<cfif LvarActual>
					value="#LvarBnombre#" 
				</cfif>
					type="text" size="36" style="border:solid 1px ##CCCCCC;" readonly tabindex="-1"
			><a 
				tabindex="-1" 
				href="javascript:cf_conceptoPago#attributes.name#_conlis();" 
				<cfif NOT LvarActual>
					style="display:none"
				</cfif>
				id="Bimg#attributes.name#"><img src="/cfmx/sif/imagenes/Description.gif"
						alt="Lista de Beneficiarios: Socio Negocio, Tesorería o Punto de Venta"
						name="imagenSNid"
						width="18" height="14"
						border="0" align="absmiddle">
				</a>
				<iframe name="ifr_conceptoPago#attributes.name#" id="ifr_conceptoPago#attributes.name#" style="display:none"></iframe>
		</td>
	</tr>
</table>
<script language="javascript">
	// Determina si la cuenta contable requiere Pago a Terceros
	function cf_conceptoPago#attributes.name#_onchange()
	{
		var cboTESRPTCid = document.getElementById("#attributes.name#");
		var LvarDisabled = (cboTESRPTCid.value == "" || cboTESRPTCid.value == "-1")
		document.getElementById("Btipo#attributes.name#").disabled = LvarDisabled;
		document.getElementById("Bident#attributes.name#").disabled = LvarDisabled;
		document.getElementById("Bimg#attributes.name#").style.display = LvarDisabled ? "none":"";
	}
	function cf_conceptoPago#attributes.name#_init(CFcuenta)
	{
		//cf_conceptoPago#attributes.name#_initBack("");
		document.getElementById("ifr_conceptoPago#attributes.name#").src = "/cfmx/sif/Utiles/ConlisConceptoPago.cfm?OP=init&name=#attributes.name#&CFcuenta=" + CFcuenta;
	}
		function cf_conceptoPago#attributes.name#_initBack(tipo)
	{
		var cboTESRPTCid = document.getElementById("#attributes.name#");
		if(tipo=="OK")
		{
			cboTESRPTCid.options[0].disabled = false;
			cboTESRPTCid.options[1].disabled = false;
			cboTESRPTCid.options[1].text = "(N/A para este movimiento)";
		<cfif LvarTESRPTCid EQ "" or LvarTESRPTCid EQ "-1">
			for (var i = 2; i<cboTESRPTCid.options.length ; i++)
				cboTESRPTCid.options[i].disabled = false;
		<cfelse>
			for (var i = 2; i<cboTESRPTCid.options.length ; i++)
			{
				cboTESRPTCid.options[i].disabled = false;
				if (cboTESRPTCid.options[i].value == "#LvarTESRPTCid#")
					cboTESRPTCid.options[i].selected = true;
			}
			<cfif LvarBid NEQ "">
				document.getElementById("Btipo#attributes.name#").value			= "#LvarBtipo#";
				document.getElementById("Bid#attributes.name#").value			= "#LvarBid#";
				document.getElementById("Bident#attributes.name#").value		= "#LvarBident#";
				document.getElementById("Bnombre#attributes.name#").value		= "#LvarBnombre#";
				document.getElementById("Btipo#attributes.name#").disabled		= false;
				document.getElementById("Bident#attributes.name#").disabled		= false;
				document.getElementById("Bimg#attributes.name#").style.display	= "";
			</cfif>
		</cfif>
		}
		else
		{
			cboTESRPTCid.options[0].disabled = true;
			cboTESRPTCid.options[1].disabled = false;
			cboTESRPTCid.options[1].text = "(N/A para esta cuenta)";
			cboTESRPTCid.options[1].selected = true;
			for (var i = 2; i<cboTESRPTCid.options.length ; i++)
				cboTESRPTCid.options[i].disabled = true;
		}
	}

	// Llamada al CONLIS
	function cf_conceptoPago#attributes.name#_conlis()
	{
		var URLStr = "/cfmx/sif/Utiles/ConlisConceptoPago.cfm?OP=conlis&name=#attributes.name#&tipos=#LvarTipos#&tipo=" + document.getElementById("Btipo#attributes.name#").value;
		<!--- popUpWindow está definido en el tag de cuentas --->
		popUpWindow(URLStr, 250, 200, 650, 550);
	}

	function cf_conceptoPago#attributes.name#_query()
	{
		var LvarTipo = document.getElementById("Btipo#attributes.name#").value;
		var LvarIdent = document.getElementById("Bident#attributes.name#").value;

		document.getElementById("ifr_conceptoPago#attributes.name#").src = "/cfmx/sif/Utiles/ConlisConceptoPago.cfm?OP=query&name=#attributes.name#&tipo=" + LvarTipo + "&Bident=" + escape(LvarIdent);
	}

	function cf_conceptoPago#attributes.name#_queryBack(id, tipo, ident, nombre)
	{
		document.getElementById("Bid#attributes.name#").value		= id;
		if (tipo != "")
			document.getElementById("Btipo#attributes.name#").value	= tipo;
		document.getElementById("Bident#attributes.name#").value	= rtrim(ident);
		document.getElementById("Bnombre#attributes.name#").value	= rtrim(nombre);
	}
	
	function rtrim (str) 
	{
		var	ws = /\s/,
			i = str.length;
		while (ws.test(str.charAt(--i)));
		return str.slice(0, i + 1);
	}
	
	// Verificación del form
	function cf_conceptoPago#attributes.name#_verif(TIP)
	{
		var LvarMSG = "";
		if (document.getElementById("#attributes.name#").value == "-1")
			LvarMSG = "El campo Concepto de Pagos a Terceros es requerido";
		else if (document.getElementById("#attributes.name#").value != "")
		{
			if (document.getElementById("Bid#attributes.name#").value == "")
				LvarMSG = "El campo Beneficiario es requerido";

			if (TIP == "C" && LvarMSG == "")
			{
				return confirm ("El movimiento detalle es de 'Crédito', confirme que efectivamente corresponde a una compra o pago");
			}
		}

		if (LvarMSG != "")
		{
			alert (LvarMSG);
			return false;
		}

		return true;
	}
</script>
<cfif attributes.TR NEQ "">
	<cfif listlen(attributes.TR) EQ 1>
		</td>
	<cfelse>
		</td>
		</td>
	</cfif>
	</tr>
</cfif>
</cfoutput>
		