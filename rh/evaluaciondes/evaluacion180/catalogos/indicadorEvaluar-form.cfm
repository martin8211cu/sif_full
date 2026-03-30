<cfset modo = 'ALTA'>
<cfif isdefined("form.IAEid") and len(trim(form.IAEid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo eq 'CAMBIO'>
	<cfquery name="data" datasource="#session.DSN#">
		select IAEid, IAEcodigo, IAEdescripcion, IAEpesop, IAEtipoconc, IAEpregunta, IAEevaluajefe, IAEevaluasubjefe, ts_rversion
		from RHIndicadoresAEvaluar
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and IAEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IAEid#">
		order by IAEcodigo, IAEdescripcion
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"
	xmlfile="/rh/generales.xml"
	returnvariable="vCodigo"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	xmlfile="/rh/generales.xml"
	returnvariable="vDescripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluar_por"
	Default="Evaluar por"
	returnvariable="vEvaluar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Peso"
	Default="Peso"
	returnvariable="vPeso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Jefe_lo_evalua"
	Default="Jefe lo evalua"
	returnvariable="vJefe"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evalua_a_subalternos_que_son_jefes"
	Default="Evalua a subalternos que son jefes"
	returnvariable="vSubJefe"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pregunta"
	Default="Pregunta"
	returnvariable="vPregunta"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Desea_eliminar_el_registro"
	Default="Desea eliminar el registro"
	xmlfile="/rh/generales.xml"	
	returnvariable="vEliminar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tabla_de_Evaluacion"
	Default="Tabla de Evaluaci&oacute;n"
	returnvariable="vTabla"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Abierta"
	Default="Abierta"
	returnvariable="vAbierta"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Eliminar"
	Default="Eliminar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Eliminar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>
		

<script language="javascript1.2" type="text/javascript">
</script>

<cfoutput>
<form name="form1" method="post" action="indicadorEvaluar-sql.cfm" style="margin:0;">
	<cfif modo neq 'ALTA'>
	  <input type="hidden" id="IAEid" name="IAEid" value="#form.IAEid#">
	</cfif>
	
	<table width="100%" border="0" cellpadding="3" cellspacing="0">
		<tr> 
			<td align="right" nowrap>#vCodigo#:&nbsp;</td>
			<td nowrap>
				<input name="IAEcodigo" type="text" id="IAEcodigo" size="10" tabindex="1" maxlength="10" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(data.IAEcodigo)#</cfoutput></cfif>">
			</td>
		</tr>	
		<tr> 
			<td align="right" nowrap>#vDescripcion#:&nbsp;</td>
			<td nowrap>
				<input name="IAEdescripcion" type="text" id="IAEdescripcion" size="50" tabindex="1" maxlength="50" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(data.IAEdescripcion)#</cfoutput></cfif>">
			</td>
		</tr>	
			
		<tr>
			<td align="right" nowrap>#vEvaluar#</td>
			<td>
				<select name="IAEtipoconc" id="IAEtipoconc" tabindex="1" onchange="javascript:funcCambiar(this.value);">
					<option value="T" <cfif modo NEQ 'ALTA' and data.IAEtipoconc EQ 'T'>selected</cfif>>#vTabla#</option>
					<option value="A" <cfif modo NEQ 'ALTA' and data.IAEtipoconc EQ 'A'>selected</cfif>>#vAbierta#</option>
				</select>
			</td>
		</tr>				

		<tr id="tr_peso"> 
			<td align="right" nowrap>#vPeso#:&nbsp;</td>
			<td nowrap>
				<cfset valor = 0.00>
				<cfif modo neq 'ALTA' >
					<cfset valor = data.IAEpesop >
				</cfif>
				<cf_monto name="IAEpesop" size="3" decimales="0" tabindex="1" value="#valor#">
			</td>
		</tr>	

		<tr id="tr_pregunta"> 
			<td align="right" nowrap valign="top">#vPregunta#:&nbsp;</td>
			<td nowrap>
				<textarea name="IAEpregunta" tabindex="1" id="IAEpregunta" rows="3" cols="50"><cfif modo NEQ 'ALTA'>#trim(data.IAEpregunta)#</cfif></textarea>
			</td>
		</tr>	
		
		<tr>
			<td align="right" nowrap style="padding:0;"></td>
			<td style="padding:0;">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input type="checkbox" tabindex="1" name="IAEevaluajefe" id="IAEevaluajefe" value="J" <cfif modo NEQ 'ALTA' and data.IAEevaluajefe EQ 1>checked</cfif>></td>
						<td><label for="IAEevaluajefe">#vJefe#</label></td>
					</tr>
					<tr>
						<td width="1%"><input type="checkbox" tabindex="1" name="IAEevaluasubjefe" id="IAEevaluasubjefe" value="J" <cfif modo NEQ 'ALTA' and data.IAEevaluasubjefe EQ 1>checked</cfif>></td>
						<td><label for="IAEevaluasubjefe">#vSubJefe#</label></td>
					</tr>
				</table>
			</td>
		</tr> 	

		
		

    <tr> 
   	  <td nowrap align="center" colspan="2"> 
			<cfif modo EQ "ALTA">
				<input type="submit" name="btnAgregar" class="btnGuardar" tabindex="1" value="#BTN_Agregar#"> 
			<cfelse>
				<input type="submit" name="btnModificar" class="btnGuardar" tabindex="1" value="#BTN_Modificar#" >
				<input type="submit" name="btnEliminar" class="btnEliminar" tabindex="1" value="#BTN_Eliminar#" onClick="javascript: deshabilitarValidacion(); return confirm('#vEliminar#?')" > 
				<input type="button" name="btnNuevo" class="btnNuevo" tabindex="1" value="#BTN_Nuevo#" onclick="javascript:location.href='indicadorEvaluar.cfm'" >

				<cfset ts = "">	
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
				</cfinvoke>
			<input type="hidden" name="timestamp" value="<cfoutput>#ts#</cfoutput>">


			</cfif>
		</td>
    </tr>
  </table>
</form>
</cfoutput>

<cf_qforms>
<cfoutput>
<script language="javascript1.2" type="text/javascript">
	objForm.IAEcodigo.required = true;
	objForm.IAEcodigo.description = '#vCodigo#';
	objForm.IAEdescripcion.required = true;
	objForm.IAEdescripcion.description = '#vDescripcion#';
	objForm.IAEpesop.required = true;
	objForm.IAEpesop.description = '#vPeso#';
	objForm.IAEpregunta.description = '#vPregunta#';	

	function deshabilitarValidacion(){
		objForm.IAEcodigo.required = false;
		objForm.IAEdescripcion.required = false;
		objForm.IAEpesop.required = false;
		objForm.IAEpregunta.required = false;
	}
	
	function funcCambiar(valor){
		document.getElementById('tr_peso').style.display = 'none';
		//document.getElementById('tr_pregunta').style.display = 'none';		
		objForm.IAEpesop.required = false;
		//objForm.IAEpregunta.required = false;

		if (valor == 'T'){
			document.getElementById('tr_peso').style.display = '';
			objForm.IAEpesop.required = true;			
		}
		/*
		else{
			document.getElementById('tr_pregunta').style.display = '';
		objForm.IAEpregunta.required = true;
		}*/
	}
	
	funcCambiar(document.form1.IAEtipoconc.value);
	document.form1.IAEcodigo.focus();
</script>
</cfoutput>
