<cfinclude template="reporteCCSS_D.cfm">

<cfset LvarTiempo = arraynew(1)>
<cflog file="ccss"  text="Inicio #LSTimeFormat(now(),'hh:mm ss tt')#">
<cfset ExportaArchivo()>

<cflog file="ccss"  text="Fin #LSTimeFormat(now(),'hh:mm ss tt')#">


<cffunction name="ExportaArchivo" access="private" output="no" returntype="any">
	<cfquery name="rsParametros" datasource="#session.DSN#">
		select Pcodigo,Pvalor from RHParametros  
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and Pcodigo in (300)
	</cfquery>
	<cfset Lvar_NUMPAT = rsParametros.Pvalor>
	<!--- ***************************************************** --->
	<!--- **********  INICIA PROCESO             ************** --->
	<!--- ***************************************************** --->
	<cfset fnGeneraTablasTemporales()>
	<cflog file="ccss"  text="fnGeneraTablasTemporales #LSTimeFormat(now(),'hh:mm ss tt')#">
	<!--- **************************************************************** --->
	<!--- ** debido a que se maneja volumenes altos de informacion      ** --->
	<!--- ** se crearon 2 tablas temporales LineaTiempo,CalendarioPagos ** --->
	<!--- ** en la cuales se va almancenar el contenido de los meses    ** --->
	<!--- ** utilizados por el reporte y asi evitar consultar estas     ** --->
	<!--- ** tablas en su totalidad                                     ** --->
	<!--- **************************************************************** --->
	<!--- <cfset fnInsertaTablasTemporales (feciniTA, fecfin, Lvar_periodoT, Lvar_mesT, form.CPperiodo, form.CPmes)>
	<cfset LvarTiempo[3] = gettickcount()>--->
	<!--- ***************************************************** --->
	<!--- ** LO PRIMERO QUE SE DEBE HACER ES INSERTAR UN     ** --->
	<!--- ** 25 (ENCABEZADO) POR CADA NUMERO PATRONAL        ** --->
	<!--- ** POR LO GENERAL ES UN REGISTRO PERO PUEDEN       ** --->
	<!--- ** EXISTIR EXCEPCIONES POR OFICINA                 ** --->

	<!--- ***************************************************** --->
	<!--- ***********  PASO 2 INSERTA ENCABEZADO    *********** --->
	 <cfset HILERA = "25"
		&  RepeatString('0', (18 -len(trim(Lvar_NUMPAT)))) & Lvar_NUMPAT
		&  RepeatString('0', (4 -len(trim(Lvar_adscrita)))) & Lvar_adscrita
		&  RepeatString('0', (4 -len(trim(form.CPperiodo)))) & form.CPperiodo
		&  RepeatString('0', (2 -len(trim(form.CPmes)))) & form.CPmes>
	
	
	<cfquery datasource="#Session.DSN#">
		insert into  #ReporteCCSS#(RCCtexto, RCCTipo, Ecodigo)
		values( '#HILERA#', 25, #session.Ecodigo# )
	</cfquery>
	
	<cfset fnProcesaOficinaSinNumPat()>
	<cfset fnProcesaArchivo()>
	
	<cfquery name="err" datasource="#Session.DSN#">
		select RCCtexto 
			from #ReporteCCSS# where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			order by RCCid
	</cfquery>
	<cfquery name="rh_delete" datasource="#Session.DSN#">
		delete  #ReporteCCSS#
	</cfquery>
</cffunction>
<cffunction name="fnGeneraTablasTemporales" output="no" access="private" hint="Genera Tablas Temporales para el proceso">	
	<cf_dbtemp name="ReporteCCSSv2" returnvariable="ReporteCCSS" datasource="#session.DSN#">
		<cf_dbtempcol name="RCCid" type="numeric" mandatory="yes" identity="yes">
		<cf_dbtempcol name="Ecodigo" type="Integer" mandatory="yes">
		<cf_dbtempcol name="RCCTipo" type="Integer" mandatory="yes">
		<cf_dbtempcol name="RCCtexto" type="varchar(176)" mandatory="yes">
		<cf_dbtempcol name="Empleado" type="varchar(30)" mandatory="no">
		<cf_dbtempcol name="TipoReg" type="varchar(3)" mandatory="no">
		<cf_dbtempcol name="Monto" type="money" mandatory="no">
	</cf_dbtemp>
	
	<cf_dbtemp name="Tempv4" returnvariable="Temp" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid"    		type="numeric" mandatory="no">
		<cf_dbtempcol name="FECHDE"  		type="datetime" mandatory="no">
		<cf_dbtempcol name="FECHAS"   		type="datetime" mandatory="no">
		<cf_dbtempcol name="Ecodigo" 		type="Integer" mandatory="no">
		<cf_dbtempcol name="Ocodigo" 		type="numeric" mandatory="no">
		<cf_dbtempcol name="RHPcodigo" 		type="varchar(10)" mandatory="no">
		<cf_dbtempcol name="Salario" 		type="money" mandatory="no">
		<cf_dbtempcol name="Incidencias" 	type="money" mandatory="no">
		<cf_dbtempcol name="MONTO" 			type="money" mandatory="no">
		<cf_dbtempcol name="Salarioa" 		type="money" mandatory="no">
		<cf_dbtempcol name="Incidenciasa" 	type="money" mandatory="no">
		<cf_dbtempcol name="MONTOa" 		type="money" mandatory="no">
		<cf_dbtempcol name="Fechamax"  		type="datetime" mandatory="no">
		<cf_dbtempcol name="Fechamin"   	type="datetime" mandatory="no">
		<cf_dbtempcol name="Numpatronal" 	type="varchar(25)" mandatory="no">
		<cf_dbtempcol name="CPmes" type="Integer" mandatory="no">
		<cf_dbtempcol name="CPperiodo" type="Integer" mandatory="no">
		<cf_dbtempindex cols="DEid">
		<cf_dbtempindex cols="DEid,FECHDE,FECHAS">
	</cf_dbtemp>
	
	<cf_dbtemp name="registro3532" returnvariable="registro35" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid"    		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="RHRCCSSid"    	type="numeric" 		mandatory="no">
		<cf_dbtempcol name="FECINI"  		type="datetime" 	mandatory="no">	<!---  Fecha de Inicio del Mov--->
		<cf_dbtempcol name="TIPIDE" 		type="char(1)" 		mandatory="no">	<!---  Tipo de Identificacion--->
		<cf_dbtempcol name="IDENTI" 		type="char(25)" 	mandatory="no"> <!---  Codigo de Identificacion--->
		<cf_dbtempcol name="APE1" 			type="char(20)" 	mandatory="no"> <!---  Primer Apellido--->
		<cf_dbtempcol name="APE2" 			type="char(20)" 	mandatory="no"> <!---  Segundo Apellido--->
		<cf_dbtempcol name="NOMBRE" 		type="char(60)" 	mandatory="no"> <!---  Nombre--->
		<cf_dbtempcol name="MONTO" 			type="money"		mandatory="no">	<!---  Monto del Salario del Mes--->
		<cf_dbtempcol name="CLASEG" 		type="char(1)" 		mandatory="no">	<!---  Clase de Seguro--->
		<cf_dbtempcol name="TIPCAM" 		type="char(2)" 		mandatory="no">	<!---  Tipo de Cambio--->
		<cf_dbtempcol name="NUMJOR" 		type="Integer" 		mandatory="no">	<!---  Horas por Jornada--->
		<cf_dbtempcol name="CLAJOR" 		type="char(3)" 		mandatory="no">	<!---  Tipo de Jornada--->
		<cf_dbtempcol name="FECFIN"  		type="datetime" 	mandatory="no">	<!---  Fecha Fin del Cambio--->
		<cf_dbtempcol name="FECFINL"  		type="char(8)" 	    mandatory="no">	<!---  Fecha Fin del Cambio--->
		<cf_dbtempcol name="RHJid"    		type="numeric" 		mandatory="no">	<!---  Codigo de Jornada--->
		<cf_dbtempcol name="RHOcodigo" 		type="char(10)" 	mandatory="no">	<!---  Clase de Puesto--->
		<cf_dbtempcol name="TINCAPACI" 		type="char(3)" 		mandatory="no">	<!---  Tipo de Incapacidad--->
		<cf_dbtempcol name="MONTO1"			type="char(15)"		mandatory="no">	<!---  Monto Ya Fotmateado--->
		<cf_dbtempcol name="NUMJOR1"		type="char(2)"		mandatory="no">	<!---  Horas por Jornada--->
		<cf_dbtempcol name="Ppais"			type="char(2)"		mandatory="no">	<!---  Pais de Procedencia--->
		<cf_dbtempcol name="CONSE"    		type="numeric(4,2)"	mandatory="no"> <!---  Ordenamiento (1 - Ingresos, 2 - Ingreso por Cambio Patronal,--->
																				<!---  3 - Cambio Jornada, 4 - Cambio Puesto--->
																				<!---  5 - Cambio Salario, 6 - Incapacidades--->
																				<!---  7 - Permisos, 8 - Pensiones--->	
																				<!---  9 - Exclusiones por Cambio Patronal, 10 - Ceses )--->
		<cf_dbtempindex cols="DEid">
	</cf_dbtemp>
</cffunction>
<cffunction name="fnInsertaTablasTemporales" access="private" output="no" hint="Inserta la InformaciÃ³n en las tablas temporales">
	<cfargument name="feciniTa" type="date" required="yes">
	<cfargument name="fecfin" type="date" required="yes">
	<cfargument name="Lvar_periodoT" type="numeric" required="yes">
	<cfargument name="Lvar_mesT" type="numeric" required="yes">
	<cfargument name="Lvar_periodoT2" type="numeric" required="yes">
	<cfargument name="Lvar_mesT2" type="numeric" required="yes">

	<cfquery datasource="#Session.DSN#">
		insert into  #LineaTiempo# (LTid,DEid,Ecodigo,Ocodigo,Tcodigo,RHTid,RHPcodigo,RHJid,LTdesde,LThasta)
		select LTid,DEid,Ecodigo,Ocodigo,Tcodigo,RHTid,RHPcodigo,RHJid,LTdesde,LThasta
		from LineaTiempo lt
		where Ecodigo = #session.Ecodigo#
		  and (
		  	( lt.LTdesde <= #Arguments.feciniTA# and lt.LThasta >= #Arguments.fecfin#) 
			or 
			( lt.LThasta >= #Arguments.feciniTA# and lt.LTdesde <= #Arguments.fecfin#)
			)		  
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		insert into  #CalendarioPagos# (CPid,Ecodigo,CPcodigo,Tcodigo,CPdesde,CPhasta,CPperiodo,CPmes,CPtipo,CPnocargasley,CPnocargas)
		select CPid,Ecodigo,CPcodigo,Tcodigo,CPdesde,CPhasta,CPperiodo,CPmes,CPtipo,CPnocargasley,CPnocargas
		from CalendarioPagos
		where Ecodigo = #session.Ecodigo#
		<cfif Arguments.Lvar_periodoT EQ Arguments.Lvar_periodoT2>
		  and CPperiodo = #Arguments.Lvar_periodoT#
		  and CPmes     >= #Arguments.Lvar_mesT# 
		  and CPmes     <= #Arguments.Lvar_mesT2#
		<cfelse>
		  and CPperiodo >= #Arguments.Lvar_periodoT#
		  and CPperiodo <= #Arguments.Lvar_periodoT2#
		  and (CPperiodo*100)+CPmes  >=  (#Arguments.Lvar_periodoT# *100) + #Arguments.Lvar_mesT#  
		  and (CPperiodo*100)+CPmes  <=  (#Arguments.Lvar_periodoT2#*100) + #Arguments.Lvar_mesT2#
		</cfif>
		order by CPperiodo,CPmes
	</cfquery>
</cffunction>
<cffunction name="fnProcesaOficinaSinNumPat" access="private" output="no" hint="Procesa los datos para las oficinas que no tienen numero patronal independiente">
	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select Ocodigo 
		from Oficinas
		where Onumpatronal is null
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset ListaOficinas = "">
	<cfloop query="rsOficinas">
		<cfif len(ListaOficinas) GT 0>
			<cfset ListaOficinas = ListaOficinas & ", ">
		</cfif>
		<cfset ListaOficinas = ListaOficinas & rsOficinas.Ocodigo>
	</cfloop>
	<cfset fnDetalleCCSS1(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS1 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS2(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS2 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS3(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS4(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS5(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS6(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS7(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
	<cfset fnDetalleCCSS8a(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">

	<cfset fnDetalleCCSS8b(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">

	<cfset fnDetalleCCSS9a(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">

	<cfset fnDetalleCCSS9b(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
	<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">

	<cfset fnDetalleCCSS10()>
	<cflog file="ccss"  text="fnDetalleCCSS10 #LSTimeFormat(now(),'hh:mm ss tt')#">
	
</cffunction>
<cffunction name="fnProcesaArchivo" access="private" output="no" hint="Procesa el Archivo Plano">
	<!--- ***********  PASO 3 INSERTA ENCABEZADO   *********** --->
	<!--- ***********  PARA LAS OFICINAS CON EXCEPCION    **** --->
	<cfquery name="rh_query" datasource="#Session.DSN#">
			select distinct Onumpatronal,Oadscrita,Onumpatinactivo 
			from Oficinas 
			where Ecodigo = #session.Ecodigo#
			  and coalesce(Onumpatronal,'0') != '0' 
			<cfif isdefined("form.GrupoPlanilla") and len(trim(form.GrupoPlanilla))>
				and substring(Oficodigo, 1,#len(trim(form.GrupoPlanilla))#) = '#trim(form.GrupoPlanilla)#'
			</cfif> 
			order by Onumpatronal,Oadscrita 
	</cfquery>
	<cfif rh_query.recordCount GT 0>
		
		<cfset  Lvar_adscritaDEF = Lvar_adscrita>	<!--- Sucursal Adscrita CCSS DEFAULT --->
		<cfset  Lvar_PatEmp = 1> 
		<cfloop query="rh_query">
			
			<cfquery name="rsOficinas" datasource="#session.dsn#">
				select Ocodigo 
				from Oficinas
				where Ecodigo = #session.Ecodigo#
				  and Onumpatronal = '#rh_query.Onumpatronal#'
			</cfquery>
			<cfset ListaOficinas = "">

			<cfloop query="rsOficinas">
				<cfif len(ListaOficinas) GT 0>
					<cfset ListaOficinas = ListaOficinas & ", ">
				</cfif>
				<cfset ListaOficinas = ListaOficinas & rsOficinas.Ocodigo>
			</cfloop>

			<cfset  Lvar_NUMPAT = rh_query.Onumpatronal>
			<cfif  len(trim(rh_query.Oadscrita))>
				<cfset  Lvar_adscrita = rh_query.Oadscrita>
			<cfelse>
				<cfset  Lvar_adscrita = Lvar_adscritaDEF>			
			</cfif> 
			<cfset HILERA = "25" 
				&  RepeatString('0', (18 -len(trim(Lvar_NUMPAT)))) & trim(Lvar_NUMPAT) 
				&  RepeatString('0', (4 -len(trim(Lvar_adscrita)))) & trim(Lvar_adscrita)
				&  RepeatString('0', (4 -len(trim(form.CPperiodo)))) & form.CPperiodo
				&  RepeatString('0', (2 -len(trim(form.CPmes)))) & form.CPmes>

			
			
			<cfif rh_query.Onumpatinactivo eq 1>
				 <cfset HILERA = HILERA & 'S' >
			</cfif>
			<cfquery name="rh_ReporteCCSS_GC" datasource="#Session.DSN#">
				insert into  #ReporteCCSS#(RCCtexto, RCCTipo, Ecodigo)
				values( '#HILERA#', 25, #session.Ecodigo# )
			</cfquery>	
			<cfif rh_query.Onumpatinactivo eq 0>	
					<cfset fnDetalleCCSS1(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS1 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS2(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS2 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS3(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS4(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS5(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS6(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS7(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS8a(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS8b(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS9a(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS9b(ListaOficinas,Lvar_NUMPAT,fecini,fecfin)>
					<cflog file="ccss"  text="fnDetalleCCSS3 #LSTimeFormat(now(),'hh:mm ss tt')#">
					
					<cfset fnDetalleCCSS10()>
					<cflog file="ccss"  text="fnDetalleCCSS10 #LSTimeFormat(now(),'hh:mm ss tt')#">
			</cfif>
		</cfloop>
	</cfif>
	<!--- ***************************************************************** --->
	<!--- ************         insert into a registro 15           ************** --->
	<!--- ***************************************************************** --->
	<cfset HILERA = "15PAT"  &  LSDateFormat(Now(), "yyyymmdd")>
	<cfquery name="rs_25" datasource="#Session.DSN#">
		select count(1) 
		as cantidad 
		from #ReporteCCSS# 
		where RCCTipo = 25 
		and Ecodigo = #session.Ecodigo#
	</cfquery> 
	<cfquery name="rs_35" datasource="#Session.DSN#">
		select count(1) as cantidad 
		from #ReporteCCSS# 
		where RCCTipo = 35 
		and Ecodigo = #session.Ecodigo#
		and upper(TipoReg) in ('IC','SA')
	</cfquery>
	<cfset HILERA = HILERA &  RepeatString('0', (10 -len(trim(rs_25.cantidad)))) & trim(rs_25.cantidad) &  RepeatString('0', (10 -len(trim(rs_35.cantidad)))) & trim(rs_35.cantidad)>
	<cfquery datasource="#Session.DSN#">
		insert into  #ReporteCCSS#(RCCtexto, RCCTipo, Ecodigo)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#HILERA#">,
			15,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
		)
	</cfquery>
</cffunction>


