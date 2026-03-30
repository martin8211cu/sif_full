<!---LvarTCESQLConciLibre--->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAConciliacionLibre ="Conciliacion-Libre.cfm">
 <cfif isdefined("LvarTCESQLConciLibre")>
 	<cfset LvarIrAConciliacionLibre="TCEConciliacion-Libre.cfm">
</cfif>


<cfquery name="rsgrupo" datasource="#Session.DSN#">
	select coalesce(max(a.CDLgrupo) + 1, 1) as grupo
	from CDLibros a, MLibros b
	where b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	and a.MLid = b.MLid
</cfquery>

<cfset grupo = rsgrupo.grupo>
<cftransaction>
	<cfif isdefined("Form.Agregar")>
		<cfset Lvar_sumaDCL = 0>
		<cfset Lvar_sumaDCB = 0>

		<cfif isdefined('form.chkLibros')>
			<cfset chequeados = ListToArray(Form.chkLibros,",")>
			<cfset cuantos = ArrayLen(chequeados)>
			<cfset listaLibros = ''>
			<cfset idsEC = ArrayNew(1)>
			<cfloop index="CountVar" from="1" to="#cuantos#">
				<!--- <cfdump var="#Form.chkLibros#" label ="chkLibros">
				<cfdump var="#chequeados#" label ="chequedados"> --->
				<cfset valores = ListToArray(chequeados[CountVar],"|")>
				<cfset ArrayAppend(idsEC,valores[1])>
				<cfset listaLibros = ListAppend(listaLibros,Trim(valores[2]))>
				<!--- <cfdump var="#valores#" label="valores"> --->
			</cfloop>
			<cfset listaIdsEC = ListRemoveDuplicates(ArrayToList(idsEC))>
			<cfquery name="rsMontoL" datasource="#session.DSN#">
				select
					round(coalesce((
						sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - sum(case CDLtipomov when 'C' then CDLmonto else 0 end)),0.00),2) as sumaDCL
				from CDLibros
				where  ECid in (#Trim(listaIdsEC)#)
				  and MLid in (#listaLibros#)
			</cfquery>
			<cfset Lvar_sumaDCL = rsMontoL.sumaDCL>
		</cfif>
		<cfif isdefined('form.chkBancos')>
			<cfset chequeados1 = ListToArray(Form.chkBancos,",")>
			<cfset cuantos1 = ArrayLen(chequeados1)>
			<cfset listaBancos = ''>
			<cfloop index="CountVar" from="1" to="#cuantos1#">
				<!--- <cfdump var="#Form.chkBancos#" label ="chkbancos">
				<cfdump var="#chequeados1#" label ="chequedados1"> --->
				<cfset valores1 = ListToArray(chequeados1[CountVar],"|")>
				<cfset listaBancos = ListAppend(listaBancos,Trim(valores1[2]))>
				<!--- <cfdump var="#valores1#" label="valores1"> --->
			</cfloop>

			<!--- <cf_dump var="#listaBancos#" label=" lista bancos"> --->

			<cfquery name="rsMontoB" datasource="#session.DSN#">
				select coalesce((sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
				sum(case CDBtipomov when 'C' then CDBmonto else 0 end)),0.00) as sumaDCB
				from CDBancos
				where  ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[1])#">
				  and CDBlinea in (#listaBancos#)
			</cfquery>
			<cfset Lvar_sumaDCB = rsMontoB.sumaDCB>
		</cfif>

		<!--- VALIDACION DE IGUALDAD ENTRE SUMA DE DEBITOS Y CREDITOS BANCOS Y SUMA DE DEBITOS Y CREDITOS LIBROS --->
		 <!---<cfdump var="#Lvar_sumaDCL#">
		<cf_dump var="#Lvar_sumaDCB#"> --->

				<!--- JARR Se permite asignar montos con diferencia ente -1---1 peso  al asignar montos
		<cfif Lvar_sumaDCL NEQ Lvar_sumaDCB>
		--->

		<cfif  (Lvar_sumaDCL - Lvar_sumaDCB ) lt -1 or (Lvar_sumaDCL-Lvar_sumaDCB) gt 1 >

			<!--- recordar el filtro --->
			<cfset filtroform="">
			<cfif isDefined("Form.optFecha") or isDefined("url.optFecha")>
				<cfset filtroform="&optFecha=1">
			<cfelseif isDefined("Form.optNumDoc") or isDefined("url.optNumDoc")>
				<cfset filtroform="&optNumDoc=1">
			<cfelseif isDefined("Form.optTipoDoc_NumDoc") or isDefined("url.optTipoDoc_NumDoc")>
				<cfset filtroform="&optTipoDoc_NumDoc=1">
			<cfelseif isDefined("Form.optTipoDoc_Fecha") or isDefined("url.optTipoDoc_Fecha")>
				<cfset filtroform="&optTipoDoc_Fecha=1">
			<cfelseif isDefined("Form.optMonto") or isDefined("url.optMonto")>
				<cfset filtroform="&optMonto=1">
			</cfif>
			<cfif IsDefined("form.FiltroSelectL")><!--- libros seleccionados --->
				<cfset filtroform=filtroform & "&FiltroSelectL=1">
			</cfif>
			<cfif IsDefined("form.FiltroSelectB")><!--- bancos seleccionados --->
				<cfset filtroform=filtroform & "&FiltroSelectB=1">
			</cfif>
			<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm--->
			<cflocation url="#LvarIrAConciliacionLibre#?ECid=#form.ECid#&BTid=#form.BTid#&BTEcodigo=#form.BTEcodigo#&msg=1#filtroform#">
			<cfabort>
		</cfif>
		<!--- JARR SE modifiac el id EC por el del CDBAncos en CDLibros --->
		<cfset Lvar_ECidBancos=0>
		<cfif isdefined('form.chkBancos')>
			<cfloop index="CountVar" from="1" to="#cuantos1#">
				<cfset valores1 = ListToArray(chequeados1[CountVar],"|")>
				<cfset Lvar_ECidBancos=Trim(valores1[1])>
				<cfquery name="ABC_Conciliacion" datasource="#Session.DSN#">
					update CDBancos set
						CDBconciliado = 'S',
						CDBmanual = 'S',
						CDBgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#grupo#">,
						CDBacumular=0,
						CDBUsucodigo=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[1])#">
					and CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[2])#">
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined('form.chkLibros')>
			<cfloop index="CountVar" from="1" to="#cuantos#">
				<cfset valores = ListToArray(chequeados[CountVar],"|")>
				<cfquery name="ABC_Conciliacion" datasource="#Session.DSN#">
					update CDLibros set
						CDLconciliado = 'S',
						CDLmanual = 'S',
						CDLgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#grupo#">,
						CDLacumular=0,
						CDLUsucodigo=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ECidBancos#">
					where 1=1
					and MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores[2])#">
				</cfquery>
			</cfloop>
		</cfif>
	</cfif>
</cftransaction>

<!---Redireccion Conciliacion-Libre.cfm o TCEConciliacion-Libre.cfm--->
 <form action="<cfoutput>#LvarIrAConciliacionLibre#</cfoutput>" method="post" name="sql">
	<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid))>
		<input name="ECid" type="hidden" value="<cfoutput>#Form.ECid#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.Agregar")>
		<input name="Asignar" type="hidden" value="<cfoutput>#Form.Agregar#</cfoutput>">
	</cfif>
	<cfif isdefined("form.BTid") and len(trim(form.BTid)) >
		<input name="BTid" type="hidden" value="<cfoutput>#Form.BTid#</cfoutput>">
	</cfif>

	<!--- recordar filtros --->
	<cfif isDefined("Form.optFecha") or isDefined("url.optFecha")>
		<input name="optFecha" type="hidden" value="1">
	<cfelseif isDefined("Form.optNumDoc") or isDefined("url.optNumDoc")>
		<input name="optNumDoc" type="hidden" value="1">
	<cfelseif isDefined("Form.optTipoDoc_NumDoc") or isDefined("url.optTipoDoc_NumDoc")>
		<input name="optTipoDoc_NumDoc" type="hidden" value="1">
	<cfelseif isDefined("Form.optTipoDoc_Fecha") or isDefined("url.optTipoDoc_Fecha")>
		<input name="optTipoDoc_Fecha" type="hidden" value="1">
	<cfelseif isDefined("Form.optMonto") or isDefined("url.optMonto")>
		<input name="optMonto" type="hidden" value="1">
	</cfif>

	<cfif IsDefined("form.FiltroSelectL")><!--- libros seleccionados --->
		<input name="FiltroSelectL" type="hidden" value="1">
	</cfif>
	<cfif IsDefined("form.FiltroSelectB")><!--- bancos seleccionados --->
		<input name="FiltroSelectB" type="hidden" value="1">
	</cfif>
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();
</script>
</body>
</HTML>
