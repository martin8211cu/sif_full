?<cfcomponent>
	<cffunction name="Kardex_Resumido_Almacen" access="public" returntype="query" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'		type='numeric' 	required='true'>				 <!--- Código empresa ---->
		<cfargument name='almini' 		type='numeric' 	required='true'>				 <!--- Código del Almacén Inicial ---->
		<cfargument name='almfin' 		type='numeric' 	required='true'>				 <!--- Código del Almacén Final ---->
		<cfargument name='Acodigo1' 	type='string' 	required='false' default=""> <!--- Código del Artículo Inicial ---->
		<cfargument name='Acodigo2' 	type='string' 	required='false' default=""> <!--- Código del Artículo Final ---->
		<cfargument name='perini' 		type='numeric' 	required='false' default="0">	 <!--- Periódo Inicial --->
		<cfargument name='mesini' 		type='numeric' 	required='false' default="0">	 <!--- Mes Inicial --->
		<cfargument name='perfin' 		type='numeric' 	required='false' default="0">	 <!--- Período Final --->
		<cfargument name='mesfin' 		type='numeric' 	required='false' default="0">	 <!--- Mes Final --->
		<cfargument name='debug' 		type='string' 	required='false' default="N">

	<cf_dbtemp name="kardexR01" returnvariable="kardexR" datasource="#session.dsn#">
		<cf_dbtempcol name="Acodigo"		    type="char(15)"   	    mandatory="yes">
		<cf_dbtempcol name="Adescripcion"		type="varchar(80)"		mandatory="yes">
		<cf_dbtempcol name="Bdescripcion"		type="varchar(60)" 		mandatory="yes">
		<cf_dbtempcol name="Entradas"  			type="float"	 		mandatory="no">
		<cf_dbtempcol name="Salidas"			type="float"	 		mandatory="no">	
		<cf_dbtempcol name="SaldoUnidades" 		type="float" 			mandatory="no">
		<cf_dbtempcol name="CEntradas"			type="money" 			mandatory="no">	
		<cf_dbtempcol name="CSalidas"  			type="money" 			mandatory="no">
		<cf_dbtempcol name="SaldoCosto"			type="money" 			mandatory="no">
		<cf_dbtempcol name="PrecioMercado"		type="money" 			mandatory="no">
		<cf_dbtempcol name="Aid"  				type="numeric"			mandatory="yes">
		<cf_dbtempcol name="Alm_Aid"  			type="numeric"			mandatory="no">
	</cf_dbtemp>
	
	<cfif not len(trim(Arguments.almini))>
		<cfquery name="rsAlmini" datasource="#session.DSN#">
			select min(Aid) as almini
			from Almacen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarAlmIni = rsAlmini.almini>
	<cfelse>
		<cfset LvarAlmIni = Arguments.almini>
	</cfif>
	
	<cfif not len(trim(Arguments.almfin))>
		<cfquery name="rsAlmfin" datasource="#session.DSN#">
			select max(Aid) as almfin 
			from Almacen 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarAlmFin = rsAlmfin.almfin>
	<cfelse>
		<cfset LvarAlmFin = Arguments.almfin>
	</cfif>	
		
	
	<cfif LvarAlmIni gt LvarAlmFin>
		<cfset LvarAlmTemp = LvarAlmIni>
		<cfset LvarAlmIni = LvarAlmFin>
		<cfset LvarAlmFin = LvarAlmTemp>
	</cfif>
	
	<cfif Arguments.perini gt Arguments.perfin>
		<cfset LvarPerTemp = Arguments.perini>
		<cfset LvarPerIni = Arguments.perfin>
		<cfset LvarPerFin = LvarPerTemp>
	<cfelse>
		<cfset LvarPerIni = Arguments.perini>
		<cfset LvarPerFin = Arguments.perfin>
	</cfif>
	
	<cfif ((Arguments.mesini + Arguments.perini) * 100) gt ((Arguments.mesfin + Arguments.perfin) * 100)>
		<cfset LvarMesTemp = Arguments.mesini>
		<cfset LvarMesini = Arguments.mesfin>
		<cfset LvarMesfin = LvarMesTemp>
	<cfelse>
		<cfset LvarMesini = Arguments.mesini>
		<cfset LvarMesfin = Arguments.mesfin>
	</cfif>
	
	<cfif not len(trim(Arguments.Acodigo1))>
		<cfquery name="rsAcodigo1" datasource="#session.DSN#">
			select min(Acodigo) as Acodigo1
			from Articulos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarAcodigo1 = rsAcodigo1.Acodigo1>
	<cfelse>
		<cfset LvarAcodigo1 = Arguments.Acodigo1>
	</cfif>
	
	<cfif not len(trim(Arguments.Acodigo2))>
		<cfquery name="rsAcodigo2" datasource="#session.DSN#">
			select max(Acodigo) as Acodigo2
			from Articulos 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfset LvarAcodigo2 = rsAcodigo2.Acodigo2>
	<cfelse>
		<cfset LvarAcodigo2 = Arguments.Acodigo2>
	</cfif>
	
	<cfif LvarAcodigo1 gt LvarAcodigo2>
		<cfset LvarAcodigoTemp = LvarAcodigo1>
		<cfset LvarAcodigo1 = LvarAcodigo2>
		<cfset LvarAcodigo2 = LvarAcodigoTemp>
	</cfif>
	<cfif arguments.debug EQ 'S'>
		<cfoutput>
			#LvarAlmIni# AlmIni <br>
			#LvarAlmFin# AlmFin<br>
			#LvarPerIni# PerIni<br>
			#LvarPerFin# PerFin<br>
			#LvarMesini# Mesini<br>
			#LvarMesfin# Mesfin<br>
			#LvarAcodigo1# Acodigo1<br>
			#LvarAcodigo2# Acodigo2<br>
		</cfoutput>
	</cfif>
	
	<cftransaction>
<!---	<cf_dbfunction name="to_float" args="0" returname = "Entradas">
	<cf_dbfunction name="to_float" args="0" returname = "Salidas">
--->	<cf_dbfunction name="to_float" args="e.Eexistencia" returname = "Eexistencia">
	<!--- Saldos Iniciales  --->
	<cfquery datasource="#session.DSN#" name="rsConsulta">
	insert into #kardexR# (
			Acodigo, 
			Adescripcion, 
			Bdescripcion, 
			Entradas, 
			Salidas, 
			SaldoUnidades, 
			CEntradas, 
			CSalidas, 
			SaldoCosto, 
			Aid, 
			Alm_Aid,
			PrecioMercado
		)
		select 
			c.Acodigo,
			c.Adescripcion,  
			b.Bdescripcion, 
			0.00 as Entradas,
			0.00 as Salidas,
<!---		#preservesinglequotes(Entradas)# as Entradas,
			#preservesinglequotes(Salidas)# as Salidas,	--->
			coalesce(Eexistencia,0.00) as SaldoUnidades,
			0.00 as CEntradas, 
			0.00 as CSalidas,
			e.Ecostototal as SaldoCosto,
			c.Aid,
			e.Alm_Aid,
			coalesce((select coalesce(max(cp.CTDprecio),0)  from CostoProduccionSTD cp 
		where cp.Aid   = c.Aid 
		 and CTDperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerFin#">
		 and CTDmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesfin#">
	)
	,0)	
		from Articulos c
		inner join Existencias e
		on e.Aid = c.Aid
			inner join Almacen b
			on b.Aid = e.Alm_Aid
		  	 and b.Aid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmIni#"> 
						and <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmFin#">
			where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		 	 and c.Acodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAcodigo1#"> 
								and <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAcodigo2#">
	</cfquery>
	
<!---	<cf_dump var="#rsConsulta#">--->
	
<!--- 
	<cfif arguments.debug EQ 'S'>
	<cf_dump var="entre">
		<cfquery name="debug2" datasource="#session.DSN#">
			select * from #kardexR#
		</cfquery>
		<cfdump var="#debug2#">
	</cfif>--->
<!--- --->	

	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set SaldoUnidades = SaldoUnidades
	    - coalesce((select sum(k.Kunidades) from Kardex k
				where k.Aid = #kardexR#.Aid
	 		 	and k.Alm_Aid = #kardexR#.Alm_Aid
	  			and k.Kperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerFin#">
	  			and (k.Kmes + k.Kperiodo * 100) > (#LvarMesfin# + #LvarPerFin# * 100 )
			)
			,0.00)
	</cfquery>
	
	
	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set SaldoCosto = SaldoCosto 
		- coalesce((select sum(k.Kcosto) from Kardex k
			where k.Aid = #kardexR#.Aid
	  			 and k.Alm_Aid = #kardexR#.Alm_Aid
	 			 and k.Kperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerFin#">
	  			 and (k.Kmes + k.Kperiodo * 100) > (#LvarMesfin# + #LvarPerFin# * 100)
				)
			, 0.00)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set Entradas = coalesce((select sum(k.Kunidades) from Kardex k
			where k.Aid = #kardexR#.Aid
	  		and k.Alm_Aid = #kardexR#.Alm_Aid
	  		and k.Kperiodo between #LvarPerIni# and #LvarPerFin#
	  		and (k.Kmes + k.Kperiodo * 100) between (#LvarMesini# + #LvarPerIni# * 100) and (#LvarMesfin# + #LvarPerFin# * 100)
	  		and k.Kunidades > 0
			), 0)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set Salidas = coalesce((select sum(abs(k.Kunidades)) from Kardex k
			where k.Aid = #kardexR#.Aid
	  		and k.Alm_Aid = #kardexR#.Alm_Aid
	  		and k.Kperiodo between #LvarPerIni# and #LvarPerFin#
	  		and (k.Kmes + k.Kperiodo * 100) between (#LvarMesini# + #LvarPerIni# * 100) and (#LvarMesfin# + #LvarPerFin# * 100 )
	  		and k.Kunidades < 0
			), 0)
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set CEntradas = coalesce((select sum(k.Kcosto) from Kardex k
			where k.Aid = #kardexR#.Aid
	  		and k.Alm_Aid = #kardexR#.Alm_Aid
	  		and k.Kperiodo between #LvarPerIni# and #LvarPerFin#
	  		and (k.Kmes + k.Kperiodo * 100) between (#LvarMesini# + #LvarPerIni# * 100) and (#LvarMesfin# + #LvarPerFin# * 100 )
	  		and k.Kunidades > 0
			), 0)
	</cfquery>

	<cfquery datasource="#session.DSN#">
		update #kardexR#
		set CSalidas = coalesce((select sum(abs(k.Kcosto)) from Kardex k
			where k.Aid = #kardexR#.Aid
	  		and k.Alm_Aid = #kardexR#.Alm_Aid
	  		and k.Kperiodo between #LvarPerIni# and #LvarPerFin#
	  		and (k.Kmes + k.Kperiodo * 100) between (#LvarMesini# + #LvarPerIni# * 100) and (#LvarMesfin# + #LvarPerFin# * 100 )
	  		and k.Kunidades < 0
			), 0)
	</cfquery>
	
	
<cf_dbfunction name="to_char" args="Aid" returnvariable = "Aid">
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
			#PreserveSingleQuotes(Aid)# as Aid,
			Acodigo,     
			Adescripcion,     
			Bdescripcion,     
			coalesce(SaldoUnidades,0) - coalesce(Entradas,0) + coalesce(Salidas,0) as SaldoinicialU,
			Entradas,     
			Salidas,     
			SaldoUnidades, 	
			coalesce(SaldoCosto,0) - coalesce(CEntradas,0) + coalesce(CSalidas,0) as SaldoCostoC,  		
			CEntradas,
			CSalidas,     
			SaldoCosto,  
			PrecioMercado			
		from #kardexR#
		order by Bdescripcion, 
		Acodigo
	</cfquery>	
			<cfreturn rsReporte>
		</cftransaction>
	</cffunction>
</cfcomponent>


