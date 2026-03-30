<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaRet">
    <cfinvokeargument name="tabla" value="RHEBecasEmpleado ebe 
    										inner join DatosEmpleado de on de.DEid = ebe.DEid
                                            inner join RHTipoBeca tb on tb.RHTBid = ebe.RHTBid"/>
    <cfinvokeargument name="columnas" value="RHEBEid, ebe.RHTBid, ebe.DEid, RHTBdescripcion, DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido1 as Empleado, RHEBEfecha, case RHEBEestado when 10 then 'Solicitado' when 20 then 'Rechazado por jefatura' when 30 then 'Aprobado por jefatura' when 40 then 'Rechazado por Vicerectoría' when 50 then 'Aprobado por Vicerectoría' when 60 then 'Rechazado por Comité de becas' when 70 then 'Aprobado por Comité de becas' else '' end as RHEBEestado"/>
    <cfinvokeargument name="desplegar" value="RHTBdescripcion, Empleado, RHEBEfecha, RHEBEestado"/>
    <cfinvokeargument name="etiquetas" value="#LB_Beca#,#LB_Empleado#,#LB_Fecha#,#LB_Estado#"/>
    <cfinvokeargument name="formatos" value="V, V, D, U"/>
    <cfinvokeargument name="filtro" value="ebe.Ecodigo = #session.Ecodigo# and ebe.RHEBEestado = 10 and ebe.DEid = #rsReferencia.llave#"/>
    <cfinvokeargument name="align" value="left, left, left, left"/>
    <cfinvokeargument name="ajustar" value="S"/>
    <cfinvokeargument name="checkboxes" value="N"/>				
    <cfinvokeargument name="irA" value="RegBecas.cfm"/>
    <cfinvokeargument name="botones" value="Nuevo"/>
    <cfinvokeargument name="mostrar_filtro" value="yes"/>
    <cfinvokeargument name="filtrar_por_delimiters" value="|"/>
    <cfinvokeargument name="filtrar_por" value="RHTBdescripcion|DEnombre#_CAT#' '#_CAT#DEapellido1#_CAT#' '#_CAT#DEapellido1"/>
    <cfinvokeargument name="keys" value="RHEBEid"/>
</cfinvoke>