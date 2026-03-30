<cfif isdefined("url.id_paso") and not isdefined("form.id_paso")>
	<cfset form.id_paso = url.id_paso >
</cfif>
<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfset form.id_tramite = url.id_tramite >
</cfif>
<cfif isdefined("url.id_requisito") and not isdefined("form.id_requisito")>
	<cfset form.id_requisito = url.id_requisito >
</cfif>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Requisitos por Tr&aacute;mite</title>
<cf_templatecss>
</head>

<body>


<script language='Javascript' src="/cfmx/sif/js/utilesMonto.js"> </script>
<cfset modoreq = 'ALTA' >
<cfif isdefined("form.id_requisito")>
	<cfset modoreq = 'CAMBIO' >
</cfif>
<cfquery name="MaxPasos" datasource="#session.tramites.dsn#">
	select coalesce(max(numero_paso),0) + 10 as numero_paso
	from TPRReqTramite
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#" >
</cfquery>

<cfquery datasource="asp" name="monedas">
	select Miso4217, Mnombre
	from Moneda
	order by Miso4217
</cfquery>
<cfset prerequisitos = "">
<cfif modoreq neq 'ALTA'> 
	<cfquery name="data" datasource="#session.tramites.dsn#">
		select id_requisito, numero_paso, vigencia_requerida, costo_requisito, moneda ,
		case when costo_requisito is null  then 0 else 1 end  as valor ,ts_rversion, es_obligatorio,
		modo_flujo, id_requisito_flujo
		from TPRReqTramite
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#" >
		  and id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#" >
	</cfquery>
	<cfquery datasource="#session.tramites.dsn#" name="PRPrerrequisito">
		select  numero_paso from  TPRReqTramite a,TPRPrerrequisito b
		where a.id_tramite =  b.id_tramite 
		and a.id_requisito = b.id_prerrequisito
		and  b.id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
		and b.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
		order by numero_paso 
	</cfquery>	
	<cfif PRPrerrequisito.recordcount gt 0>
			<cfloop query="PRPrerrequisito">
				<cfif PRPrerrequisito.recordcount neq PRPrerrequisito.currentRow>
					<cfset prerequisitos = prerequisitos & PRPrerrequisito.numero_paso & ','>
				<cfelse>
					<cfset prerequisitos = prerequisitos & PRPrerrequisito.numero_paso >
				</cfif>
			</cfloop>
	</cfif>		
</cfif>

<cfoutput>

<cfif isdefined("form.id_tramite") and len(trim(form.id_tramite))>
	<cfquery name="inst" datasource="#session.tramites.dsn#">
		select codigo_tramite, nombre_tramite
		from TPTramite
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
	</cfquery>

	<cfquery name="paso" datasource="#session.tramites.dsn#">
		select nombre_paso
		from TPTramitePaso
		where id_paso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_paso#">
	</cfquery>


	<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
		<tr><td align="left">
			<font size="3" color="##003399">
			<strong>Tr&aacute;mite:&nbsp;#trim(inst.codigo_tramite)# - #inst.nombre_tramite#</strong></font></td></tr>
		<tr><td align="left" valign="middle">
			<font size="3" color="##003399">
			<strong>Paso:&nbsp;#trim(paso.nombre_paso)#</strong></font></td></tr>

	</table>
</cfif>

<table width="100%" cellpadding="2" cellspacing="0" style="border-left:1px solid black; border-bottom:1px solid black; border-right:1px solid black; ">
	<tr>
		<td width="60%" valign="top">
			<form name="form2" method="post" style="margin:0;" action="requisitos_tramite-sql.cfm" onsubmit="return validar2(this);">
				<input type="hidden" name="id_tramite" value="#form.id_tramite#" >
				<!---<input type="hidden" name="id_paso" value="#form.id_paso#" >--->
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><strong><font size="1"><cfif modoreq neq 'ALTA'>Modificar<cfelse>Agregar</cfif>&nbsp;Requisito</font></strong></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td width="16%" align="right">Requisito:&nbsp;</td>
						<td width="56%">
							<cfquery datasource="#session.tramites.dsn#" name="requisitos">
								select id_requisito, codigo_requisito, nombre_requisito,costo_requisito,moneda
								from TPRequisito
								<cfif modoreq neq 'ALTA'>
									where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
								<cfelse>
									where id_requisito not in ( select id_requisito 
																from TPRReqTramite 
																where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#"> )
								</cfif>
								order by 2, 3
							</cfquery>
							<cfif modoreq neq 'ALTA'>
								#trim(requisitos.codigo_requisito)# - #requisitos.nombre_requisito#
								<input type="hidden" name="id_requisito" value="#requisitos.id_requisito#" >
							<cfelse>
								<cf_tprequisitos form="form2" otrosdatos="SI">
							</cfif>
						
						</td>
				
					</tr>
					<tr>
						<td width="16%" align="right">N&uacute;mero:&nbsp;</td>
						<td>
						  <input name="numero_paso" style="text-align:left;"
								onFocus="javascript: this.value=qf(this); this.select(); " 
								onKeyUp="javascript: if(snumber(this,event,0)){} "
								onBlur="javascript:fm(this,0);"type="text" size="4" maxlength="4"
								value="<cfif modoreq NEQ "ALTA">#data.numero_paso#<cfelse>#MaxPasos.numero_paso#</cfif>">
						</td>		
					</tr>
					
					<tr>
						<td align="right">Paso:&nbsp;</td>
						<cfquery name="pasos" datasource="#session.tramites.dsn#">
							select id_paso, nombre_paso
							from TPTramitePaso
							where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
						</cfquery>
						<td>
							<select name="id_paso">
								<cfloop query="pasos">
									<option value="#pasos.id_paso#" <cfif isdefined("form.id_paso") and form.id_paso eq pasos.id_paso>selected</cfif>  >#pasos.nombre_paso#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					
					<tr>	
						<td width="19%"  colspan="1"  nowrap align="right">Antiguedad m&aacute;xima en d&iacute;as:&nbsp;</td>
						<td width="9%">
						  <input name="vigencia_requerida" style="text-align:left;"
								onFocus="javascript: this.value=qf(this); this.select(); " 
								onKeyUp="javascript: if(snumber(this,event,0)){} "
								onBlur="javascript:fm(this,0);"type="text" size="4" maxlength="4"
								value="<cfif modoreq NEQ "ALTA">#data.vigencia_requerida#</cfif>">
						</td>
					</tr>
					<tr>
						<td width="16%"  nowrap align="right">&nbsp;</td>
						<td>
							<input 	type="radio"  
									name="valores_predeterminados" 
									id="valores_predeterminados1" 
									value="0" 
									<cfif modoreq EQ "ALTA">checked<cfelseif modoreq NEQ "ALTA" and data.valor eq 0>checked</cfif>
									onClick="javascript: activacampos();" >
							<label for="valores_predeterminados1">Usar costo normal </label>				
							&nbsp; 
							<INPUT 	readonly="yes" TYPE="textbox" 
									NAME="MontoR" 
									VALUE="<cfif modoreq NEQ "ALTA">#trim(requisitos.moneda)#&nbsp;#LSNumberFormat(requisitos.costo_requisito,',9.00')#</cfif>"
									SIZE="30" 
									tabindex="1"
									MAXLENGTH="30" 
									ONBLUR=""  
									ONFOCUS="this.select(); " 
									ONKEYUP="" 
									style=" background-color:##FFFFFF; border: medium none; text-align:left; size:auto;"
							>													
						</td>
					</tr>	
					<tr>
						<td width="16%"  nowrap align="right">&nbsp;</td>
						<td>
							<input 	type="radio"  
									name="valores_predeterminados" 
									id="valores_predeterminados2" 
									value="1" 
									<cfif modoreq NEQ "ALTA" and data.valor eq 1>checked</cfif>
									onClick="javascript: activacampos();">
							<label for="valores_predeterminados2">Especificar costo</label>		
						</td>
					</tr>	
					<tr>
						<td width="16%"  nowrap align="right">&nbsp;</td>
						<td>
							<input name="costo_requisito" id="costo_requisito" style="text-align:right;"
								onfocus="javascript: this.value=qf(this); this.select(); " 
								onkeyup="javascript: if(snumber(this,event,2)){} "
								onblur="javascript:fm(this,2);"type="text" size="15" maxlength="15"
								disabled
								value="<cfif modoreq NEQ "ALTA">#LSNumberFormat(data.costo_requisito,',9.00')#<cfelse>0.00</cfif>">
							&nbsp;			
							<select name="moneda" id="moneda" disabled >
								<option value="" >-Seleccione una moneda-</option>
								<cfloop query="monedas">
									<option value="#HTMLEditFormat(monedas.Miso4217)#"
									<cfif modoreq NEQ 'ALTA' AND ( monedas.Miso4217 eq data.moneda ) > selected </cfif>>
									#HTMLEditFormat(monedas.Miso4217)# #HTMLEditFormat(monedas.Mnombre)#</option>
								</cfloop>
							</select>
						</td>
					</tr>						
					<tr>
						<td width="16%" align="right">Pre-Requisitos:&nbsp;</td>
						<td>
						  <input name="prerequisitos" style="text-align:left;"
							type="text" size="50" maxlength="80"
							value="#prerequisitos#">
						</td>		
					</tr>
					<tr>
						<td width="16%" align="right">&nbsp;</td>
						<td>
						  Anote los n&uacute;meros de pre-requisitos separados por coma. </td>		
					</tr>	
					<tr>
						<td width="16%"  nowrap align="right">&nbsp;</td>
						<td>
							<table cellpadding="0" cellspacing="0">
								<tr>
									<td valign="middle">
										<input 	type="checkbox"
										name="es_obligatorio" 
										id="es_obligatorio" 
										<cfif modoreq NEQ "ALTA" and data.es_obligatorio eq 1>checked</cfif>	>
									</td>
									<td valign="middle">
										<label for="es_obligatorio">Es requisito obligatorio para completar el paso.</label>		
									</td>
								</tr>
							</table>  
						</td>
					</tr>	
					
					<tr>
						<td align="right">Especificaci&oacute;n del Flujo :&nbsp;</td>
						<td>
							<select name="modo_flujo" onChange="javascript:cambiar(this);" >
								<option value="0" <cfif modoreq eq 'CAMBIO' and data.modo_flujo eq 0 >selected</cfif>  >No aplica</option>
								<option value="1" <cfif modoreq eq 'CAMBIO' and data.modo_flujo eq 1 >selected</cfif> >Asignar automaticamente al funcionario con menos carga de trabajo</option>
								<option value="*" <cfif modoreq eq 'CAMBIO' and data.modo_flujo eq '*' >selected</cfif> >Asignar a todos los funcionarios</option>
								<option value="M" <cfif modoreq eq 'CAMBIO' and data.modo_flujo eq 'M'>selected</cfif>>Asignaci&oacute;n manual</option>
							</select>
						</td>
					</tr>
					
					<tr id="continuar">
						<td align="right" nowrap width="30%" >Al concluir este Requisito continuar con:&nbsp;</td>
						<td>
							<cfquery name="requisitos" datasource="#session.tramites.dsn#">
								select a.id_requisito, b.nombre_requisito
								from TPRReqTramite a
								
								inner join TPRequisito b
								on b.id_requisito = a.id_requisito
								
								where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
								<cfif isdefined("form.id_requisito") and len(trim(form.id_requisito))>
									and a.id_requisito != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
								</cfif>
								order by 2
							</cfquery>
							
							<select name="id_requisito_flujo" id="id_requisito_flujo">
								<option value="">-ninguno-</option>
								<cfloop query="requisitos">
									<option value="#requisitos.id_requisito#" <cfif modoreq eq 'CAMBIO' and requisitos.id_requisito eq  data.id_requisito_flujo>selected</cfif> >#requisitos.nombre_requisito#</option>
								</cfloop>
							</select>
						</td>
					</tr>

					<tr>
						<td colspan="4" align="center">
							<cfif modoreq neq 'ALTA'>
								<input type="submit" name="Modificar" value="Modificar" >
								<!---<input type="submit" name="Eliminar" value="Eliminar" onClick="javascript: if ( confirm('Desea eliminar el registro?') ){  deshabilitarValidacion(); return true;} return false;">--->
							<cfelse>
								<input type="submit" name="Agregar" value="Agregar" >
							</cfif>
						</td>
					</tr>
				</table>
				<cfset ts = "">
				<cfif modoreq NEQ "ALTA">
					<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
				</cfif>
				<input type="hidden" name="ts_rversion" value="<cfif modoreq NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
			</form>
		</td>
	</tr>
</table>

<script type="text/javascript" language="javascript1.2">
	function activacampos(){
		if( document.form2.valores_predeterminados1.checked){
			document.form2.costo_requisito.disabled 	 = true;
			document.form2.moneda.disabled 	 			= true;
		}
		else{	
		document.form2.costo_requisito.disabled 	 = false;
		document.form2.moneda.disabled 	 			= false;
		}
	}
	activacampos();
	
	function validar2(f){
		var msj = '';
		
		if ( document.form2.id_requisito.value == '' ){
			var msj = msj + ' - El campo Requisito es requerido.\n';
		}
		if ( document.form2.numero_paso.value == '' ){
			var msj = msj + ' - El campo Número es requerido.\n';
		}

		if ( document.form2.id_paso.value == '' ){
			var msj = msj + ' - El campo Paso es requerido.\n';
		}
		
		if(document.form2.valores_predeterminados2.checked){
			if ( document.form2.costo_requisito.value == '' ){
				var msj = msj + ' - El campo Costo es requerido.\n';
			}
			if ( document.form2.moneda.value == '' ){
				var msj = msj + ' - El campo moneda es requerido.\n';
			}		
		}

		if ( msj != ''){
			msj = 'Se presentaron los siguientes errores:\n' + msj;
			alert(msj)
			return false;
		}
		return true
	}
	
	function cambiar(obj){
		if ( obj.value != '0' ){
			document.getElementById('id_requisito_flujo').disabled = false;
		}
		else{
			document.getElementById('id_requisito_flujo').value = 0;
			document.getElementById('id_requisito_flujo').disabled = true;
		}
	}
	
	cambiar(document.form2.modo_flujo);
	
</script>
</cfoutput>
</body>
</html>
