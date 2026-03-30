<!--- Si el combo de requisición viene con -1 es que es vació --->
<cfif isDefined("Form.TipoRequisicion") and Compare(Trim(Form.TipoRequisicion),"-1") EQ 0>
	<cfset Form.TipoRequisicion = "">
</cfif>

<cfif isDefined("Form.Aceptar")>

	<!--- Inserta un registro en la tabla de Parámetros --->
	<cffunction name="insertCuenta" >		
		<cfargument name="pcodigo"      type="numeric" required="true">
		<cfargument name="mcodigo"      type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor"       type="string" required="true">			
		<cfquery name="insCuenta" datasource="#Session.DSN#">
		set nocount on
			if not exists (select 1 
						from Parametros 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">) 
				begin
					insert Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
					values (
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
						)
				end
				else begin
					update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
				end
		set nocount off							
		</cfquery>			
		<cfreturn true>
	</cffunction>
	
	<!--- Actualiza la cuenta contable según el pcodigo --->
	<cffunction name="updateCuenta" >					
		<cfargument name="pcodigo" type="numeric" required="true">
		<cfargument name="pvalor" type="string" required="true">			
		<cfquery name="updCuenta" datasource="#Session.DSN#">
		set nocount on
			update Parametros set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
		set nocount off
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cftransaction>
	<cftry>		
		<cfquery name="ParametrosCuentasCG" datasource="#Session.DSN#">
			set nocount on
			<cfif isDefined("Form.hayVencimiento1") and Len(Trim(hayVencimiento1)) GT 0>
				<cfif Form.hayVencimiento1 EQ "1">
					<cfset a = updateCuenta(310,Form.vencimiento1)>
 				<cfelseif Form.hayVencimiento1 EQ "0">
					<cfset b = insertCuenta(310,'GN','Primer Vencimiento en Días',Form.vencimiento1)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento2") and Len(Trim(hayVencimiento2)) GT 0>
				<cfif Form.hayVencimiento2 EQ "1">
					<cfset a = updateCuenta(320,Form.vencimiento2)>
 				<cfelseif Form.hayVencimiento2 EQ "0">
					<cfset b = insertCuenta(320,'GN','Segundo Vencimiento en Días',Form.vencimiento2)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento3") and Len(Trim(hayVencimiento3)) GT 0>
				<cfif Form.hayVencimiento3 EQ "1">
					<cfset a = updateCuenta(330,Form.vencimiento3)>
 				<cfelseif Form.hayVencimiento3 EQ "0">
					<cfset b = insertCuenta(330,'GN','Tercer Vencimiento en Días',Form.vencimiento3)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayVencimiento4") and Len(Trim(hayVencimiento4)) GT 0>
				<cfif Form.hayVencimiento4 EQ "1">
					<cfset a = updateCuenta(340,Form.vencimiento4)>
 				<cfelseif Form.hayVencimiento4 EQ "0">
					<cfset b = insertCuenta(340,'GN','Cuarto Vencimiento en Días',Form.vencimiento4)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayTipoRequisicion") and Len(Trim(hayTipoRequisicion)) GT 0>
				<cfif Form.hayTipoRequisicion EQ "1">
					<cfset a = updateCuenta(360,Form.TipoRequisicion)>
 				<cfelseif Form.hayTipoRequisicion EQ "0" and Len(Trim(Form.TipoRequisicion)) GT 0>
					<cfset b = insertCuenta(360,'IV','Requisición Default',Form.TipoRequisicion)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.haySolicitante") and Len(Trim(haySolicitante)) GT 0>
				<cfif Form.haySolicitante EQ "1">
					<cfset a = updateCuenta(370,Form.CMSid)>
 				<cfelseif Form.haySolicitante EQ "0" >
					<cfset b = insertCuenta(370,'IV','Solicitante Default',Form.CMSid)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.hayAutorizacion") and Len(Trim(form.hayAutorizacion)) GT 0>
				<cfif isdefined("form.chkAutorizar")>
					<cfset valor = '1'>
				<cfelse>
					<cfset valor = '0'>
				</cfif>
				<cfif form.hayAutorizacion EQ "1">
					<cfset a = updateCuenta(410,valor)>
 				<cfelseif Form.hayAutorizacion EQ "0">
					<cfset b = insertCuenta(410,'CM','Requiere aprobación de Solicitudes de Compra',valor)>
				</cfif>
			</cfif>

			<cfif isDefined("Form.haycalculoImp") and Len(Trim(haycalculoImp)) GT 0>
				<cfif Form.haycalculoImp EQ "1">
					<cfset a = updateCuenta(420,Form.calculoImp)>
 				<cfelseif Form.haycalculoImp EQ "0" >
					<cfset b = insertCuenta(420,'FA','Forma de Cálculo de Impuesto (0: Desc/Imp, 1: Imp/Desc.)',Form.calculoImp)>
				</cfif>
			</cfif>
			
			<cfif isDefined("Form.haySupervisor") and Len(Trim(form.haySupervisor)) GT 0>
				<cfif form.haySupervisor EQ "1">
					<cfset a = updateCuenta(430,Form.FASupervisor)>
 				<cfelseif Form.haySupervisor EQ "0">
					<cfset b = insertCuenta(430,'FA','Supervisor de Cierre de Cajas',Form.FASupervisor)>
				</cfif>
			</cfif>

 			select 1
			set nocount off
		</cfquery>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<form action="ParametrosAuxiliaresAD.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
