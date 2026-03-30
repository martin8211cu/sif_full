<!---	
	Modificado por: Alejandro Bolaños
		Fecha: 11-07-2013
		Motivo: Se agregan 2 parametros a la funcion para no tener en codigo duro el tipo de movimiento y la descripcion
--->
<cfcomponent>	
	<cffunction name='inserta_mlibros' access='public' output='true' returntype="any">
		<cfargument name='Ecodigo' 	  	type='numeric' required="yes">
        <cfargument name='Bid'   	  	type='numeric' required="yes">
        <cfargument name='BTid'   	  	type='numeric' required="yes">
        <cfargument name='CBid'   	  	type='numeric' required="yes">                    
		<cfargument name='Mcodigo' 	  	type='numeric' required="yes">        
		<cfargument name='fecha' 	  	type='string'  required="yes">               
        <cfargument name='referencia' 	type='string'  required="yes">
        <cfargument name='descripcion' 	type='string'  required="yes">  
        <cfargument name='tipomov' 	  	type='string'  required="yes">  
        <cfargument name='documento'  	type='string'  required="yes"> 
        <cfargument name='IDcontable' 	type='numeric' required="yes">        
		<cfargument name='tipoCambio' 	type='numeric' required="yes">
		<cfargument name='monto'      	type='numeric' required="yes">
        <cfargument name='Periodo'    	type='string'  required="yes">
        <cfargument name='Mes'        	type='string'  required="yes">
   		<cfargument name='Conexion'   	type='string' required="yes">                                        
        
		<cfquery name="insert_mlibros" datasource="#arguments.conexion#">
				insert into	MLibros 
					(
						Ecodigo, 
						Bid, 
						BTid, 
						CBid, 
						Mcodigo, 
						MLfechamov, 
						MLfecha, 
						MLreferencia, 
						MLdocumento, 
						MLdescripcion, <!----Cobro CxC----->
						MLconciliado, 
						IDcontable, 
						MLtipocambio, 
						MLmonto, 
						MLmontoloc, 
						MLperiodo, 
						MLmes, 
						MLtipomov, 
						MLusuario
					)
			VALUES(
                   #arguments.Ecodigo#, 
                   #arguments.Bid#, 
                   #arguments.BTid#, 
                   #arguments.CBid#, 
                   #arguments.Mcodigo#, 
                   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#"            voidNull>,
                    <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#arguments.fecha#" voidNull>,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#left(arguments.referencia,25)#"      voidNull>, 
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#arguments.documento#"       voidNull>, 
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#arguments.descripcion#"               voidNull>, 
                   'N',
                   #arguments.IDcontable#, 
                   #arguments.tipocambio#, 
    			   #arguments.monto#,
                   (#arguments.tipocambio# * #arguments.monto#),
                   #arguments.Periodo#,
                   #arguments.Mes#,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#arguments.tipomov#"                         voidNull>, 
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar"  value="#session.usuario#"         voidNull>
                  ) 
			<cf_dbidentity1 datasource="#session.DSN#" name="insert" verificar_transaccion="no">
		 </cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insert" verificar_transaccion="no" returnvariable="LvarMLid">
		<cfset LvarMLid =  LvarMLid>
		
		<cfreturn LvarMLid>
	</cffunction>
</cfcomponent>



