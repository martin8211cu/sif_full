<cfsetting requesttimeout="14400">
<!--- Tab1 --->
<cfif isdefined("Form.Alta")>
    <cfset Periodo = Mid(Form.FechaDesde,7,4)>
    <cfquery name="rsSelectId" datasource="#Session.DSN#">
    	(SELECT coalesce((SELECT MAX(RHAAid)+1 FROM RHAjusteAnual),1) as IdAjusteAnual)
    </cfquery>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert into RHAjusteAnual (
        RHAAid,
        RHAAcodigo,
        RHAAdescrip,
        RHAAfecharige,
        RHAAfechavence,
        RHAAPeriodo,
        Ecodigo,
        RHAAEstatus,
        EIRid)
		values (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSelectId.IdAjusteAnual#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAcodigo#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAdescrip#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaDesde)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaHasta)#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy',Form.FechaDesde)#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
        0,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IRcodigo#">)
	</cfquery>
    <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#rsSelectId.IdAjusteAnual#&tab=2" addtoken="no">
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#session.DSN#">
    	update RHAjusteAnual
        set
        	RHAAcodigo = 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAcodigo#">,
        	RHAAdescrip =  	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAdescrip#">,
        	RHAAfecharige =  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaDesde)#">,
        	RHAAfechavence = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaHasta)#">,
        	RHAAPeriodo =    <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('yyyy',Form.FechaDesde)#">,
        	Ecodigo =        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
       		RHAAEstatus = 0,
            EIRid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IRcodigo#">
        where RHAAid  = 	 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
    </cfquery>
     <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=2" addtoken="no">
<cfelseif isdefined("form.Baja")>
	<cftransaction action="begin">
    	<cfquery datasource="#session.DSN#" name = "rsDeleteRHAjusteNomina">
            delete from RHAjusteAnualNomina
            where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>
        <cfquery datasource="#session.DSN#" name = "rsDeleteRHAjusteNoConceptos">
            delete from RHAjusteAnualAcumulado
            where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>
    	<cfquery datasource="#session.DSN#" name = "rsDeleteRHAjusteNoConceptos">
            delete from RHAjusteAnualNoConceptos
            where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>
        <cfquery datasource="#session.DSN#" name = "rsDeleteDRHAjuste">
            delete from DRHAjusteAnual
            where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>
        <cfquery datasource="#session.DSN#" name = "rsDeleteRHAjuste">
            delete from RHAjusteAnual
            where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>
    </cftransaction>
    <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm" addtoken="no">
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm" addtoken="no">
</cfif>

<!---Tab2--->
<cfif isdefined("Form.BTN_Alta")>
<!---	<cf_dump var = "#form#">--->
	<cfif isdefined ("Form.Concepto") and Form.Concepto EQ -1>
    	<cf_throw message="Elige Concepto">
	<cfelseif isdefined ("Form.Concepto") and Form.Concepto NEQ "">
        <cfquery name="rsSelectNoConceptos" datasource="#session.DSN#">
         	select 1 as validacion
			from RHAjusteAnualNoConceptos rhaanc, CIncidentes ci
			where rhaanc.CIid = ci.CIid
            	and ci.Ecodigo = #session.Ecodigo#
	  			and rhaanc.CIid = #Form.Concepto#
                and RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
        </cfquery>

        <cfif rsSelectNoConceptos.validacion NEQ 1>
    		<cfquery name="rsInsertNoConceptos" datasource="#session.DSN#">
    			insert into RHAjusteAnualNoConceptos (RHAAid,CIid)
        			values(<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">,
        	   			   <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Concepto#">)
        	</cfquery>
        <cfelse>
        	<cf_throw message="Concepto Repetido">
        </cfif>
    </cfif>

	<!---<cfquery name="rsSelectSalarioEmpleado" datasource="#session.DSN#">
    	select *
        from RHAjusteAnualAcumulado rhaas inner join RHAjusteAnual rhaa on  rhaas.RHAAid = rhaa.RHAAid
        where rhaas.RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
			and rhaa.Ecodigo= #session.Ecodigo#
    </cfquery>

    <cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    	select RHAAfecharige,RHAAfechavence
        from RHAjusteAnual
        where RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
	          and Ecodigo = #session.Ecodigo#
    </cfquery>

    <cfset FechaDesde = #DateFormat(rsSelectFechas.RHAAfecharige,'yyyy-MM-dd')#>
    <cfset FechaHasta = #DateFormat(rsSelectFechas.RHAAfechavence,'yyyy-MM-dd')#>

    <cfif isdefined ("rsSelectSalarioEmpleado") and rsSelectSalarioEmpleado.RecordCount EQ 0>
	<cf_dbtemp name = "RHAjusteAnualAcumulado" datasource = "#session.DSN#" returnvariable = "RHAjusteAnualAcumulado">
    		<cf_dbtempcol name="RHAAid"						type="varchar(50)"		mandatory="no">
            <cf_dbtempcol name="DEid" 						type="numeric"  		mandatory="no">
            <cf_dbtempcol name="RHAAAcumuladoSalario" 		type="money" 			mandatory="no">
			<cf_dbtempcol name="Tcodigo" 					type="char(10)"  		mandatory="no">
    </cf_dbtemp>

    <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #RHAjusteAnualAcumulado# (RHAAid,DEid,RHAAAcumuladoSalario<!---,Tcodigo--->)
        	select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,hse.DEid,sum(hse.SEsalariobruto)<!---, hrc.Tcodigo--->
			from HSalarioEmpleado hse
	 			inner join HRCalculoNomina hrc on hse.RCNid = hrc.RCNid
    		where Ecodigo = #session.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
			group by hse.DEid,hrc.Tcodigo
				union
			select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,se.DEid,sum(se.SEsalariobruto)<!---,rc.Tcodigo--->
			from SalarioEmpleado se
	 			inner join RCalculoNomina rc on se.RCNid = rc.RCNid
			where Ecodigo = #session.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
			group by se.DEid
    </cfquery>

    <cfquery name="rsSelectAjusteAnualSalario" datasource="#session.DSN#">
    	select DEid from #RHAjusteAnualAcumulado#
    </cfquery>

    <cfif isdefined("rsSelectAjusteAnualSalario") and rsSelectAjusteAnualSalario.RecordCount GT 0>
    	<cfloop query="rsSelectAjusteAnualSalario">
    		<cfquery name="rsUpdateTcodigo" datasource="#session.DSN#">
    			update #RHAjusteAnualAcumulado#
        		set Tcodigo = (select top 1 Tcodigo
					   from DLaboralesEmpleado
                       where DEid = #rsSelectAjusteAnualSalario.DEid#
	                   		and Ecodigo = #session.Ecodigo#
					   order by DLfechaaplic desc)
       			where DEid = #rsSelectAjusteAnualSalario.DEid#
    		</cfquery>
   		</cfloop>
    </cfif>

    <cfquery name="rsInsertSalario" datasource="#session.DSN#">
    	insert into RHAjusteAnualAcumulado (RHAAid,DEid,RHAAAcumuladoSalario,Tcodigo)
        select RHAAid,DEid,sum(RHAAAcumuladoSalario) as Salario, Tcodigo
        from #RHAjusteAnualAcumulado#
        group by RHAAid,DEid,Tcodigo
    </cfquery>

    </cfif>--->
  <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=2" addtoken="no">

<cfelseif isdefined("Form.BTN_Continuar")>

	<cf_dbtemp name = "RHAjusteAnualAcumulado" datasource = "#session.DSN#" returnvariable = "RHAjusteAnualAcumulado">
    	<cf_dbtempcol name="RHAAid"					type="varchar(50)"		mandatory="no">
        <cf_dbtempcol name="DEid"					type="int"				mandatory="no">
		<cf_dbtempcol name="RHAAAcumuladoSalario" 	type="money"			mandatory="no">
        <cf_dbtempcol name="Tcodigo" 				type="char(10)"  		mandatory="no">
    </cf_dbtemp>

    <cf_dbtemp name = "RHAjusteAnualNoConceptos" datasource = "#session.DSN#" returnvariable = "RHAjusteAnualNoConceptos">
    	<cf_dbtempcol name="RHAAid"				type="varchar(50)"		mandatory="no">
        <cf_dbtempcol name="CIid"				type="numeric(18,0)"		mandatory="no">
		<!---<cf_dbtempcol name="RHAANCdescripcion"	type="varchar(50)"		mandatory="no">--->
    </cf_dbtemp>

    <cf_dbtemp name = "DRHAjusteAnual" datasource = "#session.DSN#" returnvariable = "DRHAjusteAnual">
    	<cf_dbtempcol name="RHAAid"				type="varchar(50)"		mandatory="no">
        <cf_dbtempcol name="DEid"				type="int"				mandatory="no">
		<cf_dbtempcol name="DRHAAAcumulado"		type="money"			mandatory="no">
        <cf_dbtempcol name="CIid"		        type="numeric(18,0)"	mandatory="no">
    </cf_dbtemp>

	<cfquery name="rsInsertNoConceptos" datasource="#session.DSN#">
    	insert into #RHAjusteAnualNoConceptos# (RHAAid,CIid)
    	select rhaanc.RHAAid,rhaanc.CIid
		from RHAjusteAnualNoConceptos rhaanc, CIncidentes ci
		where rhaanc.CIid = ci.CIid
        	and ci.Ecodigo = #session.Ecodigo#
	  		and RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
   	</cfquery>

    <cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    	select RHAAfecharige,RHAAfechavence
        from RHAjusteAnual
        where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	          and Ecodigo = #session.Ecodigo#
    </cfquery>

    <cfset FechaDesde = #DateFormat(rsSelectFechas.RHAAfecharige,'yyyy-MM-dd')#>
    <cfset FechaHasta = #DateFormat(rsSelectFechas.RHAAfechavence,'yyyy-MM-dd')#>

<!---	<cfquery name="rsInsertSalarioEmpleado" datasource="#session.DSN#">  Lo comente
    	insert into #RHAjusteAnualAcumulado# (RHAAid,DEid,RHAAAcumuladoSalario<!---,Tcodigo--->)
    	select rhaaa.RHAAid,DEid,RHAAAcumuladoSalario<!---,Tcodigo--->
        from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid = rhaa.RHAAid
        where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
			and rhaa.Ecodigo= #session.Ecodigo#
    </cfquery> --->

    <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #RHAjusteAnualAcumulado# (RHAAid,DEid,RHAAAcumuladoSalario<!---,Tcodigo--->)
        	select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,hse.DEid,sum(hse.SEsalariobruto)<!---, hrc.Tcodigo--->
			from HSalarioEmpleado hse
	 			inner join HRCalculoNomina hrc on hse.RCNid = hrc.RCNid
    		where Ecodigo = #session.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
			group by hse.DEid
	</cfquery>
    <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #RHAjusteAnualAcumulado# (RHAAid,DEid,RHAAAcumuladoSalario<!---,Tcodigo--->)
			select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,se.DEid,sum(se.SEsalariobruto)<!---,rc.Tcodigo--->
			from SalarioEmpleado se
	 			inner join RCalculoNomina rc on se.RCNid = rc.RCNid
			where Ecodigo = #session.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
			group by se.DEid
    </cfquery>

    <cfquery name="rsSelectAjusteAnualSalario" datasource="#session.DSN#">
    	select DEid from #RHAjusteAnualAcumulado#
        group by DEid
    </cfquery>

   <!--- <cf_dump var ="#rsSelectAjusteAnualSalario#">--->
    <cfquery name = "rsSelectConcepto" datasource ="#session.DSN#">
    	select RHAAid,CIid
		from #RHAjusteAnualNoConceptos#
	</cfquery>

    <cfif isdefined("rsSelectAjusteAnualSalario") and rsSelectAjusteAnualSalario.RecordCount GT 0>
    	<cfloop query="rsSelectAjusteAnualSalario">
    		<cfquery name="rsUpdateTcodigo" datasource="#session.DSN#">
    			update #RHAjusteAnualAcumulado#
        		set Tcodigo = (select top 1 Tcodigo
					   from DLaboralesEmpleado
                       where DEid = #rsSelectAjusteAnualSalario.DEid#
	                   		and Ecodigo = #session.Ecodigo#
					   order by DLfechaaplic desc)
       			where DEid = #rsSelectAjusteAnualSalario.DEid#
    		</cfquery>
   		</cfloop>
    </cfif>

            <cfquery name="rsEspecie" datasource="#session.DSN#">
            	select CIid from ComponentesSalariales
				where Ecodigo = #session.Ecodigo#
					and CSusatabla in (0,2)
					and CSsalarioEspecie = 1
            </cfquery>

            <!---<cfset conceptos = #ValueList(rsEspecie.CIid)#>--->
            <cfif isdefined("rsEspecie") and rsEspecie.RecordCount NEQ 0 and isdefined("rsSelectConcepto") and rsSelectConcepto.RecordCount NEQ 0>
            	<cfset conceptos = #ValueList(rsEspecie.CIid)# & ',' & #ValueList(rsSelectConcepto.CIid)#>
            <cfelse>
            	<cfset conceptos = #ValueList(rsSelectConcepto.CIid)#>
            </cfif>
            <!---<cfset conceptos = Replace(conceptos,',',"','","all")>--->
            <!---<cfloop query = "rsSelectAjusteAnualSalario">--->

    		<cfquery name="rsInsertConceptos" datasource="#session.DSN#">
    			insert into #DRHAjusteAnual# (RHAAid,DEid,DRHAAAcumulado,CIid)
                select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,a.DEid, SUM(coalesce(round(a.RHLIgrabado,2),0)), a.CIid
				from RHLiqIngresos a
					<!---inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid--->
                    inner join RHLiquidacionPersonal b
						on  a.Ecodigo = b.Ecodigo
							and a.DEid = b.DEid
							and a.DLlinea = b.DLlinea
					inner join CIncidentes c
					on a.CIid = c.CIid and a.Ecodigo = c.Ecodigo
				where <!---a.DEid = 327--->
		  			a.Ecodigo = #session.Ecodigo#
				<cfif conceptos NEQ ''>
					and a.CIid not in (#PreserveSingleQuotes(conceptos)#)
  				 </cfif>
					and a.fechaalta between dateadd(day,-1,'#FechaDesde#') and dateadd(day,1,'#FechaHasta#')
				group by a.DEid, a.CIid
                <!---select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">, DEid, sum (importe),ci.CIid
                from RHLiqIngresos rhl
					inner join CIncidentes ci on rhl.CIid = ci.CIid
				where <!---DEid  = 364
					and---> rhl.Ecodigo = #session.Ecodigo#
                    <cfif conceptos NEQ ''>
					and rhl.CIid not in (#PreserveSingleQuotes(conceptos)#)
                    </cfif>
					and fechaalta between '#FechaDesde#' and '#FechaDesde#'
				group by DEid,rhl.CIid,ci.CIid--->
    		</cfquery>

            <cfquery name="rsInsertConceptos" datasource="#session.DSN#">
    			insert into #DRHAjusteAnual# (RHAAid,DEid,DRHAAAcumulado,CIid)
                select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">,a.DEid, SUM(coalesce(round(a.RHLIexento,2),0)), a.CIid
				from RHLiqIngresos a
					<!---inner join DDConceptosEmpleado b
						on a.DLlinea = b.DLlinea and a.CIid = b.CIid--->
                    inner join RHLiquidacionPersonal b
						on  a.Ecodigo = b.Ecodigo
							and a.DEid = b.DEid
							and a.DLlinea = b.DLlinea
					inner join CIncidentes c
					on a.CIid = c.CIid and a.Ecodigo = c.Ecodigo
				where <!---a.DEid = 327--->
		  			a.Ecodigo = #session.Ecodigo#
				<cfif conceptos NEQ ''>
					and a.CIid not in (#PreserveSingleQuotes(conceptos)#)
  				 </cfif>
					and a.fechaalta between dateadd(day,-1,'#FechaDesde#') and dateadd(day,1,'#FechaHasta#')
				group by a.DEid, a.CIid
    		</cfquery>

           <!--- <cfquery name="select" datasource="#session.DSN#">
            	select * from  #DRHAjusteAnual#
            </cfquery>

            <cf_dump var = "#select#">--->

            <cfquery name="rsInsertConceptos" datasource="#session.DSN#">
    			insert into #DRHAjusteAnual# (RHAAid,DEid,DRHAAAcumulado,CIid)
       			select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">, hi.DEid,sum(hi.ICmontores), ci.CIid
				from HIncidenciasCalculo hi
	 				inner join CIncidentes ci on hi.CIid = ci.CIid
                    and ci.CItimbrar=0
                    inner join HRCalculoNomina hrc on hrc.RCNid = hi.RCNid and ci.Ecodigo = hrc.Ecodigo
   				where hrc.RCdesde >= '#FechaDesde#'
	  				  and hrc.RChasta <= '#FechaHasta#'
                	<!---cp.CPfpago between '#FechaDesde#' and '#FechaHasta#' --->
        		   	<!---and hi.DEid = 342--->
                    <cfif conceptos NEQ ''>
                    and hi.CIid not in (#PreserveSingleQuotes(conceptos)#)
                    </cfif>
                   	<!---and hi.ICmontores > 0--->
                    and ci.Ecodigo = #session.Ecodigo#
       			   		group by hi.DEid,ci.CIid
             </cfquery>

             <cfquery name="rsInsertConceptos" datasource="#session.DSN#">
    			insert into #DRHAjusteAnual# (RHAAid,DEid,DRHAAAcumulado,CIid)
                select <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">, hi.DEid,sum(abs(hi.ICmontores)), ci.CIid
				from IncidenciasCalculo hi
	 				inner join CIncidentes ci on hi.CIid = ci.CIid
                    and ci.CItimbrar=0
                    inner join RCalculoNomina rc on rc.RCNid = hi.RCNid and ci.Ecodigo = rc.Ecodigo
   				where rc.RCdesde >= '#FechaDesde#'
	  				  and rc.RChasta <= '#FechaHasta#'
					<!---cp.CPfpago between '#FechaDesde#' and '#FechaHasta#' --->
        		   <!---	and hi.DEid = #rsSelectAjusteAnualSalario.DEid#--->
                   	<cfif conceptos NEQ ''>
                    and hi.CIid not in (#PreserveSingleQuotes(conceptos)#)
                    </cfif>
                    <!---and hi.ICmontores > 0--->
                    and ci.Ecodigo = #session.Ecodigo#
       			   		group by hi.DEid,ci.CIid
            </cfquery>

            <cfloop query="rsSelectAjusteAnualSalario"> <!---Redondeo de Vale de Despensa--->
        		<cfinvoke component="rh.Componentes.AjusteAValesDespensa" method="AjusteAValesDespensa">
            		<cfinvokeargument name="DEid" value="#rsSelectAjusteAnualSalario.DEid#">
                    <cfinvokeargument name="RHAAid" value="#Form.RHAAid#">
                    <cfinvokeargument name="FechaDesde" value="#FechaDesde#">
                    <cfinvokeargument name="FechaHasta" value="#FechaHasta#">
            	</cfinvoke>
            </cfloop>

    		<cfquery name="rsSelectFiniquitos" datasource="#session.DSN#">
       			insert into DRHAjusteAnual (RHAAid,DEid,DRHAAAcumulado,CIid)
       			select RHAAid,DEid,sum(DRHAAAcumulado),CIid from #DRHAjusteAnual#
                <!---where ---><!---CIid = 100
                and---> <!---DEid = 327--->
                group by RHAAid,DEid,CIid
    		</cfquery>
            <!---<cf_dump var = "#rsSelectFiniquitos#">--->
        <!---</cfif> --->
<!---        <cfquery name="rsISR" datasource="#session.DSN#">
         	<!---insert into DRHAjusteAnual (RHAAid,DEid,DRHAAAcumulado,CIid)--->
        	select RHAAid,DEid,DRHAAAcumulado,CIid from #DRHAjusteAnual#
           <!--- group by RHAAid,DEid,CIid--->
        </cfquery>
        <cf_dump var = "#rsISR#">--->

    <cfquery name="rsInsertSalario" datasource="#session.DSN#">
    	insert into RHAjusteAnualAcumulado (RHAAid,DEid,RHAAAcumuladoSalario,Tcodigo)
        select RHAAid,DEid,SUM(CAST((RHAAAcumuladoSalario) AS MONEY))   as Salario, Tcodigo
        from #RHAjusteAnualAcumulado#
        group by RHAAid,DEid,Tcodigo
    </cfquery>

        

    <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=3" addtoken="no">

<cfelseif isdefined("Form.hdAccion") and Form.hdAccion EQ "BAJA">
<!---<cf_dump var="#form#">--->

	<cfif isdefined ("Form.hdCodigo") and Form.hdCodigo NEQ "">
		<cfquery name="rsSelectNoConceptos" datasource="#session.DSN#">
    		select 1 as validacion
			from RHAjusteAnualNoConceptos rhaanc, CIncidentes ci
			where rhaanc.CIid = ci.CIid
             	and ci.Ecodigo = #session.Ecodigo#
	  			and rhaanc.CIid = #Form.hdCodigo#
        </cfquery>

     	<cfif rsSelectNoConceptos.validacion EQ 1>
			<cfquery name="rsDeleteNoConceptos" datasource="#session.DSN#">
   				delete from RHAjusteAnualNoConceptos
				where CIid = #Form.hdCodigo#
	  				and RHAAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAAid#">
    		</cfquery>
        </cfif>
     </cfif>
	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=2">
</cfif>

<!---Tab 3 --->
<!---<cf_dump var= "#form#">--->
<cfif isdefined("Form.BTN_GenerarE")>

            <cfquery name="rsSelectEmpleadoAcumulado" datasource="#session.DSN#">
    			select *
        		from RHAjusteAnualAcumulado rhaas inner join RHAjusteAnual rhaa on rhaas.RHAAid = rhaa.RHAAid
        		where rhaas.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
					and rhaa.Ecodigo= #session.Ecodigo#
    		</cfquery>

           <!--- <cfquery name="rsSelectEmpleadoAcumulado" datasource="#session.DSN#">
            	select COUNT(*) as empleado
				from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
				where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
					and rhaa.Ecodigo = #session.Ecodigo#
            </cfquery>--->

            <!---<cfthrow message="#rsSelectEmpleadoAcumulado.RecordCount#">--->
            <cfif isdefined("rsSelectEmpleadoAcumulado") and rsSelectEmpleadoAcumulado.RecordCount NEQ 0>
            <cfloop query="rsSelectEmpleadoAcumulado">
				<cfquery name="rsInsertTotalAcumulado" datasource="#session.DSN#">
					<!---insert into RHAjusteAnualAcumulado(RHAAid,DEid,RHAAAcumulado)--->
					update RHAjusteAnualAcumulado set RHAAAcumulado =
					(select <!---rhaa.RHAAid,rhaas.DEid, --->(rhaas.RHAAAcumuladoSalario + SUM(drhaa.DRHAAAcumulado))as AcumuladoTotal
					from RHAjusteAnualAcumulado rhaas
						inner join DRHAjusteAnual drhaa on drhaa.DEid = rhaas.DEid and drhaa.RHAAid = rhaas.RHAAid
						inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaas.RHAAid
					where rhaas.DEid = #rsSelectEmpleadoAcumulado.DEid# <!---in (#ValueList(rsSelectSalarioEmpleado.DEid)#) --->
						and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
						and rhaa.Ecodigo = #session.Ecodigo#
					group by rhaa.RHAAid,rhaas.DEid,rhaas.RHAAAcumuladoSalario)
				</cfquery>
            </cfloop>
            </cfif>

            <cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    		select RHAAfecharige,RHAAfechavence
        	from RHAjusteAnual
        	where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	          and Ecodigo = #session.Ecodigo#
       		</cfquery>

			<cf_dbtemp name="EmpleadosFuera" datasource = "#session.DSN#" returnvariable = "EmpleadosFuera">
            	<cf_dbtempcol name = "DEid" 	type= "int">
            	<cf_dbtempcol name = "FechaAB"  type = "datetime" mandatory="no">
            </cf_dbtemp>

            <cfif isdefined ("chkAlta") and chkAlta EQ 'on'>

            <cf_dbtemp name="EmpleadosAlta" datasource = "#session.DSN#" returnvariable = "EmpleadosAlta">
            	<cf_dbtempcol name = "DEid" 		type= "int" 		mandatory="no">
                <cf_dbtempcol name = "FechaAlta"  	type = "datetime" 	mandatory="no">
            </cf_dbtemp>

            <cfquery name="InsertEmpleadosAlta" datasource="#session.DSN#">
            	insert into #EmpleadosAlta# (DEid,FechaAlta)
				select d.DEid, min(DLfvigencia) as FechaAlta
				from DLaboralesEmpleado d
    			inner join  DatosEmpleado a on d.DEid  = a.DEid and d.Ecodigo=a.Ecodigo
    			inner join RHTipoAccion r on r.RHTid = d.RHTid
				where r.RHTcomportam = 1
	  				and d.Ecodigo = #session.Ecodigo#
				group by d.DEid
			</cfquery>

			<cfquery name="rsEmpleadosAlta" datasource="#session.DSN#">
             	insert into #EmpleadosFuera#(DEid,FechaAB)
					select DEid, FechaAlta <!----- Obtiene la fecha de Alta--->
					from #EmpleadosAlta#
					where  FechaAlta > <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#"><!---'#rsSelectFechas.RHAAfecharige#'--->
			</cfquery>

            <!---<cf_dump var = "#rsEmpleadosAlta#">--->
            <cfquery name = "rsEmpleadoAB" datasource="#session.DSN#">
            	select DEid, FechaAlta as fechaAlta
                from #EmpleadosAlta#
            </cfquery>

            <cfloop query="rsEmpleadoAB">
            <cfquery name = "rsUpdMesInicio" datasource="#session.DSN#">
            	update RHAjusteAnualAcumulado
                set <cfif #rsEmpleadoAB.fechaAlta# LTE #rsSelectFechas.RHAAfecharige#>
                		RHAAAMesInicio = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(DateFormat(rsSelectFechas.RHAAfecharige,'yyyy-MM-dd'))#">
                	<cfelse>
						RHAAAMesInicio = #Month(DateFormat(rsEmpleadoAB.fechaAlta,'yyyy-MM-dd'))#
                    </cfif>
                where DEid = #rsEmpleadoAB.DEid#
                	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>
            </cfloop>
            </cfif>


            <cfif isdefined ("chkBaja") and chkBaja EQ 'on'>

            <cf_dbtemp name="EmpleadosBA" datasource = "#session.DSN#" returnvariable = "EmpleadosBA">
            	<cf_dbtempcol name = "DEid" 		type= "int" 		mandatory="no">
            	<cf_dbtempcol name = "FechaBaja"  	type = "datetime" 	mandatory="no">
                <cf_dbtempcol name = "FechaAlta"  	type = "datetime" 	mandatory="no">
            </cf_dbtemp>

            <cfquery name="InsertEmpleadosBA" datasource="#session.DSN#">
            	insert into #EmpleadosBA# (DEid,FechaBaja)
				select d.DEid, max(DLfvigencia) as FechaCese
				from DLaboralesEmpleado d
    				inner join  DatosEmpleado a on d.DEid  = a.DEid and d.Ecodigo=a.Ecodigo
    				inner join  RHTipoAccion r on r.RHTid = d.RHTid
				where RHTcomportam = 2
					<!---and DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaHasta)#">--->
					and d.Ecodigo = #session.Ecodigo#
				group by d.DEid
			</cfquery>

            <cfquery name="SelectEmpleadosBA" datasource="#session.DSN#">
            	select DEid,FechaBaja from #EmpleadosBA#
			</cfquery>

            <cfloop query="SelectEmpleadosBA">
            	<cfquery name="UpdateEmpleadosBA" datasource="#session.DSN#">
            		update #EmpleadosBA#
                    set FechaAlta = (select max(DLfvigencia) as FechaAlta
									 from DLaboralesEmpleado d
    			                     	inner join  DatosEmpleado a on d.DEid  = a.DEid and d.Ecodigo=a.Ecodigo
    									inner join RHTipoAccion r on r.RHTid = d.RHTid
										where RHTcomportam = 1
	  									and d.Ecodigo = #session.Ecodigo#
	  									and d.DEid = #SelectEmpleadosBA.DEid#
										group by d.DEid)
                    where DEid = #SelectEmpleadosBA.DEid#
                </cfquery>
            </cfloop>

            <cfquery name="SelectEmpleadosBA" datasource="#session.DSN#">
            	select * from #EmpleadosBA#
			</cfquery>
            <!---<cf_dump var = "#SelectEmpleadosBA#">--->

            <!---<cfquery name = "rsEmpleadoAB" datasource="#session.DSN#">
            	select DEid,month(FechaBaja) as fechaBaja
                from #EmpleadosBA#
                where FechaAlta < FechaBaja
            </cfquery>--->

            <!---<cf_dump var = "#rsEmpleadoAB#">--->

            <cfloop query="SelectEmpleadosBA">
            	<cfquery name = "rsUpdMesInicio" datasource="#session.DSN#">
            		update RHAjusteAnualAcumulado
                	set <cfif #SelectEmpleadosBA.FechaBaja# GT #rsSelectFechas.RHAAfechavence#>
                    	 RHAAAMesFinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(LSDateFormat(rsSelectFechas.RHAAfechavence,'yyyy-MM-dd'))#">
                       	<cfelseif #SelectEmpleadosBA.FechaAlta# GTE #SelectEmpleadosBA.FechaBaja#>
                		 RHAAAMesFinal = <cfqueryparam cfsqltype="cf_sql_integer" value="#Month(LSDateFormat(rsSelectFechas.RHAAfechavence,'yyyy-MM-dd'))#">
                		<cfelseif #SelectEmpleadosBA.FechaAlta# LT #SelectEmpleadosBA.FechaBaja#>
                         RHAAAMesFinal = #Month(DateFormat(SelectEmpleadosBA.FechaBaja,'yyyy-MM-dd'))#
                    	</cfif>
                	where DEid = #SelectEmpleadosBA.DEid#
                		and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            	</cfquery>
            </cfloop>

            <!---<cfquery name = "rsEmpleadoAB" datasource="#session.DSN#">
            	select DEid,month(FechaBaja) as fechaBaja
                from #EmpleadosBA#
                where FechaAlta >= FechaBaja
            </cfquery>

            <cfloop query="rsEmpleadoAB">
            <cfquery name = "rsUpdMesInicio" datasource="#session.DSN#">
            	update RHAjusteAnualAcumulado
                set RHAAAMesFinal = month(<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaHasta)#">)
                where DEid = #rsEmpleadoAB.DEid#
                	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>
            </cfloop>--->

            <cfquery name = "rsEmpleadoAB" datasource="#session.DSN#">
            	select DEid
				from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid = rhaa.RHAAid
				where rhaaa.RHAAAMesFinal is null
				and rhaa.Ecodigo = #session.Ecodigo#
				and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>

            <cfloop query="rsEmpleadoAB">
            <cfquery name = "rsUpdMesInicio" datasource="#session.DSN#">
            	update RHAjusteAnualAcumulado
                set RHAAAMesFinal = (select month(max(DLffin))
									 from DLaboralesEmpleado d
    			                     	inner join  DatosEmpleado a on d.DEid  = a.DEid and d.Ecodigo=a.Ecodigo
    									inner join RHTipoAccion r on r.RHTid = d.RHTid
										where RHTcomportam = 1
	  									and d.Ecodigo = #session.Ecodigo#
	  									and d.DEid = #rsEmpleadoAB.DEid#)
                where DEid = #rsEmpleadoAB.DEid#
                	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>
            </cfloop>

			<cfquery name="rsEmpleadosBaja" datasource="#session.DSN#">
            	insert into #EmpleadosFuera#(DEid,FechaAB)
				select DEid,FechaBaja
                from #EmpleadosBA#
                where FechaAlta < FechaBaja
                		and FechaBaja <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.FechaHasta)#">
			</cfquery>
            </cfif>

            <cfif isdefined ("txtIngresoAnual") and txtIngresoAnual NEQ ''>
           	<cfquery name="rsEmpleadoSueldoS" datasource="#session.DSN#">
            	insert into #EmpleadosFuera#(DEid)
            	select DEid
				from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
				where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
                	and RHAAAcumulado > <cfqueryparam cfsqltype="cf_sql_varchar" value="#replace(Form.txtIngresoAnual,',','','all')#">
				order by DEid
            </cfquery>
            </cfif>

            <cfquery name="SelectAB" datasource="#session.DSN#">
            	select DEid from #EmpleadosFuera#
                group by DEid
            </cfquery>

           <!--- <cf_dump var = "#SelectAB#">--->

            <cfquery name="rsSelectSalarioEmpleado" datasource="#session.DSN#">
    			update RHAjusteAnualAcumulado
                set RHAAAEstatus = 1,
                	RHAAAMesInicio = month(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSelectFechas.RHAAfecharige#">),
                    RHAAAMesFinal = month(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSelectFechas.RHAAfechavence#">)
                where 
					 RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
					<cfif SelectAB.RecordCount gt 0>
                		and DEid not in (#ValueList(SelectAB.DEid)#)
					</cfif>
    		</cfquery>


            <cfquery name="rsSelectSalarioEmpleado" datasource="#session.DSN#">
    			update RHAjusteAnualAcumulado
                set RHAAAEstatus = 0
                	<!---RHAAAMesFinal = month(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSelectFechas.RHAAfechavence#">)--->
                where DEid in (#ValueList(SelectAB.DEid)#)
                	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
    		</cfquery>

             <cfquery name = "rsEmpleadoSFecha" datasource="#session.DSN#">
            	select DEid
				from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaaa.RHAAid = rhaa.RHAAid
				where rhaaa.RHAAAMesFinal is null
				and rhaa.Ecodigo = #session.Ecodigo#
				and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>

            <cfloop query="rsEmpleadoSFecha">
            <cfquery name="rsSelectSalarioEmpleado" datasource="#session.DSN#">
    			update RHAjusteAnualAcumulado
                set RHAAAMesFinal = month(<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSelectFechas.RHAAfechavence#">)
                where DEid = #rsEmpleadoSFecha.DEid#
                	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
    		</cfquery>
            </cfloop>


	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=3">

<cfelseif isdefined("Form.hdAccion") and Form.hdAccion EQ 'BAJAE'>
<!---<cfthrow message="#Form.hdDEid#">--->
	<cfif isdefined ("Form.hdDEid") and Form.hdDEid NEQ ''>
		<cfquery name = "rsUpdateEmpleado" datasource = "#session.DSN#">
    		update RHAjusteAnualAcumulado
        	set RHAAAEstatus = 0
        	where DEid = #form.hdDEid#
            	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
   		</cfquery>
<!---        <cfquery name = "rsUpdateEmpleado" datasource = "#session.DSN#">
    		update RHAjusteAnualAcumulado
        	set RHAAAcumuladoISPT = 0.00
        	where DEid = #form.hdDEid#
            	and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
   		</cfquery>--->
    </cfif>
	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=3">

<cfelseif isdefined("BTN_Generar")>

	<cf_dbtemp name = "RHAjusteAnualAcumulado" datasource = "#session.DSN#" returnvariable = "RHAjusteAnualAcumulado">
    	<cf_dbtempcol name="RHAAid"					type="varchar(50)"		mandatory="no">
        <cf_dbtempcol name="DEid"					type="int"				mandatory="no">
		<cf_dbtempcol name="RHAAAEstatus"			type="bit"				mandatory="no"		 default = 0 >
        <cf_dbtempcol name="RHAAAcumuladoSalario"	type="money"			mandatory="no">
        <cf_dbtempcol name="RHAAAcumulado"			type="money"			mandatory="no">
	<!---        <cf_dbtempcol name="RHPrimaVacacionalE"		type="money"			mandatory="no">
        <cf_dbtempcol name="RHPrimaVacacionalG"		type="money"			mandatory="no">
        <cf_dbtempcol name="RHAguinaldoE"			type="money"			mandatory="no">
        <cf_dbtempcol name="RHAguinaldoG"			type="money"			mandatory="no">
        <cf_dbtempcol name="RHAAAcumuladoExento"	type="money"			mandatory="no">
        <cf_dbtempcol name="RHAAAcumuladoGravado"	type="money"			mandatory="no">--->
    </cf_dbtemp>

	<cfquery name="rsInsertSalarioEmpleado" datasource="#session.DSN#">
    	insert into #RHAjusteAnualAcumulado# (RHAAid, DEid, RHAAAEstatus,RHAAAcumuladoSalario,RHAAAcumulado)
    	select rhaaa.RHAAid, DEid, RHAAAEstatus,RHAAAcumuladoSalario,RHAAAcumulado
        from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
		where rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  		and rhaa.Ecodigo = #session.Ecodigo#
   	</cfquery>

    <cf_dbtemp name = "DRHAjusteAnual" datasource = "#session.DSN#" returnvariable = "DRHAjusteAnual">
    	<cf_dbtempcol name = "RHAAid"			type = "varchar(50)" 	mandatory = "no">
        <cf_dbtempcol name = "DEid" 			type = "int"			mandatory = "no">
        <cf_dbtempcol name = "DRHAAAcumulado"	type = "money"			mandatory = "no">
        <cf_dbtempcol name = "DRHAAConcepto"	type = "varchar(50)"	mandatory = "no">
    </cf_dbtemp>

    <cfquery name="rsInsertAcumConceptos" datasource="#session.DSN#">
    	insert into #DRHAjusteAnual# (RHAAid,DEid,DRHAAAcumulado,DRHAAConcepto)
        select drha.RHAAid,DEid, DRHAAAcumulado,CIid
        from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
        where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  		and rhaa.Ecodigo = #session.Ecodigo#
    </cfquery>

	<cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
    	select RHAAfecharige,RHAAfechavence
        from RHAjusteAnual
        where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	        and Ecodigo = #session.Ecodigo#
    </cfquery>

	<cfquery name="rsEmpleadosAjusteAnual" datasource="#session.DSN#">
    	select DEid,RHAAAEstatus
		from #RHAjusteAnualAcumulado#
    </cfquery>

	<cfif isdefined ("rsEmpleadosAjusteAnual") and rsEmpleadosAjusteAnual.RecordCount GT 0>
    	<cf_dbtemp name = "PrimaVacacional" datasource = "#session.DSN#" returnvariable = "PrimaVacacional">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no">
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoGravable"	type = "money"			mandatory = "no">

   		</cf_dbtemp>

        <cf_dbtemp name = "Aguinaldo" datasource = "#session.DSN#" returnvariable = "Aguinaldo">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no">
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
           	<cf_dbtempcol name = "AcumuladoGravable"	type = "money"			mandatory = "no">
   		</cf_dbtemp>

        <cf_dbtemp name = "Separacion" datasource = "#session.DSN#" returnvariable = "Separacion">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no">
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
           	<cf_dbtempcol name = "AcumuladoGravable"	type = "money"			mandatory = "no">
            <cf_dbtempcol name = "Anios"				type = "int"			mandatory = "no">
   		</cf_dbtemp>

        <cf_dbtemp name = "PTU" datasource = "#session.DSN#" returnvariable = "PTU">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no">
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
           	<cf_dbtempcol name = "AcumuladoGravable"	type = "money"			mandatory = "no">
            <cf_dbtempcol name = "Anios"				type = "int"			mandatory = "no">
   		</cf_dbtemp>

         <cf_dbtemp name = "FOA" datasource = "#session.DSN#" returnvariable = "FOA">
    		<cf_dbtempcol name = "RHAAid"				type = "varchar(50)" 	mandatory = "no">
        	<cf_dbtempcol name = "DEid" 				type = "int"			mandatory = "no">
        	<cf_dbtempcol name = "Acumulado"			type = "money"			mandatory = "no">
            <cf_dbtempcol name = "SalarioMinimo"		type = "money"			mandatory = "no">
            <cf_dbtempcol name = "AcumuladoExento"		type = "money"			mandatory = "no">
           	<cf_dbtempcol name = "AcumuladoGravable"	type = "money"			mandatory = "no">
            <cf_dbtempcol name = "Anios"				type = "int"			mandatory = "no">
   		</cf_dbtemp>



        <cfloop query="rsEmpleadosAjusteAnual">

        	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2560" default="0" returnvariable="CIidPrimVacacional"/>

        	<cfquery name="rsInsertPVacacional" datasource="#session.DSN#">
             insert into #PrimaVacacional# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
            		 inner join CIncidentes ci on ci.CIid = drha.CIid and rhaa.Ecodigo = ci.Ecodigo
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#CIidPrimVacacional#)
	  			and DEid = #rsEmpleadosAjusteAnual.DEId#
				group by drha.RHAAid,DEid
            </cfquery>

            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsEmpleadosAjusteAnual.DEId#
				and sm.SZEhasta  = (select max(s.SZEhasta)
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid
											and s.SZEestado = 1)
			</cfquery>

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #PrimaVacacional#
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #PrimaVacacional#
                set AcumuladoExento = (case when Acumulado > (15*SalarioMinimo) then (15*SalarioMinimo)
                					   else Acumulado
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #PrimaVacacional#
                set AcumuladoGravable = (case when Acumulado > (15*SalarioMinimo) then (Acumulado - AcumuladoExento)
                					   else 0.00
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <!---<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #RHAjusteAnualAcumulado#
                set RHPrimaVacacionalG = (select AcumuladoGravable from #PrimaVacacional# where DEid = #rsEmpleadosAjusteAnual.DEId#)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #RHAjusteAnualAcumulado#
                set RHPrimaVacacionalE = (select AcumuladoExento from #PrimaVacacional# where DEid = #rsEmpleadosAjusteAnual.DEId#)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2561" default="0" returnvariable="CIidAguinaldo"/>

            <cfquery name="rsInsertAguinaldo" datasource="#session.DSN#">
             insert into #Aguinaldo# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
             			inner join CIncidentes ci on ci.CIid = drha.CIid and rhaa.Ecodigo = ci.Ecodigo
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#CIidAguinaldo#)
	  			and DEid = #rsEmpleadosAjusteAnual.DEId#
				group by drha.RHAAid,DEid
            </cfquery>

            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsEmpleadosAjusteAnual.DEId#
				and sm.SZEhasta  = (select max(s.SZEhasta)
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid
											and s.SZEestado = 1)
			</cfquery>

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #Aguinaldo#
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #Aguinaldo#
                set AcumuladoExento = (case when Acumulado > (30*SalarioMinimo) then (30*SalarioMinimo)
                					   else Acumulado
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #Aguinaldo#
                set AcumuladoGravable = (case when Acumulado > (30*SalarioMinimo) then (Acumulado - AcumuladoExento)
                					   else 0.00
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <!--- <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	select * from #Aguinaldo#
                where DEid = 331
            </cfquery>

            <cf_dump var  = "#rsUpdateAcumuladoGravable#">
            --->
             <!---<cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #RHAjusteAnualAcumulado#
                set RHAguinaldoE = (select AcumuladoExento from #Aguinaldo# where DEid = #rsEmpleadosAjusteAnual.DEId#)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #RHAjusteAnualAcumulado#
                set RHAguinaldoG = (select AcumuladoGravable from #Aguinaldo# where DEid = #rsEmpleadosAjusteAnual.DEId#)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>--->

            <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2562" default="0" returnvariable="CIidSeparacion"/>

            <cfquery name="rsInsertSeparacion" datasource="#session.DSN#">
             insert into #Separacion# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
             			inner join CIncidentes ci on ci.CIid = drha.CIid and rhaa.Ecodigo = ci.Ecodigo
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#CIidSeparacion#)
	  			and DEid = #rsEmpleadosAjusteAnual.DEId#
				group by drha.RHAAid,DEid
            </cfquery>

            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsEmpleadosAjusteAnual.DEId#
				and sm.SZEhasta  = (select max(s.SZEhasta)
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid
											and s.SZEestado = 1)
			</cfquery>

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #Separacion#
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
				select dle.DLfvigencia as DLfechaaplic, eve.EVfantig, dle.DEid
	 			from DLaboralesEmpleado  dle
	 				inner join RHTipoAccion rhta
						on  dle.Ecodigo = rhta.Ecodigo
						and dle.RHTid = rhta.RHTid
	  				inner join EVacacionesEmpleado eve
	    				on  dle.DEid = eve.DEid
				where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  			and dle.DEid = #rsEmpleadosAjusteAnual.DEId#
	  			and rhta.RHTcomportam = 2
			</cfquery>

            <cfif isdefined('rsDetalleRHLiquidacionPersonal') and rsDetalleRHLiquidacionPersonal.RecordCount GT 0>
            <cfset ylaborados = DateDiff('yyyy',rsDetalleRHLiquidacionPersonal.EVfantig,rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
            <cfset mlaborados = DateDiff('m',DateAdd('yyyy',ylaborados,rsDetalleRHLiquidacionPersonal.EVfantig),rsDetalleRHLiquidacionPersonal.DLfechaaplic)>
            <cfif mlaborados GTE 5>
            <cfset mlaborados = 5>
            <cfelseif mlaborados LTE 4>
            <cfset mlaborados = 4>
            </cfif>
            <cfset tdiasalario = (90 * (Round((#ylaborados# + (#mlaborados#/10)))))>
            </cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #Separacion#
                <cfif isdefined('tdiasalario')>
                set Anios = #tdiasalario#
                <cfelse>
                set Anios = 0
                </cfif>
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #Separacion#
                set AcumuladoExento = (case when Acumulado > (Anios*SalarioMinimo) then (Anios*SalarioMinimo)
                					   else Acumulado
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #Separacion#
                set AcumuladoGravable = (case when Acumulado > (Anios*SalarioMinimo) then (Acumulado - AcumuladoExento)
                					   else 0.00
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <!---PTU Inicio--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2563" default="0" returnvariable="CIidPTU"/>

        	<cfquery name="rsInsertPVacacional" datasource="#session.DSN#">
             insert into #PTU# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
            		 inner join CIncidentes ci on ci.CIid = drha.CIid and rhaa.Ecodigo = ci.Ecodigo
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#CIidPTU#)
	  			and DEid = #rsEmpleadosAjusteAnual.DEId#
				group by drha.RHAAid,DEid
            </cfquery>

            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsEmpleadosAjusteAnual.DEId#
				and sm.SZEhasta  = (select max(s.SZEhasta)
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid
											and s.SZEestado = 1)
			</cfquery>

			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #PTU#
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #PTU#
                set AcumuladoExento = (case when Acumulado > (15*SalarioMinimo) then (15*SalarioMinimo)
                					   else Acumulado
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #PTU#
                set AcumuladoGravable = (case when Acumulado > (15*SalarioMinimo) then (Acumulado - AcumuladoExento)
                					   else 0.00
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>
            <!---PTU Final--->

            <!---FOA Inicio--->
            <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2564" default="0" returnvariable="CIidFOA"/>

        	<cfquery name="rsInsertPVacacional" datasource="#session.DSN#">
             insert into #FOA# (RHAAid,DEid,Acumulado)
             select drha.RHAAid,DEid,coalesce(sum(DRHAAAcumulado),0.00)
			 from DRHAjusteAnual drha inner join RHAjusteAnual rhaa on rhaa.RHAAid = drha.RHAAid
            		 inner join CIncidentes ci on ci.CIid = drha.CIid and rhaa.Ecodigo = ci.Ecodigo
			 where drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	  			and rhaa.Ecodigo = #session.Ecodigo#
	  			and ci.CIid in (#CIidFOA#)
	  			and DEid = #rsEmpleadosAjusteAnual.DEId#
				group by drha.RHAAid,DEid
            </cfquery>

            <cfquery name="rsSelectSalario" datasource="#session.dsn#">
			select coalesce(sm.SZEsalarioMinimo,0) as SZEsalarioMinimo
			from DatosEmpleado de
				inner join ZonasEconomicas ze
					on de.ZEid = ze.ZEid
				inner join SalarioMinimoZona sm
					on ze.ZEid = sm.ZEid
				and sm.SZEestado = 1
			where  de.DEid = #rsEmpleadosAjusteAnual.DEId#
				and sm.SZEhasta  = (select max(s.SZEhasta)
									from DatosEmpleado d
										inner join ZonasEconomicas z
											on d.ZEid = z.ZEid
										inner join SalarioMinimoZona s
											on z.ZEid = s.ZEid
											and s.SZEestado = 1)
			</cfquery>


			<cfif isdefined("rsSelectSalario") and rsSelectSalario.RecordCount neq 0>
				<cfset SZEsalarioMinimo = #rsSelectSalario.SZEsalarioMinimo#>
			<cfelse>
				<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="2024" default="0" returnvariable="SZEsalarioMinimo"/>
			</cfif>

            <cfquery name="rsUpdateSalarioM" datasource="#session.DSN#">
            	update #FOA#
                set SalarioMinimo = #SZEsalarioMinimo#
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfset fechaInicio = LSDateFormat(rsSelectFechas.RHAAfecharige,'yyyymmdd')>
            <cfset fechaFinal = LSDateFormat(rsSelectFechas.RHAAfechavence,'yyyymmdd')>

            <cfquery name="rsUpdateAcumuladoExento" datasource="#session.DSN#">
            	update #FOA#
                set AcumuladoExento = (case when Acumulado > ((1.3*SalarioMinimo) * (DATEDIFF(d,'#fechaInicio#','#fechaFinal#')+1)) then ((1.3*SalarioMinimo) * (DATEDIFF(d,'#fechaInicio#','#fechaFinal#')+1))
                					   else Acumulado
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>

            <cfquery name="rsUpdateAcumuladoGravable" datasource="#session.DSN#">
            	update #FOA#
                set AcumuladoGravable = (case when Acumulado > ((1.3*SalarioMinimo) * (DATEDIFF(d,'#fechaInicio#','#fechaFinal#')+1)) then (Acumulado - AcumuladoExento)
                					   else 0.00
                                       end)
                where DEid = #rsEmpleadosAjusteAnual.DEId#
            </cfquery>
            <!---FOA Final--->







            <cfquery name="rsUpdateEmpleados" datasource="#session.DSN#">
                update RHAjusteAnualAcumulado
				set RHAAAcumuladoGravado = ((select coalesce(sum(DRHAAAcumulado),0.00)
											from DRHAjusteAnual drha, CIncidentes ci, RHAjusteAnual rhaa
											where drha.CIid = ci.CIid
	  										and drha.RHAAid = rhaa.RHAAid
	  										and ci.CIid not in (#CIidPrimVacacional#)
											and ci.CIid not in (#CIidAguinaldo#)
											and ci.CIid not in (#CIidSeparacion#)
                                            and ci.CIid not in (#CIidPTU#)
                                            and ci.CIid not in (#CIidFOA#)
	  										and ci.CInorenta = 0
	  										and drha.DEid = #rsEmpleadosAjusteAnual.DEId#
	  										and ci.Ecodigo = #session.Ecodigo#
                                            and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">)  +
                                            coalesce((select AcumuladoGravable from #PrimaVacacional# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoGravable from #Aguinaldo# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoGravable from #Separacion# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoGravable from #PTU# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00)+ coalesce((select AcumuladoGravable from #FOA# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00))
				where DEId = #rsEmpleadosAjusteAnual.DEId#
	  			and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>

            <cfquery name="rsUpdateEmpleados" datasource="#session.DSN#">
                update RHAjusteAnualAcumulado
				set RHAAAcumuladoExento = ((select coalesce(sum(DRHAAAcumulado),0.00)
										   from DRHAjusteAnual drha, CIncidentes  ci, RHAjusteAnual rhaa
							               where drha.CIid = ci.CIid
							               and drha.RHAAid = rhaa.RHAAid
                                           and ci.CIid not in (#CIidPrimVacacional#)
											and ci.CIid not in (#CIidAguinaldo#)
											and ci.CIid not in (#CIidSeparacion#)
                                            and ci.CIid not in (#CIidPTU#)
                                            and ci.CIid not in (#CIidFOA#)
							               and ci.CInorenta = 1
							               and drha.DEid = #rsEmpleadosAjusteAnual.DEId#
							               and ci.Ecodigo = #session.Ecodigo#
                                           and drha.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">) +
                                           coalesce((select AcumuladoExento from #PrimaVacacional# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoExento from #Aguinaldo# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00)+ coalesce((select AcumuladoExento from #Separacion# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoExento from #PTU# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00) + coalesce((select AcumuladoExento from #FOA# where DEid = #rsEmpleadosAjusteAnual.DEId#),0.00))
				where DEId = #rsEmpleadosAjusteAnual.DEId#
	  			and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>

           <!--- <cfquery name="rsUpdateEmpleados" datasource="#session.DSN#">
                update RHAjusteAnualAcumulado
				set RHAAAcumuladoGravado = (select coalesce(RHPrimaVacacionalG,0.00) + coalesce(RHAguinaldoG,0.00) + 		coalesce(RHAAAcumuladoGravado,0.00)
                							from #RHAjusteAnualAcumulado#
                                            where DEId = #rsEmpleadosAjusteAnual.DEId#)
				where DEId = #rsEmpleadosAjusteAnual.DEId#
	  			and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>--->

            <cfquery name="rsUpdateEmpleados" datasource="#session.DSN#">
                update RHAjusteAnualAcumulado
				set RHAAAcumuladoSubsidio = (select coalesce(SUM(RHSvalor),00)
 											from HRHSubsidio hrhs
 											where hrhs.DEid = #rsEmpleadosAjusteAnual.DEId#
												 and RCNid in (select CPid from CalendarioPagos
				                                              where Ecodigo = #session.Ecodigo#
						                                           and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
						                                           and CPhasta <= '#rsSelectFechas.RHAAfechavence#')) +
                                            (select coalesce(SUM(RHSvalor),00)
 											from RHSubsidio hrhs
 											where hrhs.DEid = #rsEmpleadosAjusteAnual.DEId#
												and RCNid in (select CPid from CalendarioPagos
				                                              where Ecodigo = #session.Ecodigo#
						                                           and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
						                                           and CPhasta <= '#rsSelectFechas.RHAAfechavence#'))
				where DEId = #rsEmpleadosAjusteAnual.DEId#
	  			and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
				</cfquery>
				
				<cfquery name="rsDeduccionesAjusteISR" datasource="#session.DSN#">
					select  coalesce(sum(a.DCvalor),0.00) as sumDeducciones
						from DeduccionesCalculo a, DeduccionesEmpleado b, TDeduccion c
							where a.RCNid in (select CPid from CalendarioPagos where Ecodigo = #session.Ecodigo#
							and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
							and CPhasta <= '#rsSelectFechas.RHAAfechavence#') 
	 						and a.DEid = #rsEmpleadosAjusteAnual.DEId#
	 						and a.Did = b.Did
     						and b.TDid = c.TDid
	 						and c.TDesajuste = 1 
				</cfquery>

				<cfquery name="rsHDeduccionesAjusteISR" datasource="#session.DSN#">
					select  coalesce(sum(a.DCvalor),0.00) as sumDeducciones
						from HDeduccionesCalculo a, DeduccionesEmpleado b, TDeduccion c
							where a.RCNid in (select CPid from CalendarioPagos where Ecodigo = #session.Ecodigo#
							and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
							and CPhasta <= '#rsSelectFechas.RHAAfechavence#') 
	 						and a.DEid = #rsEmpleadosAjusteAnual.DEId#
	 						and a.Did = b.Did
     						and b.TDid = c.TDid
	 						and c.TDesajuste = 1 
				</cfquery>
				<!--- Se agrega al Acumulado de ISR Anual  la suma anual de las deducciones que aplican Ajuste ISR --->

                <cfquery name="rsUpdateEmpleados" datasource="#session.DSN#">
                update RHAjusteAnualAcumulado
				set RHAAAcumuladoRenta = ((select coalesce(sum(SErenta)+#rsDeduccionesAjusteISR.sumDeducciones#+#rsHDeduccionesAjusteISR.sumDeducciones#,0.00)
										  from HSalarioEmpleado
                                          where DEid = #rsEmpleadosAjusteAnual.DEId#
	                                            and RCNid in (select CPid from CalendarioPagos
				                                              where Ecodigo = #session.Ecodigo#
						                                           and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
						                                           and CPhasta <= '#rsSelectFechas.RHAAfechavence#')
						                                           <!---and CPtipo = 0)--->
                                        	group by DEid)+
                                          coalesce((select sum(SErenta)
										  from SalarioEmpleado
                                          where DEid = #rsEmpleadosAjusteAnual.DEId#
	                                            and RCNid in (select CPid from CalendarioPagos
				                                              where Ecodigo = #session.Ecodigo#
						                                           and CPdesde >= '#rsSelectFechas.RHAAfecharige#'
						                                           and CPhasta <= '#rsSelectFechas.RHAAfechavence#')
						                                          <!--- and CPtipo = 0)--->
                                        	group by DEid),0.00))
				where DEId = #rsEmpleadosAjusteAnual.DEId#
	  			and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
                </cfquery>
        </cfloop>

       <!--- <cfquery name="Empleados" datasource="#session.DSN#">
 			select * from #RHAjusteAnualAcumulado#
            where DEid = 380
			order by DEid
            </cfquery>

            <cf_dump var = "#Empleados#">--->

        <!---<cfquery name="Salario" datasource="#session.DSN#">
        	select * from #Separacion#
            where DEid =327
            order by DEid
        </cfquery>

        <cf_dump var = "#Salario#">--->

        </cfif>

        	<cfquery name = "rsSelectImpuestoGravable" datasource="#session.DSN#">
                select rhaaa.DEid, (coalesce(rhaaa.RHAAAcumuladoGravado,0.00)) + (coalesce( rhaaa.RHAAAcumuladoSalario,0.00)) as ImporteGravable
				from RHAjusteAnualAcumulado rhaaa
	 				<!---inner join RHAjusteAnualSalario rhaas on rhaas.DEid = rhaaa.DEId and rhaas.RHAAid= rhaaa.RHAAid--->
	 				inner join RHAjusteAnual rhaa on rhaa.RHAAid = rhaaa.RHAAid
				where <!---rhaaa.RHAAAEstatus = 1
					and---> rhaa.Ecodigo = #session.Ecodigo#
                    and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            </cfquery>
        <cfif isdefined ("rsSelectImpuestoGravable") and rsSelectImpuestoGravable.RecordCount GT 0>
        	<cfloop query="rsSelectImpuestoGravable">
            	<cfquery name = "rsUpdateImpuestoGravable" datasource="#session.DSN#">
               		update RHAjusteAnualAcumulado
					set RHAAAcumuladoSG = #rsSelectImpuestoGravable.ImporteGravable#
 					where DEId = #rsSelectImpuestoGravable.Deid#
                    	and RHAAid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
            	</cfquery>
            </cfloop>
         </cfif>

	<!---        Empieza Calculo de Ajuste Anual--->
	<cf_dbtemp name="TRentaAnual" returnvariable="TRentaAnual" datasource="#session.DSN#">
		<cf_dbtempcol name="DIRid" 			type="numeric" 	mandatory="no">
        <cf_dbtempcol name="LimInf" 		type="money" 	mandatory="no">
        <cf_dbtempcol name="LimSup" 		type="money" 	mandatory="no">
        <cf_dbtempcol name="MontoFijo" 		type="money" 	mandatory="no">
        <cf_dbtempcol name="Porcentaje" 	type="money" 	mandatory="no">
    </cf_dbtemp>

    <cf_dbtemp name="CalculoAjusteAnual" returnvariable="CalculoAjusteAnual" datasource="#session.DSN#">
		<cf_dbtempcol name="RHAAid" 		type="varchar(50)" 	mandatory="no">
        <cf_dbtempcol name="DEid" 			type="int" 			mandatory="no">
        <cf_dbtempcol name="RHAcumuladoSG" 	type="money" 		mandatory="no">
        <cf_dbtempcol name="TLimInf"     	type="money" 		mandatory="no">
        <cf_dbtempcol name="TLimSup" 		type="money" 		mandatory="no">
        <cf_dbtempcol name="TMonto" 		type="money" 		mandatory="no">
        <cf_dbtempcol name="Tporcentaje" 	type="money" 		mandatory="no">
        <cf_dbtempcol name="Subsidio" 		type="money" 		mandatory="no">
        <cf_dbtempcol name="ISPT" 			type="money" 		mandatory="no">
        <cf_dbtempcol name="ISR" 			type="money" 		mandatory="no">
        <cf_dbtempcol name="ISRT" 			type="money" 		mandatory="no">
    </cf_dbtemp>

    <!---  --->
    <cfquery datasource="#session.DSN#" name="prueba">
    Insert into #TRentaAnual# (DIRid,LimInf,LimSup,MontoFijo,Porcentaje)
        	select b.DIRid ,b.DIRinf ,b.DIRsup ,b.DIRmontofijo ,b.DIRporcentaje
            from EImpuestoRenta a
            	inner join DImpuestoRenta b on b.EIRid = a.EIRid
            where a.IRcodigo = (select EIRid from RHAjusteAnual
            					where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
                                and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
			and a.EIRid = (select Max(EIRid) 
							from EImpuestoRenta 
							where IRcodigo = (select EIRid 
												from RHAjusteAnual	
												where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#"> 
												and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">))
            	and a.EIRestado = 1
               <!--- and a.EIRdesde >=  '2012-01-01'--->
        order by b.DIRinf
    </cfquery>
    <cfquery datasource="#session.DSN#">
    	Insert into #CalculoAjusteAnual# (RHAAid,DEid,RHAcumuladoSG,Subsidio,ISPT)
			select rhaaa.RHAAid,rhaaa.DEId,rhaaa.RHAAAcumuladoSG,rhaaa.RHAAAcumuladoSubsidio,rhaaa.RHAAAcumuladoRenta
			from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa
				on rhaaa.RHAAid =rhaa.RHAAid
			where rhaaa.RHAAAEstatus = 1
				and rhaa.Ecodigo = #session.Ecodigo#
				and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
	</cfquery>
	<cfquery datasource="#session.DSN#">
     update #CalculoAjusteAnual#
     	set TLimInf = ( select LimInf from #TRentaAnual# where  #CalculoAjusteAnual#.RHAcumuladoSG between LimInf and LimSup),
            TLimSup = ( select LimSup from #TRentaAnual# where  #CalculoAjusteAnual#.RHAcumuladoSG between LimInf and LimSup),
            TMonto	 = ( select MontoFijo from #TRentaAnual# where  #CalculoAjusteAnual#.RHAcumuladoSG between LimInf and LimSup),
            Tporcentaje = ( select Porcentaje from #TRentaAnual# where  #CalculoAjusteAnual#.RHAcumuladoSG between LimInf and LimSup)
    </cfquery>
    <cfquery datasource="#session.DSN#">
     update #CalculoAjusteAnual#
     	set ISR = coalesce((((RHAcumuladoSG - TLimInf) * (Tporcentaje/100))+ TMonto),0)
    </cfquery>
    <cfquery datasource="#session.DSN#">
     update #CalculoAjusteAnual#
     	set ISRT = coalesce((ISR - ISPT),0)
    </cfquery>

    <cfquery datasource="#session.DSN#" name="rsSelectCalculo">
    	select * from #CalculoAjusteAnual#
        order by DEid
    </cfquery>
    <cfloop query="rsSelectCalculo">
		<cfquery name = "rsUpdateEmpleados" datasource="#session.DSN#">
			update RHAjusteAnualAcumulado
					set RHAAAcumuladoISR = #rsSelectCalculo.ISR#
					where DEId = #rsSelectCalculo.DEId#
					and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		</cfquery>
		<cfquery name = "rsUpdateEmpleados" datasource="#session.DSN#">
			update RHAjusteAnualAcumulado
					set RHAAAcumuladoISPT = #rsSelectCalculo.ISRT#
					where DEId = #rsSelectCalculo.DEId#
					and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		</cfquery>
    </cfloop>
     <cfquery datasource="#session.DSN#" name="rsNoEISR">
			select rhaaa.DEId
			from RHAjusteAnualAcumulado rhaaa inner join RHAjusteAnual rhaa
				on rhaaa.RHAAid =rhaa.RHAAid
			where rhaaa.RHAAAEstatus = 0
				and rhaa.Ecodigo = #session.Ecodigo#
				and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
    </cfquery>
	
    <cfloop query="rsNoEISR">
		<cfquery name = "rsUpdateEmpleados" datasource="#session.DSN#">
			update RHAjusteAnualAcumulado
					set RHAAAcumuladoISPT = 0
					where DEId = #rsNoEISR.DEId#
					and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		</cfquery>
		<cfquery name = "rsUpdateEmpleados" datasource="#session.DSN#">
			update RHAjusteAnualAcumulado
					set RHAAAcumuladoISR = 0
					where DEId = #rsNoEISR.DEId#
					and RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		</cfquery>
    </cfloop>

  <!---  <cf_dump var = "#rsSelectCalculo#">--->
    <cflocation url="/cfmx/rh/nomina/procesoanual/repAjusteAnual.cfm?RHAAid=#Form.RHAAid#">

    <!---cfquery name="rsAjusteAnual" datasource="#session.DSN#">
    	select RHAAPeriodo
		from RHAjusteAnual
		where Ecodigo = #session.Ecodigo#
    </cfquery>
    --->
    <!---<cf_dump var = "#rsAjusteAnual#">--->
	<!---<cfdocument format="pdf">
    <!---<cfdocumentitem type="header">
    <font size="-1" align="center"><i>Nondisclosure Agreement</i></font>
    </cfdocumentitem>
    <cfdocumentitem type="footer">
    <font size="-1"><i>Page <cfoutput>#cfdocument.currentpagenumber# of
        #cfdocument.totalpagecount#</cfoutput></i></font>
    </cfdocumentitem>--->
    <cfpdfform action="populate" source="C:\Users\APH\Documents\constancia.pdf" <!---destination="C:\Users\APH\Documents\constancia.xdp"---> >
        <cfpdfsubform name="form1">
            <cfpdfformparam name="txtPeriodo" value="Hola"/>
        </cfpdfsubform>
    </cfpdfform>
    <!---resumes in this section. --->
    <cfdocumentsection>
    <!---<p>I, <cfoutput>#rsAjusteAnual.RHAAPeriodo#</cfoutput>,
        hereby attest that the information in this document is accurate and complete.</p>
    <br/><br/>
    <table border="0" cellpadding="20">
    <tr><td width="300">
    <hr />
    <p><i>Signature</i></p></td>
    <td width="150"><hr />
    <p><i>Today's Date</i></p></td></tr>--->
    </cfdocumentsection>
	</cfdocument>--->
<cfelseif isdefined("BTN_VerReporte")>
	<cflocation url="/cfmx/rh/nomina/procesoanual/repAjusteAnual.cfm?RHAAid=#Form.RHAAid#">
<cfelseif isdefined("BTN_Continuar3")>
	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=4">
</cfif>
<!---Tab 4 --->
<!---<cf_dump var = "#form#">--->
<cfif isdefined ("BTN_DescargarI")>
	<cfif isdefined("form.Concepto") and #form.Concepto# EQ -1>
    	<cf_throw message = "Elige un concepto">
    <cfelse>
    	<cfset CIcodigo = #form.Concepto#>
    </cfif>

    <cfset fechaIncid = #LSDateFormat(form.FechaAplica,'yyyyMMdd')#>
    <cfset jornada = '01'>
   	<cfset tipoNomina = #form.groupNomina#>

     <cfquery name="rsSelect" datasource="#session.DSN#">
    	select de.DEidentificacion, RHAAAcumuladoISPT * (-1) as Total
			from RHAjusteAnualAcumulado rhaaa
				inner join RHAjusteAnual rhaa on rhaaa.RHAAid =rhaa.RHAAid
				inner join DatosEmpleado de on de.DEid = rhaaa.DEid
			where rhaaa.RHAAAEstatus = 1
				and rhaa.Ecodigo = #session.Ecodigo#
				and rhaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
                and RHAAAcumuladoISPT < 0
    </cfquery>

    <cfset linea = 1>
    <cfset columna = ''>
    <cfloop query="rsSelect">
    		<cfif linea GT 1>
				<cfset columna = columna & '#chr(13)##chr(10)#'>
			</cfif>
    		<cfset columna = columna & #rsSelect.DEidentificacion# & '#chr(44)#'>
            <cfset columna = columna & #CIcodigo# & '#chr(44)#'>
            <cfset columna = columna & #fechaIncid# & '#chr(44)#'>
            <cfset columna = columna & '' & '#chr(44)#'>
            <cfset columna = columna & #jornada# & '#chr(44)#'>
            <cfset columna = columna & #tipoNomina# & '#chr(44)#'>
            <cfset columna = columna & '' & '#chr(44)#'>
            <cfset columna = columna & #rsSelect.Total# & '#chr(44)#'>
            <cfset columna = columna & 'carga'>
            <cfset linea=linea + 1>
    </cfloop>

    <cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'IncidenciaISR')>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#columna#" charset="utf-8">
	<cfheader name="Content-Disposition" value="inline;filename=IncidenciaISR.csv">
	<cfcontent file="#txtfile#" type="attachment/msexcel" deletefile="yes">

<cfelseif isdefined ("BTN_DescargarD")>
	<cfif isdefined("form.Deduccion") and #form.Deduccion# EQ -1>
    	<cf_throw message = "Elige una deduccion">
    <cfelse>
    	<cfset TDcodigo = #form.Deduccion#>
    </cfif>

    <cfset snnumero = '999-9999'>
    <cfset referencia = '#form.txtDescripcion#'>
    <cfset metodo = 1>
    <cfset cnominas = (len(trim(#form.txtCantidad# )) NEQ 0)?#form.txtCantidad#:1>
    <cfset fechaDeducI = #LSDateFormat(form.FechaAplicaD,'yyyyMMdd')#>
    <cfset fechaDeducF = '61000101'>
	<cfset control = 1>
	<cfset moneda= 'MXP'>
	<cfset groupDeduccion = #form.groupDeduccion#>
	
	<cfquery name="rsSelectAjusteAnual" datasource="#session.DSN#">
		
		select de.DEid,de.DEidentificacion, de.DEapellido1, de.DEapellido2, de.DEnombre, rhaaa.Tcodigo, rhaaa.RHAAAMesInicio,rhaaa.RHAAAMesFinal, rhaaa.RHAAAcumuladoSG,
			rhaaa.RHAAAcumuladoExento, rhaaa.RHAAAcumuladoSubsidio,rhaaa.RHAAAcumuladoRenta,
			rhaaa.RHAAAcumuladoISPT,rhaaa.RHAAAcumuladoISR,
			isnull(rhaaa.RHAAAcumuladoISR-(rhaaa.RHAAAcumuladoRenta),0) as calEisr1,
			isnull(rhaaa.RHAAAcumuladoISR-(rhaaa.RHAAAcumuladoSubsidio+rhaaa.RHAAAcumuladoRenta),0) as calEisr2,
			case rhaaa.RHAAAEstatus
			when 0 then 'No'
			when 1 then 'Si'
			end as Estatus
		from DatosEmpleado de inner join RHAjusteAnualAcumulado rhaaa on rhaaa.DEid = de.DEid 
		where de.Ecodigo = #session.Ecodigo#
		  and rhaaa.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
		  and rhaaa.RHAAAEstatus = 1
		order by de.DEapellido1, de.DEapellido2, de.DEnombre 
	</cfquery>
	<cf_dbtemp name = "Subsidio" datasource = "#session.DSN#" returnvariable = "Subsidio">
        <cf_dbtempcol name = "DEid" 			type = "int"			mandatory = "no">
        <cf_dbtempcol name = "Monto"			type = "money"			mandatory = "no">
        <cf_dbtempcol name = "RCNid"			type = "money"			mandatory = "no">
	</cf_dbtemp>

	<cf_dbtemp name = "Incidencias" datasource = "#session.DSN#" returnvariable = "Incidencias">
        <cf_dbtempcol name = "DEid"             type = "int"            mandatory = "no">
        <cf_dbtempcol name = "Monto"            type = "money"          mandatory = "no">
        <cf_dbtempcol name = "RCNid"            type = "money"          mandatory = "no">
	</cf_dbtemp>
	
	<cf_dbtemp name = "rsSelect" datasource = "#session.DSN#" returnvariable = "rsSelect">
        <cf_dbtempcol name = "DEidentificacion" type = "varchar(60)"    mandatory = "no">
		<cf_dbtempcol name = "Total"            type = "money"          mandatory = "no">
		<cf_dbtempcol name = "groupDeduccion"   type = "int"            mandatory = "no">
        <cf_dbtempcol name = "id"               type = "varchar(50)"    mandatory = "no">
	</cf_dbtemp>

	<cfquery name = "rsSelectFechas" datasource ="#session.DSN#">
		select RHAAfecharige,RHAAfechavence,RHAAEstatus
		from RHAjusteAnual 
		where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
			 and Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfquery name="rsInsertSub" datasource="#session.DSN#">
		insert into #Subsidio# (DEid,Monto,RCNid)
		(select a.DEid,a.DCvalor,a.RCNid
		 from HDeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
		 where a.DEid = b.DEid
		 and c.Ecodigo = b.Ecodigo
		 and c.TDid = b.TDid
		 and RCNid in (select CPid from CalendarioPagos
					   where Ecodigo = #session.Ecodigo#
							and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
							and CPtipo = 0)
		and c.Ecodigo = #session.Ecodigo#
		and a.DCvalor < 0
		 group by a.DEid,a.DCvalor,a.RCNid)
		union
	   (select a.DEid,a.DCvalor,a.RCNid
		 from DeduccionesCalculo a, DeduccionesEmpleado b,TDeduccion c 
		 where a.DEid = b.DEid
		 and c.Ecodigo = b.Ecodigo
		 and c.TDid = b.TDid
		 and RCNid in (select CPid from CalendarioPagos
					   where Ecodigo = #session.Ecodigo#
							and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
							and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
							and CPtipo = 0)
		and c.Ecodigo = #session.Ecodigo#
		and a.DCvalor < 0
		 group by a.DEid,a.DCvalor,a.RCNid)
	</cfquery>
	<cfquery name="rsInsertSub" datasource="#session.DSN#">
		insert into #Incidencias# (DEid,Monto,RCNid)
		select  hic.DEid,hic.ICmontores,hic.RCNid from 
		HIncidenciasCalculo hic
		inner  join CIncidentes ic
		on ic.CIid =hic.CIid
	where ic.CIcodigo ='09'
	and hic.RCNid IN
		   (SELECT CPid
			FROM CalendarioPagos
			WHERE Ecodigo = 1
			  and CPdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfecharige#">
			  and CPhasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsSelectFechas.RHAAfechavence#">
			  AND CPtipo = 0)
		GROUP BY hic.DEid,
				hic.ICmontores,
				hic.RCNid
	</cfquery>

	<cfset myguit = #CreateUUID()#>
	<cfloop query="rsSelectAjusteAnual">
		<cfquery name="rsReporte" datasource="#session.DSN#">
			select isnull(sum(t.Monto),0.00 )as Monto
			from(
			select sum(Monto) * -1 as Monto from #Subsidio#
			where DEid = #rsSelectAjusteAnual.DEid#
			union all
			select sum(Monto) as Monto from #Incidencias#
			where DEid = #rsSelectAjusteAnual.DEid#)t
			</cfquery>

		<cfset favor=0>
		<cfset cargo=0>
<!--- 		<cfif rsReporte.Monto EQ 0 and rsSelectAjusteAnual.calEisr1 gt 0>
			<cfset cargo=rsSelectAjusteAnual.calEisr1>
		<cfelseif rsReporte.Monto EQ 0 and rsSelectAjusteAnual.calEisr1 lt 0>
			<cfset favor=rsSelectAjusteAnual.calEisr1>
		<cfelseif rsReporte.Monto gt 0 and rsSelectAjusteAnual.calEisr2 gt 0>
			<cfset cargo=rsSelectAjusteAnual.calEisr2>
		<cfelseif rsReporte.Monto gt 0 and rsSelectAjusteAnual.calEisr2 lt 0>
			<cfset favor=rsSelectAjusteAnual.calEisr2>
		</cfif> --->
		<cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio gt rsSelectAjusteAnual.RHAAAcumuladoISR>
            <cfset favor=0>
            <cfset cargo=0>
        <cfelse>
            <cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio gt 0>
                <cfset favor=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta)lt 0) ? LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
                <cfset cargo=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta) gt 0)? LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoSubsidio - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
            </cfif>
            <cfif rsSelectAjusteAnual.RHAAAcumuladoSubsidio lt 0 or rsSelectAjusteAnual.RHAAAcumuladoSubsidio eq 0>
                <cfset favor=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta) lt 0)?LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
                <cfset cargo=((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta) gt 0)?LSCurrencyformat((rsSelectAjusteAnual.RHAAAcumuladoISR - rsSelectAjusteAnual.RHAAAcumuladoRenta),'none'):0>
            </cfif>
        </cfif> 
		
		<cfquery datasource="#session.DSN#">
			insert into #rsSelect# (DEidentificacion,Total,groupDeduccion,id) values ('#rsSelectAjusteAnual.DEidentificacion#',#(favor neq 0)?LSParseNumber(favor):LSParseNumber(cargo)#,#(favor neq 0)?0:1#,'#myguit#')
		</cfquery>

	</cfloop>

	<cfquery name="rsInsertSubT" datasource="#session.DSN#">
		select * from  #rsSelect# where id='#myguit#' and groupDeduccion='#groupDeduccion#' and Total!=0
	</cfquery>
	
    <cfset linea = 1>
	<cfset columna = ''>

	<cfquery name="rsDeduccion" datasource="#session.DSN#">
		select TDid, TDcodigo, TDdescripcion, b.SNnumero
		from TDeduccion a
		left outer join SNegocios b
			on a.SNcodigo=b.SNcodigo
			and a.Ecodigo = b.Ecodigo
		where TDcodigo ='#form.Deduccion#'
		  and a.Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif len(trim(rsDeduccion.SNnumero)) EQ 0>
		<cf_throw message = "Deduccion sin socio de negocio">
	</cfif>
	<cfloop query="rsInsertSubT">
				<cfif linea GT 1>
					<cfset columna = columna & '#chr(13)##chr(10)#'>
				</cfif>
				<cfset columna = columna & #rsDeduccion.SNnumero# & '#chr(44)#'>
				<cfset columna = columna & #TDcodigo# & '#chr(44)#'>
				<cfset columna = columna & #rsInsertSubT.DEidentificacion# & '#chr(44)#'>
				<cfset columna = columna & #referencia# & '#chr(44)#'>
				<cfset columna = columna & #metodo# & '#chr(44)#'>
				<cfset columna = columna & ((#rsInsertSubT.Total#)/#cnominas#) & '#chr(44)#'>
				<cfset columna = columna & #rsInsertSubT.Total# & '#chr(44)#'>
				<cfset columna = columna & #fechaDeducI# & '#chr(44)#'>
				<cfset columna = columna & #fechaDeducF# & '#chr(44)#'>
				<cfset columna = columna & #control# & '#chr(44)#'>
				<cfset columna = columna & #moneda#>
				<cfset linea=linea + 1>
    </cfloop>
    <cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'DeduccionISR')>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#columna#" charset="utf-8">
	<cfheader name="Content-Disposition" value="inline;filename=Deduccion.csv">
	<cfcontent file="#txtfile#" type="attachment/msexcel" deletefile="yes">

  <!---  <cf_dump var = "#rsSelect#">--->
    <!---<cfthrow message="#tipoNomina#">--->
	<!---	<!---<cf_dump var = "#form#">
    <cfquery name="rsSelectNomina" datasource="#session.DSN#">
    	select 1 as existe
        from RHAjusteAnualNomina rhaan inner join RHAjusteAnual rhaa on rhaan.RHAAid= rhaa.RHAAid
		where Ecodigo = #session.Ecodigo#
			and rhaan.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TNomina#">
            and rhaan.RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHAAid#">
    </cfquery>--->

<!---    <cfset valido = #rsSelectNomina.existe#>
    <cfthrow message="#valido#">--->

    <cfif form.CPcodigo NEQ ''>
    	<cfif #rsSelectNomina.existe# NEQ 1>
			<cfquery name="rsInsertNonima" datasource="#session.DSN#">
				insert into RHAjusteAnualNomina (RHAAid,Tcodigo,CPid,CPcodigo)
        		values (
        		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHAAid#">,
        		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TNomina#">,
       			(select CPid from CalendarioPagos
				 where Ecodigo = #session.Ecodigo#
 					and CPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CPcodigo)#">
 					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TNomina#">),
        	   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CPcodigo)#">)
             </cfquery>
         <cfelse>
         	<cf_throw message = "Ya se eligio esa nomina" >
         </cfif>
     </cfif>
    <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=4">
<cfelseif isdefined("Form.hdAccion") and Form.hdAccion EQ 'BAJAN'>
	<cfquery name="rsDeleteN" datasource="#session.DSN#">
    	delete from RHAjusteAnualNomina
        where RHAAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHAAid#">
        	and Tcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hdTcodigo#">
    </cfquery>
    <cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-form.cfm?RHAAid=#Form.RHAAid#&tab=4">--->
<cfelseif isdefined("BTN_Aplicar")>
	<cfquery datasource="#session.DSN#">
    	update RHAjusteAnual
        set
       		RHAAEstatus = 1
        where RHAAid  = 	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHAAid#">
        	and Ecodigo =        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
   	<cflocation url="/cfmx/rh/nomina/procesoanual/AjusteAnual-lista.cfm">
</cfif>


