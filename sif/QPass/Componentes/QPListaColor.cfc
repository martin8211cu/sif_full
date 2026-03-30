<cfcomponent output="no">
	<cfif not isdefined('session.DSN')>
    	<cfset session.DSN = 'minisif'>
    </cfif>
    <cfif not isdefined('session.Ecodigo')>
    	<cfset session.Ecodigo = 2>
    </cfif>
    <cfif isdefined('url.Usucodigo') and url.Usucodigo eq 11499>
        <cfset session.Ecodigo = 1>
    </cfif>
    
	<cffunction name="fnActualizaTags" output="no" access="public" returntype="numeric" hint="Actualizar Tags que tengan lista asociada en nulo a Lista Blanca (para actualizar cualquier tag que tanga la columna en valor nulo)">
		<cfargument name="Tag" 		type="string" required="no" default="-1">
        <cfargument name='Ecodigo'  type='string' required='false' default="#session.Ecodigo#">
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsBusca" datasource="#arguments.conexion#">
        	select QPTidTag
            from QPassTag
            where QPTlista is null
            <cfif arguments.Tag neq '-1'>
            	and QPTPAN = '#arguments.Tag#' 
            </cfif>
        </cfquery>
        
        <cfif rsBusca.recordcount gt 0>
            <cfloop query="rsBusca">
                <cfinvoke component="QPListaColor" method="ActualizaTag" returnvariable="LvarResultado">
                    <cfinvokeargument name="IDTAG" value="#rsBusca.QPTidTag#">
                    <cfinvokeargument name="Lista" value="B">
                </cfinvoke>
            </cfloop>
       </cfif>
       
		<cfreturn 1>
	</cffunction>

	<cffunction name="fnTagPromotores" access="public" output="no" returntype="numeric" hint="Evaluar los Tags en poder de promotores, identificando Lista Blanca o Lista Negra según parámetro  de Promotor (puntos seguros)">
    	<cfargument name="Tag" 		type="string" required="no" default="-1">
        <cfargument name='Ecodigo'  type='string' required='false' default="#session.Ecodigo#">
        <cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsTagPromotores" datasource="#arguments.conexion#">
			select t.QPTPAN, t.QPTidTag
			from QPPromotor p 
                inner join QPassTag t
                on t.QPPid = p.QPPid
			where p.Ecodigo = #arguments.Ecodigo#
   				and ( p.QPPPuntoSeguro = 1 or p.QPPPuntoSeguro is null )<!--- QPPPuntoSeguro:  1=seguro, 2=inseguro --->
	 			and 
					(select count(1)
					 from QPassEstado a
					 where a.QPidEstado = t.QPidEstado
					 and QPEdisponibleVenta = 1 --<!--- Disponible para la venta 1:si, 0:no --->
					) > 0				
				
        </cfquery>
        
        <cfloop query="rsTagPromotores">
            <cfinvoke component="QPListaColor" method="ActualizaTag">
                <cfinvokeargument name="IDTAG" value="#rsTagPromotores.QPTidTag#">
                <cfinvokeargument name="Lista" value="B">
            </cfinvoke>
        </cfloop>
        
        <cfquery name="rsTagPromotores" datasource="#arguments.conexion#">
			select t.QPTPAN, t.QPTidTag
            from QPPromotor p
				inner join QPassTag t
				on t.QPPid = p.QPPid
            where p.Ecodigo = #arguments.Ecodigo#
	  		and QPPPuntoSeguro = 2  <!--- QPPPuntoSeguro:  1=seguro, 2=inseguro --->
            and (select count(1)
                 from QPassEstado a
                 where a.QPidEstado = t.QPidEstado
                 and (
                 		QPEdisponibleVenta = 0 <!--- Disponible para la venta 1:si, 0:no --->
                      or
                         QEPvalorDefault <> 1  <!--- Si no esta en valordefault 1 entonces debe ir en lista negra --->
                      )
                 ) > 0	
        </cfquery>
        
        <cfloop query="rsTagPromotores">
            <cfinvoke component="QPListaColor" method="ActualizaTag">
                <cfinvokeargument name="IDTAG" value="#rsTagPromotores.QPTidTag#">
                <cfinvokeargument name="Lista" value="N">
            </cfinvoke>
        </cfloop>
        
        <cfreturn 1>
    </cffunction>
    
    <cffunction name="fnVentasPrepago" access="public" output="no" returntype="numeric" hint="Evaluar las cuentas de prepago según los parámetros establecidos en la tabla de parámetros">
    	<cfargument name="Tag" 		type="string" required="no" default="-1">
        <cfargument name='Ecodigo'  type='string' required='false' default="#session.Ecodigo#">
        <cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsListaBlanca" datasource="#arguments.conexion#">
        	select Pvalor
            from QPParametros
            where Ecodigo = #arguments.Ecodigo#
            and Pcodigo = 10
        </cfquery>
        <cfset LvarListaBlanca = rsListaBlanca.Pvalor>
        
        <cfquery name="rsListaNegra" datasource="#arguments.conexion#">
        	select Pvalor
            from QPParametros
            where Ecodigo = #arguments.Ecodigo#
            and Pcodigo = 20
        </cfquery>
        <cfset LvarListaNegra = rsListaNegra.Pvalor>
        
        <!--- Todas la ventas de tipo Prepago --->
        <cfquery name="rsVentasPrepago" datasource="#arguments.conexion#">
        	select 
            	a.QPctaSaldosSaldo, 
                a.Mcodigo, 
                b.QPTidTag,
                (select bb.QEPvalorDefault    <!--- Si no esta en valordefault 1 entonces debe ir en lista negra --->
                	from QPassTag aa 
                    inner join QPassEstado bb
                      on bb.QPidEstado = aa.QPidEstado
                 where aa.QPTidTag = b.QPTidTag) as QEPvalorDefault
            from QPcuentaSaldos a
            	inner join QPventaTags b
                	on b.QPctaSaldosid = a.QPctaSaldosid
	            <cfif arguments.Tag neq '-1'>
                	inner join QPassTag c
                    	on c.QPTidTag = b.QPTidTag
                </cfif>
            where a.Ecodigo = #arguments.Ecodigo#
            and a.QPctaSaldosTipo = 2 <!--- 1=PostPago, 2=Prepago --->
            <cfif arguments.Tag neq '-1'>
            	and c.QPTPAN = '#arguments.Tag#'
            </cfif>
        </cfquery>
        
        <cfloop query="rsVentasPrepago">
        	<cfif rsVentasPrepago.QEPvalorDefault eq 1 and rsVentasPrepago.QPctaSaldosSaldo GTE LvarListaBlanca> <!--- si el estado es "activo", y le alcanza el saldo poner color tag blanco --->
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="B">
                </cfinvoke>
                
            <cfelseif rsVentasPrepago.QEPvalorDefault eq 1 and rsVentasPrepago.QPctaSaldosSaldo GTE LvarListaNegra and rsVentasPrepago.QPctaSaldosSaldo LT LvarListaBlanca> <!--- si el estado es "activo", tiene saldo mayor o igual al parametro de lista negra y menor que parametro de lista blanca,  poner color tag gris --->
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="G">
                </cfinvoke>
            <cfelseif rsVentasPrepago.QEPvalorDefault eq 0 or rsVentasPrepago.QPctaSaldosSaldo LT LvarListaNegra> <!--- si el estado es "inactivo" o saldo es menor que el parametro de lista negra, poner color tag negro --->
	            <cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="N">
                </cfinvoke>
            </cfif>
        </cfloop>

        <cfreturn 1>
    </cffunction>
    
    
    
    <!--- Ventas Postpago --->
    <cffunction name="fnVentasPostpago" access="public" output="yes" returntype="numeric" hint="Evaluar las cuentas de prepago según los parámetros establecidos en la tabla de parámetros">
        <cfargument name='Ecodigo'  type='string' required='false' default="#session.Ecodigo#">
        <cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsListaNegraPostPago" datasource="#arguments.conexion#">
        	select Pvalor
            from QPParametros
            where Ecodigo = #arguments.Ecodigo#
            and Pcodigo = 25
        </cfquery>

        <cfset LvarListaNegraPostPago = rsListaNegraPostPago.Pvalor>
        <!--- Busca el último lote procesado al momento de generar la lista --->
        <cfquery name="rsQPListaControl" datasource="#session.DSN#">
        	select max(qplc_id) as qplc_id
            from QPListaControl
            where qplc_estado = 6
        </cfquery>
        
        
        <!--- Todas la ventas de tipo Prepago --->
        <cfquery name="rsVentasPostpago" datasource="#arguments.conexion#">
        	select 
            	a.QPctaSaldosSaldo, 
                a.Mcodigo,
                b.QPTidTag,
                d.qpdlc_lista,
                (select aa.QEPvalorDefault    <!--- Si no esta en valordefault 1 entonces debe ir en lista negra --->
                	from QPassEstado aa
                 where aa.QPidEstado = c.QPidEstado) as QEPvalorDefault
            from QPcuentaSaldos a
            	inner join QPventaTags b
                	on b.QPctaSaldosid = a.QPctaSaldosid
                inner join QPassTag c
                   	on c.QPTidTag = b.QPTidTag
                inner join QPListaSalida d
                    on d.qpdlc_Tag = c.QPTidTag
            where a.Ecodigo = #arguments.Ecodigo#
            and a.QPctaSaldosTipo = 1 <!--- 1=PostPago, 2=Prepago --->
            and d.qplc_id = #rsQPListaControl.qplc_id#
        </cfquery> <!--- <cfdump var="#rsVentasPostpago#">  --->
        
        <cfloop query="rsVentasPostpago">
	        <!---  <cfoutput>#rsVentasPostpago.QPTidTag# Inicio</cfoutput><br>  --->
        	<cfif rsVentasPostpago.QEPvalorDefault eq 1 and trim(rsVentasPostpago.qpdlc_lista) eq 'B' and rsVentasPostpago.QPctaSaldosSaldo GTE LvarListaNegraPostPago>
            	<!---  <cfoutput>#rsVentasPostpago.QPTidTag# Blanco</cfoutput><br>  --->
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPostpago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="B">
                </cfinvoke> 
                
            <cfelseif rsVentasPostpago.QEPvalorDefault eq 1 and trim(rsVentasPostpago.qpdlc_lista) eq 'G' and rsVentasPostpago.QPctaSaldosSaldo GTE LvarListaNegraPostPago>
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPostpago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="G">
                </cfinvoke> 
                 <!--- <cfoutput>#rsVentasPostpago.QPTidTag# Gris</cfoutput><br>  --->
            <cfelseif rsVentasPostpago.QEPvalorDefault eq 0 or trim(rsVentasPostpago.qpdlc_lista) eq 'N' or rsVentasPostpago.QPctaSaldosSaldo LT LvarListaNegraPostPago>
	            <cfinvoke component="QPListaColor" method="ActualizaTag">
                    <cfinvokeargument name="IDTAG" value="#rsVentasPostpago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="N">
                </cfinvoke> 
                 <!--- <cfoutput>#rsVentasPostpago.QPTidTag# Cualquier color que envíen si el saldo es menor que N entonce se va en lista Negra</cfoutput><br>  --->
            </cfif>
        </cfloop>
         <!--- <cfabort> ---> 

        <cfreturn 1>
    </cffunction>

	<cffunction name="ActualizaTag" access="public" output="no" returntype="numeric" hint="Actualizar los Tags asociados a las cuentas Prepago según la lista asociala a las cuentas.">
	    <cfargument name="IDTAG"	type="numeric"	required="yes">
    	<cfargument name="Lista"	type="string" 	required="yes">
        <cfargument name='conexion' type='string' 	required='false' default="#Session.DSN#">
        
        	<cfquery datasource="#arguments.conexion#">
                update QPassTag
                set QPTlista = '#arguments.Lista#'
                where QPTidTag = #arguments.IDTAG#
            </cfquery>
        
    	<cfreturn 1>
    </cffunction>
</cfcomponent>
