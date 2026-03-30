<!--- 

	Modificado por: Ana Villavicencio
	Fecha: 16 de enero del 2006
	Motivo: Se agrega la verficación de igualdad de las de la suma de debitos y créditos de bancos y libros.  
			Se hace una consulta de la suma de los montos de los documentos marcados, ya sea en libros o bancos.
			Verifica q sean iguales, si no lo son regresa sin hacer cambios.

	Modificadio por: Ana Villavicencio
	Fecha: 25 de octubre del 2005
	Motivo: Se cambio el proceso de asignar documentos para conciliar, no estaba asignando el BTid  (transaccion) para los 
			documentos de bancos.
 --->
  
<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAConciliacion="Conciliacion.cfm">
<cfif isdefined("LvarTCESQLConci")>
	<cfset LvarIrAConciliacion="TCEConciliacion.cfm">
</cfif>



<cfquery name="rsgrupo" datasource="#Session.DSN#">
	select coalesce(max(CDLgrupo) + 1, 1) as grupo 
	from CDLibros a
	where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
</cfquery>

<cfset grupo = rsgrupo.grupo>	
<cftransaction>
	<cfif isdefined("Form.Agregar")>			
		<cfset chequeados = ListToArray(Form.chkLibros,",")>
		<cfset cuantos = ArrayLen(chequeados)>
		<cfset chequeados1 = ListToArray(Form.chkBancos,",")>
		<cfset cuantos1 = ArrayLen(chequeados1)>
		
		<!--- VALIDACION DE IGUALDAD ENTRE SUMA DE DEBITOS Y CREDITOS BANCOS Y SUMA DE DEBITOS Y CREDITOS LIBROS --->
		<cfset listaBancos = ''>
		<cfset listaLibros = ''>
		<cfloop index="CountVar" from="1" to="#cuantos1#">
			<cfset valores1 = ListToArray(chequeados1[CountVar],"|")>
			<cfset listaBancos = ListAppend(listaBancos,Trim(valores1[2]))>
		</cfloop>
		<cfloop index="CountVar" from="1" to="#cuantos#">
			<cfset valores = ListToArray(chequeados[CountVar],"|")>
			<cfset listaLibros = ListAppend(listaLibros,Trim(valores[2]))>
		</cfloop>

		<!--- JARR  23/07/2018 ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[1])#">--->
		<cfquery name="rsMontoB" datasource="#session.DSN#">
			select sum(case CDBtipomov when 'D' then CDBmonto else 0 end) as DebitosB,
			sum(case CDBtipomov when 'C' then CDBmonto else 0 end) as CreditosB,(sum(case CDBtipomov when 'D' then CDBmonto else 0 end) -
			sum(case CDBtipomov when 'C' then CDBmonto else 0 end)) as sumaDCB
			from CDBancos
			where  1=1
			  and CDBlinea in (#listaBancos#)
		</cfquery>
		<cfquery name="rsMontoL" datasource="#session.DSN#">
			select sum(case CDLtipomov when 'D' then CDLmonto else 0 end) as DebitosL,
			sum(case CDLtipomov when 'C' then CDLmonto else 0 end) as CreditosL,
			(sum(case CDLtipomov when 'D' then CDLmonto else 0 end) - sum(case CDLtipomov when 'C' then CDLmonto else 0 end)) as sumaDCL
			from CDLibros
			where   1=1
			  and MLid in (#listaLibros#)
		</cfquery>

		<!--- JARR Se permite asignar montos con diferencia ente -1---1 peso  al asignar montos
		<cfif rsMontoL.sumaDCL  NEQ rsMontoB.sumaDCB>
		--->
			
			<cfif (Abs(rsMontoL.sumaDCL)-Abs(rsMontoB.sumaDCB) gt 1) OR (Abs(rsMontoL.sumaDCL)-Abs(rsMontoB.sumaDCB) lt -1 )>
				
			<!--- recordar el filtro --->
			<cfset filtroform="">
			<cfif isDefined("Form.optFecha")>  
				<cfset filtroform="&optFecha=1">
			<cfelseif isDefined("Form.optNumDoc")>
				<cfset filtroform="&optNumDoc=1">
			<cfelseif isDefined("Form.optTipoDoc_NumDoc")>
				<cfset filtroform="&optTipoDoc_NumDoc=1">
			<cfelseif isDefined("Form.optTipoDoc_Fecha")>
				<cfset filtroform="&optTipoDoc_Fecha=1">
			<cfelseif isDefined("Form.optMonto")>
				<cfset filtroform="&optMonto=1">
			</cfif>
			
			<cfif IsDefined("form.FiltroSelectL")><!--- libros seleccionados --->
				<cfset filtroform=filtroform & "&FiltroSelectL=1">
			</cfif>
			<cfif IsDefined("form.FiltroSelectB")><!--- bancos seleccionados --->
				<cfset filtroform=filtroform & "&FiltroSelectB=1">
			</cfif>
		
			<!---redireccion Conciliacion.cfm o TCEConciliacion.cfm(TCE)--->
			<cflocation url="#LvarIrAConciliacion#?ECid=#form.ECid#&BTid=#form.BTid#&msg=1#filtroform#">
			<cfabort>
		</cfif>

		<!--- ACTUALIZA LOS REGISTROS DE BANCOS Y LIBROS COMO CONCILIADOS
		BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTid#">
	--->
	<!--- JARR SE modifiac el id EC por el del CDBAncos en CDLibros --->
		<cfset Lvar_ECidBancos=0>
		<cfloop index="CountVar" from="1" to="#cuantos1#">
			<cfset valores1 = ListToArray(chequeados1[CountVar],"|")>
			<cfset Lvar_ECidBancos=Trim(valores1[1])>
			<cfquery name="ABC_Conciliacion" datasource="#Session.DSN#">
				update CDBancos set 
					CDBconciliado = 'S', 
					CDBmanual = 'S',
					CDBgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#grupo#">
					
				where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[1])#">
				and CDBlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores1[2])#">
			</cfquery>
		</cfloop>	

		<cfloop index="CountVar" from="1" to="#cuantos#">				
			<cfset valores = ListToArray(chequeados[CountVar],"|")>
			<cfquery name="ABC_Conciliacion" datasource="#Session.DSN#">
				update CDLibros set 
					CDLconciliado = 'S', 
					CDLmanual = 'S', 
					CDLgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#grupo#">,
					ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_ECidBancos#">
				where 1=1
				and MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(valores[2])#">
			</cfquery>
		</cfloop>

		<cfquery name="ABC_Conciliacion" datasource="#Session.DSN#">
			update ECuentaBancaria set 
				ECaplicado = 'N' 
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>
		
	</cfif>
</cftransaction>


<!---redireccion Conciliacion.cfm o TCEConciliacion.cfm(TCE)--->
 <form action="<cfoutput>#LvarIrAConciliacion#</cfoutput>" method="post" name="sql">
	<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid))>
		<input name="ECid" type="hidden" value="<cfoutput>#Form.ECid#</cfoutput>">
	</cfif>	
	<cfif isdefined("Form.Agregar")>
		<input name="Asignar" type="hidden" value="<cfoutput>#Form.Agregar#</cfoutput>">
	</cfif>
	
	
	  <cfif isdefined("form.fbDesc") and len(trim(form.fbDesc)) >
	  	<input name="fbDesc" type="hidden" value="<cfoutput>#Form.fbDesc#</cfoutput>">
	  </cfif>

	  <cfif isdefined("form.fbFecha") and len(trim(form.fbFecha)) >
		<input name="fbFecha" type="hidden" value="<cfoutput>#Form.fbFecha#</cfoutput>">
	  </cfif>
	
	  <cfif isdefined("form.flDesc") and len(trim(form.flDesc)) >
		<input name="flDesc" type="hidden" value="<cfoutput>#Form.flDesc#</cfoutput>">
	  </cfif>

	  <cfif isdefined("form.flFecha") and len(trim(form.flFecha)) >
		<input name="flFecha" type="hidden" value="<cfoutput>#Form.flFecha#</cfoutput>">
	  </cfif>
	  <cfif isdefined("form.BTid") and len(trim(form.BTid)) >
		<input name="BTid" type="hidden" value="<cfoutput>#Form.BTid#</cfoutput>">
	  </cfif>
	  
		<cfif isDefined("Form.optFecha")>  
			<input name="optFecha" type="hidden" value="1">
		<cfelseif isDefined("Form.optNumDoc")>
			<input name="optNumDoc" type="hidden" value="1">
		<cfelseif isDefined("Form.optTipoDoc_NumDoc")>
			<input name="optTipoDoc_NumDoc" type="hidden" value="1">
		<cfelseif isDefined("Form.optTipoDoc_Fecha")>
			<input name="optTipoDoc_Fecha" type="hidden" value="1">
		<cfelseif isDefined("Form.optMonto")>
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
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
