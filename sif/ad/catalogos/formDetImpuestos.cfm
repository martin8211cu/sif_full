<!--- MODO: Definición del modo de acuerdo con la variable DIcodigo (Compone junto con Ecodigo e Icodigo la Llave Única de la Tabla DImpuestos)--->
<cfif isdefined("form.DIcodigo") and len(trim(form.DIcodigo)) >
	<cfset modo = 'CAMBIO'>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>
<!--- Datos del Impuesto --->
<cfquery name="rsDesImpuesto" datasource="#Session.DSN#">
	select Icodigo, Idescripcion
	from Impuestos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
</cfquery>
<!--- Impuestos no Compuestos --->
<cfif modo eq "ALTA">
  <cfquery name="rsImpuestos" datasource="#session.dsn#">
	select Icodigo, Idescripcion, Iporcentaje
	, (select min(CFcuenta) from CFinanciera where Ccuenta = a.Ccuenta) as CFcuenta
	, b.Cformato, Icompuesto, Icreditofiscal, a.ts_rversion 
	from Impuestos a
	left outer join CContables b
		on a.Ccuenta = b.Ccuenta
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Icompuesto = 0
	and Icodigo not in (
		select DIcodigo
		from DImpuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	)
  </cfquery>
</cfif>
<cfif modo NEQ 'ALTA'>
	<!--- Resultados en Modo Cambio de la Tabla DImpuestos --->
	<cfquery name="rsdata" datasource="#session.DSN#">
		select Icodigo, DIcodigo, DIdescripcion, DIporcentaje, Ccuenta, CFcuenta, DIcreditofiscal, ts_rversion 
		from DImpuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
			and DIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.DIcodigo#">
	</cfquery>
	<cfif rsdata.recordcount and rsdata.Ccuenta neq -1>
		<cfquery name="rsCuentas" datasource="#Session.DSN#">
			select Cmayor, CFformato, CFdescripcion, CFcuenta, Ccuenta
			  from CFinanciera
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif rsdata.CFcuenta NEQ "">
			   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.CFcuenta#">	
			<cfelse>
			   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdata.Ccuenta#">
			 order by CFcuenta
			</cfif>
		</cfquery>
	</cfif>
</cfif>
<SCRIPT language="JavaScript" type="text/JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfoutput>
<form style="margin:0;" name="form1" action="SQLDetImpuestos.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td align="right"><strong>Grupo:</strong>&nbsp;</td>
			<td>
				<label ><strong>#rsDesImpuesto.Icodigo#- #rsDesImpuesto.Idescripcion#</strong></label>
				<input type="hidden" name="Icodigo" value="#Form.Icodigo#">
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>Impuesto:</strong>&nbsp;</td>
			<td>
				<cfif modo eq "ALTA">
					<select name="DIcodigo" onChange="javascript:SugerirValores(this.value);" >
						<cfloop query="rsImpuestos">
							<option value="#Icodigo#"<cfif modo neq "ALTA" and rsdata.DIcodigo eq Icodigo>selected</cfif>>#Idescripcion#</option>
						</cfloop>
					</select>
				<cfelse>
					<input type="hidden" name="DIcodigo" value="#rsData.DIcodigo#">
					#rsdata.DIdescripcion#
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td align="right"><strong>Porcentaje:</strong>&nbsp;</td>
			<td>
				<input type="text" name="DIporcentaje" size="8" maxlength="8" value="<cfif modo neq 'ALTA'>#LSNumberFormat(rsdata.DIporcentaje,'9.00')#<cfelse>0.00</cfif>" style="text-align:right;" onblur="javascript:fm(this,2);" onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"  >	
			</td>
		</tr>

		<tr>
			<td align="right" nowrap ><strong>Cta. Financiera:</strong>&nbsp;</td>
			<td>
				<cfif modo EQ "ALTA" or rsdata.Ccuenta eq -1 or rsCuentas.RecordCount EQ 0>
					<cf_cuentas ccuenta="Ccuenta" CFcuenta="CFcuenta">
				<cfelse>
					<cf_cuentas ccuenta="Ccuenta" CFcuenta="CFcuenta" query="#rsCuentas#">
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td align="right">
				<input type="checkbox" name="DIcreditofiscal" value="<cfif modo NEQ "ALTA">#rsdata.DIcreditofiscal#</cfif>" <cfif modo NEQ "ALTA" and rsdata.DIcreditofiscal EQ "1">checked</cfif> >
			</td>
			<td><strong>Cr&eacute;dito Fiscal</strong></td>
		</tr>

		<tr>
			<td colspan="4">&nbsp;</td>
		</tr>

		<tr>
			<td colspan="4" align="center">
				<cf_botones modo="#modo#" include="Regresar" >
 			</td>
		</tr>
		<cfif modo neq "ALTA">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsdata.ts_rversion#" returnvariable="ts"></cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#"> 
		</cfif> 
	</table>
</form>
</cfoutput>

<script language="javascript1.2" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.DIcodigo.description="Código";
	objForm.DIporcentaje.description="Porcentaje";
	objForm.Ccuenta.description="Cuenta Contable";
	
	function habilitarValidacion(){
		objForm.DIcodigo.required = true;
		objForm.DIporcentaje.required = true;
		objForm.Ccuenta.required = true;
		objForm.allowsubmitonerror = false;
	}
	
	function deshabilitarValidacion(){
		objForm.DIcodigo.required = false;
		objForm.DIporcentaje.required = false;
		objForm.Ccuenta.required = false;
		objForm.allowsubmitonerror = true;
	}

	function funcRegresar() {
		if ('<cfoutput>#Form.Icodigo#</cfoutput>' != "") {
			document.form1.modo='CAMBIO';		
			document.form1.action='Impuestos.cfm';
			deshabilitarValidacion();
			return true;
		}
		return false;
	}
	
	<cfif modo eq "ALTA">
	function SugerirValores(DIcodigo){
	<cfoutput>
		<cfloop query="rsImpuestos">
			if ("#Icodigo#"==DIcodigo){
				//porcentaje
				document.form1.DIporcentaje.value = "#LSCurrencyFormat(Iporcentaje,'none')#";
				//creditofiscal
				document.form1.DIcreditofiscal.checked = #Icreditofiscal#;
				//cuentacontable 
				TraeCFcuentaTagCcuenta("#CFcuenta#");
				//descripción
			}
		</cfloop>
	</cfoutput>
	}
	</cfif>
	
	//objForm.onValidate = validaPorcentaje;
	habilitarValidacion();
	<cfif modo eq "ALTA">
		SugerirValores(objForm.DIcodigo.obj.value);
		objForm.DIcodigo.obj.focus();
	<cfelse>
		objForm.DIporcentaje.obj.focus();
	</cfif>
	
</script>