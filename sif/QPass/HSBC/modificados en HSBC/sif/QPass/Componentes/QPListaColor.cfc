<cfcomponent output="no">
	<cffunction name="fnActualizaTags" output="no" access="public" returntype="numeric" hint="Actualizar Tags que tengan lista asociada en nulo a Lista Blanca (para actualizar cualquier tag que tanga la columna en valor nulo)">
		<cfargument name="Tag" 		type="string" required="no" default="-1">
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
        <cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsTagPromotores" datasource="#arguments.conexion#">
			select t.QPTPAN, t.QPTidTag
			from QPPromotor p 
                inner join QPassTag t
                on t.QPPid = p.QPPid
			where p.Ecodigo = #session.Ecodigo#
   				and ( p.QPPPuntoSeguro = 1 or p.QPPPuntoSeguro is null )<!--- QPPPuntoSeguro:  1=seguro, 2=inseguro --->
	 			and 
					(select count(1)
					 from QPassEstado a
					 where a.QPidEstado = t.QPidEstado
					 and QPEdisponibleVenta = 1 --<!--- Disponible para la venta 1:si, 2:no --->
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
            where p.Ecodigo = #session.Ecodigo#
	  		and QPPPuntoSeguro = 2  <!--- QPPPuntoSeguro:  1=seguro, 2=inseguro --->
            and (select count(1)
                 from QPassEstado a
                 where a.QPidEstado = t.QPidEstado
                 and QPEdisponibleVenta = 2 <!--- Disponible para la venta 1:si, 2:no --->
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
        <cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
        
        <cfquery name="rsListaBlanca" datasource="#arguments.conexion#">
        	select Pvalor
            from QPParametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 10
        </cfquery>
        <cfset LvarListaBlanca = rsListaBlanca.Pvalor>
        
        <cfquery name="rsListaNegra" datasource="#arguments.conexion#">
        	select Pvalor
            from QPParametros
            where Ecodigo = #session.Ecodigo#
            and Pcodigo = 20
        </cfquery>
        <cfset LvarListaNegra = rsListaNegra.Pvalor>
        
        <!--- Todas la ventas de tipo Prepago --->
        <cfquery name="rsVentasPrepago" datasource="#arguments.conexion#">
        	select 
            	a.QPctaSaldosSaldo, 
                a.Mcodigo, 
                b.QPTidTag
            from QPcuentaSaldos a
            	inner join QPventaTags b
                	on b.QPctaSaldosid = a.QPctaSaldosid
	            <cfif arguments.Tag neq '-1'>
                	inner join QPassTag c
                    	on c.QPTidTag = b.QPTidTag
                </cfif>
            where a.Ecodigo = #session.Ecodigo#
            and a.QPctaSaldosTipo = 2 <!--- 1=PostPago, 2=Prepago --->
            <cfif arguments.Tag neq '-1'>
            	and c.QPTPAN = '#arguments.Tag#'
            </cfif>
        </cfquery>
        
        <cfloop query="rsVentasPrepago">
        	<cfif rsVentasPrepago.QPctaSaldosSaldo GTE LvarListaBlanca>
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="B">
                </cfinvoke>
                
            <cfelseif rsVentasPrepago.QPctaSaldosSaldo GTE LvarListaNegra and rsVentasPrepago.QPctaSaldosSaldo LT LvarListaBlanca>
            	<cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="G">
                </cfinvoke>
            <cfelseif rsVentasPrepago.QPctaSaldosSaldo LT LvarListaNegra>
	            <cfinvoke component="QPListaColor" method="ActualizaTag">
	                <cfinvokeargument name="IDTAG" value="#rsVentasPrepago.QPTidTag#">
                    <cfinvokeargument name="Lista" value="N">
                </cfinvoke>
            </cfif>
        </cfloop>

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
