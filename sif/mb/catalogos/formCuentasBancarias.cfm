<!---
	Modificado por Hector Garcia Beita.
		Fecha: 22-07-2011.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
--->

<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_CtaClienteExiste" default="El Código de Cuenta Interbancaria ya existe." returnvariable="LB_CtaClienteExiste" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Bancos" default="Bancos" returnvariable="BTN_Bancos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_Oficina" default="Oficina" returnvariable="MSG_Oficina" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Moneda" default="Moneda" returnvariable="MSG_Moneda" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Cuenta" default="Cuenta" returnvariable="MSG_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_Descripcion" default="Descripción" returnvariable="MSG_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_CodigoDeCuenta" default="Código de Cuenta en el Banco" returnvariable="MSG_CodigoDeCuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_CuentaCliente" default="Código de Cuenta Interbancaria" returnvariable="MSG_CuentaCliente" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_TipoDeCuenta" default="Tipo de Cuenta" returnvariable="MSG_TipoDeCuenta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_CVirtual" default="Cuenta Virtual" returnvariable="MSG_CVirtual" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN DE VARIBALES DE TRADUCCION --->

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
 --->
<cfset LvarPagina = "Bancos.cfm">
<cfset LvarSQLCtsBancarias = "SQLCuentasBancarias.cfm">
<cfif isdefined("LvarTCECuentasBancarias")>
	<cfset LvarPagina = "TCEBancos.cfm">
    <cfset LvarSQLCtsBancarias = "TCESQLCuentasBancarias.cfm">
</cfif>

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

<cfif isdefined("Session.Ecodigo") and isdefined("Form.CBid") and Len(Trim(Form.CBid)) GT 0 >
	<cfquery name="rsCuentaBancaria" datasource="#Session.DSN#">
		select CBid, Bid, Ecodigo, Ocodigo, 
		Mcodigo, Ccuenta, CBcodigo, CBdescripcion, 
		Ccuentacom, Ccuentaint, CBcc, CBTcodigo, 
		CBdato1, ts_rversion, EIid
		, CBidioma,CBclave,CBcodigoext,CcuentaintPag, CVirtual
		from CuentasBancos
		where Ecodigo = #Session.Ecodigo#
		  and CBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CBid#">
		  and Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.Bid#">
          and CBesTCE = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="0">				
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
    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>

<cfquery name="rsScriptsBancos" datasource="sifcontrol">
	select EIid,rtrim(EIcodigo) as EIcodigo, EIdescripcion
	from EImportador
	where EImodulo = 'sif.mb'
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
	function deshabilitarValidacion(){
		objForm.CBdescripcion.required = false;
		objForm.CBcodigo.required = false;
		objForm.CBcc.required = false;
	}
<!---Redireccion Bancos o TCEBancos (Tarjetas de Credito)--->
	function Bancos1(data) {
		document.form1.action='<cfoutput>#LvarPagina#</cfoutput>';
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

<!---Redireccion SQLCuentasBancarias o TCESQLCuentasBancarias(Tarjetas de Credito)--->
<form method="post" name="form1" action="<cfoutput>#LvarSQLCtsBancarias#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>">
 
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
		<cfoutput> 
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Moneda" XmlFile="/sif/rh/generales.xml">Moneda</cf_translate>:&nbsp;</td>
			<td><cf_sifmonedas Conexion="#session.DSN#" form="form1" query="#rsCuentaBancaria#" Mcodigo="Mcodigo" tabindex="1"></td>		  
		</tr>
		</cfoutput>
		
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
					ccuenta="Ccuentacom" cdescripcion="Cdescripcioncom" cformato="Cformatocom">
				<cfelse>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentacom" 
					cdescripcion="Cdescripcioncom" cformato="Cformatocom">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CuentaIntNoCobrados">Cuenta Int. No Cobrados</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA" and isDefined("CuentaIntNoCob") and Len(Trim(CuentaIntNoCob)) GT 0>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaIntNoCob#" auxiliares="N" movimiento="S" 
					ccuenta="Ccuentaint" cdescripcion="Cdescripcionint" cformato="Cformatoint">
				<cfelse>
					<cf_cuentas tabindex="3" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentaint" 
					cdescripcion="Cdescripcionint" cformato="Cformatoint">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Cuenta Int. No Pagados:&nbsp;</td>
			<td>
				<cfif modo NEQ "ALTA" and isDefined("CuentaIntNoPag") and Len(Trim(CuentaIntNoPag)) GT 0>
					<cf_cuentas tabindex="1" Conexion="#Session.DSN#" Conlis="S" query="#rsCuentaIntNoPag#" auxiliares="N" movimiento="S" 
					ccuenta="Ccuentaintpag" cdescripcion="Cdescripcionintpag" cformato="Cformatointpag">
				<cfelse>
					<cf_cuentas tabindex="3" Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" ccuenta="Ccuentaintpag" 
					cdescripcion="Cdescripcionintpag" cformato="Cformatointpag">
				</cfif>	
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/sif/rh/generales.xml">Descripción</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" tabindex="4" name="CBdescripcion" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBdescripcion#</cfoutput></cfif>" 
				size="32" maxlength="80" onfocus="javascript:this.select();">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_CodigoCuenta">Cód. Cuenta en el Banco</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="CBcodigo" tabindex="4" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBcodigo#</cfoutput></cfif>" 
				size="32" maxlength="50" onfocus="javascript:this.select();">
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_CuentaCliente">Cód. Cuenta Interbancaria</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" maxlength="25" name="CBcc"  tabindex="4"
				value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsCuentaBancaria.CBcc)#</cfoutput></cfif>" 
				size="32" onblur="javascript:codigos(this);" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr> 
			<td><div align="right"><cf_translate key="LB_TipoDeCuenta">Tipo de Cuenta</cf_translate>:&nbsp;</div></td>
			<td>
				<select name="CBTcodigo" tabindex="4">
					<option value="1"<cfif modo neq 'ALTA' and rsCuentaBancaria.CBTcodigo eq 1> selected</cfif>>
						Cuenta de Ahorro</option>
					<option value="2"<cfif modo eq 'ALTA' or (modo neq 'ALTA' and rsCuentaBancaria.CBTcodigo eq 2)> selected</cfif>>
						Cuenta Corriente</option>
				</select>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right"><cf_translate key="LB_DatoAdicionalCuenta">Dato Adicional Cuenta</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="CBdato1" tabindex="4" size="30" onfocus="javascript:this.select();" 
				value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBdato1#</cfoutput></cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><cf_translate key="LB_FormatoDeImportacion">Formato de Importaci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<select name="EIid" tabindex="4">
					<option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/rh/generales.xml">Seleccione Uno</cf_translate>---</option>
					<cfloop query="rsScriptsBancos">
						<option value="#rsScriptsBancos.EIid#" 
						<cfif (MODO neq "ALTA") and (trim(rsCuentaBancaria.EIid) eq trim(rsScriptsBancos.EIid))>selected</cfif>
						>#rsScriptsBancos.EIdescripcion#</option>
					</cfloop>
				</select>
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
			<td>&nbsp;</td>
			<td><input type="checkbox" name="matricula" /><strong>&nbsp;Matricular  Cheques &nbsp;</strong>
			<input type="checkbox" name="CVirtual" <cfif isdefined("rsCuentaBancaria.CVirtual") and rsCuentaBancaria.CVirtual eq 1 >checked</cfif> /><strong>&nbsp; #MSG_CVirtual#</strong></td>	
		</tr>
		<cfif LEN(TRIM(InterfazCatalogos)) and InterfazCatalogos EQ 1>
			<tr valign="baseline"> 
				<td nowrap align="right"><cf_translate key="LB_ClaveCuenta">Clave</cf_translate>:&nbsp;</td>
				<td>
					<input type="text" name="CBclave" tabindex="4" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBclave#</cfoutput></cfif>" 
					size="15" maxlength="4" onfocus="javascript:this.select();">
				</td>
			</tr>
			<tr valign="baseline"> 
				<td nowrap align="right"><cf_translate key="LB_CodigoExterno">C&oacute;digo Externo</cf_translate>:&nbsp;</td>
				<td>
					<input type="text" name="CBcodigoext" tabindex="4" 
					value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBcodigoext#</cfoutput></cfif>" 
					size="15" maxlength="10" onfocus="javascript:this.select();">
				</td>
			</tr>
		</cfif>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline"> 
			<td colspan="2" align="center" nowrap>
				<input tabindex="-1" type="hidden" name="CBid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsCuentaBancaria.CBid#</cfoutput></cfif>">
				<input tabindex="-1" type="hidden" name="Bid" value="<cfoutput>#Form.Bid#</cfoutput>">
				<input tabindex="-1" name="desde" type="hidden" value="<cfif isdefined("form.desde")><cfoutput>#form.desde#</cfoutput></cfif>">
				<cfset ts = "">
				<cfif modo NEQ "ALTA">
					<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsCuentaBancaria.ts_rversion#" 
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
		</cfoutput>
	</table>
</form>


<script language="JavaScript">
	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");
	<cfoutput>
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description="#MSG_Oficina#";				
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description="#MSG_Moneda#";
	objForm.Ccuenta.required = true;
	objForm.Ccuenta.description="#MSG_Cuenta#";				
	objForm.CBdescripcion.required = true;
	objForm.CBdescripcion.description="#MSG_Descripcion#";				
	objForm.CBcodigo.required = true;
	objForm.CBcodigo.description="#MSG_CodigoDeCuenta#";						
	objForm.CBcc.required = true;
	objForm.CBcc.description="#MSG_CuentaCliente#";
	objForm.CBTcodigo.required = true;
	objForm.CBTcodigo.description="#MSG_TipoDeCuenta#";
</cfoutput>
</script>