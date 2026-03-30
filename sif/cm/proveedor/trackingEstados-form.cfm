<cfset modo = 'ALTA'>
<cfif  isdefined("form.ETcodigo") and len(trim(form.ETcodigo))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="sifpublica">
		select ETcodigo, ETdescripcion, ETorden, ts_rversion
		from EstadosTracking
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ETcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsExiste" datasource="sifpublica">
	select ETcodigo
	from EstadosTracking
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<script type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="javascript1.2" type="text/javascript">
	var valida = true;

	function validar(){
		if (valida){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
		
			if ( trim(document.form1.ETcodigo.value) == '' ){
				error = true;
				mensaje += ' - El campo Código es requerido.\n '
			}
		
			if ( trim(document.form1.ETdescripcion.value) == '' ){
				error = true;
				mensaje += ' - El campo Descripción es requerido.\n '
			}
	
			if (error){
				alert(mensaje);
			}
	
			return !error
		}
		return true;
	}
	
</script>

<cfoutput>
<form name="form1" method="post" action="trackingEstados-sql.cfm"  style="margin:0;" onSubmit="return validar();" >
	<table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<td align="right">C&oacute;digo:&nbsp;</td>
			<td>
				<input type="text" name="ETcodigo" <cfif modo neq 'ALTA'>readonly</cfif> value="<cfif modo neq 'ALTA'>#data.ETcodigo#</cfif>" tabindex="1" size="7" maxlength="7" style="text-align: right;" <cfif modo eq 'ALTA'>onBlur="javascript:fm(this,0); codigos(this.value);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" </cfif> >
			</td>
		</tr>
		
		<tr>	
			<td align="right">Descripcip&oacute;n:&nbsp;</td>
			<td><input type="text" size="60" name="ETdescripcion" tabindex="1" maxlength="100" onFocus="this.select()" value="<cfif modo neq 'ALTA'>#data.ETdescripcion#</cfif>" ></td>
		</tr>
	
		<tr>
			<td align="right">Orden:&nbsp;</td>
			<td><input type="text" name="ETorden" value="<cfif modo neq 'ALTA'>#data.ETorden#</cfif>" tabindex="1" size="7" maxlength="7" style="text-align: right;" onBlur="javascript:fm(this,0);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  ></td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center">
				<cfif modo eq 'ALTA'>
					<input type="submit" name="Alta" value="Agregar">
				<cfelse>	
					<cfif form.ETcodigo neq 0 >
						<input type="submit" name="Cambio" value="Modificar">
						<input type="submit" name="Baja" value="Eliminar" onClick="javascript:valida=false; if ( confirm('Desea eliminar el registro?') ){ return true; } else{return false;} ">
					</cfif>
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript:valida=false;">
				</cfif>
			</td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>

	</table>

	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="timestamp" value="#ts#">
	</cfif>

</form>
</cfoutput>
<script language="javascript1.2" type="text/javascript">
	function codigos(valor){
		var codigo = ''
		<cfloop query="rsExiste">
			<cfoutput>
			codigo = '#rsExiste.ETcodigo#';
			if ( trim(codigo) == trim(valor) ) {
				alert('El Código de Estado ya existe');
				document.form1.ETcodigo.value = '';
				document.form1.ETcodigo.focus();
				return false;
			}
			</cfoutput>
		</cfloop>
		
		return true;

	}

</script>

<!---
<script language="javascript1.2" type="text/javascript">
	function codigos(valor){
		var codigo = ''
		<cfloop query="rsExiste">
			<cfoutput>
			codigo = #rsExiste.ETcodigo#;
			if ( trim(codigo) == trim(valor)  ) {
				alert('El Código de Estado ya existe');
				return false;
			}
			</cfoutput>
		</cfloop>
		
		return true;
	}

</script>
--->
