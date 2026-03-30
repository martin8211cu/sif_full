<cfset modo = 'ALTA'>

<cfoutput>

<cfquery name="pcdata" datasource="sifcontrol">
	select PCnombre, PCid
	from PortalCuestionario
	where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
</cfquery>

<script type="text/javascript" language="javascript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<cfif isdefined("form.PCid") and len(trim(form.PCid)) and isdefined("form.PPid") and len(trim(form.PPid))>
	<cfquery name="prdata" datasource="sifcontrol">
		select PCid, PPid, PPpregunta
		from PortalPregunta
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>

	<cfquery name="data" datasource="#session.DSN#">
		select idcompetencia, peso
		from RHPreguntasCompetencia
		where RHPCtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="H">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
		  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif data.recordcount gt 0 >
		<cfset modo = 'CAMBIO'>
	</cfif>

	<form name="form1" method="post" action="preguntasCompetencia-sql.cfm" style="margin:0;" onSubmit="return validar(this);">
		<input type="hidden" name="PCid" value="#form.PCid#">
		<input type="hidden" name="PPid" value="#form.PPid#">
		<input type="hidden" name="RHPCtipo" value="H">
		<cfif modo neq 'ALTA'><input type="hidden" name="_idcompetencia" value="#data.idcompetencia#"></cfif>
		<cfif isdefined("form.pagenum")><input type="hidden" name="_pagenum" value="#form.pagenum#"></cfif>

	<table width="100%" cellpadding="3" cellspacing="0">
		<tr>
			<td align="center" colspan="2"><strong>#pcdata.PCnombre#</strong></td>
		</tr>
<!---
		<tr>
			<td align="right">Parte:&nbsp;</td>
			<td>#dataPreguntas.PPparte#</td>
		</tr>
		<tr>
			<td align="right">N&uacute;mero:&nbsp;</td>
			<td>#dataPreguntas.PPnumero#</td>
		</tr>
--->		
		<tr>
			<td align="right" valign="top">Pregunta:&nbsp;</td>
			<td valign="top">#prdata.PPpregunta#</td>
		</tr>
	
		<tr>
			<td align="right" width="30%">Habilidad:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA'>
					<cfquery name="habilidad" datasource="#session.DSN#">
						select RHHid, RHHcodigo, RHHdescripcion 
						from RHHabilidades 
						where RHHid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.idcompetencia#" >
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cf_rhhabilidad nameid="idcompetencia" query="#habilidad#">
				<cfelse>
					<cf_rhhabilidad nameid="idcompetencia" >
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right" width="30%">Peso:&nbsp;</td>
			<td>
				<input type="text" size="6" maxlength="6"  name="peso" style="text-align:right;" value="<cfif modo neq 'ALTA'>#LSNumberFormat(data.peso,',9.00')#</cfif>" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2);"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
			</td>
		</tr>

		<tr>
			<td align="center" colspan="2" align="center">
				<input type="submit" name="guardar" value="Guardar">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="eliminar" value="Eliminar">
				</cfif>
			</td>
		</tr>

	</table>
	</form>
<cfelse>
	<table width="99%" align="center" cellpadding="2" cellspacing="0" class="areaFiltro">
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><strong>#pcdata.PCnombre#</strong></td></tr>
		<tr><td align="center">Para asociar competencias a preguntas, debe seleccionar primero una pregunta.</td></tr>
		<tr><td>&nbsp;</td></tr>
	</table>
</cfif>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	
	function restaurar_color(obj){
		obj.style.backgroundColor = '#FFFFFF';
	}

	function validar(form){
		var mensaje = 'Se presentaron los siguientes errores:\n';
		var error = false;

		if ( trim(form.RHHid.value) == '' ){
			mensaje = mensaje + ' - El campo Competencia es requerido.\n' 
			//form.RHHcodigo.style.backgroundColor = '#FFFFCC';
			error = true;
		}

		if ( trim(form.peso.value) == '' ){
			mensaje = mensaje + ' - El campo Peso es requerido.\n' 
			//form.peso.style.backgroundColor = '#FFFFCC';
			error = true;
		}
		
		if (error){
			alert(mensaje);
		}

		return !error;

	}
</script>