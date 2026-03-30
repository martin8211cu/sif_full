<cf_templateheader title="Proceso de Distribuci&oacute;n de Gastos">

		<cf_web_portlet_start border="true" titulo="Proceso de Distribuci&oacute;n de Gastos" >
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<form style="margin:0" action="gastosDistribuir-verificacion.cfm" method="get" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td align="right" valign="middle" width="47%"><strong>Per&iacute;odo:</strong></td>
					<td>
						<cfquery name="rsPeriodos" datasource="#session.DSN#">
							select distinct Speriodo as periodo
							from CGPeriodosProcesados 
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							order by Speriodo desc						
						</cfquery>
						<select name="periodo" onchange="javascript:meses(this.value)">
							<cfoutput query="rsPeriodos">
								<option value="#rsPeriodos.periodo#">#rsPeriodos.periodo#</option>
							</cfoutput>
						</select>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="40%"><strong>Mes:</strong></td>
					<td>
						<select name="mes">
						</select>
					</td>
				</tr>

				<tr>
					<td colspan="2" align="center"><input type="submit" name="btnAplicar" value="Trabajar" class="btnAplicar" /></td>
				</tr>
			</table>
		</form>
		<cf_web_portlet_end>
		
		<cf_qforms>
		
		<cfquery name="rsMeses" datasource="#session.DSN#" >
			select Speriodo, Smes
			from CGPeriodosProcesados 
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			order by Speriodo, Smes
		</cfquery>			
		<cfset listaMes = 'Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre'>
		<script type="text/javascript" language="javascript1.2">
			objForm.periodo.required = true;
			objForm.periodo.description = 'Período';
			objForm.mes.required = true;
			objForm.mes.description = 'Mes';
	
	
			function meses(valor){
				var combo = document.form1.mes;
				combo.length = 0;
				var cont = 0;
				<cfoutput query="rsMeses">
					var vPeriodo = '#rsMeses.Speriodo#'
					if ( vPeriodo == valor ){
						combo.length++;
						combo.options[cont].value = '#rsMeses.Smes#';
						combo.options[cont].text = '#listgetat(listaMes, rsMeses.Smes)#';
						combo.options[cont].selected = true;
						cont++;
					}
				</cfoutput>
			}
			meses(document.form1.periodo.value)
		</script>
	<cf_templatefooter>		