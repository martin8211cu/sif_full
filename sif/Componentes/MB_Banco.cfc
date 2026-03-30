<cfcomponent>
	<!---===================================================================================================--->
	<cffunction name="GetBanco" access="public" returntype="query">
		<cfargument name="conexion"   type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Ecodigo"    type="numeric" 	required="no" hint="Codigo de la empresa del Portal">
        
        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
        <cfquery name="ABC_Bancos" datasource="#Arguments.conexion#">
            SELECT 	Bid, Ecodigo, Bdescripcion, Bdireccion, Btelefon, Bfax, Bemail, ts_rversion, EIid, Bcodigocli,
                    Bcodigo, BcodigoACH, Iaba, BcodigoSWIFT, BcodigoIBAN, BcodigoOtro
             FROM Bancos 
            WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
        </cfquery>   
		<cfreturn ABC_Bancos>
	</cffunction>
   <!---===================================================================================================--->
<!---►►Funcion para crear el Encabezado de los Movimientos bancarios◄◄--->
    <cffunction name="SetEMovimientos" access="public" hint="Funcion para poder Agregar un Movimiento Bancario">
		<cfargument name="conexion"   		type="string"  	required="no" hint="Nombre del DataSource">
        <cfargument name="Ecodigo"    		type="numeric" 	required="no" hint="Codigo de la empresa del Portal">
        <cfargument name="Usucodigo" 		type="numeric" 	required="no" hint="Usuario">
        <cfargument name="BTid" 			type="numeric">
        <cfargument name="CBid"  			type="numeric">
        <cfargument name="CFid"  			type="numeric" 	required="no" default="-1" hint="Centro Funcional">
        <cfargument name="Ocodigo"   		type="numeric"  required="no" default="-1">
        <cfargument name="EMtipocambio" 	type="numeric">
        <cfargument name="EMdocumento" 		type="string">
        <cfargument name="EMtotal" 			type="numeric">
        <cfargument name="EMreferencia" 	type="string">
        <cfargument name="EMfecha" 			type="date">
        <cfargument name="EMdescripcion" 	type="string">
        <cfargument name="EMusuario"		type="string">
        <cfargument name="EMselect"  		type="numeric"  default="-1">
        <cfargument name="TpoSocio"   		type="numeric">
        <cfargument name="CDCcodigo"  		type="numeric"  default="-1">
        <cfargument name="SNcodigo"  		type="numeric"  default="-1">
        <cfargument name="id_direccion"  	type="numeric"  default="-1">
        <cfargument name="TpoTransaccion" 	type="string" 	default="">
        <cfargument name="Documento" 		type="string" 	default="">
        <cfargument name="SNid"   			type="numeric"  default="-1">
        <cfargument name="ERNid"   			type="numeric"  default="-1">
        <cfargument name="EIid"   			type="numeric"  default="-1">
        <cfargument name="EMdocumentoRef"	type="string" 	default=""  	required="no" hint="Se usa como llave del importador TEFclientes">

        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.EMusuario') and isdefined('session.Usulogin')>
        	<cfset Arguments.EMusuario = session.Usulogin>
        </cfif>
        
        <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
        	INSERT INTO EMovimientos (
               BTid,
               Ecodigo,
               CBid,
               CFid,
               Ocodigo,
               EMtipocambio,
               EMdocumento,
               EMdocumentoRef, 
               EMtotal,
               EMreferencia,
               EMfecha,
               EMdescripcion,
               EMusuario,
               EMselect,
               SNcodigo,
               id_direccion,
               TpoSocio,
               TpoTransaccion,
               Documento,
               SNid,
               CDCcodigo,
               ERNid,
               EIid,
               BMUsucodigo
              
        )
    VALUES(
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.BTid#">,
            #Arguments.Ecodigo#,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CBid#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFid#"  			voidNull null="#Arguments.CFid EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ocodigo#"        voidNull null="#Arguments.Ocodigo EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#Arguments.EMtipocambio#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.EMdocumento#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.EMdocumentoRef#" voidNull>,
            <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.EMtotal#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="25"  value="#Arguments.EMreferencia#"   voidNull>,
            <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.EMfecha#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120" value="#Arguments.EMdescripcion#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#Arguments.EMusuario#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_integer"      	 value="#Arguments.EMselect#" 		voidNull null="#Arguments.EMselect EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_integer"      	 value="#Arguments.SNcodigo#" 		voidNull null="#Arguments.SNcodigo EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.id_direccion#" 	voidNull null="#Arguments.id_direccion EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.TpoSocio#"       voidNull>,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.TpoTransaccion#" voidNull>,
            <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.Documento#"      voidNull>,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.SNid#" 			voidNull null="#Arguments.SNid      EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CDCcodigo#" 		voidNull null="#Arguments.CDCcodigo EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.ERNid#" 			voidNull null="#Arguments.ERNid     EQ -1#">,
            <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.EIid#" 			voidNull null="#Arguments.EIid      EQ -1#">,            
            #Arguments.Usucodigo#
    	)     
        <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
        </cfquery> 
    	<cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarIdentity">
        <cfreturn LvarIdentity>
   </cffunction>
   <!---►►Funcion para Crear el Detalle de un Movimiento Bancario◄◄--->
   <cffunction name="SetDMovimientos" access="public" hint="Funcion para Crear el Detalle de un Movimiento Bancario">
       <cfargument name ="conexion"   	 type ="string"  	required="no" hint="Nombre del DataSource">
       <cfargument name ="Ecodigo"    	 type="numeric" 	required="no" hint="Codigo de la empresa del Portal">
       <cfargument name ="Usucodigo" 	   type="numeric" 	required="no" hint="Usuario">
       <cfargument name ="EMid" 		     type="numeric" 	required="no">
       <cfargument name ="Ccuenta" 		   type="numeric" 	required="no">
       <cfargument name ="Dcodigo" 		    type="numeric" 	required="no" default="-1">
       <cfargument name ="CFid" 		      type="numeric" 	required="no" default="-1">
       <cfargument name ="DMmonto"		    type="numeric" 	required="no">
       <cfargument name ="DMdescripcion"  type="string"  	required="no">
       <cfargument name ="PCGDid" 		    type="numeric" 	required="no" default="-1">
       <cfargument name ="CFcuenta" 	    type="numeric" 	required="no" default="-1">
       <cfargument name ="ProcesoNormal"  type="boolean"  required="no" default="true" hint="Indica que viene de form. Usar false cuando es de importador">
        
        

        <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo') and isdefined('session.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo') and isdefined('session.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
         
        <cfquery name="rsInsert" datasource="#Arguments.conexion#">     
            INSERT INTO DMovimientos (
                   EMid,
                   Ecodigo,
                   Ccuenta,
                   Dcodigo,
                   CFid,
                   DMmonto,
                   DMdescripcion,
                   PCGDid,
                   CFcuenta,
                   BMUsucodigo
            )
            VALUES(
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.EMid#">,
                   #Arguments.Ecodigo#,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ccuenta#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Dcodigo#"       voidNull null="#Arguments.Dcodigo EQ -1#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFid#"          voidNull null="#Arguments.CFid EQ -1#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.DMmonto#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="120" value="#Arguments.DMdescripcion#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.PCGDid#"        voidNull null="#Arguments.PCGDid EQ -1#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFcuenta#"      voidNull null="#Arguments.CFcuenta EQ -1#">,
                   #Arguments.Usucodigo#
            )     
            <cf_dbidentity1 name="rsInsert" datasource="#Arguments.conexion#"> 
          </cfquery> 
            <cf_dbidentity2 name="rsInsert" datasource="#Arguments.conexion#" returnvariable="LvarLinea">
            <cfif #Arguments.ProcesoNormal#>
                <cf_conceptoPagoSQL name="TESRPTCid" EMid="#Arguments.EMid#" Dlinea="#LvarLinea#">  
            </cfif>  
          <cfreturn LvarLinea>
   </cffunction>
   
   <!---►►Funcion para eliminar un Movimiento Bancario◄◄--->
   <cffunction name="DropEMovimientos" access="public" hint="Funcion para eliminar un Movimiento Bancario">
   		<cfargument name="EMid"   	 type="string"  	required="no" hint="Id del Movimiento Bancario">
        <cfargument name="conexion"  type="string"  	required="no" hint="Nombre del DataSource">
        
   		 <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        
        <cfinvoke method="DropDMovimientos">
        	<cfinvokeargument name="EMid" value="#Arguments.EMid#">
        </cfinvoke>
        
        <cfquery  datasource="#Arguments.conexion#"> 
        	Delete from EMovimientos
            where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#">
        </cfquery>
   </cffunction>
   
   <!---►►Funcion para eliminar un detalle de un Movimiento Bancario◄◄--->
   <cffunction name="DropDMovimientos" access="public" hint="Funcion para eliminar un detalle de un Movimiento Bancario">
   		<cfargument name="EMid"   	 type="string"  required="no" hint="Id del Movimiento Bancario">
   		<cfargument name="conexion"  type="string"  required="no" hint="Nombre del DataSource">
        
   		 <cfif not isdefined('Arguments.conexion') and isdefined('session.dsn')>
        	<cfset Arguments.conexion = session.dsn>
        </cfif>
        
        <cfquery  datasource="#Arguments.conexion#"> 
        	Delete from DMovimientos
             where EMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EMid#"> 
        </cfquery>
   </cffunction>

  <!---►►Validacion de documentos◄◄--->
  <cffunction name="ValidarDocumentoBanco" access="public" returntype = "numeric" hint="Valida que el documento digitado no se repita para  para un banco especifico">
    <cfargument name="BancoId"    type="numeric"  required="yes" hint="Id del banco">
    <cfargument name="Documento"  type="string"  required="yes" hint="Texto del documento (numero)">
    <cfargument name="DSN"  type="string" required="yes"  hint="BD">
    <!--- <cfquery name="CantidadDocumentos" datasource="#arguments.DSN#">
      
      select EMdocumento
      From CuentasBancos cb 
            Inner Join EMovimientos em on cb.CBid = em.CBid
      where Bid         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BancoId#">
        and EMdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Documento#"> 


    </cfquery>
 --->
    <cfquery name="CantidadDocumentos2" datasource="#arguments.DSN#">
      
      select MLdocumento 
      From MLibros 
            
      where Bid         = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.BancoId#">
        and MLdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Documento#"> 


    </cfquery>

    <!--- <cfreturn CantidadDocumentos.recordcount>--->
    <cfreturn CantidadDocumentos2.recordcount>


  </cffunction>

</cfcomponent>