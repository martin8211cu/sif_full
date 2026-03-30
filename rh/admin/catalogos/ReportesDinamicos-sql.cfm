<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_ElConceptoDePagoYaEstaRegistrado" Default="El concepto de pago ya est&aacute; registrado" returnvariable="MSG_ElConceptoDePagoYaEstaRegistrado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_LaDeduccionYaEstaRegistrada" 	 Default="La deducci&oacute;n ya est&aacute; registrada" returnvariable="MSG_LaDeduccionYaEstaRegistrada" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_LaCargaYaEstaRegistrada" 		 Default="La Carga ya est&aacute; registrada" returnvariable="MSG_LaCargaYaEstaRegistrada" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset params = ''>

<cfif not isdefined('form.Nuevo') and not isdefined('form.NuevoD')>
	
	<cfif isdefined('form.Alta')>
    	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
        	insert into RHReportesNomina (Ecodigo,RHRPTNcodigo,RHRPTNdescripcion,RHRPTNlineas,BMUsucodigo,fechaalta)
            values(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRPTNcodigo#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRPTNdescripcion#">,
                50,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            	)
           <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
        </cftransaction>
        <cf_translatedata name="set" tabla="RHReportesNomina" col="RHRPTNdescripcion" valor="#form.RHRPTNdescripcion#" filtro="RHRPTNid = #rsInsert.identity#">
         <cfset params = params & 'RHRPTNid=' & rsInsert.identity>
    <cfelseif isdefined('form.Cambio')>
	    <cftransaction>
    	<cfquery name="rsUpdate" datasource="#session.DSN#">
        	update RHReportesNomina
            set RHRPTNcodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRPTNcodigo#">,
            	RHRPTNdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRPTNdescripcion#">,
            	BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                fechaalta		  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
           	where RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
		</cfquery>	
        </cftransaction>
        <cf_translatedata name="set" tabla="RHReportesNomina" col="RHRPTNdescripcion" valor="#form.RHRPTNdescripcion#" filtro="RHRPTNid = #form.RHRPTNid#">
        <cfset params = params & 'RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.Baja')>
    	<cftransaction>
    	<cfquery name="rsDeleteConceptos" datasource="#session.DSN#">
        	delete from RHConceptosColumna
            where exists(select 1
            			 from RHColumnasReporte a
                         where a.RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
                           and a.RHCRPTid = RHConceptosColumna.RHCRPTid
            			)
        </cfquery>
    	<cfquery name="rsDeleteCol" datasource="#session.DSN#">
        	delete from RHColumnasReporte
            where RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
        </cfquery>
    	<cfquery name="rsDelete" datasource="#session.DSN#">
        	delete from RHReportesNomina
            where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
        </cfquery>
        </cftransaction>
        <cflocation url="ReportesDinamicos-lista.cfm">	
    <cfelseif isdefined('form.AltaD')>
    	<cftransaction>
		<cfquery name="rsInsertD" datasource="#session.DSN#">
        	insert into RHColumnasReporte(RHRPTNid,RHCRPTcodigo ,RHCRPTdescripcion,RHRPTNcolumna,RHRPTNOrigen,BMUsucodigo,fechaalta)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">,
            	<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHCRPTcodigo#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCRPTdescripcion#">,
                0,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNOrigen#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            	)
           <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsertD">
        </cftransaction>
        <cf_translatedata name="set" tabla="RHColumnasReporte" col="RHCRPTdescripcion" valor="#form.RHCRPTdescripcion#" filtro="RHCRPTid = #rsInsertD.identity#">
         <cfset params = params & 'RHCRPTid =' & rsInsertD.identity & '&RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.CambioD')>
    	<cftransaction>
    	<cfquery name="rsUpdateD" datasource="#session.DSN#">
            update RHColumnasReporte
            set <!---RHCRPTcodigo 	  = <cfqueryparam cfsqltype="cf_sql_char" 		value="#form.RHCRPTcodigo#">,
                RHCRPTdescripcion =	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHCRPTdescripcion#">,--->
                RHRPTNOrigen 	  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHRPTNOrigen#">,
                BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
                fechaalta 		  = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">
            where RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
        </cfquery>
        </cftransaction>
        <!---<cf_translatedata name="set" tabla="RHColumnasReporte" col="RHCRPTdescripcion" valor="#form.RHCRPTdescripcion#" filtro="RHCRPTid = #form.RHCRPTid#">----->
        <cfset params = params & 'RHCRPTid=' & form.RHCRPTid & '&RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.BajaD')>
    	<cftransaction>
    	<cfquery name="rsDeleteConceptos" datasource="#session.DSN#">
        	delete from RHConceptosColumna
            where exists(select 1
            			 from RHColumnasReporte a
                         where a.RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
                           and a.RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
                           and a.RHCRPTid = RHConceptosColumna.RHCRPTid
            			)
        </cfquery>
    	<cfquery name="rsDeleteCol" datasource="#session.DSN#">
        	delete from RHColumnasReporte
            where RHRPTNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRPTNid#">
              and RHCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
        </cfquery>
        </cftransaction>
        <cfset params = params & '&RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.AgregaI')>
    	<cfquery name="rsConcepto" datasource="#session.DSN#">
        	select 1
            from RHConceptosColumna
            where RHCRPTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
              and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
        </cfquery>
        <cfif rsConcepto.RecordCount NEQ 0>
        <cf_throw message="#MSG_ElConceptoDePagoYaEstaRegistrado#" errorcode="2025">
        </cfif>
    	<cftransaction>
        <cfquery name="rsInsertCC" datasource="#session.DSN#">
        	insert into RHConceptosColumna(RHCRPTid,CIid,BMUsucodigo,fechaalta)
            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                  )
        </cfquery>
        </cftransaction>
        <cfset params = params & 'RHCRPTid=' & form.RHCRPTid & '&RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.AgregaD')>
    	<cfquery name="rsDeduccion" datasource="#session.DSN#">
        	select 1
            from RHConceptosColumna
            where RHCRPTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
              and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
        </cfquery>
        <cfif rsDeduccion.RecordCount NEQ 0>
        <cf_throw message="#MSG_LaDeduccionYaEstaRegistrada#" errorcode="2030">
		</cfif>
    	<cftransaction>
        <cfquery name="rsInsertDed" datasource="#session.DSN#">
        	insert into RHConceptosColumna(RHCRPTid,TDid,BMUsucodigo,fechaalta)
            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                  )
        </cfquery>
        
        </cftransaction>
        <cfset params = params & 'RHCRPTid=' & form.RHCRPTid & '&RHRPTNid=' & form.RHRPTNid>
	<cfelseif isdefined('form.AgregaC')>
    	<cfquery name="rsCarga" datasource="#session.DSN#">
        	select 1
            from RHConceptosColumna
            where RHCRPTid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">
              and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
        </cfquery>
        <cfif rsCarga.RecordCount NEQ 0>
        <cf_throw message="#MSG_LaCargaYaEstaRegistrada#" errorcode="2035">
		</cfif>
    	<cftransaction>
        <cfquery name="rsInsertC" datasource="#session.DSN#">
        	insert into RHConceptosColumna(RHCRPTid,DClinea,BMUsucodigo,fechaalta)
            values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCRPTid#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
            		<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                  )
        </cfquery>
        
        </cftransaction>
        <cfset params = params & 'RHCRPTid=' & form.RHCRPTid & '&RHRPTNid=' & form.RHRPTNid>
    <cfelseif isdefined('form.RHCCRPTid') and LEN(TRIM(form.RHCCRPTid))>
    	<cftransaction>
        <cfquery name="rsDeleteTDid" datasource="#session.DSN#">
        	delete from RHConceptosColumna
            where RHCCRPTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCCRPTid#">
        </cfquery>
        </cftransaction>
         <cfset params = params & 'RHCRPTid=' & form.RHCRPTid & '&RHRPTNid=' & form.RHRPTNid>
	</cfif>
<cfelseif isdefined('form.NuevoD')>
	 <cfset params = params & 'RHRPTNid=' & form.RHRPTNid>
</cfif>
<cflocation url="ReportesDinamicos.cfm?#params#">	