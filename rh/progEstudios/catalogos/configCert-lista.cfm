<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaRet">
    <cfinvokeargument name="tabla" value="RHEConfigCertBecas ccb inner join RHTipoBeca tb on tb.RHTBid = ccb.RHTBid"/>
    <cfinvokeargument name="columnas" value="ccb.RHECCBid, ccb.RHTBid, RHTBcodigo, RHTBdescripcion"/>
    <cfinvokeargument name="desplegar" value="RHTBcodigo, RHTBdescripcion"/>
    <cfinvokeargument name="etiquetas" value="Código,Descripción"/>
    <cfinvokeargument name="formatos" value="V, V, D, B"/>
    <cfinvokeargument name="filtro" value="ccb.Ecodigo = #session.Ecodigo#"/>
    <cfinvokeargument name="align" value="left, left"/>
    <cfinvokeargument name="ajustar" value="S"/>
    <cfinvokeargument name="checkboxes" value="N"/>				
    <cfinvokeargument name="irA" value="configCert.cfm"/>
    <cfinvokeargument name="showEmptyListMsg" value="true"/>
    <cfinvokeargument name="keys" value="RHECCBid"/>
</cfinvoke>