<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_Error" default="Ocurrio Un Error:" returnvariable="MSG_Error" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ErrorCantidad" default="No se indico la Cantidad para la Linea" returnvariable="MSG_ErrorCantidad" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ErrorPrecioU" default="No se indico el Precio Unitario para la Linea" returnvariable="MSG_ErrorPrecioU" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ErrorDescuento" default="No se indico el Descuento para la Linea" returnvariable="MSG_ErrorDescuento" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ErrorImpuesto" default="No se indico el Impuesto para la Linea" returnvariable="MSG_ErrorImpuesto" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ErrorLinea" default="No se indico la Linea" returnvariable="MSG_ErrorLinea" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_CantidadCero" default="La Cantidad debe ser mayor de Cero" returnvariable="MSG_CantidadCero" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PrecioCero" default="El Precio Unitario debe ser mayor de Cero" returnvariable="MSG_PrecioCero" xmlfile="ModificaDetalles-sql.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_DescuentoMayor" default="El descuento no puede ser mayor o igual al Precio Total de la Linea" returnvariable="MSG_DescuentoMayor" xmlfile="ModificaDetalles-sql.xml"/>

<!---Validar que se envien todos los datos--->
<cfif isdefined("url.EOidorden") and len(url.EOidorden) GT 0>
	<cfset form.EOidorden = url.EOidorden>	
<cfelse>
	<cfabort showerror="#MSG_ErrorLinea#">
</cfif>
<cfif isdefined("url.Linea") and len(url.Linea) GT 0>
	<cfset form.Linea = url.Linea>	
<cfelse>
	<cfabort showerror="#MSG_ErrorLinea#">
</cfif>
<cfif isdefined("url.Cantidad") and len(url.Cantidad) GT 0>
	<cfset form.Cantidad = url.Cantidad>	
<cfelse>
	<cfabort showerror="#MSG_ErrorCantidad#">
</cfif>
<cfif isdefined("url.PrecioU") and len(url.PrecioU) GT 0>
	<cfset form.PrecioU = url.PrecioU>	
<cfelse>
	<cfabort showerror="#MSG_ErrorPrecioU#">
</cfif>
<cfif isdefined("url.Descuento") and len(url.Descuento) GT 0>
	<cfset form.Descuento = url.Descuento>	
<cfelse>
	<cfabort showerror="#MSG_ErrorDescuento#">
</cfif>
<cfif isdefined("url.Impuesto") and len(url.Impuesto) GT 0>
	<cfset form.Impuesto = url.Impuesto>	
<cfelse>
	<cfabort showerror="#MSG_ErrorImpuesto#">
</cfif>

<!---Convierte las cadenas de texto en arrays--->
<cfset ArrayLinea = ListToArray(form.Linea,",", true)>
<cfset ArrayCantidad = ListToArray(form.Cantidad,",", true)>
<cfset ArrayPrecioU = ListToArray(form.PrecioU,",", true)>
<cfset ArrayDescuento = ListToArray(form.Descuento,",", true)>
<cfset ArrayImpuesto = ListToArray(form.Impuesto,",", true)>

<!---Variables para Totales --->
<cfset varImpuestoTotal = 0>
<cfset varDescuentoTotal = 0>
<cfset varTotal = 0>

<cfset varLimite = ArrayLen(ArrayLinea)>
<cftransaction action="begin">
<cftry>
	<cfloop from="1" to="#varLimite#" step="1" index="varID">
		<cfif ArrayCantidad[varID] LTE 0>
        	<cfthrow message="#MSG_CantidadCero#">
        </cfif>
        <cfif ArrayPrecioU[varID] LTE 0>
        	<cfthrow message="MSG_PrecioCero">
        </cfif>
        <cfif (ArrayCantidad[varID] * ArrayPrecioU[varID]) LTE ArrayDescuento[varID]>
        	<cfthrow message="#MSG_DescuentoMayor#">
        </cfif>
        
        <!---Calculo de Impuesto --->
        <cfquery name="rsImpuesto" datasource="#session.dsn#">
        	select Iporcentaje, Icreditofiscal 
            from Impuestos
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayImpuesto[varID]#">
        </cfquery>
        <cfif rsImpuesto.Iporcentaje GT 0>
        	<cfset varImpuesto = ((ArrayCantidad[varID] * ArrayPrecioU[varID]) - ArrayDescuento[varID]) * (rsImpuesto.Iporcentaje/100)>
        <cfelse>
        	<cfset varImpuesto = 0>
        </cfif>
        <!---Calcula el Porcentaje de Descuento --->
        <cfif ArrayDescuento[varID] GT 0>
			<cfset varPorcentaje = (ArrayDescuento[varID] * 100) /(ArrayCantidad[varID] * ArrayPrecioU[varID])>
        <cfelse>
        	<cfset varPorcentaje = 0>
        </cfif>
        
        <!--- Actualiza los Valores --->
        <!--- Para el descuento se respeta el % y se calcula el Monto--->
        <cfquery datasource="#session.dsn#">
        	update DOrdenCM
            set DOcantidad = <cfqueryparam cfsqltype="cf_sql_float" value="#ArrayCantidad[varID]#">,
            DOpreciou = <cfqueryparam cfsqltype="cf_sql_money" value="#ArrayPrecioU[varID]#">,
            DOmontodesc = <cfqueryparam cfsqltype="cf_sql_float" value="#ArrayDescuento[varID]#">,
            DOporcdesc = <cfqueryparam cfsqltype="cf_sql_float" value="#varPorcentaje#">,
            DOtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#ArrayCantidad[varID]*ArrayPrecioU[varID]#">,
            Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayImpuesto[varID]#">,
            <cfif rsImpuesto.Icreditofiscal EQ 0>
            	DOimpuestoCosto = <cfqueryparam cfsqltype="cf_sql_money" value="#varImpuesto#">
            <cfelse>
            	DOimpuestoCF = <cfqueryparam cfsqltype="cf_sql_money" value="#varImpuesto#">
            </cfif>
            where 
            Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
            and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ArrayLinea[varID]#">
        </cfquery>
        
        <!---Acumula Totales--->
        <cfset varImpuestoTotal = varImpuestoTotal + varImpuesto>
		<cfset varDescuentoTotal = varDescuentoTotal + ArrayDescuento[varID]>
        <cfset varTotal = varTotal + (ArrayCantidad[varID] * ArrayPrecioU[varID]) - ArrayDescuento[varID] + varImpuesto>
	</cfloop>
    
    <!---Actualiza los Totales--->
    <cfquery datasource="#session.dsn#">
        update EOrdenCM
        set Impuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#varImpuestoTotal#">,
        EOdesc = <cfqueryparam cfsqltype="cf_sql_money" value="#varDescuentoTotal#">,
        EOtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#varTotal#">
        where 
        Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOidorden#">
    </cfquery>
<cftransaction action="commit" />
<cfcatch>
	<cftransaction action="rollback" />
    <cfset varError = "#MSG_Error# #cfcatch.Message#">
    <cfif isdefined("cfcatch.Detail") and len(cfcatch.Detail) GT 0>
    	<cfset varError = varError & " Detalle: #cfcatch.Detail#">
    </cfif>
	<cfif isdefined("cfcatch.sql")>
    	<cfset varError = varError & " SQL: #cfcatch.sql#">
    </cfif>
    <cfif isdefined("cfcatch.where")>
    	<cfset varError = varError & " SQL: Parametros: #cfcatch.where#">
    </cfif>
    <cfabort showerror="#varError#">
</cfcatch>
</cftry>
</cftransaction>
<cfinclude template="ModificaDetalles-form.cfm">