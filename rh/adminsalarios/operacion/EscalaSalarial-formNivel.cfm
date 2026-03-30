<cfset modoD = "ALTA">
<cfif isdefined("Form.DESlinea") and Len(Trim(Form.DESlinea))>
	<cfset modoD = "CAMBIO">
</cfif>

<cfquery name="rsListaNiveles" datasource="#Session.DSN#">
	select a.DESlinea, a.ESid, a.DESnivel, a.DESptodesde, a.DESptohasta, a.DESsalmin, a.DESsalmax, a.DESsalprom, a.fechaalta, a.BMUsucodigo,
		<cfif data.ESestado EQ 0>
		   case when a.DESptodesde = (
		      select max(DESptodesde)
			  from RHDEscalaSalHAY b
			  where b.ESid = a.ESid
		   ) then 
				'<img alt=#chr(34)#Eliminar Nivel#chr(34)# border=#chr(34)#0#chr(34)# src=#chr(34)#/cfmx/rh/imagenes/Borrar01_S.gif#chr(34)# onClick=#chr(34)#javascript:EliminarNivel(''' 
				|| <cf_dbfunction name="to_char" args="a.DESlinea" datasource="#session.DSN#"> ||''');#chr(34)# onMouseOver=#chr(34)#javascript: this.style.cursor = ''pointer''#chr(34)#>' 
		   else '&nbsp;'
		   end as iconoEliminar
		<cfelse>
		   '&nbsp;' as iconoEliminar
		</cfif>
	from RHDEscalaSalHAY a
	where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
</cfquery>

<cfquery name="nextPuntos" datasource="#Session.DSN#">
	select coalesce(max(DESptohasta)+1, 0) as puntos
	from RHDEscalaSalHAY 
	where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
</cfquery>

<cfquery name="nextSalario" datasource="#Session.DSN#">
	select coalesce(max(DESsalmax)+1, 0) as salario
	from RHDEscalaSalHAY 
	where ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
</cfquery>

<cfif modoD EQ "CAMBIO">
	<cfquery name="dataNivel" datasource="#Session.DSN#">
		select a.DESlinea, a.ESid, a.DESnivel, a.DESptodesde, a.DESptohasta, a.DESsalmin, a.DESsalmax, a.DESsalprom, a.fechaalta, a.BMUsucodigo
		from RHDEscalaSalHAY a
		where a.ESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ESid#">
		and a.DESlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DESlinea#">
	</cfquery>
</cfif>

<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="javascript" type="text/javascript">
	function EliminarNivel(n) {
		if (confirm('¿Está seguro de que desea eliminar el último nivel salarial?')) {
			document.form2.BajaD.value = '1';
			document.form2.DESlinea_del.value = n;
			inhabilitarValidaciones();
			document.form2.submit();
		}
	}
</script>

<cfoutput>
	<form name="form2" method="post" action="EscalaSalarial-sql.cfm" style="margin: 0;" onSubmit="javascript: if (window.validaForm) {return validaForm(this);}">
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
		<input type="hidden" name="BajaD" id="BajaD" value="0">
		<input type="hidden" name="DESlinea_del" id="DESlinea_del" value="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="6" class="tituloAlterno" nowrap>Niveles</td>
		  </tr>
		  <cfif data.ESestado EQ 0 OR (modoD EQ "CAMBIO" and data.ESestado NEQ 0)>
		  <tr>
			<td align="right" class="fileLabel" nowrap>Nivel:</td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#dataNivel.DESnivel#
					<input name="DESnivel" type="hidden" id="DESnivel" value="#dataNivel.DESnivel#">
				<cfelse>
					<input name="DESnivel" type="text" id="DESnivel" size="10" maxlength="3">
				</cfif>
			</td>
			<td align="right" class="fileLabel" nowrap>Puntos Iniciales: </td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#dataNivel.DESptodesde#
					<input name="DESptodesde" type="hidden" id="DESptodesde" value="#dataNivel.DESptodesde#">
				<cfelse>
					#nextPuntos.puntos#
					<input type="hidden" name="DESptodesde" id="DESptodesde" value="#nextPuntos.puntos#">
				</cfif>
			</td>
			<td align="right" class="fileLabel" nowrap>Puntos Finales: </td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#dataNivel.DESptohasta#
					<input name="DESptohasta" type="hidden" id="DESptohasta" value="#dataNivel.DESptohasta#">
				<cfelse>
					<input name="DESptohasta" type="text" id="DESptohasta" size="10" maxlength="10" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" class="fileLabel" nowrap>Salario M&iacute;nimo:</td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#LSNumberFormat(dataNivel.DESsalmin, ',9.00')#
					<input name="DESsalmin" type="hidden" id="DESsalmin" value="#LSNumberFormat(dataNivel.DESsalmin, ',9.00')#">
				<cfelse>
					<input name="DESsalmin" type="text" id="DESsalmin" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="#LSNumberFormat(nextSalario.salario, ',9.00')#">
				</cfif>
			</td>
			<td align="right" class="fileLabel" nowrap>Salario Medio:</td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#LSNumberFormat(dataNivel.DESsalprom, ',9.00')#
					<input name="DESsalprom" type="hidden" id="DESsalprom" value="#LSNumberFormat(dataNivel.DESsalprom, ',9.00')#">
				<cfelse>
					<input name="DESsalprom" type="text" id="DESsalprom" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</cfif>
			</td>
			<td align="right" class="fileLabel" nowrap>Salario M&aacute;ximo: </td>
			<td>
				<cfif modoD EQ "CAMBIO">
					#LSNumberFormat(dataNivel.DESsalmax, ',9.00')#
					<input name="DESsalmax" type="hidden" id="DESsalmax" value="#LSNumberFormat(dataNivel.DESsalmax, ',9.00')#">
				<cfelse>
					<input name="DESsalmax" type="text" id="DESsalmax" size="11" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;">
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="6" align="center">
				<cfif modoD EQ "CAMBIO">
					<cfif data.ESestado EQ 0>
						<input type="submit" name="NuevoD" id="NuevoD" value="Nuevo">
					</cfif>
				<cfelse>
					<input type="submit" name="AltaD" id="AltaD" value="Agregar">
				</cfif>
			</td>
		  </tr>
		  </cfif>
		</table>
	</form>
</cfoutput>
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaRet">
	<cfinvokeargument name="query" value="#rsListaNiveles#"/>
	<cfinvokeargument name="desplegar" value="DESnivel, DESptodesde, DESptohasta, DESsalmin, DESsalprom,DESsalmax,  iconoEliminar"/>
	<cfinvokeargument name="etiquetas" value="Nivel, P.Iniciales, P.Finales, Sal.Min., Sal.Med.,Sal.Max.,  &nbsp;"/>
	<cfinvokeargument name="formatos" value="V,I,I,M,M,M,IMG"/>
	<cfinvokeargument name="align" value="center, right, right, right, right, right, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
	<cfinvokeargument name="keys" value="DESlinea"/>
	<cfinvokeargument name="MaxRows" value="0"/>
	<cfinvokeargument name="formName" value="listaNiveles"/>
	<cfinvokeargument name="PageIndex" value="2"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
<!--- EXCEPCIONES DE NIVELES SALARIALES --->
<cfif modoD EQ "CAMBIO">
	<cfinclude template="EscalaSalarial-formExcepciones.cfm">
</cfif>


<cf_qforms form="form2" objForm="objForm2">
<script language="javascript" type="text/javascript">

	function __isPuntos() {
		if (this.required) {
			var a = parseInt(this.obj.form.DESptodesde.value, 10);
			var b = parseInt(this.value, 10);
			if (b <= a) {
				this.error = "El valor del campo Puntos Finales debe ser mayor al valor en el campo de Puntos Iniciales";
			}
		}
	}
	_addValidator("isPuntos", __isPuntos);

	function __isSalario() {
		if (this.required) {
			var a = parseFloat(qf(this.obj.form.DESsalmin.value));
			var b = parseFloat(qf(this.value));
			if (b <= a) {
				this.error = "El valor del campo Salario Máximo debe ser mayor al valor en el campo de Salario Mínimo";
			}
		}
	}
	_addValidator("isSalario", __isSalario);

	function inhabilitarValidacionesDet() {
		<!--- Solo para Escalas en Proceso y en modo cambio --->
		<cfif data.ESestado EQ 0>
			objForm2.DESnivel.required = false;
			objForm2.DESptohasta.required = false;
			objForm2.DESsalmin.required = false;
			objForm2.DESsalprom.required = false;
			objForm2.DESsalmax.required = false;
		</cfif>
	}

	<!--- Solo para Escalas en Proceso y en modo cambio --->
	<cfif data.ESestado EQ 0>
		function validaForm(f) {
			f.obj.DESsalmin.value = qf(f.obj.DESsalmin.value);
			f.obj.DESsalprom.value = qf(f.obj.DESsalprom.value);
			f.obj.DESsalmax.value = qf(f.obj.DESsalmax.value);
		}
	</cfif>	

	<!--- Solo para Escalas en Proceso y en modo cambio --->
	<cfif data.ESestado EQ 0>
		objForm2.DESnivel.required = true;
		objForm2.DESnivel.description = "Nivel";
		objForm2.DESptohasta.required = true;
		objForm2.DESptohasta.description = "Puntos Finales";
		objForm2.DESptohasta.validatePuntos();
		objForm2.DESsalmin.required = true;
		objForm2.DESsalmin.description = "Salario Mínimo";
		objForm2.DESsalprom.required = true;
		objForm2.DESsalprom.description = "Salario Medio";
		objForm2.DESsalmax.required = true;
		objForm2.DESsalmax.description = "Salario Máximo";
		objForm2.DESsalmax.validateSalario();
	</cfif>
	
</script>