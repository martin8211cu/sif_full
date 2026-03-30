
<cfset params = 'sel=2&RHTTid=#Form.RHTTid#&PAGENUM=#Form.PAGENUM#&modo=#modo#'>

<cfif isdefined('form.RHVTidL') and LEN(TRIM(form.RHVTidL))><cfset params = params & "&RHVTidL=#form.RHVTidL#"></cfif>

<cfif isdefined('form.RHVTidL') and (not isdefined('form.RHVTid') or LEN(TRIM(form.RHVTid)) EQ 0)>
	<cfset form.RHVTid = form.RHVTidL>
</cfif>
	<!--- BUSCA EL ID DEL SALARIO BASE --->
	<cfquery name="rsSalarioBase" datasource="#session.DSN#">
		select CSid
		from ComponentesSalariales
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CSsalariobase = 1
		and CSusatabla = 1
	</cfquery>
	<cfset ComponenteSB = rsSalarioBase.CSid>
<cfif isdefined('form.Agregar')>

	<!--- SE BUSCA EL CODIGO SIGUIENTE DE LA TABLA --->
	<cfquery name="getCodigo" datasource="#session.DSN#">
		select coalesce(max(RHVTcodigo),0) + 1  as codigo
		from RHVigenciasTabla
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<!---- VALIDAR QUE LA NUEVA VIGENCIA SEA MAYOR A LA ULTIMA VIGENCIA ----->
	<cfquery name="verificaFechaRige" datasource="#session.DSN#">
		select count(1) as cantRegistros
		from RHVigenciasTabla a
		where  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHVTfecharige)#">  <= (select max(RHVTfecharige ) 
																												from RHVigenciasTabla b					
																												where b.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
																											   )
			and a.RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
	</cfquery>
    
<!---	<cfif isdefined("verificaFechaRige") and verificaFechaRige.RecordCount NEQ 0 and verificaFechaRige.cantRegistros GT 0>
        
    </cfif>
--->
		<cftransaction>
		<!--- GUARDA LA VIGENCIA --->
		<cfquery name="insertaVigencia" datasource="#session.DSN#">
			insert into RHVigenciasTabla (RHTTid,RHVTfecharige,RHVTtablabase,RHVTdocumento,Ecodigo,RHVTcodigo,RHVTdescripcion
            	,BMUsucodigo,RHVTestado,RHVTfechahasta,BMfalta,BMfmod, Mcodigo, RHVTtipocambio )
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">,
				<cfqueryparam cfsqltype="cf_sql_date" 	 value="#LSParseDateTime(Form.RHVTfecharige)#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTidref#" null="#len(trim(Form.RHVTidref)) eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdocumento#" null="#len(trim(Form.RHVTdocumento)) eq 0#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#getCodigo.codigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				'P',
				<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(6100, 01, 01)#">,
				<cf_dbfunction name="today">,
				<cf_dbfunction name="today">,
                <cf_JDBCquery_param cfsqltype="cf_sql_numeric" 	voidnull null="#len(form.Mcodigo)  EQ 0#" value="#form.Mcodigo#">,
                <cf_JDBCquery_param cfsqltype="cf_sql_float" 	voidnull null="#len(form.RHVTtipocambio)  EQ 0#" value="#form.RHVTtipocambio#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertaVigencia">
		<cf_translatedata name="set" tabla="RHVigenciasTabla" col="RHVTdescripcion" valor="#Form.RHVTdescripcion#" filtro="RHVTid = #insertaVigencia.identity#">

		
		<cfinvoke component="rh.Componentes.RH_EstructuraSalarial"  method="generarComponentesSB">
				<cfinvokeargument name="RHTTid" value="#form.RHTTid#">
				<cfinvokeargument name="Conexion" value="#session.dsn#">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
				<cfinvokeargument name="Debug" value="false">	
		</cfinvoke>
		
		<!--- SI TIENE UN TABLA BASE SE TIENEN QUE INSERTAR LOS REGISTROS --->
		<cfif isdefined('form.RHVTidref') and LEN(TRIM(form.RHVTidref))>
        
        	<!---20140217 ljimenez se insertan los componentes que estan asociados al puesto tabla categoria--->
            <cfquery name="insertaTB" datasource="#session.DSN#">
				insert into RHMontosCategoria (RHVTid,RHCid, RHMCmonto, RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)
				select distinct #insertaVigencia.identity#, 
					a.RHCid,coalesce(b.RHMCmonto,0.00),coalesce(b.RHMCmonto,0.00),0,0,
					rh.CSid,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHCategoriasPuesto a
					inner join RHCPcomponentes rh
						on a.RHCPlinea=rh.RHCPlinea	
					left join 	RHMontosCategoria b
						on b.RHCid = a.RHCid
						and b.CSid = rh.CSid
   					    and b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTidref#">
				where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
            
        	<!---20140217 ljimenez IICA se insertan los componentes que estan asociados a la  categoria directamente y que no estan asociados a la relacion puesto tabla categoria--->
			<cfquery name="insertaTB" datasource="#session.DSN#">
				insert into RHMontosCategoria (RHVTid,RHCid, RHMCmonto, RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)
				select distinct #insertaVigencia.identity#, 
					a.RHCid,coalesce(c.RHMCmonto,0.00),coalesce(c.RHMCmonto,0.00),0,0,
					b.CSid,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from  RHCategoria a
                inner join RHCcomponentes b
                    on a.RHCid  = b.RHCid
               	inner join RHCategoriasPuesto d
                	on a.RHCid = d.RHCid

                left join 	RHMontosCategoria c
                    on c.RHCid = b.RHCid
                        and c.CSid = b.CSid 
   					    and c.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTidref#">
				where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	                and d.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
    	            and not exists (select 1 from RHMontosCategoria aa where aa.RHVTid = #insertaVigencia.identity# and aa.RHCid = a.RHCid and aa.CSid = b.CSid)
			</cfquery>
		<cfelse>
			<!--- NO TIENE UNA TABLA DE REFERENCIA ENTONCES INGRESA LAS CATEGORAS EXISTENTES --->
			<cfquery name="insertaCat" datasource="#session.DSN#">
				insert into RHMontosCategoria (RHVTid,RHCid, RHMCmonto, RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid, BMfalta, BMfmod, BMUsucodigo)
				select distinct #insertaVigencia.identity#, 
					a.RHCid,0,0,0,0,
					rh.CSid,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				from RHCategoriasPuesto a
					inner join RHCPcomponentes rh
						on a.RHCPlinea=rh.RHCPlinea	
				where a.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and RHTTid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			</cfquery>
		</cfif>
		 <cfset params = params & '&RHVTid='&insertaVigencia.identity&'&RHVTidL='&insertaVigencia.identity>

		 <!--- Se consulta si se ha insertado una vigencia que contiene una empresa distinta 
		 		a la del componente salarial asociada --->
		 <cfquery name="rsExisteVigencia" datasource="#session.DSN#">
			select count(1) as Valor
			from RHMontosCategoria a 
				inner join RHVigenciasTabla b 
				    on a.RHVTid=b.RHVTid  
				inner join ComponentesSalariales cs
				    on a.CSid= cs.CSid
				    and b.Ecodigo<>cs.Ecodigo
			where b.RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#insertaVigencia.identity#">
		</cfquery>
		<cfif rsExisteVigencia.RecordCount and rsExisteVigencia.Valor GT 0>
			<cftransaction action="rollback" />
			<cf_errorcode code="50234" msg="@errorDat_1@ Proceso Cancelado!" detail="La vigencia que desea agregar contiene inconsistencias. Favor verificar la información y no interrumpir la operación mientras está en proceso." errorDat_1="Error de Integridad de datos"/>   
		</cfif>


		</cftransaction>
	<!---<cfelse>
		<cfset err='La fecha rige de la vigencia debe ser mayor a la última vigencia para la tabla salarial'>
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&ErrMsg=Errores Encontrados<br>&ErrDet=#URLEncodedFormat(err)#" addtoken="no">	
	</cfif>--->
	<cflocation url="tipoTablasSal.cfm?#params#">
<cfelseif isdefined('form.modificar')>
	<cftransaction>
		<!--- TRAE DATOS ACTUALES --->
        <cfquery name="rsDatosVig" datasource="#session.DSN#">
            select RHVTtablabase
            from RHVigenciasTabla
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
              and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
              and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
        </cfquery>
        <cfset Lvar_TablaBaseA = rsDatosVig.RHVTtablabase>
    
        <!--- MODIFICA EL ENCABEZADO DE LA VIGENCIA --->

        <cfquery name="updateVigencia" datasource="#session.DSN#">
            update RHVigenciasTabla
            set RHVTfecharige 	= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.RHVTfecharige)#">,
                RHVTtablabase 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTidref#" null="#len(trim(Form.RHVTidref)) eq 0#">,
                RHVTdocumento 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdocumento#" null="#len(trim(Form.RHVTdocumento)) eq 0#">,
                RHVTdescripcion = 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHVTdescripcion#">,
                BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                BMfmod			= <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
	            Mcodigo			= <cf_JDBCquery_param cfsqltype="cf_sql_numeric" 	voidnull null="#len(form.Mcodigo) EQ 0#" value="#form.Mcodigo#">,
                RHVTtipocambio	= <cf_JDBCquery_param cfsqltype="cf_sql_float" 	voidnull null="#len(form.RHVTtipocambio)  EQ 0#" value="#form.RHVTtipocambio#">
                
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
            and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
        </cfquery>
        <cf_translatedata name="set" tabla="RHVigenciasTabla" col="RHVTdescripcion" valor="#Form.RHVTdescripcion#" filtro="RHVTid = #Form.RHVTid#">

        <!--- VERIFICA LA TABLA BASE --->
        <cfif Lvar_TablaBaseA NEQ Form.RHVTidref>
            <cfquery name="deleteMontoC" datasource="#session.DSN#">
                delete from RHMontosCategoria
                where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
            </cfquery>
            <cfif LEN(TRIM(Form.RHVTidref)) and form.RHVTidref GT 0>
                <!--- ASIGNA UNA TABLA BASE --->
                <cfquery name="insertaTB" datasource="#session.DSN#">
                    insert into RHMontosCategoria (RHVTid, RHCid, RHMCmonto,RHMCmontoAnt, RHMCmontoFijo,RHMCmontoPorc,CSid,BMfalta, BMfmod, BMUsucodigo)
                    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
                            , RHCid, RHMCmonto,RHMCmonto,0,0,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#ComponenteSB#">,
                           <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                           <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
                           <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
                    from RHMontosCategoria 
                    where RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTidref#">
                </cfquery>
            </cfif>
        </cfif>
        <cfset params = params & '&RHVTid='&form.RHVTid&'&RHVTidL='&form.RHVTid>
	</cftransaction>
	<cflocation url="tipoTablasSal.cfm?#params#">
<cfelseif isdefined('form.Eliminar')>
	<cftransaction>
    	<cfif isdefined('form.RHVTidL') and (not isdefined('form.RHVTid') or LEN(TRIM(form.RHVTid)) EQ 0)>
		<cfset form.RHVTid = form.RHVTidL>
        </cfif>
	<!--- SE ELIMINA UNA VIGENCIA DE UNA TABLA SIEMPRE Y CUANDO ESTE PENDIENTE--->
		<!--- SE ELIMINAN LOS MONTOS POR CATEGORIA --->
		<cfquery name="borraMontos" datasource="#session.DSN#">
			delete from RHMontosCategoria
			where  RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
		</cfquery>
		<cfquery name="borraVigencia" datasource="#session.DSN#">
			delete from RHVigenciasTabla
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
			  and RHVTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHVTid#">
			  and RHVTestado = 'P' <!--- PENDIENTE --->
		</cfquery>
	</cftransaction>
	<cfset params = 'sel=2&RHTTid=#Form.RHTTid#&PAGENUM=#Form.PAGENUM#&modo=#modo#'>
	<cflocation url="tipoTablasSal.cfm?#params#">
<cfelse>
	<cfset params = 'sel=2&RHTTid=#Form.RHTTid#&PAGENUM=#Form.PAGENUM#&modo=#modo#'>
	<cflocation url="tipoTablasSal.cfm?#params#">
</cfif>


