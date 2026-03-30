<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<!---<cfset LobjInterfaz.fnProcesoNuevoSoin(306,"EOidorden=#Arguments.EOidorden#","A")> pone en cola del motor--->
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfquery name="pConsulta" datasource="#session.dsn#">
	select	<cf_dbfunction name="date_part" args="YYYY,cpp.CPPfechaDesde">  ano 
	from 	minisif..CPresupuestoPeriodo as cpp
	where 	cpp.CPPestado = 1 and cpp.Ecodigo = #session.Ecodigo#
</cfquery>
<cfset periodoConsulta = #pConsulta.ano#>
<cfquery name="readProyectos" datasource="#session.dsn#">
	select	distinct(obproyecto.OBPcodigo) as OBPcodigo
	from 	minisif..CPresupuestoPeriodo as cpp
			inner join minisif..PCGplanCompras as pcgpc
				on pcgpc.CPPid = cpp.CPPid and pcgpc.Ecodigo = #session.Ecodigo#
			left join minisif..PCGDplanCompras as pcgdpc
				on pcgdpc.PCGEid = pcgpc.PCGEid and pcgdpc.PCGDtipo = 'P' 
				and pcgdpc.PCGDmodificado = 0 and pcgdpc.Ecodigo = #session.Ecodigo#
			<!---left join minisif..PCGDplanComprasMultiperiodo as pcgdpcmp
				on pcgdpcmp.PCGDid = pcgdpc.PCGDid --->
			left join minisif..OBobra as obobra
				on obobra.OBOid = pcgdpc.OBOid
			left join minisif..OBproyecto as obproyecto
				on obproyecto.OBPid = obobra.OBPid
	where 	cpp.CPPestado = 1 and cpp.Ecodigo = #session.Ecodigo#
</cfquery>
<!--- Valida que vengan datos --->
<cfif readProyectos.recordcount eq 0>
	<cfthrow message="Error en Interfaz 306. No hay proyectos que registren cambios en el plan de compras. Proceso Cancelado!.">
</cfif>

<cfquery name="readCantProyectos" datasource="#session.dsn#">
	select	count(distinct(pcgpc.PCGEid)) as cantidadProyectos
	from 	minisif..CPresupuestoPeriodo as cpp
			inner join minisif..PCGplanCompras as pcgpc
				on pcgpc.CPPid = cpp.CPPid and pcgpc.Ecodigo = #session.Ecodigo#
			left join minisif..PCGDplanCompras as pcgdpc
				on pcgdpc.PCGEid = pcgpc.PCGEid and pcgdpc.PCGDtipo = 'P' 
				and pcgdpc.PCGDmodificado = 0 and pcgdpc.Ecodigo = #session.Ecodigo#
			<!---left join minisif..PCGDplanComprasMultiperiodo as pcgdpcmp
				on pcgdpcmp.PCGDid = pcgdpc.PCGDid --->
	where 	cpp.CPPestado = 1 and cpp.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif readCantProyectos.cantidadProyectos eq 0>
		<cfthrow message="Error en Interfaz 306. No hay proyectos que que afecten al plan de compras. Proceso Cancelado!.">
</cfif>

<cfquery name="readInt306" datasource="#session.dsn#">
	select	cpp.CPPid, pcgpc.PCGEid, pcgdpc.PCGDid,pcgdpcmp.PCGDid,pcgdpc.PCGDejecutado,pcgdpc.PCGDreservado,pcgdpc.PCGDcomprometido, pcgdpc.PCGDautorizado,pcgdpc.OBOid, obobra.OBPid, obproyecto.OBPcodigo,pcgdpcmp.PCGDautorizadoTotal
	from 	minisif..CPresupuestoPeriodo as cpp
			inner join minisif..PCGplanCompras as pcgpc
				on pcgpc.CPPid = cpp.CPPid and pcgpc.Ecodigo = #session.Ecodigo#
			left join minisif..PCGDplanCompras as pcgdpc
				on pcgdpc.PCGEid = pcgpc.PCGEid and pcgdpc.PCGDtipo = 'P' 
				and pcgdpc.PCGDmodificado = 0 and pcgdpc.Ecodigo = #session.Ecodigo#
			left join minisif..PCGDplanComprasMultiperiodo as pcgdpcmp
				on pcgdpcmp.PCGDid = pcgdpc.PCGDid 
			left join minisif..OBobra as obobra
				on obobra.OBOid = pcgdpc.OBOid
			left join minisif..OBproyecto as obproyecto
				on obproyecto.OBPid = obobra.OBPid
	where 	cpp.CPPestado = 1 and cpp.Ecodigo = #session.Ecodigo#
</cfquery>
<cfif readInt306.recordcount eq 0>
		<cfthrow message="Error en Interfaz 306. No hay registros que afecten proyectos del plan de compras. Proceso Cancelado!.">
</cfif>
<cftransaction>
	<!---IE306:Tabla De Control--->
	<cfquery datasource="sifinterfaces">
		insert into IE306(ID,CANTIDAD_DOCUMENTOS)
		values(#GvarID#,#readCantProyectos.cantidadProyectos#)
	</cfquery>
	<!---IE306:Tabla Proyectos, ietara sobre cada uno de los codigos de proyectos que registraron cambios--->
	<cfloop query="readProyectos">
		<cfquery datasource="sifinterfaces">
			insert into ID306(ID,CODIGO_PROYECTO,PERIODO_CONSULTA)
			values(#GvarID#,#readProyectos.OBPcodigo#,#periodoConsulta#)
		</cfquery>
	</cfloop>	
	<!---IE306:Tabla Lineas X Proyecto, ietara sobre cada 1 de los registros que que afectaron plan de compras--->
	<cfloop query="readInt306">
		<cfquery datasource="sifinterfaces">
			insert into IS306(ID, CODIGO_PROYECTO, CODIGO_CONTRATO_OC, PERIODO_CONSULTA<!---, FUENTE_FINANCIAMIENTO--->, PRESUPUESTO_TOTAL,VARIACIONES_TOTAL,PRESUPUESTO_DEL_PERIODO, VARIACIONES_DEL_PERIODO, <!---EJECUCION_TOTAL,--->EJECUCION_DEL_PERIODO,COMPROMISO_DEL_PERIODO, RESERVA_DEL_PERIODO,DISPONIBLE_DEL_PERIODO)						  			
			values(
					#GvarID#,#readInt306.OBPcodigo#,NULL,#periodoConsulta#,
					Coalesce(#readInt306.PCGDautorizadoTotal#,0.00), 
					0,
					Coalesce(#readInt306.PCGDautorizado#,0.00), 
					0,
					Coalesce(#readInt306.PCGDreservado#,0.00)        +
						Coalesce(#readInt306.PCGDcomprometido#,0.00) + 							
						Coalesce(#readInt306.PCGDejecutado#,0.00)    + 
						Coalesce(#readInt306.PCGDpendiente#,0.00)    + 
						Coalesce(#readInt306.PCGDautorizadoAnteriores#,0.00),
					Coalesce(#readInt306.PCGDejecutado#,0.00), 
					Coalesce(#readInt306.PCGDcomprometido#,0.00), 
					Coalesce(#readInt306.PCGDreservado#,0.00),
					Coalesce(#readInt306.PCGDautorizado#,0.00) 
					   -( Coalesce(#readInt306.PCGDejecutado#,0.00) + 
						  Coalesce(#readInt306.PCGDejecutado#,0.00) +
						  Coalesce(#readInt306.PCGDejecutado#,0.00) ) 
				)
		</cfquery>
	</cfloop>
</cftransaction>