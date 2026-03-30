<!--- NOTAS:
		1. rsComponentesActual, rsComponentesPropuestos estan definidos en registro-movimientos-form.cfm
--->

<script language="javascript1.2" type="text/javascript">
	function funcEliminar(id){
		if ( confirm('Desea borrar el Componente Salarial?') ){
			document.form1.CSid_Borrar.value = id;
			document.form1.borrar.value=1;
			return true
		}
		return false;
	}
</script> 

<cfset pAgr = (Len(Trim(data.RHTTid)) and data.RHTTid NEQ 0 and Len(Trim(data.RHCid)) and data.RHCid NEQ 0 and Len(Trim(data.RHMPPid)) and data.RHMPPid NEQ 0)>

<cfinvoke component="rh.Componentes.RH_CompSalarial" method="pComponentes" returnvariable="result">
    <cfinvokeargument name="id" value="#data.RHMPid#">
    <cfinvokeargument name="query" value="#rsComponentesPropuestos#">
    <cfinvokeargument name="totalComponentes" value="#CTotal.Monto#">
    <cfinvokeargument name="sql" value="2">
    <cfinvokeargument name="readonly" value="#configura.componentes is 0#">
    <cfinvokeargument name="permiteAgregar" value="#pAgr#">
	<cfinvokeargument name="negociado" value="#data.RHMPnegociado is 'N'#">
	<cfinvokeargument name="linea" value="RHCMPid">
	<cfinvokeargument name="unidades" value="Cantidad">
	<cfinvokeargument name="montobase" value="MontoBase">
	<cfinvokeargument name="montores" value="MontoRes">
	<cfinvokeargument name="funcionEliminar" value="funcEliminar">
</cfinvoke>