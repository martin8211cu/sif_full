<!--- Validar parametros --->
<cfif not isdefined("Form.cedula")>
 	<cflocation url="error.cfm?msg=sin-cedula">
</cfif>

<cfinclude template="config.cfm">

<!--- Iniciar un nuevo tramite --->
<cfquery datasource="sdc" name="insert">
	set nocount on
	insert TramitePasaporte (Usucodigo, Ulocalizacion, Cedula)
	values (
		<cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cedula#"> )
	select convert (varchar, @@identity) as TPID
	set nocount off
</cfquery>
<!--- <cfdump var="#insert#"> --->
<cfset TPID = insert.TPID>
<!--- Preparar objetos para llamar web service de migracion --->
<cfobject action=create name="Tramites"    type="JAVA" class="com.soin.remoteservices.soinsoap.Workflow.Tramites">
<cfobject action=create name="prop"        type="JAVA" class="java.util.Properties">
<cfobject action=create name="autentica"   type="JAVA" class="com.soin.remoteservices.soinsoap.Workflow.TypeMapping.Autenticacion">
<cfobject action=create name="paramcedula" type="JAVA" class="com.soin.remoteservices.soinsoap.Workflow.TypeMapping.Parametro">

<!--- Realizar la invocacion del web service --->
	
<!--- 	<cfset ret=Tramites.init('http://www.migestion.net/SoinSoap/rpcServer', false, '10.7.7.57', 4050)> --->
	<cfset ret=Tramites.init(uriPasaporte, false, '', 0)>
	<!--- <cfdump var="#Tramites#">--->
	<cfset ret=autentica.init('guest','passwd')>
	<cfset listaParametros=ArrayNew(1)>
	<cfset temp=ArraySet(listaParametros,1,1,'')>
	<cfset paramcedula.init('cedula', replace( trim(form.cedula),'-','','all'))>
	<!--- <cfdump var="#paramcedula#" label="Parametro de cedula"> --->
	<cfset listaParametros[1]=paramcedula>
	<!---
	<cfoutput>ListaParametros:</cfoutput>
	<cfloop index="i" from="1" to="#ArrayLen(listaParametros)#">
		<cfoutput>#listaParametros[i].getNombre()# = '#listaParametros[i].getValor()#' <br></cfoutput>
	</cfloop>
	--->
	<CFSET ret = Tramites.ProcesaTipoTramite (autentica, 'consulta', listaParametros)>

	Resultado:<br>
	<cfset WSestado="">
	<cfset WSnombre="">
	<cfset WSexpedido="">
	<cfset WSexpira="">
	<cfloop index="i" from="1" to="#ArrayLen(ret)#">
	<!---
		<cfoutput>i = #i#, #ret[i].getNombre()# = #ret[i].getValor()# <br></cfoutput>
	--->
		<cfif #Lcase(Trim(ret[i].getNombre()))# EQ "nombre"><cfset WSnombre=ret[i].getValor()></cfif>
		<cfif #Lcase(Trim(ret[i].getNombre()))# EQ "estado"><cfset WSestado=ret[i].getValor()></cfif>
		<cfif #Lcase(Trim(ret[i].getNombre()))# EQ "fecha_expedicion"><cfset WSexpedido=ret[i].getValor()></cfif>
		<cfif #Lcase(Trim(ret[i].getNombre()))# EQ "fecha_expiracion"><cfset WSexpira=ret[i].getValor()></cfif>
	</cfloop>
	
	<cfset Pestado='N'>
	<cfif #WSestado# EQ "NUEVO">
		<cfset Pestado='N'>
	<cfelseif #WSestado# EQ "VIGENTE">
		<cfset Pestado='V'>
	<cfelseif #WSestado# EQ "RENOVAR">
		<cfset Pestado='R'>
	<cfelseif #WSestado# EQ "REVALIDAR">
		<cfset Pestado='E'>
	</cfif>
	
	
<br>
	<cfoutput>WSestado = #WSestado#</cfoutput><br>
	<cfoutput>WSnombre = #WSnombre#</cfoutput><br>
	<cfoutput>WSexpedido = #WSexpedido#</cfoutput><br>
	<cfoutput>WSexpira = #WSexpira#</cfoutput>

<!--- Guardar el estado del tramite - importe y moneda se ignoran --->
<cfquery datasource="sdc">
	update TramitePasaporte
	set Pestado = '#Pestado#',
	    Avance = '2',
		Pnombre   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#WSnombre#">,
		Pexpedido = <cfqueryparam cfsqltype="cf_sql_date"    value="#WSexpedido#">,
		Pexpira   = <cfqueryparam cfsqltype="cf_sql_date"    value="#WSexpira#">
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and Cedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cedula#">
	  and TPID = #TPID#
</cfquery>

<cflocation url="trpass02.cfm?TPID=#TPID#" >
