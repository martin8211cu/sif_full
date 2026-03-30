<!---<cfdump var="#form#">
<cf_dump var="#url#"> --->

<!--- Tab1 --->
<cfif isdefined("Form.Alta")>
	<cfquery name="rsInsert" datasource="#session.DSN#">
    	insert into RHPTUE(
        					RHPTUEcodigo,
                            RHPTUEdescripcion,
                            CIid,
                            FechaDesde,
                            FechaHasta,
                            Ecodigo,
                            RHPTUEMonto,
                            BMUsucodigo,
                            BMFecha,
                            RHPTUEDescFaltas,
                            RHPTUEDescIncapa,
                            EIRid,
                            RHPTUECantDias
        					)
        values(
	        	<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPTUEcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPTUEdescripcion#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaDesde)#">,
                <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaHasta)#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHPTUEMonto,',','','ALL')#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                #now()#,
                <cfif isdefined("form.RHPTUEDescFaltas")>1<cfelse>0</cfif>,
                <cfif isdefined("form.RHPTUEDescIncapa")>1<cfelse>0</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IRcodigo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.txtCantDias#">
        		)
    		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#rsInsert.identity#" addtoken="no">
<cfelseif isdefined("form.Cambio")>
	<cfquery datasource="#session.DSN#">
    	update RHPTUE
        set RHPTUEcodigo = 		<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPTUEcodigo#">,
	        RHPTUEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPTUEdescripcion#">,
            CIid = 				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
            FechaDesde = 		<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaDesde)#">,
            FechaHasta = 		<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(form.FechaHasta)#">,
            RHPTUEMonto = 		<cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.RHPTUEMonto,',','','ALL')#">,
            RHPTUEDescFaltas =  <cfif isdefined("form.RHPTUEDescFaltas")>1<cfelse>0</cfif>,
            RHPTUEDescIncapa =  <cfif isdefined("form.RHPTUEDescIncapa")>1<cfelse>0</cfif>,
            EIRid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.IRcodigo#">,
            RHPTUECantDias= <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.txtCantDias)#">
        where RHPTUEid = 		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
    </cfquery>
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#" addtoken="no">
<cfelseif isdefined("form.Baja")>    
	<cftransaction action="begin">
    
	    <!--- <cfquery datasource="#session.DSN#">
            delete from SalarioEmpleado 
            where RCNid in (select RCNid ;; <!--- Revisar bien este delete en caso de que esten 2 calendarios de pagos --->
            				from RCalculoNomina
			            	where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">)
        </cfquery>
    
	    <cfquery datasource="#session.DSN#">
            delete from RCalculoNomina
            where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
        </cfquery> --->
    
        <cfquery datasource="#session.DSN#">
            delete from RHPTUEMpleados
            where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
        </cfquery>
        <cfquery datasource="#session.DSN#">
            delete from RHPTUD
            where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
        </cfquery>
        <cfquery datasource="#session.DSN#">
            delete from RHPTUE
            where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid#">
        </cfquery>
    </cftransaction>
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm" addtoken="no">
<cfelseif isdefined("form.Nuevo")>
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm" addtoken="no">
</cfif>

    
    
 <!--- Tab2 --->   
<cfif isdefined("Form.BTN_Alta")> 
	<cfif isdefined("Form.RHPTUEid") and Len(Trim(Form.RHPTUEid)) >
		<cfif Form.opcion EQ 1>
			<!--- Inserciones para los Centros Funcionales --->
			<!--- Inserta  el Centro Funcional sin Dependencias --->
			<cfquery name="rsCentroFuncional" datasource="#Session.DSN#">
				select RHPTUEid, CFid, Ecodigo, BMUsucodigo 
				from RHPTUD 
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
			</cfquery>
			
			<cfif rsCentroFuncional.recordcount EQ 0 >
				<cfquery name="insertCentroFuncional" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, CFid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>

			<cfif isdefined("Form.CFdependencias") >
				<!--- Selecciona el Path del Centro Funcional --->
				<cfquery name="selectPathCF" datasource="#Session.DSN#">
					select CFpath
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
				</cfquery>
				<!--- Inserta las Dependencias del Centro Funcional --->
				<cfquery name="insertCentroFuncionalDep" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, CFid, Ecodigo, BMUsucodigo)
					select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							CFid, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					from CFuncional
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CFpath like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(selectPathCF.CFpath)#/%">
					and not exists (
						select 1
						from RHPTUD x
						where x.RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
						and x.CFid = CFuncional.CFid
					)
				</cfquery>
			</cfif>

		<cfelseif Form.opcion EQ 2>
			<!--- Inserta Oficina/Departamento --->
			<cfquery name="rsOficinaDepto" datasource="#Session.DSN#">
				select RHPTUEid, Dcodigo, Ocodigo, Ecodigo, BMUsucodigo
				from RHPTUD
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
					and Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
					and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
			</cfquery>

			<cfif rsOficinaDepto.recordcount EQ 0 >
				<cfquery name="insertOficinaDepto" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, Dcodigo, Ocodigo, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
						
		<cfelseif Form.opcion EQ 3>
			<!--- Inserta Tipo de Puesto --->
			<cfquery name="rsPuesto" datasource="#Session.DSN#">
				select RHPTUEid, RHPcodigo, Ecodigo, BMUsucodigo
				from RHPTUD
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
					and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			</cfquery>

			<cfif rsPuesto.recordcount EQ 0 >
				<cfquery name="insertPuesto" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, RHPcodigo, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
			
		<cfelseif Form.opcion EQ 4>
			<!--- Inserta Empleados --->
			<cfquery name="rsEmpleados" datasource="#Session.DSN#">
				select RHPTUEid, DEid, Ecodigo, BMUsucodigo
				from RHPTUD
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
		
			<cfif rsEmpleados.recordcount EQ 0 >
				<cfquery name="insertEmpleados" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, DEid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
		
		<cfelseif Form.opcion EQ 5>
			<!--- Inserta los tipos de puestos --->
			<cfquery name="rsTipoPuesto" datasource="#Session.DSN#">
				select RHPTUEid, RHTPid, Ecodigo, BMUsucodigo
				from RHPTUD
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
				and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">
			</cfquery>
		
			<cfif rsTipoPuesto.recordcount EQ 0 >
				<cfquery name="insertEmpleados" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, RHTPid, Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#form.fecha#">
					)				
				</cfquery>
			</cfif>
            
        <cfelseif Form.opcion EQ 6>
			<!--- Inserta las Empresas --->
            
			<cfquery name="rsTipoEmpresa" datasource="#Session.DSN#">
				select RHPTUEid, RHTPid, Ecodigo, BMUsucodigo
				from RHPTUD
				where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
				<!---and RHTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">--->
			</cfquery>
		
			<cfif rsTipoEmpresa.recordcount GTE 0 >
            	<cfset fcorte = LSDateFormat(#form.fecha#,'yyyy-MM-dd')>
				<cfquery name="insertEmpleados" datasource="#Session.DSN#">
					insert into RHPTUD (RHPTUEid, <!---RHTPid,---> Ecodigo, BMUsucodigo,Fcorte)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">,
							<!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTPid#">,---> 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Empresas#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#fcorte#">
					)				
				</cfquery>
			</cfif>
		</cfif>
	</cfif>
    
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=2" addtoken="no">	
	
<cfelseif isdefined("Form.RHPTUaccion") and Form.RHPTUaccion EQ "BAJA">
	<!---<cf_dump var = "#form#">--->
	<cfif isdefined("Form.RHPTUDid") and Len(Trim(Form.RHPTUDid)) >
		<cfquery name="delDependencia" datasource="#Session.DSN#">
			delete from RHPTUD
			where RHPTUDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUDid#">
		</cfquery>
        <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=2" addtoken="no">
	</cfif>	

<!--- Tab 3: GENERACION DE EMPLEADOS --->	
<cfelseif isdefined("Form.btnGenerar")>
		<!---<cf_dump var="#form#">--->
		<!---<cf_dump var="#url#">--->
        <cfsetting requesttimeout="14400"><!--- 4 horas --->
        <cfinvoke component="rh.Componentes.RH_PTU" method="generarEmpleados" returnvariable="LvarResult">
            <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
        </cfinvoke>              
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=3" addtoken="no">	

<cfelseif isdefined("Form.btnEliminar")>
<!---<cf_dump var="#form#">--->
    <cfquery datasource="#session.dsn#">
        delete from RHPTUEMpleados
        where RHPTUEMid in (#form.chk#)
        and RHPTUEid = #form.RHPTUEid_3#
    </cfquery>
    <cfquery name="rs" datasource="#session.DSN#">
    	select count(1) as cantidad
        from RHPTUEMpleados
        where RHPTUEid = #form.RHPTUEid_3#
    </cfquery>
    
    <cfif rs.cantidad gt 0>
    	<cfset Lvartab =  3>
    <cfelse>
	    <cfset Lvartab =  2>
    </cfif>
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid_3#&tab=#Lvartab#" addtoken="no">	
<cfelseif isdefined("Form.btnCalcular")>
	<!---<cf_dump var="#form#">
	<cf_dump var="#url#">--->
	<cfsetting requesttimeout="14400"><!--- 4 horas --->
    <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
        <cfinvokeargument name="RHPTUEid" value="#form.RHPTUEid_3#"/>
        <cfinvokeargument name="MontoMaximoS" value="#Form.SueldoAnual#"/>
        <cfinvokeargument name="MontoMaximoNS" value="#Form.SueldoAnualNS#"/>
    </cfinvoke>
   
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid_3#&tab=4" addtoken="no">	
    
<!--- Tab 4: CERRAR CALCULO PTU --->
<!---<cf_dump var = "#form#">--->
<cfelseif isdefined("Form.btnCerrar")>
	<cfquery datasource="#session.dsn#">
    	update RHPTUE
        set RHPTUEEstado = 1 <!--- 0: Abierto, 1: Cerrado --->
        where RHPTUEid = #form.RHPTUEid_4#
    </cfquery>  
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid_4#&tab=5" addtoken="no">	
<cfelseif isdefined("Form.btnAgregarDias")>
	<cfquery datasource="#session.dsn#">
		update RHPTUEMpleados 
		set RHPTUEMDiasAPagar = RHPTUEMDiasAPagar + #form.CantidadDias#
		where RHPTUEid = #form.RHPTUEid_4#
			and DEid = #form.DEid4#
    </cfquery>
    
    <cfquery name="rsEmpleados" datasource="#Session.DSN#">
		select RHPTUEMSueldoAnual, DEid, Ecodigo
		from RHPTUEMpleados rht
    	where RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPTUEid_4#">
    order by RHPTUEMSueldoAnual desc
	</cfquery>

<!---<cf_dump var= "#rsEmpleados#">--->

<cfset validacion = 0>
<cfloop query="rsEmpleados">
	<cfquery name="rsEmpleadosDos" datasource="#Session.DSN#">
    	select top 1 Tcodigo
					   from DLaboralesEmpleado 
                       where DEid = #rsEmpleados.DEid#
	                   		and Ecodigo = #rsEmpleados.Ecodigo#
					   order by DLfechaaplic desc
     </cfquery>
     <cfif rsEmpleadosDos.Tcodigo EQ '02' and validacion EQ 0>
     	<cfset validacion = 1>
     	<cfset idEmpleado = #rsEmpleados.DEid#>
        <cfset SueldoAnual = #rsEmpleados.RHPTUEMSueldoAnual#>
     <cfelseif rsEmpleadosDos.Tcodigo EQ '03' and validacion EQ 0>
     	<cfset idEmpleado = #rsEmpleados.DEid#>
        <cfset SueldoAnual = 0>
     </cfif>
</cfloop>
	
    <cfif SueldoAnual EQ ''>
    <cfset SueldoAnual = 0 >
	</cfif>
    
	<cfset SueldoAnualNS = (#SueldoAnual# * 1.2)>
    
    <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
        <cfinvokeargument name="RHPTUEid" value="#form.RHPTUEid_4#"/>
        <cfinvokeargument name="MontoMaximoS" value="#SueldoAnual#"/>
        <cfinvokeargument name="MontoMaximoNS" value="#SueldoAnualNS#"/>
    </cfinvoke>
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid_4#&tab=4" addtoken="no">	    
</cfif>