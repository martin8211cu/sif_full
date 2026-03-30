<cfcomponent>

<cffunction name="uso_expr" returntype="string">
	<cfargument name="columna">
	<cfargument name="uso">
	
	<cfswitch expression="#Arguments.uso#">
		<cfcase value="sum,max,min,avg">
			<cfreturn Arguments.uso & "(" & Arguments.columna & ")">
		</cfcase>
		<cfcase value="wavg">
			<cfreturn "sum(" & Arguments.columna & " * peso_" & Arguments.columna & ")/sum(peso_" & Arguments.columna & ")">
		</cfcase>
		<cfcase value="first,last">
			<!--- se deben sumar las del primer/ultimo dia --->
			<cfreturn "sum(" & Arguments.columna & ")">
		</cfcase>
		
		<cfdefaultcase>
			<cfthrow message="Uso invalido : #Arguments.uso#">
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="dar_formato" returntype="string">
	<cfargument name="valor" type="numeric">
	<cfargument name="formato" type="string">
	
	<cfif formato is '$'>
		<cfif valor LT 0.01 and valor GT 0>
			<cfreturn '<0.01'>
		<cfelse>
			<cfreturn NumberFormat(valor,',0.00')>
		</cfif>
	<cfelseif formato is '%'>
		<cfif valor LT 0.001 and valor GT 0>
			<cfreturn '<0.1%'>
		<cfelse>
			<cfreturn NumberFormat(valor*100,',0.0') & '%'>
		</cfif>
	<cfelseif formato is 'N'>
		<cfif valor LT 0.1 and valor GT 0>
			<cfreturn '<0.1'>
		<cfelse>
			<cfreturn NumberFormat(valor,',0.0')>
		</cfif>
	<cfelseif formato is 'F'>
		<cfif valor LT 0.001 and valor GT 0>
			<cfreturn '<0.001'>
		<cfelseif valor NEQ Int(Valor)>
			<cfreturn NumberFormat(valor,',0.000')>
		<cfelse>
			<cfreturn NumberFormat(valor,',0')>
		</cfif>
	<cfelse>
		<cfthrow message="Formato invalido: #formato# para el valor #valor#">
	</cfif>
</cffunction>

<cffunction name="extrae_valor">
	<cfargument name="indicador" type="string">
	<cfargument name="columna"   type="string">
	<cfargument name="uso"       type="string">
	<cfargument name="es_diario" type="boolean">
	<cfargument name="desde"     type="date">
	<cfargument name="hasta"     type="date">
	
	<cfset var ticks=GetTickCount()>
	
	<cfif Arguments.es_diario>
		<!--- igual que en portlets/indicacores/detalle-form.cfm --->
		<cfset divide_diario =  " ">
	<cfelse>
		<cfset divide_diario =  "/ count(distinct fecha) ">
	</cfif>

	<cfset expresion_total = uso_expr('total', Arguments.uso)>
	<cfset expresion_valor = uso_expr('valor', Arguments.uso)>
	<!--- --->
	
	<cfif uso is 'first'>
		<cfquery name="usar_fecha" datasource="#session.dsn#">
			select min(fecha) as fecha from IndicadorValor
			where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
			  and fecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.desde#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 </cfquery>
		 <cfif Len(usar_fecha.fecha) is 0><cfset usar_fecha.fecha = Arguments.desde></cfif>
		 <cfset usar_fecha.fecha = CreateDate(Year(usar_fecha.fecha), Month(usar_fecha.fecha), Day(usar_fecha.fecha))>
	<cfelseif uso is 'last'>
		<cfquery name="usar_fecha" datasource="#session.dsn#">
			select max(fecha) as fecha from IndicadorValor
			where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
			  and fecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.hasta#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		 </cfquery>
		 <cfif Len(usar_fecha.fecha) is 0><cfset usar_fecha.fecha = Arguments.hasta></cfif>
		 <cfset usar_fecha.fecha = CreateDate(Year(usar_fecha.fecha), Month(usar_fecha.fecha), Day(usar_fecha.fecha))>
	</cfif>
	<!---
	<cfoutput>ticks #indicador# 1:#GetTickCount()-ticks #;<br></cfoutput>
	--->
	<cfset ticks=GetTickCount()>
 
	<cfquery datasource="#session.dsn#" name="query_valor" >
		select
			count(1) as cantidad,
			coalesce ( # expresion_total # # divide_diario #, 0) as total,
			coalesce ( # expresion_valor # # divide_diario #, 0) as valor
		from IndicadorValorEmp
		where indicador = <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">--->'#Arguments.indicador#'
		<cfif uso is 'first' or uso is 'last'>
		  and fecha = #usar_fecha.fecha#<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#usar_fecha.fecha#">--->
		<cfelse>
		  and fecha between #Arguments.desde#<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.desde#">--->
		                and #Arguments.hasta#<!---<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.hasta#">--->
		</cfif>
		  and CEcodigo = #session.CEcodigo#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">--->
		  and Ecodigo = #session.Ecodigo#<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">--->
	</cfquery> 
	<!---
	<cfoutput>ticks #indicador# 2:#GetTickCount()-ticks#;#query_valor.cantidad# regs<br></cfoutput>
	--->
	<cfreturn query_valor>
</cffunction>

<cffunction name="calcular_indicador" returntype="struct">
	<cfargument name="indicador"      type="string"  required="yes">
	<cfargument name="filtro_tiempo"  type="numeric" required="yes">
	<cfargument name="fecha"          type="date"    required="yes">
	
	<cfset var ret = 0 >
	
	<cfquery datasource="asp" name="datos_indicador">
		select es_diario, formato, uso_valor, uso_total
		from Indicador
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.indicador#">
	</cfquery>
	<cfif Len(datos_indicador.es_diario) Is 0>
		<cfthrow message="Indicador #Arguments.indicador# no existe">
	</cfif>
	
	<cfinvoke component="IndicadorTiempos" method="filtro#filtro_tiempo#" 
		returnvariable="ret" fecha="#Arguments.fecha#">
	</cfinvoke>
	
	<cfset ret.es_diario = datos_indicador.es_diario>
	<cfset ret.formato   = datos_indicador.formato>
	<cfset ret.uso_valor = datos_indicador.uso_valor>
	<cfset ret.uso_total = datos_indicador.uso_total>
	
	<cfset tmp = extrae_valor (Arguments.indicador, 'valor', datos_indicador.uso_valor, datos_indicador.es_diario, ret.desde_act, ret.hasta_act)>
	<cfset ret.valor_actual   = tmp.valor>
	<cfset ret.total_actual   = tmp.total>

	<cfset tmp = extrae_valor (Arguments.indicador, 'valor', datos_indicador.uso_valor, datos_indicador.es_diario, ret.desde_ant, ret.hasta_ant)>
	<cfset ret.valor_anterior = tmp.valor>
	<cfset ret.total_anterior = tmp.total>
	<!---
	<cfset ret.valor_actual   = extrae_valor (Arguments.indicador, 'valor', datos_indicador.uso_valor, datos_indicador.es_diario, ret.desde_act, ret.hasta_act)>
	<cfset ret.total_actual   = extrae_valor (Arguments.indicador, 'total', datos_indicador.uso_total, datos_indicador.es_diario, ret.desde_act, ret.hasta_act)>

	<cfset ret.valor_anterior = extrae_valor (Arguments.indicador, 'valor', datos_indicador.uso_valor, datos_indicador.es_diario, ret.desde_ant, ret.hasta_ant)>
	<cfset ret.total_anterior = extrae_valor (Arguments.indicador, 'total', datos_indicador.uso_total, datos_indicador.es_diario, ret.desde_ant, ret.hasta_ant)>
	--->

	<cfset ret.actual   = IIf(ret.total_actual  , 'ret.valor_actual   / ret.total_actual  ', 'ret.valor_actual  ')>
	<cfset ret.anterior = IIf(ret.total_anterior, 'ret.valor_anterior / ret.total_anterior', 'ret.valor_anterior')>

	<!--- <cfset ret.incremento = IIf(ret.valor_anterior, '(ret.valor_actual/ret.valor_anterior-1)*100', '0')> --->
	<cfset ret.incremento = IIf(ret.anterior, '(ret.actual/ret.anterior-1)*100', '0')>

	<cfset ret.fmt_actual   = dar_formato(ret.actual,   datos_indicador.formato)>
	<cfset ret.fmt_anterior = dar_formato(ret.anterior, datos_indicador.formato)>
<!---	
	<cfif trim(indicador) eq 'rotacion' and session.sitio.ip is '200.122.128.247'><cf_dump var="#ret#"></cfif>
--->
	<cfreturn ret>
</cffunction>

</cfcomponent>
