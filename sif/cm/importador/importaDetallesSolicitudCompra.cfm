<!---mcz--->
<!---======== Tabla temporal de errores  ========--->
<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	<cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery name="rsImportador" datasource="#session.dsn#">
select * from #table_name#
</cfquery>
<!---<cfdump var="#rsImportador#">--->

<cfset idSol = Session.ImportarDetalleSC.idSol>

<cfquery name="rsEnc" datasource="#session.dsn#">
	select * from ESolicitudCompraCM
    where ESidsolicitud=#idSol# and Ecodigo=#session.Ecodigo#
</cfquery>

<cfquery name="rsTipoSolCom" datasource="#session.dsn#">
	select * from CMTiposSolicitud
    where CMTScodigo='#rsEnc.CMTScodigo#'
</cfquery>

<cfloop query="rsImportador">
<cfset Ccodigo=#rsImportador.Ccodigo#>

<cfquery name="check1" datasource="#session.dsn#">
	select count(1) as check1 from  CFuncional
    where Ecodigo=#session.Ecodigo#
    and CFcodigo=<cfqueryparam value="#rsImportador.CFcodigo#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfif check1.check1 EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El Centro Funcional no se encuentra registrado en el sistema(#CFcodigo#)!')
		</cfquery>
	</cfif>

<cfif rsTipoSolCom.CMTSservicio EQ 1>
<!---  Validar si ya existe el codigo de Servicio en el sistema --->
	<cfquery name="check2" datasource="#session.dsn#">
		select count(1) as check2
		from #table_name# a,
		Conceptos b
		where a.Ccodigo = b.Ccodigo
		and b.Ecodigo = #session.Ecodigo#
		and b.Ccodigo='#rsImportador.Ccodigo#'
	</cfquery>	
	<cfif check2.check2 EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		insert into #errores# (Error)
		values ('Error!El servicio no se encuentra registrado en el sistema(#Ccodigo#)!')
		</cfquery>
	</cfif>

	<!--- Validar existencia de Unidades --->
		<cfquery name="check3" datasource="#session.dsn#">
			  select count(1) as check3
			   from #table_name# a
			   where ltrim(rtrim(a.Ucodigo)) <>''
				 and a.Ucodigo is not null
				 and a.Ucodigo='#rsImportador.Ucodigo#'
				 and not exists( select 1 from Unidades b
									   where b.Ucodigo = a.Ucodigo
										  and b.Ecodigo =  #session.Ecodigo#)
				and a.Ccodigo='#Ccodigo#'
			</cfquery>
		<cfif check3.check3 gt 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Codigo de Unidad no esta registrado en el sistema(#check3.Ucodigo#)!')
			</cfquery>
		</cfif>
</cfif>

<cfif rsTipoSolCom.CMTStarticulo EQ 1>
	<cfquery datasource="#session.DSN#" name="check4">
        select count(1) as check4
        from #table_name# a,Almacen b
        where b.Ecodigo= #session.Ecodigo# 
              and b.Almcodigo=a.Alm_Aid 
        	  and b.Almcodigo='#rsImportador.Alm_Aid#'        
	</cfquery>
    
    <cfif check4.check4 EQ 0>
    	<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error!Codigo de Almacen no esta registrado en el sistema(#Alm_Aid#)!')
		</cfquery>
    </cfif>
    <cfquery datasource="#session.DSN#" name="check5">
    	select count(1) as check5
        from Articulos
        where Ecodigo= #session.Ecodigo#
        and Acodigo='#rsImportador.Aid#'
    </cfquery>
      
    <cfif check5.check5 EQ 0>
        <cfquery name="ERR" datasource="#session.DSN#">
                    insert into #errores# (Error)
                    values ('Error!Codigo de Articulo no esta registrado en el sistema(#Aid#)!')
        </cfquery>
    </cfif>    
</cfif>		

<cfif rsTipoSolCom.CMTSactivofijo EQ 1>
	
</cfif>	
		 
	
</cfloop>

		<cfquery name="rsErr" datasource="#session.dsn#">
			select count(1) as cantidad from #errores#
		</cfquery>
		
		<cfif rsERR.cantidad eq 0>
        <!---<cfthrow message="Error ">--->
        
        
        <cfquery name="consecutivod" datasource="#session.DSN#">
			select max(DSconsecutivo) as linea
			from DSolicitudCompraCM
			where ESidsolicitud = <cfqueryparam value="#idSol#" cfsqltype="cf_sql_numeric">
		</cfquery>
        <cfset linea = 0>
		<cfif consecutivod.RecordCount gt 0  and len(consecutivod.linea)>
			<cfset linea = consecutivod.linea >
        </cfif>
        <cfdump var ="#linea#">
        <cfif rsImportador.RecordCount gt 0 >
        <cfloop query="rsImportador">		
			<cfset linea =linea + 1 >
		<cfquery name="rsConServ" datasource="#session.dsn#">
        	select Cid from Conceptos where Ccodigo = '#rsImportador.Ccodigo#' and Ecodigo =#session.Ecodigo#
        </cfquery>
        <cfquery datasource="#session.DSN#" name="rsArticulo">
            select Aid
            from Articulos
            where Ecodigo= #session.Ecodigo#
            and Acodigo='#rsImportador.Aid#'
        </cfquery>
        <cfquery datasource="#session.DSN#" name="rsAlmacen">
            select b.Aid
            from #table_name# a,Almacen b
            where b.Ecodigo= #session.Ecodigo# 
                  and b.Almcodigo=a.Alm_Aid 
                  and b.Almcodigo='#rsImportador.Alm_Aid#'        
        </cfquery>
        <cfquery name="rsCFuncional" datasource="#session.dsn#">
            select  CFid from  CFuncional
            where Ecodigo=#session.Ecodigo#
            and CFcodigo=<cfqueryparam value="#rsImportador.CFcodigo#" cfsqltype="cf_sql_varchar">
        </cfquery>
        
		<cfquery name="rsIns" datasource="#session.dsn#">		
			insert into DSolicitudCompraCM ( Ecodigo, ESidsolicitud, ESnumero, DSconsecutivo, DStipo, Aid, Alm_Aid, Cid, DSdescripcion, DSobservacion, DSdescalterna,  Icodigo,  DScant, DSmontoest, DStotallinest, Ucodigo, DSfechareq, CFid, BMUsucodigo)
						values (<cf_jdbcquery_param value="#session.Ecodigo#" cfsqltype="cf_sql_integer">, 
								<cf_jdbcquery_param value="#idSol#" cfsqltype="cf_sql_numeric">, 
								<cf_jdbcquery_param value="#rsEnc.ESnumero#" cfsqltype="cf_sql_integer">, 
								<cf_jdbcquery_param value="#linea#" cfsqltype="cf_sql_integer">, 
								<cf_jdbcquery_param value="#rsImportador.DStipo#" cfsqltype="cf_sql_char">, 
								<cfif len(trim(rsImportador.Aid)) ><cf_jdbcquery_param value="#rsArticulo.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
								<cfif isdefined("rsImportador.Alm_Aid") and rsImportador.DStipo eq 'A' ><cf_jdbcquery_param value="#rsAlmacen.Aid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
								<cfif len(trim(rsConServ.Cid)) and (rsImportador.DStipo eq 'S' or rsImportador.DStipo eq 'P')><cf_jdbcquery_param value="#rsConServ.Cid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>, 
								
								<cf_jdbcquery_param value="#rsImportador.DSdescripcion#" cfsqltype="cf_sql_varchar">, 
								<cfif len(trim(rsImportador.DSobservacion)) ><cf_jdbcquery_param value="#Mid(rsImportador.DSobservacion,1,255)#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
								<cfif len(trim(rsImportador.DSdescalterna)) ><cf_jdbcquery_param value="#Mid(rsImportador.DSdescalterna, 1, 1024)#" cfsqltype="cf_sql_longvarchar"><cfelse>null</cfif>,
								<cfif len(trim(rsImportador.Icodigo))><cf_jdbcquery_param value="#rsImportador.Icodigo#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,

								<cf_jdbcquery_param value="#rsImportador.DScant#" cfsqltype="cf_sql_float">, 
								#rsImportador.DSmontoest#,
								round(#rsImportador.DScant*rsImportador.DSmontoest#,2),
								<cf_jdbcquery_param value="#trim(rsImportador.Ucodigo)#" cfsqltype="cf_sql_varchar">,
								null,
                                <cfif len(trim(rsImportador.CFcodigo))>
                                    <cf_jdbcquery_param value="#rsCFuncional.CFid#" cfsqltype="cf_sql_numeric">
                                <cfelse>
                                  <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
                                </cfif>,
								
								
								
								#session.Usucodigo#
								
                               )
		</cfquery>
        </cfloop>
        <cfset total = getTotal(idSol) >
				<cfquery name="update" datasource="#session.DSN#">
					update ESolicitudCompraCM
					set EStotalest	  = <cf_jdbcquery_param value="#total#" cfsqltype="cf_sql_money">
                    where ESidsolicitud = <cf_jdbcquery_param value="#idSol#" cfsqltype="cf_sql_numeric">
				</cfquery>
		</cfif>					  
				 
<cfelse>
		<cfquery name="ERR" datasource="#session.DSN#">
			select Error as MSG
			from #errores#
			order by Error
		</cfquery>
		<cfreturn>		
</cfif>		 
		
					
   <!--- Function getTotal --->
<cffunction name="getTotal" returntype="numeric">
	<cfargument name="id" type="numeric" required="yes">

	<cfquery name="rsTotal" datasource="#session.DSN#">
		select coalesce(
                    sum(round(DScant*DSmontoest,2))+
                    sum(round(round(DScant*DSmontoest,2) * Iporcentaje/100,2))
	            ,0) as total
		from ESolicitudCompraCM a
			inner join DSolicitudCompraCM b
				on a.ESidsolicitud=b.ESidsolicitud
			inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
				and b.Icodigo=c.Icodigo
		where a.ESidsolicitud = <cfqueryparam value="#id#" cfsqltype="cf_sql_numeric">
	</cfquery>
	
	<cfif rsTotal.RecordCount gt 0 and len(trim(rsTotal.total))>
		<cfreturn rsTotal.total>
	<cfelse>
		<cfreturn 0 >	
	</cfif>
	
</cffunction>	
							
	