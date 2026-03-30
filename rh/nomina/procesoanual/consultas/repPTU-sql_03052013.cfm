<!---<cf_dump var = "#form#">--->
<!---<cfif isdefined('form.Tcodigo') and len(form.tcodigo) GT 0>
	<cfset Tcodigo = #form.Tcodigo#>
<cfelse>
	<cf_throw message = "Elige una nomina">
</cfif>--->

<cfsetting requesttimeout="14400">

<cfif isdefined('form.FechaDesde') and len(form.FechaDesde) GT 0>
	<cfset FechaDesde = #form.FechaDesde#>
</cfif>

<cfif isdefined('form.FechaHasta') and len(form.FechaHasta) GT 0>
	<cfset FechaHasta = #form.FechaHasta#>
</cfif>

<cfif isdefined('form.FechaCorte') and len(form.FechaCorte) GT 0>
	<cfset FechaCorte = #LSDateFormat(form.FechaCorte,'yyyy-mm-dd')#>
</cfif>


<cf_dbtemp name="DatosEmpleado" returnvariable="DatosEmpleado">
		<cf_dbtempcol name="DEid"   	type="int"          mandatory="yes">
        <cf_dbtempcol name="DEidentificacion" type="int"    mandatory="no">
        <cf_dbtempcol name="Ecodigo" 	type="numeric"    	mandatory="no">
		<cf_dbtempcol name="Nombre" 	type="char(100)"    mandatory="no">
		<cf_dbtempcol name="ApPa" 		type="char(80)"     mandatory="no">
        <cf_dbtempcol name="ApMa" 		type="char(80)"     mandatory="no">
		<cf_dbtempcol name="FeAlta" 	type="datetime"     mandatory="no">
		<cf_dbtempcol name="FeFini" 	type="datetime"   	mandatory="no">
        <cf_dbtempcol name="Tcodigo"	type="char(2)"   	mandatory="no">
        <cf_dbtempcol name="DiasTraT"	type="int"   		mandatory="no">
        <cf_dbtempcol name="DiasTra"	type="int"   		mandatory="no">
        <cf_dbtempcol name="DiasFal"	type="int"   		mandatory="no">
        <cf_dbtempcol name="DiasInc"	type="int"   		mandatory="no">
        <cf_dbtempcol name="SueldoAnual"type="money"   		mandatory="no">
</cf_dbtemp>

<cfquery datasource="#session.DSN#" name = "Prueba">
		insert into #DatosEmpleado# (DEid,Ecodigo,DEidentificacion,Nombre,ApPa,ApMa,FeAlta,FeFini)
        select a.DEid,a.Ecodigo,e.DEidentificacion,e.DEnombre,e.DEapellido1,e.DEapellido2, 
			min(a.LTdesde) as FechaDesde, max(a.LThasta) as FechaHasta
            		from LineaTiempo a 
            			inner join EVacacionesEmpleado b
                			on b.DEid = a.DEid
                        inner join DatosEmpleado e on b.DEid = e.DEid
            		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            			<!---and a.DEid =  283--->
            		group by a.DEid, b.EVfantig, a.Ecodigo,e.DEidentificacion,e.DEnombre,e.DEapellido1,e.DEapellido2
</cfquery>

	<cfquery datasource="#session.DSN#" name="prueba"> 
         delete from #DatosEmpleado#
         where FeFini < <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">
    </cfquery>
            
    <cfquery datasource="#session.DSN#" name="prueba"> 
    	delete from #DatosEmpleado#
    	where FeAlta > <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
	</cfquery>
    
    <!---Elimina aquellos empleados que fueron nombrados despues de la fecha de corte--->
	<cfquery datasource="#session.DSN#" name="prueba"> 
    	delete from #DatosEmpleado#
    	where FeAlta > <!---'#LSDateFormat(FechaCorte,'yyyymmdd')#' ---><cfqueryparam cfsqltype="cf_sql_date" value="#FechaCorte#">
	</cfquery>
    
    <cfquery name="rsEmpleados" datasource="#session.DSN#">
        	select 
            	DEid, 
                Ecodigo,
                FeAlta, 
                FeFini 
            from #DatosEmpleado#
    </cfquery>
    
    <cfloop query="rsEmpleados">
			<cfset LvarDeid 	  = rsEmpleados.DEid>
            <cfset LvarFechaDesde = rsEmpleados.FeAlta>
            <cfset LvarFechaHasta = rsEmpleados.FeFini>
            <cfset LvarEcodigo = rsEmpleados.Ecodigo>

        	<cfset LvarDiasAPagar = fnDiasPagar(LvarDeid,LvarEcodigo,FechaDesde,LvarFechaDesde,LvarFechaHasta,FechaHasta)>
            
            <cfquery datasource="#session.DSN#"> 
    			update #DatosEmpleado#
        		set DiasTra = #LvarDiasAPagar#
        		where DEid = #rsEmpleados.DEid#
	    	</cfquery>
             
		     <cfset LvarSueldoAnual 	= fnSueldoAnual(LvarDeid,FechaDesde,FechaHasta,LvarEcodigo)>   
     			<cfquery datasource="#session.DSN#">
            			update #DatosEmpleado#
                		set SueldoAnual = #LvarSueldoAnual#
                		where DEid = #rsEmpleados.DEid#
            	</cfquery>
        </cfloop>
        
        
<cfinclude template="repPTU-rep.cfm">
        

	<cffunction name="fnDiasPagar" access="public" output="true" returntype="numeric"  hint="Calculos de Días a Pagar">
		<cfargument name="DEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
        <cfargument name="Ecodigo" type= "numeric" required="yes">
        <cfargument name="varFechaDesde" type="date" required="yes" hint="Fecha Desde del PTU">
        <cfargument name="FvarFechaDesde" type="date" required="yes" hint="Fecha Desde">
        <cfargument name="FvarFechaHasta" type="date" required="yes" hint="Fecha Hasta">
        <cfargument name="varFechaHasta" type="date" required="yes" hint="Fecha hasta del PTU">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
        
        <cfquery name="rsLineaTiempo" datasource="#arguments.conexion#">
            select b.EVfantig, min(a.LTdesde) as LTdesde, max(LThasta) as LThasta
            from LineaTiempo a 
            inner join EVacacionesEmpleado b
                on b.DEid = a.DEid
            where a.Ecodigo = #arguments.Ecodigo#
            and a.DEid = #arguments.DEid#
            group by a.DEid, b.EVfantig
    	</cfquery>

        <cfif rsLineaTiempo.recordcount gt 0>
		   
		   <cfset LvarFechaDesde = 0>
           
		   <cfif DateCompare(rsLineaTiempo.EVfantig, rsLineaTiempo.LTdesde, 'd') LTE 0>
                <cfif DateCompare(rsLineaTiempo.LTdesde, arguments.FvarFechaDesde, 'd') LTE 0>
                	<cfif arguments.FvarFechaDesde GT arguments.varFechaDesde>
                    	<cfset LvarFechaDesde = arguments.FvarFechaDesde>
                    <cfelse>
                    	<cfset LvarFechaDesde = arguments.varFechaDesde>
                    </cfif>   
                <cfelse>
                	<cfif arguments.FvarFechaDesde GT arguments.varFechaDesde>
                    	<cfset LvarFechaDesde = arguments.FvarFechaDesde>
                    <cfelse>
                    	<cfset LvarFechaDesde = arguments.varFechaDesde>
                    </cfif>   
                </cfif>
            <cfelse>
                <cfif DateCompare(rsLineaTiempo.LTdesde, arguments.FvarFechaDesde, 'd') LTE 0>
                	<cfif arguments.FvarFechaDesde GT arguments.varFechaDesde>
                    	<cfset LvarFechaDesde = arguments.FvarFechaDesde>
                    <cfelse>
                    	<cfset LvarFechaDesde = arguments.varFechaDesde>
                    </cfif>
                    
                <cfelse>
                	<cfif arguments.FvarFechaDesde GT arguments.varFechaDesde>
                    	<cfset LvarFechaDesde = arguments.FvarFechaDesde>
                    <cfelse>
                    	<cfset LvarFechaDesde = arguments.varFechaDesde>
                    </cfif>   
                </cfif>
            </cfif>
           
            <!--- La fecha hasta solo compara LThasta contra FechaHasta Periodo PTU --->
            <cfset LvarFechaHasta = 0>
            <cfif DateCompare(rsLineaTiempo.LThasta, arguments.varFechaHasta, 'd') GT 0><!--- Entra1<br> --->
                <cfset LvarFechaHasta = arguments.varFechaHasta>
            <cfelse><!--- Entra2<br> --->
                <cfset LvarFechaHasta = rsLineaTiempo.LThasta>
            </cfif>
            
            <cfset LvarDias = DateDiff("d", LvarFechaDesde, LvarFechaHasta)+1> <!---  FechaHasta - FechaDesde --->

			<!--- Puede ser que se quieran los días nómina pero tienen que confirmar los 360 días, en vez de los 365, se deja la prevista
			 <cfquery name="rsDiasNomina" datasource="#arguments.conexion#">
				select sum(a.PEcantdias) as PEcantdias
				from HPagosEmpleado a
					inner join HRCalculoNomina b
					on b.RCNid = a.RCNid
				where and b.RCdesde >= '#LvarFechaDesde#'
					and b.RChasta <= '#LvarFechaHasta#'
					and a.DEid = #arguments.DEid#
					and a.PEtiporeg = 0 <!--- Normales --->
			</cfquery>
            <cfset LvarDias = 0>
            <cfif isdefined("rsDiasNomina") and rsDiasNomina.recordcount gt 0>
            	<cfset LvarDias = rsDiasNomina.PEcantdias>
            </cfif> --->
			
            <cfquery name="rsTcodigo" datasource="#arguments.conexion#">
            	select top 1 Tcodigo from LineaTiempo 
				where Ecodigo = #arguments.Ecodigo#
					and DEid = #arguments.DEid#
				order by LTid desc
            </cfquery>
            
            <cfif isdefined('rsTcodigo') and rsTcodigo.RecordCount GT 0 and rsTcodigo.Tcodigo EQ '01'>
            	<cfif LvarDias gte 360>
                	<cfset LvarDias = 366>
           		</cfif>
            <cfelse>
            	<cfif LvarDias gt 366>
                	<cfset LvarDias = 366>
            	</cfif>
            </cfif>
            
            <cfquery datasource="#session.DSN#"> 
    			update #DatosEmpleado#
        		set DiasTraT = #LvarDias#
        		where DEid = #arguments.DEid#
	    	</cfquery>            
            
            <cfset LvarDiasFalta = 0>
                <cfquery name="rsDiasFalta" datasource="#arguments.conexion#">
                    select coalesce(sum(b.PEcantdias),0) as DiasFalta
                    from HRCalculoNomina a
                        inner join HPagosEmpleado b
                          on b.RCNid = a.RCNid
                        inner join RHTipoAccion c
                          on c.RHTid = b.RHTid
                    where b.DEid = #arguments.DEid#
                        and c.RHTcomportam = 13 <!--- Ausencia / Falta --->
                        and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
                        and a.Ecodigo = #arguments.Ecodigo#
                        and a.RCdesde >= '#LSDateFormat(varFechaDesde)#'
                        and a.RChasta <= '#LSDateFormat(varFechaHasta)#'
                        and b.PEdesde >= '#LSDateFormat(varFechaDesde)#'
                        and b.PEhasta <= '#LSDateFormat(varFechaHasta)#'
                </cfquery>
                
                <cfif rsDiasFalta.recordcount gt 0 and rsDiasFalta.DiasFalta gt 0>
                    <cfset LvarDiasFalta = rsDiasFalta.DiasFalta * -1>
                </cfif>
                
             <cfquery datasource="#session.DSN#"> 
    			update #DatosEmpleado#
        		set DiasFal = #LvarDiasFalta#
       			where DEid = #arguments.DEid#
	    	</cfquery>
            
            <cfset LvarDiasIncapacidad = 0>
                <cfquery name="rsDiasIncapacidad" datasource="#arguments.conexion#">
                    select coalesce(sum(b.PEcantdias),0) as DiasIncapacidad
                    from HRCalculoNomina a
                        inner join HPagosEmpleado b
                          on b.RCNid = a.RCNid
                        inner join RHTipoAccion c
                          on c.RHTid = b.RHTid
                    where b.DEid = #arguments.DEid#
                        and c.RHTcomportam = 5 <!--- Incapacidad --->
                        and c.RHTsubcomportam = 2
                        and b.PEtiporeg = 0 <!--- Tipo de Registro: 0 :Normal --->
                        and a.Ecodigo = #arguments.Ecodigo#
                        and a.RCdesde >= '#LSDateFormat(varFechaDesde)#'
                        and a.RChasta <= '#LSDateFormat(varFechaHasta)#'
                        and b.PEdesde >= '#LSDateFormat(varFechaDesde)#'
                        and b.PEhasta <= '#LSDateFormat(varFechaHasta)#'
                </cfquery>
                
                <cfif rsDiasIncapacidad.recordcount gt 0 and rsDiasIncapacidad.DiasIncapacidad gt 0>
                    <cfset LvarDiasIncapacidad = rsDiasIncapacidad.DiasIncapacidad * -1>
                </cfif>
            
            <cfquery datasource="#session.DSN#"> 
    			update #DatosEmpleado#
        		set DiasInc = #LvarDiasIncapacidad#
        		where DEid = #arguments.DEid#
	    	</cfquery>
            
            <!--- <cfoutput>dias: #LvarDias#</cfoutput><br>
            <cfoutput>diasFalta: #LvarDiasFalta#</cfoutput><br> --->
            <cfset LvarResultado = LvarDias + (LvarDiasFalta) + (LvarDiasIncapacidad)>
        <cfelse>
        	 <cfset LvarResultado = 0>
        </cfif> 
        
        <cfquery datasource="#arguments.conexion#">
        	update #DatosEmpleado#
            	set FeAlta = '#LSDateFormat(LvarFechaDesde,'yyyymmdd')#',
                FeFini = '#LSDateFormat(LvarFechaHasta,'yyyymmdd')#'
            where DEid = #arguments.DEid#
        </cfquery>
        
        <cfreturn LvarResultado>
    </cffunction>
    
    <cffunction name="fnSueldoAnual" access="public" output="true" returntype="numeric"  hint="Calculos de Días a Pagar">
		<cfargument name="DEid" type="numeric" required="yes" hint="ID del encabezado del PTU (tab1)">
        <cfargument name="FechaDesde" type="date" required="yes" hint="Fecha Desde">
        <cfargument name="FechaHasta" type="date" required="yes" hint="Fecha Hasta">  
        <cfargument name="Ecodigo" type="numeric" required="yes">       
        
        <cf_dbtemp name = "PTUSueldoAcumulado" datasource = "#session.DSN#" returnvariable = "PTUSueldoAcumulado">
        <cf_dbtempcol name="DEid"				type="int"				mandatory="no">
		<cf_dbtempcol name="SalarioAcumulado" 	type="money"			mandatory="no">
    	</cf_dbtemp>
        
     <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #PTUSueldoAcumulado# (DEid,SalarioAcumulado)
        	select hse.DEid,sum(hse.SEsalariobruto)
			from HSalarioEmpleado hse  
	 			inner join HRCalculoNomina hrc on hse.RCNid = hrc.RCNid 
    		where Ecodigo = #arguments.Ecodigo# 
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#"> 
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#"> 
                and hse.DEid = #arguments.DEid#
			group by hse.DEid
		</cfquery>
        
        <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #PTUSueldoAcumulado# (DEid,SalarioAcumulado)
        	select hse.DEid,sum(hse.ICmontores)
			from HIncidenciasCalculo hse  
	 			inner join HRCalculoNomina hrc on hse.RCNid = hrc.RCNid 
	 			inner join CIncidentes ci on ci.CIid = hse.CIid 
    		where hrc.Ecodigo = #arguments.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#"> 
                and hse.DEid = #arguments.DEid#
                and ci.CIid in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'IExtraSueldo'	
								where c.RHRPTNcodigo = 'PR003'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #arguments.Ecodigo#)
			group by hse.DEid
		</cfquery>
        
        
    	<cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #PTUSueldoAcumulado# (DEid,SalarioAcumulado)
			select se.DEid,sum(se.SEsalariobruto)
			from SalarioEmpleado se  
	 			inner join RCalculoNomina rc on se.RCNid = rc.RCNid 
			where Ecodigo = #arguments.Ecodigo# 
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaDesde#">  
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#FechaHasta#">
                and se.DEid = #arguments.DEid#
			group by se.DEid
    	</cfquery>
        
         <cfquery name="rsInsertSalario_temp" datasource="#session.DSN#">
    	insert into #PTUSueldoAcumulado# (DEid,SalarioAcumulado)
        	select hse.DEid,sum(hse.ICmontores)
			from IncidenciasCalculo hse  
	 			inner join RCalculoNomina hrc on hse.RCNid = hrc.RCNid 
	 			inner join CIncidentes ci on ci.CIid = hse.CIid 
    		where hrc.Ecodigo = #arguments.Ecodigo#
	  			and RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaDesde#">
	  			and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.FechaHasta#"> 
                and hse.DEid = #arguments.DEid#
                and ci.CIcodigo in (select distinct a.CIid
								from RHReportesNomina c
									inner join RHColumnasReporte b
												inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
										 on b.RHRPTNid = c.RHRPTNid
										and b.RHCRPTcodigo = 'IExtraSueldo'	
								where c.RHRPTNcodigo = 'PR003'				<!--- Codigo Reporte Dinamico --->
								  and c.Ecodigo = #arguments.Ecodigo#)
			group by hse.DEid
		</cfquery>
        
        <cfquery name="rsSueldoAnual" datasource="#session.DSN#">
			select coalesce(sum(SalarioAcumulado),0) as SueldoAnual
			from #PTUSueldoAcumulado#
	 		group by DEid
    	</cfquery>
        
        <!---<cf_dump var = "#rsSueldoAnual#">--->
        
        <!---<cfquery name="rsSueldoAnual" datasource="#arguments.conexion#">
        	select 
            	coalesce(sum(PEmontores),0) as SueldoAnual
            from HRCalculoNomina a
                inner join HPagosEmpleado b
                  on b.RCNid = a.RCNid
            where b.DEid = #arguments.DEid#
                and a.RCdesde >= '#arguments.FechaDesde#'
                and a.RChasta <= '#arguments.FechaHasta#'
                and b.PEdesde >= '#arguments.FechaDesde#'
                and b.PEhasta <= '#arguments.FechaHasta#'
        </cfquery>--->
		<cfif isdefined('rsSueldoAnual') and  rsSueldoAnual.RecordCount GT 0>
        <cfset LvarResultado = rsSueldoAnual.SueldoAnual>
        <cfelse>
        <cfset LvarResultado = 0>
        </cfif>
        <cfreturn LvarResultado>
    </cffunction>