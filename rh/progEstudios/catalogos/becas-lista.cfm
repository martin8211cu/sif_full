<cfset filtro = "(RHTBesCorporativo = 0 and Ecodigo = #session.Ecodigo#) or ( RHTBesCorporativo = 1 and CEcodigo = #session.CEcodigo#)">
<cfset checked = '<img src="/cfmx/rh/imagenes/checked.gif" border="0">'>
<cfset unchecked = '<img src="/cfmx/rh/imagenes/unchecked.gif" border="0">'>	
<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaRet">
    <cfinvokeargument name="tabla" value="RHTipoBeca"/>
    <cfinvokeargument name="columnas" value="RHTBid, RHTBcodigo, RHTBdescripcion, RHTBfecha, case RHTBesCorporativo when 1 then '#preservesinglequotes(checked)#' else '#preservesinglequotes(unchecked)#' end as RHTBesCorporativo"/>
    <cfinvokeargument name="desplegar" value="RHTBcodigo, RHTBdescripcion, RHTBfecha, RHTBesCorporativo"/>
    <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#, #LB_Fecha#, #LB_Corporativo#"/>
    <cfinvokeargument name="formatos" value="V, V, D, I"/>
    <cfinvokeargument name="filtro" value="#filtro#"/>
    <cfinvokeargument name="align" value="left, left, right, center"/>
    <cfinvokeargument name="ajustar" value="S"/>
    <cfinvokeargument name="checkboxes" value="N"/>				
    <cfinvokeargument name="irA" value="becas.cfm"/>
    <cfinvokeargument name="showEmptyListMsg" value="true"/>
    <cfinvokeargument name="mostrar_filtro" value="yes"/>
    <cfinvokeargument name="filtrar_por_delimiters" value="|"/>
    <cfinvokeargument name="filtrar_automatico" value="yes"/>
    <cfinvokeargument name="filtrar_por" value="RHTBcodigo|RHTBdescripcion|RHEBEfecha|RHEBEestado"/>
    <cfinvokeargument name="keys" value="RHTBid"/>
</cfinvoke>