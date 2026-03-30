<cfset modo = 'ALTA'>
<cfif isdefined("url.arbol_pos") and len(trim(url.arbol_pos))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA' >
	<cfquery name="rsCategoriaSNegocios" datasource="#Session.DSN#" >
		select CSNid, Ecodigo, coalesce(CSNidPadre,0) as CSNidPadre, CSNcodigo, CSNdescripcion,  ts_rversion 
		from CategoriaSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.arbol_pos#" >		  
		order by CSNdescripcion asc
	</cfquery>
	
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select CSNid as CSNidPadre, CSNcodigo as CSNcodigoPadre, CSNdescripcion as CSNdescPadre, CSNpath as path
		from CategoriaSNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		  and CSNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCategoriaSNegocios.CSNidPadre#">
	</cfquery>
	
	<cfif isdefined("rsClasificacion") and rsClasificacion.RecordCount GT 0>
		<cfset Form.nivel= #ListLen(rsClasificacion.path,'/')#>
	<cfelse>
		<cfset Form.nivel= 1>
	</cfif>

</cfif>

<cfquery name="rsClasificaciones" datasource="#session.DSN#">
	select CSNid, CSNcodigo, CSNdescripcion 
	from CategoriaSNegocios
	where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsProfundidad" datasource="#session.DSN#">
	select coalesce(Pvalor,'1') as Pvalor
	from Parametros
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo=540
</cfquery>

<script src="../../js/utilesMonto.js" language="javascript1.2" type="text/JavaScript"></script>

<script language="JavaScript" type="text/JavaScript">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function validar(form){
		if (document.form1.validacion.value == 1){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			if ( trim(document.form1.CSNcodigo.value) == '' ){
				error = true;
				mensaje = mensaje + " - El campo Codigo es requerido.\n";
			}
	
			if ( trim(document.form1.CSNdescripcion.value) == '' ){
				error = true;
				mensaje = mensaje + " - El campo Descripción es requerido.\n";
			}
	
			if (error){
				alert(mensaje);
				return false;
			}
	
			document.form1.CSNcodigo.disabled = false;
			return true;
		}
		return true;	
	}

	function habilitarValidacion(){
		document.form1.validacion.value = 1;
	}

	function deshabilitarValidacion(){
		document.form1.validacion.value = 0;
	}

	function validaCodigo(value){
		var ok = true;
		if (trim(value) != ''){
			<cfif modo neq 'ALTA'>
				if ( trim(value) == trim(document.form1._CSNcodigo.value) ){
					ok = false;
				}
			</cfif>

			if ( codigo[value] && ok){
				alert('El Código de Servicio ya existe.');
				document.form1.CSNcodigo.value = "";
				document.form1.CSNcodigo.focus();
				return true;
			}
			else{
				return false;
			}	
		}	
	}

	function funcCSNcodigopadre(){
		if( document.form1.profundidad.value <= (parseInt(document.form1.nivel))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form1.CSNidPadre.value = '';
			document.form1.CSNcodigoPadre.value = '';
			document.form1.CSNdescPadre.value = '';
		}
	}	

	function codigos(){
		<cfoutput query="rsClasificaciones" maxrows="100">
			codigo["#trim(rsClasificaciones.CSNcodigo)#"] = "#trim(rsClasificaciones.CSNcodigo)#";
		</cfoutput>
	}
	var codigo = new Object();
	codigos();

</script>

<cfoutput>

<form action="SQLCategoriaSNegocios.cfm" method="post" name="form1" onSubmit="return validar();">
	<table width="100%" height="50%" align="center" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td width="22%" align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td width="78%">
				<input name="CSNcodigo" type="text" 
					value="<cfif modo neq "ALTA" >#trim(rsCategoriaSNegocios.CSNcodigo)#</cfif>" 
					size="10" maxlength="4"  alt="El Código del Concepto" onBlur="javascript:validaCodigo(this.value);" 
					onFocus="this.select();"> 
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="_CSNcodigo" value="#rsCategoriaSNegocios.CSNcodigo#" >
				</cfif>
			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="CSNdescripcion" type="text"  
				value="<cfif modo neq "ALTA">#rsCategoriaSNegocios.CSNdescripcion#</cfif>" 
				size="35" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>Clasificaci&oacute;n Padre:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_sifcategoriassn query="#rsClasificacion#" id="CSNidPadre" name="CSNcodigoPadre" 
							desc="CSNdescPadre" catalogo="0"  >
				<cfelse>
					<cf_sifcategoriassn id="CSNidPadre" name="CSNcodigoPadre" desc="CSNdescPadre" catalogo="0">
				</cfif>
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td colspan="2" align="center" nowrap>
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
	</table>

	<cfset ts = "">
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsCategoriaSNegocios.ts_rversion#"/>
		</cfinvoke>
		
		<input type="hidden" name="CSNid" value="#rsCategoriaSNegocios.CSNid#">
		<input type="hidden" name="arbol_pos" value="#rsCategoriaSNegocios.CSNid#">
		<input name="nivel" type="hidden" value="#form.nivel#">
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	
	<input type="hidden" name="validacion" value="1">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="_CSNidPadre" value="#rsCategoriaSNegocios.CSNidPadre#" >
	</cfif>

    <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">
 </form>
 </cfoutput>
