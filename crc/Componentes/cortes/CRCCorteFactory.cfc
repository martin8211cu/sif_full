<cfcomponent output="false"  displayname="CRCCorteFactory">
 
	<cfset C_TP_DISTRIBUIDOR =  'D'>
	<cfset C_TP_MAYORISTA    =  'TM'>
	<cfset C_TP_TARJETA      =  'TC'>	

	<cfset C_ERROR_COMP_CORTE_NO_ENCONTRADO = '00014'>

	<cffunction name="obtenerCorte" returntype="struct" access="public" hint="resuelve el corte a devolver"> 
		<cfargument name="TipoProducto" type="string"   required="yes" >
		<cfargument name="SNid" 	    type="numeric"  required="no" default="0">
    	<cfargument name="conexion"     type="string"   required="no" default="#session.dsn#"> 
		<cfargument name="ECodigo"      type="string"	required="no" default="#session.Ecodigo#">
		 
		<cfset stTipoProducto = #Trim(arguments.TipoProducto)#>
		<cfif  stTipoProducto eq C_TP_DISTRIBUIDOR>
			
			<cfset CRCCortesDistribuidor = createObject( "component","crc.Componentes.cortes.CRCCortesDistribuidor").init(conexion=#arguments.conexion#,Ecodigo=#arguments.ECodigo#)>
			<cfreturn  CRCCortesDistribuidor>
		
		<cfelseif  stTipoProducto eq C_TP_MAYORISTA>

			<cfset CRCCortesTarjetaMayorista = createObject( "component","crc.Componentes.cortes.CRCCortesTarjetaMayorista").init(SNid=#arguments.SNid#,conexion=#arguments.conexion#,Ecodigo=#arguments.ECodigo#)>
			<cfreturn  CRCCortesTarjetaMayorista>
		
		<cfelseif stTipoProducto eq C_TP_TARJETA>

			<cfset CRCCortesTarjetaCredito = createObject( "component","crc.Componentes.cortes.CRCCortesTarjetaCredito").init(conexion=#arguments.conexion#,Ecodigo=#arguments.ECodigo#)>
			<cfreturn  CRCCortesTarjetaCredito>

		<cfelse>  
 			<cfthrow errorcode="#C_ERROR_COMP_CORTE_NO_ENCONTRADO#" message="Componente de corte no encontrado" />
 		 
		</cfif>
	</cffunction>


</cfcomponent>