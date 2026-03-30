<cfsetting requestTimeout = "3600">
<!---<cf_dump var = "#form#">--->
<cfif isdefined("Form.btnAgregarCP")>
	<!--- Crear la tabla temporal de Incidencias--->
	<cf_dbtemp name="Inc_CalcFOA" returnvariable="IncidenciasCalculoFOA" datasource="#Session.DSN#">
			<cf_dbtempcol name="DEid"   		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CIid"   		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="CFid"   		type="numeric"  mandatory="no">
			<cf_dbtempcol name="Ifecha" 		type="datetime" mandatory="yes">
			<cf_dbtempcol name="Ivalor" 		type="money"    mandatory="yes">
			<cf_dbtempcol name="Ifechasis"   	type="datetime" mandatory="yes">
			<cf_dbtempcol name="Usucodigo"   	type="numeric"  mandatory="no">
			<cf_dbtempcol name="Ulocalizacion"  type="char(2)"  mandatory="no">
			<cf_dbtempcol name="BMUsucodigo"   	type="numeric"  mandatory="no">
			<cf_dbtempcol name="Iespecial"   	type="integer"  mandatory="no">
			<cf_dbtempcol name="RCNid"   		type="numeric"  mandatory="no">
			<cf_dbtempcol name="Mcodigo"   		type="numeric"  mandatory="no">
			<cf_dbtempcol name="RHJid"   		type="numeric"  mandatory="no">
			<cf_dbtempcol name="Imonto"   		type="money"    mandatory="no">
	</cf_dbtemp>

	<!---<cfflush interval="20">--->
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Procesando_el_Registro_Numero"
		Default="Procesando el Registro Numero"
		returnvariable="LB_Procesando_el_Registro_Numero"/>
    
	<cftransaction action="begin">
		<cfquery datasource="#Session.DSN#">
			insert into RCalculoNomina (
                RCNid,
                RCDescripcion,
                Ecodigo,
                Tcodigo,
                RCdesde,
                RChasta,
                RCestado,
                Usucodigo,
                Ulocalizacion,
                RCpagoentractos,
                RCporcentaje,
                RHCFOAid)
			values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RCDescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RCdesde)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RChasta)#">,
                0,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
                0, 
                null,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">)
		</cfquery>
                
		<cfquery datasource="#session.DSN#">
        	insert into SalarioEmpleado 
            (
              RCNid, 
              DEid, 
              SEsalariobruto, 
              SEincidencias, 
              SEcargasempleado, 
              SEcargaspatrono, 
              SErenta, 
              SEdeducciones, 
              SEliquido, 
              SEacumulado, 
              SEproyectado,
              SEcalculado,
              SEespecie
             )
            select
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">, 
              b.DEid, 
              0, 
              b.RHDCFOAempleado + b.RHDCFOAempresa + b.RHDCFOAmonto, 
              0, 
              0, 
              0,
              0, 
              b.RHDCFOAempleado + b.RHDCFOAempresa + b.RHDCFOAmonto,
              0, 
              0,
              1,
              0
            from RHCierreFOA a inner join RHDCierreFOA b 
				on b.RHCFOAid= a.RHCFOAid
				where a.RHCFOAid =<cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and not exists ( select 1
                             from SalarioEmpleado i
                             where i.DEid = b.DEid
                               and i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
							)
              and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
        </cfquery>
        
        <!---Agregar Concepto de Pago de Acum Empresa--->
        <cfquery name="rsIncEmpresa" datasource="#session.DSN#">
        	select distinct a.CIid
            from RHReportesNomina c
            	inner join RHColumnasReporte b
                inner join RHConceptosColumna a
                	on a.RHCRPTid = b.RHCRPTid
                    on b.RHRPTNid = c.RHRPTNid
                    and b.RHCRPTcodigo = '01' 	
            where c.RHRPTNcodigo = 'PR004'				
                 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 and a.CIid is not null
        </cfquery>
        
	    <cfset CIidEmpresa = #rsIncEmpresa.CIid#>
        
		<cfquery datasource="#Session.DSN#">
			insert into IncidenciasCalculo(
                RCNid,
                DEid,
                CIid,
                ICfecha,
                ICvalor,
                ICfechasis,
                Usucodigo,
                Ulocalizacion,
                ICmontoant,
                ICmontores
                )
                
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">, b.DEid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidEmpresa#">, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RCdesde)#">, b.RHDCFOAempresa as TotalInci,
            		#now()#,
                    #session.Usucodigo#,
                    '00' as localizacion,
                    0 as cero,
                     b.RHDCFOAempresa
			from RHCierreFOA a inner join RHDCierreFOA b 
				on b.RHCFOAid= a.RHCFOAid
			where a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
		</cfquery>
        
        <!---Agregar Concepto de Pago de Acum Empleado--->
        <cfquery name="rsIncEmpleado" datasource="#session.DSN#">
        	select distinct a.CIid
            from RHReportesNomina c
            	inner join RHColumnasReporte b
                inner join RHConceptosColumna a
                	on a.RHCRPTid = b.RHCRPTid
                    on b.RHRPTNid = c.RHRPTNid
                    and b.RHCRPTcodigo = '02' 	
            where c.RHRPTNcodigo = 'PR004'				
                 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 and a.CIid is not null
        </cfquery>
        
         <cfset CIidEmpleado = #rsIncEmpleado.CIid#>
         
		<cfquery datasource="#Session.DSN#">
			insert into IncidenciasCalculo(
                RCNid,
                DEid,
                CIid,
                ICfecha,
                ICvalor,
                ICfechasis,
                Usucodigo,
                Ulocalizacion,
                ICmontoant,
                ICmontores
                )
                
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">, b.DEid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CIidEmpleado#">, <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RCdesde)#">, b.RHDCFOAempleado as TotalInci,
            		#now()#,
                    #session.Usucodigo#,
                    '00' as localizacion,
                    0 as cero,
                     b.RHDCFOAempresa
			from RHCierreFOA a inner join RHDCierreFOA b 
				on b.RHCFOAid= a.RHCFOAid
			where a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
		</cfquery>
        
        <!---Agregar Interes de FOA--->
        <cfquery name="rsIncEmpleado" datasource="#session.DSN#">
        	select distinct a.CIid
            from RHReportesNomina c
            	inner join RHColumnasReporte b
                inner join RHConceptosColumna a
                	on a.RHCRPTid = b.RHCRPTid
                    on b.RHRPTNid = c.RHRPTNid
                    and b.RHCRPTcodigo = '03' 	
            where c.RHRPTNcodigo = 'PR004'				
                 and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 and a.CIid is not null
        </cfquery>
        
        <cfset CInteres = #rsIncEmpleado.CIid#>
		<cfquery datasource="#Session.DSN#">
			insert into IncidenciasCalculo(
                RCNid,
                DEid,
                CIid,
                ICfecha,
                ICvalor,
                ICfechasis,
                Usucodigo,
                Ulocalizacion,
                ICmontoant,
                ICmontores
                )
                
            select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">, b.DEid, <cfqueryparam cfsqltype="cf_sql_numeric" value="#CInteres#">, 
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RCdesde)#">, b.RHDCFOAmonto as TotalInci,
            		#now()#,
                    #session.Usucodigo#,
                    '00' as localizacion,
                    0 as cero,
                    b.RHDCFOAmonto
			from RHCierreFOA a inner join RHDCierreFOA b 
				on b.RHCFOAid= a.RHCFOAid
			where a.RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHCFOAid#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and b.Tcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Tcodigo#">
		</cfquery>
        
       <!--- SML deducciones--->
       
       <cfset vFechaDefault = createdate(6100,01,01) >
    	<cfquery datasource = "#session.DSN#" name="rsEmpresa"> <!---SML Modificacion para guardar los calculos de PTU en su empresa correspondiente--->
			select Ecodigo,Tcodigo,CPdesde,CPhasta from CalendarioPagos 
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		</cfquery>
        
       <cfquery datasource="#session.DSN#">
			insert into DeduccionesCalculo (Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, DCmontoant, DCcalculo)
            select b.Did, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">, a.DEid, 
            case when b.Dcontrolsaldo = 0 then b.Dvalor
				 when b.Dcontrolsaldo = 1 then b.Dsaldo
			end
            , 0.00, null, 0.00, 0
            from SalarioEmpleado a
            inner join DeduccionesEmpleado b
                on b.DEid = a.DEid
				and b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  <!---Le agregue Ecodigo--->
            inner join TDeduccion c
                on c.TDid = b.TDid
				and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  <!---Le agregue Ecodigo --->
            inner join RHIncluirDeduccion d on d.TDid = b.TDid and d.CPid =a.RCNid
            where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              and b.Dactivo = 1
              <!---and Dmetodo = 1--->
              and b.Dfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpresa.CPhasta#">
             and coalesce(b.Dfechafin,<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaDefault#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpresa.CPdesde#">                            
		</cfquery>
        
        <cfquery datasource="#session.DSN#" name="DeduccionesEspeciales">
			update SalarioEmpleado
        	set SEcalculado = 0
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">   
		</cfquery>
        
        <cfquery datasource="#session.DSN#" name="DeduccionesEspeciales">
		select a.TDid, e.DEid
    		from TDeduccion a
    		inner join FDeduccion b on a.TDid = b.TDid
     		inner join DeduccionesEmpleado e on a.TDid = e.TDid and e.Destado = 1
 	 	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.Ecodigo#">
    		and a.TDrenta = 0
    		and a.TDid not in 
    		(select TDid
			from RHExcluirDeduccion
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">)   
		</cfquery>
        
        <cfset Arguments.RCNid = #form.RCNid#>
		<cfloop query="DeduccionesEspeciales">
        	<cfset Arguments.pDEid = #DeduccionesEspeciales.DEid#>
			<cfquery datasource="#session.DSN#" name="formula">
				select FDformula, FDcfm
				from FDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
			</cfquery>

			<cfif len(trim(formula.FDcfm))>
				<cfinclude template="#trim(formula.FDcfm)#">
			</cfif>	
		</cfloop>   
        
         <cfquery datasource="#session.DSN#" name="DeduccionesEspeciales">
			update SalarioEmpleado
        	set SEcalculado = 1,
            	SEliquido = SEliquido - SEdeducciones
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                   
		</cfquery>     
        
        <cftransaction action="commit"/>
	</cftransaction>

	<cfinclude template="FondoAhorro-form.cfm">
</cfif>

<cfif not isdefined("form.btnEliminar") and not isdefined("form.btnAplicar")>
	<cfif isdefined('url.Primera') and isdefined('url.RHCFOAID') >
		<cfinclude template="FondoAhorro-form.cfm">
	</cfif>
</cfif>


<cfif not isdefined("form.btnEliminar") and not isdefined("form.btnAplicar") >
	<cfif isdefined('url.Segunda') and isdefined('url.RHCFOAID')>
		<cfinclude template="FondoAhorro-form.cfm">
	</cfif>
</cfif>

<cfif isdefined("form.btnEliminar")>
	<cfif isdefined('form.chk') and len(trim(form.chk)) GT 0>
    
    <cfset CPid = #form.chk#>
    
    <cfquery name="deleteIncidenciasCalculo" datasource="#session.DSN#">
    	delete from DeduccionesCalculo
        where RCNId = #CPid#
    </cfquery>
    
    <cfquery name="deleteIncidenciasCalculo" datasource="#session.DSN#">
    	delete from IncidenciasCalculo
        where RCNId = #CPid#
    </cfquery>
    
    <cfquery name="deleteSalarioEmpleado" datasource="#session.DSN#">
    	delete from SalarioEmpleado
        where RCNId = #CPid#
    </cfquery>
    
    <cfquery name="deleteRCalculoNomina" datasource="#session.DSN#">
    	delete from RCalculoNomina
        where RCNId = #CPid#
	</cfquery>
    </cfif>
    <cfinclude template="FondoAhorro-form.cfm">
</cfif>

<cfif isdefined("form.btnFiltrar")>
		<cfset form.tab = 4>
        <cfset url.Primera = 1>
		<cfinclude template="FondoAhorro-form.cfm">
</cfif>

<cfif isdefined("form.btnAplicar")>

	<!---<cf_dump var = "#url#">
    <cf_dump var = "#form#">--->
	<!---<cfquery name="rsUpdateFOA" datasource="#session.DSN#">
    	update RHCierreFOA
        set RHCFOAestatus = 2
		 where RHCFOAid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.RHCFOAid#">
    </cfquery>--->
	<cfset Form.tab = 5>
	<cfinclude template="FondoAhorro-form.cfm">
</cfif>
