<cfcomponent>

	<cfquery datasource="asp" name="__conexiones__">
        select e.Ecodigo as EcodigoSDC, e.CEcodigo, c.Ccache, e.Ereferencia
        from Empresa e
            join Caches c
                on e.Cid = c.Cid
	</cfquery>
    
    <cfset This.Conexiones = __conexiones__>
    <cfset This.CATcodigo  = ''>
    <cfset This.CampoError = ''>
    <cfset This.ValorError = ''>
   
    
    <!--- INICIO PARAMETROS, deben modificarse en la instalación --->
    <cfset This.Usucodigo = 5>  
 	<cfset This.ConceptoCompras = 'COMPRA'>   
    <!--- FIN    PARAMETROS, deben modificarse en la instalación --->

    <cffunction name = 'ConversionEquivalencia' returntype="query" output="yes">
      <cfargument name='SIScodigo'	    type='string' 	required='true' hint="Sistema">
      <cfargument name='CATcodigo'		type='string' 	required='true' hint="Catalogo">
      <cfargument name='EmpOrigen' 		type='numeric' 	required='true' hint="Empresa Origen">
      <cfargument name='CodOrigen' 		type='string' 	required='true' hint="Codigo Origen">
      <cfargument name='CampoError'  	type='string' 	required='true' hint="Campo Error">
    
    <cfset This.CATcodigo = Arguments.CATcodigo>
    <cfset This.CampoError = Arguments.CampoError>
    <cfset This.ValorError = Arguments.CodOrigen>
<!---    <cfdump var="#Arguments#">   --->
      <cfquery name="rsEquiv" datasource="sifinterfaces">
                    select  SIScodigo, CATcodigo, EQUempOrigen, EQUcodigoOrigen, EQUempSIF, EQUcodigoSIF  
                    from SIFLD_Equivalencia
                    where SIScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#SIScodigo#">  
                            and CATcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#CATcodigo#">
                            and EQUempOrigen = <cfqueryparam cfsqltype="cf_sql_integer" value="#EmpOrigen#">
                            and EQUcodigoOrigen = <cfqueryparam cfsqltype= "cf_sql_varchar" value="#CodOrigen#">
      </cfquery>
      <cfif rsEquiv.recordcount eq 0>                   
        <!--- si No Existe el Registro en Equivalencias     --->
        <cfthrow message="No se encuentra equivalencia para #Arguments.CATcodigo# - #Arguments.CodOrigen#">
      </cfif>
      <cfreturn rsEquiv>
    </cffunction>
    
    <cffunction name = 'InsertaError'> 
    	<cfargument name='Proceso'	    type='string' 	required='true' hint="Proceso">
      	<cfargument name='ID_Documento' type='numeric' 	required='true' hint="Id_Documento">
        
        
        <cfoutput>Insertando Error #cfcatch.Message#<br></cfoutput>
        
        <cfquery name="rsGrabaError" datasource="sifinterfaces">
            insert into LDSIF_Errores (Proceso, ID_Documento, CATcodigo, Estado, Columna_Error, Valor_Error)
                values ('#Arguments.Proceso#', #Arguments.ID_Documento#, '#This.CATcodigo#', 'Pendiente', '#This.CampoError#', 
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#This.ValorError#">)
        </cfquery>	
    </cffunction>

	<cffunction name = 'ExtraeMaximo'> 
    	<cfargument name='Tabla' type='string'	required='true' hint="Tabla">
      	<cfargument name='CampoID' type='string'	required='true' hint="Proceso">
        
        <cfquery name="rsMaximo_Tabla" datasource="sifinterfaces">
       		select coalesce (max( # CampoID # ), 0) + 1 as Maximo from # Tabla #
       	</cfquery>
        
        <cfquery name="rsMaximo_IdProceso" datasource="sifinterfaces">
            select Consecutivo + 1 as Maximo 
            from IdProceso 
       	</cfquery>
        
        <cfif (Len(rsMaximo_Tabla.Maximo) GT 0) AND (rsMaximo_IdProceso.Maximo LT rsMaximo_Tabla.Maximo)>
        	<cfset retvalue = rsMaximo_Tabla>
        <cfelse>
        	<cfset retvalue = rsMaximo_IdProceso>
        </cfif>
        
        <cfquery datasource="sifinterfaces">
            update IdProceso
            set Consecutivo = #retvalue.Maximo#
        </cfquery>

        <cfreturn retvalue>
    </cffunction>


	<cffunction name="getConexion" returntype="string" output="no">
    	<cfargument name="Ecodigo" type="numeric" required="yes" hint="Ecodigo (sdc) que es usar¨¢ para obtener el cache o conexion">
        
		<cfquery dbtype="query" name="ret">
        	select Ccache from This.Conexiones where EcodigoSDC = #Arguments.Ecodigo#
        </cfquery>
        <cfreturn ret.Ccache>
    </cffunction>

	<cffunction name="getCEcodigo" returntype="string" output="no">
    	<cfargument name="Ecodigo" type="numeric" required="yes" hint="Ecodigo (sdc) que es usará para obtener el CEcodigo">
        
		<cfquery dbtype="query" name="ret">
        	select CEcodigo from This.Conexiones where EcodigoSDC = #Arguments.Ecodigo#
        </cfquery>
        <cfreturn ret.CEcodigo>
    </cffunction>

	<cffunction name="getEcodigo" returntype="string" output="no">
    	<cfargument name="Ecodigo" type="numeric" required="yes" hint="Ecodigo (sdc) que es usará para obtener el Ecodigo local">
        
		<cfquery dbtype="query" name="ret">
        	select Ereferencia from This.Conexiones where EcodigoSDC = #Arguments.Ecodigo#
        </cfquery>
        <cfreturn ret.Ereferencia>
    </cffunction>

	<cffunction name="disparaInterfaz" returntype="void" output="no">

    <!--- Invocar como:
		<cfset disparaInterfaz(18, ID, empresaEq.Ecodigo)>
	--->
    	<cfargument name="NumeroInterfaz" type="numeric" required="yes" hint="Número de la interfaz por disparar: 14, 18, 10, etc">
    	<cfargument name="ID"             type="numeric" required="yes" hint="Consecutivo por insertar">
		<cfargument name="Ecodigo"        type="numeric" required="yes" default="0" hint="EcodigoSDC">

<!--- <cfdump var="#Arguments#"> --->
	
		<cfquery datasource="sifinterfaces">

            insert into InterfazColaProcesos (
                CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
                EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
                FechaInclusion, UsucodigoInclusion, Cancelar)
                 
            select
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCEcodigo(Arguments.Ecodigo)#">,
              <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#"> as NumeroInterfaz,
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#"> as ID,
              0 as SecReproceso,
              
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
              'E' as OrigenInterfaz,
              'A' as TipoProcesamiento,
              1 as StatusProceso,
              
              <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
              <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.Usucodigo#">,
              0 as Cancelar
		</cfquery>



    </cffunction>
    
    -----------------------------------------------------
    
    <cffunction name = 'ExtraeCliente'> 
    	
        <cfargument name='Cliente' type='string' 	required='true' hint="ClienteInterfaz">
      	<cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
        
        <cfset ConexionBase = getConexion(Arguments.Ecodigo) >
        
          <cfquery name="rsCliente" datasource="#ConexionBase#">
              select 
              	case when esIntercompany = 1 then  <!---    1 = Afiliados, 0 = Terceros    --->
                	'02' 
                else 
                	'01' 
                end as TipoCte, sncodigo
              from SNegocios
              where SNCodigoExt = '#Arguments.Cliente#'
                and Ecodigo = #getEcodigo(Arguments.Ecodigo)#
          </cfquery>

        <cfreturn rsCliente>
    </cffunction>
--------------------------------------------------------
 <!---   
    <cffunction name = 'MaximoFaPreFacturaE'>
    	
    	<cfargument name='Tabla' type='string'	required='true' hint="Tabla">
      	<cfargument name='CampoID' type='string'	required='true' hint="Campo">
        <cfargument name='Ecodigo' type='numeric'	required='true' hint="Ecodigo">
        
        <cfset ConexionBase = getConexion(Arguments.Ecodigo) >
        
        <cfquery name="rsMaximo_FApre" datasource="#ConexionBase#">
       		select coalesce (max( # CampoID # ), 0) + 1 as Maximo from # Tabla #
            	where Ecodigo = #getEcodigo(Arguments.Ecodigo)#
       	</cfquery>        
        <cfreturn rsMaximo_FApre>
    </cffunction>   --->
    
</cfcomponent>


  