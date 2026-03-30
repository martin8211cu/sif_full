<cfcomponent>
<cffunction name="indicador_tiempos" returntype="query">
	<cfset var tm = QueryNew('')>
	<cfset QueryAddColumn(tm, 'codigo', ListToArray('1,2,3,4,5,6,7,8,9'))>
	<cfset QueryAddColumn(tm, 'nombre', ListToArray(
			'Mes vs Mes anterior,Mes vs Acumulado mes anterior,Mes vs Mes año anterior,' & 
			'Mes vs Acumulado mes año anterior,Año vs Acumulado año anterior,Últimos dos días,' & 
			'Año vs Año anterior') )>
	<cfreturn tm>
</cffunction>


<cffunction name="quad" returntype="struct">
	<cfargument name="desde_act" type="date">
	<cfargument name="hasta_act" type="date">
	<cfargument name="desde_ant" type="date">
	<cfargument name="hasta_ant" type="date">
	<cfset var rv = StructNew()>
	<cfset rv.desde_act = desde_act>
	<cfset rv.hasta_act = hasta_act>
	<cfset rv.desde_ant = desde_ant>
	<cfset rv.hasta_ant = hasta_ant>
	<cfreturn rv>
</cffunction>

<cffunction name="filtro1" returntype="struct" hint="Mes vs Mes anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), Month(fecha),   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('m', -1, CreateDate(Year(fecha), Month(fecha), 1)),
		DateAdd('d', -1, CreateDate(Year(fecha), Month(fecha), 1) ) )>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro2" returntype="struct" hint="Mes vs Acumulado mes anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), Month(fecha),   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('m', -1, CreateDate(Year(fecha), Month(fecha), 1)),
		DateAdd('m', -1, CreateDate(Year(fecha), Month(fecha), Day(fecha))))>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro3" returntype="struct" hint="Mes vs Mes año anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), Month(fecha),   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), Month(fecha), 1)),
		DateAdd('d', -1, DateAdd('m', 1, DateAdd('yyyy', -1, CreateDate(Year(fecha), Month(fecha), 1)))))>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro4" returntype="struct" hint="Mes vs Acumulado mes año anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), Month(fecha),   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), Month(fecha), 1)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), Month(fecha), Day(fecha))))>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro5" returntype="struct" hint="Año vs Acumulado año anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), 1,   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), 1,   1)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), Month(fecha),  Day(fecha))))>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro6" returntype="struct" hint="Últimos dos días">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		DateAdd ('d', -2, CreateDate(Year(fecha), Month(fecha),  Day(fecha))),
		DateAdd ('d', -2, CreateDate(Year(fecha), Month(fecha),  Day(fecha))),
		DateAdd ('d', -1, CreateDate(Year(fecha), Month(fecha),  Day(fecha))),
		DateAdd ('d', -1, CreateDate(Year(fecha), Month(fecha),  Day(fecha))))>
	<cfreturn ret>
</cffunction>

<cffunction name="filtro7" returntype="struct" hint="Año vs año anterior">
<cfargument name="fecha" type="date" required="yes">
	<cfset var ret = quad(
		CreateDate(Year(fecha), 1,   1),
		CreateDate(Year(fecha), Month(fecha),  Day(fecha)),
		DateAdd('yyyy', -1, CreateDate(Year(fecha), 1,  1)),
		DateAdd('d',    -1, CreateDate(Year(fecha), 1,  1)))>
	<cfreturn ret>
</cffunction>


</cfcomponent>
