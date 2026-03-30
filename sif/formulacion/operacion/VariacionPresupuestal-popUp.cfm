<cfparam name="url.FPEEid" default="-1">
<cfparam name="form.FPEEid" default="#url.FPEEid#">
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfquery name="rsEstimacion" datasource="#session.dsn#">
	select FPTVid, CPPid, FPEEestado
		from FPEEstimacion
	where FPEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPEEid#">	
</cfquery>
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
				case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
				case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(CPPfechaHasta)}">
			as Pdescripcion
		from CPresupuestoPeriodo
	where CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimacion.CPPid#">
</cfquery>
<cfquery name="rsVariacion" datasource="#session.dsn#">
	select FPTVDescripcion
		from TipoVariacionPres
	where FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimacion.FPTVid#">
</cfquery>
<cfquery name="rsEstimaciones" datasource="#session.dsn#">
	select ee.FPEEid as FPEEidL, cf.CFid, cf.CFcodigo, cf.CFdescripcion
		from FPEEstimacion ee
			inner join CFuncional cf
				on cf.CFid = ee.CFid
	where ee.CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimacion.CPPid#">
	  and ee.FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstimacion.FPTVid#">
</cfquery>
<cfset lvarMaxrows = 5>
<cfset lvarShowlink	= true>
<cfset lvarNavegacion = "FPEEid=#form.FPEEid#">
<cfset lvarTitulo = "Aprobación Grupal">
<cfif isdefined('Congelar')>
	<cfset lvarMaxrows = 10>
	<cfset lvarShowlink	= false>
	<cfset lvarNavegacion = "Congelar=true&FPEEid=#form.FPEEid#">
	<cfset lvarTitulo = "Congelar Estimación">
</cfif>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#lvarTitulo#: #rsVariacion.FPTVDescripcion#">
	<cf_templatecss>
	<cfoutput>
		<form action="VariacionPresupuestal-popUp.cfm" method="post" name="form1">
			<input type="hidden" name="FPEEid" value="#form.FPEEid#" />
			<table border="0" width="100%" align="center">
				<tr align="center">
					<td>
						<strong style="font-size:20px">Centro Funcionales Asociados</strong>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td>
					<cfinvoke component="sif.Componentes.pListas"
						method			="pLista"
						returnvariable	="Lvar_Lista"
						tabla			="FPEEstimacion ee inner join CFuncional cf on cf.CFid = ee.CFid"
						columnas		="ee.FPEEid as FPEEidL, cf.CFid, cf.CFcodigo, cf.CFdescripcion"
						desplegar		="CFcodigo, CFdescripcion"
						etiquetas		="Código, Descripción"
						formatos		="S,S"
						filtro			="ee.CPPid = #rsEstimacion.CPPid# and ee.FPTVid = #rsEstimacion.FPTVid# and not ee.FPEEestado in (6,7,8)"
						align			="left, left"
						keys			="FPEEidL"
						maxrows			="#lvarMaxrows#"
						showlink		="#lvarShowlink#"
						showEmptyListMsg="true"
						mostrar_filtro	="true"
						formName		="form1"
						filtrar_automatico="true"
						navegacion 		="FPEEid=#form.FPEEid#"
						irA				="VariacionPresupuestal-popUp.cfm">
	
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</form>
			<cfif isdefined('Congelar')>
			<tr><td nowrap><strong>Descripci&oacute;n del grupo:</strong>&nbsp;<input id="DescripcionGrupo" name="DescripcionGrupo" size="60" maxlength="80"/></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="center"><button type="submit" class="btnNormal" onclick="fnCongelar()">Congelar</button></td></tr>
			<cfelse>
				<tr><td align="center"><strong>Lineas Modificadas</strong></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>
						<cfif isdefined('form.FPEEidL') and len(trim(form.FPEEidL)) eq 0>
							<cfset form.FPEEidL = -1>
						<cfelseif not isdefined('form.FPEEidL')>
							<cfset form.FPEEidL = -1>
						</cfif>
						<cfinvoke component="sif.Componentes.pListas"
							method			="pLista"
							returnvariable	="Lvar_Lista"
							tabla			="FPDEstimacion"
							columnas		="DPDEdescripcion, FPDEid, DPDEmontoAjuste,FPEEid as FPEEidD, FPDElinea, FPEPid"
							desplegar		="DPDEdescripcion,DPDEmontoAjuste"
							etiquetas		="Descripción, Monto Ajuste"
							formatos		="S,S"
							filtro			="FPEEid = #form.FPEEidL# and coalesce(DPDEmontoAjuste,0) <> 0"
							align			="left, left"
							keys			="FPDEid"
							maxrows			="5"
							showEmptyListMsg="true"
							formName		="form1"
							fparams			="FPEEidD,FPEPid,FPDElinea"
							funcion			="fnProcesar"
							PageIndex="1">
					</td></tr>
					<cfinvoke component="sif.Componentes.FPRES_Equilibrio" method="CreateQueryGeneral" returnvariable="query">
						<cfinvokeargument name="CPPid" 			value="#rsEstimacion.CPPid#">
						<cfinvokeargument name="FPEEestado" 	value="0">
					</cfinvoke>
					<cfquery dbtype="query" name="rsNiveles">	
						select PCDcatid, PCDdescripcion,
							sum(IngresosEstimacion) TotalIngresos,
							sum(EgresosEstimacion)  TotalEgresos,
							sum(IngresosPlan) TotalIngresosPlan,
							sum(EgresosPlan) TotalEgresosPlan
						from query
						group by PCDcatid, PCDdescripcion
						order by PCDdescripcion
					</cfquery>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center" style="font-size:20px"><strong>Niveles de Equilibrio</strong></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr style="font-weight:bold" align="center">
								<td colspan="2">Nivel</td>
								<td colspan="2">Total Egresos</td>
								<td colspan="2">Total Egresos En Plan</td>
								<td colspan="2">Diferencia</td>
								<td colspan="2">Total Ingresos</td>
								<td colspan="2">Total Ingresos En Plan</td>
								<td>Diferencia</td>
							</tr>
							<cfset lvarAprobar = true>
							<cfset i = 0>
							<cfloop query="rsNiveles">
								<cfif i mod 2 eq 0>
								<tr class="listaPar">
								<cfelse>
								<tr class="listaNon" nowrap="nowrap">
								</cfif>
									<cfset lvarDifE = rsNiveles.TotalEgresosPlan - rsNiveles.TotalEgresos>
									<cfset lvarDifI = rsNiveles.TotalIngresosPlan - rsNiveles.TotalIngresos>
									<cfif lvarDifE neq 0 or lvarDifI neq 0>
										<cfset lvarAprobar = false>
									</cfif>
									<td>#rsNiveles.PCDdescripcion#</td><td>&nbsp;</td>
									<td align="right">#numberformat(rsNiveles.TotalEgresos,',9.0000')#</td><td>&nbsp;</td>
									<td align="right">#numberformat(rsNiveles.TotalEgresosPlan,',9.0000')#</td><td>&nbsp;</td>
									<td align="right">#numberformat(lvarDifE,',9.0000')#</td><td>&nbsp;</td>
									<td align="right">#numberformat(rsNiveles.TotalIngresos,',9.0000')#</td><td>&nbsp;</td>
									<td align="right">#numberformat(rsNiveles.TotalIngresosPlan,',9.0000')#</td><td>&nbsp;</td>
									<td align="right">#numberformat(lvarDifI,',9.0000')#</td>
								</tr>
								<cfset i = i + 1>
							</cfloop>
							<cfif lvarAprobar>
								<tr><td colspan="14">&nbsp;</td></tr>
								<tr><td colspan="14" align="center">
								<button type="submit" class="btnAplicar" onclick="fnAprobar()">Aprobar</button>
								</td></tr>
							</cfif>
						</table>
					</td></tr>
				</cfif>
			</table>
	<script language="javascript1.2" type="text/javascript">
		function fnAprobar(){
			window.opener.location.href = "EstimacionGI-sql.cfm?esGrupal=true&btnAprobar=true&FPTVid=#rsEstimacion.FPTVid#&CPPid=#rsEstimacion.CPPid#";
			window.close();
		}
		function fnProcesar(FPEEid,FPEPid,FPDElinea){
			window.opener.location.href = "VariacionPresupuestal-Admin.cfm?FPEEid="+FPEEid+"&FPEPid="+FPEPid+"&FPDElinea="+FPDElinea;
			window.close();
		}
		function fnCongelar(){
			desc = document.getElementById('DescripcionGrupo').value;
			param = "btnCongelar=true&CPPid=#rsEstimacion.CPPid#&=#rsEstimacion.CPPid#&FPEEestado=#rsEstimacion.FPEEestado#&descripcion="+desc
			<cfif isdefined('CurrentPage')>
			param = param + "&CurrentPage=#CurrentPage#";
			</cfif>
			window.opener.location.href = "EstimacionGI-sql.cfm?"+param;
			window.close();
		}
	</script>
	</cfoutput>
<cf_web_portlet_end>