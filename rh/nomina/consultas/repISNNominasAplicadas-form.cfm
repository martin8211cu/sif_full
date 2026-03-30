<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>

<cfif isdefined("url.Tcodigo") and len(trim(url.Tcodigo))>
	<cfset form.Tcodigo = url.Tcodigo>
</cfif>
<!--- Si la consulta es por grupo de oficinas --->
<cfif Tconsulta eq 2>
	<cfquery name="rsGrupoOficinas" datasource="#session.DSN#">
		select o.Ocodigo,o.Odescripcion from Oficinas o
		 inner join AnexoGOficinaDet od
		 on o.Ocodigo=od.Ocodigo
		 inner join AnexoGOficina ao
		 on od.GOid=ao.GOid
		 where ao.GOcodigo=#form.codGrupoOf# and o.Ecodigo=#Session.Ecodigo#
	</cfquery>
	<cfset  codOfs= ' '>
	<cfloop query="rsGrupoOficinas">
		<cfset  codOfs&='#Ocodigo#,' >
	</cfloop>
	<cfset codOfs=Mid(codOfs, 1, len(codOfs)-1)>
</cfif>

<!--- Si aplica Calculo especial --->
<cfif isDefined('TCalculoEspecial')>
	<cf_dbtemp name="tmpISNE" returnvariable="RepISNE" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
		<cf_dbtempcol name="Dias" type="numeric" mandatory="no" default="0">
		<cf_dbtempcol name="MontoSalario" type="money" mandatory="no"  default="0">
		<cf_dbtempcol name="MontoFalta" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="MontoVariable" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="MontoISNE" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="MontoISN" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="Ocodigo" type="numeric" mandatory="no" >
	</cf_dbtemp>


	<cfquery name="rsInsSalarios" datasource="#session.DSN#">
		insert into #RepISNE# (DEid,Ocodigo ,Dias, MontoSalario)
		select hp.DEid, hp.Ocodigo ,sum(hp.PEcantdias) as PEcantdias, sum(hp.PEmontores) as PEmontores
		from HPagosEmpleado hp
			inner join CalendarioPagos cp
				on hp.RCNid = cp.CPid
			inner join TiposNomina tn
				on cp.Tcodigo = tn.Tcodigo
		where  1 = 1
			<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			 <cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
				and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
			</cfif>
			<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and hp.Ocodigo in (#codOfs#) 
					<cfelse>
						and hp.Ocodigo = #codOf#
					</cfif>
			</cfif>
		and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
		and hp.PEtiporeg = 0
		group by hp.DEid,hp.Ocodigo
	</cfquery>

	<cfquery name="rsIncidencias" datasource="#session.DSN#">
		update #RepISNE# set MontoVariable = coalesce((select sum(hic.ICmontores)
		from 
			HIncidenciasCalculo hic
		inner join CIncidentes ci	
			on ci.CIid = hic.CIid
		inner join CalendarioPagos cp
			on hic.RCNid = cp.CPid
		inner join TiposNomina tn
			on cp.Tcodigo = tn.Tcodigo
		where  1=1
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
		   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
		<cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
		   and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
		   and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
		</cfif>
		  and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
		  and ci.CIafectaISN = 1
		  and hic.RCNid in
			  (	
				(
				select hp.RCNid
				from HPagosEmpleado hp
					inner join CalendarioPagos cp
						on hp.RCNid = cp.CPid
					inner join TiposNomina tn
						on cp.Tcodigo = tn.Tcodigo
				where  1 = 1
				<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
				<cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
					and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
					and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
				</cfif>
				<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and hp.Ocodigo in  (#codOfs#)
					<cfelse>
						and hp.Ocodigo = #codOf#
					</cfif>
				</cfif>
				and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
				and hp.PEtiporeg = 0
				and hp.DEid = #RepISNE#.DEid)
			)
		  and hic.DEid = #RepISNE#.DEid),0)
	</cfquery>

	<cfquery name="rsPercFin" datasource="#session.dsn#">
		insert into #RepISNE# (DEid,Ocodigo, Dias, MontoVariable)
		select dle.DEid,dle.Ocodigo, 0, sum(importe)
		from
			RHLiqIngresos ri
		inner join RHLiquidacionPersonal lp on lp.DEid=ri.DEid
		inner join DLaboralesEmpleado dle
			on dle.DEid = ri.DEid
			and ri.Ecodigo = dle.Ecodigo
			and ri.DLlinea = dle.DLlinea
		inner join CIncidentes ci
			on ri.CIid = ci.CIid
		where dle.DLfvigencia
		<cfif form.FechaDesde neq ''>
			between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">
		<cfelse>
			between (select top 1 CPdesde from CalendarioPagos where Tcodigo=#form.Tcodigo# and   CPperiodo=#form.Periodo# and CPmes=#form.Mes# order by CPid)
			and (select top 1 CPhasta from CalendarioPagos where Tcodigo=#form.Tcodigo# and   CPperiodo=#form.Periodo# and CPmes=#form.Mes# order by CPid desc)
		</cfif>
		<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and dle.Ocodigo in (#codOfs#)
					<cfelse>
						and dle.Ocodigo = #codOf#
					</cfif>
				</cfif>
		and ci.CIafectaISN = 1
		and lp.lp.RHLPestado=1
		group by dle.DEid,dle.Ocodigo
	</cfquery>
	<!--- Inicia calculo especial --->
	<cfquery name="rsRepISNET" datasource="#session.DSN#">
		select sum(MontoSalario) as TMontoSalario,  sum(MontoVariable) as TMontoVariable
        	from #RepISNE# a
				<cfif (codOf gt 0 OR (isDefined('codOfs') and codOfs neq '')) and FechaDesde eq "" and FechaHasta eq "">
					<cfif codOf gt 0 >
					where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) = #codOf#
					</cfif>
					<cfif isDefined('codOfs') and  codOfs neq ''>
						where (
							select top 1 lt.Ocodigo from LineaTiempo lt
							where lt.DEid = a.DEid and
							DATEPART(YYYY, lt.LThasta) >= #periodo# and (DATEPART(MM, lt.LThasta) >= #mes# or lt.LThasta = '6100-01-01 00:00:00.000')
							order by lt.LTdesde desc
						) in (#codOfs#)
					</cfif>
				</cfif>
	</cfquery>
	<cfset TMontoSalario = rsRepISNET.TMontoSalario neq '' ? rsRepISNET.TMontoSalario:0>
	<cfset TMontoVariable = rsRepISNET.TMontoVariable neq '' ? rsRepISNET.TMontoVariable:0>
	<cfset BaseGravableM = TMontoSalario+TMontoVariable>

	<cfquery name="rsTablaIpuestoR" datasource="#session.DSN#">
		select d.DIRinf,d.DIRsup,d.DIRmontofijo,d.DIRporcentaje from DImpuestoRenta d
			   inner join EImpuestoRenta ei on d.EIRid=ei.EIRid
		       inner join ImpuestoRenta i on ei.IRcodigo=i.IRcodigo
			   where i.IRcodigo='MXISN' and  #BaseGravableM#>= d.DIRinf and #BaseGravableM#<=d.DIRsup
	</cfquery>

	<cfif rsTablaIpuestoR.RecordCount eq 0>
		<cfthrow message="No se ha definido la Tabla de Impuesto de Renta MXISN">
	</cfif>

	<cfset LB_ImpuestoPorcE = ' '>
	<cfset LB_PorceISNE = ' '>
	<cfif rsTablaIpuestoR.RecordCount gt 0>
	
		<cfset TLInferior=rsTablaIpuestoR.DIRinf>
		<cfset TMontoFijo=rsTablaIpuestoR.DIRmontofijo>
		<cfset TPrcentaje=rsTablaIpuestoR.DIRporcentaje>
		<cfset BaseGravableMC = BaseGravableM-TLInferior>
		<cfset Impuesto = BaseGravableMC * (TPrcentaje/100)>
		<cfset ImporteIpmuesto = Impuesto+TMontoFijo>
		<cfset ImpuestoPorc = NumberFormat(ImporteIpmuesto/BaseGravableM ,'0.00')>
		<cfset LB_ImpuestoPorcE =(ImpuestoPorc*100)&' %'>
		<cfset LB_PorceISNE = form.PorceISN&' %'>

		<cfquery datasource="#session.DSN#">
			update #RepISNE# set MontoISNE = (MontoSalario + MontoVariable) * (#ImpuestoPorc#/100)
		</cfquery>
		
		<cfquery datasource="#session.DSN#">
			update #RepISNE# set MontoISN = MontoISNE * (#form.PorceISN#/100)
		</cfquery>
	</cfif>

<!--- Fin calculo especial --->
<cfelse>
	<cf_dbtemp name="tmpISN" returnvariable="RepISN" datasource="#session.DSN#">
		<cf_dbtempcol name="DEid" type="numeric" mandatory="no">
		<cf_dbtempcol name="Dias" type="numeric" mandatory="no" default="0">
		<cf_dbtempcol name="MontoSalario" type="money" mandatory="no"  default="0">
		<cf_dbtempcol name="MontoFalta" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="MontoVariable" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="MontoISN" type="money" mandatory="no" default="0">
		<cf_dbtempcol name="Ocodigo" type="numeric" mandatory="no" >
	</cf_dbtemp>

	<!---<cfset vs_tablaCalculo = 'HRCalculoNomina'>
	<cfset vs_tablaDeducciones = 'HDeduccionesCalculo'>--->
	<cfquery name="rsInsSalarios" datasource="#session.DSN#">
		insert into #RepISN# (DEid, Ocodigo,Dias, MontoSalario)
		select hp.DEid, hp.Ocodigo, sum(hp.PEcantdias) as PEcantdias, sum(hp.PEmontores) as PEmontores
		from HPagosEmpleado hp
			inner join CalendarioPagos cp
				on hp.RCNid = cp.CPid
			inner join TiposNomina tn
				on cp.Tcodigo = tn.Tcodigo
			<!--- ***********************************Este es mi c�digo******************************* --->
			<cfif codOf gt 0 and isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				<!--- inner join LineaTiempo lt
				on lt.LTid = hp.LTid
				and lt.DEid = hp.DEid --->
				<!--- inner join Oficinas o
				on o.Ocodigo = lt.Ocodigo --->
			</cfif>
			<!--- ***********************************Este es mi c�digo******************************* --->
		where  1 = 1
			<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
			 <cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
				and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
			</cfif>
			<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and hp.Ocodigo in (#codOfs#) 
					<cfelse>
						and hp.Ocodigo = #codOf#
					</cfif>
				</cfif>
		and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
		and hp.PEtiporeg = 0
		<!--- and hp.RHTid  in (select RHTid from RHTipoAccion where RHTcomportam not in (5, 13) and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">) --->
		group by hp.DEid, hp.Ocodigo
	</cfquery>
	
	<cfquery name="rsIncidencias" datasource="#session.DSN#">
		update #RepISN# set MontoVariable = coalesce(  (  isnull(( select sum(hic.ICmontores)
		from 
			HIncidenciasCalculo hic
		inner join CIncidentes ci	
			on ci.CIid = hic.CIid
		inner join CalendarioPagos cp
			on hic.RCNid = cp.CPid
		inner join TiposNomina tn
			on cp.Tcodigo = tn.Tcodigo
		INNER JOIN LineaTiempo lt ON hic.DEid = lt.DEid
		AND lt.Ecodigo = tn.Ecodigo
		AND lt.LTid =
		(SELECT max(lt2.LTid)
		FROM LineaTiempo lt2
		WHERE lt.DEid = lt2.DEid
			AND lt2.LTdesde < = cp.CPhasta
			AND lt2.LThasta > = cp.CPdesde)
		INNER JOIN RHPlazas p ON lt.RHPid = p.RHPid
		AND lt.Ecodigo = p.Ecodigo
		INNER JOIN CFuncional cf ON cf.CFid=coalesce(p.CFidconta, p.CFid)
		where  1=1
		AND cf.Ocodigo = #RepISN#.Ocodigo
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
		   and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		   and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
		<cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
		   and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
		   and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
		</cfif>
		  and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
		  and ci.CIafectaISN = 1
		  and hic.RCNid in
			  (	
				(
				select hp.RCNid
				from HSalarioEmpleado hp 
				
					inner join CalendarioPagos cp
						on hp.RCNid = cp.CPid
					inner join TiposNomina tn
						on cp.Tcodigo = tn.Tcodigo
				where  1 = 1
				<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
					and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
					and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
				<cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
					and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
					and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
					
				</cfif>
				<!---<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and hp.Ocodigo in  (#codOfs#)
					<cfelse>
						and hp.Ocodigo = #codOf#
					</cfif>
				</cfif> --->
				and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
				<!--- and hp.PEtiporeg = 0 --->
				and hp.DEid = #RepISN#.DEid
				<!---and hp.Ocodigo = #RepISN#.Ocodigo  --->
				)
			)
		  and hic.DEid = #RepISN#.DEid  ),0)<!---Termina el query original JARR---->
		  + isnull(
			  (select sum(hic.ICmontores)
				from 
					HIncidenciasCalculo hic
				inner join CIncidentes ci	
					on ci.CIid = hic.CIid
				inner join CFuncional cf
					on cf.CFid = hic.CFid
					<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and cf.Ocodigo in  (#codOfs#)
					<cfelse>
						and cf.Ocodigo = #codOf#
					</cfif>
				</cfif>
				inner join CalendarioPagos cp
					on hic.RCNid = cp.CPid
				inner join TiposNomina tn
					on cp.Tcodigo = tn.Tcodigo
				where  1=1
				<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
				and cp.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
				and cp.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
				<cfelseif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and (cp.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
				and  cp.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
				</cfif>
				and tn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and tn.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Form.Tcodigo#">
				and ci.CIafectaISN = 1
				and hic.DEid = #RepISN#.DEid
				and cf.Ocodigo = #RepISN#.Ocodigo
				and ci.CIcodigo in ('1GA0','01G0'))
		  ,0)
		 ),0) 
	</cfquery>

	<cfquery name="rsPercFin" datasource="#session.dsn#">
		insert into #RepISN# (DEid,Ocodigo, Dias, MontoVariable)
		select dle.DEid,dle.Ocodigo, 0, sum(importe)
		from
			RHLiqIngresos ri
		inner join RHLiquidacionPersonal lp on lp.DEid=ri.DEid
		inner join DLaboralesEmpleado dle
			on dle.DEid = ri.DEid
			and ri.Ecodigo = dle.Ecodigo
			and ri.DLlinea = dle.DLlinea
		inner join CIncidentes ci
			on ri.CIid = ci.CIid
		where dle.DLfvigencia
		<cfif form.FechaDesde neq ''>
			between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">
		<cfelse>
			between (select top 1 CPdesde from CalendarioPagos where Tcodigo=#form.Tcodigo# and   CPperiodo=#form.Periodo# and CPmes=#form.Mes# order by CPid)
			and (select top 1 CPhasta from CalendarioPagos where Tcodigo=#form.Tcodigo# and   CPperiodo=#form.Periodo# and CPmes=#form.Mes# order by CPid desc)
		</cfif>
		<cfif codOf gt 0 OR  Tconsulta eq 2>
					<cfif Tconsulta eq 2>
						and dle.Ocodigo in (#codOfs#)
					<cfelse>
						and dle.Ocodigo = #codOf#
					</cfif>
				</cfif>
		and ci.CIafectaISN = 1
		and lp.RHLPestado=1
		group by dle.DEid,dle.Ocodigo
	</cfquery>

	<cfquery name="rsInsFaltas" datasource="#session.DSN#">
		update  #RepISN# set MontoISN = (MontoSalario + MontoVariable) * (#form.PorceISN#/100)
	</cfquery>
</cfif>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinclude template="repISNNominasAplicadas-rep.cfm">