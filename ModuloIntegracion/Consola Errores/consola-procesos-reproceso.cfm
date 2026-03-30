<cfif (isdefined("form.chk"))><!--- Viene de la lista --->
	<cfset datos = ListToArray(Form.chk,",")>
    <cfset limite = ArrayLen(datos)>

	<cfloop from="1" to="#limite#" index="idx">
		<!--- Obtiene Datos del Error --->
		<cfquery name="rsError" datasource="sifinterfaces">
			select ID_Documento,Tabla
			from SIFLD_Errores
			where ID_Error = <cfqueryparam cfsqltype="cf_sql_double" value="#datos[idx]#">
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
			<cfelseif rsError.Tabla EQ "ESIFLD_MovBancariosCxC">
				<cfset Campo = "ID_DocumentoM">
			<cfelseif rsError.Tabla EQ "SIFLD_Costo_Venta">
				<cfset Campo = "ID_Mov_Costo">
            <cfelseif rsError.Tabla EQ "ESIFLD_Cobros_Pagos">
				<cfset Campo = "ID_Pago">
			<cfelseif rsError.Tabla EQ "Enc_Ordenes_Pago_SOIN">
				<cfset Campo = "ID">
			<cfelseif rsError.Tabla EQ "Cheques_SOIN">
				<cfset Campo = "ID">
			</cfif>    
			
						
	<!---               <cfdump var="#Interfaz#">
				<cfdump var="#Tabla#">
				<cfdump var="#Campo#">
				<cfdump var="#idx#">
				<cfdump var="#datos[idx]#">   --->
				  
		   
           <cftransaction>
				<cfif rsError.Tabla NEQ "" and len(rsError.Tabla) GT 0>
                    <cfquery datasource="sifinterfaces">
                        update #trim(rsError.Tabla)# set Estatus = case Estatus
                                                                    when 3 then 1
                                                                    when 6 then 4
                                                                    when 7 then 5
                                                                    when 33 then 31
                                                                    else 1
                                                                   end
                        where #Campo# = <cfqueryparam value="#rsError.ID_Documento#" cfsqltype="cf_sql_integer">
                        and Estatus in (3,6,7,33) 
                    </cfquery>
                </cfif>
				
				<cfquery datasource="sifinterfaces">
					delete from SIFLD_Errores
					where ID_Error = <cfqueryparam cfsqltype="cf_sql_double" value="#datos[idx]#">
				</cfquery>
		   </cftransaction>
		</cfif>
	</cfloop>
</cfif>

<cflocation url="/cfmx/ModuloIntegracion/Consola Errores/consola-procesos-form.cfm">





             