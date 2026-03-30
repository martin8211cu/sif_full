<cfset modo = "ALTA">
<cfif isdefined("form.CMIid") and len(trim(form.CMIid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select CMIid ,Ecodigo ,CMIcodigo ,CMIdescripcion ,CMIpeso  ,Usucodigo ,fechaalta  ,ts_rversion
		from CMIncoterm
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CMIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMIcodigo)#">
		  and CMIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#">		  
	</cfquery>
</cfif>

<cfquery name="dataCodigos" datasource="#session.DSN#" maxrows="100">
	select CMIcodigo
	from CMIncoterm
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfoutput>
<form name="form1" action="CMIncoterm-SQL.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input type="text" name="CMIcodigo" size="5" maxlength="5" <cfif modo neq 'ALTA'> readonly="true"<cfelse>onfocus="this.select();" onBlur="validaCodigo(this);"</cfif> value="<cfif modo neq 'ALTA'>#trim(data.CMIcodigo)#</cfif>"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="CMIdescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#trim(data.CMIdescripcion)#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<tr>
          <td align="right" nowrap><strong>Peso:</strong>&nbsp;</td>
          <td nowrap>
            <input type="text" name="CMIpeso" value="<cfif modo neq 'ALTA'>#data.CMIpeso#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,2); validaPeso(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
           </td>
	  </tr>

		<tr>
			<td align="right"></td>
			<td>&nbsp;
			</td>
		</tr>

		<!--- Botones --->
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" align="center">
		<cfif modo eq 'ALTA'>
			<input type="submit" name="Alta" value="Agregar" onClick="javascript: habilitarValidacion();">
			<input type="reset" name="Limpiar" value="Limpiar">
		<cfelse>
			<input type="submit" name="Cambio" value="Modificar" onClick="habilitarValidacion();">
			<input type="submit" name="Baja" value="Eliminar" onClick="if ( confirm('Desea eliminar el registro?') ){deshabilitarValidacion(); return true;} return false;">
			<input type="submit" name="Nuevo" value="Nuevo" onClick="deshabilitarValidacion();">
		</cfif>
		</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>

	</table>

	<cfif modo neq 'ALTA'>
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="CMIid" value="#data.CMIid#">
	</cfif>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CMIcodigo.required = true;
	objForm.CMIcodigo.description="Código";				
	objForm.CMIdescripcion.required= true;
	objForm.CMIdescripcion.description="Descripción";	

	<cfoutput>
		objForm.CMIcodigo.description="#JSStringFormat('Código')#";
		objForm.CMIdescripcion.description="#JSStringFormat('Descripción')#";
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.CMIcodigo.required = true;
		objForm.CMIdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CMIcodigo.required = false;
		objForm.CMIdescripcion.required = false;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	function validaPeso(obj){
	    var numero = new Number(qf(obj.value));
		if (numero > 100 && obj.value != ''){
			alert('El Peso no puede ser mayor que 100.00');
			obj.value = '';
			obj.focus();
			return
		}
	}

	function validaCodigo(obj){
		if ( trim(obj.value) != '' ){
			var valor = '';
			<cfoutput>
			<cfloop query="dataCodigos">
				valor = '#trim(dataCodigos.CMIcodigo)#'
				
				if ( trim(obj.value) == valor ){
					alert("Error. El código ya existe.");
					obj.value = '';
					return false;
				}
				
			</cfloop>
			</cfoutput>
		}
	}
</script>
