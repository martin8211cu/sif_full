<cfquery name="rsListaExcepciones" datasource="#Session.DSN#">
	select a.DESlinea, a.Ecodigo, a.RHPcodigo, a.salmin, a.salmax, a.salprom, a.puntosactuales, a.fechaalta, a.BMUsucodigo,
		<cfif data.ESestado EQ 0>
			'<img alt=#chr(34)#Eliminar Nivel#chr(34)# border=#chr(34)#0#chr(34)# src=#chr(34)#/cfmx/rh/imagenes/Borrar01_S.gif#chr(34)# onClick=#chr(34)#javascript:EliminarExcepcion(''' 
			|| rtrim(a.RHPcodigo) ||''');#chr(34)# onMouseOver=#chr(34)#javascript: this.style.cursor = ''pointer''#chr(34)#>' as iconoEliminar
		<cfelse>
		   '&nbsp;' as iconoEliminar
		</cfif>
	from RHNivelesPuestoHAY a
	where a.DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea#">
</cfquery>

<script language="javascript" type="text/javascript">
	function EliminarExcepcion(n) {
		if (confirm('¿Está seguro de que desea eliminar la excepción para el nivel salarial actual?')) {
			document.form3.BajaExc.value = '1';
			document.form3.RHPcodigo_del.value = n;
			inhabilitarValidacionesExc();
			document.form3.submit();
		}
	}
</script>
<cfoutput>
	<form name="form3" method="post" action="EscalaSalarial-sql.cfm" style="margin: 0;" onSubmit="javascript: if (window.validaForm2) {return validaForm2(this);}">
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="ESid" id="ESid" value="#Form.ESid#">
		</cfif>
		<cfif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
			<input type="hidden" name="PageNum1" id="PageNum1" value="#Form.PageNum1#">
		</cfif>
		<cfif modoD EQ "CAMBIO">
			<input type="hidden" name="DESlinea" id="DESlinea" value="#Form.DESlinea#">
		</cfif>
		<cfif isdefined("Form.PageNum2") and Len(Trim(Form.PageNum2))>
			<input type="hidden" name="PageNum2" id="PageNum2" value="#Form.PageNum2#">
		</cfif>
		<input type="hidden" name="BajaExc" id="BajaExc" value="0">
		<input type="hidden" name="RHPcodigo_del" id="RHPcodigo_del" value="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="6" class="tituloAlterno">Excepciones al Nivel #dataNivel.DESnivel#</td>
		  </tr>
		  <cfif data.ESestado EQ 0>
		  <tr>
			<td class="fileLabel" align="right">Puesto:</td>
			<td colspan="5">
				<cf_rhpuesto form="form3">
			</td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Salario M&iacute;nimo:</td>
		    <td>
				<input name="salmin" type="text" id="salmin" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
			</td>
			<td class="fileLabel" align="right" nowrap>Salario Medio:</td>
		    <td>
				<input name="salprom" type="text" id="salprom" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
			</td>
		    <td class="fileLabel" align="right" nowrap>Salario M&aacute;ximo: </td>
		    <td>
				<input name="salmax" type="text" id="salmax" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
			</td>
		  </tr>
		  <tr align="center">
			<td colspan="6">
				<input type="submit" name="AgregarExc" value="Agregar">
			</td>
		  </tr>
		  <tr><td colspan="6">&nbsp;</td></tr>
		</cfif>
		</table>
	</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsListaExcepciones#"/>
	<cfinvokeargument name="desplegar" value="RHPcodigo, salmin,salprom, salmax,  iconoEliminar"/>
	<cfinvokeargument name="etiquetas" value="Puesto, Sal.Min., Sal.Medio.,Sal.Max.,  &nbsp;"/>
	<cfinvokeargument name="formatos" value="V,M,M,M,IMG"/>
	<cfinvokeargument name="align" value="left, right, right, right, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="DESlinea,Ecodigo,RHPcodigo"/>
	<cfinvokeargument name="MaxRows" value="0"/>
	<cfinvokeargument name="formName" value="listaExcepciones"/>
	<cfinvokeargument name="showLink" value="false"/>
	<cfinvokeargument name="PageIndex" value="3"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>

<cf_qforms form="form3" objForm="objForm3">
<script language="javascript" type="text/javascript">

	function __isSalario2() {
		if (this.required) {
			var a = parseFloat(qf(this.obj.form.salmin.value));
			var b = parseFloat(qf(this.value));
			if (b <= a) {
				this.error = "El valor del campo Salario Máximo debe ser mayor al valor en el campo de Salario Mínimo";
			}
		}
	}
	_addValidator("isSalario2", __isSalario2);

	function inhabilitarValidacionesExc() {
		<!--- Solo para Escalas en Proceso y en modo cambio --->
		<cfif data.ESestado EQ 0>
			objForm3.RHPcodigo.required = false;
			objForm3.salmin.required = false;
			objForm3.salprom.required = false;
			objForm3.salmax.required = false;
		</cfif>
	}

	<!--- Solo para Escalas en Proceso y en modo cambio --->
	<cfif data.ESestado EQ 0>
		function validaForm2(f) {
			f.obj.salmin.value = qf(f.obj.salmin.value);
			f.obj.salprom.value = qf(f.obj.salprom.value);
			f.obj.salmax.value = qf(f.obj.salmax.value);
		}
	</cfif>	
	
	<!--- Solo para Escalas en Proceso y en modo cambio --->
	<cfif data.ESestado EQ 0>
		objForm3.RHPcodigo.required = true;
		objForm3.RHPcodigo.description = "Puesto";
		objForm3.salmin.required = true;
		objForm3.salmin.description = "Salario Mínimo";
		objForm3.salprom.required = true;
		objForm3.salprom.description = "Salario Medio";
		objForm3.salmax.required = true;
		objForm3.salmax.description = "Salario Máximo";
		objForm3.salmax.validateSalario2();
	</cfif>

</script>
