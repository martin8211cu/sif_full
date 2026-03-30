<!--- modificado en notepad para incluir el boom --->
<cfinclude template="RHPagosExternos-dicc.cfm">
<cf_templateheader title="#LB_RHPagosExternos#">
<cf_web_portlet_start titulo="#LB_RHPagosExternos#"/>

	<cfinclude template="RHPagosExternos-form.cfm">
	
	<cfset rsPEXmesdesc = queryNew("value,description","Integer,Varchar")>
	<cfset queryAddRow(rsPEXmesdesc,1)>
	<cfset querySetCell(rsPEXmesdesc,"value",-1,rsPEXmesdesc.recordcount)>
	<cfset querySetCell(rsPEXmesdesc,"description","Todos",rsPEXmesdesc.recordcount)>
	<cfif isdefined("request.qrymeses")>
		<cfset rsmeses = request.qrymeses>
	<cfelse>
		<cfquery name="rsmeses" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
			from Idiomas a
				inner join VSidioma b
				on b.Iid = a.Iid
				and b.VSgrupo = 1
			where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
			order by <cf_dbfunction name="to_number" args="b.VSvalor">
		</cfquery>
	</cfif>
	<cfloop query="rsmeses">
		<cfset queryAddRow(rsPEXmesdesc,1)>
		<cfset querySetCell(rsPEXmesdesc,"value",v,rsPEXmesdesc.recordcount)>
		<cfset querySetCell(rsPEXmesdesc,"description",m,rsPEXmesdesc.recordcount)>
	</cfloop>
	
	<cfquery name="rsperiodos" datasource="#session.dsn#">
		select distinct PEXperiodo
		from RHPagosExternos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	</cfquery>
	<cfset rsPEXperiododesc = queryNew("value,description","Integer,Varchar")>
	<cfset queryAddRow(rsPEXperiododesc,1)>
	<cfset querySetCell(rsPEXperiododesc,"value",-1,rsPEXperiododesc.recordcount)>
	<cfset querySetCell(rsPEXperiododesc,"description","Todos",rsPEXperiododesc.recordcount)>
	<cfloop query="rsperiodos">
		<cfset queryAddRow(rsPEXperiododesc,1)>
		<cfset querySetCell(rsPEXperiododesc,"value",PEXperiodo,rsPEXperiododesc.recordcount)>
		<cfset querySetCell(rsPEXperiododesc,"description",PEXperiodo,rsPEXperiododesc.recordcount)>
	</cfloop>
	
	<cfset filtrar_por_array = ArrayNew(1)>
	<cfset ArrayAppend(filtrar_por_array,"PEXperiodo")>
	<cfset ArrayAppend(filtrar_por_array,"PEXmes")>
	<cfset ArrayAppend(filtrar_por_array,"DEidentificacion")>
	<cfset ArrayAppend(filtrar_por_array,"{fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', b.DEnombre)})})})}")>
	<cfset ArrayAppend(filtrar_por_array,"PEXmonto")>
	<cfset ArrayAppend(filtrar_por_array,"''")>
	
	<cf_dbfunction name="to_number" args="y.VSvalor" returnvariable="VSvalorConverted"> 
	
	<cfinvoke component="rh.Componentes.pListas" method="pListaRH"
		tabla="RHPagosExternos a
				inner join DatosEmpleado b
					on b.DEid = a.DEid

				inner join VSidioma y
					inner join Idiomas x
						on x.Iid = y.Iid
						and x.Icodigo = '#session.idioma#'
					on y.VSgrupo = 1
					and #VSvalorConverted# = a.PEXmes
		"
		columnas="a.PEXid, a.DEid, a.PEXmonto, a.PEXperiodo, a.PEXmes, a.PEXfechaPago, '' as x, VSdesc as PEXmesdesc, 
			b.DEidentificacion, {fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', b.DEnombre)})})})} as DEnombrecompleto"
		filtro="a.Ecodigo = #Session.Ecodigo# order by DEidentificacion"
		desplegar="PEXperiodo, PEXmesdesc, DEidentificacion, DEnombrecompleto, PEXmonto, x"
		filtrar_por_array="#filtrar_por_array#"
		etiquetas="#LB_PEXperiodo#, #LB_PEXmes#, #LB_DEidentificacion# #LB_Empleado#, #LB_DEnombrecompleto#  #LB_Empleado#, #LB_PEXmonto#, "
		formatos="I, I, S, S, S, US"
		align="left, left, left, left, right, left"
		ira="RHPagosExternos.cfm"
		form_method="get"
		keys="PEXid"
		mostrar_filtro="yes"
		filtrar_automatico="yes"
		rsPEXmesdesc="#rsPEXmesdesc#"
		rsPEXperiodo="#rsPEXperiododesc#"
	/>
	
<cf_web_portlet_end/>
<cf_templatefooter>