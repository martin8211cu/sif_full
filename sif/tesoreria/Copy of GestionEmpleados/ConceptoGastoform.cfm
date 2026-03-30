<!--- 
	
 --->

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif not isdefined("Form.GECconcepto") and isdefined("url.GECconcepto")>
	<cfset Form.GECconcepto=url.GECconcepto>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfquery datasource="#Session.DSN#" name="rsID_tipo_gasto">
	select 
		GETdescripcion,
		GETid
	from GEtipoGasto
	where Ecodigo = #session.Ecodigo#
</cfquery>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsID_concepto_gasto">
		select 
			a.GECid,
			a.GECconcepto, 
			a.GECdescripcion,
			a.GECcomplemento,
			a.ts_rversion,
			a.montoI,
			a.montoM,
			a.GETid,
			a.Cid
		from GEconceptoGasto a
			inner join GEtipoGasto b
				on b.GETid = a.GETid
		where b.Ecodigo = #session.Ecodigo#
		<cfif isdefined("form.GECid") and form.GECid NEQ "">
			and a.GECid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GECid#">
		</cfif>
	</cfquery> 
	
	<cfquery datasource="#session.DSN#" name="rsConceptos">
		select c.Cid, c.Ccodigo, c.Cdescripcion<!---, cc.cuentac as cuentac--->
		from Conceptos c
		inner join CConceptos cc
			on cc.CCid=c.CCid
		where c.Cid =	<cfif len(trim(rsID_concepto_gasto.Cid))><cfqueryparam value="#rsID_concepto_gasto.Cid#" cfsqltype="cf_sql_numeric"><cfelse>-1</cfif>
	</cfquery>
	
</cfif>
<form method="post" name="form1" action="ConceptoGastoSQL.cfm">
	<table align="center">
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Clasificación Servicio Asociado: </td>
		  	<td>
			<cfif modo NEQ 'ALTA'>
				<cfif rsConceptos.recordcount gt 0 >
					<cf_sifconceptos query="#rsConceptos#" tabindex="1">      
				<cfelse>
					<cf_sifconceptos id="Cid" name="Ccodigo" desc="Cdescripcion" cuentac="cuentac" tabindex="1" FuncJSalCerrar="fnCargar();">
				</cfif>	
			<cfelse>	
				<cf_sifconceptos id="Cid" name="Ccodigo" desc="Cdescripcion" cuentac="cuentac" tabindex="1" FuncJSalCerrar="fnCargar();">				
			</cfif>
			
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Código del Concepto: </td>
		  <td>
				<input type="text" name="GECconcepto" id="GECconcepto" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_concepto_gasto.GECconcepto#</cfoutput></cfif>" size="32" <cfif modo NEQ 'ALTA' and len(trim(#rsID_concepto_gasto.Cid#)) >readonly="false"</cfif> tabindex="1" onfocus="javascript: this.select();" maxlength="10" alt="El campo Codigo" />
		  </td>
		</tr>
		<tr valign="baseline">
          <td nowrap="nowrap" align="right">Descripción:</td>
		  <td><input type="text"  name="GECdescripcion" maxlength="25" id='GECdescripcion' value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_concepto_gasto.GECdescripcion#</cfoutput></cfif>" size="32"  <cfif modo NEQ 'ALTA' and len(trim(#rsID_concepto_gasto.Cid#)) >readonly="false"</cfif> tabindex="1" onfocus="javascript: this.select();" alt="El campo Descripcion" />
              <label></label></td>
	  </tr>		
		<tr valign="baseline"> 
			<td nowrap align="right">Complemento cuenta:</td>
		  <td><input type="text" name="GECcomplemento" id='GECcomplemento' maxlength="25" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_concepto_gasto.GECcomplemento#</cfoutput></cfif>" size="32" <cfif modo NEQ 'ALTA' and len(trim(#rsID_concepto_gasto.Cid#)) >readonly="false"</cfif> tabindex="1" onfocus="javascript: this.select();" alt="El campo GECcomplemento">
		    <label></label></td>
		</tr>
		<tr valign="baseline">
          <td nowrap="nowrap" align="right">Tipo de Gasto Asociado: </td>
		  <td><label>
		   <select name="GETid" tabindex="1">  
				<cfoutput query="rsID_tipo_gasto">
					<option value="#rsID_tipo_gasto.GETid#" <cfif modo neq "ALTA" and rsID_concepto_gasto.GETid  eq rsID_tipo_gasto.GETid>selected="selected"</cfif>  >#rsID_tipo_gasto.GETdescripcion#</option>
				</cfoutput>
           </select>
			
				
		  </label>
	      <label></label></td>
	  </tr>
	  <tr>
		  <td align="right">
				Monto Máximo por Item:
		   </td>
		   <td>
		   		<cfif modo eq 'ALTA'>
		  		 <cf_inputNumber name="montoI" size="20" value="0" enteros="13" decimales="2" maxlenght="15">
				 <cfelse>
				  <cf_inputNumber name="montoI" size="20" value="#rsID_concepto_gasto.montoI#" enteros="13" decimales="2" maxlenght="15">
				 </cfif>
		   </td>
	  </tr>
	  <tr>
		  <td align="right">
				Monto Máximo por Documento:
		   </td>
		   <td>
		   		<cfif modo eq 'ALTA'>
		  		 <cf_inputNumber name="montoM" size="20" value="0" enteros="13" decimales="2" maxlenght="15">
				<cfelse>
					 <cf_inputNumber name="montoM" size="20" value="#rsID_concepto_gasto.montoM#" enteros="13" decimales="2" maxlenght="15">
				</cfif>
		   </td>
	  </tr>
		<tr>
		  <td colspan="2" align="center" nowrap><input type="hidden" name="botonSel" value="" tabindex="-1" />
            <input name="txtEnterSI" type="text" size="1" tabindex="-1" maxlength="1" readonly="true" class="cajasinbordeb" />
            <cfif modo EQ "ALTA">
              <input type="submit" name="Alta" value="Agregar" tabindex="1" onclick=" fnHabilitar(); javascript: this.form.botonSel.value = this.name;" />
              <input type="reset" name="Limpiar" value="Limpiar" tabindex="1" onclick="fnHabilitar(); javascript: this.form.botonSel.value = this.name" />
              <cfelse>
              <input type="submit" name="Cambio" value="Modificar" tabindex="1" onclick=" fnHabilitar(); javascript: this.form.botonSel.value = this.name;" />
              <input type="submit" name="Baja" value="Eliminar" tabindex="1" onclick=" fnHabilitar(); javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}" />
              <input type="submit" name="Nuevo" value="Nuevo" tabindex="1" onclick=" fnHabilitar(); javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); " />
            </cfif></td>
	  </tr>
	</table>
	
	<input type="hidden" name="GECid" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsID_concepto_gasto.GECid#</cfoutput></cfif>">
	
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
		 	method="toTimeStamp"
		 	returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsID_concepto_gasto.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
</form>

<cf_qforms form='form1'>
	<cf_qformsrequiredfield name='GECconcepto' description='Codigo'>
	<cf_qformsrequiredfield name='GECdescripcion' description='Descripcion'>
	<cf_qformsrequiredfield name='GECcomplemento' description='GECcomplemento'>
	<cf_qformsrequiredfield name='montoI' description='Monto por Item'>
	<cf_qformsrequiredfield name='montoM' description='Monto Máximo por Documento'>
</cf_qforms>                      


<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";


	function fnCargar()
	{
		document.form1.GECconcepto.disabled=true;
		document.form1.GECconcepto.value=document.form1.Ccodigo.value;
		document.form1.GECdescripcion.disabled=true;
		document.form1.GECdescripcion.value=document.form1.Cdescripcion.value;
		document.form1.GECcomplemento.disabled=true;
		document.form1.GECcomplemento.value=document.form1.cuentac.value;
		
	}
	
	function fnHabilitar()
	{
		document.form1.GECconcepto.disabled=false;
		document.form1.GECdescripcion.disabled=false;
		document.form1.GECcomplemento.disabled=false;
	}

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
	
</script>
