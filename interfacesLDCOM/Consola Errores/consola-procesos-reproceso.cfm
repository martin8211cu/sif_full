<cfif (isdefined("form.chk"))><!--- Viene de la lista --->
	<cfset datos = ListToArray(Form.chk,",")>
    <cfset limite = ArrayLen(datos)>

	<cfloop from="1" to="#limite#" index="idx">
		<!--- Obtiene Datos del Error --->
		<cfquery name="rsError" datasource="sifinterfaces">
			select ID_Documento,Tabla
			from SIFLD_Errores
			where ID_Error = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos[idx]#">
		</cfquery>
		<cfif isdefined("rsError") and rsError.recordcount EQ 1>
			<cfif rsError.Tabla EQ "ESIFLD_Facturas_Venta">
				<cfset Campo = "ID_DocumentoV">
			<cfelseif rsError.Tabla EQ "ESIFLD_Facturas_Compra">
				<cfset Campo = "ID_DocumentoC">
			<cfelseif rsError.Tabla EQ "ESIFLD_Movimientos_Inventario">
				<cfset Campo = "ID_Movimiento">
			<cfelseif rsError.Tabla EQ "ESIFLD_Retiros_Caja">
				<cfset Campo = "ID_Retiro">
			<cfelseif rsError.Tabla EQ "SIFLD_Movimientos_Bancarios">
				<cfset Campo = "ID_MovimientoB">
			</cfif>    
				
	<!---               <cfdump var="#Interfaz#">
				<cfdump var="#Tabla#">
				<cfdump var="#Campo#">
				<cfdump var="#idx#">
				<cfdump var="#datos[idx]#">   --->
				  
		   <cftransaction>
				<cfquery datasource="sifinterfaces">
					update #trim(rsError.Tabla)# set Estatus = 1
					where #Campo# = <cfqueryparam value="#rsError.ID_Documento#" cfsqltype="cf_sql_integer">
					and Estatus = 3 
				</cfquery> 
				
				<cfquery datasource="sifinterfaces">
					delete from SIFLD_Errores
					where ID_Error = <cfqueryparam cfsqltype="cf_sql_integer" value="#datos[idx]#">
				</cfquery>
		   </cftransaction>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="/cfmx/interfacesLDCOM/Consola Errores/consola-procesos-form.cfm">





             