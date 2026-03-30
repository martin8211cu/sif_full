<cfset LvarTitulo = "Administración de Asientos de Contabilidad V.3 -  Asientos Importados">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#" width="80%">
		<cfquery name="rsMes" datasource="#session.dsn#">
			select Mstatus
			  from CGV3cierres
			 where Ecodigo		= #session.Ecodigo#
			   and Eperiodo		= #form.Eperiodo#
			   and Emes			= #form.Emes#
		</cfquery>
		<cfoutput>
		<table>
			<tr>
				<td nowrap>Período:</td>
				<td nowrap>#form.Eperiodo# - #form.Emes#</td>
			</tr>
		</table>
		</cfoutput>
		<script language="javascript">
			<cfif rsMes.Mstatus GT 0>
				<cfset LvarBotones = "">
				<cfset LvarFiltro = "">
			<cfelseif isdefined("url.chkErrores")>
				<cfset LvarBotones = "Ver_todos">
				<cfset LvarFiltro = " AND Eerror is not null">
				function funcVer_todos()
				{
					<cfoutput>
					location.href="CGV3conta.cfm?Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#";
					return false;
					</cfoutput>
				}
			<cfelse>
				<cfset LvarBotones = "Solo_con_Error">
				<cfset LvarFiltro = "">
				function funcSolo_con_Error()
				{
					<cfoutput>
					location.href="CGV3conta.cfm?Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#&chkErrores";
					return false;
					</cfoutput>
				}
			</cfif>
			
			<cfif rsMes.Mstatus EQ -3>
				<cfset LvarBotones &= ",Regenerar_Cuentas">
				function funcRegenerar_Cuentas()
				{
					<cfoutput>
					location.href="CGV3conta_sql.cfm?OP=CT&Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#";
					return false;
					</cfoutput>
				}
			<cfelseif rsMes.Mstatus EQ -5>
				<cfset LvarBotones &= ",ReAplicar_Asientos">
				function funcReAplicar_Asientos()
				{
					<cfoutput>
					location.href="CGV3conta_sql.cfm?OP=AT&Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#";
					return false;
					</cfoutput>
				}
			</cfif>
			<cfset LvarBotones &= ",Volver_Meses">
			function funcVolver_Meses()
			{
				<cfoutput>
				location.href = "CGV3conta.cfm?Nivel=1";
				return false;
				</cfoutput>
			}
			function sbAsiento(p,m,c,b)
			{
				document.formAsientos.nosubmit = true;
				location.href="CGV3conta_sql.cfm?OP=A1&Nivel=2&Eperiodo="+p+"&Emes="+m+"&CG5CON="+c+"&CGBBAT="+b;
			}
		</script>
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="CGV3asientos aa"
			columnas="Eperiodo, Emes, CG5CON, CGBBAT, 
				convert(varchar, CG5CON) + ' - ' + convert(varchar, CGBBAT) as Batch,
				Efecha, Edescripcion, Estatus, 3 as Nivel,
				case Estatus
					when  1	then 'Cargado'
					when  2	then 'Convirtiendo...'
					when -3	then '<font color=""##FF0000""><strong>Cuentas con errores</strong></font>'
					when  3	then 'Cuentas Generadas'
					when -4	then '<font color=""##FF0000""><strong>Error al Generar Asiento</strong></font>'
					when  4	then 'Asiento Generado'
					when -5	then '<font color=""##FF0000""><strong>Error al Aplicar Asiento</strong></font>'
					when  5	then 'Contabilizado'
				end as Estado,
				'<font color=""##FF0000""><strong>' + Eerror + '</strong></font>' as Eerror,
				case Estatus
					when -4	then '<img src=""/cfmx/sif/imagenes/Base.gif"" style=""cursor:pointer;"" title=""Generar y Aplicar Asiento""	onclick=""sbAsiento(' + convert(varchar(4),Eperiodo) + ',' + convert(varchar,Emes) + ',' + convert(varchar,CG5CON) + ',' + convert(varchar,CGBBAT) + ');"">'
					when -5	then '<img src=""/cfmx/sif/imagenes/options.small.png"" style=""cursor:pointer;"" title=""Aplicar Asiento""				onclick=""sbAsiento(' + convert(varchar(4),Eperiodo) + ',' + convert(varchar,Emes) + ',' + convert(varchar,CG5CON) + ',' + convert(varchar,CGBBAT) + ');"">'
				end as OP
			"
			filtro="Ecodigo = #session.Ecodigo# AND Eperiodo=#form.Eperiodo# AND Emes=#form.Emes# #LvarFiltro#"
			desplegar="OP,Batch, Estado, Efecha, Edescripcion, Eerror"
			etiquetas="OP,Batch, Estado, Fecha, Descripcion, Error"
			formatos="S,S,S,D,S,S"
			align="left,left,left,center,left,left"
			ajustar="N,N,N,N,N,S"
			showLink="yes"
			showEmptyListMsg="yes"
			ira="CGV3conta.cfm"
			navegacion="#navegacion#"
			keys="Eperiodo,Emes"
			formName="formAsientos"
			botones="#LvarBotones#"
		/>		
	<cf_web_portlet_end>
<cf_templatefooter>
