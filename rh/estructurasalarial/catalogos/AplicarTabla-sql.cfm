<cfset params = 'sel=2&RHTTid=#Form.RHTTid#'>

<cffunction name="actualizaTablasR" access="private" returntype="void">
	<cfargument name="RHVTid" 	        type="numeric" required="true">
    <cfargument name="RHVTidR" 	        type="numeric" required="true">
    <cfargument name="RHVTtipoformula"  type="numeric" required="true">
    <cfargument name="Debug" 	        type="string" required="true" default="false">
	<cfflush>
		<!--- REGISTRO EN EL HISTORICO LA TABLA A MODIFICAR--->
        
        <cfquery datasource="#session.DSN#">
           insert HRHMontosCategoria (RHMCid,RHVTid, RHCid, RHCmonto,RHCmontoAnt, RHCmontoFijo,RHCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo,HRMCnumcopia)
            select RHMCid,RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, coalesce(RHMCmontoFijo,0.00),coalesce(RHMCmontoPorc,0),CSid,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">,
            (select max(coalesce(HRMCnumcopia,0))+ 1 from HRHMontosCategoria)
            from RHMontosCategoria
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
        </cfquery>
		
        <!--- ACTUALIZAR EL MONTO DE REFERENCIA --->
        <cfquery datasource="#session.DSN#" name="rsUpdateReferencia">
            update RHMontosCategoria
            set RHMCmontoAnt = (select a.RHMCmonto 
                                from RHMontosCategoria a
                                where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTidR#">
                                  and a.RHCid = RHMontosCategoria.RHCid
								  and a.CSid = RHMontosCategoria.CSid
                                ),
                BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
           where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
		   and (select count(1)
				from RHMontosCategoria a
				where a.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTidR#">
				  and a.RHCid = RHMontosCategoria.RHCid
				  and a.CSid = RHMontosCategoria.CSid
				) > 0
        </cfquery>

        <!--- CALCULO EL NUEVO MONTO FINAL --->
        <cfquery datasource="#session.DSN#">
            update RHMontosCategoria
            set RHMCmonto = 
                <cfif arguments.RHVTtipoformula EQ 1>
                    round((RHMCmontoAnt+RHMCmontoFijo) + ((RHMCmontoAnt+RHMCmontoFijo) *(RHMCmontoPorc/100)),0),    
                <cfelse>
                    round((RHMCmontoAnt) + ((RHMCmontoAnt+RHMCmontoFijo) *(RHMCmontoPorc/100)) + (RHMCmontoFijo),0),    
                </cfif>
                BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">
           where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
        </cfquery>
		 
        <!--- VERIFICA SI LA TABLA A MODIFICAR ESTA COMO UNA TABLA DE REFERENCIA --->
        <cfquery name="rsTablasRRec" datasource="#session.DSN#">
            select RHVTid, coalesce(RHVTtipoformula,1) as RHVTtipoformula
            from RHVigenciasTabla
            where RHVTtablabase = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHVTid#">
              and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
        </cfquery>
    	<cfif rsTablasRRec.RecordCount GT 0>
			<cfloop query="rsTablasR">
                <cfset result = actualizaTablasR(rsTablasRRec.RHVTid,arguments.RHVTid,rsTablasRRec.RHVTtipoformula)>
            </cfloop>
        </cfif>
        <!--- SE APLICA LA ACTUALIZACION DE LA TABLA QUE LA REFERENCIA --->
        <cfif arguments.Debug>
           tabla a modificar
            <cf_dumptable var="RHMontosCategoria" filtro="RHVTid = #arguments.RHVTid# order by RHCid" abort="false">
            tabla de referencia
            <cf_dumptable var="RHMontosCategoria" filtro="RHVTid = #arguments.RHVTidR#" abort="false">
            <cfdump var="#rsTablasR#">
        </cfif>
	<cfflush>
    <cfreturn>
</cffunction>


<!--- APLICA LA TABLA SALARIAL --->

<cfif isdefined('form.Aplicar') or isdefined('form.AplicarV') >
	<cftransaction>
    	<!---ljimenes 20140128 fecha rige de la nueva tabla que vamos aplicar lo usamos para determinar el hasta de la tabla anterior--->
		<cfquery name="rsDatos" datasource="#session.DSN#">
			select RHVTfecharige
			from RHVigenciasTabla
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
		</cfquery>
        
        
       <!---se valida la vigencia de la tabla si es igual a una exitente mayor 
       se lee cual version es para actualizar la informacion como una copia de version--->
       <cfquery name="verificaFechaRige" datasource="#session.DSN#">
            select count(1) as cantRegistros , a.RHVTid
            from RHVigenciasTabla a
            where  a.RHVTfecharige = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHVTfecharige)#">  
                and a.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
                and a.RHVTestado = 'A'
            group by  a.RHVTid  
        </cfquery>
        
        <cfif verificaFechaRige.RecordCount EQ 0>
        	<cfset Lvar_Fechahasta = DateAdd('d',-1,rsDatos.RHVTfecharige)>
		<cfelse>
        	<cfset Lvar_Fechahasta = rsDatos.RHVTfecharige>
		</cfif>
        
        <cfif isdefined("verificaFechaRige") and verificaFechaRige.RecordCount NEQ 0 and verificaFechaRige.cantRegistros GTE 1>
        	<!--- MODIFICA EL ENCABEZADO  anterior--->
            <cfquery name="insertaVigencia" datasource="#session.DSN#">
                update RHVigenciasTabla set RHVTnumcopia = (select max(coalesce(a.RHVTnumcopia,0))+ 1 from RHVigenciasTabla a where a.RHVTfecharige = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHVTfecharige)#">)
                	,RHVTestado  = 'C'
                    ,BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                    ,BMfmod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
                    ,RHVTfechahasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Lvar_Fechahasta,'dd/mm/yyyy')#">
                where RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
                	and RHVTestado = 'A'
                    and RHVTid = #verificaFechaRige.RHVTid#
            </cfquery>
            
             <!--- MODIFICA EL ENCABEZADO nueva vingente--->
            <cfquery name="updateTabla" datasource="#session.DSN#">
                update RHVigenciasTabla
                set RHVTestado  = 'A',
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    BMfmod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
            </cfquery>

        <cfelse>
        
			<!--- MODIFICA LA FECHA DE LA TABLA VIGENTE --->
            <cfquery name="updateTablaVigente" datasource="#session.DSN#">
                update RHVigenciasTabla
                set RHVTfechahasta = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Lvar_Fechahasta,'dd/mm/yyyy')#">,
                    BMfmod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
                  and RHVTestado = 'A'
                  and coalesce(RHVTfechahasta,<cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#"> ) = <cfqueryparam cfsqltype="cf_sql_date" value="#createdate(6100,01,01)#">
            </cfquery>

            <!--- MODIFICA EL ENCABEZADO --->
            <cfquery name="updateTabla" datasource="#session.DSN#">
                update RHVigenciasTabla
                set RHVTestado  = 'A',
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                    BMfmod		= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and RHVTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
            </cfquery>
        
        </cfif>

		<cfif isdefined('form.chkRelAum')>
			<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="generarAumentoDesdeTablaSalarial">
				<cfinvokeargument name="idTabla" value="#form.RHTTid#">
				<cfinvokeargument name="idVigenciaTabla" value="#form.RHVTid#">
			</cfinvoke>
		</cfif>

	</cftransaction>
<cfelseif isdefined('form.AplicarC')>
	<cftransaction>
		<!--- REGISTRO EN EL HISTORICO QUE TABLAS LA TABLA ACTUAL--->
        <cfquery datasource="#session.DSN#" name="rsInsertHistorico">
           insert HRHMontosCategoria (RHMCid,RHVTid, RHCid, RHCmonto,RHCmontoAnt, RHCmontoFijo,RHCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo,HRMCnumcopia)
            select RHMCid,RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">,
            (select max(coalesce(HRMCnumcopia,0))+ 1 from HRHMontosCategoria)
            from RHMontosCategoria
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>
	 
        <!--- ELIMINAR LA TABLA ACTUAL --->
        <cfquery datasource="#session.DSN#">
            delete RHMontosCategoria
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>
        <!--- INSERTO NUEVA TABLA --->
        <cfquery datasource="#session.DSN#" name="rsinsert">
           insert RHMontosCategoria (RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)
            select RHVTid, RHCid, 
            		<!---round((RHMCmontoAnt+RHMCmontoFijo) + ((RHMCmontoAnt+RHMCmontoFijo) *(RHMCmontoPorc/100)),2) as RHMCmonto,--->
                    RHMCmonto,
		            RHMCmontoAnt, coalesce(RHMCmontoFijo,0.00) as RHMCmontoFijo, coalesce(RHMCmontoPorc,0) as RHMCmontoPorc, CSid,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo #">
            from RHMontosCategoriaT
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>
			 
        <!--- BUSCAR LAS TABLAS QUE HACEN REFERENCIA A LA TABLA MODIFICADA --->
        <cfquery name="rsTablasR" datasource="#session.DSN#">
            select RHVTid, coalesce(RHVTtipoformula,1) as RHVTtipoformula
            from RHVigenciasTabla
            where RHVTtablabase = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
              and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTTid#">
        </cfquery>
		
		<!--------------------------------------------- nuevo llamado---------------------------------->
        <cfif rsTablasR.RecordCount GT 0>
			<cfoutput query="rsTablasR">
                <cfset result = actualizaTablasR(rsTablasR.RHVTid,form.RHVTid,rsTablasR.RHVTtipoformula)>
            </cfoutput>
        </cfif>
        <!--- SE BORRAN LOS REGISTROS DE TRABAJO --->
        <cfquery datasource="#session.DSN#">
        	delete RHMontosCategoriaT
            where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHVTid#">
        </cfquery>

    </cftransaction>
</cfif>

<script>
	window.location="tipoTablasSal.cfm?<cfoutput>#params#</cfoutput>";
</script>
