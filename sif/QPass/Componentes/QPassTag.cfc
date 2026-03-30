<cfcomponent>
<cfif not isdefined('session.DSN')>
	<cfset session.DSN = 'minisif'>
</cfif>
<cfif not isdefined('session.Ecodigo')>
    <cfset session.Ecodigo = 2>
</cfif>

<cfif isdefined('url.Usucodigo') and url.Usucodigo eq 11499>
    <cfset session.Ecodigo = 1>
</cfif>

   	<cffunction name="InsertaTag" access="public" returntype="numeric" output="no">
    	<cfargument name="Conexion" 			type="string" 	required="yes">
        <cfargument name="QPTNumParte" 			type="string" 	required="yes">
        <cfargument name="QPTFechaProduccion" 	type="date" 	required="yes">
        <cfargument name="QPTNumSerie"  		type="string" 	required="yes">
        <cfargument name="QPTPAN"  				type="string" 	required="yes">
        <cfargument name="QPTNumLote" 			type="string" 	required="yes" default="0">
        <cfargument name="QPTNumPall" 			type="string" 	required="yes">
        <cfargument name="QPidEstado"  			type="numeric" 	required="yes">
        <cfargument name="Ocodigo"  			type="numeric" 	required="yes">
        <cfargument name="QPidLote"  			type="numeric" 	required="no">
        <cfargument name="QPTEstadoActivacion" 	type="numeric" 	default="1">
        <cfargument name="QPTlista" 			type="string"  	required="yes" default="B">
        <cfargument name="Ecodigo"  			type="numeric" 	default="#session.Ecodigo#">
        <cfargument name="BMUsucodigo"  		type="numeric" 	default="#session.Usucodigo#">
		<cfargument name="BMFecha"  			type="date" 	default="#now()#">

        <cfquery name="_rsObtieneTag" datasource="#Arguments.Conexion#">
            select 
                QPTidTag,
                QPTNumParte,
                QPTFechaProduccion,
                QPTNumSerie,
                QPTPAN,
                QPTNumLote,
                QPTNumPall,
                QPTEstadoActivacion,
                QPidLote,
                QPidEstado,
                BMFecha,
                BMusucodigo,
                Ecodigo,
                Ocodigo,
				QPTlista,
                ts_rversion
            from QPassTag
            where Ecodigo = #Arguments.Ecodigo#
              and QPTPAN = 'Arguments.QPTPAN'
        </cfquery>

		<cfif _rsObtieneTag.recordcount GT 0>
        	<cfthrow message="El numero de Dispositivo #Arguments.APTPAN# ya se encuentra definido en la base de datos">
        </cfif>

		<cftransaction action="begin">
			<cfif not isdefined('Arguments.QPidLote')>
                <cfquery name="_rsVerificaLote" datasource="#Arguments.Conexion#">
                    select QPidLote
                    from QPassLote
                    where Ecodigo   = #Arguments.Ecodigo#
                      and QPLcodigo = '#Arguments.APTNumLote#'
                </cfquery>
                <cfif _rsVerificaLote.recordcount EQ 0>
                    <cfquery datasource="#session.dsn#">
                        insert into QPassLote 
                            (Ecodigo, QPLcodigo, QPLdescripcion, QPLfechaProduccion, QPLfechaFinVigencia, BMfecha, BMUsucodigo)
                        values 
                            (#Arguments.Ecodigo#, '#Arguments.QPTNumLote#', '#Arguments.QPTNumLote#', '#Arguments.QPTFechaProduccion#, #createdate(6100,1,1)#, #now()#, #Arguments.BMUsucodigo#)
                    </cfquery>
                    <cfquery name="_rsVerificaLote" datasource="#Arguments.Conexion#">
                        select QPidLote
                        from QPassLote
                        where Ecodigo   = #Arguments.Ecodigo#
                          and QPLcodigo = '#Arguments.APTNumLote#'
                    </cfquery>
                </cfif>
                <cfset Arguments.QPidLote = _rsVerificaLote.QPidLote>
            </cfif>

            <cfquery datasource="#Arguments.Conexion#">
                insert into QPassTag (
                    QPTNumParte,
                    QPTFechaProduccion,
                    QPTNumSerie,
                    QPTPAN,
                    QPTNumLote,
                    QPTNumPall,
                    QPTEstadoActivacion,
                    QPidLote,
                    QPidEstado,
                    BMFecha,
                    BMusucodigo,
                    Ecodigo,
					QPTlista,
                    Ocodigo )
                values (
                    '#Arguments.QPTNumParte#',
                    <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.QPTFechaProduccion#">,
                    '#Arguments.QPTNumSerie#',
                    '#Arguments.QPTPAN#',
                    '#Arguments.QPTNumLote#',
                    '#Arguments.QPTNumPall#',
                    #Arguments.QPTEstadoActivacion#,
                    #Arguments.QPidLote#,
                    #Arguments.QPidEstado#,
                    #Arguments.BMFecha#,
                    #Arguments.BMusucodigo#,
                    #Arguments.Ecodigo#,
					'#Arguments.QPTlista#',
                    #Arguments.Ocodigo# )
            </cfquery>
    
            <cfquery name="_rsObtieneTag" datasource="#Arguments.Conexion#">
                select 
                    QPTidTag,
                    QPTNumParte,
                    QPTFechaProduccion,
                    QPTNumSerie,
                    QPTPAN,
                    QPTNumLote,
                    QPTNumPall,
                    QPTEstadoActivacion,
                    QPidLote,
                    QPidEstado,
                    BMFecha,
                    BMusucodigo,
                    Ecodigo,
					QPTlista,
					Ocodigo,
                    ts_rversion
                from QPassTag
                where Ecodigo = #Arguments.Ecodigo#
                  and QPTPAN = '#Arguments.QPTPAN#'
            </cfquery>
            <cfset fnActualizaBitacoraTag(Arguments.Conexion, _rsObtieneTag.QPTidTag, 1, Arguments.BMusucodigo)>
		</cftransaction>
		<cfreturn _rsObtieneTag.QPTidTag>
    </cffunction>

	<cffunction name="ActualizaTag" 	access="public" returntype="boolean" output="no">
    	<cfargument name="Conexion" 	type="string" required="yes">
        <cfargument name="QPTidTag" 	type="numeric" required="no">
        <cfargument name="QPTNumParte"  type="string" required="no">
        <cfargument name="QPTFechaProduccion" type="date" required="no">
        <cfargument name="QPTNumSerie"  type="string" required="no">
        <cfargument name="QPTPAN"  		type="string" required="no">
        <cfargument name="QPTNumLote"   type="string" required="no">
        <cfargument name="QPTNumPall"   type="string" required="no">
        <cfargument name="QPTEstadoActivacion" type="numeric">
        <cfargument name="QPidLote"    type="numeric" required="no">
        <cfargument name="QPidEstado"  type="numeric" required="no">
        <cfargument name="BMusucodigo" type="numeric" required="no">
        <cfargument name="Ecodigo"     type="numeric" default="#session.Ecodigo#">
        <cfargument name="Ocodigo"     type="numeric" required="no">
        <cfargument name="QPTlista"    type="string"  required="yes" default="B">
        <cfargument name="QPTMovtipoMov" type="numeric" default="2">
	<cfargument name="AceptaVentaContingente" type="boolean" required="no" default="false">

        
        <cfif isdefined('Arguments.QPTidTag') or isdefined('Arguments.QPTPAN')>
	        <!--- Lectura / Asignacion de los valores que no se reciben de parametro --->
            <cfquery name="_rsObtieneTag" datasource="#Arguments.Conexion#">
                select 
                    QPTidTag,
                    QPTNumParte,
                    QPTFechaProduccion,
                    QPTNumSerie,
                    QPTPAN,
                    QPTNumLote,
                    QPTNumPall,
                    QPTEstadoActivacion,
                    QPidLote,
                    QPidEstado,
                    BMFecha,
                    BMusucodigo,
                    Ecodigo,
					QPTlista,
					Ocodigo,
                    ts_rversion
                from QPassTag
                <cfif isdefined('Arguments.QPTidTag') and len(trim(Arguments.QPTidTag))>
                    where QPTidTag = #Arguments.QPTidTag#
                <cfelse>
                    where Ecodigo = #Arguments.Ecodigo#
                      and QPTPAN = 'Arguments.QPTPAN'
                </cfif>
            </cfquery>
				
			<cfif _rsObtieneTag.recordcount LT 1>
            	<cfthrow message="No se encontro la información del Dispositivo">
                <cfabort>
            </cfif>
            <cfif _rsObtieneTag.recordcount GT 1>
            	<cfthrow message="Existe información incorrecta del Dispositivo">
                <cfabort>
            </cfif>
		<cfelse>
            	<cfthrow message="No se pasaron los parametros Correctos del Dispositivo para Actualizar los datos">
                <cfabort>
        </cfif>
		  
		<cfif not isdefined('Arguments.QPTEstadoActivacion')>
        	<cfset Arguments.QPTEstadoActivacion = _rsObtieneTag.QPTEstadoActivacion>
        </cfif>
		  
		<cfif Arguments.QPTEstadoActivacion eq -1>
        	<cfset Arguments.QPTEstadoActivacion = 1>
       </cfif>

		<cfif not isdefined('Arguments.BMusucodigo')>
			<cfif not isdefined('session.Usucodigo')>
                <cfset session.Usucodigo = 0>
            </cfif>
        	<cfset Arguments.BMusucodigo = session.Usucodigo>
        </cfif>

		<!--- Modificar la informacion del Tag con los parametros --->
		<cftransaction action="begin">
            <cfquery datasource="#arguments.Conexion#">
                update QPassTag
                    set 
                         QPTEstadoActivacion = #Arguments.QPTEstadoActivacion#
                        ,BMusucodigo 		 = #Arguments.BMusucodigo#
                    <cfif isdefined('Arguments.QPTNumParte')> 			,QPTNumParte = '#Arguments.QPTNumParte#'						</cfif>
                    <cfif isdefined('Arguments.QPTFechaProduccion')> 	,QPTFechaProduccion = <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.QPTFechaProduccion#">			</cfif>
                    <cfif isdefined('Arguments.QPTNumSerie')>			,QPTNumSerie = '#Arguments.QPTNumSerie#'						</cfif>
                    <cfif isdefined('Arguments.QPTPAN')>				,QPTPAN = '#Arguments.QPTPAN#'									</cfif>
                    <cfif isdefined('Arguments.QPTNumLote')>			,QPTNumLote = '#Arguments.QPTNumLote#'							</cfif>
                    <cfif isdefined('Arguments.QPTNumPall')>			,QPTNumPall = '#Arguments.QPTNumPall#'							</cfif>
                    <cfif isdefined('Arguments.QPidLote')>				,QPidLote = #Arguments.QPidLote#								</cfif>
                    <cfif isdefined('Arguments.QPidEstado')>			,QPidEstado = #Arguments.QPidEstado#							</cfif>
                    <cfif isdefined('Arguments.Ecodigo')>				,Ecodigo = #Arguments.Ecodigo#									</cfif>
                    <cfif isdefined('Arguments.Ocodigo') and Arguments.Ocodigo neq -1>	,Ocodigo = #Arguments.Ocodigo#				</cfif>
                    <cfif isdefined('Arguments.QPTlista')>				,QPTlista = '#Arguments.QPTlista#'</cfif>								
			    where QPTidTag = #_rsObtieneTag.QPTidTag#
            </cfquery>
	   <!--- *** Faltaba el movimiento positivo cuando se acepta contingente *** --->

	<cfif isdefined('arguments.AceptaVentaContingente') and arguments.AceptaVentaContingente>


	   <cf_dbfunction name="op_concat" returnvariable="_Cat">
	    <cfquery datasource="#arguments.Conexion#">
		insert into QPMovCuenta 
                    (
                        QPCid,     
                        QPctaSaldosid,
                        QPcteid,         
                        QPMovid,       
                        QPTidTag,     
                        QPMCFInclusion, 
                        QPMCFProcesa,  
                        QPMCFAfectacion,
                        Mcodigo,         
                        QPMCMonto,  
                        QPMCMontoLoc, 
                        BMFecha,
                        QPTPAN,
                        QPMCdescripcion  
                     )

		select 
			d.QPCid,     
                        e.QPctaSaldosid,
                        b.QPcteid,         
                        null,
                        a.QPTidTag,     
                        #now()#,
                        null,
                        null,

                        f.Mcodigo,         
                        f.QPCmonto,  
                        0,
                        #now()#,
                        a.QPTPAN,
                        'Venta Contingente TAG' #_Cat# ' ' #_Cat# a.QPTPAN
		from QPassTag a
			inner join QPventaTags b
			  on b.QPTidTag = a.QPTidTag
			inner join QPventaConvenio c
			  on c.QPvtaConvid = b.QPvtaConvid
			inner join QPCausaxConvenio d
			  on d.QPvtaConvid = c.QPvtaConvid

			inner join QPcuentaSaldos e
			  on e.QPctaSaldosid = b.QPctaSaldosid
			inner join QPCausa f
			  on f.QPCid = d.QPCid
		where b.QPTidTag = #_rsObtieneTag.QPTidTag#
		  and QPvtaEstado = 0
		  and QPCtipo = 4
	    </cfquery>
	</cfif>

            <cfset fnActualizaBitacoraTag(Arguments.Conexion, _rsObtieneTag.QPTidTag, Arguments.QPTMovtipoMov, Arguments.BMusucodigo)>
		</cftransaction> 
		<cfreturn true>
	</cffunction>

	<cffunction name="fnActualizaBitacoraTag" access="private" output="no">
    	<cfargument name="Conexion" 		type="string"  required="yes">
        <cfargument name="QPTidTag" 		type="numeric" required="yes">
        <cfargument name="QPTMovtipoMov" 	type="numeric" required="yes">
        <cfargument name="BMusucodigo"  	type="numeric" required="yes">

        <cfquery datasource="#Arguments.Conexion#">
            insert into QPassTagMov (
                    QPTidTag, QPTMovtipoMov, QPTNumParte, 
                    QPTFechaProduccion, QPTNumSerie, QPTPAN, QPTNumLote, 
                    QPTNumPall, QPTEstadoActivacion, 
                    Ecodigo, Ocodigo, OcodigoDest, QPidLote, QPidEstado, BMFecha, BMusucodigo)
            select
                    t.QPTidTag, #Arguments.QPTMovtipoMov#, t.QPTNumParte, 
                    t.QPTFechaProduccion, t.QPTNumSerie, t.QPTPAN, t.QPTNumLote, 
                    t.QPTNumPall, t.QPTEstadoActivacion, 
                    t.Ecodigo, t.Ocodigo, t.Ocodigo, t.QPidLote, t.QPidEstado, #now()#, #Arguments.BMusucodigo#
            from QPassTag t
            where t.QPTidTag = #Arguments.QPTidTag#
        </cfquery>
    </cffunction>        

	<cffunction name="fnObtieneInfoTag" access="public" output="no" hint="Obtiene la informacion del Dispositivo" returntype="query">
    	<cfargument name="Conexion" type="string" required="yes">
        <cfargument name="Ecodigo" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="QPTidTag" type="numeric" required="no">
        <cfargument name="QPTPAN"   type="string" required="no">
    
       <cfquery name="_rsObtieneTag" datasource="#Arguments.Conexion#">
            select 
                QPTidTag,
                QPTNumParte,
                QPTFechaProduccion,
                QPTNumSerie,
                QPTPAN,
                QPTNumLote,
                QPTNumPall,
                QPTEstadoActivacion,
                QPidLote,
                QPidEstado,
                BMFecha,
                BMusucodigo,
                Ecodigo,
				QPTlista,
				Ocodigo,
                ts_rversion
            from QPassTag
            <cfif isdefined('Arguments.QPTidTag')>
                where QPTidTag = #Arguments.QPTidTag#
            <cfelse>
                where Ecodigo = #Arguments.Ecodigo#
                  and QPTPAN = 'Arguments.QPTPAN'
            </cfif>
        </cfquery>
        <cfif _rsObtieneTag.recordcount LT 1>
            <cfthrow message="No se encontro la información del Dispositivo">
            <cfabort>
        </cfif>
    
		<cfreturn _rsObtieneTag>
    </cffunction>

	<cffunction name="fnOEstadoAnteriorTag" access="public" output="no" hint="Obtiene la informacion del Dispositivo" returntype="array">
    	<cfargument name="Conexion" type="string"  default="#session.dsn#">
        <cfargument name="Ecodigo" 	type="numeric" default="#Session.Ecodigo#">
        <cfargument name="QPTidTag" type="numeric" required="no" default="-1">
        <cfargument name="QPTPAN"   type="string" required="no" default="-1">

		<cfif (not isdefined('Arguments.QPTidTag') and not isdefined('Arguments.QPTPAN')) or (Arguments.QPTidTag eq -1 and Arguments.QPTPAN eq "-1")>
        	<cfthrow message="No se indicaron los parametros correctos en la invocacion de la funcion fnOEstadoAnteriorTag. Debe de indicarse la identificacion del Dispositivo o el PAN requerido">
        </cfif>

		<cfset LvarQPreturn[1] = -1>
		<cfset LvarQPreturn[2] = -1>
		<cfset LvarQPreturn[3] = -1>
		<cfset LvarQPreturn[4] = -1>
		<cfset LvarQPreturn[5] = -1>
		<cfset LvarQPreturn[6] = -1>
		<cfset LvarQPreturn[7] = -1>

		<cfif not isdefined('Arguments.QPTidTag')>
            <cfquery name="_rsObtieneTag" datasource="#Arguments.Conexion#">
                select QPTidTag
                from QPassTag
                where Ecodigo = #Arguments.Ecodigo#
                  and QPTPAN = 'Arguments.QPTPAN'
            </cfquery>
            <cfif _rsObtieneTag.recordcount LT 1>
				<cfreturn LvarQPreturn>
                <cfabort>
            </cfif>
			<cfset Arguments.QPTidTag = _rsObtieneTag.QPTidTag>
        </cfif>

		<!--- [1] id del Tag:  Se regresa el del Tag --->
		<cfset LvarQPreturn[1] = Arguments.QPTidTag>

		<cfquery name="_rsObtieneEstadoAnterior" datasource="#Arguments.Conexion#" maxrows="5">
        	select BMFecha, QPTEstadoActivacion, QPTMovtipoMov
            from QPassTagMov
            where QPTidTag = #Arguments.QPTidTag#
            order by QPTMovid desc
        </cfquery>

		<!--- 
			[2] Tipo del ultimo Movimiento :  Se regresa el ultimo tipo de movimiento de la bitacora de movimientos de tag 
			[3] Estado del ultimo Movimiento
			[4] Tipo de Movimiento TrasAnterior
			[5] Estado del movimiento TrasAnterior 
			[6] Tipo de Movimiento TrasTrasAnterior
			[7] Estado del movimiento TrasTrasAnterior 
		--->


		<cfloop query="_rsObtieneEstadoAnterior">
			<cfif _rsObtieneEstadoAnterior.currentrow EQ (-1)>
				<cfset LvarQPreturn[2] = _rsObtieneEstadoAnterior.QPTMovtipoMov>
				<cfset LvarQPreturn[3] = _rsObtieneEstadoAnterior.QPTEstadoActivacion>
			</cfif>

			<cfif _rsObtieneEstadoAnterior.currentrow EQ 1>
				<cfset LvarQPreturn[2] = _rsObtieneEstadoAnterior.QPTMovtipoMov>
				<cfset LvarQPreturn[3] = _rsObtieneEstadoAnterior.QPTEstadoActivacion>
			</cfif>
			<cfif _rsObtieneEstadoAnterior.currentrow EQ 2>
				<cfset LvarQPreturn[4] = _rsObtieneEstadoAnterior.QPTMovtipoMov>
				<cfset LvarQPreturn[5] = _rsObtieneEstadoAnterior.QPTEstadoActivacion>
			</cfif>
			<cfif _rsObtieneEstadoAnterior.currentrow EQ 3>
				<cfset LvarQPreturn[6] = _rsObtieneEstadoAnterior.QPTMovtipoMov>
				<cfset LvarQPreturn[7] = _rsObtieneEstadoAnterior.QPTEstadoActivacion>
			</cfif>
        </cfloop>
    	<cfreturn LvarQPreturn>
    </cffunction>

	<cffunction name="fnRegresaEstadoAnteriorTag" access="public" output="no" hint="Regresa el Dispositivo a su Estado Anterior por la anulacion" returntype="boolean">
    	<cfargument name="Conexion" 				type="string"  default="#session.dsn#">
        <cfargument name="Ecodigo" 					type="numeric" default="#Session.Ecodigo#">
        <cfargument name="QPTidTag" 				type="numeric" required="no" default="-1">
        <cfargument name="QPTPAN"   				type="string" required="no" default="-1">
		<cfargument name="RechazaDesdeAceptacion" 	type="boolean" required="no" default="false">
        <cfargument name="RechazaDesdeAnulacion"  	type="boolean" required="no" default="false">

		<cfif (not isdefined('Arguments.QPTidTag') and not isdefined('Arguments.QPTPAN')) or (Arguments.QPTidTag eq -1 and Arguments.QPTPAN eq "-1")>
        	<cfthrow message="No se indicaron los parametros correctos en la invocacion de la funcion fnOEstadoAnteriorTag. Debe de indicarse la identificacion del Dispositivo o el PAN requerido">
        </cfif>

		<!--- 
			LvarDatos.  Arreglo
				[1] = Id del Tag
				[2] = Tipo de Movimiento del Ultimo Movimiento
				[3] = Estado del Ultimo movimiento
				[4] = Tipo del Movimiento TrasAnterior
				[5] = Estado del Movimiento TrasAnterior
				[6] = Tipo del Movimiento TrasTrasAnterior
				[7] = Estado del Movimiento TrasTrasAnterior
		--->
        
		<cfset LvarDatos = fnOEstadoAnteriorTag(Arguments.Conexion, Arguments.Ecodigo, Arguments.QPTidTag, Arguments.QPTPAN)>  
		
		<!--- si se rechaza desde la pantalla de Anulacion se usan 5 y 4 --->
		<cfset _LvarEstadoAnterior = LvarDatos[5]>
		<cfset _LvarTipoMovimiento = LvarDatos[4]> <!--- estaba en 2--->

		<!--- si se rechaza desde la pantalla de aceptacion o Anulación se debe dejar el tag en estado 1 y tipo mov 4 --->
		<cfif isdefined('arguments.RechazaDesdeAceptacion') and arguments.RechazaDesdeAceptacion>
			<cfset _LvarEstadoAnterior = 1>
			<cfset _LvarTipoMovimiento = 4>
		</cfif>
        
        <cfif isdefined('arguments.RechazaDesdeAnulacion') and arguments.RechazaDesdeAnulacion>
			<cfset _LvarEstadoAnterior = 1>
			<cfset _LvarTipoMovimiento = 4>
		</cfif>


		<!--- si se vende el tag y se hacen varios cambios en el tag vendido graba estado: 4 tipomov: 2 n veces y al anular queda mal el tag sin porder venderce de nuevo --->
		<cfif _LvarEstadoAnterior EQ 4 and _LvarTipoMovimiento eq 2>
			<cfset _LvarEstadoAnterior = 1> <!--- 1: En Banco / Almacen o Sucursal--->
			<cfset _LvarTipoMovimiento = 4> <!--- 4: Recepcion de Traslado hacia Oficinas --->
		</cfif>

		<!--- Condicion Especial:  Si el estado anterior es en proceso de venta ( Estado = 4 ) debe de regresar el estado a un nivel anterior --->
		<cfif _LvarEstadoAnterior EQ 4>
			<cfset _LvarEstadoAnterior = LvarDatos[7]>
		</cfif>
        
        <cfset LvarOficina = -1>
        <cfif isdefined('session.usucodigo') and len(trim(session.usucodigo))>
            <cfquery name="rsOficina" datasource="#session.DSN#">
                select min(Ocodigo) as Ocodigo
                from QPassUsuarioOficina
                where Ecodigo = #session.Ecodigo#
                and Usucodigo = #session.usucodigo#
            </cfquery>
            <cfif rsOficina.recordcount eq 0 and len(trim(rsOficina.Ocodigo)) eq 0>
                <cfthrow message="El usuario #session.usucodigo# que intenta anular la venta no está asociado a ninguna sucursal, proceso cancelado!">
                <cfreturn false>
            </cfif>
            <cfset LvarOficina = rsOficina.Ocodigo>
        </cfif>

		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="ActualizaTag" returnvariable="void">
			<cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
			<cfinvokeargument name="QPTidTag" value="#LvarDatos[1]#">
			<cfinvokeargument name="QPTEstadoActivacion" value="#_LvarEstadoAnterior#">
			<cfinvokeargument name="QPTMovtipoMov" value="#_LvarTipoMovimiento#">
            <cfinvokeargument name="Ocodigo" value="#LvarOficina#">
		</cfinvoke>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="fnProcesaVenta" access="public" output="false" hint="Procesa la Venta de un Tag">
		<cfargument name="Conexion" type="string" required="no" default="#session.dsn#">
		<cfargument name="QPvtaTagid" type="numeric" required="yes">
		
		<cfquery name="_rsRegistroVenta" datasource="#Arguments.Conexion#">
			select b.QPvtaTagid, b.QPTidTag
			from QPventaTags b
			where b.QPvtaTagid = #Arguments.QPvtaTagid#
			  and b.QPvtaEstado = 0
		</cfquery>
		
		<cftransaction action="begin">
			<cfinvoke component="sif.QPass.Componentes.QPassTag" method="ActualizaTag" returnvariable="LvarResultado">
				<cfinvokeargument name="Conexion" value="#Arguments.Conexion#">
				<cfinvokeargument name="QPTidTag" value="#_rsRegistroVenta.QPTidTag#">
				<cfinvokeargument name="QPTEstadoActivacion" value="4">
				<cfinvokeargument name="QPTMovTipoMov" value="6">
			</cfinvoke>
			<cfif LvarResultado>
				<cfquery datasource="#session.dsn#">
					Update QPventaTags
					set QPvtaEstado = 1
					where QPvtaTagid   = #_rsRegistroVenta.QPvtaTagid#
				</cfquery>
			</cfif>
		</cftransaction>
	</cffunction>
	<cffunction name="fnRechazaVenta" access="public" output="no" hint="Rechaza la Venta Realizada" returntype="boolean">
    	<cfargument name="Conexion" 				type="string"  default="#session.dsn#">
        <cfargument name="Ecodigo" 					type="numeric" default="#Session.Ecodigo#">
        <cfargument name="QPTidTag" 				type="numeric" required="no" default="-1">
        <cfargument name="QPTPAN"   				type="string"  required="no" default="-1">
		<cfargument name="QPvtaTagid"				type="numeric" required="yes">
        <cfargument name="QPvtaEstado"  			type="numeric" required="no" default="2">
		<cfargument name="RechazaDesdeAceptacion"   type="boolean" required="no" default="false">
    	<cfargument name="RechazaDesdeAnulacion"    type="boolean" required="no" default="false">
	
		<cfinvoke component="sif.QPass.Componentes.QPassTag" method="fnRegresaEstadoAnteriorTag" returnvariable="LvarResultado">
			<cfinvokeargument name="Conexion" 		value="#Arguments.Conexion#">
			<cfinvokeargument name="QPTidTag" 		value="#Arguments.QPTidTag#">
			<cfinvokeargument name="RechazaDesdeAceptacion" value="#Arguments.RechazaDesdeAceptacion#">
            <cfinvokeargument name="RechazaDesdeAnulacion" value="#Arguments.RechazaDesdeAceptacion#">
		</cfinvoke>
		<cfif LvarResultado>
			<cfquery datasource="#session.dsn#">
				Update QPventaTags
				set QPvtaEstado = #Arguments.QPvtaEstado#
				where QPvtaTagid   = #Arguments.QPvtaTagid#
			</cfquery>
		</cfif>
		<cfreturn true>
	</cffunction>
</cfcomponent>
