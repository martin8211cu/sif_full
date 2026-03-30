	<cfquery name="rsMes" datasource="#session.DSN#">
		select  -1 as value, 'Todos' as description from dual
		union all
		select  1 as value, 'Enero' as description from dual
		union all
		select  2 as value, 'Febrero' as description from dual
		union all
		select  3 as value, 'Marzo' as description from dual
		union all
		select  4 as value, 'Abril' as description from dual
		union all
		select  5 as value, 'Mayo' as description from dual
		union all
		select  6 as value, 'Junio' as description from dual
		union all
		select  7 as value, 'Julio' as description from dual
		union all
		select  8 as value, 'Agosto' as description from dual
		union all
		select  9 as value, 'Septiembre' as description from dual
		union all
		select  10 as value, 'Octubre' as description from dual
		union all
		select  11 as value, 'Noviembre' as description from dual
		union all
		select 12 as value, 'Diciembre' as description from dual
		order by 1
	</cfquery>
	
	<cfquery name="rsMes2" datasource="#session.DSN#">
		select  -1 as value, 'Todos' as description from dual
		union all
		select  1 as value, 'Enero' as description from dual
		union all
		select  2 as value, 'Febrero' as description from dual
		union all
		select  3 as value, 'Marzo' as description from dual
		union all
		select  4 as value, 'Abril' as description from dual
		union all
		select  5 as value, 'Mayo' as description from dual
		union all
		select  6 as value, 'Junio' as description from dual
		union all
		select  7 as value, 'Julio' as description from dual
		union all
		select  8 as value, 'Agosto' as description from dual
		union all
		select  9 as value, 'Septiembre' as description from dual
		union all
		select  10 as value, 'Octubre' as description from dual
		union all
		select  11 as value, 'Noviembre' as description from dual
		union all
		select 12 as value, 'Diciembre' as description from dual
		order by 1
	</cfquery>
	
	<cfquery name="Lista" datasource="#session.dsn#">
		select 
			a.CPPid,
			a.CPPanoMesDesde /100  as periodoD, 
			a.Mcodigo,
			a.CPPanoMesDesde, 
			a.CPPanoMesHasta / 100 as periodoH,
			a.CPPanoMesDesde - a.CPPanoMesDesde /100 *100 mesD,
			a.CPPanoMesHasta - a.CPPanoMesHasta /100 *100 mesH,
			
			case a.CPPanoMesDesde - a.CPPanoMesDesde /100 *100  when 1 then 'Enero' when 2 then 'Febrero' 
			when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
			when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
			end as mes, 
			
			case a.CPPanoMesHasta - a.CPPanoMesHasta /100 *100 when 1 then 'Enero' when 2 then 'Febrero' 
			when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
			when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
			end as mes2
			
			from CPresupuestoPeriodo a
			where a.Ecodigo = #Session.Ecodigo#
				<cfif isdefined ('url.FPE') and url.FPE>
				and a.CPPestado = 1
				<cfelse>
				and a.CPPestado = 0
				</cfif>
 			and exists (select 1 from COEstimacionIng where COEPeriodo = a.CPPanoMesDesde /100 and COEEstado = '2' ) 
		
			<cfif isdefined('form.filtro_periodoD')and len(trim(form.filtro_periodoD)) >
				and a.CPPanoMesDesde /100 = #form.filtro_periodoD#
			</cfif>	
			
			<cfif isdefined('form.filtro_mes')and form.filtro_mes neq -1 >
				and a.CPPanoMesDesde - a.CPPanoMesDesde /100 *100 = #form.filtro_mes#
			</cfif>	
			
			<cfif isdefined('form.filtro_mes2')and form.filtro_mes2 neq -1 >
				and a.CPPanoMesHasta - a.CPPanoMesHasta /100 *100 = #form.filtro_mes2#
			</cfif>	
			
			<cfif isdefined('form.filtro_periodoH')and len(trim(form.filtro_periodoH)) >
				and a.CPPanoMesHasta / 100 = #form.filtro_periodoH#
			</cfif>
			order by a.CPPanoMesDesde,a.CPPfechaDesde,a.CPPfechaHasta	
		</cfquery>

	<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
		<cfinvokeargument name="query" 				value="#Lista#"/>
		<cfinvokeargument name="desplegar" 			value=" periodoD,mes,periodoH,mes2"/>
		<cfinvokeargument name="etiquetas" 			value="Periodo Inicial,Mes Inicial,Periodo Final,Mes Final"/>
		<cfinvokeargument name="formatos" 			value="V,V,V,V"/>
		<cfinvokeargument name="align" 				value="left,left,left,left"/>
		<cfinvokeargument name="formName" 			value="EstPres"/>
		<cfinvokeargument name="checkboxes" 		value="N"/>
		<cfinvokeargument name="keys" 				value="CPPid"/>
		<cfinvokeargument name="ira" 					value="EstEnviarFormulacion.cfm?LvarEstimar=TRUE"/>
		<cfinvokeargument name="filtrar_por" 		value="periodoD,mesD,periodoH,mesH"/>					
		<cfinvokeargument name="MaxRows" 			value="10"/>
		<cfinvokeargument name="showEmptyListMsg" value="true"/>
		<cfinvokeargument name="PageIndex" 			value="1"/>
		<cfinvokeargument name="mostrar_filtro" 	value="true"/>
		<cfinvokeargument name="botones" 			value="Nuevo"/>
		<cfinvokeargument name="lineaAzul" 			value="true"/>
		<cfinvokeargument name="rsmes" 				value="#rsMes#"/>
		<cfinvokeargument name="rsmes2" 				value="#rsMes2#"/>
	</cfinvoke>
