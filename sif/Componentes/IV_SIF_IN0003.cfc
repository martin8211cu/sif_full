<!--- Kardex Detallado por Almacén
creado por: Marcel de Mézerville L.
	Fecha 21-Oct-2002

Modificado por: Gustavo Fonseca Hernández.
	Fecha: 25-7-2006.
	Motivo: Se pasa el sp_SIF_IN0003 a Componente.
--->
<cfcomponent>
	<cffunction name="Kardex_Detallado_Almacen" access="public" returntype="query" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>				 <!--- Código empresa ---->
		<cfargument name='almini' 				type='numeric' 	required='true'>				 <!--- Código del Almacén Inicial ---->
		<cfargument name='almfin' 				type='numeric' 	required='true'>				 <!--- Código del Almacén Final ---->
		<cfargument name='Acodigo1' 		type='string' 		required='false' default="">     <!--- Código del Artículo Inicial ---->
		<cfargument name='Acodigo2' 		type='string' 		required='false' default="">     <!--- Código del Artículo Final ---->
		<cfargument name='perini' 				type='numeric' 	required='false' default="0">	 <!--- Periódo Inicial --->
		<cfargument name='mesini' 				type='numeric' 	required='false' default="0">	 <!--- Mes Inicial --->
		<cfargument name='perfin' 				type='numeric' 	required='false' default="0">	 <!--- Período Final --->
        <cfargument name='Kartipo' 			type='string' 		required='false' default="T">	 <!--- Tipo Kardex (T = Todos)--->
		<cfargument name='mesfin' 			type='numeric' 	required='false' default="0">	 <!--- Mes Final --->
		<cfargument name='Dcodigo' 			type='numeric' 	required='false' >	             <!--- Departamento --->
		<cfargument name='debug' 				type='string' 		required='false' default="N">
        <cfargument name="Fechadesde" 	type="string" 		required="no">					 <!--- Fecha desde --->
        <cfargument name="Fechahasta" 	type="string" 		required="no">					 <!--- Fecha hasta --->
		<cfargument name='Ccodigo' 			type='numeric' 	required='false' default="0">	 <!--- Código de la Clasificacion Inicial ---->
		<cfargument name='CcodigoF'		type='numeric' 	required='false' default="0">	 <!--- Código de la Clasificacion Final ---->

	<cf_dbtemp name="tempIvekar_v1" returnvariable="kardex" datasource="#session.dsn#">
		<cf_dbtempcol name="Acodigo"		    	type="char(15)"   	    mandatory="yes">
		<cf_dbtempcol name="Acodalterno"		type="char(20)"   	    mandatory="no">
		<cf_dbtempcol name="Adescripcion"		type="varchar(80)"		mandatory="yes">
		<cf_dbtempcol name="Bdescripcion"		type="varchar(60)" 	mandatory="yes">
		<cf_dbtempcol name="Kperiodo"			type="integer" 			mandatory="no">	
		<cf_dbtempcol name="Kmes"  				type="integer" 			mandatory="no">
		<cf_dbtempcol name="CCTcodigo"		type="char(2)" 			mandatory="no">
        <cf_dbtempcol name="Ktipo"  				type="char(1)"				mandatory="no">
        <cf_dbtempcol name="KtipoES"  			type="char(1)"				mandatory="no">
        
		
		<cf_dbtempcol name="Kdocumento"  	type="char(20)"	 		mandatory="no">
		<cf_dbtempcol name="Kfecha"  				type="datetime"			mandatory="no">
		<cf_dbtempcol name="Entradas"  			type="float"	 				mandatory="no">
		<cf_dbtempcol name="Salidas"				type="float"	 				mandatory="no">	
		
		<cf_dbtempcol name="SaldoUnidades" 	type="float" 				mandatory="no">
		
		<cf_dbtempcol name="CEntradas"			type="money" 			mandatory="no">	
		<cf_dbtempcol name="CSalidas"  			type="money" 			mandatory="no">
		<cf_dbtempcol name="SaldoCosto"		type="money" 			mandatory="no">
	
		<cf_dbtempcol name="Kid"					type="numeric" 			mandatory="yes">
		<cf_dbtempcol name="Aid"  					type="numeric"			mandatory="yes">
		<cf_dbtempcol name="Alm_Aid"  			type="numeric"			mandatory="no">
		<cf_dbtempcol name="Dcodigo"  			type="integer"			mandatory="no">
        <cf_dbtempcol name="Eestante"  			type="varchar(15)"		mandatory="no">
        <cf_dbtempcol name="Ecasilla"  			type="varchar(15)"		mandatory="no">
        <cf_dbtempcol name="Usuario"				type="varchar(200)"	mandatory="no">
	</cf_dbtemp>

	<cfif not len(trim(Arguments.almini))>
		<cfquery name="rsAlmini" datasource="#session.DSN#">
			select min(Aid) as almini
			from Almacen 
			where Ecodigo =  #Arguments.Ecodigo# 
		</cfquery>
		<cfset LvarAlmIni = rsAlmini.almini>
	<cfelse>
		<cfset LvarAlmIni = Arguments.almini>
	</cfif>
	
	<cfif not len(trim(Arguments.almfin))>
		<cfquery name="rsAlmfin" datasource="#session.DSN#">
			select max(Aid) as almfin 
			from Almacen 
			where Ecodigo =  #Arguments.Ecodigo# 
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
    
    <cfif isdefined('Arguments.Fechadesde') and len(trim(#Arguments.Fechadesde#))>
    	<cfset LvarFechaIni=#Arguments.Fechadesde#>
        <cfset LvarAno= mid(LvarFechaIni,7,4)>
        <cfset LvarMes= mid(LvarFechaIni,4,2)>
    </cfif>
    <cfif isdefined('Arguments.Fechahasta') and len(trim(#Arguments.Fechahasta#))>
    	<cfset LvarFechaFin=#Arguments.Fechahasta#>
        <cfset LvarAnoF= mid(Fechahasta,7,4)>
        <cfset LvarMesF= mid(Fechahasta,4,2)>
    </cfif>
	
	<cfif not len(trim(Arguments.Acodigo1))>
		<cfquery name="rsAcodigo1" datasource="#session.DSN#">
			select min(Acodigo) as Acodigo1
			from Articulos 
			where Ecodigo =  #Arguments.Ecodigo# 
		</cfquery>
		<cfset LvarAcodigo1 = rsAcodigo1.Acodigo1>
	<cfelse>
		<cfset LvarAcodigo1 = Arguments.Acodigo1>
	</cfif>
	
	<cfif not len(trim(Arguments.Acodigo2))>
		<cfquery name="rsAcodigo2" datasource="#session.DSN#">
			select max(Acodigo) as Acodigo2
			from Articulos 
			where Ecodigo =  #Arguments.Ecodigo# 
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

	<cfif Arguments.Ccodigo gt Arguments.CcodigoF>
		<cfset LvarCcodigoTemp = Arguments.Ccodigo>
		<cfset LvarCcodigoIni = Arguments.CcodigoF>
		<cfset LvarCcodigoFin = LvarCcodigoTemp>
	<cfelse>
		<cfset LvarCcodigoIni = Arguments.Ccodigo>
		<cfset LvarCcodigoFin = Arguments.CcodigoF>
	</cfif>
    
	<cfif arguments.debug EQ 'S'>
		<cfoutput>
			#LvarAlmIni# AlmIni <br>
			#LvarAlmFin# AlmFin<br>
          <cfif isdefined('Arguments.Fechadesde') and len(trim(#Arguments.Fechadesde#))>
			#LvarFechaIni# FechaIni<br>
			#LvarFechaFin# FechaFin<br>
		  <cfelse>	
			#LvarPerIni# PerIni<br>
			#LvarPerFin# PerFin<br>
			#LvarMesini# Mesini<br>
			#LvarMesfin# Mesfin<br>
		  </cfif>
			#LvarAcodigo1# Acodigo1<br>
			#LvarAcodigo2# Acodigo2<br>
			#LvarCcodigoIni# Ccodigo<br>
			#LvarCcodigoFin# CcodigoF<br>
		</cfoutput>
	</cfif>
	<cftransaction>
	<!--- Saldos Iniciales  --->
    
	<cfquery datasource="#session.DSN#">
		insert into #kardex# (
			Acodigo,
            Acodalterno,    
			Adescripcion,     
			Bdescripcion,     
			Kperiodo,     
			Kmes,     
			CCTcodigo,
            Ktipo,
			Kdocumento,    
			 
			Kfecha,     
			Entradas,     
			Salidas,   
			  
			SaldoUnidades,     
			CEntradas,
			CSalidas,     
			SaldoCosto,     
			Kid,     
			Aid,     
			Alm_Aid,
			Dcodigo,
            Eestante,
        	Ecasilla,
            Usuario	
		)
		select 
			c.Acodigo, 
            c.Acodalterno,
			c.Adescripcion,  
			b.Bdescripcion, 
            <cfif isdefined('LvarFechaIni') and len(trim(#LvarFechaIni#))>
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarAno#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMes#">,
            <cfelse>
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerIni#">,
				<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesIni#">,
            </cfif>
			<cf_jdbcquery_param cfsqltype="cf_sql_char" value="null">, 
            <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Arguments.Kartipo#">, 
			'Saldo Inicial', 
			<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="null">, 
			<cf_jdbcquery_param cfsqltype="cf_sql_float" value="null">,
			<cf_jdbcquery_param cfsqltype="cf_sql_float" value="null">,
			Coalesce(a.EIexistencia, 0.00), 
			0.00, 
			0.00, 
			Coalesce(a.EIcosto, 0.00), 
			0, 
			c.Aid, 
			e.Alm_Aid,
			b.Dcodigo,
            e.Eestante, 
        	e.Ecasilla	,
            <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">
		from Articulos c
        
			inner join Existencias e
				on e.Aid = c.Aid
                
			inner join Almacen b
				on b.Aid = e.Alm_Aid
                			
			left join ExistenciaInicial a
		  		 on a.Aid      = e.Aid
		  	    and a.Alm_Aid = e.Alm_Aid
                
		where c.Ecodigo =  #Arguments.Ecodigo# 
		  and c.Acodigo between <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#LvarAcodigo1#"> and <cf_jdbcquery_param cfsqltype="cf_sql_char"    value="#LvarAcodigo2#">
		  and b.Aid between     <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarAlmIni#">   and <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarAlmFin#">
        <cfif isdefined('LvarFechaIni') and len(trim(#LvarFechaIni#))>
		  and a.EIperiodo =     <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarAno#">
		  and a.EIMes     =     <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMes#">
        <cfelse>
		  and a.EIperiodo =     <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarPerIni#">
		  and a.EIMes     =     <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#LvarMesIni#">
        </cfif>  
		<cfif isdefined("Arguments.Dcodigo") and len(trim(Arguments.Dcodigo))>
		  and b.Dcodigo  =      <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.Dcodigo#">
		</cfif>
		<cfif #LvarCcodigoIni# neq 0 and #LvarCcodigoFin# neq 0>
            and c.Ccodigo between <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCcodigoIni#"> 
                            and <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarCcodigoFin#">
        </cfif>                                
	</cfquery>
	
	<cfif arguments.debug EQ 'S'>
		<cfquery name="debug1" datasource="#session.DSN#">
			select * from #kardex#
		</cfquery>
		<cfdump var="#debug1#">
	</cfif>
		  
	<!--- Saldos Iniciales --->
	<cfquery datasource="#session.DSN#">
		insert into #kardex# (
			Acodigo,    
            Acodalterno, 
			Adescripcion,     
			Bdescripcion,     
			Kperiodo,     
			Kmes,     
			CCTcodigo,
            Ktipo,
			Kdocumento,     
			Kfecha,     
			Entradas,     
			Salidas,     
			SaldoUnidades,     
			CEntradas,
			CSalidas,     
			SaldoCosto,     
			Kid,     
			Aid,     
			Alm_Aid,
			Dcodigo,
            Eestante,
        	Ecasilla,
            Usuario,
			KtipoES	
		)
		select 
			c.Acodigo, 
            c.Acodalterno,
			c.Adescripcion,  
			b.Bdescripcion, 
			a.Kperiodo, 	
			a.Kmes, 
			a.CCTcodigo,             
            a.Ktipo,
			a.Kdocumento, 
			a.Kfecha,  
			
			case when a.Kunidades >= 0 then <cf_dbfunction name="to_float" args="abs(a.Kunidades)"> else null end as Entradas,
			case when a.Kunidades < 0 then  <cf_dbfunction name="to_float" args="abs(a.Kunidades)"> else null end as Salidas,
			coalesce(<cf_dbfunction name="to_float" args="a.Kexistant + a.Kunidades">,0.00) as SaldoUnidades,
			coalesce(case when a.Kcosto >= 0 then abs(a.Kcosto) else null end,0.00) as CEntradas,
			coalesce(case when a.Kcosto < 0 then  abs(a.Kcosto) else null end,0.00) as CSalidas,
			coalesce(round(Kcostoant, 2) + round(Kcosto, 2),0.00) as SaldoCosto,
			coalesce(a.Kid, -1) as Kid,
			
			c.Aid,
			e.Alm_Aid,
			b.Dcodigo,
            e.Eestante,
        	e.Ecasilla	,
            coalesce(u.Usulogin,' '),
            a.KtipoES
            
		from Articulos c
		
         inner join Existencias e
		 	on e.Aid = c.Aid
		 
         inner join Almacen b
		 	on b.Aid = e.Alm_Aid
		 
         inner join Kardex a
		 	on a.Aid = e.Aid
		   and a.Alm_Aid = e.Alm_Aid
           
		left join Usuario u
		 	on u.Usucodigo = a.BMUsucodigo
            
		where c.Ecodigo =  #Arguments.Ecodigo# 
		  and c.Acodigo between <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAcodigo1#"> and <cfqueryparam cfsqltype="cf_sql_char" value="#LvarAcodigo2#">
		  and b.Aid between <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmIni#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAlmFin#">
		<cfif isdefined('LvarFechaIni') and len(trim(#LvarFechaIni#)) and isdefined('LvarFechaFin') and len(trim(#LvarFechaFin#))>
    	 <!--- and a.Kperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAno#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAnoF#">
		  and (a.Kmes + a.Kperiodo * 100 ) between (<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMes#">  + <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAno#">  * 100) 
				and (<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesF#"> + <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarAnoF#"> * 100)--->
		  and Kfecha between <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(LvarFechaIni)#"> and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#lsparsedatetime(LvarFechaFin)#">              
        <cfelse>
    	  and a.Kperiodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerIni#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarperFin#">
		  and (a.Kmes + a.Kperiodo * 100 ) between (<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesIni#">  + <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPerIni#">  * 100) 
				and (<cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesFin#"> + <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarperFin#"> * 100)
        </cfif>        
	  	<cfif isdefined("Arguments.Dcodigo") and len(trim(Arguments.Dcodigo))>
          and b.Dcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Dcodigo#">
      	</cfif>
        <cfif Arguments.Kartipo neq 'T'>
        	and a.Ktipo = <cfqueryparam  cfsqltype="char" value="#Arguments.Kartipo#"> 
        </cfif> 
	</cfquery> 
	
	<cfif arguments.debug EQ 'S'>
		<cfquery name="debug2" datasource="#session.DSN#">
			select * from #kardex#
		</cfquery>
		<cfdump var="#debug2#">
	</cfif>
	 
	 <cf_dbfunction name="to_char" args="Kid"   returnvariable="AKid">
	 <cf_dbfunction name="length"  args="#AKid#" returnvariable="LenKid">
	 <cf_dbfunction name="sRepeat"	args="'0': 18 - #LenKid#" delimiters=":" returnvariable="Lvar_LenKid"> 
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
        	Kid as Kid2,
            Acodigo, 
            Acodalterno,    
			Adescripcion,     
			Bdescripcion,     
			Kperiodo,     
			Kmes,
            KtipoES,     
			CCTcodigo,            
            case when Ktipo = 'E' then
							'Entrada'                     
                     when Ktipo = 'S' then
		        			'Salida'     
                     when Ktipo = 'M' then                     
							'Mov. Interalmacén'
                     when Ktipo = 'R' then
							'Requisición'
                     when Ktipo = 'I' then
							'Inv. Físico'
                     when Ktipo = 'A' then
							'Ajuste'
                     when Ktipo = 'P' then
							'Producción'
                     else
                     		'NA'
            end as Ktipo,
			Kdocumento,     
			Kfecha,     
			Entradas,     
			Salidas,     
			SaldoUnidades,     
			CEntradas,
			CSalidas,     
			SaldoCosto, 
			'#Lvar_LenKid#' <cf_dbfunction name="OP_concat"><cf_dbfunction name="to_char" args="Kid">  as Kid,
			 <cf_dbfunction name="to_char" args="Aid"> as Aid,     
			 <cf_dbfunction name="to_char" args="Alm_Aid"> as Alm_Aid,  
			case when round(coalesce(Entradas, 0) - coalesce(Salidas, 0), 6) != 0 then (coalesce(CEntradas, 0.00) - coalesce(CSalidas, 0.00)) / round(coalesce(Entradas, 0) - coalesce(Salidas, 0), 6) else null end  as CostoUnitario,
			Dcodigo,
            Eestante, 
        	Ecasilla,
            Usuario		
		from #kardex#
		order by Bdescripcion, Acodigo, Kid
	</cfquery>
			<cfif arguments.debug EQ 'S'>
				<cf_dump var="#rsReporte#">
				<cf_abort errorInterfaz="">
			<cfelse>
				<cftransaction action="commit"/>
				<cfquery datasource="#session.DSN#">
					delete from #kardex#
				</cfquery>				
			</cfif>															
			<cfreturn rsReporte>
		</cftransaction>
	</cffunction>
</cfcomponent>