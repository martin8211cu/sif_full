<cfinvoke component="commons.Utilitarios.ActualizaComponentes" method="RecalculoComponentes"> 
    <cfinvokeargument  name="TipoLinea" value="1" > 		<!--- 0 ninguna 1 Principal 2 Recargo 3 Ambas--->
    <cfinvokeargument name="ListaCSid" 	value="2"> 	<!---componentes que vamos a recalcular--->
    <cfinvokeargument name="DEid"		value="6">			<!---Lista de empleados que vamos afectar 0 = todos loe empelados--->
    <cfinvokeargument name="Desde"		value="07/01/2014">	<!---inicio de cortes que queremos afectar--->
    <cfinvokeargument name="Hasta"		value="01/01/6100">	<!---final  de cortes que queremos afectar--->        
    <cfinvokeargument name="debug" 		value="true">
</cfinvoke>

<cfdump var="Proceso Concluido....">