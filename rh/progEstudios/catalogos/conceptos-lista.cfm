<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaRet">
    <cfinvokeargument name="tabla" value="RHEConceptosBeca"/>
    <cfinvokeargument name="columnas" value="RHECBid, RHECBcodigo, RHECBdescripcion, RHECBfecha"/>
    <cfinvokeargument name="desplegar" value="RHECBcodigo, RHECBdescripcion, RHECBfecha"/>
    <cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Fecha#"/>
    <cfinvokeargument name="formatos" value="S,S,D"/>
    <cfinvokeargument name="formName" value="lista"/>
    <cfinvokeargument name="filtro" value="CEcodigo = #Session.CEcodigo# order by RHECBcodigo, RHECBdescripcion"/>
    <cfinvokeargument name="align" value="left, left, left"/>
    <cfinvokeargument name="ajustar" value="S"/>
    <cfinvokeargument name="checkboxes" value="N"/>
    <cfinvokeargument name="botones" value="Nuevo"/>
    <cfinvokeargument name="keys" value="RHECBid"/>
    <cfinvokeargument name="irA" value="conceptos.cfm"/>
</cfinvoke>