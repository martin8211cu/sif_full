<!---<cfset filtro = " mc.MSrevAgente <> 'L' ">--->
<cfset filtro = "1=1">

<cfset camposExtra = "">
<cfoutput>
	<cfif isdefined('url.fechaIni') and url.fechaIni NEQ ''>
		<cfset filtro = filtro & " and S02FEC >= '" & LSDateFormat(url.fechaIni, "yyyymmdd") & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaIni#' as fechaIni_f">
	</cfif>		
	<cfif isdefined('url.fechaFin') and url.fechaFin NEQ ''>
		<cfset filtro = filtro & " and S02FEC <= '" & LSDateFormat(url.fechaFin, "yyyymmdd") & " 23:59:59" & "'">
		<cfset camposExtra = camposExtra & ",'#url.fechaFin#' as fechaFin_f">
	</cfif>	
	<cfif isdefined('url.TipoTarea') and url.TipoTarea NEQ 'T'>
		<cfset filtro = filtro & " and S02ACC = '#url.TipoTarea#'">
		<cfset camposExtra = camposExtra & ",'#url.TipoTarea#' as S02ACC_f">
	</cfif>	
</cfoutput>

		<cf_dbtemp name="tabla_cierre" returnvariable="tabla_cierre" datasource="#session.DSN#">
			<cf_dbtempcol name="S02CON" type="numeric" mandatory="yes">
			<cf_dbtempcol name="S02ACC" type="char(1)" mandatory="yes">
			<cf_dbtempcol name="FecInclusion" type="varchar(50)" mandatory="yes">
			<cf_dbtempcol name="FecCumpli" type="varchar(50)" mandatory="yes">
			<cf_dbtempcol name="Login" type="varchar(50)" mandatory="yes">
			<cf_dbtempcol name="Cuenta" type="numeric" mandatory="yes">			
			<cf_dbtempcol name="PQactual" type="varchar(50)" mandatory="no">
			<cf_dbtempcol name="PQnuevo" type="varchar(50)" mandatory="no">
			<cf_dbtempcol name="Telefono" type="char(10)" mandatory="no">
			<cf_dbtempcol name="Tipo" type="char(1)" mandatory="yes"> 
			<cf_dbtempcol name="Gestion" type="char(10)" mandatory="no">
			<cf_dbtempcol name="Operador" type="varchar(50)" mandatory="no">
			<cf_dbtempcol name="Cumplir" type="varchar(50)" mandatory="no">
		</cf_dbtemp>	
		
		<cfif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'H'> 
			<cfquery name="rsReporteCierre" datasource="SACISIIC">
				select S02CON,S02ACC, S02COF, convert(varchar(50), S02FEC, 100) S02FEC
				, convert(varchar(50), S02FEC, 100) S02FCM
				, convert(varchar(50), S02FEC, 103) S02FECP
				, S02VA1, S02VA2, S02CON
				from SSHS02
				where #PreserveSingleQuotes(filtro)#
				Order by S02ACC ASC, S02FEC ASC
			</cfquery>
		
		
		<cfelseif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'P'>
			<cfquery name="rsReporteCierre" datasource="SACISIIC">
				select S02CON,S02ACC, S02COF, convert(varchar(50), S02FEC, 100) S02FEC
				, convert(varchar(50), S02FEC, 100) S02FCM
				, convert(varchar(50), S02FEC, 103) S02FECP
				, S02VA1, S02VA2, S02CON
				from SSXS02
				where #PreserveSingleQuotes(filtro)#
				Order by S02ACC ASC, S02FEC ASC
			</cfquery>
		</cfif>
	
	<cfif isdefined('url.TipoTarea') and url.TipoTarea EQ 'Q'>
		<cfset Operador = ''>
		<cfset Gestion = ''>
		<cfset Cumplir = ''>
		
		<cfloop query="rsReporteCierre">
			<cfset trama = ListToArray(rsReporteCierre.S02VA1,'*')>
			<cfset Es_acumulado = Left(rsReporteCierre.S02VA2,1) is 'I'>
			<cfif ArrayLen(trama)>
				<cfloop from="1" to="#ArrayLen(trama)#" index="i">
					<cfset trama[i] = Trim(trama[i])>
				</cfloop>
			</cfif>
			<cfset CINDES = getPaquete(getValueAt(trama,3))>
			<cfset login = getValueAt(trama,2)>
			<cfset LGnumero = getLGnum(login)> 
			<cfset paqactual = getPaqueteviejo(LGnumero)>
			
			<cfif Es_acumulado>
				<cfset Operador = ListRest(rsReporteCierre.S02VA2,'*')>
			</cfif>
			<cfif Es_acumulado and (rsReporteCierre.S02COF eq -15000 or rsReporteCierre.S02COF eq -5000 or rsReporteCierre.S02COF eq -10000)>
				<cfset Gestion = 'Interna'>
			<cfelse>
				<cfset Gestion = 'Externa'>
			</cfif>
			<cfif rsReporteCierre.S02COF lt 0>
				<cfset Cumplir = 'Acumulado'>
			<cfelse>
				<cfset Cumplir = 'Inmediato'>
			</cfif>
		
			<cfquery datasource="#session.DSN#" >
			Insert #tabla_cierre# 
			(S02CON
			,S02ACC
			,FecInclusion
			,FecCumpli
			,Login
			,Cuenta
			,PQactual
			,PQnuevo
			,Telefono
			,Tipo
			,Operador
			,Gestion
			,Cumplir)
			Values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteCierre.S02CON#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#rsReporteCierre.S02ACC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteCierre.S02FEC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteCierre.S02FCM#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getValueAt(trama,2)#">
			, <cfqueryparam cfsqltype="cf_sql_integer" value="#getValueAt(trama,1)#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#paqactual#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#CINDES#">
			, 
			 <cfif getValueAt(trama,4) eq '0000000' or getValueAt(trama,4) eq '00000000'>
			 	<cfqueryparam cfsqltype="cf_sql_varchar" value="">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#getValueAt(trama,4)#">
			 </cfif> 
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteCierre.S02ACC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Operador#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Gestion#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Cumplir#">)
			</cfquery>		
		</cfloop> 
			
		<cfquery name="rsRepCierre" datasource="#session.DSN#">
			Select S02CON,FecInclusion,FecCumpli,Login,Cuenta,PQactual,PQnuevo,Telefono,Tipo,Gestion,Operador,Cumplir
			from #tabla_cierre#
		</cfquery>
			
	
		<cfif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'H'>
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
				query="#rsRepCierre#"
				desplegar="FecInclusion,FecCumpli,Login,Cuenta,PQactual,PQnuevo,Telefono,Operador"
				etiquetas="Fecha Inclusión,Fecha Cumplimiento,Login,Cuenta,Paquete Anterior,Paquete Actual,Telefono,Operador"
				formatos="S,S,I,S,S,S,S,S"
				align="left,left,left,left,left,left,left,left"
				showlink="false"
				formName="form2"
				ajustar="N,N,N,N,N,N,N,N"
				MaxRows="15"
				keys="S02CON"
				filtrar_automatico="false"
				mostrar_filtro="false"/>
		<cfelseif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'P'>
		<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
				query="#rsRepCierre#"
				desplegar="FecInclusion,FecCumpli,Login,Cuenta,PQnuevo,Telefono,Cumplir,Gestion,Operador"
				etiquetas="Fecha Inclusión,Fecha Cumplimiento,Login,Cuenta,Paquete Nuevo,Telefono,Tipo,Gestión,Operador"
				formatos="S,S,I,S,S,S,S,S,S"
				align="left,left,left,left,left,left,left,left,left"
				showlink="false"
				formName="form2"
				ajustar="N,N,N,N,N,N,N,N,N"
				MaxRows="15"
				keys="S02CON"
				filtrar_automatico="false"
				mostrar_filtro="false"/>
		</cfif>		
				
				
				
	<cfelseif isdefined('url.TipoTarea') and url.TipoTarea EQ 'B'>
		<cfset Gestion = 'Interna'>
		<cfset fechaCumplir = ''>
		<cfloop query="rsReporteCierre">
			<cfset trama = ListToArray(rsReporteCierre.S02VA1,'*')> 
			<cfif ArrayLen(trama)>
				<cfloop from="1" to="#ArrayLen(trama)#" index="i">
					<cfset trama[i] = Trim(trama[i])>
				</cfloop>
			</cfif>
			<cfif Not Len(getValueAt(trama,3))>
				<cfset fechaCumplir = rsReporteCierre.S02FECP>
			<cfelse>
				<cfset fechaCumplir = #getValueAt(trama,3)#>
			</cfif>
			<cfquery datasource="#session.DSN#">
			Insert #tabla_cierre# 
			(S02CON
			,S02ACC
			,FecInclusion
			,FecCumpli
			,Login
			,Cuenta
			,Tipo
			,Operador
			,Gestion
			,Cumplir)
			Values (
			  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsReporteCierre.S02CON#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#rsReporteCierre.S02ACC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteCierre.S02FEC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReporteCierre.S02FCM#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getValueAt(trama,2)#">
			, <cfqueryparam cfsqltype="cf_sql_integer" value="#getValueAt(trama,1)#">
			, <cfqueryparam cfsqltype="cf_sql_char" value="#rsReporteCierre.S02ACC#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getValueAt(trama,4)#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Gestion#">
			, <cfqueryparam cfsqltype="cf_sql_varchar" value="#fechaCumplir#">)						
			</cfquery>		
		</cfloop> 
		
		<cfquery name="rsRepCierre" datasource="#session.DSN#">
			Select S02CON,FecInclusion,FecCumpli,Login,Cuenta,PQactual,PQnuevo,Telefono,Tipo,Gestion,Operador,Cumplir
			from #tabla_cierre#
		</cfquery>
	
		<cfif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'H'>
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
				query="#rsRepCierre#"
				desplegar="FecInclusion,FecCumpli,Login,Cuenta,Operador"
				etiquetas="Fecha Inclusión,Fecha Cumplimiento,Login,Cuenta,Operador"
				formatos="S,S,S,I,S"
				align="left,left,left,left,left"
				showlink="false"
				formName="form2"
				ajustar="N,N,N,N,N,"
				MaxRows="15"
				keys="S02CON"
				filtrar_automatico="false"
				mostrar_filtro="false"/>
		<cfelseif isdefined('url.EstadoTarea') and url.EstadoTarea eq 'P'>			
			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
				query="#rsRepCierre#"
				desplegar="FecInclusion,Login,Cuenta,Cumplir,Gestion,Operador"
				etiquetas="Fecha Inclusión,Login,Cuenta,Fecha A Cumplir,Gestión,Operador"
				formatos="S,S,S,I,S,S"
				align="left,left,left,left,left,left"
				showlink="false"
				formName="form2"
				ajustar="N,N,N,N,N,N"
				MaxRows="15"
				keys="S02CON"
				filtrar_automatico="false"
				mostrar_filtro="false"/>
		</cfif>
	</cfif>
	<cffunction name="getValueAt" access="private" returntype="any">
		<cfargument name="trama" type="array" required="yes">
		<cfargument name="index" type="numeric" required="yes">
		
		<cfif ArrayLen(Arguments.trama) ge index>
			<cfreturn trama[index]>
		<cfelse>
			<cfreturn "">	
		</cfif>
		
	</cffunction>
	
	
	<cffunction name="getPaqueteviejo" access="private" returntype="string">
		<cfargument name="LGnumero" type="numeric" required="yes">
		
		<cfquery name="paq" datasource="#session.dsn#">
		  if (Select count(1) from ISBbitacoraCambioPaquete) > 1
				Select BCpaqdestino					
					From ISBbitacoraCambioPaquete a
					Where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
					and BCid = (Select max(BCid)-1 from ISBbitacoraCambioPaquete b
                                Where a.LGnumero = b.LGnumero)
			else
				Select BCpaqdestino					
					From ISBbitacoraCambioPaquete
					Where LGnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.LGnumero#">
		</cfquery>
	   
		<cfif isdefined('paq') and Len(paq.BCpaqdestino)>
			<cfreturn getPaquete(paq.BCpaqdestino)>
		<cfelse>
			<cfreturn 'No Suministrado'>
		</cfif>
	</cffunction>
	
	
	<cffunction name="getPaquete" access="private" returntype="string">
		<cfargument name="paquete" type="numeric" required="yes">
		
		<cfquery name="nombre_Paq" datasource="SACISIIC">
				Select CINDES					
					From SACISIIC..SSXCIN
					Where CINCAT = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.paquete#">
				
		</cfquery>		
	 <cfreturn nombre_Paq.CINDES>		
	</cffunction>
		
	<cffunction name="getLGnum" access="private" returntype="string">
		<cfargument name="login" type="string" required="yes">
		
		<cfquery datasource="#session.dsn#" name="buscarLogin" maxrows="1">
			select LGnumero
			from ISBlogin
			where LGlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.login#">
		</cfquery>
		
		<cfif buscarLogin.RecordCount is 0>
			<cfreturn "">
		</cfif>
		<cfreturn buscarLogin.LGnumero>			 		
	</cffunction>