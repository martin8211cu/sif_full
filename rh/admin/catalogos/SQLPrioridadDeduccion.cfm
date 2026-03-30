<cfinvoke key="LB_Antes_de_borrar_el_tipo_de_deduccion_debe_eliminar_los_permisos" default="La Prioridad se encuentra asociada a un tipo de Deducción" returnvariable="LB_ErrorTipoDed" component="sif.Componentes.Translate" method="Translate"/>	
<cfparam name="action" default="PrioridadDeduccion.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<!--- Agregar Prioridad de Deducción --->
	<cfif isdefined("form.Alta") >
		<cfquery datasource="#session.DSN#" name="rsExisteAdd">
			select *
			from RHPrioridadDed
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHPDcodigo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.RHPDcodigo#">
		</cfquery>
        <cfif isdefined('rsExisteAdd') and  rsExisteAdd.RecordCount NEQ 0>
			<cfset Errs = 'Código de Prioridad ya Existe'>
            <cfset ErrsMG = 'Ingreso Registro no Válido'>
            <cfset title = 'Operación Inválida'>
            
            <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(title)#&ErrMsg= #URLEncodedFormat(ErrsMG)#<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
            <cfabort>
        </cfif>
    
		<cftransaction>
        	<cfquery datasource="#session.DSN#" name="rsExiste">
                select * 
                from RHPrioridadDed 
                where RHPDorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHPDorden#" >
                and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#"> 
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 1>
                    and (RHPDordmonto =  2 or RHPDordfecha =  1 or RHPDordfecha =  2)
                <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 2>
                     and (RHPDordmonto = 1 or RHPDordfecha =  1 or RHPDordfecha =  2)
                </cfif>
                <cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 3>
                     and  (RHPDordmonto = 1 or RHPDordmonto =  2  or RHPDordfecha =  2)
                 <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 4>
                    and  (RHPDordmonto = 2 or RHPDordmonto =  2  or RHPDordfecha =  1)
                 </cfif>
            </cfquery>

			<cfif isdefined('rsExiste') and rsExiste.RecordCount NEQ 0 >
                <cfset TitleErrs = 'Operación Inválida'>
                <cfset MsgErr	 = 'Inclusion no Válida'>
                <cfset DetErrs 	 = 'El Orden del registro que intenta agregar ya existe con otro criterio'>
                
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                <cfabort>
            </cfif>
        	
            <cfquery datasource="#session.DSN#" name="rsInsert">
                insert into RHPrioridadDed (RHPDcodigo, Ecodigo, RHPDdescripcion,  RHPDorden,RHPDordmonto, RHPDordfecha,  Usucodigo, BMUsucodigo)
                values ( <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.RHPDcodigo#">
                        , <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#"> 
                        , <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.RHPDdescripcion#">
                        , <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHPDorden#" >
                        <cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 1>
                             ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                        <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 2>
                             ,<cfqueryparam cfsqltype="cf_sql_integer" value="2">
                        <cfelse>
                            ,null
                         </cfif>
                         <cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 3>
                             ,<cfqueryparam cfsqltype="cf_sql_integer" value="1">
                         <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 4>
                             ,<cfqueryparam cfsqltype="cf_sql_integer" value="2">
                         <cfelse>
                            ,null
                         </cfif>
                        , <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Session.Usucodigo#" >
                        , <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">	 
                )
				<cf_dbidentity1>
            </cfquery>
            <cf_dbidentity2 name="rsInsert">
            <cf_translatedata name="set" tabla="RHPrioridadDed" col="RHPDdescripcion" valor="#form.RHPDdescripcion#" filtro="RHPDid = #rsInsert.identity#">
            	
		</cftransaction>
		
	<cfelseif isdefined("form.Cambio")>
		<!--- Actualizar una Prioridad de Deducción --->
		
		<cftransaction>
		
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHPrioridadDed"
				redirect="formPrioridadDeduccion.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHPDid" 
				type1="numeric" 
				value1="#form.RHPDid#">
		
			<cfquery datasource="#session.DSN#" name="rsExiste">
                select * 
                from RHPrioridadDed 
                where RHPDorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHPDorden#" >
                and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" 	value="#session.Ecodigo#"> 
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 1>
                    and (RHPDordmonto =  2 or RHPDordfecha =  1 or RHPDordfecha =  2)
                <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 2>
                     and (RHPDordmonto = 1 or RHPDordfecha =  1 or RHPDordfecha =  2)
                </cfif>
                <cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 3>
                     and  (RHPDordmonto = 1 or RHPDordmonto =  2  or RHPDordfecha =  2)
                 <cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 4>
                    and  (RHPDordmonto = 2 or RHPDordmonto =  2  or RHPDordfecha =  1)
                 </cfif>
                 and RHPDid <> #form.RHPDid#
            </cfquery>
            

			<cfif isdefined('rsExiste') and rsExiste.RecordCount NEQ 0 >
                <cfset TitleErrs = 'Observación'>
                <cfset MsgErr	 = 'Modificación no Válida'>
                <cfset DetErrs 	 = 'El Orden del registro que intenta Modificar ya existe con otro criterio'>
                
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(TitleErrs)#&ErrMsg= #URLEncodedFormat(MsgErr)# <br>&ErrDet=#URLEncodedFormat(DetErrs)#" addtoken="no">
                <cfabort>
            </cfif>
	
		<cfquery datasource="#session.DSN#">
			update RHPrioridadDed set 
					RHPDdescripcion = <cfqueryparam value="#Form.RHPDdescripcion#" cfsqltype="cf_sql_varchar">
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 1>
					, RHPDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 2>
					, RHPDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				<cfelse>
					, RHPDordmonto = null
				</cfif>
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 3>
					, RHPDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 4>
					, RHPDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				<cfelse>
					, RHPDordfecha = null
				</cfif>
                	, RHPDorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHPDorden#" >
                
 			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHPDid =  <cfqueryparam value="#form.RHPDid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cf_translatedata name="set" tabla="RHPrioridadDed" col="RHPDdescripcion" valor="#form.RHPDdescripcion#" filtro="RHPDid = #form.RHPDid#">
        <!---ljs se hace el update en la tabla de tipos de deduccion  para todas las prioridades que tienen 
		el mismos codigo de prioridad esto para mentener informacion de los clientes viejos --->
        <cfquery datasource="#session.DSN#">
			update TDeduccion set 
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 1>
					 TDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 2>
					 TDordmonto = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				<cfelse>
					 TDordmonto = null
				</cfif>
				<cfif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 3>
					, TDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
				<cfelseif isdefined("Form.RHPDcriterio") and Form.RHPDcriterio EQ 4>
					, TDordfecha = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
				<cfelse>
					, TDordfecha = null
				</cfif>
 			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
			  and TDprioridad =  <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.RHPDcodigo#">
		</cfquery> 
		
		</cftransaction>
		
		<cfset modo = 'CAMBIO'>
		  
	<!--- Borrar una Prioridad de Deducción --->
	<cfelseif isdefined("form.Baja")>
		<cftry>
        	<cfquery datasource="#session.DSN#" name="rsExiste">
				select * from RHPrioridadDed
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPDid =  <cfqueryparam value="#form.RHPDid#" cfsqltype="cf_sql_numeric">
                  and exists (select TDprioridad 
                  					from TDeduccion 
                                    	where TDprioridad = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.RHPDcodigo#">
                                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >)
			</cfquery>
            <cfif isdefined('rsExiste') and  rsExiste.RecordCount NEQ 0>
				<cfset Errs = #LB_ErrorTipoDed#>
                <cfset title = 'Operación Inválida'>
                <cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errtitle=#URLEncodedFormat(title)#&ErrMsg= Borrado NO Permitido<br>&ErrDet=#URLEncodedFormat(Errs)#" addtoken="no">
                <cfabort>
            </cfif>
			<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
                <cfinvokeargument  name="nombreTabla" value="RHPrioridadDed">		
                <cfinvokeargument name="condicion" value="Ecodigo = #Session.Ecodigo#  and RHPDid = #form.RHPDid#">
            </cfinvoke>
			<cfquery datasource="#session.DSN#" name="xx">
				delete from RHPrioridadDed
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHPDid =  <cfqueryparam value="#form.RHPDid#" cfsqltype="cf_sql_numeric">
                  and not exists (select TDprioridad 
                  					from TDeduccion 
                                    	where TDprioridad = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.RHPDcodigo#">
                                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >)
			</cfquery>
            
			<cfcatch type="any">
			 	<cf_throw message="#LB_ErrorTipoDed#" errorcode="187">
			</cfcatch>
		</cftry>	
	</cfif>
</cfif>	
<cfset args="">
<cfif isdefined('modo') and LEN(TRIM(modo))>
	<cfset args = args & "?modo=#modo#">
</cfif>
<cfif modo eq 'CAMBIO'>
	<cfset args = args & "&RHPDid=#RHPDid#">
</cfif>
<cfif isdefined('form.PageNum') and LEN(TRIM(form.PageNum))>
	<cfset args = args & "&PageNum=#form.PageNum#">	
</cfif>

<cflocation url="#action##args#">
