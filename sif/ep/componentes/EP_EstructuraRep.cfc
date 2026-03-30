<!---
	Realizado por: Maria de los Angeles Blanco López
	Fecha : 02/Enero/2013
	Motivo:	Creación de la tabla temporal para los reportes de estructura programatica

--->
<cfcomponent output="no">
	<cffunction name="CG_EstructuraSaldo" access="public" output="no" returntype="string">
		<!---<cfargument name="Reporte" 		type="string" required="yes">--->
		<cfargument name="IDEstrPro" 	type="numeric" 	required="yes">
		<cfargument name="PerInicio" 	type="numeric" 	required="yes">
		<cfargument name="MesInicio" 	type="numeric" 	required="yes">
		<cfargument name="PerFin" 		type="numeric" 	required="yes">
		<cfargument name="MesFin" 		type="numeric" 	required="yes">
		<cfargument name='MonedaLoc' 	type='boolean' 	required="yes">
		<cfargument name='invertirSaldo' 	type='boolean' 	default="false">
		<cfargument name="Mcodigo" 		type="numeric" 	required="no">
		<cfargument name="GvarConexion" type="string"   required="yes">
<!--- Control Evento Inicia
        <cfargument name="NumeroEvento" 	type="string" 	required="no">
 Control Evento Fin --->
 		<cfset FechaCreacion = #dateFormat(now(),"DDMMYYYYHHMMSSSS")#>
		<cfset TablaTem = 'SaldosEstr'&#FechaCreacion#>

 		<cf_dbtemp name="#TablaTem#" returnVariable="SaldosEstr" datasource="#GvarConexion#">
			<cf_dbtempcol name="ID_Grupo"    		type="int" >
			<cf_dbtempcol name="ID_EstrPro"    		type="int" >
			<cf_dbtempcol name="ID_EstrCtaVal"    	type="int" >
			<cf_dbtempcol name="Ecodigo"    		type="int" >
			<cf_dbtempcol name="Cmayor"  			type="char(4)" >
			<cf_dbtempcol name="Cformato"  			type="varchar(100)" >
			<cf_dbtempcol name="Ccuenta"			type="varchar(100)"	>
			<cf_dbtempcol name="SLinicial" 	 		type="money" >
			<cf_dbtempcol name="DLdebitos" 	 		type="money">
			<cf_dbtempcol name="CLcreditos" 	 	type="money" >
			<cf_dbtempcol name="SOinicial" 	 		type="money" >
			<cf_dbtempcol name="DOdebitos" 	 		type="money" >
			<cf_dbtempcol name="COcreditos" 	 	type="money" >
			<cf_dbtempcol name="Mcodigo" 	 		type="integer" >
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
			<cf_dbtempcol name="ID_GrupoPadre" 		type="int" >

		<!---	<cf_dbtempcol name="Mes" 	 		    type="integer" >
			<cf_dbtempcol name="Periodo" 	 		type="integer" >--->
		</cf_dbtemp>

		<!----Parametro si es moneda local--->
		<cfquery datasource="#Gvarconexion#" name="rsMonLoc">
			select m.Mcodigo
            from Monedas m
	        inner join Empresas e
    	    on m.Ecodigo = e.Ecodigo
   	        and m.Mcodigo = e.Mcodigo
       	    and e.Ecodigo = <cfqueryparam cfsqltype ="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif Arguments.MonedaLoc EQ true>
			<cfquery datasource="#GvarConexion#" name="rsSaldos">
				insert into #SaldosEstr# (ID_Grupo, ID_EstrPro, ID_EstrCtaVal, Ecodigo, Cmayor, Cformato, Ccuenta, SLinicial, DLdebitos,
							CLcreditos, SOinicial, DOdebitos, COcreditos, Mcodigo, PCDcatid, PCDvalor, PCDdescripcion,ClasCatCon, SoloHijos,PCDcatidH,
							PCDvalorH, PCDdescripcionH, CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance,ID_GrupoPadre) 
				select distinct gcm.ID_Grupo, cge.ID_Estr, X.ID_EstrCtaVal, sc.Ecodigo, c.Cmayor, c.Cformato, c.Ccuenta,
				SaldoIniLoc = isnull((select SUM(SLinicial) from SaldosContables
								where Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and Smes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#"> and Ccuenta = c.Ccuenta),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				DebitoLoc = isnull((select sum(DLdebitos) from SaldosContables
								where Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> and Ccuenta = c.Ccuenta),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CreditoLoc = isnull((select sum(CLcreditos) from SaldosContables
								where Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> and Ccuenta = c.Ccuenta),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				null as SaldoIniOri, null as DebitoOri, null as CreditoOri, #rsMonLoc.Mcodigo#, X.PCDcatid, X.PCDvalor, X.PCDdescripcion,
				isnull(cl.PCCDclaid,0), SoloHijos = isnull(X.SoloHijos,0), Y.PCDcatidref, Y.PCDvalor, Y.PCDdescripcion,
				cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance,gcgm.ID_GrupoPadre
				from (
					select 	Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
						select Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
							select  cc.Cformato, cc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join CContables cc
								on cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas in (1,3)
								and cc.Cmovimiento = 'S'
							union all
							select  cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join (SELECT d.ID_Estr, cp.Ccuenta from CGEstrProgCtaD d
											inner join CContables cp
											on cp.Cformato like replace(d.FormatoP,'X','_')) epc
								on epc.ID_Estr = cge.ID_Estr
							inner join CContables cc
								on epc.Ccuenta = cc.Ccuenta
								and cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas = 2
								and cc.Cmovimiento = 'S'
						) incluye
						except
						select  cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
						from CGEstrProgCtaM cge
						inner join (SELECT d.ID_Estr, cp.Ccuenta from CGEstrProgCtaD d
											inner join CContables cp
											on cp.Cformato like replace(d.FormatoP,'X','_')) epc
							on epc.ID_Estr = cge.ID_Estr
						inner join CContables cc
							on epc.Ccuenta = cc.Ccuenta
							and cc.Cmayor = cge.CGEPCtaMayor
						where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and cge.CGEPInclCtas = 3
							and cc.Cmovimiento = 'S'
					) ctas

				) cge
				inner join CGEstrProg ep
					on cge.ID_Estr = ep.ID_Estr
				inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
					and c.Ccuenta = cge.Ccuenta
				left join  (
						select nm.Ccuenta, nm.PCEcatid, cc.PCCDclaid
						 from  PCDCatalogoCuenta nm
						 inner join PCDClasificacionCatalogo cc
							on cc.PCDcatid = nm.PCDcatid
						 inner join PCClasificacionD cd
							on cd.PCCEclaid = cc.PCCEclaid
							and cc.PCCDclaid = cd.PCCDclaid
						) cl
					on cge.Ccuenta = cl.Ccuenta
					and ep.PCEcatidClasificado = cl.PCEcatid
				left join SaldosContables sc on sc.Ccuenta = c.Ccuenta
				left join Monedas m on m.Mcodigo = sc.Mcodigo
				left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr
				left join CGGrupoPadreCtas gcgm on gcm.ID_GrupoPadre = gcgm.ID_GrupoPadre and gcm.ID_Estr = gcgm.ID_Estr
				left join (select distinct c.Cmayor, c.Cformato, c.Ccuenta, sc.Smes, sc.Speriodo, cc.PCDvalor, cc.PCDdescripcion,
							case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv,
		                            epvd.ID_EstrCtaVal, epvd.PCDcatid, epv.SoloHijos
			 			    from CGEstrProgCtaM cge
						    inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuenta nm on nm.Ccuenta = c.Ccuenta
							inner join SaldosContables sc on sc.Ccuenta = c.Ccuenta
							inner join CGDEstrProgVal epvd on epvd.PCDcatid = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
						   	and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
			 				inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatid
							<!---left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr--->
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.Cmovimiento = 'S'
							and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">) as X on X.Ccuenta = c.Ccuenta and X.Cformato = c.Cformato
				left join (select distinct c.Cmayor, c.Cformato, c.Ccuenta, sc.Smes, sc.Speriodo, cc.PCDvalor, cc.PCDdescripcion, epvd.PCDcatidref,
								case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv
							from CGEstrProgCtaM cge
						    inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuenta nm on nm.Ccuenta = c.Ccuenta
							inner join SaldosContables sc on sc.Ccuenta = c.Ccuenta
							inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
							and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
							<!---left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr--->
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.Cmovimiento = 'S'
							and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">) as Y on Y.Ccuenta = c.Ccuenta and Y.Cformato = c.Cformato
				<!---select gcm.ID_Grupo, cge.ID_Estr, ID_EstrCtaVal, c.Cmayor, c.Cformato, SUM(sc.SLinicial) as SaldoIniLoc, SUM(DLdebitos) as DebitoLoc, 																		                SUM(CLcreditocfs) as CreditoLoc, null, null, null, sc.Mcodigo,
				c.Cformato
				from dbo.SaldosContables sc
				inner join CContables c on sc.Ccuenta=c.Ccuenta and sc.Ecodigo=c.Ecodigo
				inner join Monedas m on m.Mcodigo = c.Mcodigo
				inner join CGEstrProgCtaM cge on c.Cmayor=cge.CGEPCtaMayor
				left join CGGrupoCtasMayor gcm on gcm.ID_Estr = cge.ID_Estr
				left join CGEstrProgVal epv on epv.ID_Estr = cge.ID_Estr--->
				where sc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
				and c.Cmovimiento = 'S'
				and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
				and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
				<!---group by gcm.ID_Grupo, cge.ID_Estr, c.Cmayor, c.Cformato, sc.Mcodigo, sc.Ecodigo, c.Ccuenta, 					                X.ID_EstrCtaVal--->
			</cfquery>
		<cfelse>
			<cfquery datasource="#GvarConexion#" name="rsSaldos">
				 insert into #SaldosEstr# (ID_Grupo, ID_EstrPro, ID_EstrCtaVal, Ecodigo, Cmayor, Cformato, Ccuenta, SLinicial, DLdebitos,
					CLcreditos, SOinicial, DOdebitos, COcreditos, Mcodigo, PCDcatid, PCDvalor, PCDdescripcion, ClasCatCon,SoloHijos,PCDcatidH,
					PCDvalorH, PCDdescripcionH, CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance,ID_GrupoPadre) 
				select distinct gcm.ID_Grupo, cge.ID_Estr, X.ID_EstrCtaVal, sc.Ecodigo, c.Cmayor, c.Cformato, c.Ccuenta, null as                SaldoIniLoc, null as DebitoLoc, null as CreditoLoc,
				SaldoIniOri = isnull((select SUM(SOinicial) from SaldosContables
								where Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and Smes =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#"> and Ccuenta = c.Ccuenta
								and Mcodigo =  sc.Mcodigo),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				DebitoOri = isnull((select sum(DOdebitos) from SaldosContables
								where Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> and Ccuenta = c.Ccuenta
								and Mcodigo = sc.Mcodigo),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				CreditoOri = isnull((select sum(COcreditos) from SaldosContables
								where Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
								and Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
								and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#"> and Ccuenta = c.Ccuenta
								and Mcodigo = sc.Mcodigo),0.00)<cfif Arguments.invertirSaldo>*case when isnull(X.SaldoInv,1) = -1 then -1 else isnull(Y.SaldoInv,1) end</cfif>,
				sc.Mcodigo, X.PCDcatid, X.PCDvalor, X.PCDdescripcion,isnull(cl.PCCDclaid,0), SoloHijos = isnull(X.SoloHijos,0), Y.PCDcatidref, Y.PCDvalor,
				Y.PCDdescripcion, cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance,gcgm.ID_GrupoPadre
				from (
					select 	Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
						select Cformato, Ccuenta, CGEPCtaMayor, CGEPInclCtas, ID_Grupo,
								CGEPctaTipo, CGEPctaGrupo, CGEPctaBalance, ID_Estr from (
							select  cc.Cformato, cc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join CContables cc
								on cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas in (1,3)
								and cc.Cmovimiento = 'S'
							union all
							select  cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
							from CGEstrProgCtaM cge
							inner join (SELECT d.ID_Estr, cp.Ccuenta from CGEstrProgCtaD d
											inner join CContables cp
											on cp.Cformato like replace(d.FormatoP,'X','_')) epc
								on epc.ID_Estr = cge.ID_Estr
							inner join CContables cc
								on epc.Ccuenta = cc.Ccuenta
								and cc.Cmayor = cge.CGEPCtaMayor
							where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
								and cge.CGEPInclCtas = 2
								and cc.Cmovimiento = 'S'
						) incluye
						except
						select  cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas, cge.ID_Grupo,
								cge.CGEPctaTipo, cge.CGEPctaGrupo, cge.CGEPctaBalance, cge.ID_Estr
						from CGEstrProgCtaM cge
						inner join (SELECT d.ID_Estr, cp.Ccuenta from CGEstrProgCtaD d
											inner join CContables cp
											on cp.Cformato like replace(d.FormatoP,'X','_')) epc
							on epc.ID_Estr = cge.ID_Estr
						inner join CContables cc
							on epc.Ccuenta = cc.Ccuenta
							and cc.Cmayor = cge.CGEPCtaMayor
						where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and cge.CGEPInclCtas = 3
							and cc.Cmovimiento = 'S'
					) ctas

				) cge
				inner join CGEstrProg ep
					on cge.ID_Estr = ep.ID_Estr
				inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
					and c.Ccuenta = cge.Ccuenta
				left join  (
						select nm.Ccuenta, nm.PCEcatid, cc.PCCDclaid
						 from  PCDCatalogoCuenta nm
						 inner join PCDClasificacionCatalogo cc
							on cc.PCDcatid = nm.PCDcatid
						 inner join PCClasificacionD cd
							on cd.PCCEclaid = cc.PCCEclaid
							and cc.PCCDclaid = cd.PCCDclaid
				) cl
					on cge.Ccuenta = cl.Ccuenta
					and ep.PCEcatidClasificado = cl.PCEcatid
				left join SaldosContables sc on sc.Ccuenta = c.Ccuenta
				left join Monedas m on m.Mcodigo = sc.Mcodigo
				left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr
				left join CGGrupoPadreCtas gcgm on gcm.ID_GrupoPadre = gcgm.ID_GrupoPadre and gcm.ID_Estr = gcgm.ID_Estr
				left join (select distinct c.Cmayor, c.Cformato, c.Ccuenta, sc.Smes, sc.Speriodo, cc.PCDvalor, cc.PCDdescripcion,
							case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv,
								epvd.ID_EstrCtaVal, epvd.PCDcatid, epv.SoloHijos
						   from CGEstrProgCtaM cge
						    inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuenta nm on nm.Ccuenta = c.Ccuenta
							inner join SaldosContables sc on sc.Ccuenta = c.Ccuenta
							inner join CGDEstrProgVal epvd on epvd.PCDcatid = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
							and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatid
							<!---left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr--->
							where sc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.Cmovimiento = 'S'
							and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
							and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mcodigo#">
							) as X on X.Ccuenta = c.Ccuenta and X.Cformato = c.Cformato
				left join (select distinct c.Cmayor, c.Cformato, c.Ccuenta, sc.Smes, sc.Speriodo, cc.PCDvalor, cc.PCDdescripcion,epvd.PCDcatidref,
								case when isnull(epvd.SaldoInv,0) = 0 then 1 else -1 end SaldoInv
						   from CGEstrProgCtaM cge
						    inner join CContables  c on cge.CGEPCtaMayor = c.Cmayor
							inner join PCDCatalogoCuenta nm on nm.Ccuenta = c.Ccuenta
							inner join SaldosContables sc on sc.Ccuenta = c.Ccuenta
							inner join CGDDetEProgVal epvd on epvd.PCDcatidref = nm.PCDcatid
							inner join CGEstrProgVal epv on epv.ID_EstrCtaVal = epvd.ID_EstrCtaVal
							and epv.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							inner join PCDCatalogo cc on cc.PCDcatid = epvd.PCDcatidref
							<!---left join CGGrupoCtasMayor gcm on gcm.ID_Grupo = cge.ID_Grupo and gcm.ID_Estr = cge.ID_Estr--->
							where cge.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
							and c.Cmovimiento = 'S'
							and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
							and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
							and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">) as Y on Y.Ccuenta = c.Ccuenta and 																				                            Y.Cformato = c.Cformato
				<!---select gcm.ID_Grupo, cge.ID_Estr, ID_EstrCtaVal, c.Cmayor, c.Cformato, null, null, null, SUM(sc.SOinicial) as SaldoIniOri, 				                SUM(DOdebitos) as DebitoOri, SUM(COcreditos) as CreditoOri, sc.Mcodigo,
				from dbo.SaldosContables sc
				inner join CContables c on sc.Ccuenta=c.Ccuenta and sc.Ecodigo=c.Ecodigo
				inner join CGEstrProgCtaM cge on c.Cmayor=cge.CGEPCtaMayor
				left join CGGrupoCtasMayor gcm on gcm.ID_Estr = cge.ID_Estr
				left join CGEstrProgVal epv on epv.ID_Estr = cge.ID_Estr--->
				where
				sc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
				and c.Cmovimiento = 'S'
				and sc.Speriodo between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.PerFin#">
				and sc.Smes between <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesInicio#">
				and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.MesFin#">
				and sc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Mcodigo#">
<!---				group by gcm.ID_Grupo, cge.ID_Estr, c.Cmayor, c.Cformato, sc.Mcodigo, sc.Ecodigo, c.Ccuenta, X.ID_EstrCtaVal--->
			</cfquery>
		</cfif>
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
       <!---  <cfquery datasource="#GvarConexion#" name="RScomprueba">
        	select right(ltrim(rtrim(Cformato)),9),sum(CPCpresupuestado)
			from #SaldosEstr#
			where CPCpresupuestado <>0
			group by right(ltrim(rtrim(Cformato)),9)
			order by right(ltrim(rtrim(Cformato)),9)
		</cfquery> --->
		<!---

		<!---Elimina las cuentas que se deben incluir o excluir por cuenta de mayor--->
		<cfquery name="rsCtasIncExcl" datasource="#GvarConexion#">
			select distinct cc.Cformato, epc.Ccuenta, cge.CGEPCtaMayor, cge.CGEPInclCtas
			from CGEstrProgCtaM cge
			inner join (select distinct ID_Estr, Ccuenta from CGEstrProgCtaD where Ccuenta is not null) epc on epc.ID_Estr = cge.ID_Estr
			inner join CContables cc on epc.Ccuenta = cc.Ccuenta and substring(Cformato,1,4) = cge.CGEPCtaMayor
			<!---left join CGGrupoCtasMayor gcm on gcm.ID_Estr = cge.ID_Estr
			left join CGEstrProgVal epv on epv.ID_Estr = cge.ID_Estr
			--->where
			cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
		</cfquery>

		<cfquery name="rsSaldos" datasource="#GvarConexion#">
			select top 1 * from #SaldosEstr#
		</cfquery>


		<cfif rsCtasIncExcl.recordcount GT 0>
			<cfloop query="rsCtasIncExcl">
				<cfif rsCtasIncExcl.CGEPInclCtas EQ 2>
					<cfquery datasource="#GvarConexion#">
						delete #SaldosEstr#
						where Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">
						and Ccuenta not in (select epc.Ccuenta
											from CGEstrProgCtaM cge
											inner join (select distinct ID_Estr, Ccuenta from CGEstrProgCtaD where Ccuenta is not null) epc on epc.ID_Estr = cge.ID_Estr
											inner join CContables cc on epc.Ccuenta = cc.Ccuenta and substring(Cformato,1,4) = cge.CGEPCtaMayor
											where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
											and cge.CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">)
					</cfquery>
				<cfelseif rsCtasIncExcl.CGEPInclCtas EQ 3>
					<cfquery datasource="#session.dsn#">
						delete #SaldosEstr#
						where Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">
						and Ccuenta in (select epc.Ccuenta
										from CGEstrProgCtaM cge
										inner join (select distinct ID_Estr, Ccuenta from CGEstrProgCtaD where Ccuenta is not null) epc on epc.ID_Estr = cge.ID_Estr
										inner join CContables cc on epc.Ccuenta = cc.Ccuenta and substring(Cformato,1,4) = cge.CGEPCtaMayor
										where cc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
										and cge.ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
										and cge.CGEPCtaMayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCtasIncExcl.CGEPCtaMayor#">)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>

		<cfquery name="ClasifiCatCon" datasource="#GvarConexion#">
			select PCEcatidClasificado as PCEcatid
			from CGEstrProg
			where ID_Estr =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
		</cfquery>

		<cfquery name="CtasMayorEstr" datasource="#GvarConexion#">
			select distinct Cmayor
			from #SaldosEstr#
		</cfquery>

		<cfif isdefined("ClasifiCatCon") and ClasifiCatCon.PCEcatid NEQ 0>
			<cfloop query="CtasMayorEstr">
		<!---	<cfquery name="ClasifiCatCon" datasource="#GvarConexion#">
				select distinct PCNid, PCNlongitud, PCNdep, PCNdescripcion, NM.PCEcatid, M.Cmayor
				from PCNivelMascara NM
				inner join CtasMayor M on NM.PCEMid = M.PCEMid
				where M.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#CtasMayorEstr.Cmayor#">
     		    order by Cmayor
			</cfquery>--->

				<cfquery datasource="#GvarConexion#">
			<!--- select distinct nm.PCDcatid, nm.PCEcatid, cd.PCCDvalor, PCCDclaid, cd.PCCDdescripcion, s.Cformato --->
			    	 update #SaldosEstr# set ClasCatCon = cc.PCCDclaid
					 from CGEstrProg ep
					 inner join #SaldosEstr# s on s.ID_EstrPro = ep.ID_Estr
					 inner join PCDCatalogoCuenta nm on nm.Ccuenta = s.Ccuenta
					 inner join PCDClasificacionCatalogo cc on cc.PCDcatid = nm.PCDcatid  ---and c.PCDcatid = nm.PCDcatid
					 inner join PCClasificacionD cd on cd.PCCEclaid = cc.PCCEclaid and cc.PCCDclaid = cd.PCCDclaid
					 where s.Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#CtasMayorEstr.Cmayor#">
					 and ep.ID_Estr = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.IDEstrPro#">
					 and ep.PCEcatidClasificado != 0
					 and nm.PCEcatid = <cfqueryparam cfsqltype="cf_sql_integer" value="#ClasifiCatCon.PCEcatid#">
				</cfquery>


			<!---<cfset Par1 = 5>
			<cfset Par2 = 0>
			<cfloop query="ClasifiCatCon">
				<cfif ClasifiCatCon.PCEcatid EQ ClasifiCatCon.PCEcatid>
				<cfset Par2 = Par2 + ClasifiCatCon.PCNlongitud>
					<cfquery name="rsValor" datasource="#GvarConexion#">
						select substring(Cformato,#Par1#,#Par2#)
						from #SaldosEstr#
						where Cmayor = <cfqueryparam cfsqltype="cf_sql_integer" value="#ClasifiCatCon.Cmayor#">
					</cfquery>
					<cfset Par2 = Par2 + 1>

				</cfif>
			</cfloop>--->
			<!---<cf_dumptofile select="select distinct nm.PCDcatid, nm.PCEcatid, cd.PCCDvalor, cd.PCCDdescripcion, s.Cformato from CGEstrProg ep
			 inner join #SaldosEstr# s on s.ID_EstrPro = ep.ID_Estr
			 inner join PCDCatalogoCuenta nm on nm.Ccuenta = s.Ccuenta
			 inner join PCDClasificacionCatalogo cc on cc.PCDcatid = nm.PCDcatid
			 inner join PCClasificacionD cd on cd.PCCEclaid = cc.PCCEclaid and cc.PCCDclaid = cd.PCCDclaid
			 where s.Cmayor in (5111,5122, 5115) and ep.ID_Estr = 1 and ep.PCEcatidClasificado != 0 and nm.PCEcatid = 62">--->
			</cfloop>
		</cfif>
 --->
<!--- <cfquery name="rs" datasource="#Gvarconexion#">
	select * from #SaldosEstr#
</cfquery>
<cf_dump var="#rs#"> --->
	<cfreturn SaldosEstr>
	</cffunction>

	<cffunction name="CG_EstructuraMovimientos" access="private" output="no">
	</cffunction>
</cfcomponent>

