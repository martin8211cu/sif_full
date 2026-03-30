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
    	<cfargument name='SIScodigo'	type='string'	required='true' hint="Sistema">
      	<cfargument name='CATcodigo'	type='string'	required='true' hint="Catalogo">
    	<cfargument name='EmpOrigen'	type='numeric'	required='true' hint="Empresa Origen">
      	<cfargument name='CodOrigen'	type='string'	required='true' hint="Codigo Origen">
      	<cfargument name='CampoError'	type='string'	required='true' hint="Campo Error">
      
		<cfset This.CATcodigo = Arguments.CATcodigo>
    	<cfset This.CampoError = Arguments.CampoError>
    	<cfset This.ValorError = Arguments.CodOrigen>

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
    
    <!--- Funcion Para extraer el Ultimo campo ID (Maximo) de las tablas IEXX --->
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

	<!--- FUNCION GETCONEXION --->
	<cffunction name="getConexion" returntype="string" output="no">
    	<cfargument name="EcodigoSDC" type="numeric" required="yes" hint="Ecodigo (sdc) que es usar¨¢ para obtener el cache o conexion">
        
		<cfquery dbtype="query" name="ret">
        	select * from This.Conexiones where EcodigoSDC = #Arguments.EcodigoSDC#
        </cfquery>
        <cfreturn ret.Ccache>
    </cffunction>

	<!--- FUNCION GETCECODIGO --->
	<cffunction name="getCEcodigo" returntype="string" output="no">
    	<cfargument name="EcodigoSDC" type="numeric" required="yes" hint="Ecodigo (sdc) que es usará para obtener el CEcodigo">
        
		<cfquery name="rsCEcodigo" datasource="#getConexion(Arguments.EcodigoSDC)#">
        	select CEcodigo 
			from Empresa e
				inner join Empresas s
				on  e.Ecodigo = s.Ecodigo and s.EcodigoSDC = #Arguments.EcodigoSDC#
        </cfquery>
        <cfreturn rsEcodigo.Ecodigo>
    </cffunction>
	
	<!--- FUNCION GETECODIGO --->
	<cffunction name="getEcodigo" returntype="string" output="no">
    	<cfargument name="EcodigoSDC" type="numeric" required="yes" hint="Ecodigo (sdc) que es usará para obtener el Ecodigo local">
        
		<cfquery name="rsEcodigo" datasource="#getConexion(Arguments.EcodigoSDC)#">
        	select Ecodigo
			from Empresas where EcodigoSDC = #Arguments.EcodigoSDC#
        </cfquery>
		<cfif isdefined("rsEcodigo") and rsEcodigo.recordcount EQ 1>
	        <cfreturn rsEcodigo.Ecodigo>
		<cfelseif isdefined("rsEcodigo") and rsEcodigo.recordcount GT 1>
			<cfthrow message="Mas de una empresa asignada al EcodigoSDC:  #Arguments.EcodigoSDC#">
		<cfelse>
			<cfthrow message="No hay empresa asignada al EcodigoSDC:  #Arguments.EcodigoSDC#">
		</cfif>
    </cffunction>

	<!--- Funcion Dispara Interfaz --->
	<cffunction name="disparaInterfaz" returntype="void" output="no">
    	<cfargument name="NumeroInterfaz" type="numeric" required="yes" hint="Número de la interfaz por disparar: 14, 18, 10, etc">
    	<cfargument name="ID"             type="numeric" required="yes" hint="Consecutivo por insertar">
		<cfargument name="EcodigoSDC"        type="numeric" required="yes" default="0" hint="EcodigoSDC">
		<cfargument name="Masivo"        type="numeric" required="yes" default="0" hint="Bandera Masivo">
		<cfargument name="ID2"             type="numeric" required="no" hint="Consecutivo por insertar">
		<cfset varCEcodigo = getCEcodigo(Arguments.EcodigoSDC)>
		<cfif Arguments.Masivo EQ 0>
			<cfquery datasource="sifinterfaces">
				insert into InterfazColaProcesos
					(CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
					 EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
					 FechaInclusion, UsucodigoInclusion, Cancelar)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#varCEcodigo#">,
				  	<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#">,
				  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ID#">,
				  	0,
				  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">,
				  	'E',
				  	'A',
				  	1,
				  	<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#This.Usucodigo#">,
				  	0)
			</cfquery>
		<cfelse>
			<cfloop from="#Arguments.ID#" to="#Arguments.ID2#" index="ID">
				<cfquery datasource="sifinterfaces">
					insert into InterfazColaProcesos (
						CEcodigo, NumeroInterfaz, IdProceso, SecReproceso,
						EcodigoSDC, OrigenInterfaz, TipoProcesamiento, StatusProceso,
						FechaInclusion, UsucodigoInclusion, Cancelar)

					select
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCEcodigo(Arguments.EcodigoSDC)#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.NumeroInterfaz#"> as NumeroInterfaz,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#"> as ID,
					  0 as SecReproceso,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">,
					  'E' as OrigenInterfaz,
					  'A' as TipoProcesamiento,
					  1 as StatusProceso,
					  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,<!--- timestamp para que guarde fecha de proceso --->
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#This.Usucodigo#">,
					  0 as Cancelar
					from IE#Arguments.NumeroInterfaz#
					where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ID#">
				</cfquery>
			</cfloop>
		</cfif>
    </cffunction>
	<!---FUNCION EXTRAE CLIENTE--->    
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
				end as TipoCte, SNcodigo
			from SNegocios
			where SNCodigoExt like <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Cliente#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#getEcodigo(Arguments.Ecodigo)#">
		</cfquery>
		<cfif not isdefined("rsCliente") OR rsCliente.recordcount LTE 0>
			<cfthrow message="No Existe el Socio de Negocios con Codigo Externo #Arguments.Cliente#">
		</cfif>
		
		<cfreturn rsCliente>
	</cffunction>
    
</cfcomponent>


  