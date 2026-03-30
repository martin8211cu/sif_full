

<cfquery name="rsSociosN" datasource="#session.DSN#">
	select SNcodigo, SNid, SNnombre, SNidentificacion, SNnumero, DEidVendedor, DEidCobrador, SNcuentacxc, SNvenventas
	from SNegocios a, EstadoSNegocios b
	where a.Ecodigo =  #Session.Ecodigo#
		and a.ESNid = b.ESNid
		and a.SNid = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.valor#">
</cfquery>


<cfset ArrSN = ArrayNew(1)>
<cfif rsSociosN.recordCount gt 0>
	<cfset ArrayAppend(ArrSN,rsSociosN.SNid)>
	<cfset ArrayAppend(ArrSN,rsSociosN.SNnumero)>
	<cfset ArrayAppend(ArrSN,rsSociosN.SNnombre)>
</cfif>

<cf_conlis
	Campos="f_30200101,SNnumero_30200101,SNnombre_30200101"
	Desplegables="N,S,S"
	Modificables="N,S,N"
	Size="0,10,30"
	tabindex="2"
	ValuesArray="#ArrSN#"
	Tabla="Snegocios"
	Columnas="SNid as f_30200101,SNnumero as SNnumero_30200101,SNnombre as SNnombre_30200101"
	form="form1"
	Filtro="Ecodigo = #Session.Ecodigo# and (SNtiposocio = 'C' or SNtiposocio = 'A')
			order by SNnombre"
	Desplegar="SNnumero_30200101,SNnombre_30200101"
	Etiquetas="Codigo, Nombre"
	filtrar_por="SNnumero,SNnombre"
	Formatos="S,S"
	Align="left,left"
	Asignar="f_30200101,SNnumero_30200101,SNnombre_30200101"
	Asignarformatos="S,S,S"/>
