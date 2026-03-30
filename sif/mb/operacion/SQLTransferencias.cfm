<cfparam name="action" default="listaTransferencias.cfm">
<cfparam name="modo" default="ALTA">
<cfparam name="dmodo" default="ALTA">

<!--- Cuando estamos en modo cambio del Encabezado, si este tiene lineas de detalle, se desabiltan los combos
	  y se crean dos hiddens con el valor correspondiente, y aqui se asignan a los valores que procesa el sql, 
	  pues como los combos son disabled no se vienen con el submit
  --->
<cfif isdefined("form.ETperiodo1") and isdefined("form.ETmes1") >
	<cfset form.ETperiodo = form.ETperiodo1 >
	<cfset form.ETmes     = form.ETmes1 >
</cfif>

<!---  Se va a aplicar un documento?? --->
<cfif isdefined("form.btnAplicar") >
	<cfinvoke component="sif.Componentes.CP_MBPosteoTransferencias" method="PosteoTransferencias">
		<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
		<cfinvokeargument name="ETid" value="#form.ETid#"/>
		<cfinvokeargument name="usuario" value="#session.usucodigo#"/>	
		<cfinvokeargument name="LoginUsuario" value="#session.Usulogin#"/>		
		<cfinvokeargument name="debug" value="N"/>							
	</cfinvoke>			
	<cflocation addtoken="no" url="listaTransferencias.cfm">
</cfif>

<cfif not isdefined("form.btnNuevoD")>
	<cftry>
		<!--- Caso 1: Agregar Encabezado --->
		<cfif isdefined("Form.btnAgregarE")>
			<cftransaction>
				<cfset LvarETusuario = mid(session.usuario,1,30)>
				<cfset LvarETdescripcion = mid(form.ETdescripcion,1,255)>
				<cfset LvarEdocbase = mid(form.Edocbase,1,20)>
				
				<cfquery name="insert" datasource="#Session.DSN#">
					insert into ETraspasos( Ecodigo, ETperiodo, ETmes, ETusuario, ETdescripcion, ETfecha, Edocbase)
								 values ( <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#form.ETperiodo#"     cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#form.ETmes#"         cfsqltype="cf_sql_integer">, 
										  <cfqueryparam value="#LvarETusuario#"    cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#LvarETdescripcion#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#LSParseDateTime(form.ETfecha)#" cfsqltype="cf_sql_timestamp">,
										  <cfqueryparam value="#LvarEdocbase#" cfsqltype="cf_sql_varchar">
										)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			</cftransaction>

		<cfset modo="CAMBIO">
		<cfset action = "Transferencias.cfm">
				
		<!--- Caso 2: Borrar un Encabezado de Requisicion --->
		<cfelseif isdefined("Form.btnBorrarE")>
			<cfquery datasource="#Session.DSN#">
				delete from DTraspasos
				where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			</cfquery>				
			<cfquery  datasource="#Session.DSN#">
				delete from ETraspasos
				where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfset modo="ALTA">
				  
		<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
		<cfelseif isdefined("Form.btnAgregarD")>			
			<cfquery  datasource="#Session.DSN#">			  
			   insert into DTraspasos ( ETid, CBidori, CBiddest, BTidori, BTiddest, DTmontoori, DTmontodest, DTmontolocal, DTmontocomori,
							DTmontocomloc, DTdocumento, DTreferencia, DTtipocambio, DTtipocambiof, DTdocumentodest, DTreferenciadest) 
			   values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidori#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBiddest#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTidori#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BTiddest#">,
						<cfqueryparam cfsqltype="cf_sql_money"   value="#Replace(form.DTmontoori,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontodest,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontolocal,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontocomori,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontocomloc,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_char"    value="#form.DTdocumento#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTreferencia#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.DTtipocambio,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.DTtipocambiof,',','','all')#">,
                        <cfqueryparam cfsqltype="cf_sql_char"    value="#form.DTdocumentodest#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DTreferenciadest#">)
			</cfquery>
			
			<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->			
			<cf_dbtimestamp datasource="#session.dsn#"
					table="ETraspasos"
					redirect="Transferencias.cfm"
					timestamp="#form.ts_rversion#"
					field1="ETid" 
					type1="numeric" 
					value1="#form.ETid#"
					>
			
			<cfquery  datasource="#Session.DSN#">
				update ETraspasos
				set ETperiodo 	  = <cfqueryparam value="#form.ETperiodo#" 					cfsqltype="cf_sql_integer">,
					ETmes     	  = <cfqueryparam value="#form.ETmes#"     					cfsqltype="cf_sql_integer">,
					ETfecha   	  = <cfqueryparam value="#LSParseDateTime(form.ETfecha)#" 	cfsqltype="cf_sql_timestamp">,
					ETdescripcion = <cfqueryparam value="#form.ETdescripcion#"				cfsqltype="cf_sql_varchar">,
					Edocbase	  = <cfqueryparam value="#form.Edocbase#" 					cfsqltype="cf_sql_varchar">
				where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			  </cfquery>

			<cfset modo="CAMBIO">
			<cfset dmodo="ALTA">
			<cfset action = "Transferencias.cfm">

		<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
		<cfelseif isdefined("Form.btnCambiarD")>				
			<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
			<cf_dbtimestamp datasource="#session.dsn#"
					table="ETraspasos"
					redirect="Transferencias.cfm"
					timestamp="#form.ts_rversion#"
					field1="ETid" 
					type1="numeric" 
					value1="#form.ETid#"
					>
				
			<cfquery  datasource="#Session.DSN#">
				update ETraspasos
				set ETperiodo 	  = <cfqueryparam value="#form.ETperiodo#" 					cfsqltype="cf_sql_integer">,
					ETmes     	  = <cfqueryparam value="#form.ETmes#"     					cfsqltype="cf_sql_numeric">,
					ETfecha   	  = <cfqueryparam value="#LSParseDateTime(form.ETfecha)#" 	cfsqltype="cf_sql_timestamp">,
					ETdescripcion = <cfqueryparam value="#form.ETdescripcion#" 				cfsqltype="cf_sql_varchar">,
					Edocbase	  = <cfqueryparam value="#form.Edocbase#" 					cfsqltype="cf_sql_varchar">
				where ETid = <cfqueryparam value="#form.ETid#" cfsqltype="cf_sql_numeric">
			 </cfquery> 

			 
			 <cf_dbtimestamp datasource="#session.dsn#"
					table="DTraspasos"
					redirect="Transferencias.cfm"
					timestamp="#form.dtimestamp#"
					field1="DTid" 
					type1="numeric" 
					value1="#form.DTid#"
					>
			
			<cfquery  datasource="#Session.DSN#">
				update DTraspasos
				set  DTmontoori    = <cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontoori,',','','all')#">
					,DTmontodest   = <cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontodest,',','','all')#">
					,DTmontolocal  = <cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontolocal,',','','all')#">
					,DTmontocomori = <cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontocomori,',','','all')#">
					,DTmontocomloc = <cfqueryparam cfsqltype="cf_sql_money"  value="#Replace(form.DTmontocomloc,',','','all')#">       
					,DTdocumento   = <cfqueryparam cfsqltype="cf_sql_char"    value="#DTdocumento#">
					,DTreferencia  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DTreferencia#">
					,DTtipocambio  = <cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.DTtipocambio,',','','all')#">
					,DTtipocambiof = <cfqueryparam cfsqltype="cf_sql_float"   value="#Replace(form.DTtipocambiof,',','','all')#">	
                    ,DTdocumentodest   = <cfqueryparam cfsqltype="cf_sql_char"    value="#DTdocumentodest#">
					,DTreferenciadest  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DTreferenciadest#">
				where DTid   = <cfqueryparam value="#form.DTid#"     cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfset modo="CAMBIO">
			<cfset dmodo="CAMBIO">
			<cfset action = "Transferencias.cfm">

		<!--- Caso 5: Borrar detalle de Requisicion --->
		<cfelseif isdefined("Form.btnBorrarD")>
			<cfquery datasource="#Session.DSN#">
				delete from DTraspasos
				where DTid   = <cfqueryparam value="#form.DTid#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfset modo="CAMBIO">
			<cfset action = "Transferencias.cfm">

		</cfif>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "Transferencias.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>
	
<cfif isdefined("Form.btnAgregarE")>
	<cfset form.ETid = insert.identity >
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="ETid"   type="hidden" value="<cfif isdefined("Form.ETid")>#Form.ETid#</cfif>">
	<cfif dmodo neq 'ALTA'>
		<input name="dmodo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="DTid"  type="hidden" value="<cfif isdefined("Form.DTid")>#Form.DTid#</cfif>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>