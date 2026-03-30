<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonCambiar"
	Default="Modificar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonCambiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonBorrar"
	Default="Eliminar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonBorrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonNuevo"
	Default="Nuevo"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonNuevo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BotonAgregar"
	Default="Agregar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="BotonAgregar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Regresar"
	Default="Regresar"
	XmlFile="/sif/rh/generales.xml"
	returnvariable="Regresar"/>	
<!--- Asigna modos EIR y DIR --->
<cfif isDefined("Form.EIRid") and len(trim(Form.EIRid)) gt 0>
	<cfset emodo = "CAMBIO">
</cfif>
<cfif isDefined("Form.DIRid") and len(trim(Form.DIRid)) gt 0>
	<cfset dmodo = "CAMBIO">
</cfif>
<cfif not isdefined("Form.emodo")>
	<cfset emodo='ALTA'>
<cfelseif Form.emodo EQ "CAMBIO">
	<cfset emodo="CAMBIO">
<cfelse>
	<cfset emodo='ALTA'>
</cfif>
<cfif not isdefined("Form.dmodo")>
	<cfset dmodo='ALTA'>
<cfelseif Form.dmodo EQ "CAMBIO">
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfset dmodo='ALTA'>
</cfif>

<!--- Consultas EIR y DIR --->
<cfif emodo eq "CAMBIO">
	<cfquery name="rsEIR" datasource="sifcontrol">
		select EIRid, IRcodigo, EIRdesde, EIRhasta, EIRestado, ts_rversion 
		from EImpuestoRenta
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
	</cfquery>
</cfif>
<cfif dmodo eq "CAMBIO">
	<cfquery name="rsDIR" datasource="sifcontrol">
		select DIRid, EIRid, DIRinf, DIRsup, DIRporcentaje, DIRmontofijo,
		DIRporcexc, DIRmontoexc, ts_rversion 
		from DImpuestoRenta
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		and DIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DIRid#">
	</cfquery>
</cfif>
<cfif modo eq "CAMBIO">
	<cfquery name="rsEIRlista" datasource="sifcontrol">
		select EIRid, EIRdesde, EIRhasta, EIRestado, case EIRestado when 0 then 'Captura' when 1 then 'Listo' end as EIRestadodesc
		from EImpuestoRenta
		where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.IRcodigo#">
	</cfquery>
</cfif>
<cfif emodo eq "CAMBIO">
	<cfquery name="rsDIRlista" datasource="sifcontrol">
		select DIRid, DIRinf, DIRsup, DIRporcentaje, DIRmontofijo,DIRporcexc, DIRmontoexc
		from DImpuestoRenta
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
		order by DIRinf
	</cfquery>
	<cfquery name="rsMinimo" datasource="sifcontrol">
		select coalesce(max(DIRsup),0.00) + 1 as minimo <!---Si se pone 0.01 hay que cambiar la función isRango que está hecha para enteros.--->
		from DImpuestoRenta
		where EIRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIRid#">
	</cfquery>
</cfif>

<script language="JavaScript" type="text/javascript">
	function Deliminar(id) {
		if (confirm('¿Desea Eliminar el Rango de impuestos?')) {
			document.form.DIRid.value = id;
			document.form.Accion.value='DBaja';
			fnNoValidar();
			document.form.submit();
			return true;
		}
		return false;
	}
	function DModificar(id) {
		document.form.DIRid.value = id;
		document.form.Accion.value = 'DModificar';
		fnNoValidar();
		document.form.submit();
	}
	function Conceptos(opc) {	
		if (opc=='1')
			document.formDeduc.frame.value = 'IR';
		else {
			document.formDeduc.frame.value = 'CD';
		}
		document.formDeduc.submit();
	}
</script>
<table border="0" cellspacing="0" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">

<!--- DIR --->
<cfif emodo neq 'ALTA'>
  <tr><td nowrap colspan="3">
  <table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
  <tr> 
	<td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">Impuestos por Rango</td>
  </tr>
<cfif rsEIR.EIRestado neq 1>
  <tr bgcolor="FAFAFA"> 
	<td nowrap class="filelabel">&nbsp;Monto hasta :</td>
	<td nowrap class="filelabel">&nbsp;Porcentaje :</td>
	<td nowrap class="filelabel">&nbsp;Monto fijo :</td>
	<!---se agrega para uso de renta en El Salvador ljimenez--->
	<td nowrap class="filelabel">&nbsp;Porcentaje exceso :</td> 
	<td nowrap class="filelabel">&nbsp;Monto exceso :</td>
	<td nowrap class="filelabel">&nbsp;</td>
  </tr>
  <cfoutput>
  <tr>
    <td nowrap>
		<cfif dmodo neq 'ALTA'>
			&nbsp;<input name="DIRsup" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="#LSCurrencyFormat(rsDIR.DIRsup,'none')#" 
					tabindex="3" >&nbsp;
		<cfelse>
			&nbsp;<input name="DIRsup" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="0.00" tabindex="3" >&nbsp;
		</cfif>
	</td>
    <td nowrap>
		<cfif dmodo neq 'ALTA'>
			&nbsp;
			<input name="DIRporcentaje2" type="text" size="10" maxlength="6" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="#LSCurrencyFormat(rsDIR.DIRporcentaje,'none')#" 
					tabindex="3" />
			&nbsp;
			<cfelse>
			&nbsp;
			<input name="DIRporcentaje" type="text" size="10" maxlength="6" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="0.00" tabindex="3" >&nbsp;
		</cfif>
	</td>
    <td nowrap>
		<cfif dmodo neq 'ALTA'>
			&nbsp;<input name="DIRmontofijo" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="#LSCurrencyFormat(rsDIR.DIRmontofijo,'none')#" 
					tabindex="3" >&nbsp;
		<cfelse>
			&nbsp;<input name="DIRmontofijo" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="0.00" tabindex="3" >&nbsp;
		</cfif>
	</td>
	<!---se agrega para uso de renta en El Salvador ljimenez--->
	
	<td nowrap>
		<cfif dmodo neq 'ALTA'>
			&nbsp;
			<input name="DIRporcexc2" type="text" size="10" maxlength="6" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="#LSCurrencyFormat(rsDIR.DIRporcexc,'none')#" 
					tabindex="3" />
			&nbsp;
		<cfelse>
			&nbsp;<input name="DIRporcexc" type="text" size="10" maxlength="6" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="0.00" tabindex="3" >&nbsp;
		</cfif>
	</td>
	
	
	    <td nowrap>
		<cfif dmodo neq 'ALTA'>
			&nbsp;<input name="DIRmontoexc" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="#LSCurrencyFormat(rsDIR.DIRmontoexc,'none')#" 
					tabindex="3" >&nbsp;
		<cfelse>
			&nbsp;<input name="DIRmontoexc" type="text" size="20" maxlength="18" style="text-align: right"  
					onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  
					onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
					value="0.00" tabindex="3" >&nbsp;
		</cfif>
	</td>
	
	<!---fin campos El Salvador ljimenez--->
	
	
    <td nowrap>
		&nbsp;<input type="submit" alt="8" name='DAlta' 	value="#BotonAgregar#" onClick="javascript: return setBtn(this);" tabindex="3">
	</td>
	<cfif dmodo neq 'ALTA'>
		<input type="hidden" name="DIRid" value="#rsDIR.DIRid#">
	<cfelse>
		<input type="hidden" name="DIRid" value="">
	</cfif>
	<cfif dmodo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsDIR.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="DIRtimestamp" value="<cfoutput>#ts#</cfoutput>">
	</cfif>
  </tr>
  </cfoutput>
</cfif>
  </table>
  </td>
  </tr>
  <tr><td nowrap colspan="3">&nbsp;</td></tr>
  <tr><td nowrap colspan="3">
	<table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
		<tr bgcolor="FAFAFA"> 
			<td nowrap>&nbsp;</td>
			<td nowrap align="right">&nbsp;<b>Desde</b></td>
			<td nowrap align="right">&nbsp;<b>Hasta</b></td>
			<td nowrap align="right">&nbsp;<b>Porcentaje</b></td>
			<td nowrap align="right">&nbsp;<b>Monto Fijo</b></td>
			<td nowrap align="right">&nbsp;<b>Porcentaje Exceso</b></td>
			<td nowrap align="right">&nbsp;<b>Monto Exceso</b></td>
			
			<td nowrap>&nbsp;</td>
  		</tr>
		<cfoutput query="rsDIRlista">
		<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
			<td nowrap>&nbsp;
				<!--- <cfif dmodo neq "ALTA" and DIRid eq rsDIR.DIRid>
				<input name="btnDMarcar#DIRid#" type="image" alt="Elemento en edición" 
				onClick="javascript: return false;" src="/cfmx/rh/imagenes/Edita.gif" width="16" height="16">
				<cfelse>
				&nbsp;
				</cfif> --->
			</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRinf,'none')#</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRsup,'none')#</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRporcentaje,'none')#</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRmontofijo,'none')#</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRporcexc,'none')#</td>
			<td nowrap align="right">&nbsp;#LSCurrencyFormat(DIRmontoexc,'none')#</td>
			
			<td nowrap>
				<cfif rsEIR.EIRestado neq 1 and CurrentRow eq RecordCount>
				<input  name="btnDBorrar#DIRid#" type="image" alt="Eliminar elemento" 
				onClick="javascript: return Deliminar(#DIRid#);" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16">
				</cfif>
				
				<!--- 
				<input name="btnDEditar#DIRid#" type="image" alt="Editar elemento" 
				onClick="javascript: DModificar('#DIRid#');" src="/cfmx/rh/imagenes/Edit_o.gif" width="16" height="16"> --->
			</td>
		</tr>
		</cfoutput>
	</table>
</td></tr>
<tr><td nowrap colspan="3">&nbsp;</td></tr>
<cfif rsEIR.EIRestado neq 1>
<tr><td nowrap colspan="3" align="center"><input type="submit" alt="12" name="EAplicar" value="Aplicar" onClick="javascript: return setBtn(this);" tabindex="4"></td></tr>
<cfelse>
<tr><td nowrap colspan="3">
<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
<tr> 
	<td nowrap class="fileLabel">&nbsp;No se puede Modificar la Relación de Impuesto sobre la Renta porque ya fue Aplicada.</strong></td>
</tr>
</table>
</td></tr>
<tr><td nowrap colspan="3"></td></tr>
</cfif>
</cfif>
</table>
