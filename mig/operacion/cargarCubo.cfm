<cf_templateheader title="Carga de Datos al Modelo MultiDimensional">
<cf_web_portlet_start titulo="Carga de Datos al Modelo MultiDimensional">
	<cfinclude template="cargarCubo_view.cfm">
	<BR>
	<form action="cargarCubo_sql.cfm" method="post" style="text-align:center;">
		<table>
			<tr>
				<td align="left" colspan="3">
					<input type="checkbox" name="chkTodas" id="chkTodas"> Cargar datos de Todas las Empresas
				</td>
			</tr>
			<tr>
				<td align="center" style="border:solid 1px #CCCCCC; background-color:#EEEEEE">
					Cargar Dimensiones
				</td>
			<cfif LvarOP NEQ "ERR_D">
				<td align="center" style="border:solid 1px #CCCCCC; background-color:#EEEEEE">
					Cargar Metricas
				</td>
				<td align="center" style="border:solid 1px #CCCCCC; background-color:#EEEEEE">
					Cargar Indicadores
				</td>
			</cfif>
			</tr>

			<tr>
				<td>
					<img src="/cfmx/mig/operacion/dims.gif" style="cursor:pointer;height:200px;" alt="Cargar Dimensiones" onclick="location.href='cargarCubo_sql.cfm?btnDims' + fnChkTodas();">
				</td>
			<cfif LvarOP NEQ "ERR_D">
				<td>
					<img src="/cfmx/mig/operacion/mets.jpg" style="cursor:pointer;height:200px;" alt="Cargar Métricas" onclick="location.href='cargarCubo_sql.cfm?btnMets' + fnChkTodas();">
				</td>
				<td>
					<img src="/cfmx/mig/operacion/inds.jpg" style="cursor:pointer;height:200px;" alt="Cargar Indicadores" onclick="location.href='cargarCubo_sql.cfm?btnInds' + fnChkTodas();">
				</td>
			</cfif>
			</tr>
		</table>		
	</form>
	<script language="javascript">
		function fnChkTodas()
		{
			return ((document.getElementById('chkTodas').checked) ? "&chkTodas" : "");
		}
	</script>
<cf_web_portlet_end>
<cf_templatefooter>
