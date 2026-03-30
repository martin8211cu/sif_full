<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se hizo una modificación en la llave de la tabla BTransaccionesEq, ahora son cuatro campos 
			(Ecodigo,Bid,BTid,BTEcodigo). Se hicieron los cambios en cada consulta 
			y además se deshabilito los campos que pertenecen a la tabla.
	Modificado por Gustavo Fonseca H.
		Fecha: 13-10-2005.
		Motivo: Se quita la validación de que solo se pueda tener un tipo de transacción del banco (función __CodeExists).
		Esto por que se debe permitir N transacciones "mías" a solo 1 del Banco.
	Modificado por Gustavo Fonseca H.
		Fecha: 14-10-2005.
		Motivo: Se utilizan los tags "sifMBTransaccionesBancos" y "sifMBTransaccionesLibros" para obtener la transaccioón de Bancos y Libros.
		Se agrega la Etiqueta del banco para informar sobre cual banco se está trabajando.
	Modificado por Gustavo Fonseca H.
		Fecha: 26-10-2005.
		Motivo: Se modifica para que agregue campos hidden y pueda modificar la transacción de Bancos y de Libros, también se arregla la 
			validación para que solo se puedan asociar transacciones equivalentes (Bancos-C/Libros-D y viceversa). 
	Modificado por Hector Garcia Beita.
		Fecha: 22-07-2011.
		Motivo: Se agregan variables de redirección para los casos en que el 
		fuente sea llamado desde la opción de tarjetas de credito mediante includes
		con validadores segun sea el caso
 --->

<!---
	Validador para los casos en que la transaccion se realiza
	desde la opcion de bancos o desde tarjetas de credito. 
 --->
<cfset LvarSQLTransEqui = "SQLTBEquivalentes.cfm">
<cfset LvarPaginaTrans = "TransaccionesBanco.cfm">
<cfset LvarPaginaBanco = "Bancos.cfm">
<cfset LvarBTtce = 0>
<cfif isdefined("LvarTCETBEEquivalentes")>
    <cfset LvarPaginaBanco = "TCEBancos.cfm">
    <cfset LvarPaginaTrans = "TCETransaccionesBanco.cfm">
    <cfset LvarSQLTransEqui = "TCESQLTransaccionesBancoEquiva.cfm">
	<cfset LvarBTtce = 1>
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

<cfquery name="RsBdescripcion" datasource="#session.DSN#">
	select Bdescripcion
		from Bancos
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
</cfquery>

<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#session.DSN#">
		select *
		from BTransaccionesEq
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
		  and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
		  and BTEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.BTEcodigo#">

	</cfquery>

	<cfquery name="rsBancos" datasource="#session.DSN#">
		select 
			Bid,
			BTEcodigo,
			BTEdescripcion,
			BTEtipo,
			BMUsucodigo,
			ts_rversion
		from TransaccionesBanco
		where Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Bid#">
			and rtrim(ltrim(upper(BTEcodigo))) = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Ucase(form.BTEcodigo))#">
			and BTEtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTtce#">
 
	</cfquery>
	<cfquery name="rsLibros" datasource="#session.DSN#">
		select 
			BTid,
			Ecodigo, 
			BTcodigo, 
			BTdescripcion, 
			BTtipo, 
			ts_rversion
		from BTransacciones 
		where   BTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
			and BTtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTtce#">
	</cfquery>
</cfif>

<cfquery  name="rsTransaccion" datasource="#session.DSN#">
	select BTid, BTdescripcion 
	from BTransacciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and BTtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarBTtce#">
	order by BTid
</cfquery>

<cfquery name="rsCodigos" datasource="#session.DSN#">
	select BTEcodigo
	from BTransaccionesEq
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
</cfquery>


<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function deshabilitarValidacion(){
		if (document.form1.botonSel.value == 'Baja' || document.form1.botonSel.value == 'Nuevo' ){
			objForm.EPcodigo.required = false;
			objForm.EPdescripcion.required = false;
		}
	}
	
</script>

<!----Redireccion SQLTBEquivalentes o TCESQLTransaccionesBancoEquiva--->
<form method="post" name="form1" action="<cfoutput>#LvarSQLTransEqui#</cfoutput>" onSubmit="return valida();">
	<input name="LvarBid" type="hidden" value="<cfoutput>#form.Bid#</cfoutput>">
	<table align="center" border="0">
		<tr >
			<td align="right"><strong><cf_translate key="LB_Banco" XmlFile="/sif/generales.xml">Banco</cf_translate>:&nbsp;</strong></td>
			<td colspan="3"><cfoutput>#RsBdescripcion.Bdescripcion#</cfoutput></td>
    	</tr>
		<tr >
			<td align="right">&nbsp;</td>
			<td colspan="3">&nbsp;</td>
    	</tr>
    	<tr >
			<td nowrap align="right"><strong><cf_translate key="LB_TransaccionDelBanco">Transacci&oacute;n del Banco</cf_translate>:</strong></td>
		  	<td colspan="3">
				<cfif modo NEQ 'ALTA'>
					<cfoutput>
						<input tabindex="-1" name="Bid" type="hidden" value="#rsBancos.Bid#">
						<input tabindex="-1" name="BTEcodigo" type="hidden" value="#rsBancos.BTEcodigo#">
						<input tabindex="-1" name="BTEdescripcion" type="hidden" value="#rsBancos.BTEdescripcion#">
						<input tabindex="-1" name="BTEtipo" type="hidden" value="#rsBancos.BTEtipo#">
						#rsBancos.BTEcodigo#&nbsp;#rsBancos.BTEdescripcion#
					</cfoutput>					
				<cfelse>
					<cf_sifMBTransaccionesBancos Banco = #form.Bid#  tabindex="1">
				</cfif>
		  	</td>
    	</tr>
		<tr> 
			<td nowrap align="right"><strong><cf_translate key="LB_TransaccionDeLibros">Transacci&oacute;n de Libros</cf_translate>:</strong></td>
		  	<td colspan="3">
				<cfif modo NEQ 'ALTA'>
					<cfoutput>
						<input tabindex="-1" name="BTid" type="hidden" value="#rsLibros.BTid#">
						<input tabindex="-1" name="BTcodigo" type="hidden" value="#rsLibros.BTcodigo#">
						<input tabindex="-1" name="BTdescripcion" type="hidden" value="#rsLibros.BTdescripcion#">
						<input tabindex="-1" name="BTtipo" type="hidden" value="#rsLibros.BTtipo#">
						#rsLibros.BTcodigo#&nbsp;#rsLibros.BTdescripcion#
					</cfoutput>
				<cfelse>
					<cf_sifMBTransaccionesLibros  tabindex="1">
				</cfif>
		  	</td>
    	</tr>
		
    	<tr >
			<td nowrap align="right"><strong><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:</strong></td>
		  	<td colspan="3">
		  		<input type="text" name="BTEdescripcion2"  tabindex="1"
					   value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.BTEdescripcion#</cfoutput></cfif>" 
					   size="60" maxlength="60" onFocus="this.select();"  >
		  	</td>
    	</tr>
		<tr bordercolor="000000"class="Ayuda">
			<td colspan="2" style="font-size:12px" align="center">
				<cf_translate key="MSG_SoloSePuedenAsociarTransaccionesConElMismoTipoDeMovimientoCreditoODebito">Solo se pueden asociar transacciones con el mismo tipo de movimiento (Cr&eacute;dito o D&eacute;bito)</cf_translate>
			</td>
		</tr>


		<tr valign="baseline">
      		<td colspan="4" align="center" nowrap>
			  <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_RegresarABancos"
					Default="Regresar a Bancos"
					returnvariable="BTN_RegresarABancos"/>
			  <cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="BTN_TransaccionesDelBanco"
					Default="Transacciones del Banco"
					returnvariable="BTN_TransaccionesDelBanco"/>
				<cf_botones  tabindex="2" modo=#modo# include="Bancos,Transacciones" includevalues="#BTN_RegresarABancos#,#BTN_TransaccionesDelBanco#">
      		</td>
		</tr>
  </table>
 <!--- <input type="hidden" name="Bid" value="<cfoutput>#form.Bid#</cfoutput>">
 <cfif modo NEQ 'ALTA'><input type="hidden" name="BTid" value="<cfoutput>#form.BTid#</cfoutput>"></cfif> --->
	 <input  tabindex="-1" name="_BTid" type="hidden" value="">
	 <input tabindex="-1" name="_BTEcodigo" type="hidden" value="">
	 <input tabindex="-1" name="_Bid" type="hidden" value="">
	 
 </form>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SoloSePuedenAsociarTransaccionesConElMismoTipoDeMovimientoCreditoODebito1"
	Default="Solo se pueden asociar transacciones con el mismo tipo de movimiento (Crédito o Débito)"
	returnvariable="MSG_SoloSePuedenAsociarTransaccionesConElMismoTipoDeMovimientoCreditoODebito1"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CodigoDeLaTransaccionDelBanco"
	Default="Código de la Transacción del Banco"
	returnvariable="MSG_CodigoDeLaTransaccionDelBanco"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CodigoDeLaTransaccionDeLibros"
	Default="Código de la Transacción de Libros"
	returnvariable="MSG_CodigoDeLaTransaccionDeLibros"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TransaccionBancaria"
	Default="Transacción Bancaria"
	returnvariable="MSG_TransaccionBancaria"/>

	
<script language="JavaScript">
	
	document.form1._BTid.value = document.form1.BTid.value;
	document.form1._BTEcodigo.value = document.form1.BTEcodigo.value;
	document.form1._Bid.value = document.form1.Bid.value;
	

	function deshabilitarValidacion(){
		objForm.BTEdescripcion.required = false;
	}

	function valida(){
		document.form1.BTEcodigo.disabled = false;
		<cfif modo EQ 'ALTA'>
			return ValidaTipos();
		</cfif>
		return true;
	}


		
	function ValidaTipos()
	{
		if (!(document.form1.BTtipo.value == document.form1.BTEtipo.value))
		{
			alert('<cfoutput>#MSG_SoloSePuedenAsociarTransaccionesConElMismoTipoDeMovimientoCreditoODebito1#</cfoutput>');
			return false;
		}
		else 
		{
			return true;
		}
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

<cfoutput>
	objForm.BTEcodigo.required = true;
	objForm.BTEcodigo.description="#MSG_CodigoDeLaTransaccionDelBanco#";
	objForm.BTcodigo.required = true; 
	objForm.BTcodigo.description="#MSG_CodigoDeLaTransaccionDeLibros#";
	objForm.BTid.required = true;
	objForm.BTid.description="#MSG_TransaccionBancaria#";
</cfoutput>	
	function funcBancos(){
		<!----Redireccion Banco o TCEBanco--->
		document.form1.action='<cfoutput>#LvarPaginaBanco#</cfoutput>';
		document.form1.Bid.value = document.form1.Bid.value;		
		document.form1.submit();
		return false;
	}

	function funcTransacciones(){
		<!----Redireccion TransaccionesBancos o TCETransaccionesBancos--->
		document.form1.action='<cfoutput>#LvarPaginaTrans#</cfoutput>';
		document.form1.Bid.value = document.form1.Bid.value;
		document.form1.BTEcodigo.value=" ";		
		document.form1.submit();
		return false;
	}

</script>