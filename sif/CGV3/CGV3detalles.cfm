<cfset LvarTitulo = "Administración de Asientos de Contabilidad V.3 -  Detalles de Asiento">
<cf_templateheader title="#LvarTitulo#">
	<cf_web_portlet_start titulo="#LvarTitulo#">
		<cfquery name="rsAsiento" datasource="#session.dsn#">
			select 	Eerror,
					IDcontable,
					(select count(1) from HEContables where IDcontable = aa.IDcontable) as Contabilizado,
					(select count(1) from EContables  where IDcontable = aa.IDcontable) as Digitado
			  from CGV3asientos aa
			 where Ecodigo	= #session.Ecodigo# 
			   AND Eperiodo	= #form.Eperiodo# 
			   AND Emes		= #form.Emes#
			   AND CG5CON	= #form.CG5CON# 
			   AND CGBBAT	= #form.CGBBAT#
		</cfquery>

		<cfoutput>
		<table>
			<tr>
				<td nowrap>Período:</td>
				<td nowrap>#form.Eperiodo# - #form.Emes#</td>
				<td rowspan="2">&nbsp;</td>
				<td rowspan="2">
					<cfif rsAsiento.Contabilizado GT 0>
						<strong>POLIZA CONTABILIZADA</strong><BR>
					<cfelseif rsAsiento.Digitado GT 0>
						<strong>POLIZA GENERADA SIN CONTABILIZAR</strong><BR>
					</cfif>
					<font color="##FF0000">#rsAsiento.Eerror#</font>
				</td>
			</tr>
			<tr>
				<td>Batch:</td>
				<td nowrap>#form.CG5CON# - #form.CG5CON#</td>
				<cfset LvarBoton = "">
				<cfif rsAsiento.Contabilizado GT 0>
					<cfset LvarBoton = "Poliza_Contabilizada">
				<cfelseif rsAsiento.Digitado GT 0>
					<cfset LvarBoton = "Modificar_Poliza">
				</cfif>
			</tr>
		</table>
		</cfoutput>
		<cfinvoke component="sif.Componentes.pListas" method="pLista"
			tabla="CGV3detalles dd"
			columnas="Did, Eperiodo, Emes, CG5CON, CGBBAT, Ddocumento, Dreferencia, Ddescripcion, 
						case when Dmovimiento = 'D' then Dmonto end as Debito,
						case when Dmovimiento = 'C' then Dmonto end as Credito,
						CTAM01 + CTAM02 + CTAM03 + CTAM04 + CTAM05 + CTAM06 
							+ '<BR>'
							+ CFformato
							+ case when Derror is not null then
								'<BR>' +
								'<font color=""##FF0000""><strong>' + Derror + '</strong></font>'
							end
						as CUENTA
			"
			filtro="Ecodigo = #session.Ecodigo# AND Eperiodo=#form.Eperiodo# AND Emes=#form.Emes#
					and CG5CON=#form.CG5CON# AND CGBBAT=#form.CGBBAT#"
			desplegar="Did, Dreferencia, Ddescripcion, CUENTA, Debito, Credito"
			etiquetas="Documento, Ref, Descripcion, Cuenta, Debitos, Creditos"
			formatos="S,S,S,S,M,M"
			align="left,left,left,left,right,right"
			ajustar="N,N,N,S,N,N"
			showEmptyListMsg="yes"
			showLink="no"
			ira="CGV3conta.cfm"
			navegacion="#navegacion#"
			keys="Did"
			formName="formDetalles"
			botones="#LvarBoton#,Volver_Asientos,Volver_Meses"
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
				location.href = "CGV3conta.cfm?Nivel=2&Eperiodo=#form.Eperiodo#&Emes=#form.Emes#";
				return false;
				</cfoutput>
			}
		<cfif rsAsiento.IDcontable NEQ "">
			<cfoutput>
			function funcModificar_Poliza(id)
			{
				location.href = "CGV3conta.cfm?Nivel=5&IDcontable=#rsAsiento.IDcontable#";
				return false;
			}
			function funcPoliza_Contabilizada(id)
			{
				location.href = "CGV3conta.cfm?Nivel=6&IDcontable=#rsAsiento.IDcontable#";
				return false;
			}
			</cfoutput>
		</cfif>
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>

