<cfset modo = "ALTA">
<cfif isdefined("form.CMTid") and len(trim(form.CMTid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>	
	<cfquery name="data" datasource="#session.DSN#">		
		select CMTid,CMTdesc,CMTentregaefec,CMTgestiorec,CMTeestiorecp,CMTefecentrega,ts_rversion
		from CMTipoAnalisis
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMTid#">
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" action="CMTipoAnalisis-SQL.cfm" method="post" onSubmit="javascript: return funcValidacion();">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="CMTdesc" size="50" maxlength="100" value="<cfif modo neq 'ALTA'>#trim(data.CMTdesc)#</cfif>" onfocus="this.select();"></td>
		</tr>		
		<tr>
          <td align="right" nowrap><strong>Entrega efectiva:</strong>&nbsp;</td>
          <td nowrap>
			<input size="6"  type="text" name="CMTentregaefec" value="<cfif modo neq 'ALTA'>#data.CMTentregaefec#<cfelse>0</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2); funcValidaPeso(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">            
	  	</tr>
		<tr>
          <td align="right" nowrap><strong>Gesti&oacute;n de reclamos por cantidad:</strong>&nbsp;</td>
          <td nowrap>
			<input size="5"  type="text" name="CMTgestiorec" value="<cfif modo neq 'ALTA'>#data.CMTgestiorec#<cfelse>0</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2); funcValidaPeso(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">            
	  	</tr>
		<tr>
          <td align="right" nowrap><strong>Gesti&oacute;n de reclamos por precio:</strong>&nbsp;</td>
          <td nowrap>
			<input size="5" type="text" name="CMTeestiorecp" value="<cfif modo neq 'ALTA'>#data.CMTeestiorecp#<cfelse>0</cfif>" style="text-align:right;" onBlur="javascript:fm(this,2); funcValidaPeso(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">            
	  	</tr>
		<!---
		<tr>
          <td align="right" nowrap><strong>Entregas efectivas:</strong>&nbsp;</td>
          <td nowrap>
			<input type="text" name="CMTefecentrega" value="<cfif modo neq 'ALTA'>#data.CMTefecentrega#<cfelse>0</cfif>" size="4" maxlength="4" style="text-align:right;" onBlur="javascript:fm(this,0);  validaPlazo(this);" onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">            
	  	</tr>
		---->
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
		<input type="hidden" name="CMTid" value="#trim(data.CMTid)#">
	</cfif>
	
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	objForm.CMTdesc.required = true;
	objForm.CMTdesc.description="Descripción";				
	function habilitarValidacion(){
		objForm.CMTdesc.required = true;
	}
	function deshabilitarValidacion(){
		objForm.CMTdesc.required = false;
	}	
	function funcValidaPeso(voObjeto){
		if (voObjeto.value > 100){
			alert("El peso no puede ser mayor a cien");
			return false;
		}
	}
	function funcValidacion(){
		if(document.form1.CMTentregaefec.value > 100){
			alert("El peso en la entrega efectiva no puede ser mayor a cien");
			return false;
		}
		if(document.form1.CMTgestiorec.value > 100){
			alert("El peso en la gestión de reclamos por cantidad no puede ser mayor a cien");
			return false;
		}
		if(document.form1.CMTeestiorecp.value > 100){
			alert("El peso en la gestión de reclamos por precio no puede ser mayor a cien");
			return false;
		}
		return true;
	}
</script>
