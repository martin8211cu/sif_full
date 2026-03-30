<cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces">
<cfset LobjInterfaz.sbReportarActividad(GvarNI, GvarID)>

<cfif listLen(GvarXML_IE) neq 7>
	<cfthrow message="Los Datos de entrada son 7: oficina, periodo, mes, codigo CF, formato cuenta inicial, y cuenta final, disponible">
</cfif>
<cfset LvarOcodigo			= listGetAt(GvarXML_IE,1)>
<cfset LvarEperiodo   		= listGetAt(GvarXML_IE,2)>
<cfset LvarEmes				= listGetAt(GvarXML_IE,3)>
<cfset CFcodigo				= listGetAt(GvarXML_IE,4)>
<cfset CPformatoIni   		= listGetAt(GvarXML_IE,5)>
<cfset CPformatoFin			= listGetAt(GvarXML_IE,6)>
<cfset LvarMdisponible		= listGetAt(GvarXML_IE,7)>

<cfif CFcodigo EQ -1>
	<cfthrow message="Falta Centro Funcional">
</cfif>
<cfif CPformatoIni EQ -1>
	<cfset CPformatoIni = "">
</cfif>
<cfif CPformatoFin EQ -1>
	<cfset CPformatoFin = chr(127)>
</cfif>

<cfquery name="rsCF" datasource="#session.dsn#">
	select 	CFid, CFcodigo, 	CFdescripcion,
			CFcuentac, 			CFcuentaaf,
			CFcuentainversion, 	CFcuentainventario,
			CFcuentaingreso, 	CFcuentagastoretaf,
			CFcuentaingresoretaf
	  from CFuncional 
	 where CFcodigo = '#CFcodigo#'
	 and Ecodigo=#session.Ecodigo#
</cfquery>
<cfif rsCF.CFid EQ "">
	<cfthrow message="Centro Funcional codigo :'#CFcodigo#' no existe">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
	select 
		a.Ocodigo,	 						
		b.CPformato,						
		d.CPCPcalculoControl
		from 
		CPresupuestoControl a
			inner join  CPresupuesto b
				on a.CPcuenta=b.CPcuenta
				and b.Ecodigo=a.Ecodigo
			inner join CPCuentaPeriodo d
				on d.CPcuenta=b.CPcuenta
		where  a.Ecodigo=#session.Ecodigo#
		and a.CPCano=#LvarEperiodo#
		and a.CPCmes=#LvarEmes#
		and a.Ocodigo=#LvarOcodigo#
</cfquery>

<cfif rsSQL.recordcount EQ 0>
	<cfthrow message="No existen datos en el periodo: #LvarEperiodo#, mes: #LvarEmes# y codigo oficina: #LvarOcodigo#">
</cfif>

<cfquery name="rsSQL" datasource="#session.dsn#">
select 
		a.Ocodigo,	 						
		a.CPCano as Eperiodo,             
		a.CPCmes as Emes,	 				
		a.CPCpresupuestado,					<!---Total de Presupuesto [A]  = Aprobación Presupuesto Ordinario--->
		a.CPCmodificado,					<!---Montos Extraordinarios[M]= Modificaciones Presupuestarias --->
		a.CPCejecutado,						<!---Movimientos[E] = Presupuesto Ejecutado--->
		a.CPCreservado,						<!---Reservas [RC] = Presupuesto Reservado--->
		a.CPCcomprometido,					<!---Compromisos [CC] = Presupuesto Comprometido--->
		a.CPCtrasladado,					<!---[T]  = Traslados de Presupuesto--->
		a.CPCmodificacion_Extraordinaria,	<!---[ME] = Excesos Autorizados (Modificación Extraordinaria)--->
		a.CPCvariacion,						<!---[VC] = Variación Cambiaria--->
		a.CPCreservado_Presupuesto,			<!---[RP] = Provisiones Presupuestarias--->
		a.CPCnrpsPendientes,				<!---[NP] = Rechazos Aprobados Pendientes de Aplicar--->
		a.CPCreservado_Anterior, 			<!---[RA]--->
		a.CPCcomprometido_Anterior,			<!---[CA]--->
		
		<!-----CFcodigo,					Centro Funcional--->
		
		b.CPformato,						
		b.CPdescripcion,					
		d.CPCPtipoControl,					
		d.CPCPcalculoControl,
		<!---[*PA]:PRESUPUESTO AUTORIZADO =[*PP]+[ME]=[A]+[M]+[T]+[VC]+[ME] --->
		(CPCpresupuestado+ CPCmodificado + CPCtrasladado + CPCvariacion + CPCmodificacion_Extraordinaria) <!---PA--->
		<!---[*PC]:PRESUPUESTO CONSUMIDO =[*PCA]+[RP]=[RA]+[CA]+[RC]+[CC]+[E]+[RP] --->
		-  (  CPCreservado_Anterior + CPCcomprometido_Anterior + CPCreservado + CPCcomprometido + CPCejecutado +  CPCreservado_Presupuesto  ) <!---PC--->
 		- CPCnrpsPendientes  as DNmonto		<!---DNmonto	Disponible [*DN]:DISPONIBLE NETO = [*PA] - [*PC] - [NP]--->		
		
		from 
		
		CPresupuestoControl a
		inner join  CPresupuesto b
			on a.CPcuenta=b.CPcuenta
			and b.Ecodigo=a.Ecodigo
		inner join CPCuentaPeriodo d
			on d.CPcuenta=b.CPcuenta
		inner join CFinanciera cf
			on cf.CPcuenta = b.CPcuenta	
		
		where  a.Ecodigo=#session.Ecodigo#
		and a.CPCano=#LvarEperiodo#
		and a.CPCmes=#LvarEmes#
		and a.Ocodigo=#LvarOcodigo#
		
		 and b.CPformato >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoIni#">
	   and b.CPformato <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#CPformatoFin##chr(127)#">
	  <!--- and b.CPmovimiento = 'S'--->
	   and (
			    cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentac)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaaf)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainversion)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainventario)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingreso)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentagastoretaf)#'
			 OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingresoretaf)#'
		)

</cfquery>

<cfset LvarTabla = "<recordset>">
<!---<CFcodigo>#rsSQL.CFcodigo#</CFcodigo>--->
	<cfloop query="rsSQL">
		<cfset LvarTabla &= " 
		<row>
			<Ocodigo>#rsSQL.Ocodigo#</Ocodigo>
			<Empresa>#session.Ecodigo#</Empresa>
			<Periodo>#rsSQL.Eperiodo#</Periodo>
			<Mes>#rsSQL.Emes#</Mes>
			
			<CPformato>#rsSQL.CPformato#</CPformato>
			<CPdescripcion>#rsSQL.CPdescripcion#</CPdescripcion>
			<CPCPtipoControl>#rsSQL.CPCPtipoControl#</CPCPtipoControl>
			<CPCPcalculoControl>#rsSQL.CPCPcalculoControl#</CPCPcalculoControl>
			<CPCpresupuestado>#rsSQL.CPCpresupuestado#</CPCpresupuestado>
			<CPCmodificado>#rsSQL.CPCmodificado#</CPCmodificado>
			<CPCejecutado>#rsSQL.CPCejecutado#</CPCejecutado>
			<CPCreservado>#rsSQL.CPCreservado#</CPCreservado>
			<CPCcomprometido>#rsSQL.CPCcomprometido#</CPCcomprometido>
			<DNmonto>#rsSQL.DNmonto#</DNmonto>
			<CPCtrasladado>#rsSQL.CPCtrasladado#</CPCtrasladado>
			<CPCmodificacion_Extraordinaria>#rsSQL.CPCmodificacion_Extraordinaria#</CPCmodificacion_Extraordinaria>
			<CPCvariacion>#rsSQL.CPCvariacion#</CPCvariacion>
			<CPCreservado_Presupuesto>#rsSQL.CPCreservado_Presupuesto#</CPCreservado_Presupuesto>
			<CPCnrpsPendientes>#rsSQL.CPCnrpsPendientes#</CPCnrpsPendientes>    
		</row>">
	</cfloop>
<cfset LvarTabla &= "<recordset>">

<cfset GvarXML_OE = LvarTabla>

<cffunction name="fnComodinToMascara" access="private" output="no">
	<cfargument name="Comodin" type="string" required="yes">

	<cfset var LvarComodines = "?,*,!">

	<cfset var LvarMascara = Arguments.Comodin>
	<cfloop index="LvarChar" list="#LvarComodines#">
		<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"_","ALL")>
	</cfloop>

	<cfreturn LvarMascara>
</cffunction>

