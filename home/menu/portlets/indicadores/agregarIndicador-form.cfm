<cfif isdefined("url.indicador") and not isdefined("form.indicador")>
	<cfset form.indicador = url.indicador >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.indicador") and len(trim(form.indicador))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="dataIndicadores" datasource="asp">
	select indicador, nombre_indicador, descripcion_funcional, filtro_of, filtro_depto, filtro_cf
	from Indicador
	<cfif modo eq 'ALTA'>
		where indicador not in ( select indicador from IndicadorUsuario where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#"> )
		order by nombre_indicador 
	<cfelse>
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
	</cfif>
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="asp">
		select indicador, posicion, Ocodigo, Dcodigo, CFid, ts_rversion
		from IndicadorUsuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
    	  and indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
	</cfquery>
<cfelse>
	<cfset LvarPos = 10 >
	<cfquery name="pos" datasource="asp">
		select coalesce(max(posicion),0) as posicion
		from IndicadorUsuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	</cfquery>
	<cfif pos.recordCount gt 0>
		<cfset LvarPos = pos.posicion + 10 >
	</cfif>
</cfif>

<script type="text/javascript" language="javascript1.2">
	var configuracion = new Object();

	// objeto con datos de tabla de conversiones 
	<cfoutput query="dataIndicadores">
		if ( !configuracion["#trim(dataIndicadores.indicador)#"] ){
			configuracion["#trim(dataIndicadores.indicador)#"] = new Object();
		}

		configuracion["#trim(dataIndicadores.indicador)#"]["descripcion_funcional"] = "#ParagraphFormat(dataIndicadores.descripcion_funcional)#";
		configuracion["#trim(dataIndicadores.indicador)#"]["of"] = "#lcase(dataIndicadores.filtro_of)#";
		configuracion["#trim(dataIndicadores.indicador)#"]["depto"] = "#lcase(dataIndicadores.filtro_depto)#";
		configuracion["#trim(dataIndicadores.indicador)#"]["cf"] = "#lcase(dataIndicadores.filtro_cf)#";
	</cfoutput>
</script>

<cfoutput>

<cfinvoke component="home.Componentes.IndicadorBase" method="init" returnvariable="CFCIndicador">
<cfset misdatos = CFCIndicador.obtenerFiltros(session.Usucodigo, session.Ecodigo, session.EcodigoSDC, session.DSN) >

<script language="javascript1.2"></script>
<form name="form1" method="post" action="agregarIndicador-sql.cfm" style="margin:0;" onSubmit="return validar(this);">
	<table width="100%" border="0" cellpadding="2" cellspacing="0" >
		<tr>
			<td width="190" align="right">Seleccione el indicador:&nbsp;</td>
			<td>
				<cfif modo eq 'ALTA'>
					<select name="indicador" onChange="javascript:cambia_indicador(this);">
						<option value="">- seleccionar -</option>
						<cfloop query="dataIndicadores">
							<option value="#trim(dataIndicadores.indicador)#">#dataIndicadores.nombre_indicador#</option>
						</cfloop>
					</select>
				<cfelse>
					<input type="hidden" name="indicador" value="#trim(form.indicador)#">
					#dataIndicadores.nombre_indicador#
				</cfif>
			</td>
		</tr>
		
		<tr>
			<td valign="top" align="right">Descripci&oacute;n Funcional:&nbsp;</td>
			<td>
				<div id="descripcion" style="overflow:auto; height:50; width:250; margin:0;">
					<cfif modo neq 'ALTA'>#dataIndicadores.descripcion_funcional#</cfif>
				</div>
			</td>
		</tr>

		<!--- Centro Funcional --->
		<tr height="30px;">
			<td valign="middle" nowrap align="right" >Centro Funcional:&nbsp;</td>
			<td>
				<div id='cf_n' style="display:inherit;">N/A - No Aplica</div>
				<div id='cf_s' style="display:none;">
					<cfif modo eq 'ALTA' or ( isdefined("data.CFid") and len(trim(data.CFid)) eq 0 )>
						<cf_rhcfuncional>
					<cfelse>
						<cfquery name="dataCF" datasource="#session.DSN#">
							select CFid, CFcodigo, CFdescripcion
							from CFuncional
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CFid#">
						</cfquery>
						<cf_rhcfuncional query="#dataCF#">	
					</cfif>
				</div>
				<div id='cf_f' style="display:none;">
					<cfif isdefined("misdatos")>
						<input type="hidden" name="_CFid" value="#misdatos.CFid#">
						#misdatos.CFdescripcion#
					<cfelse>
						N/A - No Aplica
					</cfif>
				</div>
			</td>
		</tr>
		
		<!--- Oficina --->
		<cfquery name="dataOficinas" datasource="#session.DSN#">
			select Ocodigo, Odescripcion
			from Oficinas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Odescripcion
		</cfquery>
		<tr height="30px;">
			<td valign="middle" align="right">Oficina:&nbsp;</td>
			<td>
				<div id='of_n' style="display:inherit;">N/A - No Aplica</div>
				<div id='of_s' style="display:none;">
					<select name="Ocodigo" onChange="javascript:limpiarCF(this);">
						<option value="">- todos -</option>
						<cfloop query="dataOficinas">
							<option value="#dataOficinas.Ocodigo#" <cfif modo neq 'ALTA' and data.Ocodigo eq dataOficinas.Ocodigo>selected</cfif> >#dataOficinas.Odescripcion#</option>
						</cfloop>
					</select>
				</div>
				<div id='of_f' style="display:none;">
					<cfif isdefined("misdatos")>
						<input type="hidden" name="_Ocodigo" value="#misdatos.Ocodigo#">
						#misdatos.Odescripcion#
					<cfelse>
						N/A - No Aplica
					</cfif>
				</div>
			</td>
		</tr>

		<!--- Departamento --->
		<cfquery name="dataDepto" datasource="#session.DSN#">
			select Dcodigo, Ddescripcion
			from Departamentos
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Ddescripcion
		</cfquery>
		<tr height="30px;">
			<td valign="middle" align="right">Departamento:&nbsp;</td>
			<td>
				<div id='depto_n' style="display:inherit;">N/A - No Aplica</div>
				<div id='depto_s' style="display:none;">					
					<select name="Dcodigo"  onChange="javascript:limpiarCF(this);">
						<option value="">- todos -</option>
						<cfloop query="dataDepto">
							<option value="#dataDepto.Dcodigo#" <cfif modo neq 'ALTA' and data.Dcodigo eq dataDepto.Dcodigo>selected</cfif>>#dataDepto.Ddescripcion#</option>
						</cfloop>
					</select>
				</div>
				<div id='depto_f' style="display:none;">
					<cfif isdefined("misdatos")>
						<input type="hidden" name="_Dcodigo" value="#misdatos.Dcodigo#">
						#misdatos.Ddescripcion#
					<cfelse>
						N/A - No Aplica
					</cfif>
				</div>
			</td>
		</tr>
		
		<!--- posicion --->
		<tr height="30px;">
			<td valign="middle" align="right">Posici&oacute;n:&nbsp;</td>
			<td><input type="text" name="posicion" size="4" maxlength="4" style="text-align:right;" value="<cfif modo neq 'ALTA'>#data.posicion#<cfelse>#LvarPos#</cfif>"></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>

		<tr>
			<td colspan="2" align="center" >
				<cfif modo neq 'ALTA'>
					<input type="submit" name="btnModificar" value="Modificar" onClick="javascript:valida=true;">
				<cfelse>
					<input type="submit" name="btnAgregar" value="Agregar" onClick="javascript:valida=true;">
				</cfif>
				<input type="submit" name="btnCancelar" value="Cancelar" onClick="javascript:valida=false;">
			</td>
		</tr>
	</table>
	
	<input type="hidden" name="filtro_cf" value="<cfif modo neq 'ALTA'>#dataIndicadores.filtro_cf#</cfif>">
	<input type="hidden" name="filtro_of" value="<cfif modo neq 'ALTA'>#dataIndicadores.filtro_of#</cfif>">
	<input type="hidden" name="filtro_depto" value="<cfif modo neq 'ALTA'>#dataIndicadores.filtro_depto#</cfif>">

</form>

<script type="text/javascript" language="javascript1.2">
	var valida = true;
	function mostrar_datos(div,valor){
		document.getElementById(div+'n').style.display = 'none';
		document.getElementById(div+'s').style.display = 'none';
		document.getElementById(div+'f').style.display = 'none';
		document.getElementById(div+valor).style.display = '';
	}

	function cambia_indicador(obj){
		if ( obj.value != ''){
			document.getElementById('descripcion').innerHTML = configuracion[obj.value]['descripcion_funcional'];
			mostrar_datos('of_', configuracion[obj.value]['of']);
			mostrar_datos('depto_', configuracion[obj.value]['depto']);
			mostrar_datos('cf_', configuracion[obj.value]['cf']);
			document.form1.filtro_cf.value = configuracion[obj.value]['cf'];
			document.form1.filtro_of.value = configuracion[obj.value]['of'];
			document.form1.filtro_depto.value = configuracion[obj.value]['depto'];
		}
		else{
			document.getElementById('descripcion').innerHTML = '';

			mostrar_datos('of_', 'n');
			mostrar_datos('depto_', 'n');
			mostrar_datos('cf_', 'n');
			document.form1.filtro_cf.value = 'n';
			document.form1.filtro_of.value = 'n';
			document.form1.filtro_depto.value = 'n';
		}
	}
	
	function validar(form){
		if ( valida ){
			var error = false;
			var mensaje = 'Se presentaron los siguientes errores:\n';
			
			if( form.indicador.value == '' ){
				error = true;
				mensaje += ' - El campo Indicador es requerido.\n'
			}
			
			/*
			if ( form.filtro_cf.value == 's' && form.CFid.value == '' ){
				error = true;
				mensaje += ' - El campo Centro Funcional es requerido.\n'
			}
			if ( form.filtro_of.value == 's' && form.Ocodigo.value == '' ){
				error = true;
				mensaje += ' - El campo Oficina es requerido.\n'
			}
			if ( form.filtro_depto.value == 's' && form.Dcodigo.value == '' ){
				error = true;
				mensaje += ' - El campo Departamento es requerido.\n'
			}
			*/
			
			if (error){
				alert(mensaje);
			}
			
			return !error;
		}
		
	}
	
	function funcCFcodigo(){
		alert('OFICINA ' + document.form1.CFidOcodigo.value +  ' DEPTO ' + document.form1.CFidDcodigo.value)
		document.form1.Ocodigo.value = document.form1.CFidOcodigo.value;
		document.form1.Dcodigo.value = document.form1.CFidDcodigo.value;
	}
	
	function limpiarCF(obj){
		document.form1.CFid.value = '';
		document.form1.CFcodigo.value = '';
		document.form1.CFdescripcion.value = '';
		document.form1.CFidOcodigo.value = '';
		document.form1.CFidDcodigo.value = '';
	}

	<cfif modo neq 'ALTA'>
		mostrar_datos('of_', '#lcase(dataIndicadores.filtro_of)#');
		mostrar_datos('depto_', '#lcase(dataIndicadores.filtro_depto)#');
		mostrar_datos('cf_', '#lcase(dataIndicadores.filtro_cf)#');
		document.form1.filtro_cf.value = '#lcase(dataIndicadores.filtro_cf)#';
		document.form1.filtro_of.value = '#lcase(dataIndicadores.filtro_of)#';
		document.form1.filtro_depto.value = '#lcase(dataIndicadores.filtro_depto)#';
	</cfif>

</script>

</cfoutput>