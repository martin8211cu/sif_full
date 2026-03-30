
<cfset session.DSN="minisif">
<cfset session.Usucodigo=999999> 

<!--- Gerenardo por la Tarea en forma Automatico --->

<cfset start = Now()>
<cfoutput>
	<strong>Proceso Excepción Contable por Centro Funcional</strong><br>
	<strong>Iniciando proceso</strong> #TimeFormat(start,"HH:MM:SS")#<br>
</cfoutput>


<!---***************************************************************************************--->

<cfquery name="rsPurdyCF" datasource="#session.DSN#">
	select * from PurdyCF
</cfquery>

<cfif (rsPurdyCF.recordcount NEQ 0)>
	<cfquery datasource="#session.DSN#">
		delete CFExcepcionCuenta
		where InterfazPM > 0
	</cfquery>
	
	<cfset Formato = "">
	<cfset FCuenta = "">
	<cfset Valor2  = "">
	
	<cfloop query="rsPurdyCF">
		<cfset paso = "NO Aplicado">
		<cfquery name="rsCFuncional" datasource="#session.DSN#">
			select CFid, CFcodigo,CFcuentac 
			from CFuncional
			where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPurdyCF.Ecodigo#">
			and CFcodigo = '#rsPurdyCF.CFcodigo#'
		</cfquery>
		
		<cfif (rsCFuncional.recordcount NEQ 0)>
			<cfset Formato2 = listtoarray("#rsPurdyCF.Formato#","-")>
			<cfset Mayor = ''>
			
			<cfswitch expression="#len(Formato2[1])#">
				<cfcase value="1"> <cfset Mayor = "000" & '#Formato2[1]#'> </cfcase>
				<cfcase value="2"> <cfset Mayor = '00' & '#Formato2[1]#'> </cfcase>
				<cfcase value="3"> <cfset Mayor = '0' & '#Formato2[1]#'> </cfcase>
				<cfcase value="4"> <cfset Mayor = '#Formato2[1]#'> </cfcase>
				<cfdefaultcase>    </cfdefaultcase>
			</cfswitch>
		
			<cfset cuenta = Mayor>
			<cfloop from="2" to ="#arraylen(Formato2)#" index="i">
					<cfset cuenta = cuenta & '-' & '#Formato2[i]#'>
			</cfloop>
			
			<cfset cadena = rsCFuncional.CFcuentac>
			<cfset obgasto = ''>
			
			<cfloop from="1" to = "#len(trim(rsCFuncional.CFcuentac))#" index="i">
				<cfset pos = Find('?', #cadena#,i)>
				<cfif pos EQ 0>
					<cfbreak> 
				</cfif>
				<cfset obgasto  = obgasto & Mid('#cuenta#', #pos#, 1)>
				<cfset x  = Mid('#cuenta#', #pos#, 1)>
				<cfset cadena = Replace('#cadena#','?',	'#x#',1)>
				<cfif ((pos EQ "#len(trim(rsCFuncional.CFcuentac))#") or (pos EQ 0)) >
					<cfbreak> 
				</cfif>
			</cfloop>
			<cfloop from="1" to = "#len(trim(obgasto))#" index="i">
				<cfset Valor2 = Valor2 & '?'>
			</cfloop>
			
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select 1
				from CFExcepcionCuenta
				where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.CFid#">
				  and valor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#obgasto#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPurdyCF.Ecodigo#">
			</cfquery>
			<cfif (rsExiste.recordcount eq 0) and (#cuenta# EQ #cadena#)>
				<cfquery datasource="#session.DSN#">
					insert into CFExcepcionCuenta( CFid, valor1, valor2, Ecodigo, BMusucodigo, BMfechaalta,InterfazPM )
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFuncional.CFid#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#obgasto#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Valor2#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPurdyCF.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPurdyCF.InterfazPM#">)
				</cfquery>
				<cfset paso = "Aplicado">
			<cfelse>
				<cfset paso = "NO Aplicado">
			</cfif>	
			<cfset Valor2 = ''>
		<cfelse>
			<cfoutput>Empresa: #rsPurdyCF.Ecodigo# - Resultado: #paso# - Centro Funcional Tabla de Paso: #rsPurdyCF.CFcodigo# - Cuenta: #rsPurdyCF.Formato# <br></cfoutput>
		</cfif>
	</cfloop>
<cfelse>
	<cfoutput>* * * No hay datos para aplicar * * * <br></cfoutput>
</cfif>
<cfoutput>
	<cfset finish = Now()>
	<strong>Proceso terminado</strong> #TimeFormat(finish,"HH:MM:SS")#<br>
	<strong>* * * Proceso Concluido * * *</strong>
</cfoutput>