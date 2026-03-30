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

<cfif isdefined('url.CIid') and url.CIid GT 0 and not isdefined('form.CIid')>
	<cfset form.CIid = url.CIid>
	<cfset modo = "CAMBIO">
<cfelseif isdefined('form.CIid')>
	<cfset modo = "CAMBIO">
</cfif>

<!--- CONSULTAS --->
<cfquery name="rsCodigos" datasource="#Session.DSN#">
	SELECT CIcodigo
	FROM CIncidentes
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CIcarreracp = 1
</cfquery> 

<!--- VERIFICA SI LA EMPRESA ES DE GUATEMALA PARA MOSTRAR OTROS DATOS --->
<cfquery name="rsEmpresa" datasource="#session.dsn#">
	select 1
	from Empresa e
		inner join Direcciones d
		on d.id_direccion = e.id_direccion
		and Ppais = 'GT'
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
</cfquery>

<cfset deshabilitar = false >
<cfif modo neq 'ALTA' >
	<cfquery name="rs" datasource="#Session.DSN#">
		select CIid, Ecodigo, CIcodigo, CIdescripcion, CIfactor, CItipo, CInegativo, CIcantmin, CIcantmax, 
		       CInorealizado, CInorenta, CInocargas, CInoanticipo, CInodeducciones, CIvacaciones, CIcuentac, CIredondeo, 
			   CIafectasalprom, CInocargasley, CIafectacomision, CItipoexencion, CIexencion, ts_rversion, coalesce(CSid, 0) as CSid,
			   Ccuenta, Cformato,CISumarizarLiq,CIMostrarLiq,CInopryrenta, CIclave, CIcodigoext, CInomostrar
		from CIncidentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">
	</cfquery>

	<cfquery name="ligados" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.CSid#">
		  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
	</cfquery>
	
	<cfif isdefined("rs.Ccuenta") and len(trim(rs.Ccuenta))>
		<cfquery name="rsCuenta" datasource="#session.DSN#">
			select a.Ccuenta, b.CFcuenta, a.Cformato
			from CContables a
				inner join CFinanciera b
					on a.Ccuenta = b.Ccuenta
					and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
				and a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ccuenta#">
		</cfquery>
	</cfif>
	
	<cfif ligados.recordcount gt 0 >
		<cfset deshabilitar = true >
	</cfif>
</cfif>

<!--- FIN CONSULTAS --->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>
<form name="form1" method="post" action="ConceptosPagoCP-sql.cfm" onsubmit="javascript: return validaForm(this);">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
    	<tr> 
			<td align="right" class="fileLabel">#LB_CODIGO#:</td>
			<td>
				<input name="CIcodigo" type="text" id="CIcodigo" size="5" maxlength="5" <cfif deshabilitar >readonly="readonly"</cfif>  
				value="<cfif modo NEQ "ALTA">#rs.CIcodigo#</cfif>" onfocus="this.select();"></td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">#LB_DESCRIPCION#:</td>
			<td><input name="CIdescripcion" type="text" id="CIdescripcion" size="50" maxlength="80"  <cfif deshabilitar >readonly="readonly"</cfif> value="<cfif modo NEQ "ALTA">#rs.CIdescripcion#</cfif>" onfocus="this.select();" /></td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel"><cf_translate key="LB_Factor">Factor</cf_translate>:</td>
			<td colspan="3"> <input name="CIfactor" type="text" id="CIfactor" size="18" maxlength="15" <cfif deshabilitar >readonly="readonly"</cfif> onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,5);"  onkeyup="if(snumber(this,event,5)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIfactor#<cfelse>1.00000</cfif>"></td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel" width="1%">#LB_METODO#:</td>
			<td colspan="3">
				<select name="CItipo" id="CItipo" <cfif deshabilitar >disabled="disabled"</cfif> onchange="javascript: activarPagosNoProcesados(this);">
					<option value="2" <cfif modo NEQ "ALTA" and rs.CItipo EQ 2>selected</cfif>><cf_translate  key="CItipo2">Importe</cf_translate></option>
					<option value="3" <cfif modo NEQ "ALTA" and rs.CItipo EQ 3>selected</cfif>><cf_translate  key="CItipo3">C&aacute;lculo</cf_translate></option>
				</select>
			</td>
		</tr>

      <!--- 	<tr> 
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_RangoMinimo">Rango M&iacute;nimo</cf_translate>:</td>
			<td width="13%" colspan="3"><input name="CIcantmin" type="text" id="CIcantmin2" size="18" <cfif deshabilitar >readonly="readonly"</cfif> maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#rs.CIcantmin#<cfelse>1.00</cfif>"></td>
      	</tr>
      	<tr> 
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_RangoMaximo">Rango M&aacute;ximo</cf_translate>:</td>
			<td colspan="3">
				<input name="CIcantmax" type="text" id="CIcantmax4" size="18" <cfif deshabilitar >readonly="readonly"</cfif> 
					maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  }
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" 
					value="<cfif modo NEQ "ALTA">#rs.CIcantmax#<cfelse>1.00</cfif>">
			</td>
      	</tr> --->
		<tr>
			<td align="right" class="fileLabel" nowrap ><cf_translate key="LB_ObjetoDeGasto">Objeto de Gasto</cf_translate>:</td>
			<td>
				<input name="CIcuentac" type="text"  value="<cfif modo NEQ "ALTA">#trim(rs.CIcuentac)#</cfif>" <cfif deshabilitar >readonly="readonly"</cfif> 
					size="50" maxlength="100" style="text-align:left" onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" onfocus="javascript:this.select();"  >			</td>
	  	</tr>
	  	<tr>
			<td align="right" class="fileLabel" nowrap ><cf_translate key="LB_CuentaContable">Cuenta Contable</cf_translate>:</td>
			<td>
				<cfif modo NEQ "ALTA" and isdefined("rsCuenta") and rsCuenta.RecordCount NEQ 0>
					<cf_cuentas query="#rsCuenta#" descwidth="10">
				<cfelse>
					<cf_cuentas descwidth="25">
				</cfif>			
			</td>
		</tr>
      	<tr>
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_TipoDeExencion">Tipo de Exenci&oacute;n</cf_translate>:</td>
			<td>
				<select name="CItipoexencion" id="CItipoexencion" onchange="javascript: chgExencion(this.value);">
				  <option value="0" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 0> selected</cfif>><cf_translate  key="CMB_NoAplica">(No Aplica)</cf_translate></option>
				  <option value="1" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 1> selected</cfif>><cf_translate  key="CMB_CantidadDeDias">Cantidad de d&iacute;as</cf_translate></option>
				  <option value="2" <cfif modo NEQ "ALTA" and rs.CItipoexencion EQ 2> selected</cfif>><cf_translate  key="CMB_Monto">Monto</cf_translate></option>
				</select>			</td>
      	</tr>
      	<tr id="trexencion" style="display: none;">
			<td align="right" class="fileLabel" nowrap><cf_translate key="LB_ValorExencion">Valor Exenci&oacute;n</cf_translate>:</td>
			<td>
				<div id="exencion1" style="display: none; ">
				<input name="CIexencion1" type="text" id="CIexencion1" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSNumberFormat(rs.CIexencion, '9')#<cfelse>0</cfif>">
				</div>
				<div id="exencion2" style="display: none; ">
				<input name="CIexencion2" type="text" id="CIexencion2" size="18" maxlength="15" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo NEQ "ALTA">#LSNumberFormat(rs.CIexencion, ',9.00')#<cfelse>0.00</cfif>">
				</div>			</td>
      	</tr>
	  	<cfif rsEmpresa.RecordCount NEQ 0>
			<tr>
				<td align="right" class="fileLabel"><cf_translate  key="LB_Clave">Clave</cf_translate>:&nbsp;</td>
				<td><input name="CIclave" type="text" size="6" maxlength="4" value="<cfif modo NEQ 'ALTA'>#rs.CIclave#</cfif>" /></td>
			</tr>
			<tr>
				<td align="right" class="fileLabel"><cf_translate  key="LB_CodigoExterno">C&oacute;digo Externo</cf_translate>:&nbsp;</td>
				<td><input name="CIcodigoext" type="text" size="6" maxlength="5" value="<cfif modo NEQ 'ALTA'>#rs.CIcodigoext#</cfif>" /></td>
			</tr>
		</cfif>
		<tr>
			<td>&nbsp;</td>
			<td>
				<table border="0" width="100%" cellpadding="0" cellspacing="3">
					<tr>
						<td><input alt="0" name="CInorealizado" type="checkbox" id="CInorealizado" value="0" <cfif modo NEQ "ALTA" and rs.CInorealizado EQ 1>checked</cfif> onclick="javascript: checkNorealizado(this,document.form1); checkMe(this,document.form1);"></td>
						<td nowrap colspan="3"><cf_translate key="CHK_PagosNoProcesados">Pagos No Procesados (Si el tipo de unidad es Importe)</cf_translate></td>
					</tr>
					<tr>
						<td><input alt="0" name="CIredondeo" type="checkbox" id="CIredondeo" value="0" <cfif modo NEQ "ALTA" and rs.CIredondeo EQ 1>checked</cfif> onclick="javascript: checkRedondeo(this,document.form1); checkMe(this,document.form1);"></td>
						<td nowrap colspan="3"><cf_translate key="CHK_ConceptoParaRedondeo">Concepto para Redondeo (Si el tipo de unidad es Importe)</cf_translate></td>
					</tr>	
					<tr> 
					  	<td width="1%"><input alt="1" name="CInorenta" type="checkbox" id="CInorenta" value="0" <cfif modo NEQ "ALTA" and rs.CInorenta EQ 1>checked</cfif> onclick="javascript: checkMe(this,document.form1);"></td>
						<td nowrap><cf_translate key="CHK_NoAplicaRenta">No Aplica Renta</cf_translate></td>
					</tr>
					<tr> 
					  	<td width="1%"> <input alt="2" name="CInocargas" type="checkbox" id="CInocargas" value="0" <cfif modo NEQ "ALTA" and rs.CInocargas EQ 1>checked</cfif> onclick="javascript: checkMe(this,document.form1);"></td>
						<td nowrap><cf_translate key="CHK_NoAplicaCargas">No Aplica Cargas</cf_translate> </td>
						<td> <input alt="3" name="CInodeducciones" type="checkbox" id="CInodeducciones" value="0" <cfif modo NEQ "ALTA" and rs.CInodeducciones EQ 1>checked</cfif> onclick="javascript: checkMe(this,document.form1);"></td>
						<td nowrap><cf_translate key="CHK_NoAplicaDeducciones">No Aplica Deducciones</cf_translate></td>
					</tr>
					<tr> 
						<td> <input alt="3" name="CIvacaciones" type="checkbox" id="CIvacaciones" value="0" <cfif modo NEQ "ALTA" and rs.CIvacaciones EQ 1>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_AfectaVacaciones">Afecta Vacaciones</cf_translate></td>
						<td> <input alt="3" name="CIafectasalprom" type="checkbox" id="CIafectasalprom" value="1" <cfif modo NEQ "ALTA" and rs.CIafectasalprom EQ 1>checked<cfelseif modo eq 'ALTA'>checked</cfif>></td>
						<td nowrap><cf_translate key="CHK_AfectaSalarioPromedio">Afecta Salario Promedio</cf_translate></td>
					</tr>
					<tr> 
						<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInocargasley eq 1>checked</cfif> name="CInocargasley" value="checkbox"></td>
						<td nowrap><cf_translate key="CHK_NoAplicaCargasDeLey">No aplica cargas de ley</cf_translate></td>
				  	  <td width="1%"><input alt="1" name="CInoanticipo" type="checkbox" id="CInoanticipo" value="0" <cfif modo NEQ "ALTA" and rs.CInoanticipo EQ 1>checked</cfif>></td>
						 <td nowrap><cf_translate key="CHK_CInoanticipo">Aplica Anticipo</cf_translate></td>
					</tr>
					<tr> 
						<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CIafectacomision eq 1>checked</cfif> name="CIafectacomision" value="checkbox"></td>
						<td nowrap><cf_translate key="CHK_AfectaComision">Afecta Comisi&oacute;n</cf_translate></td>
						<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInomostrar eq 1>checked</cfif> name="CInomostrar" value="1"></td>
						<td nowrap><cf_translate key="CHK_NoMostrarEnListas">No mostrar en listas</cf_translate></td>
					</tr>
					<tr> 
						<td nowrap><input type="checkbox" <cfif modo neq 'ALTA' and rs.CInopryrenta eq 1>checked</cfif> name="CInopryrenta" value="checkbox"></td>
						<td nowrap colspan="3"><cf_translate key="CHK_NoConsiderarParaProyeccionDeRentaCalculoNomina">No considerar para proyecci&oacute;n de Renta en el c&aacute;lculo de n&oacute;mina</cf_translate></td>
					</tr>
					<tr><td colspan="4">&nbsp;</td></tr>
					<tr>
						<td colspan="4">
							<fieldset><legend><cf_translate key="LB_Boleta_de_Liquidacion" >Boleta de Liquidaci&oacute;n</cf_translate></legend>
							<table width="100%" border="0">
								<tr>
								  <td><input name="CISumarizarLiq" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CISumarizarLiq EQ '1'> checked </cfif>>
								  <cf_translate  key="CHK_No_sumarizar_y_mostrar_en_detalle_de_liquidacion">No sumarizar y mostrar en detalle de la liquidaci&oacute;n</cf_translate></td>
								</tr>
								<tr>
								  <td><input name="CIMostrarLiq" type="checkbox" tabindex="1"  <cfif  modo neq 'ALTA' and rs.CIMostrarLiq EQ '1'> checked </cfif>>
								  <cf_translate  key="CHK_Mostrar_en_area_otros_rubros_especiales">Mostrar en &aacute;rea otros rubros especiales</cf_translate></td>
								</tr>
							</table>
							</fieldset>					  	</td>
					</tr>					  
				</table>			</td>
		</tr>
		<tr> 
        	<td colspan="4" align="center"> 
				<cfset Lvar_BExcluir = ''>
				<cfset Lvar_BIncluir = ''>
				<cfif modo NEQ "ALTA" and rs.CItipo EQ 3><cfset Lvar_BIncluir = 'Formular'></cfif>
				<cfif modo eq 'CAMBIO'><cfif deshabilitar><cfset Lvar_BExcluir ='Baja'></cfif></cfif>
				<cf_botones modo="#modo#" exclude="#Lvar_BExcluir#" include="#Lvar_BIncluir#">
			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts"></cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="CIid" value="#rs.CIid#">
	</cfif>
	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">

<!--- para mantener la navegacion --->
<cfif isdefined("Form.FCIcodigo") and Len(Trim(Form.FCIcodigo)) NEQ 0>
	<input type="hidden" name="FCIcodigo" value="#form.FCIcodigo#" >
</cfif>

<cfif isdefined("Form.FCIdescripcion") and Len(Trim(Form.FCIdescripcion)) NEQ 0>
	<input type="hidden" name="FCIdescripcion" value="#form.FCIdescripcion#" >
</cfif>

<cfif isdefined("Form.fMetodo") and Len(Trim(Form.fMetodo)) gt 0>
	<input type="hidden" name="fMetodo" value="#form.fMetodo#" >
</cfif> 

</form>

</cfoutput>

<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function validaForm(f) {
		f.obj.CIfactor.value = qf(f.obj.CIfactor.value);
		f.obj.CIexencion1.value = qf(f.obj.CIexencion1.value);
		f.obj.CIexencion2.value = qf(f.obj.CIexencion2.value);
		return true;
	}

	function chgExencion(tipoexencion) {
		var trex = document.getElementById("trexencion");
		var a = document.getElementById("exencion1");
		var b = document.getElementById("exencion2");
		switch(tipoexencion) {
			case '0': trex.style.display = 'none';
					  a.style.display = 'none'; 
					  b.style.display = 'none'; 
					  break;

			case '1': trex.style.display = '';
					  a.style.display = ''; 
					  b.style.display = 'none'; 
					  break;

			case '2': trex.style.display = '';
					  a.style.display = 'none'; 
					  b.style.display = ''; 
					  break;
		}
	}

	function checkNorealizado(obj, form) {
		// checks excluyentes 	
		if (obj.checked ) {
			form.CIredondeo.checked = false;
		}
	}

	function checkRedondeo(obj, form) {
		// checks excluyentes 	
		if (obj.checked ) {
			form.CInorealizado.checked = false;
		}
	}

	function checkMe(button, form) {
		if (button.alt==0) {

			if (form.CInorealizado.checked || form.CIredondeo.checked ) {
				form.CInorenta.checked = true;
				form.CInocargas.checked = true;
				form.CInodeducciones.checked = true;
			}
		}
		else{
			form.CInorealizado.checked = false;
			form.CIredondeo.checked = false;
		}
	}
	
	//-->

	function deshabilitarValidacion(){
		objForm.CIcodigo.required = false;
		objForm.CIcodigo.validate = false;
		objForm.CIdescripcion.required = false;
	}

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	function _Field_isExiste(){
		var existe = new Boolean;
		existe = false;
		<cfoutput query="rsCodigos">
			if (
				'#CIcodigo#'.toUpperCase( )==this.value.toUpperCase( )
				<cfif modo NEQ "ALTA">&&'#rs.CIcodigo#'.toUpperCase( )!=this.value.toUpperCase( )</cfif>
				)
					existe = true;
		</cfoutput>
		if (existe){this.error="El campo "+this.description+"<cfoutput>#MSG_ContieneUnValorQueYaExisteDebeDigitarUnoDiferente#</cfoutput>";}
	}
	_addValidator("isExiste", _Field_isExiste);

	objForm.CIcodigo.required = true;
	objForm.CIcodigo.description = "<cfoutput>#MSG_CodigoDeTipoDeIncidencia#</cfoutput>";
	objForm.CIcodigo.validateExiste();
	objForm.CIcodigo.validate=true;
	objForm.CIdescripcion.required = true;
	objForm.CIdescripcion.description = "<cfoutput>#MSG_DescripcionDeIncidencia#</cfoutput>";
	objForm.CIfactor.required = true;
	objForm.CIfactor.description = "<cfoutput>#MSG_Factor#</cfoutput>";
	<cfif modo NEQ "ALTA">
		fm(objForm.obj.CIfactor, 5);
	</cfif>
	
	objForm.CIcodigo.obj.focus();
	chgExencion(document.form1.CItipoexencion.value);
	objForm.CIvacaciones.obj.disabled = true;

	function activarPagosNoProcesados(obj) {
		//Activa desactiva CheckBox de Pagos No Procesados
		if (obj.value==2) {
			objForm.CInorealizado.obj.disabled = false;
			objForm.CIredondeo.obj.disabled = false;
		}
		else {
			objForm.CInorealizado.obj.checked = false;
			objForm.CInorealizado.obj.disabled = true;

			objForm.CIredondeo.obj.checked = false;
			objForm.CIredondeo.obj.disabled = true;
		}
		//Activa desactiva CheckBox de Afecta Vacaciones
		if (obj.value==3) {
			objForm.CIvacaciones.obj.disabled = false;
		}
		else {
			objForm.CIvacaciones.obj.checked = false;
			objForm.CIvacaciones.obj.disabled = true;
		}
	}
	
	function funcFormular(){
		document.form1.action="../../admin/catalogos/TiposIncidencia-formular.cfm?Regresar=../../carreraProfesional/catalogos/ConceptosPagoCP.cfm";
	}
</script>
