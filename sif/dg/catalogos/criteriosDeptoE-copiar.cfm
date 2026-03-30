<cf_templateheader title="Copiar Valores Distribuci&oacute;n de Gastos por Departamento">

		<cf_web_portlet_start border="true" titulo="Copiar Valores Distribuci&oacute;n de Gastos por Departamento" >
		<cfinclude template="/sif/portlets/pNavegacion.cfm">

		<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
		<cfif isdefined("url.error") and url.error eq 1>
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="60%" >
					<TR><TD align="center"><strong>Error procesando informaci&oacute;n</strong></TD></TR>
					<TR><TD align="center">El per&iacute;odo y mes origen deben ser diferentes al per&iacute;odo y mes destino</TD></TR>
					<TR><TD align="center"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onClick="javascript: location.href='criteriosDeptoE-copiar.cfm'"></TD></TR>
				</table>
		<cfelseif isdefined("url.error") and url.error eq 2>
			<cfoutput>
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="60%" >
					<TR><TD align="center"><strong>Error procesando informaci&oacute;n</strong></TD></TR>
					<TR><TD align="center">No existen datos para el per&iacute;odo y mes origen seleccionados:</TD></TR>
					<TR><TD align="center">Per&iacute;odo: #url.periodo_origen#</TD></TR>
					<TR><TD align="center">Mes: #listgetat(listaMes, url.mes_origen)#</TD></TR>
					<TR><TD align="center"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onClick="javascript: location.href='criteriosDeptoE-copiar.cfm'"></TD></TR>
				</table>
			</cfoutput>	
		<cfelseif isdefined("url.proceso")>
			<cfoutput>
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="60%" >
					<TR><TD align="center"><strong>El proceso de copiado de la informaci&oacute;n se realiz&oacute; con &eacute;xito.</strong></TD></TR>
					<TR><TD align="center">Se copi&oacute; informaci&oacute;n del per&iacute;odo #url.periodo_origen#, mes #listgetat(listaMes, url.mes_origen)# al per&iacute;odo #url.periodo_destino#, mes #listgetat(listaMes, url.mes_destino)#</TD></TR>
					<TR><TD align="center"><input type="button" name="Regresar" value="Regresar" class="btnAnterior" onClick="javascript: location.href='criteriosDeptoE-copiar.cfm'"></TD></TR>
				</table>
			</cfoutput>	
		<cfelse>
			<form style="margin:0" action="criteriosDeptoE-copiar-sql.cfm" method="get" name="form1" id="form1" onsubmit="javascript: return validar();" >
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
					<tr>
						<td align="right" valign="middle" width="47%"><strong>Per&iacute;odo origen:</strong></td>
						<td>
							<cfquery name="rsPeriodos" datasource="#session.DSN#">
								select distinct Speriodo as periodo
								from CGPeriodosProcesados 
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								order by Speriodo desc						
							</cfquery>
							<select name="periodo_origen" >
								<cfoutput query="rsPeriodos">
									<option value="#rsPeriodos.periodo#">#rsPeriodos.periodo#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="40%"><strong>Mes origen:</strong></td>
						<td>
							<select name="mes_origen">
								<option value="">-seleccionar-</option>
								<option value="1">Enero</option>
								<option value="2">Febrero</option>
								<option value="3">Marzo</option>
								<option value="4">Abril</option>
								<option value="5">Mayo</option>
								<option value="6">Junio</option>
								<option value="7">Julio</option>
								<option value="8">Agosto</option>
								<option value="9">Setiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							</select>
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="47%"><strong>Per&iacute;odo destino:</strong></td>
						<td>
							<select name="periodo_destino" >
								<cfoutput query="rsPeriodos">
									<option value="#rsPeriodos.periodo#">#rsPeriodos.periodo#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="40%"><strong>Mes destino:</strong></td>
						<td>
							<select name="mes_destino">
								<option value="">-seleccionar-</option>
								<option value="1">Enero</option>
								<option value="2">Febrero</option>
								<option value="3">Marzo</option>
								<option value="4">Abril</option>
								<option value="5">Mayo</option>
								<option value="6">Junio</option>
								<option value="7">Julio</option>
								<option value="8">Agosto</option>
								<option value="9">Setiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							</select>
						</td>
					</tr>
	
					<tr>
						<td align="right" valign="middle" width="40%"></td>
						<td>
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td width="1%"><input type="checkbox" name="chkBorrar" id="chkBorrar" value="" /></td>
									<td><label for="chkBorrar" >Eliminar datos si existen para per&iacute;odo y mes destino.</label></td>
								</tr>
							</table>
						</td>
					</tr>
	
	
					<tr>
						<td colspan="2" align="center"><input type="submit" name="btnAplicar" value="Copiar" class="btnAplicar" /></td>
					</tr>
				</table>
			</form>

			<cf_qforms>
			
			<script type="text/javascript" language="javascript1.2">
				objForm.periodo_origen.required = true;
				objForm.periodo_origen.description = 'Período origen';
				objForm.mes_origen.required = true;
				objForm.mes_origen.description = 'Mes origen';
				objForm.periodo_destino.required = true;
				objForm.periodo_destino.description = 'Período destino';
				objForm.mes_destino.required = true;
				objForm.mes_destino.description = 'Mes destino';	
	
				function validar(){
					if ( document.form1.periodo_origen.value == document.form1.periodo_destino.value && document.form1.mes_origen.value == document.form1.mes_destino.value){
						alert('Se presentaron los siguientes errores:\n - El período y mes origen deben ser diferentes al período y mes destino.')
						return false;
					}
					return true;
				}
		
			</script>

		</cfif>
		<cf_web_portlet_end>
		
	<cf_templatefooter>		