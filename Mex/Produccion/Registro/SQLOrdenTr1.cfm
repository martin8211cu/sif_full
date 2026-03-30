<cfparam  name="modo" default="ALTA">
<cfparam  name="modoArt" default="ALTA">
<cfparam  name="modoPT" default="ALTA">
<cfparam  name="actualTab" default="area">
        
<!---<cf_dump var="#form#" >         
--->
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="ABC_OrdenTr" datasource="#Session.DSN#">
				insert into Prod_OT (ECodigo, OTcodigo, SNcodigo, OTdescripcion, OTfechaRegistro,OTfechaCompromiso,OTobservacion,OTstatus,BMUsucodigo,BMfecha)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">, 	
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,									
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTdescripcion#">, 
					<cfqueryparam cfsqltype="cf_sql_date"    value="#Form.OTfechaReg#">,                    
                    <cfqueryparam cfsqltype="cf_sql_date"    value="#Form.OTfechaComp#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTObs#">, 
                    <cfqueryparam cfsqltype="cf_sql_integer" value="Nueva">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)								
			</cfquery>
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="CancelaProceso" datasource="#Session.DSN#">
				update Prod_PRoceso set
                	OTstatus		= <cfqueryparam cfsqltype="cf_sql_integer" value="Cancelado">,
                    BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
			</cfquery>	
			<cf_dbtimestamp datasource="#session.dsn#"
					table="Prod_OT"
					redirect="RegOrdenTrab.cfm"
					timestamp="#form.ts_rversion#"
					field1="OTcodigo" 
					type1="varchar" 
					value1="#Form.OTcodigo#"
					>
			<cfquery name="ABC_OrdenTr" datasource="#Session.DSN#">
				update Prod_OT set
                	OTstatus		= <cfqueryparam cfsqltype="cf_sql_integer" value="Cancelado">,
                    BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
			</cfquery>	
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.dsn#"
					table="Prod_OT"
					redirect="RegOrdenTrab.cfm"
					timestamp="#form.ts_rversion#"
					field1="OTcodigo" 
					type1="varchar" 
					value1="#Form.OTcodigo#"
					>
			<cfquery name="ABC_OrdenTr" datasource="#Session.DSN#">
				update Prod_OT set
                    SNcodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,									
					OTdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTdescripcion#">, 
					OTfechaRegistro	= <cfqueryparam cfsqltype="cf_sql_date"    value="#Form.OTfechaReg#">,                    
                    OTfechaCompromiso= <cfqueryparam cfsqltype="cf_sql_date"    value="#Form.OTfechaComp#">,
                    OTobservacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTObs#">,
                    BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where ECodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
			</cfquery>	
            
		<cfelseif isDefined("Form.Aceptar_Area")>
        <!---INICIA  Mantenimiento de Proceso-Area  --->
            <cffunction name="insertProceso" >		
                <cfargument name="pOTcodigo"   	type="string" required="true">
                <cfargument name="pOTseq"      	type="numeric" required="true">
                <cfargument name="pAPcodigo" 	type="numeric" required="true">
                <cfargument name="pChecked" 	type="numeric" required="true">
                
                <cfquery name="rsProdproceso" datasource="#Session.DSN#">
                    select 1 
                    from Prod_Proceso
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                     and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
                     and OTseq    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">
                </cfquery>
                <cfif "#Arguments.pChecked#" EQ 1>
                    <cfif isdefined('rsProdproceso') and rsProdproceso.recordCount EQ 0>
                        <cfquery datasource="#Session.DSN#">
                            insert INTO Prod_Proceso (Ecodigo, OTcodigo,OTseq, APcodigo,OTstatus,BMUsucodigo,BMfecha)
                            values (
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">, 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">, 
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="Nueva">,
                                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
                                )
                        </cfquery>
                    <cfelse>
                        <cfquery datasource="#Session.DSN#">
                            update Prod_Proceso
                                set APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
                                and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                                and OTseq    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.pOTseq#">	
                        </cfquery>				
                    </cfif>
                <cfelse>
                    <cfif isdefined('rsProdproceso') and rsProdproceso.recordCount NEQ 0>
                        <cfquery datasource="#Session.DSN#">
                            Delete Prod_Proceso
                            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.pOTcodigo#">	
                                and APcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pAPcodigo#">
                                and OTseq    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pOTseq#">	
                        </cfquery>
                    </cfif>
                </cfif>
                <cfreturn true>
            </cffunction>
            
            <cfloop from="1" to="#form.NprodArea#" index="id"> 
                <cfset vOrden = "Orden#id#">
                <cfset vAPcodigo ="APCodigo#id#">
                
                <cfif isdefined("form.chk#id#")>
                    <cfset vArreglo = 1>
                <cfelse> 
                    <cfset vArreglo = 0>
                </cfif>
                <cfif isdefined("form.Orden#id#") and len(trim(form['#vOrden#'])) and isdefined("form.APCodigo#id#")>
                    <cfset b = insertProceso(#form.OTcodigo#,#form['#vOrden#']#,#form['#vAPCodigo#']#,#vArreglo#)>
                </cfif>
            </cfloop>
			<!---FIN  Mantenimiento de Proceso-Area  --->
            
<!---INICIA  Mantenimiento de Proceso-Archivo  --->
        <cfelseif isDefined("Form.Aceptar") and isDefined("form.logo") and Len(form.logo) GT 1> 
        	<cfset actualTab = "arc">
            <cfquery name="rsSiguiente" datasource="#Session.DSN#">
                select isnull(max(AAconsecutivo),0)+1 as siguiente
                from Prod_OTArchivo
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                 and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">	
            </cfquery>
            <cfquery datasource="#Session.DSN#">
                insert INTO Prod_OTArchivo (Ecodigo,OTcodigo,AAcontenido,AAnombre,AAdefaultpre,AAconsecutivo,BMUsucodigo,BMfecha)
                values (
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">, 
                    <cf_dbupload filefield="logo" accept="image/*">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cffile.clientfile#">, 
                    0,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSiguiente.siguiente#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                    )
            </cfquery>
        <cfelseif isDefined("Form.EliminarArchivo")>
        		<cfset actualTab = "arc">
                <cfquery datasource="#Session.DSN#">
                    delete Prod_OTArchivo
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and OTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">	
                    and AAconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Prod_tipo#">
                </cfquery>
<!---FIN  Mantenimiento de Proceso-Archivo  --->

<!---INICIA  Mantenimiento de Orden-Insumo  --->
		<cfelseif isDefined("Form.Aceptar_Art") and isDefined("Form.OrdenSeq") and isDefined("Form.Aid")>
        	<cfset actualTab = "prod">
			<cfif modoArt EQ 'ALTA'>
                <cfquery datasource="#Session.DSN#">
                    insert INTO Prod_Insumo (Ecodigo,OTcodigo,OTseq,Artid,UCodigo,MPcantidad,MPprecioUnit,MPseguimiento,BMUsucodigo,BMfecha)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OrdenSeq#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.UnidadM#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cantidad#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#form.PrecioU#">,
                        <cfif isdefined("form.chkseguimiento")>1<cfelse>0</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                        )
                </cfquery>
            	<cfset modoArt="CAMBIO">
            </cfif>
     	<cfelseif isDefined("Form.Modificar_Art") and isDefined("form.OrdenSeq") and isDefined("form.Aid")> 
        	<cfset actualTab = "prod">           
            <cfquery datasource="#Session.DSN#">
                Update Prod_Insumo
                set
                    UCodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.UnidadM#">,
                    MPcantidad		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cantidad#">,
                    MPprecioUnit  	= <cfqueryparam cfsqltype="cf_sql_money"   value="#form.PrecioU#">,
                    MPseguimiento 	= <cfif isdefined("form.chkseguimiento")>1<cfelse>0</cfif>,
                    BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" 	 value="#session.Usucodigo#">,
                    BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                where
                    Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and
                    OTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#"> and
                    OTseq 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OrdenSeq#"> and
                    Artid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
            </cfquery>
            <cfset modoArt="CAMBIO">
       	<cfelseif isDefined("Form.Eliminar_Art") and isDefined("form.OrdenSeq") and isDefined("form.Aid")>
        	<cfset actualTab = "prod">            
            <cfquery datasource="#Session.DSN#">
                Delete Prod_Insumo
                where
                    Ecodigo	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and 
                    OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#"> and 
                    OTseq 	 = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OrdenSeq#"> and
                    Artid 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
            </cfquery>
            <cfset modoArt="ALTA">
<!---FIN Mantenimiento de Orden-Insumo  ---> 
<!---INICIA  Mantenimiento de Orden-Producto Terminado ---> 
		<cfelseif isDefined("Form.Aceptar_Prod") and isDefined("Form.ProdTer_Aid")>
        	<cfset actualTab = "pt">
			<cfif modoPT EQ 'ALTA'>
                <cfquery datasource="#Session.DSN#">
                    insert INTO Prod_Producto (Ecodigo,OTcodigo,Artid,PTcantidad,PTPrecioUnit,BMUsucodigo,BMfecha)
                    values (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProdTer_Aid#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PT_Cantidad#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#form.PT_PrecioU#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                        )
                </cfquery>
            	<cfset modoPT="CAMBIO">
            </cfif>
		<cfelseif isDefined("Form.Modificar_Prod") and isDefined("Form.ProdTer_Aid")>
        	<cfset actualTab = "pt">
            <cfquery datasource="#Session.DSN#">
                Update Prod_Producto
                set
                    PTcantidad		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PT_Cantidad#">,
                    PTprecioUnit  	= <cfqueryparam cfsqltype="cf_sql_money"   value="#form.PT_PrecioU#">,
                    BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" 	 value="#session.Usucodigo#">,
                    BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> 
                where
                    Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and
                    OTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#"> and
                    Artid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProdTer_Aid#">
            </cfquery>
            <cfset modoPT="CAMBIO">
		<cfelseif isDefined("Form.Eliminar_Prod") and isDefined("Form.ProdTer_Aid")>
        	<cfset actualTab = "pt">
            <cfquery datasource="#Session.DSN#">
                Delete Prod_Producto
                where
                    Ecodigo		= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and
                    OTcodigo 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OTcodigo#"> and
                    Artid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProdTer_Aid#">
            </cfquery>
            <cfset modoPT="ALTA">
<!---FIN Mantenimiento de Orden-Producto Terminado --->          
		</cfif>
        <cfset modo="CAMBIO">			
	<cfcatch type="any">
		<cfinclude template="../../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<!---INICIA  Mantenimiento de Proceso-Archivo  --->
<form action="RegOrdenTr.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
    <input name="modoArt" type="hidden" value="<cfif isdefined("modoArt")><cfoutput>#modoArt#</cfoutput></cfif>">
    <input name="modoPT" type="hidden" value="<cfif isdefined("modoArt")><cfoutput>#modoPT#</cfoutput></cfif>">
    <input name="tab" type="hidden" value=<cfoutput>"#actualTab#"</cfoutput>>
	<cfif modo neq 'ALTA'>
		<input name="OTcodigo" type="hidden" value="<cfif isdefined("Form.OTcodigo")><cfoutput>#Form.OTcodigo#</cfoutput></cfif>">	
	</cfif>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


