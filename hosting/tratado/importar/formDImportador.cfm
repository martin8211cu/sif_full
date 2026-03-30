<cfif dmodo neq 'ALTA'>
	<cfquery name="rsDForm" datasource="sifcontrol">
		select DInumero, DInombre, DIdescripcion, DItipo, DIlongitud 
		from DImportador
		where EIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
		and DInumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DInumero#">
	</cfquery>
</cfif>

<!--- Consecutivo --->
<cfquery name="rsConsecutivo" datasource="sifcontrol">
	select isnull(max(DInumero),0)+1 as DInumero
	from DImportador
	where EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	and DInumero > 0
</cfquery>

<cfquery name="rsConsecutivoEx" datasource="sifcontrol">
	select isnull(min(DInumero),0)-1 as DInumero
	from DImportador
	where EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
	and DInumero < 0
</cfquery>

<cfoutput>
	<table border="0" width="80%" cellpadding="0" cellspacing="0" align="center">

		<tr>
			
			<td><cf_translate  key="LB_Tipo">Tipo</cf_translate>:<br>
				<select name="tipo" onChange="cambioTipo(this);" tabindex="1" >
				</select>
			</td>

			<td><cf_translate  key="LB_Numero">N&uacute;mero</cf_translate>:<br>
				<input name="DInumero" type="text" tabindex="1" value="<cfif dmodo neq 'ALTA'>#Trim(rsDForm.DInumero)#<cfelse>#rsConsecutivo.DInumero#</cfif>" size="12" maxlength="12" style="text-align: right;" onblur="javascript:fm(this,0); operacion();"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" alt="El N&uacute;mero" >
				<input type="hidden" name="hDInumero" value="<cfif dmodo neq 'ALTA'>#Trim(rsDForm.DInumero)#<cfelse>#rsConsecutivo.DInumero#</cfif>">
			</td>

			<td><cf_translate  key="LB_Nombre">Nombre</cf_translate>:<br>
				<input type="text" name="DInombre" size="30" maxlength="30" tabindex="1" value="<cfif dmodo neq 'ALTA'>#trim(rsDForm.DInombre)#</cfif>" onblur="javascript:nombre(this);" onfocus="this.select();" >
			</td>

			<td><cf_translate  key="LB_Descripcion">Descripci&oacute;n</cf_translate>:<br>
				<input type="text" name="DIdescripcion" size="40" maxlength="40" tabindex="1" value="<cfif dmodo neq 'ALTA'>#trim(rsDForm.DIdescripcion)#</cfif>" onfocus="this.select();" >
			</td>

			<td nowrap><cf_translate  key="LB_TipoDeDato">Tipo de dato</cf_translate>:<br>
  				<select name="DItipo" tabindex="1" onChange="javascript:vtipo(this.value)">
					<option value="datetime" <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'datetime'>selected</cfif> ><cf_translate  key="CMB_Datetime">datetime</cf_translate></option>
					<option value="float"    <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'float'>selected</cfif> ><cf_translate     key="CMB_float">float</cf_translate></option>
					<option value="int"      <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'int'>selected</cfif> ><cf_translate       key="CMB_int">int</cf_translate></option>
					<option value="money"    <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'money'>selected</cfif> ><cf_translate     key="CMB_money">money</cf_translate></option>
					<option value="numeric"  <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'numeric'>selected</cfif> ><cf_translate   key="CMB_numeric">numeric</cf_translate></option>
					<option value="varchar"  <cfif dmodo neq 'ALTA' and rsDForm.DItipo eq 'varchar'>selected</cfif> ><cf_translate   key="CMB_varchar">varchar</cf_translate></option>
				</select>
			
			</td>
			<td>&nbsp;</td>

			<td><cf_translate  key="LB_Longitud">Longitud</cf_translate>:<br>
				<input type="text" tabindex="1" name="DIlongitud" size="4" maxlength="4" value="<cfif dmodo neq 'ALTA'>#rsDForm.DIlongitud#<cfelse>12</cfif>" style="text-align: right;" onblur="javascript:fm(this,0); cero(); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" >
			</td>
			
			<input type="hidden" name="hIDInumero" value="#rsConsecutivo.DInumero#">
			<input type="hidden" name="hEDInumero" value="#rsConsecutivoEx.DInumero#">

		</tr>

	</table>
</cfoutput>

<script language="javascript1.2" type="text/javascript">

	function vtipo(value){
		if ( value == 'varchar' || value == 'numeric' ){
			validaDetalle(false);
		}
		else{
			objForm.DIlongitud.setValue("0");
			validaDetalle(true);
		}
	}
	
	function validaDetalle(value){
		if ( value == true ){
			<cfif dmodo neq 'ALTA'>
				objForm.DInumero.obj.disabled = true;
			</cfif>
		}
		else{
			objForm.DInumero.obj.disabled = value;
		}
		objForm.DIlongitud.obj.disabled = value;
	}
	
	function cero(){
		if ( trim(objForm.DIlongitud.getValue()) == '' ){
			objForm.DIlongitud.setValue("0");
		}
	}

	function nombre(obj){
		var result = '';	
		var datos = trim(obj.value).split(' ');
		for (var i=0; i<datos.length; i++){
			result += trim(datos[i]);
		}

		obj.value = trim(result);
	}
	
	function cambioTipo(obj){
		<cfif dmodo eq 'ALTA'>
			if ( document.form1.tipo.value == 1 ){
				document.form1.DInumero.value = document.form1.hEDInumero.value;
			}
			else{
				document.form1.DInumero.value = document.form1.hIDInumero.value;
			}
		<cfelse>
			n = Math.abs(parseInt(document.form1.DInumero.value));
			document.form1.DInumero.value = document.form1.tipo.value == 1 ? -n : +n;
		</cfif>
	}
	
	function operacion(){
		<cfif dmodo eq 'ALTA'>
			if ( document.form1.tipo.value == 1 ){
				if ( document.form1.DInumero.value.length > 0 && document.form1.DInumero.value.charAt(0) != '-' ){
					document.form1.DInumero.value = '-' + document.form1.DInumero.value;
				}
				else if(document.form1.DInumero.value.length == 0) {
					document.form1.DInumero.value = document.form1.hEDInumero.value;
				}
			}
			else if(document.form1.DInumero.value.length == 0) {
				document.form1.DInumero.value = document.form1.hIDInumero.value;			
			}
		</cfif>
	}
	
	function combo(){
			document.form1.tipo.length = 0;
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Columna"
			Default="Columna"
			returnvariable="LB_Columna"/>
			 
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Parametro"
			Default="Parámetro"
			returnvariable="LB_Parametro"/>
			
			
			document.form1.tipo.length += 1;
			document.form1.tipo.options[document.form1.tipo.length-1].value = 0;
			document.form1.tipo.options[document.form1.tipo.length-1].text  = '<cfoutput>LB_Columna</cfoutput>';
			<cfif dmodo NEQ "ALTA" and #rsDForm.DInumero# gt 0>
				document.form1.tipo.options[document.form1.tipo.length-1].selected=true;
			</cfif>
	
			if (document.form1.EIexporta.checked){
				document.form1.tipo.length += 1;
				document.form1.tipo.options[document.form1.tipo.length-1].value = 1;
				document.form1.tipo.options[document.form1.tipo.length-1].text  = '<cfoutput>LB_Parametro</cfoutput>';
				<cfif dmodo NEQ "ALTA" and #rsDForm.DInumero# lt 0>
					document.form1.tipo.options[document.form1.tipo.length-1].selected=true;
				</cfif>
			}
	}
	
</script>