<!--- 
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 19-10-2005.
		Motivo: Se agrega la etiqueta del Banco para saber sobre cual banco se está trabajando.
	Modificado por Gustavo Fonseca Hernández.
		Fecha: 27-10-2005.
		Motivo: Se pone etiqueta en cambio el dato del BTEcodigo y se agrega ayuda para el usuario.
		
		Modificado por Hector Garcia Beita.
		Fecha: 2-1-2005.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
 --->
 
<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
--->
<cfset LvarPagina = "SQLTransaccionesBanco.cfm">
<cfset LvarPaginaBanco = "Bancos.cfm">
<cfset LvarTBEquiva = "TBEquivalentes.cfm">
<cfset LvarBTEtce = 0>
<cfif isdefined("LvarTCETransaccionesBancos")>
	<cfset LvarPagina = "TCESQLTransaccionesBanco.cfm">
    <cfset LvarPaginaBanco = "TCEBancos.cfm">
    <cfset LvarTBEquiva = "TCETransaccionesBancoEquiva.cfm">
    <cfset LvarBTEtce = 1>
</cfif>

<!-- Establecimiento del modo -->
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

<cfquery name="RsBdescripcion" datasource="#session.DSN#">
	select Bdescripcion
		from Bancos
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
</cfquery>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.Bid") AND Len(Trim(Form.Bid)) GT 0  and isdefined("form.BTEcodigo") and len(trim(form.BTEcodigo)) gt 0>
	<cfquery name="rsTipoTransaccion" datasource="#Session.DSN#">
		select 
			Bid,
			BTEcodigo,
			BTEdescripcion,
			BTEtipo,
			BMUsucodigo,
			ts_rversion
		from TransaccionesBanco
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
        and BTEtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTEtce#">
	</cfquery>
	
	<cfquery name="rsValidaTipo" datasource="#session.DSN#">
		select count(1) as resultado
		from BTransaccionesEq 
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
		and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.BTEcodigo#">
	</cfquery>
	
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

	<!---Redireccion SQLTransaccionesBanco o TCESQLTransaccionesBanco (Tarjetas de Credito)--->
<form method="post" name="form1" action="<cfoutput>#LvarPagina#</cfoutput>">
	<table align="center" width="100%" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td align="right"><strong><cf_translate key="LB_Banco" XmlFile="/sif/generales.xml">Banco</cf_translate>:&nbsp;</strong></td>
			<td colspan="3"><cfoutput>#RsBdescripcion.Bdescripcion#</cfoutput></td>
    	</tr>
		<tr>
			<td align="right">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
    	</tr>
		<tr> 
			<td nowrap align="right"><strong><cf_translate key="LB_Codigo" XmlFile="/sif/generales.xml">Código</cf_translate>:&nbsp;</strong></td>
			<td>
				<cfif modo EQ "ALTA">
					<input name="BTEcodigo" tabindex="1" type="text" value="" size="10" maxlength="10" onfocus="javascript:this.select();">
				<cfelseif modo NEQ "ALTA">
					<cfoutput>#trim(rsTipoTransaccion.BTEcodigo)#</cfoutput>
					<input name="BTEcodigo" type="hidden" value="<cfoutput>#trim(rsTipoTransaccion.BTEcodigo)#</cfoutput>">
				</cfif>
			</td>
		</tr>

		<tr> 
			<td nowrap align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripción</cf_translate>:&nbsp;</strong></td>
			<td><input type="text" tabindex="1" name="BTEdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsTipoTransaccion.BTEdescripcion)#</cfoutput></cfif>" size="50" maxlength="255" onfocus="javascript:this.select();"></td>
		</tr>

		<tr> 
			<td nowrap align="right"><strong><cf_translate key="LB_TipoDeMovimiento">Tipo de Movimiento</cf_translate>:&nbsp;</strong></td>
			<td>
				<cfif isdefined("rsValidaTipo") and rsValidaTipo.resultado gt 0>
					<input type="hidden" name="BTEtipo" value="<cfoutput>#rsTipoTransaccion.BTEtipo#</cfoutput>">
					<cfoutput>
					<cfif rsTipoTransaccion.BTEtipo eq "D">
						<cf_translate key="CMB_Debito" XmlFile="/sif/generales.xml">D&eacute;bito</cf_translate>
					<cfelseif rsTipoTransaccion.BTEtipo EQ "C">
						<cf_translate key="CMB_Credito" XmlFile="/sif/generales.xml">Cr&eacute;dito</cf_translate>
					</cfif>
					
					</cfoutput>
				<cfelse>	
					<select name="BTEtipo" tabindex="1">
						<option value="D" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTEtipo EQ "D">selected</cfif>><cf_translate key="CMB_Debito" XmlFile="/sif/generales.xml">D&eacute;bito</cf_translate></option>
						<option value="C" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTEtipo EQ "C">selected</cfif>><cf_translate key="CMB_Credito" XmlFile="/sif/generales.xml">Cr&eacute;dito</cf_translate></option>
					</select>
				</cfif>
			</td>
		</tr>
		<tr bordercolor="000000"class="Ayuda">
			<td colspan="2" align="center" style="font-size:12px">
				<cf_translate key="MSG_ElTipoDeMovimientoSeDefineDesdeLaPerspectivaDeLaEmpresa">El tipo de movimiento se define desde la perspectiva de la Empresa</cf_translate>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
					<input  tabindex="-1" type="hidden" name="Bid" value="<cfoutput>#form.Bid#</cfoutput>">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsTipoTransaccion.ts_rversion#" returnvariable="ts"></cfinvoke>
					</cfif>		  
					<input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">	  
					  <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_RegresarABancos"
						Default="Regresar a Bancos"
						returnvariable="BTN_RegresarABancos"/>
					  <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_EquivalenciasDeTransacciones"
						Default="Equivalencias de Transacciones"
						returnvariable="BTN_EquivalenciasDeTransacciones"/>

					<cf_botones tabindex="2" modo = #modo# include="Bancos,EQTransacciones" includevalues="#BTN_RegresarABancos#,#BTN_EquivalenciasDeTransacciones#">
			</td>
		</tr>
	</table>
</form>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/sif/generales.xml"
	returnvariable="MSG_Codigo"/>

<script language="JavaScript">
	function deshabilitarValidacion(){
		objForm.BTEcodigo.required = false;
		objForm.BTEdescripcion.required = false;
	}

	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");
<cfoutput>
	objForm.BTEcodigo.required = true;
	objForm.BTEcodigo.description="#MSG_Codigo#";
	
	objForm.BTEdescripcion.required = true;
	objForm.BTEdescripcion.description="#MSG_Descripcion#";
</cfoutput>
	
	function funcBancos(){
		
		<!---Redireccion Banco o TCEBanco (Tarjetas de Credito)--->
		document.form1.action='<cfoutput>#LvarPaginaBanco#</cfoutput>';
		document.form1.Bid.value = document.form1.Bid.value;		
		document.form1.submit();
		return false;
	}
	function funcEQTransacciones(){
		
		<!---Redireccion TBEquivalentes o TCETransaccionesBancoEquiva(Tarjetas de Credito)--->
		document.form1.action='<cfoutput>#LvarTBEquiva#</cfoutput>';
		document.form1.Bid.value = document.form1.Bid.value;		
		document.form1.submit();
		return false;
	}
</script>