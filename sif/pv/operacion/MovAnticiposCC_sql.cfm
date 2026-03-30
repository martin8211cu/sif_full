<!--- 
	Creado por Gustavo Fonseca H.
		Fecha: 16-1-2006.
		Motivo: Nuevo proceso de Movimiento de anticipos de PV a CxC.
 --->

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfset debug = false>
<cftransaction>
<cfloop list="#form.chk#" index="i" delimiters=",">
	<cfset ver = ListToArray(i,"|")> 
		<cfquery datasource="#session.DSN#">
			<!--- -- Aplicación del Adelanto /NC/otros --->
			insert into FAX016 
			(	Ecodigo, 
				CDCcodigo, 
				FAX16FEC, 
				FAX16MON, 
				FAM01COD, 
				FAX01NTR, 
				FAX16NDC, 
				FAX16TIP, 
				FAX16OBS, 
				FAX14CON, 
				fechaalta, 
				BMUsucodigo )
			
			select 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				CDCcodigo,
				FAX14FEC,
				round(FAX14MON - FAX14MAP, 2), 
				FAM01COD, 
				FAX01NTR, 
				FAX14DOC, 
				'NC', 
				'Mov. Ant. CC' #_Cat# ' Socio: ' #_Cat# <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">,
				FAX14CON, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from FAX014
			where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
				and CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<cfif Debug>
			<cfquery name="Debug1" datasource="#session.DSN#">
				select * from FAX016
				where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
					and CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			</cfquery>	
			<cfdump var="#Debug1#" label="Despu&eacute;s del insert. Tabla: FAX016">
		</cfif>

		<cfif Debug>
			<cfquery name="Debug2" datasource="#session.DSN#">
				select * from FAX014
				where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
					and CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			</cfquery>
			<cfdump var="#Debug2#" label="Antes del update. Tabla: FAX014">
		</cfif>
		

		<!--- Valida la cuenta --->
		<cfquery name="rsValidaCuenta" datasource="#session.DSN#">
			select (1) as valida
			from FAX014 a
				inner join  CFinanciera b
					on b.CFcuenta = a.CFcuenta
				inner join CContables c
					on c.Ccuenta = b.Ccuenta
			where a.FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
				and a.CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
		</cfquery>
		<cfif isdefined("rsValidaCuenta") and rsValidaCuenta.valida eq ''>
			<cf_errorCode	code = "50577"
							msg  = "No hay una cuenta válida para el documento."
							errorDat_1="#ver[1]#"
							errorDat_2="#ver[2]#"
							errorDat_3="#session.Ecodigo#"
			>
		</cfif>
		
		<cfquery name="rsVal" datasource="#session.DSN#">
			select 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				CDCcodigo,
				FAX14FEC,
				round(FAX14MON - FAX14MAP, 2), 
				FAM01COD, 
				FAX01NTR, 
				FAX14DOC, 
				'NC', 
				'Mov. Ant. CC' #_Cat# ' Socio: ' #_Cat# <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNnumero#">,
				FAX14CON, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			from FAX014
			where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
				and CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif isdefined("rsVal") and len(trim(rsVal.FAX14DOC)) and rsval.Recordcount eq 1>
			<cfquery name="rsValidaPagos" datasource="#session.DSN#">
				select (1) as valida
				from Pagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
					and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVal.FAX14DOC#">
			</cfquery>
			
			<cfif isdefined("rsValidaPagos") and rsValidaPagos.recordcount NEQ 0>
				<cf_errorCode	code = "50578"
								msg  = "El registro que intenta mover ya se encuentra registrado en la tabla de Pagos."
								errorDat_1="#rsVal.FAX14DOC#"
								errorDat_2="#form.CCTcodigo#"
								errorDat_3="#session.Ecodigo#"
				>
			</cfif>
			
		</cfif>
				
		<cfquery datasource="#session.DSN#">
			insert into Pagos 
				(
					Ecodigo, 
					CCTcodigo, 
					Pcodigo, 
					Ocodigo,
					Mcodigo,
					Ccuenta,  
					SNcodigo, 
					Ptipocambio, 
					Ptotal, 
					Pfecha, 
					Preferencia,
					Pobservaciones,
					Pusuario, 
					Seleccionado
				) 
				
				select 
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">, 
					a.FAX14DOC, 
					b.Ocodigo,
					a.Mcodigo,
					c.Ccuenta,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">, 
					1, <!--- Tipo de cambio --->
					round(a.FAX14MON - a.FAX14MAP, 2), 
					a.FAX14FEC,
					'NC', 
					'Movimiento de Anticipos a Cuentas por Cobrar',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
					0 <!--- Seleccionado (0 no, 1 si) --->
				
				from FAX014 a
					inner join FAM001 b
						on b.FAM01COD = a.FAM01COD
					inner join  CFinanciera c
						on c.CFcuenta = a.CFcuenta
				where a.FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
					and a.CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		
		<!--- Actualización de la tabla de adelantos de Notas de Crédito --->
		<cfquery datasource="#session.DSN#">
			update FAX014
			set FAX14MAP = FAX14MON, 	<!--- Se actualiza el monto aplicado del adelanto con el monto del mismo --->
			FAX14STS = '2' 				<!--- 1. Activo 2.Terminado 3. Anulado --->
			where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
				and CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
		</cfquery>
		
		<cfif Debug>
			<cfquery name="Debug3" datasource="#session.DSN#">
				select * from FAX014
				where FAX14CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#ver[1]#"> 
					and CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#ver[2]#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			</cfquery>	
			<cfdump var="#Debug3#" label="Despu&eacute;s del update. Tabla: FAX014">
		</cfif>
		<cfif Debug>
			<cfthrow  message="Debug">
		</cfif>
		<cfset ver = ""> 
</cfloop>
</cftransaction> 

<cflocation addtoken="no" url="MovAnticiposCC.cfm">

