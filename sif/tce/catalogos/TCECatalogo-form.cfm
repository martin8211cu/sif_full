<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_CtaClienteExiste" default="El Código de Cuenta Interbancaria ya existe." returnvariable="LB_CtaClienteExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Bancos" default="Bancos" returnvariable="BTN_Bancos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Oficina" default="Oficina" returnvariable="MSG_Oficina" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Moneda" default="Moneda" returnvariable="MSG_Moneda" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Cuenta" default="Cuenta" returnvariable="MSG_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Descripcion" default="Descripción" returnvariable="MSG_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_NumTarj" default="Numero de Tarjeta" returnvariable="MSG_NumTarj" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_TipoTarjeta" default="Tipo de Tarjeta" returnvariable="MSG_TipoTarjeta" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Status" default="Status" returnvariable="MSG_Status" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_DEid" default="Titular" returnvariable="MSG_DEid" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>

<cfinvoke key="MSG_Ccuentacom" default="Cuenta Comision" returnvariable="MSG_Ccuentacom" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Ccuentaint" default="Cuenta Int. No Cobrados" returnvariable="MSG_Ccuentaint" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Ccuentaintpag" default="Cuenta Int. No Pagados" returnvariable="MSG_Ccuentaintpag" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_fechaIV" default="Fecha de Inicio Vigencia" returnvariable="MSG_fechaIV" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_fechaCorte" default="Fecha de Corte" returnvariable="MSG_fechaCorte" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_fechaPago" default="Fecha de Pago" returnvariable="MSG_fechaPago" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_fechaVencimiento" default="Fecha de Vencimiento" returnvariable="MSG_fechaVencimiento" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_MarcaTarjeta" default="Marca de Tarjeta" returnvariable="MSG_MarcaTarjeta" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_titularNombre" default="Nombre del titular" returnvariable="MSG_titularNombre" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_titularIdentificacion" default="Identificacion del titular" returnvariable="MSG_titularIdentificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<!--- FIN DE VARIBALES DE TRADUCCION --->

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
 --->

<cfset LvarPagina = "TCECatalogo-form.cfm">


<cfif isdefined("Form.Cambio")>  
  <cfset modo="CAMBIO">
<cfelse>  
  <cfif not isdefined("Form.modo")>    
    <cfset modo="ALTA">
  <cfelseif Form.modo EQ "CAMBIO">
    <cfset modo="CAMBIO">
  <cfelse>
    <cfset modo="ALTA">
  </cfif>  
</cfif>

<!--- Para cuando viene de la nueva lista de Cuentas de Mayor para agregar directamente subcuentas sin pasar por el mantenimiento de Cuentas de Mayor --->
<cfif isdefined("form.modo2")>
	<cfset modo = form.modo2>
</cfif>

<cfif modo eq 'Alta'>
	<cfquery name="rsCuentaBancaria" datasource="#Session.DSN#">
		select -1 as Mcodigo from dual
	</cfquery>
</cfif>
<cfset LvarBoolCuentaPagoTCE = 'FALSE'>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.CBid") and Len(Trim(Form.CBid)) GT 0 and isdefined("Form.CBTCid") and Len(Trim(Form.CBTCid)) GT 0 >

	<cfquery name="rsCuentaBancaria" datasource="#Session.DSN#">
		select CBTCid, CBid, Bid, Ecodigo, Ocodigo, 
		Mcodigo, Ccuenta, CBcodigo, CBdescripcion, 
		Ccuentacom, Ccuentaint, CBcc, CBTcodigo, 
		CBdato1, ts_rversion, EIid
		,CBidioma,CBclave,CBcodigoext,CcuentaintPag,
		ltrim(rtrim(CFormatoTCE)) as CFormatoTCE,
		case  
			when CFormatoTCE IS not null then 'TRUE'
			else 'FALSE'
		end as usarCPagoTCE
		from CuentasBancos
		where Ecodigo = #Session.Ecodigo#
          and CBTCid = 	<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
		  and CBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CBid#">
		  and Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.Bid#">
          and CBesTCE = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="1">				
	</cfquery>
	
	<cfset LvarBoolCuentaPagoTCE = #rsCuentaBancaria.usarCPagoTCE#>

	<cfquery name="rsCuentaPagarTCE" dbtype="query">
		select '' as CFdescripcion, '' as CFcuenta, CFormatoTCE as CFformato, '' as Ccuenta 
		from rsCuentaBancaria 
	</cfquery>
	
	<cfif Len(Trim(rsCuentaBancaria.Ccuentacom)) GT 0>
		<cfset CuentaComision = #rsCuentaBancaria.Ccuentacom#>	
		<cfquery name="rsCuentaComision" datasource="#Session.DSN#">
			select Ccuenta, Cdescripcion, Cformato from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaComision#">
		</cfquery>
	</cfif>

	<cfif Len(Trim(rsCuentaBancaria.Ccuentaint)) GT 0>
		<cfset CuentaIntNoCob = rsCuentaBancaria.Ccuentaint>
		<cfquery name="rsCuentaIntNoCob" datasource="#Session.DSN#">
			select Ccuenta, Cdescripcion, Cformato from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaIntNoCob#">
		</cfquery>
	</cfif>
	
	<cfif Len(Trim(rsCuentaBancaria.CcuentaintPag)) GT 0>
		<cfset CuentaIntNoPag = rsCuentaBancaria.CcuentaintPag>
		<cfquery name="rsCuentaIntNoPag" datasource="#Session.DSN#">
			select Ccuenta, Cdescripcion, Cformato from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaIntNoPag#">
		</cfquery>
	</cfif>

    <cfquery name="rsMonedas" datasource="#session.DSN#">
        Select cb.Mcodigo, m.Mnombre
        from CuentasBancos cb
        inner join Monedas m
        on m.Mcodigo = cb.Mcodigo
        where cb.Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
          and cb.CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
          and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          and m.Mcodigo <> #rsMonedaLoc.Mcodigo#
    </cfquery>

</cfif>

<cfquery name="rsBancoDes" datasource="#Session.DSN#">
	select Bdescripcion from Bancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.DSN#">
	select Ocodigo, Odescripcion from Oficinas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select Ccuenta, Cformato, Cdescripcion,
		case when
			(	
				select count(1)
				  from CFinanciera cf
				 	inner join CFInactivas i
						on i.CFcuenta = cf.CFcuenta
				 where cf.Ccuenta = CContables.Ccuenta
				   and <cf_dbfunction name="today"> between CFIdesde and CFIhasta
			) +
			(
				select count(1)
				  from CCInactivas
				 where Ccuenta = CContables.Ccuenta
				   and <cf_dbfunction name="today"> between CCIdesde and CCIhasta
			) > 0 then '(ATTN: CTA INACTIVA)'
		end as Inactiva
	 from CContables 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Cmovimiento = 'S' 
	  and Mcodigo in (6, 11)
	order by Ccuenta
</cfquery>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(CBcc) as CBcc
	from CuentasBancos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA' >
		and CBid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBid#">
	</cfif>
    	and CBesTCE = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
</cfquery>

<!--- Tarjetas de Credito --->
<cf_dbfunction name="concat" args="d.DEnombre +' '+d.DEapellido1 + ' ' + d.DEapellido2 " delimiters="+" returnvariable="LvarNombre">
<cfquery name="rsTarjetaCredito" datasource="#session.DSN#">
	select CBTCid, CBTCDescripcion, CBTTid, CBSTid, CBTNumTarjeta, a.DEid,
    CBTCfechainico, CBTCfechacorte, CBTCfechacancelacion, CBTCfechapago, 
    CBTCfechavencimiento, EIid,a.ts_rversion, CBTMid
    <cfif modo neq 'ALTA' >
    ,#preservesinglequotes(LvarNombre)# as DEnombrecompleto
    ,d.DEidentificacion 
    </cfif>
	from CBTarjetaCredito a 
     left outer join DatosEmpleado d
       on a.DEid = d.DEid
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA' >
		and CBTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CBTCid#">
	</cfif>
</cfquery>
<!---Tipos de Tarjeta --->
<cfquery name="rsTipoTarjeta" datasource="#session.DSN#">
	select CBTTid, CBTTDescripcion
	from CBTipoTarjetaCredito
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Status de Tarjeta --->
<cfquery name="rsStatusTarjeta" datasource="#session.DSN#">
	select CBSTDescripcion, CBSTid
	from CBStatusTarjetaCredito
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    <cfif modo eq 'ALTA' >
    	and CBSTActiva = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    </cfif>
</cfquery>

<!--- Marcas de Tarjeta --->
<cfquery name="rsMarcaTarjeta" datasource="#session.DSN#">
	select CBTMid, CBTMarca, CBTMascara
	from CBTMarcas
</cfquery>

<cfquery name="rsMascaraTarjeta" datasource="#session.DSN#">
	select CBTMid, CBTMarca, CBTMascara
	from CBTMarcas
    <cfif modo neq 'ALTA' >
		where CBTMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTarjetaCredito.CBTMid#">
	</cfif>
</cfquery>

<!---Moneda Local--->
<cfquery name="rsMonedaLoc" datasource="#session.DSN#">
	select e.Mcodigo, m.Mnombre, m.Miso4217 
    from Empresas e
    inner join Monedas m
    on m.Mcodigo = e.Mcodigo 
    where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<!--- Busca Parametro para la Moneda Extranjera en las TCE--->
<cfquery name="rsParametroTCE" datasource="#session.dsn#">
	select Pvalor
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Pcodigo = 200040
</cfquery>
<cfset MisoExt = "X">
<cfif isdefined("rsParametroTCE") and len(trim(rsParametroTCE.Pvalor)) GT 0>
	<cfset MisoExt = rsParametroTCE.Pvalor>
</cfif>

<!---Moneda Extranjera--->
<cfquery name="rsMonedaExt" datasource="#session.DSN#">
	select Mcodigo, Mnombre 
    from Monedas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MisoExt#">
</cfquery>

<cfquery name="rsMonedaExc" datasource="#session.DSN#">
	select Mcodigo, Mnombre 
    from Monedas 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Mcodigo not in (#rsMonedaLoc.Mcodigo# <cfif len(rsMonedaExt.Mcodigo) GT 0>, #rsMonedaExt.Mcodigo#</cfif>)
</cfquery>

<cfquery name="rsScriptsBancos" datasource="sifcontrol">
	select EIid,rtrim(EIcodigo) as EIcodigo, EIdescripcion
	from EImportador
	where EImodulo = 'sif.tce'
</cfquery>
    
<script src="../../js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<script language="JavaScript">
<!---Redireccion Bancos o TCEBancos (Tarjetas de Credito)--->
	function Bancos1(data) {
		document.form1.action='TCEBancos.cfm';
		document.form1.Bid.value = "<cfoutput>#Form.Bid#</cfoutput>";		
		document.form1.submit();
		return false;
	}
	
	function codigos(obj){
		if (obj.value != "") {
			var dato    = obj.value;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.CBcc#</cfoutput>';
				if (dato == temp){
					alert('<cfoutput>#LB_CtaClienteExiste#</cfoutput>');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}
</script>
<!--- VERIFICA PARAMETRO PARA MOSTRAR CLAVE Y CODIGO UTILIZADO EN PROCESO DE INTERFAZ CON SAP (OE) --->
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2010" default="" returnvariable="InterfazCatalogos"/>

<!---Redireccion Bancos o TCEBancos (Tarjetas de Credito)--->
<form method="post" name="form1"  id="form1" onsubmit="javascript:setDescripcion();" action="TCECatalogo-SQL.cfm<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>">
 
	<table align="center" cellpadding="0" cellspacing="0" border="0">
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Banco" XmlFile="/sif/rh/generales.xml">Banco</cf_translate>:&nbsp;</td>
			<td>
				<input name="textfield" readonly type="text" size="50" maxlength="50" 
				value="<cfoutput>#rsBancoDes.Bdescripcion#</cfoutput>" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Oficina" XmlFile="/sif/rh/generales.xml">Oficina</cf_translate>:&nbsp;</td>
			<td>
				<select name="Ocodigo" tabindex="1" >
					<cfoutput query="rsOficinas"> 
						<option value="#rsOficinas.Ocodigo#" 
							<cfif modo NEQ "ALTA" and (rsOficinas.Ocodigo EQ rsCuentaBancaria.Ocodigo)>selected</cfif>>
							#rsOficinas.Odescripcion#
						</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Cuenta" XmlFile="/sif/rh/generales.xml">Cuenta</cf_translate>:&nbsp;</td>
			<td>
				<select name="Ccuenta" tabindex="1">
					<cfoutput query="rsCuentas"> 
						<option value="#rsCuentas.Ccuenta#" 
							<cfif modo NEQ "ALTA" and (rsCuentas.Ccuenta EQ rsCuentaBancaria.Ccuenta)>selected</cfif>>
							#rsCuentas.Cformato# : #rsCuentas.Cdescripcion# #rsCuentas.Inactiva#
						</option>
					</cfoutput> 
				</select>
			</td>
		</tr>
		

		<cfoutput>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CuentaComision">Cuenta Comisi&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA" and isDefined("CuentaComision") and Len(Trim(CuentaComision)) GT 0>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaComision#" auxiliares="N" movimiento="S" 
					ccuenta="Ccuentacom" cdescripcion="Cdescripcioncom" descwidth="20" cformato="Cformatocom">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentacom" 
					cdescripcion="Cdescripcioncom" descwidth="20" cformato="Cformatocom">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CuentaIntNoCobrados">Cuenta Int. No Cobrados</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA" and isDefined("CuentaIntNoCob") and Len(Trim(CuentaIntNoCob)) GT 0>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaIntNoCob#" auxiliares="N" movimiento="S" 
					ccuenta="Ccuentaint" cdescripcion="Cdescripcionint" descwidth="20" cformato="Cformatoint">
				<cfelse>
					<cf_cuentas tabindex="3" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentaint" 
					cdescripcion="Cdescripcionint" descwidth="20" cformato="Cformatoint">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CuentaIntNoPagados">Cuenta Int. No Pagados</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA" and isDefined("CuentaIntNoPag") and Len(Trim(CuentaIntNoPag)) GT 0>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaIntNoPag#" auxiliares="N" movimiento="S" 
					ccuenta="Ccuentaintpag" cdescripcion="Cdescripcionintpag" descwidth="20" cformato="Cformatointpag">
				<cfelse>
					<cf_cuentas tabindex="3" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentaintpag" 
					cdescripcion="Cdescripcionintpag" descwidth="20" cformato="Cformatointpag">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">
				<label id="costoAl" style="font-style:normal; font-variant:normal; font-weight:normal;"><cf_translate key="LB_CuentaTCE" XmlFile="/sif/rh/generales.xml">Cuenta pago TCE</cf_translate>:&nbsp;</label>
			</td>
			<td valign="baseline">
				<input type="checkbox" tabindex="1" name="chkCuentaTCE" id="chkCuentaTCE" onClick="javascript: cambioCuentaTCE();" 
					<cfif (modo neq 'ALTA' and LvarBoolCuentaPagoTCE) >checked</cfif>>
			</td>
		</tr>
		
		<tr id="trCPagoTCE"  <cfif not LvarBoolCuentaPagoTCE > style="display: none" </cfif> valign="baseline"  >
			<td nowrap align="right">
				&nbsp; 
			</td>
			<td nowrap>
				<!--- <cfif modo EQ "ALTA">
							
						<cfelse>	
							<cfquery name="rsCformato" dbtype="query">
								select ccuenta, Cdescripcion2 as cdescripcion, Cformato from rsConceptos
							</cfquery>
							
						</cfif> --->
						<!--- hasta aqui --->
				<cfif LvarBoolCuentaPagoTCE>
					<cfquery name="rsCformato" dbtype="query">
						select CFdescripcion as Cdescripcion, CFcuenta, CFformato as Cformato, Ccuenta from rsCuentaPagarTCE
					</cfquery>
					<cf_cuentasanexo 
							auxiliares="S" 
							movimientos="N"
							conlis="S"
							ccuenta="ccuenta" 
							cdescripcion="CFdescripcion"
							cformato="CFformato" 
							conexion="#Session.DSN#"
							descwidth="20"
							form="form1"
							frame="frame1"
							query="#rsCformato#"
							comodin="?" tabindex="1">
				<cfelse>
					<cf_cuentasanexo 
							auxiliares="S" 
							movimiento="N"
							conlis="S"
							ccuenta="ccuenta" 
							descwidth="20"
							cdescripcion="CFdescripcion"
							cformato="CFformato"
							conexion="#Session.DSN#"
							form="form1"
							frame="frame1"
							comodin="?" tabindex="1">
				</cfif>
	
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/sif/rh/generales.xml">Descripción</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" tabindex="4" name="CBdescripcion" id="CBdescripcion" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsTarjetaCredito.CBTCDescripcion#</cfoutput></cfif>" 
				size="50" maxlength="80" onfocus="javascript:this.select();">
			</td>
		</tr>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_TipoTarjeta">Marca de Tarjeta</cf_translate>:&nbsp;</td>
			<td>
            	<select name="MarcaTarjeta" id="MarcaTarjeta" tabindex="4" onChange="javascript:setDescripcion();getMask();">
					<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/rh/generales.xml">Seleccione Uno</cf_translate>---</option>
					<cfloop query="rsMarcaTarjeta">
						<option value="#rsMarcaTarjeta.CBTMid#" 
						<cfif (MODO neq "ALTA") and (rsMarcaTarjeta.CBTMid eq rsTarjetaCredito.CBTMid)>selected</cfif>
						>#rsMarcaTarjeta.CBTMarca#
                        </option>
					</cfloop>
				</select> 
                <input type="hidden" name="SNmask"  id="SNmask" size="50" value="<cfif (MODO neq "ALTA")>#rsMascaraTarjeta.CBTMascara#</cfif>">              
			</td>
		</tr>
        <tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_NumeroTarjeta" XmlFile="/sif/rh/generales.xml">N&uacute;mero de Tarjeta</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" tabindex="4" name="CBTarjeta"  id="CBTarjeta"
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsTarjetaCredito.CBTNumTarjeta#</cfoutput></cfif>" 
				size="32" maxlength="20" onkeypress="javascript:setDescripcion();">
			</td>
		</tr>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_TipoTarjeta">Tipo de Tarjeta</cf_translate>:&nbsp;</td>
			<td>
				<select name="TipoTarjeta" tabindex="4">
					<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/rh/generales.xml">Seleccione Uno</cf_translate>---</option>
					<cfloop query="rsTipoTarjeta">
						<option value="#rsTipoTarjeta.CBTTid#" 
						<cfif (MODO neq "ALTA") and (rsTipoTarjeta.CBTTid eq rsTarjetaCredito.CBTTid)>selected</cfif>
						>#rsTipoTarjeta.CBTTDescripcion#</option>
					</cfloop>
				</select>
                
			</td>
		</tr>
        <tr>
			<td align="right" nowrap><cf_translate key="LB_Status">Status</cf_translate>:&nbsp;</td>
			<td>
				<select name="Status" tabindex="4">
					<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/rh/generales.xml">Seleccione Uno</cf_translate>---</option>
					<cfloop query="rsStatusTarjeta">
						<option value="#rsStatusTarjeta.CBSTid#" 
						<cfif (MODO neq "ALTA") and (rsStatusTarjeta.CBSTid eq rsTarjetaCredito.CBSTid)>selected</cfif>
						>#rsStatusTarjeta.CBSTDescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>
        <cfoutput> 
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Titular" XmlFile="/sif/rh/generales.xml">Titular</cf_translate>:&nbsp;</td>
			<td>             
              <!--- Variables de Traduccion --->
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="LB_ListaDeEmpleados"
                Default="Lista de Empleados"
                returnvariable="LB_ListaDeEmpleados"/>
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="LB_Identificacion"
                Default="Identificaci&oacute;n"
                returnvariable="LB_Identificacion"/>
            <cfinvoke component="sif.Componentes.Translate"
                method="Translate"
                Key="LB_Nombre"
                Default="Nombre"
                returnvariable="LB_Nombre"/>
                <cf_dbfunction name="now" returnvariable="hoy">
               <cfset ValuesArray=ArrayNew(1)>
				<cfif (modo neq "ALTA")>
                    <cfset ArrayAppend(ValuesArray,rsTarjetaCredito.DEid)>
                    <cfset ArrayAppend(ValuesArray,rsTarjetaCredito.DEidentificacion)>
                    <cfset ArrayAppend(ValuesArray,rsTarjetaCredito.DEnombrecompleto)>
                </cfif>
               <cf_conlis
                    Campos="DEid,DEidentificacion,DEnombrecompleto"
                    ValuesArray="#ValuesArray#"
                    Desplegables="N,S,S"
                    Modificables="N,S,N"
                    Size="0,10,40"
                    form="form1"
                    tabindex="1"
                    Title="#LB_ListaDeEmpleados#"
                    Tabla="DatosEmpleado b"
                    Columnas="b.DEid,
                              b.DEidentificacion as DEidentificacion,
                              {fn concat(b.DEnombre,{fn concat(' ',{fn concat(b.DEapellido1,{fn concat(' ',b.DEapellido2)})})})} as DEnombrecompleto,
                              case when (
                                        select count(1)
                                        from EmpleadoCFuncional cf
                                        where cf.DEid = b.DEid
                                          and  #hoy# between cf.ECFdesde and cf.ECFhasta) > 0 
                                    then 'Activo' 
                                    else 'Inactivo' 
                                end as descripcion,                                
                                case 
                                    when ((
                                        select count(1)
                                        from EmpleadoCFuncional cf
                                        where cf.DEid = b.DEid
                                          and cf.ECFencargado = 1
                                          and getdate() between cf.ECFdesde and cf.ECFhasta)) > 0 
                                    then 
                                        1
                                    else
                                        0
                                    end as encargado"
                    Filtro="Ecodigo =#session.ecodigo# order by DEidentificacion"
                    Desplegar="DEidentificacion,DEnombrecompleto"
                    Etiquetas="#LB_Identificacion#,#LB_Nombre#"
                    filtrar_por="b.DEidentificacion|{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(' ',b.DEnombre)})})})}"
                    filtrar_por_delimiters="|"
                    Formatos="S,S"
                    Align="left,left"
                    Asignar="DEid,DEidentificacion,DEnombrecompleto"
                    Asignarformatos="S,S,S"
                    MaxRowsQuery="200"
                    onblur="javascript:setDescripcion();"/>	
           	</td>		  
		</tr>
		</cfoutput>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_FechaVigencia">Fecha de Inicio Vigencia</cf_translate>:&nbsp;</td>
			<td>
            	<cfset LvarfechaIV = "">
            	<cfif (MODO neq "ALTA")>
	                <cfset LvarfechaIV = rsTarjetaCredito.CBTCfechainico>
                </cfif>
            	<cf_sifcalendario name="fechaIV" value="#DateFormat(LvarfechaIV,'DD/MM/YYYY')#" tabindex="1">                                				  
			</td>
		</tr>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_FechaCorte">Fecha de Corte</cf_translate>:&nbsp;</td>
			<td>
	                <cfset LvarfechaCorte = rsTarjetaCredito.CBTCfechacorte>
                    <select name="fechaCorte" id="fechaCorte"> 
                     <option value="1"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 1> selected</cfif>>01</option>
                     <option value="2"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 2> selected</cfif>>02</option>
                     <option value="3"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 3> selected</cfif>>03</option>
                     <option value="4"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 4> selected</cfif>>04</option>
                     <option value="5"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 5> selected</cfif>>05</option>
                     <option value="6"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 6> selected</cfif>>06</option>
                     <option value="7"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 7> selected</cfif>>07</option>
                     <option value="8"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 8> selected</cfif>>08</option>
                     <option value="9"  <cfif  MODO neq "ALTA" and LvarfechaCorte eq 9> selected</cfif>>09</option>
                     <option value="10" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 10> selected</cfif>>10</option>
                     <option value="11" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 11> selected</cfif>>11</option>
                     <option value="12" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 12> selected</cfif>>12</option>
                     <option value="13" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 13> selected</cfif>>13</option>
                     <option value="14" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 14> selected</cfif>>14</option>
                     <option value="15" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 15> selected</cfif>>15</option>
                     <option value="16" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 16> selected</cfif>>16</option>
                     <option value="17" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 17> selected</cfif>>17</option>
                     <option value="18" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 18> selected</cfif>>18</option>
                     <option value="19" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 19> selected</cfif>>19</option>
                     <option value="20" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 20> selected</cfif>>20</option>
                     <option value="21" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 21> selected</cfif>>21</option>
                     <option value="22" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 22> selected</cfif>>22</option>
                     <option value="23" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 23> selected</cfif>>23</option>
                     <option value="24" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 24> selected</cfif>>24</option>
                     <option value="25" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 25> selected</cfif>>25</option>
                     <option value="26" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 26> selected</cfif>>26</option>
                     <option value="27" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 27> selected</cfif>>27</option>
                     <option value="28" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 28> selected</cfif>>28</option>
                     <option value="29" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 29> selected</cfif>>29</option>
                     <option value="30" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 30> selected</cfif>>30</option>
                     <option value="31" <cfif  MODO neq "ALTA" and LvarfechaCorte eq 31> selected</cfif>>31</option>
                    </select> De cada mes.
			</td>
		</tr>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_FechaCancelacion">Fecha de Cancelacion</cf_translate>:&nbsp;</td>
			<td>
            	<cfset LvarfechaCancelacion = "">
            	<cfif (MODO neq "ALTA")>
	                <cfset LvarfechaCancelacion = rsTarjetaCredito.CBTCfechacancelacion>
                </cfif>
            	<cf_sifcalendario name="fechaCancelacion" value="#DateFormat(LvarfechaCancelacion,'DD/MM/YYYY')#" tabindex="1">				  
			</td>
		</tr>
        <tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_FechaPago">Fecha de Pago</cf_translate>:&nbsp;</td>
			<td>
            	 <cfset LvarfechaPago = rsTarjetaCredito.CBTCfechapago>
                    <select name="fechaPago" id="fechaPago"> 
                     <option value="1"  <cfif MODO neq "ALTA" and LvarfechaPago eq 1> selected</cfif>>01</option>
                     <option value="2"  <cfif MODO neq "ALTA" and LvarfechaPago eq 2> selected</cfif>>02</option>
                     <option value="3"  <cfif MODO neq "ALTA" and LvarfechaPago eq 3> selected</cfif>>03</option>
                     <option value="4"  <cfif MODO neq "ALTA" and LvarfechaPago eq 4> selected</cfif>>04</option>
                     <option value="5"  <cfif MODO neq "ALTA" and LvarfechaPago eq 5> selected</cfif>>05</option>
                     <option value="6"  <cfif MODO neq "ALTA" and LvarfechaPago eq 6> selected</cfif>>06</option>
                     <option value="7"  <cfif MODO neq "ALTA" and LvarfechaPago eq 7> selected</cfif>>07</option>
                     <option value="08" <cfif MODO neq "ALTA" and LvarfechaPago eq 8> selected</cfif>>08</option>
                     <option value="09" <cfif MODO neq "ALTA" and LvarfechaPago eq 9> selected</cfif>>09</option>
                     <option value="10" <cfif MODO neq "ALTA" and LvarfechaPago eq 10> selected</cfif>>10</option>
                     <option value="11" <cfif MODO neq "ALTA" and LvarfechaPago eq 11> selected</cfif>>11</option>
                     <option value="12" <cfif MODO neq "ALTA" and LvarfechaPago eq 12> selected</cfif>>12</option>
                     <option value="13" <cfif MODO neq "ALTA" and LvarfechaPago eq 13> selected</cfif>>13</option>
                     <option value="14" <cfif MODO neq "ALTA" and LvarfechaPago eq 14> selected</cfif>>14</option>
                     <option value="15" <cfif MODO neq "ALTA" and LvarfechaPago eq 15> selected</cfif>>15</option>
                     <option value="16" <cfif MODO neq "ALTA" and LvarfechaPago eq 16> selected</cfif>>16</option>
                     <option value="17" <cfif MODO neq "ALTA" and LvarfechaPago eq 17> selected</cfif>>17</option>
                     <option value="18" <cfif MODO neq "ALTA" and LvarfechaPago eq 18> selected</cfif>>18</option>
                     <option value="19" <cfif MODO neq "ALTA" and LvarfechaPago eq 19> selected</cfif>>19</option>
                     <option value="20" <cfif MODO neq "ALTA" and LvarfechaPago eq 20> selected</cfif>>20</option>
                     <option value="21" <cfif MODO neq "ALTA" and LvarfechaPago eq 21> selected</cfif>>21</option>
                     <option value="22" <cfif MODO neq "ALTA" and LvarfechaPago eq 22> selected</cfif>>22</option>
                     <option value="23" <cfif MODO neq "ALTA" and LvarfechaPago eq 23> selected</cfif>>23</option>
                     <option value="24" <cfif MODO neq "ALTA" and LvarfechaPago eq 24> selected</cfif>>24</option>
                     <option value="25" <cfif MODO neq "ALTA" and LvarfechaPago eq 25> selected</cfif>>25</option>
                     <option value="26" <cfif MODO neq "ALTA" and LvarfechaPago eq 26> selected</cfif>>26</option>
                     <option value="27" <cfif MODO neq "ALTA" and LvarfechaPago eq 27> selected</cfif>>27</option>
                     <option value="28" <cfif MODO neq "ALTA" and LvarfechaPago eq 28> selected</cfif>>28</option>
                     <option value="29" <cfif MODO neq "ALTA" and LvarfechaPago eq 29> selected</cfif>>29</option>
                     <option value="30" <cfif MODO neq "ALTA" and LvarfechaPago eq 30> selected</cfif>>30</option>
                     <option value="31" <cfif MODO neq "ALTA" and LvarfechaPago eq 31> selected</cfif>>31</option>
                    </select> 	De cada mes.		  
			</td>
		</tr>
		<tr valign="baseline">
			<td align="right" nowrap><cf_translate key="LB_FechaVencimiento">Fecha de Vencimiento</cf_translate>:&nbsp;</td>
			<td>
            	<cfset LvarfechaVencimiento = "">
            	<cfif (MODO neq "ALTA")>
	                <cfset LvarfechaVencimiento = rsTarjetaCredito.CBTCfechavencimiento>
                </cfif>
            	<cf_sifcalendario name="fechaVencimiento" value="#DateFormat(LvarfechaVencimiento,'DD/MM/YYYY')#" tabindex="1">				  
			</td>
		</tr>
		<tr> 
			<td><div align="right"><cf_translate key="LB_Idioma">Idioma</cf_translate>:&nbsp;</div></td>
			<td>
				<select name="CBidioma" tabindex="4">
					<option value="0"<cfif modo neq 'ALTA' and rsCuentaBancaria.CBidioma eq 0>selected</cfif>>
						Español&nbsp;
					</option>
					<option value="1"<cfif modo neq 'ALTA' and rsCuentaBancaria.CBidioma eq 1>selected</cfif>>
						Inglés (USA)
					</option>
					<option value="2"<cfif modo neq 'ALTA' and rsCuentaBancaria.CBidioma eq 2>selected</cfif>>
						Inglés (Inglaterra)
					</option>
				</select>
			</td>
		</tr>
		
        <tr>
      		<td align="right" nowrap><cf_translate key="LB_Moneda">Moneda</cf_translate>:&nbsp;</td>
      		<td colspan="2" nowrap>
        		<fieldset style="width:95%"><legend><strong>&nbsp;Tipos de Moneda&nbsp;</strong></legend>
        		<table width="100%" cellpadding="2" cellspacing="0" border="0" >
          			<tr>
                    	<td>
                            <input type="checkbox" name="chkmoneda" disabled="disabled" checked>
                            <strong><cfoutput>#rsMonedaLoc.Mnombre#</cfoutput></strong>
                            <input type="hidden" name="chkmoneda" value="<cfoutput>#rsMonedaLoc.Mcodigo#</cfoutput>"/>
                        </td>
                        <cfif modo NEQ "ALTA">
                        	<cfset Mcodigos = 0>
                            <cfset LvarExisteExt = 0>
							<cfloop query="rsMonedas">
                            
                            	<cfif len(rsMonedaExt.Mnombre) GT 0 AND rsMonedaExt.Mnombre eq rsMonedas.Mnombre>
                                	<cfset LvarExisteExt = 1>
                                </cfif>
                            	<td>
                                	<input type="checkbox" name="chkmoneda" value="<cfoutput>#rsMonedas.Mcodigo#</cfoutput>" checked>
              						<strong><cfoutput>#rsMonedas.Mnombre#</cfoutput></strong>
                            	</td>
                                <cfif Mcodigos eq 0>
                                	<cfset Mcodigos = "," & #rsMonedas.Mcodigo#>
                                <cfelse>
                                	<cfset Mcodigos = Mcodigos & ","& #rsMonedas.Mcodigo#>
                                </cfif>
                            </cfloop>
                            <cfif LvarExisteExt eq 0 and len(rsMonedaExt.Mnombre) GT 0>
                                <td>
                                    <input type="checkbox" name="chkmoneda" value="<cfoutput>#rsMonedaExt.Mcodigo#</cfoutput>">
                                    <strong><cfoutput>#rsMonedaExt.Mnombre#</cfoutput></strong>
                                </td> 
                            </cfif>
                                                        
                        <cfelse>    
                            <cfif len(rsMonedaExt.Mnombre) GT 0>
                                <td>
                                    <input type="checkbox" name="chkmoneda" value="<cfoutput>#rsMonedaExt.Mcodigo#</cfoutput>">
                                    <strong><cfoutput>#rsMonedaExt.Mnombre#</cfoutput></strong>
                                </td> 
                            </cfif>           			
                        </cfif>
          			</tr>
                    
                    <tr>
                        <td align="right" nowrap><strong>Otra :</strong>&nbsp;</td>
                        <td align="left">
                        	<cfset LvarMoneda = "">
							<cfif (MODO neq "ALTA")>
                            	<cfif Mcodigos eq 0>
                                	<cfset Mcodigos = "">
                                </cfif>
                                <cfset LvarMoneda = "#rsMonedaLoc.Mcodigo#">
                                <cfif len(rsMonedaExt.Mnombre) GT 0>
                                	<cfset LvarMoneda = LvarMoneda & ",#rsMonedaExt.Mcodigo#">
                                </cfif>
                                <cfset LvarMoneda = LvarMoneda & "#Mcodigos#">
                            <cfelse>
                            	<cfset LvarMoneda = "#rsMonedaLoc.Mcodigo#">
                                <cfif len(rsMonedaExt.Mnombre) GT 0>
                                	<cfset LvarMoneda = LvarMoneda & ",#rsMonedaExt.Mcodigo#">
                                </cfif>
                            </cfif>
                            <cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri" quitar="#LvarMoneda#" tabindex="1">
                        </td> 
                        <td align="right" nowrap>
                        	<input 	type="button" id="AGRE" name="AGRE"	value="Agregar"	tabindex="1" onClick="javascript:if (window.fnNuevaCuentaContable) fnNuevaCuentaContable();">
                        </td>
                    </tr>
        		</table>
                <table width="50%" align="center" id="tblcuenta" cellpadding="0" cellspacing="0" border="0" >
					<tr><td></td></tr>
				</table>
      			</fieldset>
	  		</td>
	  		<td width="100">&nbsp;</td>
    	</tr>
        
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap>
				<input tabindex="-1" type="hidden" name="CBid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBid#</cfoutput></cfif>">
                <input tabindex="-1" type="hidden" name="CBTCid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsTarjetaCredito.CBTCid#</cfoutput></cfif>">
             	<input tabindex="-1" type="hidden" name="Bid" value="<cfoutput>#Form.Bid#</cfoutput>">
				<input tabindex="-1" name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
                <input tabindex="-1" name="mlocal" type="hidden" value="#rsMonedaLoc.Miso4217#">
                <!---Formato de Importación--->
                <input tabindex="-1" type="hidden" name="EIid" value="<cfoutput>#rsScriptsBancos.EIid#</cfoutput>">
             	<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsTarjetaCredito.ts_rversion#" 
					returnvariable="ts">
					</cfinvoke>
				</cfif>
				<input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
				<cfset tabindex=5 >
				<cfinclude template="/sif/portlets/pBotones.cfm">
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				key="BTN_Bancos"
				default="Bancos"
				returnvariable="BTN_Bancos"/>
				<input tabindex="5" type="button" name="Bancos" value="#BTN_Bancos#" onclick="Bancos1('<cfoutput>#Form.Bid#</cfoutput>');">
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
        <iframe name="masktarget" id="masktarget" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto"></iframe>		
	</table>
	</cfoutput>
</form>
<input type="image" id="imgDel" src="../../imagenes/Borrar01_S.gif"  title="Eliminar" style="display:none;" tabindex="1">

<script language="JavaScript">
	arrcuentas = new Array();
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	<cfoutput>
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description="#MSG_Oficina#";				
		objForm.Ccuenta.required = true;
		objForm.Ccuenta.description="#MSG_Cuenta#";	
		objForm.Cmayor_Ccuentacom.required = true;
		objForm.Cmayor_Ccuentacom.description="#MSG_Ccuentacom#";
		objForm.Cmayor_Ccuentaint.required = true;
		objForm.Cmayor_Ccuentaint.description="#MSG_Ccuentaint#";
		objForm.Cmayor_Ccuentaintpag.required = true;
		objForm.Cmayor_Ccuentaintpag.description="#MSG_Ccuentaintpag#";			
		objForm.CBdescripcion.required = true;
		objForm.CBdescripcion.description="#MSG_Descripcion#";
		objForm.CBTarjeta.required = true;
		objForm.CBTarjeta.description="#MSG_NumTarj#";
		objForm.TipoTarjeta.required = true;
		objForm.TipoTarjeta.description="#MSG_TipoTarjeta#";
		objForm.Status.required = true;
		objForm.Status.description="#MSG_Status#";				
		objForm.DEid.required = true;
		objForm.DEid.description="#MSG_DEid#";	
		objForm.fechaIV.required = true;
		objForm.fechaIV.description="#MSG_fechaIV#";
		objForm.fechaCorte.required = true;
		objForm.fechaCorte.description="#MSG_fechaCorte#";
		objForm.fechaPago.required = true;
		objForm.fechaPago.description="#MSG_fechaPago#";	
		objForm.fechaVencimiento.required = true;
		objForm.fechaVencimiento.description="#MSG_fechaVencimiento#";	
		objForm.MarcaTarjeta.required = true;
		objForm.MarcaTarjeta.description="#MSG_MarcaTarjeta#";
		objForm.DEnombrecompleto.required = true;
		objForm.DEnombrecompleto.description="#MSG_titularNombre#";
		objForm.DEidentificacion.required = true;
		objForm.DEidentificacion.description="#MSG_titularIdentificacion#";	
		
		if(document.form1.chkCuentaTCE.checked == true){
			objForm.CFformato.required = true;
			objForm.CFformato.description = 'Cuenta para pagos TCE';
		}
		if(document.form1.chkCuentaTCE.checked == false){
			objForm.CFformato.required = false;		
		}
		
		
	</cfoutput>	

	function deshabilitarValidacion(){
		objForm.Ocodigo.required = false;
		objForm.Ccuenta.required = false;
		objForm.CBdescripcion.required = false;
		objForm.CBTarjeta.required = false;
		objForm.TipoTarjeta.required = false;
		objForm.Status.required = false;
		objForm.DEid.required = false;
		objForm.DEid.required = false;
	}
	function fnNuevaCuentaContable()	{	
		var LvarTable  = document.getElementById("tblcuenta");
		var LvarTbody  = LvarTable.tBodies[0];
		var LvarTR     = document.createElement("TR");
		var cuenta	   = document.getElementById("McodigoOri").options[document.getElementById("McodigoOri").options.selectedIndex].text;
		var nombre     = "chkmoneda";
		var Mcodigo	   = document.form1.McodigoOri.value	
		var continuar  = true;
		for (i=0;i< document.getElementById("McodigoOri").options.length ;i++)
		{

			if (arrcuentas.length == 0)
			{
				arrcuentas[i] = cuenta;
				break;
			}
			else
			{		
				if (i < arrcuentas.length)
				{
					if (arrcuentas[i] == cuenta)
					{
						alert("La Moneda " + cuenta + " ya ha sido agregada");
						continuar = false;
						break;
					}
				}	
				else
				{
					break;	
				}
			}
		}		
		if (continuar)		
		{	
			arrcuentas[i] = cuenta;	
			
			sbAgregaTdInput (LvarTR, cuenta, "hidden", "CuentaidList");
			sbAgregaTdText  (LvarTR, cuenta, "checkbox", nombre, Mcodigo);
			sbAgregaTdImage (LvarTR, "imgDel", "right");
			if (document.all) {
				GvarNewTD.attachEvent ("onclick", sbEliminarTR);
			}
			else {
				GvarNewTD.addEventListener ("click", sbEliminarTR, false);
			}
			LvarTR.name = cuenta;
			LvarTbody.appendChild(LvarTR);
		}	
		
	}	
	
	function sbAgregaTdInput (LprmTR, LprmValue, LprmType, LprmName){
		var LvarTD    = document.createElement("TD");
		var LvarInp   = document.createElement("INPUT");
		LvarInp.type = LprmType;
		if (LprmName != "") {
			LvarInp.name = LprmName;
		}
		LvarTD.appendChild(LvarInp);
		GvarNewTD = LvarTD;
		LprmTR.appendChild(LvarTD);
	}
	function sbAgregaTdText (LprmTR, LprmValue, LprmType2, LprmNombre, LprmMcodigo){
		var LvarTD2    = document.createElement("TD");
		var LvarTD    = document.createElement("INPUT");
		var LvarTxt   = document.createTextNode(LprmValue);
		var strong    = document.createElement("STRONG");
		LvarTD.type = LprmType2;
		LvarTD.value = LprmMcodigo;
		LvarTD.name = LprmNombre;
		LvarTD2.appendChild(LvarTD);
		LvarTD2.appendChild(strong);
		strong.appendChild(LvarTxt);
		GvarNewTD = LvarTD2;
		LvarTD2.noWrap = true;
		LprmTR.appendChild(LvarTD2);
	}
	function sbAgregaTdImage (LprmTR, LprmNombre, align){
		var LvarTDimg 	= document.createElement("TD");
		var LvarImg 	= document.getElementById(LprmNombre).cloneNode(true);
		LvarImg.style.display="";
		LvarImg.align=align;
		LvarTDimg.appendChild(LvarImg);
		GvarNewTD = LvarTDimg;
		LprmTR.appendChild(LvarTDimg);
	}
	function sbEliminarTR(e){
		var LvarTR;
		var name;
		if (document.all) {
			LvarTR = e.srcElement;
		}
		else {
			LvarTR = e.currentTarget;
		}
		LvarTR = LvarTR.parentNode;
		name   = LvarTR.name;
		for (i=0;i< document.getElementById("McodigoOri").options.length ;i++)
		{
			if (arrcuentas[i] == name)
			{
				arrcuentas[i] = "";
				break;
			}
		}
		LvarTR.parentNode.removeChild(LvarTR);		
	}
	function getMask(m)
	{
		Marca = document.form1.MarcaTarjeta.value;
		document.getElementById('masktarget').src = 'TCECatalogo-Mask.cfm?CBTMid='+Marca;		
	}
	
	function cambioCuentaTCE(){	

		var f1 = document.form1;	
		
		if(document.form1.chkCuentaTCE.checked == true){
			document.getElementById("trCPagoTCE").style.display = "";
			objForm.CFformato.required = true;
			objForm.CFformato.description = 'Cuenta para pagos TCE'; 
		}
		if(document.form1.chkCuentaTCE.checked == false){
			objForm.CFformato.required = false; 		
			document.getElementById("trCPagoTCE").style.display = "none";
		}
		return true;
	} 
	
		
	function setDescripcion(){
		var form = document.form1;
		var lDescObj = form.CBdescripcion;
		var lDescObjAnt = lDescObj.value;
		var lFiltrosAux = "";
		<cfoutput>
			lFiltrosAux = "";
			if (form.MarcaTarjeta.value!="")
				lFiltrosAux = document.getElementById("MarcaTarjeta").options[document.getElementById("MarcaTarjeta").options.selectedIndex].text; 
			if (form.CBTarjeta.value!="")
				lFiltrosAux = lFiltrosAux + " " + form.CBTarjeta.value;
			if (form.DEnombrecompleto.value!="")
				lFiltrosAux = lFiltrosAux + " " + form.DEnombrecompleto.value;	
				
		</cfoutput>
		lDescObj.value = lFiltrosAux;
	}
	</script>
    