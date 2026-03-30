<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="No_se_puede_borrar_la_plaza_pues_tiene_movimientos_registrados"
	Default="No se puede borrar la plaza, pues tiene movimientos registrados."
	returnvariable="MG_PlazasRegistradas"/> 



<cfparam name="action" default="CFuncional.cfm">
<cfparam name="modoPlazas" default="ALTA">

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
	ecodigo="#session.Ecodigo#" pvalor="540" default="0" returnvariable="vUsaPresupuesto"/>

<!--- función para reasignar la plaza responsable del centro funcional --->
<cffunction name="marcarResponsableCF" access="public" returntype="void">
	<cfargument name="CFid" type="numeric" required="yes">
	<cfargument name="RHPid" type="numeric" required="yes">
	<cfquery datasource="#session.DSN#">
		<!--- Asignar esta plaza como responsable del Centro Funcional --->
		update CFuncional set 
			RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHPid#">
			, CFuresponsable = null <!--- si se asgina una plaza responsable debe desasignar el 
									usuario responsable --->
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
	</cfquery>
</cffunction>

<!--- función para desmarcar la plaza responsable del centro funcional --->
<cffunction name="desmarcarResponsableCF" access="public" returntype="void">
	<cfargument name="CFid" type="numeric" required="yes">
	<cfargument name="RHPid" type="numeric" required="yes">
	<cfquery datasource="#session.DSN#">
		<!--- Asignar esta plaza como responsable del Centro Funcional --->				
		update CFuncional set 
			RHPid = null
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#">
		  and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHPid#">
	</cfquery>
</cffunction>

<!--- Caso 1: Agregar  --->
<cfif isdefined("form.AltaPlazas")>
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select 1
		from RHPlazas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>
	<cfif chkExists.recordCount GT 0>
		<cfset msg = "El código de plaza ya existe.">
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
		<cfabort>
	</cfif>
    
   
	<cftransaction>
		<cfquery name="ABC_Plazas" datasource="#session.DSN#">
			insert into RHPlazas ( CFid, Ecodigo, RHPcodigo, RHPdescripcion, Dcodigo, Ocodigo, RHPpuesto, CFidconta, RHPactiva )
				 values ( <cfqueryparam value="#form.CFpk#" 		   cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#form.RHPcodigo#"       cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHPdescripcion#"  cfsqltype="cf_sql_varchar">,
						  <cfqueryparam value="#form.Dcodigo#"         cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#form.Ocodigo#"         cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#form.RHPpuesto#"       cfsqltype="cf_sql_char">,
						  <cfif isdefined("form.CFidconta") and len(trim(form.CFidconta))><cfqueryparam value="#form.CFidconta#" cfsqltype="cf_sql_numeric"><cfelse> <cfqueryparam value="#form.CFpk#" cfsqltype="cf_sql_numeric"></cfif>,
						  <cfif isdefined("Form.RHPactiva")>1<cfelse>0</cfif>
				)
			<cf_dbidentity1 datasource="#session.DSN#">									
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Plazas">
        
        <!---<cfif #vUsaPresupuesto# EQ 1 > usas planilla presupuestaria--->
        
			<!--- Crea una Plaza Presupuestaria y la asocia a la plaza de RH creada --->
            <!--- 1. Obtiene la moneda de la empresa --->
            <cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="obtenerMoneda" returnvariable="vMcodigo">
                <cfinvokeargument name="DSN" value="#session.DSN#">
                <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
            </cfinvoke>
            <!--- 2. Inserta la plaza presupuestaria  --->
            <cfinvoke component="rh.Componentes.RH_TrabajarMovimientoPlaza" method="insertarPlaza" returnvariable="vRHPPid">
                <cfinvokeargument name="DSN" value="#session.DSN#">
                <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
                <cfinvokeargument name="RHPPcodigo" value="#form.RHPcodigo#">
                <cfinvokeargument name="RHPPdescripcion" value="#form.RHPdescripcion#">
                <cfinvokeargument name="BMUsucodigo"	value="#session.Usucodigo#">
            </cfinvoke>
            <!--- 3. Asocia la plaza presupuestaria a la plaza de RH --->
            <cfquery datasource="#session.DSN#">
                update RHPlazas
                set RHPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">
                where Ecodigo = <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">
                and RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Plazas.identity#">
            </cfquery>
            <!--- 4. Crea un registro de la linea del Tiempo para la plaza presupuestaria --->
            <cfset fechamax = CreateDate(6100, 01, 01)>
            <cfquery datasource="#session.DSN#">
                insert into RHLineaTiempoPlaza( Ecodigo,
                                                RHPPid,
                                                RHCid,
                                                RHMPPid,
                                                RHTTid,
                                                RHMPid,
                                                RHPid,	
                                                CFidautorizado,
                                                RHLTPfdesde,
                                                RHLTPfhasta,
                                                CFcentrocostoaut,
                                                RHMPestadoplaza,
                                                RHMPnegociado,
                                                RHLTPmonto,
                                                Mcodigo,
                                                BMfecha,
                                                BMUsucodigo )
                values( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#vRHPPid#">,
                        null,
                        null,
                        null,
                        null,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_Plazas.identity#">,
                        <cfqueryparam value="#form.CFpk#" cfsqltype="cf_sql_numeric">,
                        <cfif isdefined("form.LTfecha") and len(trim(form.LTfecha))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.LTfecha)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"></cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechamax#">,
                        <cfqueryparam value="#form.CFpk#" cfsqltype="cf_sql_numeric">,
                        'A',
                        'T',
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#vMcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
            </cfquery>	
    <!---	</cfif>	fin plazas en planilla presupuestaria--->				
	</cftransaction>	
	<cfif isDefined("Form.chkResponsable") > 
		<cfset marcarResponsableCF(Form.CFpk,ABC_Plazas.identity)>
	<cfelse>
		<cfset desmarcarResponsableCF(Form.CFpk,ABC_Plazas.identity)>
	 </cfif>
<!--- Caso 2: Modificar --->
<cfelseif isdefined("form.CambioPlazas")>
	<cf_dbtimestamp
		datasource="#session.dsn#"
		table="RHPlazas" 
		redirect="#action#"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo,integer,#Session.Ecodigo#"
		field2="RHPid,numeric,#form.RHPid#">
			
	<cftransaction>
        <cfquery datasource="#session.DSN#">
            update RHPlazas
            set RHPcodigo = <cfqueryparam value="#form.RHPcodigo#"    cfsqltype="cf_sql_char">, 
                RHPdescripcion = <cfqueryparam value="#form.RHPdescripcion#"    cfsqltype="cf_sql_varchar">, 
                Dcodigo = <cfqueryparam value="#form.Dcodigo#" cfsqltype="cf_sql_integer">, 
                Ocodigo = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
                RHPpuesto = <cfqueryparam value="#form.RHPpuesto#" cfsqltype="cf_sql_char">,
                CFidconta = <cfif isdefined("form.CFidconta") and len(trim(form.CFidconta)) ><cfqueryparam value="#form.CFidconta#" cfsqltype="cf_sql_numeric"><cfelse> <cfqueryparam value="#form.CFpk#" cfsqltype="cf_sql_numeric"></cfif>,
                RHPactiva = <cfif isdefined("Form.RHPactiva")>1<cfelse>0</cfif>
            where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
              and RHPid =  <cfqueryparam value="#form.RHPid#" cfsqltype="cf_sql_numeric">
        </cfquery>
        
        <!---<cfif #vUsaPresupuesto# EQ 1 > usas planilla presupuestaria--->
            <cfif isdefined("form.RHPPid") and len(trim(form.RHPPid))>
                <cfquery datasource="#session.DSN#">
                    update RHPlazaPresupuestaria
                    set RHPPcodigo = <cfqueryparam value="#form.RHPcodigo#"    cfsqltype="cf_sql_char">, 
                        RHPPdescripcion = <cfqueryparam value="#form.RHPdescripcion#"    cfsqltype="cf_sql_varchar">
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                      and RHPPid =  <cfqueryparam value="#form.RHPPid#" cfsqltype="cf_sql_numeric">
                </cfquery>
            </cfif>
        <!---</cfif>--->
	</cftransaction>
	
    <!---<cfif #vUsaPresupuesto# EQ 1 > usas planilla presupuestaria--->
		<cfif isdefined("form.RHLTPid") and len(trim(form.RHLTPid))>
            <cfquery datasource="#session.DSN#">
                update RHLineaTiempoPlaza
                set RHLTPfdesde = <cfif isdefined("form.LTfecha") and len(trim(form.LTfecha))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.LTfecha)#"><cfelse><cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"></cfif>
                where RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLTPid#">
            </cfquery>
        </cfif>
   <!--- </cfif>--->
	
	<cfif isDefined("Form.chkResponsable") > 
		<cfset marcarResponsableCF(Form.CFpk,form.RHPid)>
	<cfelse>
		<cfset desmarcarResponsableCF(Form.CFpk,form.RHPid)>
	 </cfif>
	<cfset modoPlazas = 'CAMBIO'>
<!--- Caso 3: Borrar --->
<cfelseif isdefined("form.BajaPlazas")>
	<cfquery name="chkExists" datasource="#Session.DSN#">
		select 1
		from RHPlazas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and RHPid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPid#">
	</cfquery>
	<cfif chkExists.recordCount GT 0>
		<cfset msg = "El código de plaza ya existe.">
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#">
		<cfabort>
	</cfif>
	<!--- Si se borra la plaza que es responsable del centro funcional, 
		poner nulo el campo de la plaza responsable en el centro funcional --->  
	<cfset desmarcarResponsableCF(Form.CFpk,form.RHPid)>

	<!--- Borra los datos asociados a la planilla presupuestaria --->
	<cfquery name="validaPlanilla" datasource="#session.DSN#">
		select Pvalor 
		from RHParametros 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo=540
	</cfquery>
	<cfquery name="rsPlazaPres" datasource="#session.DSN#">
		select RHPPid
		from RHPlazas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHPid=<cfqueryparam value="#form.RHPid#" cfsqltype="cf_sql_numeric">			
	</cfquery>

	<!--- ================================================================ ---> 
	<!--- Borra plazas presupuestarias --->
	<!--- ================================================================ ---> 	
	<cfif len(trim(rsPlazaPres.RHPPid)) >
		<!--- Usa planilla presupuestaria --->
		<cfif validaPlanilla.Pvalor eq 1 >
			<cfquery name="rsLineaTiempo" datasource="#session.DSN#">
				select count(1) as total
				from RHLineaTiempoPlaza
				where RHPPid=<cfqueryparam value="#rsPlazaPres.RHPPid#" cfsqltype="cf_sql_numeric">			
			</cfquery>
			<cfif rsLineaTiempo.total eq 1 >
				<cftransaction>
				<cfquery datasource="#session.DSN#">
					delete from RHPlazas
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHPid =  <cfqueryparam value="#form.RHPid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery datasource="#session.DSN#">
					delete from RHLineaTiempoPlaza
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHPPid =  <cfqueryparam value="#rsPlazaPres.RHPPid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfquery datasource="#session.DSN#">
					delete from RHPlazaPresupuestaria
					where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHPPid =  <cfqueryparam value="#rsPlazaPres.RHPPid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				</cftransaction>
			<cfelse>
				<cf_throw message="#MG_PlazasRegistradas#" errorcode="2110">
			</cfif>
		<!--- No usa planilla presupuestaria --->
		<cfelse>
			<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from RHPlazas
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPid =  <cfqueryparam value="#form.RHPid#" cfsqltype="cf_sql_numeric">
			</cfquery>
            <!---<cfif #vUsaPresupuesto# EQ 1 > usas planilla presupuestaria--->
                <cfquery datasource="#session.DSN#">
                    delete from RHLineaTiempoPlaza
                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                      and RHPPid =  <cfqueryparam value="#rsPlazaPres.RHPPid#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfquery datasource="#session.DSN#">
                    delete from RHPlazaPresupuestaria
                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                      and RHPPid =  <cfqueryparam value="#rsPlazaPres.RHPPid#" cfsqltype="cf_sql_numeric">
                </cfquery>
            <!---</cfif>--->
			</cftransaction>
		</cfif>
	</cfif>

</cfif>
<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="tab" type="hidden" value="3" />
   	<input name="modoPlazas"   type="hidden" value="<cfif isdefined("modoPlazas")>#modoPlazas#</cfif>">
	<input name="modo"   type="hidden" value="CAMBIO">
	<input name="CFpk"   type="hidden" value="#Form.CFpk#">
	<cfif modoPlazas eq 'CAMBIO'><input name="RHPid" type="hidden" value="#form.RHPid#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>