<!---
	Realizado por: Ernesto Raúl Bravo Gómez
	Fecha : 07/Junio/2013
	Motivo:	Creación de la tabla temporal para los reportes de saldos presupuestales
--->

<cfcomponent output="no">
	<cffunction name="CG_EstructuraSaldo" access="public" output="no" returntype="string">
		<cfargument name="IDEstrPro" 	type="numeric" 	required="yes">
		<cfargument name="PerInicio" 	type="numeric" 	required="yes">
		<cfargument name="MesInicio" 	type="numeric" 	required="yes">
		<cfargument name="PerFin" 		type="numeric" 	required="yes">
		<cfargument name="MesFin" 		type="numeric" 	required="yes">
		<cfargument name="PerIniPP" 	type="numeric" 	required="yes">
		<cfargument name="MesIniPP" 	type="numeric" 	required="yes">
		<cfargument name='MonedaLoc' 	type='boolean' 	required="yes">
		<cfargument name='invertirSaldo' 	type='boolean' 	default="false">
		<cfargument name="Mcodigo" 		type="numeric" 	required="no">
		<cfargument name="GvarConexion" type="string"   required="yes">

 		<cfset FechaCreacion = #dateFormat(now(),"DDMMYYYYHHMMSSSS")#>
		<cfset TablaTem = 'SaldosEstr'&#FechaCreacion#>

 		<cf_dbtemp name="#TablaTem#" returnVariable="SaldosEstr" datasource="#GvarConexion#">
			<cf_dbtempcol name="ID_GpoCat"    		type="int" >
            <cf_dbtempcol name="ID_Grupo"    		type="int" >
			<cf_dbtempcol name="ID_EstrPro"    		type="int" >
			<cf_dbtempcol name="ID_EstrCtaVal"    	type="int" >
			<cf_dbtempcol name="Ecodigo"    		type="int" >
			<cf_dbtempcol name="Cmayor"  			type="char(4)" >
			<cf_dbtempcol name="Cformato"  			type="varchar(100)" >
			<cf_dbtempcol name="Ccuenta"			type="varchar(100)"	>
			<cf_dbtempcol name="CPCpresupuestado"	type="money" >
			<cf_dbtempcol name="CPCpresup_Anual"	type="money" >
            <cf_dbtempcol name="CPCmodificado"		type="money" >
            <cf_dbtempcol name="CPCmodificacion_Excesos"	type="money" >
            <cf_dbtempcol name="CPCvariacion"		type="money" >
            <cf_dbtempcol name="CPCtrasladado"		type="money" >
            <cf_dbtempcol name="CPCreservado_Anterior"		type="money" >
            <cf_dbtempcol name="CPCcomprometido_Anterior"	type="money" >
            <cf_dbtempcol name="CPCreservado_Presupuesto"	type="money" >
            <cf_dbtempcol name="CPCreservado"		type="money" >
            <cf_dbtempcol name="CPCcomprometido"	type="money" >
            <cf_dbtempcol name="CPCnrpsPendientes"	type="money" >
            <cf_dbtempcol name="CPCejecutado"		type="money" >
            <cf_dbtempcol name="CPCpagado"			type="money" >
            <cf_dbtempcol name="CPCtrasladadoE"		type="money" >
            <cf_dbtempcol name="CPCautsPendientes"	type="money" >
            <cf_dbtempcol name="CPCejercido"		type="money" >
            <cf_dbtempcol name="CPCejecutadoNC"		type="money" >

            <cf_dbtempcol name="CPCmodificadoAnual"	type="money" >
            <cf_dbtempcol name="CPCmodif_ExcAnual"	type="money" >
            <cf_dbtempcol name="CPCtras_Anual"		type="money" >
            <cf_dbtempcol name="CPCtrasE_Anual"		type="money" >
			<cf_dbtempcol name="CPCpresupPeriodo"	type="money" >


			<cf_dbtempcol name="PCDcatid"    		type="int">
			<cf_dbtempcol name="PCDvalor" 	 		type="varchar(20)" >
			<cf_dbtempcol name="PCDdescripcion" 	type="varchar(100)" >
			<cf_dbtempcol name="ClasCatCon" 		type="int">
			<cf_dbtempcol name="PCDcatidH"    		type="int">
			<cf_dbtempcol name="PCDvalorH" 	 		type="varchar(20)" >
			<cf_dbtempcol name="PCDdescripcionH" 	type="varchar(100)" >
			<cf_dbtempcol name="SoloHijos" 			type="bit"  default="0">
			<!--- MEG --->
			<cf_dbtempcol name="CGEPctaTipo"    	type="varchar(1)">
			<cf_dbtempcol name="CGEPctaGrupo" 	 	type="int">
			<cf_dbtempcol name="CGEPctaBalance" 	type="int">
			<cf_dbtempcol name="ID_GrupoPadre"    		type="int" >

		</cf_dbtemp>

		<!----Parametro si es moneda local
		<cfquery datasource="#Gvarconexion#" name="rsMonLoc">
			select m.Mcodigo
            from Monedas m
	        inner join Empresas e
    	    on m.Ecodigo = e.Ecodigo
   	        and m.Mcodigo = e.Mcodigo
       	    and e.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		--->



		<cfquery datasource="#GvarConexion#" name="rsSaldos">
				insert into #SaldosEstr# (ID_GpoCat, ID_Grupo, ID_EstrPro, ID_EstrCtaVal, Ecodigo, Cmayor, Cformato, Ccuenta,
                CPCpresupuestado,CPCpresup_Anual,CPCmodificado,CPCmodificacion_Excesos,CPCvariacion,CPCtrasladado,CPCreservado_Anterior,
                CPCreservado_Presupuesto,CPCreservado,CPCcomprometido,CPCnrpsPendientes,CPCejecutado,CPCpagado,CPCtrasladadoE,
                CPCautsPendientes,CPCejercido,CPCejecutadoNC,CPCmodificadoAnual,CPCmodif_ExcAnual,CPCtras_Anual,CPCtrasE_Anual,CPCpresupPeriodo,
                PCDcatid, PCDvalor, PCDdescripcion,ClasCatCon, SoloHijos,PCDcatidH,PCDvalorH, PCDdescripcionH,
				CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance,ID_GrupoPadre)
				select distinct X.ID_Grupo, gcm.ID_Grupo, cge.ID_Estr, X.ID_EstrCtaVal, c.Ecodigo, c.Cmayor, c.CPformato, c.CPcuenta,

				CPCpresupuestado = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">

                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCpresup_Anual = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,

				CPCmodificado = isnull((select SUM(CPCmodificado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCmodificacion_Excesos = isnull((select SUM(CPCmodificacion_Excesos) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00),
				CPCvariacion = isnull((select SUM(CPCvariacion) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCtrasladado = isnull((select SUM(CPCtrasladado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCreservado_Anterior = isnull((select SUM(CPCreservado_Anterior) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCreservado_Presupuesto = isnull((select SUM(CPCreservado_Presupuesto) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCreservado = isnull((select SUM(CPCreservado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCcomprometido = isnull((select SUM(CPCcomprometido) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCnrpsPendientes = isnull((select SUM(CPCnrpsPendientes) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCejecutado = isnull((select SUM(CPCejecutado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,

				CPCpagado = isnull((select SUM(CPCpagado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCtrasladadoE = isnull((select SUM(CPCtrasladadoE) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCautsPendientes = isnull((select SUM(CPCautsPendientes) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCejercido = isnull((select SUM(CPCejercido) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCejecutadoNC = isnull((select SUM(CPCejecutadoNC) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCmodificadoAnual = isnull((select SUM(CPCmodificado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCmodif_ExcAnual = isnull((select SUM(CPCmodificacion_Excesos) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCtras_Anual = isnull((select SUM(CPCtrasladado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCtrasE_Anual = isnull((select SUM(CPCtrasladadoE) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerIniPP#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">

<!---								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesIniPP#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
--->
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CPCpresupPeriodo = isnull((select SUM(CPCpresupuestado) from CPresupuestoControl
								where CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
                                	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and CPCmes between  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
                                 	and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
                                and CPcuenta = c.CPcuenta)
                                ,0.00)<cfif Arguments.invertirSaldo> *case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,

                X.PCDcatid, X.PCDvalor, X.PCDdescripcion,isnull(cl.PCCDclaid,0), SoloHijos = isnull(X.SoloHijos,0), Y.PCDcatidref,
                Y.PCDvalor, Y.PCDdescripcion, cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance,gcgm.ID_GrupoPadre
				from (
					select 	Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
						select Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
							select  cc.CPformato Cformato, cc.CPcuenta Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join CPresupuesto cc
								on cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas in (1,3)
								and cc.CPmovimiento = 'S'
							union all
							select  cc.CPformato Cformato, epc.CPcuenta Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join (SELECT d.ID_Estr, cp.CPcuenta from CGEstrProgCtaD d
											inner join CPresupuesto cp
											on cp.CPformato like replace(d.FormatoP,'X','_')) epc
								on epc.ID_Estr = cge.ID_Estr
							inner join CPresupuesto cc
								on epc.CPcuenta = cc.CPcuenta
								and cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas = 2
								and cc.CPmovimiento = 'S'
						) incluye
						except
						select  cc.CPformato Cformato, epc.CPcuenta Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
						from CGEstrProgCtaM cge
						inner join (SELECT d.ID_Estr, cp.CPcuenta from CGEstrProgCtaD d
											inner join CPresupuesto cp
											on cp.CPformato like replace(d.FormatoP,'X','_')) epc
							on epc.ID_Estr = cge.ID_Estr
						inner join CPresupuesto cc
							on epc.CPcuenta = cc.CPcuenta
							and cc.Cmayor = cge.CGEPCtaMayor
						where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and cge.CGEPInclCtas = 3
							and cc.CPmovimiento = 'S'
					) ctas

				) cge
				inner join CGEstrProg ep
					on cge.ID_Estr = ep.ID_Estr

				inner join CPresupuesto c on cge.CGEPCtaMayor = c.Cmayor
						and c.CPcuenta = cge.Ccuenta

				inner join (select distinct CPcuenta,Ecodigo from CPresupuestoControl
					where CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
					)sc on sc.CPcuenta = c.CPcuenta

				left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr
				left join CGGrupoPadreCtas gcgm on gcm.ID_GrupoPadre = gcgm.ID_GrupoPadre and gcm.ID_Estr = gcgm.ID_Estr
				left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, <!--- sc.CPCmes, sc.CPCano, ---> cc.PCDvalor, cc.PCDdescripcion, epvd.ID_EstrCtaVal,
						case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv,
										epvd.PCDcatid, epv.ID_Grupo, epv.SoloHijos
			 			    from CGEstrProgCtaM cge

						    inner join CPresupuesto c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta
							<!--- inner join CPresupuestoControl sc on sc.CPcuenta = c.CPcuenta --->
							inner join CGDEstrProgVal epvd on epvd.PCDcatid = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
						   	and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
			 				inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatid
			 				inner join (
								select distinct c.Cmayor, c.CPformato, c.CPcuenta, cc.PCDvalor, cc.PCDdescripcion, epvd.PCDcatidref,
									case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv,
									epv.ID_EstrCtaVal
								from CGEstrProgCtaM cge
								inner join CPresupuesto  c on cge.CGEPCtaMayor = c.Cmayor
								inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta
								inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid
								inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
								and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
								where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and c.CPmovimiento = 'S'
							) y
								on y.CPcuenta = c.CPcuenta and y.ID_EstrCtaVal = epvd.ID_EstrCtaVal
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.CPmovimiento = 'S'
							<!--- and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#"> --->)
                            as X on X.CPcuenta = c.CPcuenta and X.CPformato = c.CPformato

				left join (select distinct c.Cmayor, c.CPformato, c.CPcuenta, <!--- sc.CPCmes, sc.CPCano, ---> cc.PCDvalor, cc.PCDdescripcion, epvd.PCDcatidref,
						case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv
						    from CGEstrProgCtaM cge
						    inner join CPresupuesto  c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuentaP nm on nm.CPcuenta = c.CPcuenta
							<!--- inner join CPresupuestoControl sc on sc.CPcuenta = c.CPcuenta --->
							inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
							and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.CPmovimiento = 'S'
							<!--- and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#"> --->)
                            as Y on Y.CPcuenta = c.CPcuenta and Y.CPformato = c.CPformato
				left join  (
						select nm.CPcuenta, nm.PCEcatid, cc.PCCDclaid
						 from  PCDCatalogoCuentaP nm
						 inner join PCDClasificacionCatalogo cc
							on cc.PCDcatid = nm.PCDcatid  <!--- and c.PCDcatid = nm.PCDcatid --->
						 inner join PCClasificacionD cd
							on cd.PCCEclaid = cc.PCCEclaid
							and cc.PCCDclaid = cd.PCCDclaid
						) cl
					 on cge.Ccuenta = cl.CPcuenta
						and ep.PCEcatidClasificado = cl.PCEcatid

				where sc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
				and c.CPmovimiento = 'S'
				<!--- and X.ID_EstrCtaVal =  112 --->
				<!--- and sc.CPCano between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
				and sc.CPCmes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> --->
		</cfquery>

       <!--- <cfquery datasource="#GvarConexion#" name="RScomprueba">
        	select top 100 *
			from #SaldosEstr#
			Where PCDcatidH is null <!--- SoloHijos = 1 --->
		</cfquery>
		<cf_dump var="#RScomprueba#"> --->

    	<!---ELIMINA VALORES DEL PCDCatalogo QUE NO ESTAN EN LA ESTRUCTURA PROGRAMATICA --->
        <!--- <cfquery datasource="#GvarConexion#" name="RSElimina">
        	delete
            from #SaldosEstr#
            where coalesce(PCDcatid,'0') not in
            	(select a.PCDcatid
            	 from CGDEstrProgVal a
                 	inner join CGEstrProgVal b
                    on a.ID_EstrCtaVal = b.ID_EstrCtaVal and b.ID_Estr = #SaldosEstr#.ID_EstrPro)
			and ID_EstrPro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
        </cfquery> --->

        <!---ELIMINA HIJOS CUANDO LA ESTRUCTURA PROGRAMATICA CONTIENE HIJOS--->
		<cf_dbfunction name="op_concat" datasource="#GvarConexion#" returnvariable="_Cat">
		<cfquery datasource="#GvarConexion#" name="RSElimina">
			delete
			from #SaldosEstr#
			where convert(varchar,coalesce(PCDcatid,'0')) in (
				select distinct a.PCDcatid from (
					select count(convert(varchar,coalesce(b.PCDcatid,'0'))) cantidad, convert(varchar,coalesce(b.PCDcatid,'0')) PCDcatid
								 from CGEstrProgVal c
									inner join CGDEstrProgVal b
										 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
									inner join CGDDetEProgVal a
										on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
							where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
							and convert(varchar,coalesce(b.PCDcatid,'0')) <> '0'
					group by  convert(varchar,coalesce(b.PCDcatid,'0'))
					having count(convert(varchar,coalesce(b.PCDcatid,'0'))) > 0
				) a
				inner join (
					select convert(varchar,coalesce(b.PCDcatid,'0')) PCDcatid,convert(varchar,coalesce(a.PCDcatidref,'0')) PCDcatidref, convert(varchar,coalesce(b.PCDcatid,'0')) + '-' + convert(varchar,coalesce(a.PCDcatidref,'0')) Concepto
						     from CGEstrProgVal c
								inner join CGDEstrProgVal b
									 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
				                inner join CGDDetEProgVal a
									on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
						where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
				) b
					on a.PCDcatid = b.PCDcatid
			)
			and convert(varchar,coalesce(PCDcatid,'0')) + '-' + convert(varchar,coalesce(PCDcatidH,'0')) not in (
				select  b.Concepto from (
					select count(convert(varchar,coalesce(b.PCDcatid,'0'))) cantidad, convert(varchar,coalesce(b.PCDcatid,'0')) PCDcatid
								 from CGEstrProgVal c
									inner join CGDEstrProgVal b
										 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
									inner join CGDDetEProgVal a
										on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
							where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
							and convert(varchar,coalesce(b.PCDcatid,'0')) <> '0'
					group by  convert(varchar,coalesce(b.PCDcatid,'0'))
					having count(convert(varchar,coalesce(b.PCDcatid,'0'))) > 0
				) a
				inner join (
					select convert(varchar,coalesce(b.PCDcatid,'0')) PCDcatid,convert(varchar,coalesce(a.PCDcatidref,'0')) PCDcatidref, convert(varchar,coalesce(b.PCDcatid,'0')) + '-' + convert(varchar,coalesce(a.PCDcatidref,'0')) Concepto
						     from CGEstrProgVal c
								inner join CGDEstrProgVal b
									 on b.ID_EstrCtaVal = c.ID_EstrCtaVal and c.SoloHijos = 1
				                inner join CGDDetEProgVal a
									on a.ID_DEstrCtaVal = b.ID_DEstrCtaVal
						where c.ID_Estr = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
				) b
					on a.PCDcatid = b.PCDcatid
			)
				and ID_EstrPro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDEstrPro#">
				and SoloHijos = 1
        </cfquery>

	<cfreturn SaldosEstr>
	</cffunction>

	<cffunction name="CG_EstructuraMovimientos" access="private" output="no">
	</cffunction>
</cfcomponent>

