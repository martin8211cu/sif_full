<cfset start = Now()>
<cfoutput>
	<strong>Proceso Valida Cuentas</strong><br>
	<strong>Iniciando proceso</strong> #TimeFormat(start,"HH:MM:SS")#<br>
</cfoutput>

<cfset session.DSN="minisif">
<!---<cfset session.Ecodigo="1">--->

<cfsetting requesttimeout="8600">
<cfset annomesdesde = #datepart('yyyy', Now())# & #datepart('m', Now())#>	

<!-----------------------------------------------
CTIPO = A - P - C - I - G - O                    
*Activo, Pasivo, Capital, Ingreso, Gasto, Orden *
------------------------------------------------>

<!---cargo las cuentas que voy a vericar--->
<!---ESTA PARTE ES PARA GERNERACION MANUAL--->
<!---

<cfquery name="rsTemporal" datasource="#session.DSN#">
	Select distinct  a.Ecodigo,
				a.Cdescripcion,
				a.Cbalancen as Cbalance ,
				a.Cformato,
				b.Ctipo
	from CContables a, CtasMayor b
		where a.Cmovimiento = 'S'
		and a.Ecodigo = 1
		and a.Cmayor = b.Cmayor
		and a.Cmayor='0002'
</cfquery>

--->

<!---carga las cuentas que voy a revizar--->
<cfquery name="rsTemporal" datasource="#session.DSN#">
	select * from PurdyCC
</cfquery>


<cfif (rsTemporal.recordcount NEQ 0)>
	<!---Lee el Formato de cuentas contables--->
	<cfquery name="rsFormato" datasource="#session.DSN#">
		select Pvalor 
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
				and Pcodigo = 10
	</cfquery>
	<cfset Formato = "">
	<cfset FCuenta = "">

	<cftransaction action="begin">	
		<cfloop query="rsTemporal">
		
			<cfset Mascara = ''>
			<cfset FechaHasta = Createdate('6100','01','01')>
			<cfset descripcion = '* NGS * - ' & '#rsTemporal.Cdescripcion#'>
			
			<cfset Formato = listtoarray("#rsTemporal.CFormato#","-")>
			<cfset Mayor = ''>
			<cfswitch expression="#len(ltrim(rtrim(Formato[1])))#">
				<cfcase value="1"> <cfset Mayor = "000" & '#Formato[1]#'> </cfcase>
				<cfcase value="2"> <cfset Mayor = '00' & '#Formato[1]#'> </cfcase>
				<cfcase value="3"> <cfset Mayor = '0' & '#Formato[1]#'> </cfcase>
				<cfcase value="4"> <cfset Mayor = '#Formato[1]#'> </cfcase>
				<cfdefaultcase>    </cfdefaultcase>
			</cfswitch>
			
			
			<cfset Mayor= Ltrim(Rtrim(Mayor))>
			<cfquery name="rsCtasMayor" datasource="#session.DSN#">
				select * from CtasMayor
				where ltrim(Cmayor) like '#Mayor#'
				and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
			</cfquery>

			<cfif isdefined("rsCtasMayor") and rsCtasMayor.RecordCount eq 0>
					<cfquery datasource="#session.DSN#">
						insert into CtasMayor (
								Ecodigo,
								Cmayor,
								Cdescripcion,
								Ctipo,
								Cbalancen,
								Cmascara
								)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">, 
								'#Mayor#',
								'#descripcion#',
								'#rsTemporal.Ctipo#',
								'#rsTemporal.CBalance#',
								'#rsFormato.Pvalor#'
								)
					</cfquery>
				</cfif>
				<cfquery name="rsCPVigen" datasource="#session.DSN#">
					select * from CPVigencia
					where ltrim(Cmayor) like '#Mayor#'
					and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
				</cfquery>
				<cfif  isdefined("rsCPVigen") and rsCPVigen.RecordCount eq 0>												
					<cfquery datasource="#session.DSN#">		
						insert into CPVigencia (
								Ecodigo,
								Cmayor,
								CPVdesde,
								CPVdesdeAnoMes,
								CPVhasta,
								CPVhastaAnoMes,
								CPVformatoF
								)
							values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">,
								'#Mayor#',
								<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
								#annomesdesde#,
								#FechaHasta#,
								600001,
								'#rsFormato.Pvalor#'
								)
					</cfquery>
				</cfif>
				 
				<cfquery name="rsCPVigencia" datasource="#session.DSN#">
					select * from CPVigencia
					where ltrim(Cmayor) like '#Mayor#'
					and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
				</cfquery>
				<cfset cuenta = Mayor>			

				<cfloop from="1" to ="#arraylen(Formato)#" index="i">
					<cfif i GT 1>
						<cfquery name="rsCcuenta" datasource="#session.DSN#">
							select Ccuenta from CContables
							where ltrim(Cformato) like '#cuenta#'
							and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
						<cfquery name="rsCFcuenta" datasource="#session.DSN#">
							select CFcuenta from CFinanciera
							where ltrim(CFformato) like '#cuenta#'
							and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
						<cfset cuenta = cuenta & '-' & ltrim(rtrim('#Formato[i]#'))>
					<cfelse>
						<cfquery name="rsCcuenta" datasource="#session.DSN#">
							select Ccuenta from CContables
							where ltrim(Cformato) like '#cuenta#'
							and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
						<cfquery name="rsCFcuenta" datasource="#session.DSN#">
							select CFcuenta from CFinanciera
							where ltrim(CFformato) like '#cuenta#'
							and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
					</cfif>
					<cfquery name="rsCFinanciera" datasource="#session.DSN#">
						select * from CFinanciera
						where ltrim(CFformato) like '#cuenta#'
						and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
					</cfquery>
	
					<cfquery name="rsCContables" datasource="#session.DSN#">
						select * from CContables
						where ltrim(Cformato) like '#cuenta#'
						and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
					</cfquery>
									
					<cfif isdefined("rsCContables") and rsCContables.RecordCount eq 0>
						<cfquery datasource="#session.DSN#">	
							insert into CContables (
									Ecodigo,
									Cmayor,
									Cformato,
									Cdescripcion,
									Cmovimiento,
									Cbalancen,
									Cbalancenormal,
									Cpadre
									)
								values (
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">,
									'#Mayor#',
									'#cuenta#',
									'#descripcion#',
									<!---'#rsTemporal.Cdescripcion#',--->
									<cfif i NEQ "#arraylen(Formato)#"> 'N' <cfelse> 'S'</cfif>,
									'#rsTemporal.Cbalance#',
									<cfif '#rsTemporal.Cbalance#' EQ 'D'> 1 <cfelse> -1</cfif>,
									<cfif isdefined('rsCcuenta')AND #cuenta# NEQ #mayor#>
											#rsCcuenta.Ccuenta#
									<cfelse> null </cfif>
									)
						</cfquery>
					<cfelse>
						<cfquery datasource="#session.DSN#">
							update 	CContables set Cpadre = 
									<cfif isdefined('rsCcuenta')AND #cuenta# NEQ #mayor#>
											#rsCcuenta.Ccuenta#
									<cfelse> null </cfif>
								where Cformato like '#cuenta#'
								and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
					</cfif>	
					
					<cfquery name="rsCContables" datasource="#session.DSN#">
						select * from CContables
						where ltrim(Cformato) like '#cuenta#'
						and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
					</cfquery>
					<cfif isdefined("rsCFinanciera") and rsCFinanciera.RecordCount eq 0>
						<cfquery datasource="#session.DSN#">	
							insert into CFinanciera (
									CPVid,
									Ecodigo,
									Cmayor,
									CFformato,
									CFdescripcion,
									CFmovimiento,
									Ccuenta,
									CFpadre
									)
								values (
									#rsCPVigencia.CPVid#,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">,
									'#Mayor#',
									'#cuenta#',
									'#descripcion#',
									<!---'#rsTemporal.Cdescripcion#',--->
									<cfif i NEQ "#arraylen(Formato)#"> 'N' <cfelse> 'S'</cfif>,
									<cfif isdefined('rsCcuenta') AND #cuenta# NEQ #mayor#> 
										#rsCcuenta.Ccuenta#,
									<cfelse> #rsCContables.Ccuenta#, </cfif>
									<cfif isdefined('rsCFcuenta') AND #cuenta# NEQ #mayor#> 
											#rsCFcuenta.CFcuenta# 
									<cfelse> null </cfif>
									)
						</cfquery>
						<cfelse>
						<cfquery datasource="#session.DSN#">
							update 	CFinanciera set CFpadre = 
									<cfif isdefined('rsCFcuenta')AND #cuenta# NEQ #mayor#> 
											#rsCFcuenta.CFcuenta# 
									<cfelse> null </cfif>,
									Ccuenta = #rsCContables.Ccuenta#
								where ltrim(CFformato) like '#cuenta#'
								and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						</cfquery>
					</cfif>
				</cfloop>
				
	<!--- BORRA LAS CUENTAS QUE YA AN SIDO CREADAS --->

			<cfquery datasource="#session.DSN#">
				delete from PurdyCC
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and Cdescripcion = '#rsTemporal.Cdescripcion#'
						and CBalance = '#rsTemporal.Cbalance#'
						and	CFormato = '#rsTemporal.CFormato#'
						and Ctipo = '#rsTemporal.Ctipo#'
			</cfquery>

		</cfloop>
			
			<cfquery name="ActualizaMov" datasource="#session.DSN#">	
				update CContables
					set Cmovimiento='S'
					Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and not exists (Select 1 from CContables b
						  where CContables.Ccuenta = b.Cpadre)
			</cfquery>	
			
			<cfquery name="ActualizaMov" datasource="#session.DSN#">				
				update CContables
					set Cmovimiento='N'
					Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and exists (Select 1 from CContables b
						  where CContables.Ccuenta = b.Cpadre) 
			</cfquery>
			
			<cfquery name="ActualizaMov" datasource="#session.DSN#">				
				update CFinanciera
					set CFmovimiento='S'
					Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and not exists (Select 1 from CFinanciera b
						  where CFinanciera.CFcuenta = b.CFpadre)
			</cfquery>			
			
			<cfquery name="ActualizaMov" datasource="#session.DSN#">							
				update CFinanciera
					set CFmovimiento='N'
					Where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and exists (Select 1 from CFinanciera b
						  where CFinanciera.CFcuenta = b.CFpadre)		
			</cfquery>
	
<!---			
			<cfquery name="rsCPVigencia" datasource="#session.DSN#">	
				Select * from CPVigencia
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
					and Cmayor = '#mayor#'
			</cfquery>
			
			<cfquery name="rsCtasMayor" datasource="#session.DSN#">	
				select * from CtasMayor
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
					and Cmayor = '#mayor#'
			</cfquery>
			
			<cfquery name="rsCContables" datasource="#session.DSN#">	
				select Ccuenta, Cpadre, Cmayor, Cformato, Cdescripcion, Cmovimiento,  Cbalancen, Cbalancenormal
					from CContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and Cmayor = '#mayor#'
					order by Cformato
			</cfquery>
			
			<cfquery name="rsCFinanciera" datasource="#session.DSN#">	
				select CFcuenta, Cmayor, CFformato, CFpadre, CFmovimiento, CFdescripcion
					from CFinanciera
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsTemporal.Ecodigo#">
						and Cmayor = '#mayor#'
					order by CFformato
			</cfquery>		

			rsCPVigencia	
			<cfdump var="#rsCPVigencia#">
			rsCtasMayor
			<cfdump var="#rsCtasMayor#">
			rsCContables
			<cfdump var="#rsCContables#">
			rsCFinanciera
			<cfdump var="#rsCFinanciera#">
--->
	
		<!---<cftransaction action="rollback">	--->
	</cftransaction>
<cfelse>
	<cfoutput>* * * No hay datos para aplicar * * * <br></cfoutput>
</cfif>
<cfset finish = Now()>
<cfoutput>
	<strong>Proceso Valida Cuentas</strong><br>
	<strong>Iniciando proceso</strong> #TimeFormat(finish,"HH:MM:SS")#<br>
	<strong>* * * Proceso Concluido * * *</strong><br>
</cfoutput>




