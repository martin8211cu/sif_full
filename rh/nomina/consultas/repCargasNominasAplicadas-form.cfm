<CF_NAVEGACION NAME="Periodo">
<CF_NAVEGACION NAME="Mes">
<CF_NAVEGACION NAME="DClinea">

<cfset cf = false>
<cfif len(trim(form.CFid))>
	<cfset cf = true>
	<cfquery datasource="#session.dsn#" name="rsCF">
		select CFpath, CFid
		from CFuncional
		where CFid = #form.CFid#
	</cfquery>

	<cfif isdefined("form.incluirdependencias")>
		<cfquery datasource="#session.dsn#" name="rsCF">
			select CFid
			from CFuncional
			where Ecodigo =#session.Ecodigo#
			and CFpath like '%#rsCF.CFpath#%'
		</cfquery>
	</cfif>
	<cfset listaCF=valuelist(rsCF.CFid)>
</cfif>


<cfset showNominas = false>
<cfif isdefined("form.DetallarNominas")>
	<cfset showNominas = true>
</cfif>


<!---- obtiene la oficina ----------------------->
<cfset arrayOfi = ListToArray(form.Oficina,',')>
<cfif arrayOfi[1] neq 'TD'>
	<cfquery name="rsOficina" datasource="#session.DSN#">
		select Ocodigo,Oficodigo,Odescripcion
		from Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.ecodigo#">	
		<cfswitch expression="#arrayOfi[1]#"> 
			<cfcase value="of">
				and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arrayOfi[2]#">
			</cfcase>
			<cfcase value="go">
				and Ocodigo in (select ct.Ocodigo
								from AnexoGOficinaDet ct 
								where ct.Ecodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
									and ct.GOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arrayOfi[2]#">
							   )
			</cfcase>
		 </cfswitch>
		order by Oficodigo
	</cfquery>
</cfif>	
<!---------------------------------------------->

<cfquery name="rsCargas" datasource="#session.DSN#">
	select 	c.DEid,	d.DEidentificacion,
            <cf_dbfunction name="concat" args="d.DEapellido1+' '+d.DEapellido2+'  '+d.DEnombre" delimiters="+"> as Nombre,
    		a.CPperiodo,
            a.CPmes,
			f.DCdescripcion,f.DCcodigo,
            <cfif showNominas>			
			b.RCdesde, b.RChasta,
			</cfif>
			<cfif cf>cfx.CFcodigo, cfx.CFdescripcion,</cfif>
			f.DClinea, 
			 sum(c.CCvaloremp) as MontoEmp,
			 sum(c.CCvalorpat) as MontoPat
	from CalendarioPagos a 
    	inner join HRCalculoNomina b 
        	on a.CPid = b.RCNid 
		inner join HCargasCalculo c 
        	on b.RCNid = c.RCNid        
		inner join DatosEmpleado d 
        	on c.DEid = d.DEid
		inner join DCargas f 
        	on c.DClinea = f.DClinea
        <cfif cf>
	        inner join (select distinct rct.RCNid, cfx.CFcodigo, cfx.CFdescripcion,rct.DEid
						from RCuentasTipo rct
							inner join CFuncional cfx
							    on cfx.CFid=rct.CFid
							where rct.tiporeg in (55,56, 50,51, 52)
							    and cfx.CFid in (#listaCF#)) cfx

	        on cfx.RCNid = b.RCNid
	        	and cfx.DEid = c.DEid
        </cfif>
	where  1=1
		<!--- 20150217 Las Centros Funcionales deben indicarse con respecto a las Oficinas donde se pagó la nomina, no sobre la ubicacion actual del empleado --->            
		<cfif cf>	
	        and d.DEid in (Select rct.DEid
                           from RCuentasTipo rct
                                inner join CFuncional cf
                                on cf.CFid=rct.CFid
                                and rct.tiporeg in (55,56, 50,51, 52)
                            Where  rct.RCNid= b.RCNid
               				and cf.CFid in (#listaCF#)	
                           )
		</cfif>	
		<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
			and a.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
			and a.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
       		<cfif isdefined("rsOficina") and len(trim(rsOficina.Ocodigo))>
				<!--- 20150217 Las Oficinas deben indicarse con respecto a las Oficinas donde se pagó la nomina, no sobre la ubicacion actual del empleado --->        
	        	and d.DEid in (Select rct.DEid
                           from RCuentasTipo rct
                                inner join CFuncional cf
                                    inner join Oficinas ofi
                                        on cf.Ocodigo=ofi.Ocodigo
                                        and cf.Ecodigo=ofi.Ecodigo
                                on cf.CFid=rct.CFid
                                and rct.tiporeg in (55,56, 50,51, 52)
                            Where  rct.RCNid= b.RCNid
                            and (
											<cfloop query="rsOficina">
												upper(ofi.Oficodigo) like '%#ucase(rsOficina.Oficodigo)#%'
												<cfif rsOficina.currentrow neq rsOficina.recordcount> or </cfif>
											</cfloop>
										 )	
                             )
        	</cfif>
		</cfif>	
		<cfif isdefined("form.FechaDesde")	and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>		
			and (a.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> 
			and  a.CPhasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">)
			<cfif isdefined("rsOficina") and len(trim(rsOficina.Ocodigo))>
                and d.DEid in (Select lt.DEid
                               from LineaTiempo lt
                                    inner join RHPlazas rh
                                        inner join CFuncional cf
                                            inner join Oficinas ofi
                                                on cf.Ocodigo=ofi.Ocodigo
                                                and cf.Ecodigo=ofi.Ecodigo
                                        on cf.CFid=rh.CFid
                                    on rh.RHPid=lt.RHPid
                                Where lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> 
								and lt.LThasta <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">
								 and (
										<cfloop query="rsOficina">
											upper(ofi.Oficodigo) like '%#ucase(rsOficina.Oficodigo)#%'
											<cfif rsOficina.currentrow neq rsOficina.recordcount> or </cfif>
										</cfloop>
									 )	
                                )
            </cfif>
		</cfif>	
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.DClinealist") and len(trim(form.DClinealist))>
	        and f.DClinea  in (#form.DClinealist#)
        </cfif>
		group by 				
            	c.DEid,d.DEidentificacion,
       			<cf_dbfunction name="concat" args="d.DEapellido1+' '+d.DEapellido2+'  '+d.DEnombre" delimiters="+">,
				a.CPperiodo,a.CPmes,
				f.DCdescripcion,f.DCcodigo,
				<cfif showNominas>			
				b.RCdesde, b.RChasta, 
				</cfif>
				<cfif cf>cfx.CFcodigo, cfx.CFdescripcion,</cfif> 
				f.DClinea
		 order by  <cfif isdefined("form.ChkEmp")>
			       <cfif cf>cfx.CFcodigo, cfx.CFdescripcion,</cfif> <cf_dbfunction name="concat" args="d.DEapellido1+' '+d.DEapellido2+'  '+d.DEnombre" delimiters="+">
			       		<cfif showNominas>
			       			, b.RCdesde
						</cfif>			       			
                   <cfelse>
                   	<cfif cf>cfx.CFcodigo, cfx.CFdescripcion,</cfif> f.DClinea, c.DEid 
                   	<cfif showNominas>
                   		, b.RCdesde
                   	</cfif>
                   </cfif>
</cfquery>
	


<cfif isdefined("form.Periodo")	and len(trim(form.Periodo)) and isdefined("form.Mes") and len(trim(form.Mes))>
	<cfquery name="rsFechas" datasource="#session.DSN#">
		select min(CPdesde)as fdesde, max(CPhasta)as fhasta
		from CalendarioPagos a
		where CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		and CPmes =	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfset fdesde = rsFechas.fdesde>
	<cfset fhasta = rsFechas.fhasta>
<cfelse>
	<cfset fdesde = form.FechaDesde>
	<cfset fhasta = form.FechaHasta>
</cfif>

<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeCargasNominasAplicadas" Default="Reporte de Cargas nóminas aplicadas" returnvariable="LB_ReporteDeCargasNominasAplicadas"/>

<cfinclude template="repCargasNominasAplicadas-rep.cfm">