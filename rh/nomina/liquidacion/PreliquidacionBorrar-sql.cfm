<cftransaction>
    <cfinvoke component="rh.Componentes.RH_PreLiquidacion" method="DelPreLiquidacion" returnvariable="xx">
        <cfinvokeargument name="RHPLPids" 	value="#form.chk#"/>
    </cfinvoke>
</cftransaction>

<cflocation url="PreliquidacionProceso.cfm">