<cfset modo = 'ALTA'>
<cfif isdefined("url.arbol_pos") and len(trim(url.arbol_pos))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA' >
	<cfquery name="rsCConceptos" datasource="#Session.DSN#" >
		select CCid, Ecodigo, coalesce(CCidpadre,0) as CCidpadre, CCcodigo, CCdescripcion, CCnivel, CCpath, ts_rversion , cuentac
		from CConceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.arbol_pos#" >		  
		order by CCdescripcion asc
	</cfquery>
	
	<cfquery name="rsClasificacion" datasource="#session.DSN#">
		select CCid as CCidpadre, CCcodigo as CCcodigopadre, CCdescripcion as CCdescpadre, CCnivel as CCnivel
		from CConceptos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCConceptos.CCidpadre#">
	</cfquery>
</cfif>

<cfquery name="rsClasificaciones" datasource="#session.DSN#">
	select CCid, CCcodigo, CCdescripcion 
	from CConceptos
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
			if ( trim(document.form1.CCcodigo.value) == '' ){
				error = true;
				mensaje = mensaje + " - El campo Codigo es requerido.\n";
			}
	
			if ( trim(document.form1.CCdescripcion.value) == '' ){
				error = true;
				mensaje = mensaje + " - El campo Descripción es requerido.\n";
			}
	
			if (error){
				alert(mensaje);
				return false;
			}
	
			document.form1.CCcodigo.disabled = false;
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
				if ( trim(value) == trim(document.form1._CCcodigo.value) ){
					ok = false;
				}
			</cfif>

			if ( codigo[value] && ok){
				alert('El Código de Servicio ya existe.');
				document.form1.CCcodigo.value = "";
				document.form1.CCcodigo.focus();
				return true;
			}
			else{
				return false;
			}	
		}	
	}

	function funcCCcodigopadre(){
		if( document.form1.profundidad.value <= (parseInt(document.form1.CCnivel.value))+1 ){
			alert('El nivel de Clasificación seleccionada no corresponde al nivel máximo definido en Parámetros.\n Debe seleccionar otra Clasificación.');
			document.form1.CCidpadre.value = '';
			document.form1.CCcodigopadre.value = '';
			document.form1.CCdescpadre.value = '';
			document.form1.CCnivel.value = '';
		}
	}	

	function codigos(){
		<cfoutput query="rsClasificaciones" maxrows="100">
			codigo["#trim(rsClasificaciones.CCcodigo)#"] = "#trim(rsClasificaciones.CCcodigo)#";
		</cfoutput>
	}
	var codigo = new Object();
	codigos();

</script>

<cfoutput>

<form action="SQLCConceptos.cfm" method="post" name="form1" onSubmit="return validar();">
	<table width="67%" height="75%" align="center" cellpadding="2" cellspacing="0">
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
			<td>
				<input name="CCcodigo" type="text" value="<cfif modo neq "ALTA" >#trim(rsCConceptos.CCcodigo)#</cfif>" size="10" maxlength="10"  alt="El Código del Concepto" onBlur="javascript:validaCodigo(this.value);" onFocus="this.select();"> 
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="_CCcodigo" value="#rsCConceptos.CCcodigo#" >
				</cfif>
			</td>
		</tr>

		<tr> 
			<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td>
				<input name="CCdescripcion" type="text"  value="<cfif modo neq "ALTA">#rsCConceptos.CCdescripcion#</cfif>" size="35" maxlength="50" onFocus="this.select();"  alt="La Descripción del Concepto">
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap>Objeto de Gasto:&nbsp;</td>
			<td>
				<input name="cuentac" type="text" value="<cfif modo NEQ "ALTA">#rsCConceptos.cuentac#</cfif>" size="35" maxlength="100" style="text-align:left" onFocus="javascript:this.select();">
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>Clasificaci&oacute;n Padre:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cf_sifclasificacionconcepto query="#rsClasificacion#" id="CCidpadre" name="CCcodigopadre" desc="CCdescpadre"  >
				<cfelse>
					<cf_sifclasificacionconcepto id="CCidpadre" name="CCcodigopadre" desc="CCdescpadre"  >
				</cfif>
			</td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="5" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="5" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="CConceptos"
					form = "form1"
					llave="#rsCConceptos.CCid#" />		
			</td></tr>
		</cfif>	
		<!--- *************************************************** --->  

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
			<cfinvokeargument name="arTimeStamp" value="#rsCConceptos.ts_rversion#"/>
		</cfinvoke>
		
		<input type="hidden" name="CCid" value="#rsCConceptos.CCid#">
		<input type="hidden" name="arbol_pos" value="#rsCConceptos.CCid#">
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	
	<input type="hidden" name="validacion" value="1">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="_CCidpadre" value="#rsCConceptos.CCidpadre#" >
	</cfif>

    <input type="hidden" name="profundidad" value="<cfoutput>#trim(rsProfundidad.Pvalor)#</cfoutput>">
 </form>
 </cfoutput>