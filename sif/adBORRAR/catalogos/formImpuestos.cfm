<!--- MODO: Definición del modo de acuerdo con la variable Icodigo (Compone junto con Ecodigo la Llave Única de la Tabla Impuestos)--->
<cfif isdefined("form.Icodigo") and len(trim(form.Icodigo)) >
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>
<cfif modo NEQ 'ALTA'>
	<!--- Resultados en Modo Cambio de la Tabla Impuestos --->
	<cfquery name="rsdata" datasource="#session.DSN#">
		select Icodigo,Idescripcion, Iporcentaje, 
		coalesce(Ccuenta,-1) as Ccuenta, 
		coalesce(CcuentaCxC,-1) as CcuentaCxC, 
		coalesce(CcuentaCxCAcred,-1) as CcuentaCxCAcred, 
		coalesce(CcuentaCxPAcred,-1) as CcuentaCxPAcred, 
		Icompuesto, Icreditofiscal,
		InoRetencion, ts_rversion 
		from Impuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	</cfquery>
	<cfif rsdata.Icompuesto neq 0>
		<cfquery name="rsComponentes" datasource="#session.DSN#">
			select Ecodigo, Icodigo, DIcodigo, DIporcentaje, DIdescripcion, 
				case DIcreditofiscal when 0 then '<img border=''0'' src=''/cfmx/sif/imagenes/unchecked.gif''>' 
				else '<img border=''0'' src=''/cfmx/sif/imagenes/checked.gif''>' end as DIcreditofiscal, 
				Ccuenta, Usucodigo, DIfecha
			from DImpuestos	
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
			order by DIcodigo, DIdescripcion
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxC --->
	<cfif rsdata.recordcount and rsdata.CcuentaCxC neq -1>
		<cfquery name="rsCuentasCXC" datasource="#Session.DSN#">
			select Cmayor, Cformato, Cdescripcion, Ccuenta as CcuentaCxC
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxC#">	
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxCAcred--->
	<cfif rsdata.recordcount and rsdata.CcuentaCxCAcred neq -1>
		<cfquery name="rsCuentasCxCAcred" datasource="#Session.DSN#">
			select Cmayor, Cformato, Cdescripcion, Ccuenta  as CcuentaCxCAcred
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxCAcred#">	
		</cfquery>
	</cfif>
	<!--- Cuenta Contable CcuentaCxPAcred--->
	<cfif rsdata.recordcount and rsdata.CcuentaCxPAcred neq -1>
		<cfquery name="rsCuentasCxPAcred" datasource="#Session.DSN#">
			select Cmayor, Cformato, Cdescripcion, Ccuenta  as CcuentaCxPAcred
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CcuentaCxPAcred#">	
		</cfquery>
	</cfif>
	<!--- Cuenta Contable --->
	<cfif rsdata.recordcount and rsdata.Ccuenta neq -1>
		<cfquery name="rsCuentas" datasource="#Session.DSN#">
			select Cmayor, Cformato, Cdescripcion, Ccuenta 
			from CContables
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.Ccuenta#">	
		</cfquery>
	</cfif>		
</cfif>
<script language="JavaScript" type="text/JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfoutput>
<form style="margin:0;" name="form1" action="SQLImpuestos.cfm" method="post" onSubmit="javascript:habilitarCampos();">
  <table width="100%" cellpadding="2" cellspacing="0" border="0" >
    <tr>
      <td align="right" width="20%"><strong>C&oacute;digo:</strong>&nbsp;</td>
      <td>
        <input type="text" name="Icodigo" size="5" maxlength="5"  <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo neq 'ALTA'>#rsdata.Icodigo#</cfif>" onFocus="this.select();">
      </td>
      <td align="right">
        <input type="checkbox" name="Icompuesto" onClick="javascript:validaCheck(this.checked); " value="<cfif modo NEQ "ALTA">#rsdata.Icompuesto#</cfif>" <cfif modo NEQ "ALTA" and rsdata.Icompuesto EQ "1">checked</cfif> >
        <cfif modo neq 'ALTA'>
          <input type="hidden" name="IcompuestoX" value="#rsdata.Icompuesto#">
        </cfif>
      </td>
      <td><strong>Compuesto</strong></td>
    </tr>
    <tr>
      <td align="right" ><strong>Descripci&oacute;n:</strong>&nbsp;</td>
      <td colspan="3"><input type="text" name="Idescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#rsdata.Idescripcion#</cfif>" onFocus="this.select();"></td>
    </tr>
    <tr>
      <td align="right"><strong>Porcentaje:</strong>&nbsp;</td>
      <td colspan="3">
        <input type="text" name="Iporcentaje" size="8" maxlength="8" value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsdata.Iporcentaje,'9.00')#<cfelse>0.00</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
      </td>
    </tr>
    <tr id="tr2">
      <td align="right">
        <input type="checkbox" name="Icreditofiscal" value="<cfif modo NEQ "ALTA">#rsdata.Icreditofiscal#</cfif>" <cfif modo NEQ "ALTA" and rsdata.Icreditofiscal EQ "1">checked</cfif> >
      </td>
      <td><strong>Cr&eacute;dito Fiscal</strong></td>
       <td align="right">
        <input type="checkbox" name="InoRetencion" value="1" <cfif modo NEQ "ALTA" and rsdata.InoRetencion EQ "1">checked</cfif> >
      </td>
      <td><strong>No aplicar Retención</strong></td>
   </tr>	
	<tr id="tr1">
		<td  colspan="5" nowrap="nowrap" >
			<fieldset><legend>Cuentas Contables de Impuestos</legend>
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Proveedor </strong></td>
				</tr>	
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA">
					  <cf_cuentas>
					<cfelse>
						<cfif rsdata.Ccuenta neq -1 and rsCuentas.RecordCount GT 0>
							<cf_cuentas query="#rsCuentas#">
						<cfelse>
							<cf_cuentas>
						</cfif>		
					</cfif>
				  </td>
				</tr>
				<!--- ********************************************* --->
				<!--- ***** Se agregar 3 nuevas cuentas    ******** --->
				<!--- ********************************************* --->
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Proveedor </strong><strong>Acreditadas</strong></td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA">
					  <cf_cuentas ccuenta="CcuentaCxPAcred" CFcuenta="CFcuentaCxPAcred">
					<cfelse>
						<cfif rsdata.CcuentaCxPAcred neq -1 and rsCuentasCxPAcred.RecordCount GT 0>
							<cf_cuentas ccuenta="CcuentaCxPAcred" CFcuenta="CFcuentaCxPAcred" query="#rsCuentasCxPAcred#" tabindex="1">
			
						<cfelse>
							<cf_cuentas ccuenta="CcuentaCxPAcred" CFcuenta="CFcuentaCxPAcred">
						</cfif>		
					</cfif>
				  </td>
				</tr>				
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Cliente </strong></td>
				</tr>	
				<tr id="tr1C">
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA">
					  <cf_cuentas ccuenta="CcuentaCxC" CFcuenta="CFcuentaCxC">
					<cfelse>
						<cfif rsdata.CcuentaCxC neq -1 and rsCuentasCXC.RecordCount GT 0>
							<cf_cuentas ccuenta="CcuentaCxC" CFcuenta="CFcuentaCxC" query="#rsCuentasCXC#" tabindex="1">
						<cfelse>
							<cf_cuentas ccuenta="CcuentaCxC" CFcuenta="CFcuentaCxC">
						</cfif>		
					</cfif>
				  </td>
				</tr>
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td  colspan="4" nowrap="nowrap" align="left"><strong>Facturas Cliente </strong><strong>Acreditadas</strong></td>
				</tr>	
				<tr>
				  <td  nowrap="nowrap" align="right">&nbsp;</td>
				  <td colspan="3">
					<cfif modo EQ "ALTA">
					  <cf_cuentas ccuenta="CcuentaCxCAcred" CFcuenta="CFcuentaCxCAcred">
					<cfelse>
						<cfif rsdata.CcuentaCxCAcred neq -1 and rsCuentasCxCAcred.RecordCount GT 0>
							<cf_cuentas ccuenta="CcuentaCxCAcred" CFcuenta="CFcuentaCxCAcred" query="#rsCuentasCxCAcred#" tabindex="1">
						<cfelse>
							<cf_cuentas ccuenta="CcuentaCxCAcred" CFcuenta="CFcuentaCxCAcred">
						</cfif>		
					</cfif>
				  </td>
				</tr>	
				
			</table>
			</fieldset>
		</td>
	</tr>
  	<!--- ********************************************* --->
	<!--- ********************************************* --->

    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" align="center">
        <cfif modo EQ 'CAMBIO' and rsdata.Icompuesto EQ 1>
          <cf_botones modo="#modo#" include="ImpuestosCompuestos" includevalues="Impuestos Compuestos">
          <cfelse>
          <cf_botones modo="#modo#">
        </cfif>
      </td>
    </tr>
    <cfif modo neq "ALTA">
      <cfset ts = "">
      <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsdata.ts_rversion#" returnvariable="ts">
      </cfinvoke>
      <input type="hidden" name="ts_rversion" value="#ts#">
    </cfif>
    <!---<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">	--->
  </table>
</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	<!--//
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.Icodigo.description="Código";
	objForm.Idescripcion.description="Descripción";
	objForm.Iporcentaje.description="Porcentaje";
	objForm.Ccuenta.description="Cuenta Contable";

	function habilitarValidacion(){	
		objForm.Icodigo.required = true;
		objForm.Idescripcion.required = true;
		objForm.Iporcentaje.required = true;
		if (document.form1.Icompuesto.checked == false) {
			objForm.Ccuenta.required = true;
		}
		else {
			objForm.Ccuenta.required = false;
		}		
		if (objForm.Icodigo.obj.disabled==false){
			objForm.Icodigo.obj.focus();
		}
		else {
			objForm.Idescripcion.obj.focus();
		}
	}
	
	function deshabilitarValidacion(){
		objForm.Icodigo.required = false;
		objForm.Idescripcion.required = false;
		objForm.Iporcentaje.required = false;
		objForm.Ccuenta.required = false;
	}
	
	function mostrarDatos(value){
		document.getElementById("tr1").style.display = ( value ? 'none' : '' );
		document.getElementById("tr2").style.display = ( value ? 'none' : '' );
		document.form1.Iporcentaje.disabled = value;
	}
	
	<cfif modo neq 'ALTA'>
		mostrarDatos(<cfoutput>#rsdata.Icompuesto#</cfoutput>);
	</cfif>
	
	<cfif modo neq 'ALTA'>
		function funcImpuestosCompuestos() {
			if ('<cfoutput>#rsdata.Icodigo#</cfoutput>' != "") {
				document.form1.action = 'DetImpuestos.cfm';
				return true;
			}
			return false;
		}
	</cfif>
	
	function validaCheck(value) {
		if (document.form1.Icreditofiscal.checked == true) {
			alert("Desmarque el Crédito Fiscal para poder crear un Impuesto Compuesto.");
			document.form1.Icompuesto.checked = false;
			return false;
		}
		else {
			mostrarDatos(value);
		}
	}
	
	function habilitarCampos() {
		document.form1.Icodigo.disabled = false;
	}
	
	habilitarValidacion();
	//-->
</script>
<cfif modo neq "ALTA" and rsdata.Icompuesto neq 0>
  <table width="99%">
	<tr>
		<td align="center" class="SubTitulo">Componentes del Impuesto</td>
	</tr>
	<tr>
		<td>
		  <cfinvoke 
			 component="sif.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsComponentes#"/>
			<cfinvokeargument name="desplegar" value="DIcodigo, DIdescripcion, DIporcentaje, DIcreditofiscal"/>
			<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n, Porcentaje, C.F."/>
			<cfinvokeargument name="formatos" value="S,S,M,S"/>
			<cfinvokeargument name="align" value="left,left,right,right"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="showLink" value="False"/>
			<cfinvokeargument name="totales" value="DIporcentaje"/>
			<cfinvokeargument name="formname" value="lista2"/>
			<cfinvokeargument name="pageindex" value="2"/>
		  </cfinvoke>
		</td>
	</tr>
  </table>
</cfif>