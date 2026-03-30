<cftransaction>
    <cfinvoke component="rh.Componentes.RH_PreLiquidacion" method="AddPreLiquidacion" returnvariable="xx">
        <cfinvokeargument name="DEid" 	value="#form.DEid#"/>
        <cfinvokeargument name="RHTid" 	value="#form.RHTid#"/>	
        <cfinvokeargument name="Fhasta"	value="#LSDateFormat(form.DLfvigencia)#"/>	
    </cfinvoke>
</cftransaction>

<!---<cflocation url="PreLiquidacion.cfm">--->
<cflocation url="PreliquidacionProceso.cfm">