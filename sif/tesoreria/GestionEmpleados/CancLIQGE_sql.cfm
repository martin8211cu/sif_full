<!---Ir a lista--->
<cfif IsDefined("form.irLista")>
	<cflocation url="CancLIQGE.cfm">
</cfif>

<!---Cancelar--->
<cfif IsDefined("form.Cancelar")>
	<cftransaction>
		<cfset LobjControl = createObject( "component","sif.Componentes.PRES_Presupuesto")>
        <cfset LobjControl.CreaTablaIntPresupuesto (session.dsn)/>
        <cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc">
        <cfinvoke component="sif.tesoreria.Componentes.TESgastosEmpleado" method="GEliquidacion_Aplicar">
            <cfinvokeargument name="GELid"  		value="#form.GELid#">
            <cfinvokeargument name="FormaPago" 		value="#form.FormaPago#">
            <cfinvokeargument name="PagoAdicional" 	value="0">
            <cfinvokeargument name="Anulacion" 		value="true">
            <cfinvokeargument name="GELmsgRechazo" 	value="#form.msgRechazo#">
        </cfinvoke>	
    </cftransaction>
    <cflocation url="CancLIQGE.cfm">
</cfif>

	


