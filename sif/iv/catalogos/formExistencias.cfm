<!-- Establecimiento del modo -->
<cfset modo = 'ALTA'>
<cfif isdefined("form.Aid") and len(trim(form.Aid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif not isdefined("Form.Aid")>
	<cflocation url="articulos-lista.cfm">
</cfif>

<!-- Consultas -->
<!-- 1. Almacenes -->
<cfquery datasource="#session.DSN#" name="rsAlmacen">
	select Aid, Bdescripcion, ts_rversion 
	from Almacen 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by Bdescripcion
</cfquery>

<!-- 2. Cuentas de Inventario -->
<cfquery datasource="#session.DSN#" name="rsIACuentas">
	select IACcodigo, IACdescripcion 
	from IAContables 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by IACdescripcion
</cfquery>

<!-- 3. Articulo y descripcion -->
<cfquery datasource="#session.DSN#" name="rsInfoArticulo">
	select Acodigo, Adescripcion 
	from Articulos
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric" >
</cfquery>

<script language="JavaScript1.2">
var boton = "";

function existe(form, name){
// RESULTADO
// Valida la existencia de un objecto en el form

	if (form[name] != undefined) {
		return true
   	}
	else{
		return false
	}
}

function checkeados(obj){
    for (i=0; i<obj.length; i++){
	    if (obj[i].checked){
		    return true;
		}
	} 
	return false
}

function validar(form){
	if (boton != "btnRegresar"){
		if ( existe(form, "Alm_Aid") ){
			if ( form.Alm_Aid.type == "checkbox" ){
				if (!form.Alm_Aid.checked){
					alert("No se han seleccionado registros para procesar")
					return false
				}	
			}
			// Arreglo de checkbox
			else{
				if (form.Alm_Aid.length > 0){
					if ( !checkeados(form.Alm_Aid) ){
						alert("No se han seleccionado registros para procesar")
						return false
					}
				}
				else{
					alert("No existen registros para procesar")
					return false	
				}
			}	
			return true;
		}
		else{
			return false
		}
	}
	else{
		return true;
	}	
}
</script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>

<form action="SQLExistencias.cfm" method="post" name="existencias" onSubmit="return validar(this);" >
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
		<input type="hidden" name="filtro_Acodigo" value="<cfif isdefined('form.filtro_Acodigo') and form.filtro_Acodigo NEQ ''>#form.filtro_Acodigo#</cfif>">
		<input type="hidden" name="filtro_Acodalterno" value="<cfif isdefined('form.filtro_Acodalterno') and form.filtro_Acodalterno NEQ ''>#form.filtro_Acodalterno#</cfif>">
		<input type="hidden" name="filtro_Adescripcion" value="<cfif isdefined('form.filtro_Adescripcion') and form.filtro_Adescripcion NEQ ''>#form.filtro_Adescripcion#</cfif>">		
		<input type="hidden" name="Aid" value="#form.Aid#">
		<input type="hidden" name="modo" value="CAMBIO">
	</cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><br>
			<td width="1%">&nbsp;</td>
			<td class="subTitulo" colspan="11" align="center">Art&iacute;culo <cfoutput>#rsInfoArticulo.Acodigo# - #rsInfoArticulo.Adescripcion#</cfoutput></td>
		</tr>
		
		<tr>
			<td width="1%">&nbsp;</td>
			<td colspan="4"><br><b>Almac&eacute;n</b></td>
			<td><br><b>Cuenta Contable</b></td>
			<td><br><b>Estante</b></td>
			<td><br><b>Casilla</b></td>
			<td><br><b>Exist. M&iacute;nima</b></td>
			<td><br><b>Exist. M&aacute;xima</b></td>
			<td><br><b>Existencias</b></td>
			<td><br>
			<b>Costo Unitario </b></td>
		</tr>

		<cfloop query="rsAlmacen">
			<cfquery name="rsForm" datasource="#session.DSN#">
				select Aid, Alm_Aid, IACcodigo, Eestante, Ecasilla, Eexistmin, Eexistmax, Eexistencia, Ecostou 
				from Existencias
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
				  and Aid = <cfqueryparam value="#Form.Aid#" cfsqltype="cf_sql_numeric" >
				  and Alm_Aid = <cfqueryparam value="#rsAlmacen.Aid#" cfsqltype="cf_sql_numeric" >
			</cfquery>

			<tr>
				<td width="1%">&nbsp;</td>
				<td><input tabindex="1" type="checkbox" name="Alm_Aid" value="<cfoutput>#rsAlmacen.Aid#</cfoutput>"<cfif rsForm.recordCount GT 0> checked</cfif>> <td>
				<td><cfoutput>#rsAlmacen.Bdescripcion#</cfoutput><td>

				<!-- Asiento Contable -->
				<td>
					<select name="IACcodigo_<cfoutput>#rsAlmacen.Aid#</cfoutput>" tabindex="1">
						<cfoutput query="rsIACuentas">
							<option value="#rsIAcuentas.IACcodigo#" <cfif #rsForm.IACcodigo# EQ #rsIACuentas.IACcodigo#>selected</cfif> >#rsIACuentas.IACdescripcion#</option>
						</cfoutput>
					</select>
				</td>
				
				<!-- Estante -->
				<td><input tabindex="1" type="text" name="Eestante_<cfoutput>#rsAlmacen.Aid#</cfoutput>" size="10" maxlength="15" value="<cfoutput><cfif #rsForm.Eestante# NEQ "" >#rsForm.Eestante#</cfif></cfoutput>" onfocus="javascript:this.select();" ></td>

				<!-- Casilla -->
				<td><input tabindex="1" type="text" name="Ecasilla_<cfoutput>#rsAlmacen.Aid#</cfoutput>" size="10" maxlength="15" value="<cfoutput><cfif #rsForm.Ecasilla# NEQ "" >#rsForm.Ecasilla#</cfif></cfoutput>"  onfocus="javascript:this.select();" ></td>

				<!-- Existencia minima -->
				<td><input type="text" tabindex="1" name="Eexistmin_<cfoutput>#rsAlmacen.Aid#</cfoutput>" value="<cfoutput><cfif #rsForm.Eexistmin# NEQ "" >#rsForm.Eexistmin#<cfelse>0.00</cfif></cfoutput>" size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
				<script language="JavaScript1.2">
					var codigo = "Eexistmin_" + <cfoutput>#rsAlmacen.Aid#</cfoutput>
					fm(document.existencias[codigo] , 2);	
				</script>

				<!-- Existencia maxima -->
				<td><input type="text" tabindex="1" name="Eexistmax_<cfoutput>#rsAlmacen.Aid#</cfoutput>" value="<cfoutput><cfif #rsForm.Eexistmax# NEQ "" >#rsForm.Eexistmax#<cfelse>0.00</cfif></cfoutput>"  size="8" maxlength="8" style="text-align: right;" onblur="javascript:fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
				<script language="JavaScript1.2">
					var codigo = "Eexistmax_" + <cfoutput>#rsAlmacen.Aid#</cfoutput>
					fm(document.existencias[codigo] , 2);	
				</script>

				<!--- Existencia --->
				<!--- <td><input type="text" name="Eexistencia_<cfoutput>#rsAlmacen.Aid#</cfoutput>" value="<cfoutput><cfif #rsForm.Eexistencia# NEQ "" >#LSCurrencyFormat(rsForm.Eexistencia, 'none')#<cfelse>0.00</cfif></cfoutput>"  size="12" maxlength="12" style="text-align: right;" onblur="javascript:fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" readonly></td> --->
				<td><input type="text" name="Eexistencia_<cfoutput>#rsAlmacen.Aid#</cfoutput>" value="<cfoutput><cfif #rsForm.Eexistencia# NEQ "" >#LSCurrencyFormat(rsForm.Eexistencia, 'none')#<cfelse>0.00</cfif></cfoutput>"  size="12" maxlength="12" style="text-align: right;" tabindex="-1" readonly></td>
				<script language="JavaScript1.2">
					var codigo = "Eexistencia_" + <cfoutput>#rsAlmacen.Aid#</cfoutput>
					//fm(document.existencias[codigo] , 2);	
				</script>
				
				<!-- Costo -->
				<cfoutput>
				<td><input type="text"  size="20" maxlength="20" name="Ecostou_#rsAlmacen.Aid#" value="<cfif rsForm.Ecostou NEQ '' >#LSCurrencyFormat(rsForm.Ecostou, 'none')#<cfelse>0.00</cfif>" style="text-align: right;" onblur="javascript:fm(this,2);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" tabindex="-1" readonly> </td>
				</cfoutput>
				<script language="JavaScript1.2">
					var codigo = "Ecostou_" + <cfoutput>#rsAlmacen.Aid#</cfoutput>
					//fm(document.existencias[codigo] , 2);	
				</script>
				
			</tr>
		</cfloop>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="12">
				<cf_Botones modo="CAMBIO" exclude="Baja,Nuevo" include="Regresar" includevalues="Regresar" tabindex="1">
			</td>	
		</tr>
		
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsAlmacen.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>">
	  
	</table>
</form>