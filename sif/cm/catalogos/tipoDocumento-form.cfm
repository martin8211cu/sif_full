<cfset modo = "ALTA">
<cfif isdefined("form.TDRcodigo") and len(trim(form.TDRcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select TDRcodigo, TDRdescripcion, TDRtipo, TDRgeneranc, ts_rversion
		from TipoDocumentoR
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and TDRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(form.TDRcodigo)#">
	</cfquery>
</cfif>

<cfquery name="dataCodigos" datasource="#session.DSN#" maxrows="100">
	select TDRcodigo
	from TipoDocumentoR
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif modo neq 'ALTA'>
		and TDRcodigo != <cfqueryparam cfsqltype="cf_sql_char" value="#trim(data.TDRcodigo)#">
	</cfif>
</cfquery>

<cfoutput>
<form name="form1" action="tipoDocumento-sql.cfm" method="post">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
			<td><input type="text" name="TDRcodigo" size="5" maxlength="5" <cfif modo neq 'ALTA'>readonly</cfif> value="<cfif modo neq 'ALTA'>#trim(data.TDRcodigo)#</cfif>" onfocus="this.select();" onBlur="validaCodigo(this);"></td>
		</tr>
		<tr>
			<td align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input type="text" name="TDRdescripcion" size="60" maxlength="80" value="<cfif modo neq 'ALTA'>#trim(data.TDRdescripcion)#</cfif>" onfocus="this.select();"></td>
		</tr>
		
		<tr>
			<td align="right"><strong>Tipo:&nbsp;</strong></td>
			<td>
				<select name="TDRtipo" onChange="cambiaTipo(this.value);">
					<option value="R" <cfif modo neq 'ALTA' and data.TDRtipo eq 'R'>selected</cfif> >Recepci&oacute;n</option>
					<option value="D" <cfif modo neq 'ALTA' and data.TDRtipo eq 'D'>selected</cfif> >Devoluci&oacute;n</option>
				</select> 				
			
			</td>
		</tr>

		<tr>
			<td align="right"></td>
			<td>
				<input type="checkbox" name="TDRgeneranc" <cfif modo neq 'ALTA' and data.TDRgeneranc eq 1>checked</cfif> >Genera Nota de Cr&eacute;dito
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
		<input type="hidden" name="_TDRcodigo" value="#trim(data.TDRcodigo)#">
	</cfif>
</form>
</cfoutput>

<script language="JavaScript" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.TDRcodigo.required = true;
	objForm.TDRcodigo.description="Código";				
	objForm.TDRdescripcion.required= true;
	objForm.TDRdescripcion.description="Descripción";	

	<cfoutput>
		objForm.TDRcodigo.description="#JSStringFormat('Código')#";
		objForm.TDRdescripcion.description="#JSStringFormat('Descripción')#";
	</cfoutput>
	
	function habilitarValidacion(){
		objForm.TDRcodigo.required = true;
		objForm.TDRdescripcion.required = true;
	}

	function deshabilitarValidacion(){
		objForm.TDRcodigo.required = false;
		objForm.TDRdescripcion.required = false;
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function validaCodigo(obj){
		if ( trim(obj.value) != '' ){
			var valor = '';
			<cfoutput>
			<cfloop query="dataCodigos">
				valor = '#trim(dataCodigos.TDRcodigo)#'
				
				if ( trim(obj.value) == valor ){
					alert("Error. El código de Documento ya existe.");
					obj.value = '';
					return false;
				}
				
			</cfloop>
			</cfoutput>
		}
	}
	
	function cambiaTipo(value){
		if ( value == 'D'){
			document.form1.TDRgeneranc.disabled = false;
		}
		else{
			document.form1.TDRgeneranc.disabled = true;
		}
	}
	
	cambiaTipo(document.form1.TDRtipo.value);
	
</script>
