<cfparam name="modo" default="ALTA">
<cfset LvarPagina = "ValesExtCancelado.cfm">
<cfset resultT = ''>

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")> <!--- Agregar Vale Externo --->
		<cfif trim(Form.FOLIO) neq '' && trim(Form.FOLIOFIN) eq ''> <!--- Agregar solo un Vale Ext. --->
			<cftry>
				<cfquery datasource="#Session.DSN#">
					insert into CRCValesExtCancelados 
						(Folio,CRCTiendaExternaid,FechaCancelado,Observaciones,Ecodigo,CRCCuentasid, Estado)
					values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FOLIO#">,
						<cfqueryparam cfsqltype="cf_sql_inumeric" value="#Form.IDTIENDA#">,
						<cfqueryparam cfsqltype="cf_sql_date" value="#dateTimeFormat (now(),'yyyy/mm/dd')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OBSERVACIONES#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDCUENTA#" null="#Form.IDCUENTA eq ''#">,
						'C'
						)
				</cfquery>
				<cfset modo="ALTA">
			
			<cfcatch>
				<!--- Manejo de Errores --->
				<cfif isDefined('cfcatch.cause.errorcode') && cfcatch.cause.errorcode eq 2627>
					<!--- Unico folio por tienda --->
					<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
					<cfif FindNoCase("_foliotienda_",msg[1]) neq 0>
						<cfset resultT = "Folio (#Form.FOLIO#) para la Tienda (#Form.DESCRIPTIENDA#) ya existe, intente modificarla.">
					<cfelse>
						<cfset resultT = "#cfcatch.cause.message#">
					</cfif>
				<cfelse>
					<cfset resultT = "#cfcatch.cause.message#">
				</cfif>
			</cfcatch>
			</cftry>
			
		<cfelse> <!--- Agregar vales externos en rango --->
			<cfset INI = structNew()>
				<cfset INI.folio = '#form.Folio#'>
				<cfset INI.numero = ''>
				<cfset INI.formato = ''>
			<cfset FIN = structNew()>
				<cfset FIN.folio = '#form.FolioFIN#'>
				<cfset FIN.numero = ''>
				<cfset FIN.formato = ''>

			<!--- Digestion del folio inicial --->
			<cfloop index="i" from="1" to="#Len(INI.folio)#">
				<cfif ArrayLen(reMatch('\d', Mid(INI.folio,i,1))) gt 0>
					<cfset INI.formato = '#INI.formato#~ '> <!--- Obtener patron --->
					<cfset INI.numero = '#INI.numero##Mid(INI.folio,i,1)#'> <!--- Obtener cadena numerica --->
				<cfelse>
					<cfset INI.formato = '#INI.formato##Mid(INI.folio,i,1)# '> <!--- Obtener patron --->
				</cfif>
			</cfloop>
			<cfset INI.numero = LSParseNumber(INI.numero)> <!--- Convertir cadena a numero --->

			<!--- Digestion del folio final --->
			<cfloop index="i" from="1" to="#Len(FIN.folio)#">
				<cfif ArrayLen(reMatch('\d', Mid(FIN.folio,i,1))) gt 0>
					<cfset FIN.formato = '#FIN.formato#~ '> <!--- Obtener patron --->
					<cfset FIN.numero = '#FIN.numero##Mid(FIN.folio,i,1)#'> <!--- Obtener cadena numerica--->
				<cfelse>
					<cfset FIN.formato = '#FIN.formato##Mid(FIN.folio,i,1)# '> <!--- Obtener patron --->
				</cfif>
			</cfloop>
			<cfset FIN.numero = LSParseNumber(FIN.numero)> <!--- Convertir cadena a numero --->



			<!--- Validaciones --->
			<cfif INI.formato neq FIN.formato> <!--- Los formatos son diferentes --->
				<cfthrow message="El formato inicial no corresponde con el final (#INI.formato#) > (#FIN.formato#)">
			</cfif>

			<cfif INI.numero ge FIN.numero> <!--- El numero inicial obteenido de la digestion es menor al numero final obtenido de la digestion --->
				<cfthrow message="No se pueden generar folios, los numeros en (#INI.folio#) son menores a (#FIN.folio#)">
			</cfif>

			<cfset aarLetters =REFIND("[A-Z]",ucase(INI.folio),0,true,"all")>

			<cfset folios = []>

			<!---
			<cfif lectura eq '<'>
				<cfset INI.numero = Reverse(INI.numero)>
				<cfset FIN.numero = Reverse(FIN.numero)>
			</cfif>
			--->
			<!--- Generar Folios --->
			<cfset queryBlock = ''>
			<cfloop index="i" from="#INI.numero#" to="#FIN.numero#">
				<cfset varTo = len(FIN.numero)>
				<cfif len(INI.folio)-ArrayLen(aarLetters) gt 1 and aarLetters[1].len[1] gt 0>
					<cfset varTo = len(INI.folio)-ArrayLen(aarLetters)>
				</cfif>
				<cfset numero = "#right(RepeatString('0', len(INI.folio))&i,varTo)#">
				
				<cfset folioResult = "">
				<cfset nPos = 1>
				<cfloop index="intChar" from="1" to="#Len( INI.folio )#" step="1">
					<cfset strChar = Mid( INI.folio, intChar, 1 ) />
					<cfif IsNumeric(strChar)>
						<cfset strNumber = Mid( numero, nPos, 1 ) />
						<cfset folioResult = folioResult & strNumber>
						<cfset nPos += 1>
					<cfelse>
						<cfset folioResult = folioResult & strChar>
					</cfif>
				</cfloop>
				
				<cfset arrayAppend(folios, folioResult)> <!--- Agrega el folio generado a un arreglo ---> 
			</cfloop>
						
			<!--- Obtiene los folios "nuevos" que hayan sido registrados previamente para la tienda --->
			<cfquery name="q_foliosExist" datasource="#Session.DSN#">
				select Folio from CRCValesExtCancelados where 
					Folio in ('#ArrayTolIst(folios,"','")#') 
					and ecodigo = #session.ecodigo#
					and CRCTiendaExternaid = #Form.IDTIENDA#
			</cfquery>
			<cfset q_folios = []>
			<!--- convierte los folios del query a un arreglo--->
			<cfif q_foliosExist.recordCount gt 0>
				<cfset q_folios = ValueList( q_foliosExist.Folio )>
				<cfset q_folios = ListToArray(q_folios)>
			</cfif>
			
			<!--- Itera sobre cada folio nuevo --->
			<cfloop array="#folios#" index="i" item="t">
				

				<cfif arrayFind(q_folios, folios[i]) eq 0> <!--- Si no esta en el arreglo de folios existentes, genera su query--->
					<cfset query = "insert into CRCValesExtCancelados
									(Folio,CRCTiendaExternaid,FechaCancelado,Observaciones,Ecodigo,CRCCuentasid, Estado)
								values ( 
									'#folios[i]#'
									, '#Form.IDTIENDA#'
									, '#dateTimeFormat (now(),'yyyy/mm/dd')#'
									, '#Form.OBSERVACIONES#'
									, #Session.Ecodigo#">
					<cfif isdefined("form.IDCUENTA") and len(trim(form.IDCUENTA) eq 0)>
						<cfset query = query & ", null">
					<cfelse>
						<cfset query = query & ", #form.IDCUENTA#">
					</cfif>
									
					<cfset query = query & ", 'C' );">
					<cfset queryblock = "#queryblock##query#">
				</cfif>
			</cfloop>
			<!--- Inserta los nuevos folios en bloque --->
			<cftry>
				<cftransaction>
					<cfquery datasource="#Session.DSN#">
						#preserveSingleQuotes(queryblock)#
					</cfquery>
				</cftransaction>
				<cfset modo="ALTA">
			<cfcatch>
				<cfrethrow>
				<cfif isDefined('cfcatch.cause.errorcode') && cfcatch.cause.errorcode eq 2627>
					<cfset msg = REMatch("Violation of UNIQUE KEY constraint '.*?'\.",cfcatch.cause.message)>
					<cfif FindNoCase("_foliotienda_",msg[1]) neq 0>
						<cfset resultT = "Folio (#Form.FOLIO#) para la Tienda (#Form.DESCRIPTIENDA#) ya existe, intente modificarla.">
					<cfelse>
						<cfset resultT = "#cfcatch.message#">
					</cfif>
				<cfelse>
					<cfset resultT = "#cfcatch.message#">
				</cfif>
			</cfcatch>
			</cftry>
			
		</cfif>
	<cfelseif isdefined("Form.Baja")> <!--- Eliminar Vale Externo--->
		<cfquery datasource="#Session.DSN#">
			delete from CRCValesExtCancelados
			where id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
		</cfquery>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---VALIDADOR--->

<form action="<cfoutput>#LvarPagina#</cfoutput><cfif isdefined('url.desde') and Trim(url.desde) eq 'rh'>?desde=rh</cfif>" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo">
	</cfif>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">

	<cfif modo neq 'ALTA'>
		<input name="id" type="hidden" value="<cfif isdefined("Form.id")><cfoutput>#Form.id#</cfoutput></cfif>">
	</cfif>
	<input type="hidden" name="resultT" id="resultT" value="<cfoutput>#resultT#</cfoutput>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
