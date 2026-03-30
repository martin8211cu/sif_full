<cfset LvarTitulo = "Administración de Asientos de Contabilidad V.3 -  Cuentas con Error">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cfoutput>
		<table width="100%">
			<tr>
				<td nowrap>Período:</td>
				<td nowrap>#form.Eperiodo# - #form.Emes#</td>
			</tr>
		</table>
		</cfoutput>
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="CGV3detalles dd"
			columnas="distinct 	CTAM01 + CTAM02 + CTAM03 + CTAM04 + CTAM05 + CTAM06 + ', ' as Cta,
								CFformato + ', ' as CFformato,
								'<font color=""##FF0000""><strong>' + Derror + '</strong></font>' as Derror,
								'<img src=""/cfmx/sif/imagenes/options.small.png"" style=""cursor:pointer;"" title=""Generar Cuenta"" onclick=""sbCuenta(' + convert(varchar(4),Eperiodo) + ',' + convert(varchar(2),Emes) + ', ''' + CFformato + ''');"">' as OP
			"
			filtro="Ecodigo = #session.Ecodigo# AND Eperiodo=#form.Eperiodo# AND Emes=#form.Emes#
					and Derror is not null"
			desplegar="OP, Cta, CFformato, Derror"
			etiquetas="OP,Cuenta V.3, Cuenta V.6, Error"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ajustar="N,N,N,S"
			showEmptyListMsg="yes"
			showLink="no"
			ira="CGV3conta.cfm"
			navegacion="#navegacion#"
			keys=""
			formName="formDetalles"
			botones="Regenerar_Cuentas,Volver_Meses, Volver_Asientos"
		/>
		<script language="javascript">
			function funcVolver_Meses()
			{
				<cfoutput>
				location.href = "CGV3conta.cfm?Nivel=1";
				return false;
				</cfoutput>
			}
			function funcVolver_Asientos()
			{
				<cfoutput>
				location.href = "CGV3conta.cfm?Eperiodo=#form.Eperiodo#&Emes=#form.Emes#&Nivel=2";
				return false;
				</cfoutput>
			}
			function sbCuenta(p,m,f)
			{
				location.href="CGV3conta_sql.cfm?OP=C1&Nivel=4&Eperiodo="+p+"&Emes="+m+"&CFformato="+f;
				return false;
			}
			function funcRegenerar_Cuentas()
			{
				<cfoutput>
				12:04 p.m. 10/12/2010location.href="CGV3conta_sql.cfm?OP=CT&Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#";
				return false;
				</cfoutput>
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>

