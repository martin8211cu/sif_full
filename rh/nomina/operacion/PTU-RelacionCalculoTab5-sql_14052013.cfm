<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfsetting requestTimeout = "3600">

<cf_templatecss>

<cfset action = "PTU.cfm">
<cfif isdefined("Form.btnAplicar")>
	<!--- Crear la tabla temporal de Incidencias--->
	<cf_dbtemp name="Inc_CalcPTU" returnvariable="IncidenciasCalculoPTU" datasource="#Session.DSN#">
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

	<cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	</cfoutput>
	
	<cfflush interval="20">
	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Procesando_el_Registro_Numero"
		Default="Procesando el Registro Numero"
		returnvariable="LB_Procesando_el_Registro_Numero"/>
    
	<cftransaction action="begin">
    	
    	<cfset vFechaDefault = createdate(6100,01,01) >
    	<cfquery datasource = "#session.DSN#" name="rsEmpresa"> <!---SML Modificacion para guardar los calculos de PTU en su empresa correspondiente--->
			select Ecodigo,Tcodigo,CPdesde,CPhasta from CalendarioPagos 
            where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		</cfquery>
        
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
                CIid,
                RHPTUEid)
			values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RCDescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresa.Tcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RCdesde)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RChasta)#">,
                0,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
                0, 
                null, 
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
                )
		</cfquery>
        
        <!--- Esto se pude descomentar para debuguear
		 <cfdump var="#form#">
        <cfdump var="#url#">
        <cfquery datasource="#session.DSN#" name="rs">
            select <!---count(1)--->
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">, 
              a.DEid, 
              xx.DEnombre || ' ' || xx.DEapellido1 || ' '  || xx.DEapellido2 as empleado,
              a.RHPTUEMTotalPTU, 
              a.RHPTUEMISPTRetencionPTU, 
              a.RHPTUEMNetaRecibir, d.CPcodigo, d.Tcodigo
              
            from RHPTUEMpleados a

                inner join LineaTiempo b
                    on b.DEid = a.DEid

                inner join RCalculoNomina c
                    on c.RHPTUEid = a.RHPTUEid
               inner join CalendarioPagos d
                    on d.Ecodigo = b.Ecodigo
                    and d.Tcodigo = b.Tcodigo
               inner join DatosEmpleado xx
               	on xx.DEid = a.DEid
                
            where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
            
              and a.Ecodigo = #session.Ecodigo#
              and a.FechaHasta >= b.LTdesde
              and a.FechaHasta <= b.LThasta
			  and a.RHPTUEMreconocido = 1
              <!--- and d.CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">--->
              and d.Tcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#"> 

              and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              and c.RCestado = 0


              <!--- and d.CPdesde >= b.LTdesde
              and d.CPhasta <= b.LThasta --->
              and d.CPtipo = 4
                
              and not exists ( select 1
                             from SalarioEmpleado i
                             where i.DEid = a.DEid
                               and i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
							)
        </cfquery>
        
        <cfquery name="rs2" datasource="#session.dsn#">
        	select 
                #form.RCNid# as RNCid,
                a.DEid,
                 xx.DEnombre || ' ' || xx.DEapellido1 || ' '  || xx.DEapellido2 as empleado,
                #form.CIid# as CIid,
                c.RChasta,
                a.RHPTUEMNetaRecibir,
                #now()# as now,
                #session.Usucodigo# as Usucodigo,
                '00' as localizacion,
                0 as cero
            from RHPTUEMpleados a

                inner join LineaTiempo b
                    on b.DEid = a.DEid

                inner join RCalculoNomina c
                    on c.RHPTUEid = a.RHPTUEid
               inner join CalendarioPagos d
                    on d.Ecodigo = b.Ecodigo
                    and d.Tcodigo = b.Tcodigo
               inner join DatosEmpleado xx
               	on xx.DEid = a.DEid
            where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
            
              and a.Ecodigo = #session.Ecodigo#
              and a.FechaHasta >= b.LTdesde
              and a.FechaHasta <= b.LThasta
			  and a.RHPTUEMreconocido = 1
              <!--- and d.CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">
              and d.Tcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#"> --->

              and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              and c.RCestado = 0
              and c.RCdesde >= b.LTdesde
              and c.RChasta <= b.LThasta              

              and d.CPdesde >= b.LTdesde
              and d.CPhasta <= b.LThasta
              and d.CPtipo = 4
                and not exists ( select 1
                         from IncidenciasCalculo i
                         where i.DEid=a.DEid
                           and i.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
                           and i.ICfecha = c.RChasta)
             order by a.DEid
        </cfquery>
        
        
		<cfdump var="#rs#">
        <cf_dump var="#rs2#"> --->
        
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
              a.DEid, 
              0, 
              a.RHPTUEMTotalPTU, 
              0, 
              0, 
              a.RHPTUEMISPTRetencionPTU, 
              0, 
              a.RHPTUEMNetaRecibir, 
              0, 
              0,
              0,
              0
            from RHPTUEMpleados a

                inner join LineaTiempo b
                    on b.DEid = a.DEid

                inner join RCalculoNomina c
                    on c.RHPTUEid = a.RHPTUEid
               inner join CalendarioPagos d
                    on d.Ecodigo = b.Ecodigo
                    and d.Tcodigo = b.Tcodigo
                    
            where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
            
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">
              and a.FechaHasta >= b.LTdesde
              and a.FechaHasta <= b.LThasta
			  and a.RHPTUEMreconocido = 1 <!--- solo se consideran los empleados reconocidos --->
              
              and d.CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">
              and d.Tcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">

              and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              and c.RCestado = 0

              and d.CPtipo = 4  <!--- Calendarios tipo PTU --->
                
              and not exists ( select 1
                             from SalarioEmpleado i
                             where i.DEid = a.DEid
                               and i.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
							)
        </cfquery>
		


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
                
                select 
                    #form.RCNid#,
                    a.DEid,
                    #form.CIid#,
                    c.RChasta,
                    a.RHPTUEMTotalPTU,
                    #now()#,
                    #session.Usucodigo#,
                    '00' as localizacion,
                    0 as cero,
                    a.RHPTUEMTotalPTU
                from RHPTUEMpleados a
    
                    inner join LineaTiempo b
                        on b.DEid = a.DEid
    
                    inner join RCalculoNomina c
                        on c.RHPTUEid = a.RHPTUEid
                   inner join CalendarioPagos d
                        on d.Ecodigo = b.Ecodigo
                        and d.Tcodigo = b.Tcodigo
                where a.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
                
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#">
                  and a.FechaHasta >= b.LTdesde
                  and a.FechaHasta <= b.LThasta
		    	  and a.RHPTUEMreconocido = 1 <!--- solo se consideran los empleados reconocidos --->
                  
                  and d.CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">
                  and d.Tcodigo  =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
    
                  and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                  and c.RCestado = 0

                  and d.CPtipo = 4  <!--- Calendarios tipo PTU --->
                  and not exists ( select 1
                         from IncidenciasCalculo i
                         where i.DEid=a.DEid
                           and i.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
                           and i.ICfecha = c.RChasta)
		</cfquery>
        
         <cfquery datasource="#session.DSN#">
			insert into DeduccionesCalculo (Did, RCNid, DEid, DCvalor, DCinteres, DCbatch, DCmontoant, DCcalculo)
            select b.Did, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">, a.DEid, 0.00, 0.00, null, 0.00, 0
            from SalarioEmpleado a
            inner join DeduccionesEmpleado b
                on b.DEid = a.DEid
				and b.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#"> <!--- Le agregue Ecodigo --->
            inner join TDeduccion c
                on c.TDid = b.TDid
				and c.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Ecodigo#"> <!--- Le agregue Ecodigo --->
            where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
              <!---and SEcalculado = 0--->
              and b.Dactivo = 1
              and b.Dfechaini <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpresa.CPhasta#">
             and coalesce(b.Dfechafin,<cfqueryparam cfsqltype="cf_sql_date" value="#vFechaDefault#">) >= <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpresa.CPdesde#">               
               <!---<cfif IsDefined('Arguments.pDEid')>and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>   --->            
                       
		</cfquery>
        
        <!---<cfquery datasource="#session.DSN#" name="exists">
			select 1
			from RHExcluirDeduccion
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
		</cfquery>
        
        
		<cfif exists.RecordCount>--->
			<!---<cfquery datasource="#session.DSN#">
				delete from DeduccionesCalculo
				where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
				and exists ( select de.Did
												from DeduccionesEmpleado de, RHExcluirDeduccion ed
												where de.Did = DeduccionesCalculo.Did
												and ed.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
												and ed.CPid = DeduccionesCalculo.RCNid
												and de.TDid <> ed.TDid 
							)
			</cfquery>--->
         <!---</cfif>--->	
        
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
        
        <!---<cf_dump var = "#DeduccionesEspeciales#">--->

		<cfset Arguments.RCNid = #form.RCNid#>
        <cfset session.Ecodigo = #rsEmpresa.Ecodigo#>
        <cfset Arguments.datasource = #session.DSN#>
        
		<cfloop query="DeduccionesEspeciales">
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
        	set SEcalculado = 1
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RCNid#">
                   
		</cfquery>        
        <cftransaction action="commit"/>
	</cftransaction>

	</body>
	</HTML>

</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="RHPTUEid" type="hidden" value="#Form.RHPTUEid#">
    <input name="tab" type="hidden" value="5">
   	<input name="RCNid" type="hidden" value="#Form.RCNid#">
	<input name="RCDesde" type="hidden" value="#Form.RCDesde#">
	<input name="RCHasta" type="hidden" value="#Form.RCHasta#">
	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>