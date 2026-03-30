<!---
	Administra horarios de tiempo
	un horario contiene un conjunto de intervalos de tiempo
	un intervalo de tiempo se compone de
		- dia de la semana 1-7. Domingo = 1, Sabado = 7, de manera consistente con DayOfWeek()
		- hora de inicio (HHMM), 24-horas
		- hora de final  (HHMM), 24-horas
	contiene los siguientes métodos
	- void Validate (HorarioString)
	- Horario parse (HorarioString)
	- Horario union (Horario)
	- Horario subtract (Horario)
	- Horario intersect (Horario)
	- Horario fragment (escala)
	- Horario normalize (escala)
	- Horario copy ()
	Parse genera un nuevo objeto
	union,subtract,intersect,fragment y normalize actúan sobre This
	copy regresa un objeto nuevo con el mismo contenido que This
--->
<cfcomponent displayname="Intervalos de tiempo - auxiliar para Agenda.cfc">

<cfset This.IntervalArray = ArrayNew(1)>

<cffunction name="getRegExp" returntype="string">
	<cfset var HORARIO_REGEXP = '^[DLKMJVS](-[DLKMJVS])?[0-9]{1,4}-[0-9]{1,4}(,[DLKMJVS](-[DLKMJVS])?[0-9]{1,4}-[0-9]{1,4})*$'>
	<cfreturn HORARIO_REGEXP>
</cffunction>

<cffunction name="AddInterval" access="package" output="false">
	<cfargument name="dia"    type="numeric" required="yes">
	<cfargument name="inicio" type="string"  required="yes">
	<cfargument name="final"  type="string"  required="yes">
	<cfset var ret = StructNew()>
	<cfset ret.dia    = Arguments.dia>
	<cfset ret.inicio = CompleteHour(Arguments.inicio)>
	<cfset ret.final  = CompleteHour(Arguments.final)>
	<cfif ret.inicio gt ret.final>
		<cfthrow message="Intervalo invalido: #ret.inicio# - #ret.final#">
	</cfif>
	<cfset ArrayAppend(This.IntervalArray, ret)>
</cffunction>
<cffunction name="CountInterval" access="package" output="false" returntype="numeric">
	<cfreturn ArrayLen(This.IntervalArray)>
</cffunction>
<cffunction name="GetInterval" access="package" output="false" returntype="struct">
	<cfargument name="index" type="numeric" required="yes">
	
	<cfif Arguments.index Le 0 Or Arguments.index Gt ArrayLen(This.IntervalArray)>
		<cfthrow message="Argumento index invalido para GetInterval: #index#">
	</cfif>
	<cfreturn This.IntervalArray[Arguments.index]>
</cffunction>

<cffunction name="getString" access="public" output="false" returntype="string">
	<cfset var ret = "">
	<cfloop from="1" to="#CountInterval()#" index="i">	
		<cfset ret = ListAppend(ret, Mid('DLKMJVS', This.IntervalArray[i].dia, 1) 
			& This.IntervalArray[i].inicio & '-' & This.IntervalArray[i].final)>
	</cfloop>
	<cfreturn ret>
</cffunction>

<cffunction name="getQuery" access="public" output="false" returntype="query">
	<cfset var ret = QueryNew("Dia,Inicio,Final")>
	<cfloop from="1" to="#CountInterval()#" index="i">	
		<cfset QueryAddRow(ret)>
		<cfset QuerySetCell(ret, "Dia",    Mid('DLKMJVS', This.IntervalArray[i].dia, 1))>
		<cfset QuerySetCell(ret, "Inicio", This.IntervalArray[i].inicio)>
		<cfset QuerySetCell(ret, "Final",  This.IntervalArray[i].final)>
	</cfloop>
	<cfreturn ret>
</cffunction>

<cffunction name="Validate" access="public" output="false">
	<cfargument name="HorarioString" type="string">

	<cfif REFind(getRegExp(), Arguments.HorarioString) Is 0>
		<cfthrow message="Horario malformado, debe ser de la forma L-M0800-1700[,J-V0800-1200 ...]"></cfif>
</cffunction>

<cffunction name="Always" access="public" output="false" returntype="Horario">
	<cfreturn This.Parse('L-D0000-2400')>
</cffunction>

<cffunction name="WholeDay" access="public" output="false" returntype="Horario">
	<cfargument name="weekday" type="numeric" required="yes">
	<cfset var ret = This.Empty()>
	<cfset ret.addInterval(Arguments.weekday,'0000','2400')>
	<cfreturn ret>
</cffunction>

<cffunction name="Empty" access="public" output="false" returntype="Horario">
	<cfreturn CreateObject("Component", "Horario")>
</cffunction>

<cffunction name="CompleteHour" access="private" output="false" returntype="string">
	<cfargument name="HourPart" type="string" required="yes">

	<cfif Len(Arguments.HourPart) Is 1>
		<cfreturn '0' & Arguments.HourPart & '00'>
	<cfelseif Len(Arguments.HourPart) Is 2>
		<cfreturn Arguments.HourPart & '00'>
	<cfelseif Len(Arguments.HourPart) Is 3>
		<cfreturn '0' & Arguments.HourPart>
	<cfelseif Len(Arguments.HourPart) Is 4>
		<cfreturn Arguments.HourPart>
	<cfelse>
		<cfthrow message="Hora invalida: #Arguments.HourPart#">
	</cfif>
</cffunction>

<cffunction name="Parse" access="public" output="false" returntype="Horario">
	<cfargument name="HorarioString" type="string">

	<cfset This.Validate(Arguments.HorarioString)>
	<cfset ret = This.Empty()>
	<cfloop from="1" to="#ListLen(HorarioString)#" index="i">
		<cfset Item = ListGetAt(HorarioString, i)>
		<cfset parts = REFind('^([DLKMJVS])(?:-)?([DLKMJVS])?([0-9]{1,4})-([0-9]{1,4})$', Item, 1, true)>
		<cfif ArrayLen(parts.len) Neq 5 Or ArrayLen(parts.pos) Neq 5>
			<cfthrow message="Horario malformado. Item: #Item#">
		</cfif>
		
		<cfset Dia1 = Mid(Item, parts.pos[2], parts.len[2])>
		<cfif parts.pos[3]>
			<cfset Dia2 = Mid(Item, parts.pos[3], parts.len[3])>
		<cfelse>
			<cfset Dia2 = Dia1>
		</cfif>
		<cfset Dia1 = Find(Dia1, "DLKMJVS")>
		<cfset Dia2 = Find(Dia2, "DLKMJVS")>
		<cfif Dia1 Is 0 Or Dia2 Is 0>
			<cfthrow message="Dia inválido: #Item#. Debe estar en 'DLKMJVS'"></cfif>
		<cfset Hora1 =  Mid(Item, parts.pos[4], parts.len[4])>
		<cfset Hora2 =  Mid(Item, parts.pos[5], parts.len[5])>
		<cfset dia = Dia1>
		<cfloop from="1" to="9" index="dummy">
			<cfset ret.AddInterval(Dia, Hora1, Hora2)>
			<cfif Dia Is Dia2><cfbreak></cfif>
			<cfif Dia Is 7><cfset Dia = 1>
				<cfelse><cfset Dia = Dia + 1></cfif>
		</cfloop>
	</cfloop>
	<cfreturn ret.normalize()>
</cffunction>

<cffunction name="Copy" access="public" output="false" returntype="Horario">
	<cfset var copy = This.Empty()>
	<cfloop from="1" to="#ArrayLen(This.IntervalArray)#" index="i">
		<cfset copy.AddInterval(This.IntervalArray[i].dia, This.IntervalArray[i].inicio, This.IntervalArray[i].final)>
	</cfloop>
	<cfreturn copy>
</cffunction>

<cffunction name="Normalize" access="public" output="false" returntype="Horario">
	<!--- ordenar elementos --->
	<cfset var tmp = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(This.IntervalArray)#" index="i">
		<cfset tmp[i] = This.IntervalArray[i].dia & "," & 
			This.IntervalArray[i].inicio & "," & This.IntervalArray[i].final>
	</cfloop>
	<cfset ArraySort (tmp, 'text')>
	<cfset This.IntervalArray = ArrayNew(1)>
	<cfloop from="1" to="#ArrayLen(tmp)#" index="i">
		<cfset This.AddInterval(ListGetAt(tmp[i], 1), ListGetAt(tmp[i], 2), ListGetAt(tmp[i], 3) )>
	</cfloop>
	<!--- unir IntervalArray contiguos y continuos --->
	<cfloop from="#ArrayLen(This.IntervalArray) - 1#" to="1" step="-1" index="i">
		<cfif This.IntervalArray[i].dia    IS This.IntervalArray[i+1].dia And
		      This.IntervalArray[i].inicio LE This.IntervalArray[i+1].Final And
		      This.IntervalArray[i].final  GE This.IntervalArray[i+1].Inicio>
		   <cfset This.IntervalArray[i].inicio = Min (This.IntervalArray[i].inicio,This.IntervalArray[i+1].inicio)>
		   <cfset This.IntervalArray[i].final  = Max (This.IntervalArray[i].final, This.IntervalArray[i+1].final)>
		   <cfset ArrayDeleteAt(This.IntervalArray, i+1)>
		</cfif>
	</cfloop>
	<!--- eliminar IntervalArray vacios --->
	<cfloop from="#ArrayLen(This.IntervalArray)#" to="1" step="-1" index="i">
		<cfif This.IntervalArray[i].inicio GE This.IntervalArray[i].final>
		   <cfset ArrayDeleteAt(This.IntervalArray, i)>
		</cfif>
	</cfloop>
	<cfreturn This>
</cffunction>

<cffunction name="Union" access="public" output="false" returntype="Horario">
	<cfargument name="horario2" type="Horario" required="yes">
	<cfset var cur = "">
	<cfloop from="1" to="#Horario2.CountInterval()#" index="i">
		<cfset cur = Horario2.GetInterval(i)>
		<cfset This.AddInterval(cur.dia, cur.inicio, cur.final)>
	</cfloop>
	<cfreturn This.normalize()>
</cffunction>

<cffunction name="Subtract" access="public" output="false" returntype="Horario">
	<cfargument name="horario2" type="Horario" required="yes">
	
	<cfloop from="1" to="#horario2.CountInterval()#" index="Horario2Index">
		<cfset cur2 = Horario2.GetInterval(Horario2Index)>
		<cfif cur2.inicio LT cur2.final>
			<!--- Solamente se resta si el intervalo tiene duracion != 0  --->
			<cfloop from="1" to="#This.CountInterval()#" index="SelfIndex">
				<cfif SelfIndex GT This.CountInterval()>
					<cfbreak>
				</cfif>
				<cfset self = This.GetInterval(SelfIndex)>
				<cfif cur2.dia EQ self.dia>
					<!--- Solamente se resta si es para el mismo día --->
					<cfif     cur2.inicio Le self.inicio And
							  cur2.final  Ge self.final  >
						<!--- eliminar intervalo --->
						<cfset ArrayDeleteAt(This.IntervalArray, SelfIndex)>
					<cfelseif cur2.inicio Gt self.inicio And
							  cur2.final  Lt self.final  >
						<!--- separar en dos intervalos separados --->
						<cfset This.addInterval(  self.dia, cur2.final, self.final)>
						<cfset self.final = cur2.inicio>
					<cfelseif cur2.inicio Gt self.inicio And
							  cur2.inicio Lt self.final  And
							  cur2.final  Ge self.final  >
						<!--- This.inicio := horario2.inicio --->
						<cfset self.final = cur2.inicio>
					<cfelseif cur2.final  Gt self.inicio And
							  cur2.final  Lt self.final  And
							  cur2.inicio Le self.inicio >
						<!--- This.final := horario2.final --->
						<cfset self.inicio = cur2.final>
					<cfelseif cur2.inicio Lt self.final And 
							  cur2.final  Gt self.inicio>
						<!--- hay choques de horario no esperados --->
						<cfthrow message="Subtract: assertion failed">
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
	<cfreturn This.normalize()>
</cffunction>

<cffunction name="Intersect" access="public" output="false" returntype="Horario">
	<cfargument name="horario2" type="Horario" required="yes">
	<cfset var ret = This.Empty()>
	<cfloop from="1" to="#horario2.CountInterval()#" index="Horario2Index">
		<cfset cur2 = Horario2.GetInterval(Horario2Index)>
		<cfif cur2.inicio LT cur2.final>
			<!--- Solamente se cuenta si el intervalo tiene duracion != 0  --->
			<cfloop from="1" to="#This.CountInterval()#" index="SelfIndex">
				<cfset self = This.GetInterval(SelfIndex)>
				<cfif cur2.dia EQ self.dia>
					<!--- Solamente se resta si es para el mismo día --->
					<cfif cur2.inicio Lt self.final And 
							  cur2.final  Gt self.inicio>
						<cfset ret.addInterval(self.dia, Max(self.inicio, cur2.inicio), Min(self.final, cur2.final))>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfloop>
	<cfset This = ret>
	<cfreturn This.normalize()>
</cffunction>

<cffunction name="Fragment" access="public" output="false" returntype="Horario">
	<cfargument name="escala" type="numeric" required="yes">
	
	<cfset var ret = This.Empty()>
	<cfset var cur = "">
	
	<cfloop from="1" to="#This.CountInterval()#" index="i">
		<cfset cur = This.GetInterval(i)>
		<cfset inicio = Val(Mid(cur.inicio,1,2)) * 60 + Val(Mid(cur.inicio,3,2))>
		<cfset final  = Val(Mid(cur.final, 1,2)) * 60 + Val(Mid(cur.final, 3,2))>
		<cfset inicio = Ceiling(inicio / Arguments.escala) * Arguments.escala>
		<cfset final  = Int    (final  / Arguments.escala) * Arguments.escala>
		<cfloop from="#inicio#" to="#final-Arguments.escala#" step="#Arguments.escala#" index="i2">
			<cfset f2 = i2 + Arguments.escala>
			<cfset i3 = NumberFormat(int(i2 / 60),'00') & NumberFormat(i2 mod 60,'00')>
			<cfset f3 = NumberFormat(int(f2 / 60),'00') & NumberFormat(f2 mod 60,'00')>
			<cfset ret.addInterval(cur.dia, i3, f3)>
		</cfloop>
	</cfloop>
	<cfset This = ret>
	<cfreturn ret>
</cffunction>

</cfcomponent>