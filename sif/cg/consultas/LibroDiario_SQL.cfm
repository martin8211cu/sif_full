<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Libro Diario General" 
returnvariable="LB_Titulo" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_ConceptoContable" 	default="Concepto Contable" 
returnvariable="LB_ConceptoContable" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Asiento" 	default="Asiento" 
returnvariable="LB_Asiento" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Fecha" 	default="Fecha" 
returnvariable="LB_Fecha" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Documento" 	default="Documento" 
returnvariable="LB_Documento" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_SubCuenta" 	default="SubCuenta" 
returnvariable="LB_SubCuenta" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripcion" 
returnvariable="LB_Descripcion" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Concepto" 	default="Concepto" 
returnvariable="LB_Concepto" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Debe" 	default="Debe" 
returnvariable="LB_Debe" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Haber" 	default="Haber" 
returnvariable="LB_Haber" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TotalAsientoContable" 	default="Total Asiento Contable" 
returnvariable="LB_TotalAsientoContable" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Archivo" 	default="LibroDiario" 
returnvariable="LB_Archivo" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Periodo" 	default="Periodo" 
returnvariable="LB_Periodo" xmlfile="LibroDiario_SQL.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mes" 	default="Mes" 
returnvariable="LB_Mes" xmlfile="LibroDiario_SQL.xml"/>

<cfquery name="rsParametro" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #session.Ecodigo#
	and Pcodigo = 981
</cfquery>
<cfset LvarParametro = 0>
<cfif isdefined("rsParametro") and rsParametro.recordcount eq 1>
		<cfset LvarParametro = rsParametro.Pvalor>
</cfif>


<cfset Lvarfile 	= "#LB_Archivo#" >
<cfset LvarDebe 	= "Debe">
<cfset LvarHaber 	= "Haber">
<cf_dbfunction name="string_part" args="cf.CFformato,2,100" returnvariable="LvarFormato">

<cfdump  var="#url.formato#">

<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato  eq 'tab'>
	<cfsavecontent variable="myQuery">
	<cfoutput>
		select 
			e.Eperiodo as #LB_Periodo#, 
			e.Emes as #LB_Mes#, 
			e.Cconcepto as Concepto, 
			c.Cdescripcion as DescripcionConcepto, 
			e.Edocumento as Documento, 
			e.Efecha as Fecha, 
			e.Ereferencia ,
			d.Ddescripcion as Descripcion,
			d.Dlinea as Linea,
			o.Oficodigo as Oficina,
			d.Ddocumento as DDocumento,
			e.Edescripcion,
			d.Dreferencia as Referencia,
			#LvarFormato# as Cuenta,
			m.Msimbolo as Moneda,
			m.Mnombre,
			coalesce(d.Doriginal, 1) as  Monto,
			case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as #LvarDebe#,
			case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as #LvarHaber#,
			e.ECusuario as Usuario,
			e.ECfechacreacion,
			e.ECfechaaplica,
			u.Usulogin as UsuarioAplica
		from HEContables e
		   inner join HDContables d
			  on d.IDcontable = e.IDcontable
		   inner join Oficinas o
			  on o.Ecodigo = e.Ecodigo
			 and o.Ocodigo = d.Ocodigo		  
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join CFinanciera cf
			  on cf.CFcuenta = d.CFcuenta
		   inner join Monedas m
			  on m.Mcodigo = d.Mcodigo
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica	  
	
		where e.Ecodigo = #session.Ecodigo#
		 <cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= #url.PeriodoIni#
			and e.Eperiodo <= #url.PeriodoFin#
		 </cfif>
		 <cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (#url.PeriodoIni#* 100 + #url.MesIni#) and (#url.PeriodoFin# * 100 + #url.MesFin#))
		 </cfif>
		 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = '#UCase(Trim(url.Usuario))#' or '#url.Usuario#' = 'Todos')
		 </cfif>
		 <cfif isdefined ("url.Oficodigo") and len(trim(url.Oficodigo))>
			and (o.Ocodigo = #url.Oficodigo# or #url.Oficodigo# = -1)
		 </cfif>
		  <!--- FILTROS DE Conceptos --->
		 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= #url.loteini#
			and e.Cconcepto <= #url.lotefin#
		 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= #url.loteini#
		 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
			and e.Cconcepto <= #url.lotefin#
		 </cfif> 
		 
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= #url.EdocumentoI# 
			and e.Edocumento <= #url.EdocumentoF#
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= #url.EdocumentoI#
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
			and e.Edocumento <= #url.EdocumentoF#
		</cfif>
		<!--- FILTROS DE ORDENAMIENTO--->
		<cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		</cfif>
		<cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		<cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
			order by e.Cconcepto, e.Edocumento,  d.Ddocumento, d.Dlinea
		</cfif>
	</cfoutput>
	</cfsavecontent>	

	<cftry>
		<cfflush interval="64">
		<cf_jdbcquery_open name="data" datasource="#session.DSN#">
		<cfoutput>#myquery#</cfoutput>
		</cf_jdbcquery_open>
		<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="#Lvarfile#_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="true">
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
	<cf_jdbcquery_close>
<cfelse>
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select 
			count (1) as cantidad
		from HEContables e
		   inner join HDContables d
			  on d.IDcontable = e.IDcontable
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
		 </cfif>
		 <cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
		 </cfif>
		 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#"> = 'Todos')
		 </cfif>
		 <cfif isdefined ("url.Oficodigo") and len(trim(url.Oficodigo))>
			and (d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Oficodigo#"> or <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> = -1)
		 </cfif>
		  <!--- FILTROS DE Conceptos --->
		 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#"> 
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
		 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 </cfif> 
		 
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#"> 
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		</cfif>
	</cfquery>
	
	<cfif rsReporte.cantidad GT 7000 and isdefined("url.formato") and url.formato neq 'tab'>
		<br>
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Se genero un reporte de más de 7,000 Registros.
		<br>
		&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Registros Generados: <cfoutput>#LSnumberformat(rsReporte.cantidad, '_,')#</cfoutput>. 
		<br />
		<br />
		&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; Debe ser más específico con los filtros del reporte.
		<br />
		<br />
		&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <a href="LibroDiario.cfm">Regresar</a>
		<cfabort>
	</cfif>
	
	<cfif isdefined('url.actulizarp')>
		<cfif url.hayAutoP EQ "1">
				<cfquery name="rsUpdate" datasource="#session.DSN#">
					update Parametros
					   set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.firmaautorizada#">
					 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and Pcodigo = 752
				</cfquery>
			<cfelseif url.hayAutoP EQ "0" and Len(Trim(url.firmaautorizada)) GT 0>
				<cfquery name="rsInsert" datasource="#session.DSN#">
					insert into Parametros (Ecodigo, Pcodigo,Mcodigo,Pdescripcion,Pvalor,BMUsucodigo)
					values(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							752,
							<cfqueryparam cfsqltype="cf_sql_char" value="CG">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Firma autorizada para Pólizas">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#url.firmaAutorizada#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
				</cfquery>
			</cfif>
	</cfif>
	<!--- cfquery sin corte --->
	<cfquery name="rsReporte" datasource="#session.DSN#">
		select  
			e.Cconcepto as Concepto, 
			c.Cdescripcion as DescripcionConcepto, 
			e.Edocumento as Documento, 
			e.Efecha as Fecha, 
			e.Eperiodo as Periodo, 
			e.Emes as Mes, 
			e.ECauxiliar as Auxiliar, 
			e.ECusuario as Usuario, 
			e.ECfechacreacion,
			e.ECfechaaplica,
			u.Usulogin as UsuarioAplica,
			d.Dlinea as Linea,
			e.Oorigen,
			d.Ddocumento as DDocumento,
			d.Ddescripcion as Descripcion,
			d.Dreferencia as Referencia,
			cf.CFformato as Cuenta,
			cf.CFdescripcion as DescCuenta,
			o.Oficodigo as Oficina,
			coalesce(d.Doriginal, 1) as  Monto,
			m.Msimbolo as Moneda,
			m.Mnombre,
			coalesce(d.Dtipocambio, 1) as	 TipoCambio, 
			case when Dmovimiento = 'D' then d.Dlocal else 0.00 end as Debitos,
			case when Dmovimiento = 'C' then d.Dlocal else 0.00 end as Creditos,
			'#Dateformat(now(), "DD/MM/YYYY") & TimeFormat(now(), "HH:MM:SS")#' as fecha_hora,
			e.Edescripcion,
			m.Miso4217, e.Ereferencia as ref 
		from HEContables e
		   inner join HDContables d
			  on d.IDcontable = e.IDcontable
		   inner join Oficinas o
			  on o.Ecodigo = e.Ecodigo
			 and o.Ocodigo = d.Ocodigo		  
		   inner join ConceptoContableE c
			  on c.Ecodigo 	 = e.Ecodigo
			 and c.Cconcepto = e.Cconcepto
		   inner join CFinanciera cf
			  on cf.CFcuenta = d.CFcuenta
		   inner join Monedas m
			  on m.Mcodigo = d.Mcodigo
		   inner join Usuario u
			 on u.Usucodigo = e.ECusucodigoaplica
	
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 <cfif isdefined ("url.periodoIni") and isdefined ("url.PeriodoFin")>
			and e.Eperiodo >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#">
			and e.Eperiodo <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#">
		 </cfif>
		 <cfif isdefined ("url.periodoini") and isdefined ("url.mesini")>
		   and ((e.Eperiodo * 100 + e.Emes)  between (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoIni#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesIni#">) and (<cfqueryparam cfsqltype="cf_sql_integer" value="#url.PeriodoFin#"> * 100 + <cfqueryparam cfsqltype="cf_sql_integer" value="#url.MesFin#">))
		 </cfif>
		 <cfif isdefined ("url.Usuario") and len(trim(url.Usuario))>
			and (upper(ltrim(rtrim(e.ECusuario))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(Trim(url.Usuario))#"> or <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Usuario#"> = 'Todos')
		 </cfif>
		 <cfif isdefined ("url.Oficodigo") and len(trim(url.Oficodigo))>
			and (o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Oficodigo#"> or <cfqueryparam cfsqltype="cf_sql_char" value="#url.Oficodigo#"> = -1)
		 </cfif>
		  <!--- FILTROS DE Conceptos --->
		 <cfif isdefined("url.loteini") and len(trim(url.loteini)) and isdefined("url.lotefin") and len(trim(url.lotefin))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#"> 
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 <cfelseif isdefined("url.loteini") and len(trim(url.loteini))>
			and e.Cconcepto >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.loteini#">
		 <cfelseif isdefined("url.lotefin") and len(trim(url.lotefin))> 
			and e.Cconcepto <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.lotefin#">
		 </cfif> 
		 
		<!--- FILTROS DE ASIENTOS --->
		<cfif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI)) and isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#"> 
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		<cfelseif isdefined("url.EdocumentoI") and len(trim(url.EdocumentoI))>
			and e.Edocumento >= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoI#">
		<cfelseif isdefined("url.EdocumentoF") and len(trim(url.EdocumentoF))> 
			and e.Edocumento <= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.EdocumentoF#">
		</cfif>
		<!--- FILTROS DE ORDENAMIENTO--->
		<cfif not isdefined ("url.ordenamiento") or len(trim(url.ordenamiento)) EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		</cfif>
		<cfif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 0>
			order by e.Cconcepto, e.Edocumento, d.Dlinea, d.Ddocumento
		<cfelseif isdefined ("url.ordenamiento") and len(trim(url.ordenamiento)) and url.ordenamiento EQ 1>
			order by e.Cconcepto, e.Edocumento,  d.Ddocumento, d.Dlinea
		</cfif>
		 
	</cfquery>

	<!--- Define cual reporte va a llamar --->
	<cfset nombreReporteJR = "">
	<cfif LvarParametro>
		<cfset archivo = "LibroDiarioDescCuenta.cfr">
		<cfset nombreReporteJR = "LibroDiarioDescCuenta">
	<cfelse>
		<cfif isdefined("url.chkCorteDocumento")>
			<cfset archivo = "LibroDiarioCorteDoc.cfr">
			<cfset nombreReporteJR = "LibroDiarioCorteDoc">
		<cfelse>
			<cfset archivo = "LibroDiario.cfr">
			<cfset nombreReporteJR = "LibroDiario">
		</cfif>
	</cfif>	

	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfswitch expression="#url.MESINI#">
		<cfcase value="1">
			<cfset LvarMesIni = "Enero">
		</cfcase>
		<cfcase value="2">
			<cfset LvarMesIni = "Febrero">
		</cfcase>
		<cfcase value="3">
			<cfset LvarMesIni = "Marzo">
		</cfcase>
		<cfcase value="4">
			<cfset LvarMesIni = "Abril">
		</cfcase>
		<cfcase value="5">
			<cfset LvarMesIni = "Mayo">
		</cfcase>
		<cfcase value="6">
			<cfset LvarMesIni = "Junio">
		</cfcase>
		<cfcase value="7">
			<cfset LvarMesIni = "Julio">
		</cfcase>
		<cfcase value="8">
			<cfset LvarMesIni = "Agosto">
		</cfcase>
		<cfcase value="9">
			<cfset LvarMesIni = "Septiembre">
		</cfcase>
		<cfcase value="10">
			<cfset LvarMesIni = "Octubre">
		</cfcase>
		<cfcase value="11">
			<cfset LvarMesIni = "Noviembre">
		</cfcase>
		<cfcase value="12">
			<cfset LvarMesIni = "Diciembre">
		</cfcase>
	</cfswitch>
	
	<cfswitch expression="#url.MESFIN#">
		<cfcase value="1">
			<cfset LvarMesFin = "Enero">
		</cfcase>
		<cfcase value="2">
			<cfset LvarMesFin = "Febrero">
		</cfcase>
		<cfcase value="3">
			<cfset LvarMesFin = "Marzo">
		</cfcase>
		<cfcase value="4">
			<cfset LvarMesFin = "Abril">
		</cfcase>
		<cfcase value="5">
			<cfset LvarMesFin = "Mayo">
		</cfcase>
		<cfcase value="6">
			<cfset LvarMesFin = "Junio">
		</cfcase>
		<cfcase value="7">
			<cfset LvarMesFin = "Julio">
		</cfcase>
		<cfcase value="8">
			<cfset LvarMesFin = "Agosto">
		</cfcase>
		<cfcase value="9">
			<cfset LvarMesFin = "Septiembre">
		</cfcase>
		<cfcase value="10">
			<cfset LvarMesFin = "Octubre">
		</cfcase>
		<cfcase value="11">
			<cfset LvarMesFin = "Noviembre">
		</cfcase>
		<cfcase value="12">
			<cfset LvarMesFin = "Diciembre">
		</cfcase>
	</cfswitch>	
	
<!---	<cfset LvarNombreReporte = 'Libro Diario'>
	<cfset Request.LvarTitle = 'Libro Diario'>
--->    
    <cfset LvarNombreReporte = '#LB_Titulo#'>
    <cfset Request.LvarTitle = '#LB_Titulo#'>
	<!--- INVOCA EL REPORTE --->
	<!--- Meter el translate y pasar el título del reporte por parámetro. --->
	<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
	<cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
		<cfif url.formato EQ "pdf">
		  <cfset typeRep = 2>
		</cfif>
		<cf_js_reports_service_tag queryReport = "#rsReporte#" 
				isLink = False 
				typeReport = #typeRep#
				fileName = "cg.consultas.#nombreReporteJR#"
				headers = "title:#LB_Titulo#"/>
	<cfelse>
		<cfreport format="#url.formato#" template="#archivo#" query="rsReporte">
			<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
			<cfreportparam name="Edesc" value="#rsEmpresa.Edescripcion#">
			<cfif isdefined("url.firmaAutorizada") and len(trim(url.firmaAutorizada)) and isdefined("url.chkCorteDocumento")> 
				<cfreportparam name="firmaAutorizada" value="#url.firmaAutorizada#">
			<cfelse>
				<cfreportparam name="firmaAutorizada" value="">
			</cfif>
			<cfreportparam name="NombreReporte" value="#LvarNombreReporte#">
			<cfreportparam name="MesIni" value="#LvarMesIni#">
			<cfreportparam name="MesFin" value="#LvarMesFin#">
			<cfreportparam name="PeriodoIni" value="#url.PERIODOINI#">
			<cfreportparam name="PeriodoFin" value="#url.PERIODOFIN#">
					<cfreportparam name="ConceptoContable" value="#LB_ConceptoContable#">
					<cfreportparam name="Asiento" value="#LB_Asiento#">
					<cfreportparam name="Fecha" value="#LB_Fecha#">
					<cfreportparam name="Documento" value="#LB_Documento#">
					<cfreportparam name="SubCuenta" value="#LB_SubCuenta#">
					<cfreportparam name="Descripcion" value="#LB_Descripcion#">
					<cfreportparam name="Concepto" value="#LB_Concepto#">
					<cfreportparam name="Debe" value="#LB_Debe#">
					<cfreportparam name="Haber" value="#LB_Haber#">
					<cfreportparam name="TotalAC" value="#LB_TotalAsientoContable#">
			</cfreport>
		</cfif>
</cfif>


	
	
	

