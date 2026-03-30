

<cfquery name="rsRole" datasource="asp">
	select SRcodigo, SRdescripcion from SRoles
	where SRinterno = 0 
	and   SScodigo = 'CRED'  
	and  SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.valor#">
</cfquery>


<cfset ArrRol = ArrayNew(1)>
<cfif rsRole.recordCount gt 0>
	<cfset ArrayAppend(ArrRol,rsRole.SRcodigo)>
	<cfset ArrayAppend(ArrRol,rsRole.SRdescripcion)> 
</cfif>

<cf_conlis
	Campos="f_30200711, SRdescripcion_30200711 "
	Desplegables="S,S"
	Modificables="S,N"
	Size="10,30"
	tabindex="2"
	ValuesArray="#ArrRol#"
	Tabla="SRoles"
	Columnas="SRcodigo as f_30200711, SRdescripcion as SRdescripcion_30200711"
	form="form1"
	Filtro="SRinterno = 0 and SScodigo = 'CRED'  order by SRdescripcion"
	Desplegar="f_30200711, SRdescripcion_30200711"
	Etiquetas="Codigo, Descripcion"
	filtrar_por="SRcodigo, SRdescripcion"
	Formatos="S,S"
	Align="left,left"
	Asignar="f_30200711,SRdescripcion_30200711"
	Asignarformatos="S,S"
	conexion= "asp"/>
