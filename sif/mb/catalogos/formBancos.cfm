<!---
	Modificado por: Gustavo Fonseca H.
		Fecha: 18-10-2005.
		Motivo: Se cambia el botón de "Equivalencias de Transacciones" por "Transacciones del Banco".
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
<cfset LvarPagina = "SQLBancos.cfm">
<cfset LvarPaginaCtasBancos = "CuentasBancarias.cfm">
<cfset LvarPaginaTranBancos = "TransaccionesBanco.cfm">
<cfif isdefined("LvarTCEBancos")>
	<cfset LvarPagina = "TCESQLBancos.cfm">
    <cfset LvarPaginaCtasBancos = "TCECuentasBancarias.cfm">
    <cfset LvarPaginaTranBancos = "TCETransaccionesBanco.cfm">
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

<cfif isdefined("url.Bid") and Len("url.Bid") gt 0>
	<cfset form.Bid = url.Bid >
	<cfset form.Cambio = "Cambiar" >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.Bid") and Len(Trim(Form.Bid)) GT 0 and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.Bid") AND Len(Trim(Form.Bid)) GT 0 >
	<cfquery name="rsBanco" datasource="#Session.DSN#">
		SELECT 	Bid, Ecodigo, Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail, ts_rversion, EIid, Bcodigocli,
				Bcodigo, BcodigoACH, Iaba, BcodigoSWIFT, BcodigoIBAN, BcodigoOtro,CEBSid, RFC, BancoExtranjero, plantillaDispersion
		FROM Bancos
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
	</cfquery>
</cfif>

<cfquery name="rsScriptsBancos" datasource="sifcontrol">
	select EIid,rtrim(EIcodigo) as EIcodigo, EIdescripcion
	from EImportador
	where EImodulo = 'sif.mb'
</cfquery>

<cfquery name="rsBancosSAT" datasource="#session.dsn#">
	select Id_Banco,Clave,Nombre_Corto
		from CEBancos
		where Ecodigo is null or Ecodigo = #Session.Ecodigo#
</cfquery>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</SCRIPT>

<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Bcodigo.required = false;
		objForm.Bdescripcion.required = false;
	}
	<!---Redireccion a CuentasBancarias o TCECuentasBancarias(Tarjetas de Credito)--->
	function Cuentas(data) {
		document.form1.action='<cfoutput>#LvarPaginaCtasBancos#</cfoutput>'<cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'><cfoutput>+'?desde=rh'</cfoutput></cfif>;
		document.form1.submit();
		return false;
	}
	<!---Redireccion Pagina Bancos o TCEBancos (Tarjetas de Credito)--->
	function Transacciones(data) {

		document.form1.action='<cfoutput>#LvarPaginaTranBancos#</cfoutput>';
		document.form1.submit();
		return false;
	}
	function CatalogoTCE() {
		document.form1.action='TCECatalogo.cfm';
		document.form1.submit();
		return false;
	}

</script>
<cfoutput>


<!---Redireccion SQLBancos.cfm o TCESQLBancos.cfm--->
<form method="post" name="form1" enctype="multipart/form-data" action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>">

	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/sif/generales.xml">Codigo</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Bcodigo" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsBanco.Bcodigo#</cfif>"
				size="20" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/sif/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="Bdescripcion" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsBanco.Bdescripcion#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_BancoExtranjero" XmlFile="/sif/generales.xml">Banco Extrajero</cf_translate>:&nbsp;</td>
			<td>
				<input type="checkbox" name="BancoExtranjero" tabindex="1"
				<cfif modo NEQ "ALTA" && rsBanco.BancoExtranjero eq 1>checked</cfif> onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td align="right" valign="top" nowrap><cf_translate key="LB_Direccion" XmlFile="/sif/generales.xml">Direcci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<textarea name="Bdireccion" cols="50" rows="3" onfocus="javascript:this.select();"  tabindex="1" ><cfif modo NEQ "ALTA">#trim(rsBanco.Bdireccion)#</cfif></textarea>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Telefono" XmlFile="/sif/generales.xml">T&eacute;lefono</cf_translate>:&nbsp;</td>
			<td>
				<input name="Btelefon" type="text" value="<cfif modo NEQ "ALTA">#trim(rsBanco.Btelefon)#</cfif>"
				size="30" maxlength="30" onfocus="javascript:this.select();"  tabindex="1" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Fax" XmlFile="/sif/generales.xml">Fax</cf_translate>:&nbsp;</td>
			<td>
				<input name="Bfax" type="text" value="<cfif modo NEQ "ALTA">#trim(rsBanco.Bfax)#</cfif>"
				size="30" maxlength="30" onfocus="javascript:this.select();"  tabindex="1" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Email" XmlFile="/sif/generales.xml">Email</cf_translate>:&nbsp;</td>
			<td>
				<input name="Bemail" type="text"  tabindex="1" value="<cfif modo NEQ "ALTA">#trim(rsBanco.Bemail)#</cfif>"
				size="50" maxlength="100" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td colspan="2">
				Códigos de Banco para Transferencias Interbancarias:
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CodigoACH" XmlFile="/sif/generales.xml">C&oacute;digo Nacional</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="BcodigoACH" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsBanco.BcodigoACH#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CodidgoAba">C&oacute;digo ABA</cf_translate>:&nbsp;</td>
			<td>
				<input name="Iaba" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#trim(rsBanco.Iaba)#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CodidgoSwift">C&oacute;digo SWIFT</cf_translate>:&nbsp;</td>
			<td>
				<input name="BcodigoSWIFT" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#trim(rsBanco.BcodigoSWIFT)#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CodidgoIban">C&oacute;digo IBAN</cf_translate>:&nbsp;</td>
			<td>
				<input name="BcodigoIBAN" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#trim(rsBanco.BcodigoIBAN)#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_CodidgoOtro">C&oacute;digo Especial</cf_translate>:&nbsp;</td>
			<td>
				<input name="BcodigoOtro" type="text" tabindex="1"
				value="<cfif modo NEQ "ALTA">#trim(rsBanco.BcodigoOtro)#</cfif>"
				size="50" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>

		<tr valign="baseline">
			<td align="right">
           		<cf_translate key="LB_Logobanco">Logo del Banco</cf_translate>:&nbsp;
			</td>
            <td>
             <cfif modo EQ "ALTA">
				<input name="archivo" type="file" tabindex="1"
				value=""
				size="50" maxlength="50" onfocus="javascript:this.select();" >
             <cfelse>
             	<cfset Blogo ="Blogo">
             	<cf_sifleerimagen autosize="true" border="false"  tabla="Bancos" campo="#Blogo#" condicion="Bid = #rsBanco.Bid#" conexion="#Session.DSN#" imgname="Img#Blogo#" width="70" height="70">
             </cfif>
			</td>
		</tr>

		<tr>
			<td align="right" nowrap><cf_translate key="LB_FormatoDeImpresion">Formato de Importaci&oacute;n</cf_translate>:&nbsp;</td>
			<td>
              <select name="EIid"  tabindex="1">
                <option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
                <cfloop query="rsScriptsBancos">
                  <!---  --->
                  <option value="#rsScriptsBancos.EIid#"
						<cfif (MODO neq "ALTA") and (trim(rsBanco.EIid) eq trim(rsScriptsBancos.EIid))>selected</cfif>
							>#rsScriptsBancos.EIdescripcion#</option>
                </cfloop>
              </select>
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><cf_translate key="LB_Codigo_de_Cliente">(*)C&oacute;digo de cliente:</cf_translate></td>
			<td><input type="text" name="Bcodigocli" maxlength="255" size="60" value="<cfif Modo NEQ 'ALTA'>#rsBanco.Bcodigocli#</cfif>"></td>
		</tr>
		<tr>
			<td align="right" nowrap><cf_translate key="LB_BancoSAT">C&oacute;digo SAT</cf_translate>:&nbsp;</td>
			<td>
              <select name="CEBSid"  tabindex="1">
                <option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
                <cfloop query="rsBancosSAT">
                  <!---  --->
                  <option value="#rsBancosSAT.Id_Banco#"
						<cfif (MODO neq "ALTA") and (trim(rsBanco.CEBSid) eq trim(rsBancosSAT.Id_Banco))>selected</cfif>
							>#rsBancosSAT.Clave# #rsBancosSAT.Nombre_Corto#</option>
                </cfloop>
              </select>
			</td>
		</tr>
			<tr>
			<td align="right" nowrap><cf_translate key="LB_RFC">RFC</cf_translate>:&nbsp;</td>
			<td>
				<input type="text" name="RFC" tabindex="1"
				value="<cfif modo NEQ "ALTA">#rsBanco.RFC#</cfif>"
				size="40" maxlength="20" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr>
			<td align="right" nowrap><cf_translate key="LB_PlantillaDispersion">Plantilla de Dispersi&oacute;n</cf_translate>:&nbsp;</td>
			<cfdirectory action="list" directory="#expandPath("../plantillas_dispersion")#" recurse="false" name="plantillasDispList">  
			<td>
              <select name="PlantillaDisp"  tabindex="1">
                <option value="">---<cf_translate key="CMB_SeleccioneUno" XmlFile="/sif/generales.xml">Seleccione Uno</cf_translate>---</option>
                  <!---  --->
				<cfloop query="plantillasDispList">
					<option value="#replace(plantillasDispList.name,".cfc","","all")#"
						<cfif (MODO neq "ALTA") and (trim(rsBanco.plantillaDispersion) eq trim(replace(plantillasDispList.name,".cfc","","all")))>selected</cfif>>
						#ucase(replace(plantillasDispList.name,"_disp.cfc","","all"))# 
					</option>
				</cfloop> 
              </select>
			</td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas"><cf_translate key="LB_ComplementoContable" XmlFile="/sif/generales.xml">Complementos Contables</cf_translate></td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="Bancos"
					form = "form1"
					llave="#Form.Bid#"
					 tabindex="2" />
			</td></tr>
		</cfif>
		<!--- *************************************************** --->
		<tr><td>&nbsp;</td></tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Agregar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Limpiar"/>

						<input type="submit" tabindex="3" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
						<input type="reset" tabindex="3" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Modificar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Eliminar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DeseaElimarElRegistro"
							Default="Desea Eliminar el Registro?"
							XmlFile="/sif/generales.xml"
							returnvariable="LB_DeseaElimarElRegistro"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							XmlFile="/sif/generales.xml"
							returnvariable="BTN_Nuevo"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_CuentasBancarias"
							Default="Cuentas Bancarias"
							returnvariable="BTN_CuentasBancarias"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_TransaccionesDelBanco"
							Default="Transacciones del Banco"
							returnvariable="BTN_TransaccionesDelBanco"/>

                            <cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_TarjetasCreditoEmpresarial"
							Default="Tarjetas de Cr&eacute;dito"
							returnvariable="BTN_TarjetasCreditoEmpresarial"/>

						<input tabindex="3" type="submit" name="Cambio" value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name; ">
						<input tabindex="3" type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#LB_DeseaElimarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
						<input tabindex="3" type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
						<input tabindex="3" type="button" name="CuentasB" value="#BTN_CuentasBancarias#" onClick="Cuentas(document.form1.Bid.value);">
						<!--- <input type="button" name="EQTransacciones" value="Equivalencias de Transacciones" onClick="Transacciones(document.form1.Bid.value);"> --->
                        <input tabindex="3" type="button" name="TransaccionesBAN" value="#BTN_TransaccionesDelBanco#" onClick="Transacciones(document.form1.Bid.value);">
                 		<br>
                        <!---
							Boton de catalogo de Tarjetas de Credito en caso que el el fuente sea invocado
							desde la opcion Tarjeta de Credito
						--->
                  		 <cfif isdefined("LvarTCEBancos")>
                    	 	<input tabindex="3" type="button" name="TarjetasCredito" value="#BTN_TarjetasCreditoEmpresarial#" onClick="CatalogoTCE();">
                   		</cfif>
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="2">
				<p>
					<strong>(*)</strong>  Código de uso interno del banco para identificación de la Empresa (Opcional)
				</p>
			</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="Bid" value="<cfif modo NEQ "ALTA">#rsBanco.Bid#</cfif>">
			<cfset ts = "">
			<cfif modo NEQ "ALTA">
				<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsBanco.ts_rversion#" returnvariable="ts">
				</cfinvoke>
			</cfif>
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
			<input tabindex="-1" name="desde" type="hidden" value="<cfif isdefined("form.desde")>#form.desde#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>
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
<cf_qforms>
	<cf_qformsRequiredField name="Bcodigo" description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Bdescripcion" description="#MSG_Descripcion#">
</cf_qforms>
