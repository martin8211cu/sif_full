<!--- <cfdump var="#form#">
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
                            RHPTUEDescIncapa
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
                <cfif isdefined("form.RHPTUEDescIncapa")>1<cfelse>0</cfif>
                
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
            RHPTUEDescIncapa =  <cfif isdefined("form.RHPTUEDescIncapa")>1<cfelse>0</cfif>
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
		
		<cfelse>
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
		</cfif>
	</cfif>
    
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=2" addtoken="no">	
	
<cfelseif isdefined("Form.RHPTUaccion") and Form.RHPTUaccion EQ "BAJA">
	<cfif isdefined("Form.RHPTUDid") and Len(Trim(Form.RHPTUDid)) >
		<cfquery name="delDependencia" datasource="#Session.DSN#">
			delete from RHPTUD
			where RHPTUDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUDid#">
		</cfquery>
        <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=2" addtoken="no">
	</cfif>	

<!--- Tab 3: GENERACION DE EMPLEADOS --->	
<cfelseif isdefined("Form.btnGenerar")>
        <cfsetting requesttimeout="14400"><!--- 4 horas --->
        <cfinvoke component="rh.Componentes.RH_PTU" method="generarEmpleados" returnvariable="LvarResult">
            <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
        </cfinvoke>              
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=3" addtoken="no">	

<cfelseif isdefined("Form.btnEliminar")>
    <cfquery datasource="#session.dsn#">
        delete from RHPTUEMpleados
        where RHPTUEMid in (#form.chk#)
        and RHPTUEid = #form.RHPTUEid#
    </cfquery>
    <cfquery name="rs" datasource="#session.DSN#">
    	select count(1) as cantidad
        from RHPTUEMpleados
        where RHPTUEid = #form.RHPTUEid#
    </cfquery>
    
    <cfif rs.cantidad gt 0>
    	<cfset Lvartab =  3>
    <cfelse>
	    <cfset Lvartab =  2>
    </cfif>
	<cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=#Lvartab#" addtoken="no">	
<cfelseif isdefined("Form.btnCalcular")>

	<cfsetting requesttimeout="14400"><!--- 4 horas --->
    <cfinvoke component="rh.Componentes.RH_PTU" method="CalculoPTU" returnvariable="LvarResult">
        <cfinvokeargument name="RHPTUEid" value="#Form.RHPTUEid#"/>
    </cfinvoke>
   
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=4" addtoken="no">	
<cfelseif isdefined("Form.btnCerrar")>
	<cfquery datasource="#session.dsn#">
    	update RHPTUE
        set RHPTUEEstado = 1 <!--- 0: Abierto, 1: Cerrado --->
        where RHPTUEid = #form.RHPTUEid#
    </cfquery>
    
    <cflocation url="/cfmx/rh/nomina/operacion/PTU.cfm?RHPTUEid=#form.RHPTUEid#&tab=5" addtoken="no">	
</cfif>