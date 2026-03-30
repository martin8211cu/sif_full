<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="Det-listaMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="Det-listaMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DescripcionAlterna" default="Descripcion Alterna" returnvariable="LB_DescripcionAlterna" xmlfile="Det-listaMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrecioUnitario" default="Precio Unitario" returnvariable="LB_PrecioUnitario" xmlfile="Det-listaMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="Det-listaMetodoParticipacion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="Det-listaMetodoParticipacion.xml">

<!--- Filtro para la lista --->

<cfquery name="rsDetMetPar" datasource="#session.dsn#">
	select emp.MetParID, emp.SNid, emp.Documento, emp.Descripcion,m.Miso4217,dmp.pctjePart, dmp.Capital
	from EMetPar emp left join DMetPar dmp on emp.Ecodigo=dmp.Ecodigo and emp.MetParID=dmp.MetParID
    inner join Monedas m on dmp.Ecodigo=m.Ecodigo and dmp.Mcodigo=m.Mcodigo
 	where emp.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and dmp.MetParID=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MetParID#">
</cfquery>
<cfinvoke
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsDetMetPar#"/>
		<cfinvokeargument name="desplegar" value="Documento, Descripcion, pctjePart, Capital, Miso4217"/>
		<cfinvokeargument name="etiquetas" value="#LB_Documento#,#LB_Descripcion#, #LB_pctjePar#, #LB_Capital#, #LB_Moneda#"/>
		<cfinvokeargument name="formatos" value="S, S,M, M, S"/>
		<cfinvokeargument name="align" value="left, left,  rigth, rigth, left"/>
		<cfinvokeargument name="ajustar" value="N, N, N, N, N, N"/>
		<cfinvokeargument name="irA" value="MetodoParticipacion.cfm"/>
		<cfinvokeargument name="keys" value="MetParId"/>
		<cfinvokeargument name="showemptylistmsg" value="true"/>
</cfinvoke>