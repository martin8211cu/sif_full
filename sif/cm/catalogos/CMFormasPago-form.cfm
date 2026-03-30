<cfset modo = "ALTA">
<cfif isdefined("form.CMFPcodigo") and len(trim(form.CMFPcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select CMFPid, Ecodigo , CMFPcodigo,  CMFPdescripcion ,CMFPplazo ,Usucodigo  ,fechaalta ,ts_rversion 
		from CMFormasPago
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and CMFPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.CMFPcodigo)#">
	</cfquery>
</cfif>

<cfquery name="dataCodigos" datasource="#session.DSN#" maxrows="100">
	select CMFPcodigo
	from CMFormasPago
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and CMFPcodigo != <cfqueryparam cfsqltype="cf_sql_char" value="#trim(data.CMFPcodigo)#">
	</cfif>
</cfquery>


<cfoutput>
<form name="form1" action="CMFormasPago-SQL.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input type="text" name="CMFPcodigo" size="5" maxlength="5"  value="<cfif modo neq 'ALTA'>#trim(data.CMFPcodigo)#</cfif>" onfocus="this.select();" onBlur="validaCodigo(this);"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="CMFPdescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#trim(data.CMFPdescripcion)#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<tr>
          <td align="right" nowrap><strong>Plazo:</strong>&nbsp;</td>
          <td nowrap>
<input type="text" name="CMFPplazo" value="<cfif modo neq 'ALTA'>#data.CMFPplazo#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);  validaPlazo(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">            
<strong>D&iacute;as</strong></td>
           
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
		<input type="hidden" name="_CMFPcodigo" value="#trim(data.CMFPcodigo)#">
	</cfif>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CMFPcodigo.required = true;
	objForm.CMFPcodigo.description="Código";				
	objForm.CMFPdescripcion.required= true;
	objForm.CMFPdescripcion.description="Descripción";	

	<cfoutput>
		objForm.CMFPcodigo.description="#JSStringFormat('Código')#";
		objForm.CMFPdescripcion.description="#JSStringFormat('Descripción')#";
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.CMFPcodigo.required = true;
		objForm.CMFPdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.CMFPcodigo.required = false;
		objForm.CMFPdescripcion.required = false;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	function validaPlazo(obj){
	    var numero = new Number(qf(obj.value));
		if (numero > 1000 && obj.value != ''){
			alert('El plazo no puede ser mayor que 1000');
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
				valor = '#trim(dataCodigos.CMFPcodigo)#'
				
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
