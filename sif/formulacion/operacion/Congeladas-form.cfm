<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select CPPid,  case CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
							#_Cat# ' de ' #_Cat# 
						 case {fn month(CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaDesde)#
							#_Cat# ' a ' #_Cat# 
						 case {fn month(CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
							#_Cat# ' ' #_Cat# #preservesinglequotes(CPPfechaHasta)#
						 as descripcion
	from CPresupuestoPeriodo
	where Ecodigo = #session.Ecodigo#
	  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#"> 
</cfquery>
<cfif rsPeriodo.recordcount eq 0>
	<cfthrow message="El periódo no existe">
</cfif>
<cfquery name="rsTipoVariacion" datasource="#session.DSN#">
	select FPTVid, case FPTVTipo 
						  when 0 then 'Presupuesto Extraordinario' 
						  when 1 then 'No Modifica Monto' 
						  when 2 then 'Modifica Monto hacia abajo' 
						  when 3 then 'Modifica Monto hacia Arriba'
						  when 4 then 'No Modifica Monto Grupal' 
						  else 'otro' end as descripcion
	from TipoVariacionPres 
	where Ecodigo = #session.Ecodigo#
	  and FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#"> 
</cfquery>
<cfif rsTipoVariacion.recordcount eq 0>
	<cfthrow message="El tipo de variación no existe">
</cfif>
<cfquery name="rsExisteConfiguracion" datasource="#session.DSN#">
	select count(1) as cantidad
	from FPEEstimacion
	where Ecodigo = #session.Ecodigo#
	  and FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#">
	  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	  and FPTVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPTVid#"> 
</cfquery>
<cfif rsExisteConfiguracion.cantidad eq 0>
	<cfthrow message="La configuración no existe. FPTVid = #form.FPTVid#, CPPid = #form.CPPid#, FPVCagrupador = #form.FPVCagrupador#">
</cfif>
<cfquery name="rsEnProceso" datasource="#session.DSN#">
	select count(1) as cantidad
	from FPEEstimacion
	where Ecodigo = #session.Ecodigo#
	  and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	  and FPEEestado in (0,1,2,3,4,5)
</cfquery>
<cfquery name="rsDescripcion" datasource="#session.DSN#">
	select FPECdescripcion
	from FPEstimacionesCongeladas 
	where Ecodigo = #session.Ecodigo#
	  and FPECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FPECid#"> 
</cfquery>
<cfoutput>
<table border="0" width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td align="center"><strong>Descripci&oacute;n del grupo:</strong>&nbsp;#rsDescripcion.FPECdescripcion#</td>
	</tr>
	<tr>
		<td align="center"><strong>Peri&oacute;do Presupuestal:</strong>&nbsp;#rsPeriodo.descripcion#</td>
	</tr>
		<tr>
		<td align="center"><strong>Tipo Variaci&oacute;n:</strong>&nbsp;#rsTipoVariacion.descripcion#</td>
	</tr>
	<tr>
		<td><form name="formCongelados" action="EstimacionGI-sql.cfm" method="post">
			<input type="hidden" name="CPPid" value="#form.CPPid#"/>
			<input type="hidden" name="FPECid" value="#form.FPECid#"/>
			<cfif rsEnProceso.cantidad eq 0>
				<cf_botones values="Descongelar" names="Aplicar">
			</cfif>
			<cf_botones values="Descartar" names="Anular" regresar="Congeladas.cfm">
		</form></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
	<td><form name="formCF" action="Congeladas.cfm" method="post">
		<cfinvoke component="sif.Componentes.pListas"
			method			="pLista"
			returnvariable	="Lvar_Lista"
			tabla			="FPEEstimacion a inner join CFuncional c on c.CFid = a.CFid inner join FPEstimacionesCongeladas ec on ec.FPECid = a.FPECid"
			columnas		="a.FPEEid,CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion as CF,a.CPPid,c.CFid,a.FPTVid, ec.FPECid"
			desplegar		="CF"
			etiquetas		="Código/Descripción Centro Funcional"
			formatos		="S"
			filtro			="ec.FPECid = #form.FPECid# and a.Ecodigo = #session.Ecodigo# and a.FPTVid = #form.FPTVid# order by c.CFcodigo"
			incluyeform		="true"
			align			="left,left,left"
			keys			="FPEEid"
			maxrows			="5"
			showlink		="true"
			formname		="formCF"
			ira				="#CurrentPage#"
			showEmptyListMsg="true"
			filtrar_automatico ="true"
			mostrar_filtro 	="true"
			filtrar_por		="a.CPPid,CFcodigo #_Cat# ' - ' #_Cat# CFdescripcion,FPEEestado"
			rsPdescripcion	="#rsPeriodos#"
			navegacion	="#lvarNavegacion#"/>
		</form></td>
	</tr>
</table>
</cfoutput>