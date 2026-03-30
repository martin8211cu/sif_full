<cfsetting enablecfoutputonly="yes">
<cfcontent type="text/xml">

	<cfif isdefined ('url.CPPid') and not isdefined('form.CPPid')>
		<cfset form.CPPid = url.CPPid>
	</cfif>
	
	<cfif isdefined ('form.secuencia') and len(trim(form.secuencia))>
		<cfset LvarSecuencia = #form.secuencia#>
	<cfelse>
		<cfset LvarSecuencia = ''>
	</cfif>

	<cfset Fecha  = DateFormat(now(),'YYYYMMDD')>
	<cfset Hora  = TimeFormat(now(),'HHmmss') >
	<cfset Lvarbuffer = CreateObject("java", "java.lang.StringBuffer").init( JavaCast("int", 32768 ))>
	<cfset LvarFechaIni = createdate(year(now()), month(now()), day(now()))>
	
	<cflock name="QPconsecutivo#Session.Ecodigo#" timeout="3" type="exclusive">
		<cfquery name="newLista" datasource="#session.dsn#">
			select coalesce(max(Consecutivo),0) as Consecutivo
			from FPConfNivelCConsecutivo  
			where Ecodigo = #session.Ecodigo#
			  and BMfecha between #LvarFechaIni# and #now()#
		</cfquery>
		
		<cfif newLista.Consecutivo neq ''>
			<cfset Cons = newLista.Consecutivo + 1>
		<cfelse>
			<cfset Cons = 1>
		</cfif>
	
	
	<cfif isdefined('form.dato') and len(trim(form.dato)) gt 0> 
		<cfloop delimiters="," list="#form.dato#" index="i">
			<cfquery name="insertConsecutivo" datasource="#session.dsn#">
				insert into FPConfNivelCConsecutivo  
				(
					Consecutivo, 
					<cfif isdefined('LvarSecuencia') and len(trim(#LvarSecuencia#)) gt 0>
					secuencia,
					</cfif>
					FPTVTipo,
					Ecodigo, 
					BMfecha, 
					BMUsucodigo
				)
				values
				(
					#Cons#,
					<cfif isdefined('LvarSecuencia') and len(trim(#LvarSecuencia#)) gt 0>
					#LvarSecuencia#,
					</cfif>
					#i#,
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					#session.Usucodigo#
				)
			</cfquery>
		</cfloop>
	<cfelse>
			<cfquery name="insertConsecutivo" datasource="#session.dsn#">
				insert into FPConfNivelCConsecutivo  
				(
					Consecutivo, 
					<cfif isdefined('LvarSecuencia') and len(trim(#LvarSecuencia#)) gt 0>
					secuencia,
					</cfif>
					Ecodigo, 
					BMfecha, 
					BMUsucodigo
				)
				values
				(
					#Cons#,
					<cfif isdefined('LvarSecuencia') and len(trim(#LvarSecuencia#)) gt 0>
					#LvarSecuencia#,
					</cfif>
					#session.Ecodigo#,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					#session.Usucodigo#
				)
			</cfquery>
		</cfif>
	</cflock>
	
    <cfset Entidad = #session.Ecodigo#>
	 <cfset LvarArchivo = "#Entidad#_#form.FPTVTipo##Fecha##Hora##Cons#">
	 <cfset LvarSlash = CreateObject("java","java.lang.System").getProperty("file.separator")>
	 <cfset LvarDirCur=GetDirectoryFromPath(GetCurrentTemplatePath())>
	 <cfset LvarYYYYMMDD=DateFormat(now(),"YYYYMMDD") & LvarSlash>
	 <cfset LvarDirHoy=LvarDirCur & LvarYYYYMMDD>
	 <cfset LvarExtension = "xml">
	 <cfset zipfile = "#LvarDirHoy#/#LvarArchivo#.#LvarExtension#" >
	
	<cfif NOT DirectoryExists(LvarDirHoy)>
		<cfdirectory action="create" directory="#LvarDirHoy#">
	</cfif>

	<cfquery name="Periodos" datasource="#session.dsn#">
		select a.CPPanoMesDesde /100 periodo, a.Mcodigo
		from CPresupuestoPeriodo a
		where a.Ecodigo = #Session.Ecodigo#
		and a.CPPid = #form.CPPid#
	</cfquery>
	<cfset LvarPeriodo = #Periodos.periodo#>
				
	<cfobject component="sif.Componentes.AplicarMascara" name="Obj_CFormato">

	<cf_dbtemp name="temp_nivelesCuenta_v1" returnvariable="temp" datasource="#session.dsn#">
		<cf_dbtempcol name="CFformato"   			type="varchar(255)"	 mandatory="yes">
		<cf_dbtempcol name="PCEMid"   				type="numeric"  		 mandatory="yes">
		<cf_dbtempcol name="PCTipo"   				type="varchar(2)"  	 mandatory="yes">
		<cf_dbtempcol name="Ctipo"   					type="char(1)"  		 mandatory="yes">
		<cf_dbtempcol name="Monto" 					type="money"  			 mandatory="yes">
		<cf_dbtempcol name="CFformatoCal"   		type="varchar(255)"	 mandatory="no">
		<cf_dbtempcol name="TIE"   					type="char(1)"	 		 mandatory="no"><!--- Tipo INGRESO O EGRESO--->
		<cf_dbtempcol name="Programa"   				type="varchar(255)"	 mandatory="no"><!--- Programa--->
		<cf_dbtempcol name="PCEcodigo"   			type="varchar(255)"	 mandatory="yes"><!--- Programa--->
		<cf_dbtempcol name="PCNid"   					type="numeric"  		 mandatory="yes">
		<cf_dbtempcol name="PCLinea"   				type="numeric"  		 mandatory="yes">
		<cf_dbtempcol name="PCEdescripcion"   		type="varchar(255)"   mandatory="yes">
	</cf_dbtemp>
	
	<cfquery name="rsSeparador" datasource="#session.dsn#">
		select Pvalor as separador
		from Parametros
		where Ecodigo = #Session.Ecodigo#  
		and Pcodigo = 3000
	</cfquery>
	
	<cfset LvarSeparador = #rsSeparador.separador#>
	<!---Son los mismos valores que trae datos    --->
 	<!--- form.dato = -1 Presupuesto Ordinario    --->
	<!--- form.dato = 0 Presupuesto Extraordinario--->
	<!--- form.dato = 1 No modifica monto         --->
	<!--- form.dato = 2 Modifica monto hacia abajo--->
	<!---form.dato = 3 Modifica monto hacia Arriba--->
	
	<cfif isdefined('form.FPTVTipo') and #form.FPTVTipo# eq 05> <!---Informes de Ejecución--->
		<cfquery name="rsNiveles" datasource="#session.DSN#">
			insert into #temp# (PCEdescripcion,PCLinea,PCEcodigo,PCNid,CFformato, PCEMid,Ctipo,PCTipo,Monto)
			select  Ca.PCEdescripcion,CN.PCLinea,Ca.PCEcodigo,CN.PCNid,CC.CFformato, V.PCEMid, CM.Ctipo,CN.PCTipo,
					(EE.CPCejecutado+EE.CPCejecutadoNC)
				from CPresupuestoControl EE
				inner join  PCGcuentas CC
					on CC.CPcuenta = EE.CPcuenta
				inner join CPVigencia V
					on V.Ecodigo = EE.Ecodigo
					and V.Cmayor = <cf_dbfunction name="sPart" args="rtrim(CC.CFformato),1,4">
					and #dateformat(now(),"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
				inner join CtasMayor CM
					on CM.Ecodigo = V.Ecodigo
					and CM.Cmayor = V.Cmayor
				inner join FPConfNivelCuenta CN
					on CN.PCEMid = V.PCEMid 
					and CN.PCFActivo = 1 
				inner join PCNivelMascara NM 
					on NM.PCEMid = V.PCEMid 
					and NM.PCNid = CN.PCNid 
				inner join PCECatalogo Ca
					on Ca.PCEcatid = NM.PCEcatid				
				where EE.CPPid = #form.CPPid#
				and CN.Ecodigo = #session.Ecodigo#
				and NM.PCNpresupuesto = 1
				group by Ca.PCEdescripcion,CN.PCLinea,Ca.PCEcodigo,CN.PCNid,CC.CFformato, V.PCEMid,CM.Ctipo,CN.PCTipo,NM.PCNdescripcion,
						(EE.CPCejecutado+EE.CPCejecutadoNC)
		</cfquery>
	<cfelse>
		<cfquery name="rsNiveles" datasource="#session.DSN#">
			insert into #temp# (PCEdescripcion,PCLinea,PCEcodigo,PCNid,CFformato, PCEMid,Ctipo,PCTipo,Monto)
			select Ca.PCEdescripcion,CN.PCLinea,Ca.PCEcodigo,CN.PCNid,CC.CFformato, V.PCEMid, CM.Ctipo,CN.PCTipo,DE.DPDMontoTotalPeriodo
				from FPEEstimacion EE
				inner join TipoVariacionPres TV
					on TV.FPTVid = EE.FPTVid
					and TV.FPTVTipo in (#form.dato#)
				inner join FPDEstimacion DE
					on DE.FPEEid = EE.FPEEid
				inner join FPEPlantilla P
					on P.FPEPid = DE.FPEPid
				inner join PCGcuentas CC
					on CC.PCGcuenta = DE.PCGcuenta
				inner join CPVigencia V
					on V.Ecodigo = EE.Ecodigo
					and V.Cmayor = <cf_dbfunction name="sPart" args="rtrim(CC.CFformato),1,4">
					and #dateformat(now(),"YYYYMM")# between CPVdesdeAnoMes and CPVhastaAnoMes
				inner join CtasMayor CM
					on CM.Ecodigo = V.Ecodigo
					and CM.Cmayor = V.Cmayor
				inner join FPConfNivelCuenta CN
					on CN.PCEMid = V.PCEMid 
					and CN.PCFActivo = 1 
				inner join PCNivelMascara NM 
					on NM.PCEMid = V.PCEMid 
					and NM.PCNid = CN.PCNid 
				inner join PCECatalogo Ca
					on Ca.PCEcatid = NM.PCEcatid				
				where EE.CPPid = #form.CPPid#
				and CN.Ecodigo = #session.Ecodigo#
				and NM.PCNpresupuesto = 1
				and EE.FPEEestado = 4 <!---En Aprobación Externa--->
			group by Ca.PCEdescripcion,CN.PCLinea,Ca.PCEcodigo,CN.PCNid,CC.CFformato, V.PCEMid,CM.Ctipo,CN.PCTipo,NM.PCNdescripcion,DE.DPDMontoTotalPeriodo
		</cfquery>
	 </cfif>

	<!---Saco los valores de la temporal--->
	<cfquery name="preInsert" datasource="#session.DSN#">
		select CFformato,PCEMid,PCTipo,Ctipo,Monto,TIE, Programa,PCEcodigo,PCNid,PCLinea,PCEdescripcion from #temp# 
	</cfquery>	

	<cfloop query="preInsert">
		<cfquery name="listado" datasource="#session.DSN#">
			select PCEMnivelesP from PCEMascaras where PCEMid = #preInsert.PCEMid#
		</cfquery>
		<cfset listNiveles = ListToArray(listado.PCEMnivelesP)>
		
		<cfquery name="niveles" datasource="#session.DSN#">
			select a.PCLinea,a.PCNid, b.PCNdescripcion from FPConfNivelCuenta a inner join PCNivelMascara b on b.PCEMid = a.PCEMid and b.PCNid = a.PCNid 
			where a.PCEMid = #preInsert.PCEMid# and PCFActivo = 1 order by PCLinea
		</cfquery>
		<cfset CFformatoCal = listNiveles[1]>
		<cfloop query="niveles">
			<cfset CFformatoCal &= ','&listNiveles[niveles.PCLinea+1]>
		</cfloop>
	
		<cfinvoke component="sif.Componentes.AplicarMascara" method="ExtraerNivelesP" returnvariable="LvarCuentas">
			<cfinvokeargument name="CFformato" 	value="#preInsert.CFformato#">
			<cfinvokeargument name="nivelesP"   value="#CFformatoCal#">
		</cfinvoke>
		
	<!---Obtiene el programa para Egresos--->
		<cfquery name="rsPrograma" datasource="#session.dsn#">
			select PCEMid,PCNid,PCTipo from FPConfNivelCuenta where PCEMid = #preInsert.PCEMid# 
			and PCLinea = (select min(PCLinea) from FPConfNivelCuenta where PCEMid = #preInsert.PCEMid# and PCTipo in ('E') and PCFActivo = 1)
			and PCTipo in ('E')
			and PCFActivo = 1
			and Ecodigo = #session.Ecodigo#
			
			union all
			
			select PCEMid,PCNid,PCTipo from FPConfNivelCuenta where PCEMid = #preInsert.PCEMid# 
			and PCLinea = (select min(PCLinea) from FPConfNivelCuenta where PCEMid = #preInsert.PCEMid# and PCTipo in ('ET') and PCFActivo = 1)
			and PCTipo in ('ET')
			and PCFActivo = 1
			and Ecodigo = #session.Ecodigo#
		</cfquery>
	
		<cfif preInsert.PCTipo eq 'E'>
			<cfset prog = ListGetAt(preInsert.CFformato,rsPrograma.PCNid+1,'-')>
		<cfelseif preInsert.PCTipo eq 'ET'>
			<cfset prog = ListGetAt(preInsert.CFformato,rsPrograma.PCNid+1,'-')>
		<cfelse>
			<cfset prog = ''>
		</cfif>
		
		<cfif preInsert.Ctipo eq 'C' and preInsert.PCEcodigo eq 'PI'>
			<cfset tipo = ListGetAt(preInsert.CFformato,preInsert.PCNid+1,'-')>
		<cfelseif preInsert.Ctipo eq 'P' and preInsert.PCEcodigo eq 'PI'>
			<cfset tipo = ListGetAt(preInsert.CFformato,preInsert.PCNid+1,'-')>
		<cfelse>
			<cfset tipo = ''>
		</cfif>
		
		<cfquery datasource="#session.DSN#">
			update #temp# 
				set CFformatoCal ='#replace(LvarCuentas,'-','#LvarSeparador#','ALL')#',
				TIE = 
				<cfif preInsert.Ctipo eq 'P' and tipo eq '0'>
					'E',
				<cfelseif preInsert.Ctipo eq 'C' and tipo eq '0'>
					'ET'
				<cfelseif  preInsert.Ctipo eq 'P' and tipo neq '0'>
					'I',
				<cfelseif  preInsert.Ctipo eq 'C' and tipo neq '0'>	
					'IT',
				<cfelse>
					''
				</cfif>
				Programa = '#prog#'
			where CFformato = '#preInsert.CFformato#'
			and PCEMid = #preInsert.PCEMid#
		</cfquery>
	</cfloop>
	
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select CFformato,PCEMid,PCTipo,Ctipo,Monto,TIE, Programa,PCEcodigo,PCNid,PCEdescripcion,CFformatoCal from #temp# 
	</cfquery>
	
	<cfquery name="rsInstitucion" datasource="#session.dsn#">
		select
			 Pvalor as value
		from Parametros
		where Ecodigo = #session.ecodigo# 
		and Pcodigo = 3001
	</cfquery>
	
	<cfif #rsInstitucion.recordcount# eq 0>
		<cfset LvarInstitucion = ''>
	<cfelse>
		<cfset LvarInstitucion = #rsInstitucion.value#>
	</cfif>

	<cfquery dbtype="query" name="rsSumaT">
		select sum(Monto) as total	from rsDatos
	</cfquery>
		<cfset LvarMontoTotal = #rsSumaT.total#>
		
	<cfquery dbtype="query" name="rsSumaI"> 
		select sum(Monto) as totalIngresos from rsDatos where  TIE = 'I'    <!--- Ctipo = P = cuando valor 9 <> 0 --->
	</cfquery>
		<cfset LvarMontoIngreso = #rsSumaI.totalIngresos#>
	
	<cfquery dbtype="query" name="rsSumaE">
		select sum(Monto) as totalEgresos from rsDatos where  TIE = 'E'  <!---Ctipo = P = cuando valor 9 = 0 ---> 
	</cfquery>
		<cfset LvarMontoEgreso = #rsSumaE.totalEgresos#>
		
	<cfquery dbtype="query" name="rsSumaET">
		select sum(Monto) as totalEgresosTransferencia from rsDatos where TIE = 'ET' <!---Ctipo = C = patrimonio cuando valor 7 = 0 --->
	</cfquery>
		<cfset LvarMontoEgresoTransferencia = #rsSumaET.totalEgresosTransferencia#>
		
	<cfquery dbtype="query" name="rsSumaIT">
		select sum(Monto) as totalIngresoTransferencia from rsDatos where  TIE = 'IT' <!---Ctipo = C = patrimonio cuando valor <> 0 --->
	</cfquery>
		<cfset LvarMontoIngresoTransferencia = #rsSumaIT.totalIngresoTransferencia#>
		
<cfheader name="Content-Disposition" value="attachment;filename=SIPP.xml">
<cfoutput><?xml version="1.0" encoding="utf-8"?>
<doc_presup>
   <datos_control>
      <monto_archivo>#LvarMontoTotal#</monto_archivo>
      <monto_ingresos>#LvarMontoIngreso#</monto_ingresos>
      <monto_egresos>#LvarMontoEgreso#</monto_egresos>
      <monto_ing_transf>#LvarMontoIngresoTransferencia#</monto_ing_transf >
      <monto_egr_transf>#LvarMontoEgresoTransferencia#</monto_egr_transf >
       <doc_apr>N</doc_apr>
   </datos_control>
   <documentos>
      <documento>
         <tipo_doc>#form.FPTVTipo#</tipo_doc>
         <secuencia>#LvarSecuencia#</secuencia> 
         <institucion>#LvarInstitucion#</institucion><!---validar si no se ha definido la institucion, que esta en configuracion de datos de archivo--->
         <ano>#LvarPeriodo#</ano>
         <saldos_cuentas>
				
            <ingresos>
               <detalles>
						<detalle>
						<cfquery dbtype="query" name="rsIngresos">
							select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'I' group by CFformatoCal
						</cfquery>
						<cfloop query="rsIngresos">
							<cuenta>#rsIngresos.CFformatoCal#</cuenta>
							<monto>#rsIngresos.Monto#</monto>
						</cfloop> 
					  </detalle>
               </detalles> 
				
               <transferencias>
                  <transferencia>
						<cfquery dbtype="query" name="rsIngresosTransferencia">
							select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'IT' group by CFformatoCal
						</cfquery>
						<cfloop query="rsIngresosTransferencia">
                     <cuenta>#rsIngresosTransferencia.CFformatoCal#</cuenta>
                     <valor>#rsIngresosTransferencia.Monto#</valor>
                     <institucion>#LvarInstitucion#</institucion>
						</cfloop>
                  </transferencia>
               </transferencias>
            </ingresos>
				
            <egresos>
			   	<cfquery name="VPrograma"  datasource="#session.dsn#">
						select a.PCNid, a.PCEMid,a.CFformato, a.Programa, d.PCDdescripcion from #temp# a inner join PCNivelMascara b
							on b.PCEMid = a.PCEMid 
							and b.PCNid = a.PCNid 
							inner join PCECatalogo c
								on c.PCEcatid = b.PCEcatid
							inner join PCDCatalogo d
								on d.PCEcatid = c.PCEcatid
								and c.PCEcatid = d.PCEcatid
								and d.PCDvalor = a.Programa
								and d.Ecodigo = #session.Ecodigo#
								and a.TIE in ('E','ET')
							group by a.PCNid, a.PCEMid,a.CFformato,a.Programa,d.PCDdescripcion
							order by a.PCNid, a.PCEMid
					</cfquery>
			
					<cfloop query="VPrograma">
               <programa>
							<codigo>#VPrograma.Programa#</codigo>
							<nombre>#VPrograma.PCDdescripcion#</nombre>
                  <cuentas>
                     <detalle>
							<cfquery dbtype="query" name="rsEgresos">
								select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'E' group by CFformatoCal
							</cfquery>
                     <cfloop query="rsEgresos">
								<cuenta>#rsEgresos.CFformatoCal#</cuenta>
								<monto>#rsEgresos.Monto#</monto>
							</cfloop> 
                     </detalle>
                  </cuentas>
						
                     <transferencias>
                        <transferencia>
									<cfquery dbtype="query" name="rsEgresosTransferencia">
										select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'ET' group by CFformatoCal
									</cfquery>
									<cfloop query="rsEgresosTransferencia">
										<cuenta>#rsEgresosTransferencia.CFformatoCal#</cuenta>
										<valor>#rsEgresosTransferencia.Monto#</valor>
										<institucion>#LvarInstitucion#</institucion>
									</cfloop>
                        </transferencia>
                     </transferencias>
               </programa>
				 </cfloop>
            </egresos>
         </saldos_cuentas>
      </documento>
   </documentos>
</doc_presup>
</cfoutput>

<cfsavecontent variable="doc_file">
<cfoutput><?xml version="1.0" encoding="iso-8859-1"?>
<doc_presup>
   <datos_control>
      <monto_archivo>#LvarMontoTotal#</monto_archivo>
      <monto_ingresos>#LvarMontoIngreso#</monto_ingresos>
      <monto_egresos>#LvarMontoEgreso#</monto_egresos>
      <monto_ing_transf>#LvarMontoIngresoTransferencia#</monto_ing_transf >
      <monto_egr_transf>#LvarMontoEgresoTransferencia#</monto_egr_transf >
       <doc_apr>N</doc_apr>
   </datos_control>
   <documentos>
      <documento>
         <tipo_doc>#form.FPTVTipo#</tipo_doc>
         <secuencia>#LvarSecuencia#</secuencia> <!---falta--->
         <institucion>#LvarInstitucion#</institucion><!---validar si no se ha definido la institucion, que esta en configuracion de datos de archivo--->
         <ano>#LvarPeriodo#</ano>
         <saldos_cuentas>
				
            <ingresos>
               <detalles>
						<detalle>
						<cfquery dbtype="query" name="rsIngresos">
							select CFformatoCal, sum(Monto) as Monto from rsDatos where TIE = 'I' group by CFformatoCal
						</cfquery>
						<cfloop query="rsIngresos">
							<cuenta>#rsIngresos.CFformatoCal#</cuenta>
							<monto>#rsIngresos.Monto#</monto>
						</cfloop> 
					  </detalle>
               </detalles> 
				
               <transferencias>
                  <transferencia>
						<cfquery dbtype="query" name="rsIngresosTransferencia">
							select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'IT' group by CFformatoCal
						</cfquery>
						<cfloop query="rsIngresosTransferencia">
                     <cuenta>#rsIngresosTransferencia.CFformatoCal#</cuenta>
                     <valor>#rsIngresosTransferencia.Monto#</valor>
                     <institucion>#LvarInstitucion#</institucion>
						</cfloop>
                  </transferencia>
               </transferencias>
            </ingresos>
				
            <egresos>
			   	<cfquery name="VPrograma"  datasource="#session.dsn#">
						select a.PCNid, a.PCEMid,a.CFformato, a.Programa, d.PCDdescripcion from #temp# a inner join PCNivelMascara b
							on b.PCEMid = a.PCEMid 
							and b.PCNid = a.PCNid 
							inner join PCECatalogo c
								on c.PCEcatid = b.PCEcatid
							inner join PCDCatalogo d
								on d.PCEcatid = c.PCEcatid
								and c.PCEcatid = d.PCEcatid
								and d.PCDvalor = a.Programa
								and d.Ecodigo = #session.Ecodigo#
								and a.TIE in ('E','ET')
							group by a.PCNid, a.PCEMid,a.CFformato,a.Programa,d.PCDdescripcion
							order by a.PCNid, a.PCEMid
					</cfquery>
			
					<cfloop query="VPrograma">
               <programa>
							<codigo>#VPrograma.Programa#</codigo>
							<nombre>#VPrograma.PCDdescripcion#</nombre>
                  <cuentas>
                     <detalle>
							<cfquery dbtype="query" name="rsEgresos">
								select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'E' group by CFformatoCal
							</cfquery>
                     <cfloop query="rsEgresos">
								<cuenta>#rsEgresos.CFformatoCal#</cuenta>
								<monto>#rsEgresos.Monto#</monto>
							</cfloop> 
                     </detalle>
                  </cuentas>
						
                     <transferencias>
                        <transferencia>
									<cfquery dbtype="query" name="rsEgresosTransferencia">
										select CFformatoCal,sum(Monto) as Monto from rsDatos where TIE = 'ET' group by CFformatoCal
									</cfquery>
									<cfloop query="rsEgresosTransferencia">
										<cuenta>#rsEgresosTransferencia.CFformatoCal#</cuenta>
										<valor>#rsEgresosTransferencia.Monto#</valor>
										<institucion>#LvarInstitucion#</institucion>
									</cfloop>
                        </transferencia>
                     </transferencias>
               </programa>
				 </cfloop>
            </egresos>
         </saldos_cuentas>
      </documento>
   </documentos>
</doc_presup>
</cfoutput>

</cfsavecontent>
	<cffile action="write" nameconflict="overwrite" file="#zipfile#" output="#doc_file#" charset="utf-8">
