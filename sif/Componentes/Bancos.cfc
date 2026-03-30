<cfcomponent output="no" hint="Componentes para el manejo de Bancos">
	 <!---►►►►►►Obtencion del Banco◄◄◄◄◄--->
    <cffunction access="public" name="getBancos" hint="Obtencion de los datos de Bancos">
    	<cfargument name="Conexion" 	    type="string"  required="no" hint="Nombre de la conexion">
        <cfargument name="Ecodigo"       	type="numeric" required="no" hint="Codigo Interno de la empresa">
        <cfargument name="ConCuentas"       type="boolean" required="no" hint="Con o sin Cuentas Bancarias Configuradas">
        
    	<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        
        <cfquery name="rsBancos" datasource="#Arguments.Conexion#">
        	select Bid,Ecodigo,Bdescripcion,Bdireccion,Btelefon,Bfax,Bemail,Iaba,EIid,BMUsucodigo,ts_rversion,Bcodigocli,Bcodigo,BcodigoACH,BcodigoSWIFT,BcodigoIBAN,BcodigoOtro
				from Bancos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.ConCuentas')>
              and (select count(1) from CuentasBancos cta where cta.Bid = Bancos.Bid) <cfif Arguments.ConCuentas> > 0<cfelse> = 0 </cfif>
            </cfif>
        </cfquery>
    	<cfreturn rsBancos>
	</cffunction>
    <!---►►►►►►Obtencion de los datos de las cuentas de Bancos◄◄◄◄◄--->
    <cffunction access="public" name="getCuentasBancos" hint="Obtencion de los datos de las cuentas de Bancos">
    	<cfargument name="Conexion" 	    type="string"  required="no" hint="Nombre de la conexion">
        <cfargument name="Ecodigo"       	type="numeric" required="no" hint="Codigo Interno de la empresa">
        <cfargument name="Bid"       		type="numeric" required="no" hint="Id del Banco">
    	
        <cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
        
        <cfquery name="rsCuentasBancos" datasource="#Arguments.Conexion#">
            select CBid,Bid,Ecodigo,Ocodigo,Mcodigo,Ccuenta,Ccuentacom,CBcodigo,CBdescripcion,CBcc,CBTcodigo,CBdato1,CBdato2,CBdato3,CBinfo1,CBobs1,BMUsucodigo,EIid,ts_rversion,CBidioma,CBcodigoext,CBclave,CcuentaintPag,CBesTCE,DEid
            	from CuentasBancos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.Bid')>
            	and Bid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Bid#">
            </cfif>
        </cfquery>
        <cfreturn rsCuentasBancos>
	</cffunction>
</cfcomponent>