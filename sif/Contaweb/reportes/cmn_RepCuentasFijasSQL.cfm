<!---************************ --->
<!---** AREA DE VARIABLES  ** --->
<!---************************ --->
<cfset modo = "ALTA">
<!---*********************************** --->
<!---** VARIFICACION DE CAMPOS Y ABC  ** --->
<!---*********************************** --->
<cfif not isdefined("form.Nuevo")>
	<cftry>
<!---******************************************************************************************* --->
<!---** 											ALTA 									  ** --->
<!---******************************************************************************************* --->
		<cfif isdefined("form.Alta") >
			<cfquery datasource="#session.Conta.dsn#"  name="sql" >
	
				INSERT CGC003(CGM1IM,CGC3TPOA,CGC3SEG)
				VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGM1IM#" >,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CGC3TPOA#" >,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LIST_SEGMENTO#" >
				)
			</cfquery>						
<!---******************************************************************************************* --->
<!---** 											CAMBIO 									  ** --->
<!---******************************************************************************************* --->
		<cfelseif isdefined("form.Cambio")>
			<cfquery datasource="#session.Conta.dsn#"  name="sql" >
				UPDATE CGC003 SET 
				CGC3SEG =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.LIST_SEGMENTO#" >
				where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CGM1IM#" >
				AND   CGC3TPOA = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CGC3TPOA#">
				AND   timestamp = convert(varbinary,#lcase(Form.timestamp)#)
			</cfquery>	
			<cfset modo = "CAMBIO">
<!---******************************************************************************************* --->
<!---** 											BAJA 									  ** --->
<!---******************************************************************************************* --->
		<cfelseif isdefined("form.Baja")>
			<cfquery datasource="#session.Conta.dsn#"  name="sql" >
				DELETE CGC003 
				where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CGM1IM#" >
				AND   CGC3TPOA = <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.CGC3TPOA#">
			</cfquery>
<!---******************************************************************************************* --->
<!---** 											Generar									  ** --->
<!---******************************************************************************************* --->
		<cfelseif isdefined("form.Generar")>
			
			<cfset diferencia = datediff("d",LSdateformat(Now(),"mm/dd/yyyy"), LSdateformat(Fechaejec,"mm/dd/yyyy"))>
			
			<cfif diferencia lt 0>
					<!--- Si la fecha es inferior al dia de hoy se pone la fecha de hoy --->
					<cfset Fechaejec = LSdateformat(Now(),"dd/mm/yyyy")>
			</cfif>

			<!--- Si es un fin de semana no se valida --->
			<cfset diasem = dayofweek(Fechaejec)>
			<cfif diasem neq 7 and  diasem neq 1>
			

				<cfset diferencia = datediff("d",LSdateformat(Now(),"mm/dd/yyyy"), LSdateformat(Fechaejec,"mm/dd/yyyy"))>	
								
				<cfif diferencia eq 0>
						<!--- Si es la fecha es la de hoy y la hora de ejecucion ya pasó --->
						<cfset syshora = hour(Now())>
						<cfset sysminuto = minute(Now())>
						
						<cfif hora eq 12><cfset hora = 0></cfif>
						<cfif tiempo eq "PM">
							<cfset aplhora = 12 + val(hora)>
						<cfelse>
							<cfset aplhora = val(hora)>
						</cfif>
						<cfset aplminuto = val(min)>
						
						<cfif syshora eq aplhora>
							<!--- compara minutos --->
							<cfif sysminuto gt aplminuto>								
								<cfset msgerror = "La fecha de ejecucion es inválida para el día de hoy, ya que es menor a la hora actual">
							</cfif>
						<cfelse>
							<cfif syshora gt aplhora>
								<cfset msgerror = "La fecha de ejecucion es inválida para el día de hoy, ya que es menor a la hora actual">					
							</cfif>
						</cfif>
						
						<cfif isdefined("msgerror") and len(msgerror) gt 0>
	
							<script>
							var  mensaje = '<cfoutput>#msgerror#</cfoutput>'
							alert(mensaje)
							history.back()				
							</script>
							<cfabort>		
							
						</cfif>

				</cfif>			
			
		
				<cfset error=0>
				<cfif hora eq 12><cfset hora = 0></cfif>
				<cfif tiempo eq "PM">
									
					<cfset hora = 12 + hora>
					<cfif Val(hora) gte 20 and Val(hora) lte 24>
						<cfset error=0>
					<cfelse>
						<cfset error=1>
					</cfif>
				</cfif>
				
				<cfif tiempo eq "AM">
					
					<cfif Val(hora) gte 0 and Val(hora) lte 5>
						
						<cfif Val(hora) eq 5>
						
							<cfif Val(min) gt 0>							
								<cfset error=1>
							</cfif>
						
						</cfif>
						
					<cfelse>
						<cfset error=1>
					</cfif>
				</cfif>			
				
				<cfif error eq 1>
					<script>
					var  mensaje = "El horario que usted eligió es incorrecto. Recuerde que solamente \n es válido generar el reporte de 08:00 PM a 05:00 AM"
					alert(mensaje)
					history.back()				
					</script>
					<cfabort>
				</cfif>
				
			</cfif>
						
			<cfquery name="rsParametros" datasource="#session.Conta.dsn#">
				select   CGPMES ,CGPANO  from CGX001  
			</cfquery>
			
			<cfquery datasource="#session.Conta.dsn#"  name="RScuentas" >	
				select  CGM1IM,CGC3TPOA,CGC3SEG,
				case CGC3TPOA
					 when  1 then 'SALACU_'+CGM1IM
					 when  2 then 'SALPER_'+CGM1IM
					 when  3 then 'MOVMES_'+CGM1IM
					 when  4 then 'MOVASM_'+CGM1IM
					 when  5 then 'MOVASC_'+CGM1IM
				end as ARCHIVO
				from CGC003 
				order by CGM1IM,CGC3TPOA
			</cfquery>	
			  <!--- <cf_dump var="#RScuentas#"> --->
			  <cfloop query="RScuentas">
				<cfquery datasource="#session.Conta.dsn#"  name="StrCuentas">
					select   '¶0¶-¶'  || convert(varchar,count(b.CG15ID))  || '¶1'  AS CUENTA
					from CGM001 a
					inner join CGM016 b
					on b.CG15ID = a.CG15ID
					where a.CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#RScuentas.CGM1IM#">
					and a.CGM1CD is null   
				</cfquery>
				<!--- <cfset segmentos = RScuentas.CGC3SEG> --->
				
				<cfset arreglo = listtoarray(RScuentas.CGC3SEG,",")>	
				<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
				   <cfset segmentos  = "'" & arreglo[i] & "'"> 
					<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
						insert  tbl_archivoscf (usuario,fechasolic,periodo,mesini,mesfin,fechaejec,horaejecuta,minejecuta,tpoarch,origen,status,listcuenta,nivel,listsegmento,nombrearc,BorrarArch)
						values (
							<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.usuario)#">,
							getdate(),
							<cfqueryparam  cfsqltype="cf_sql_integer"   value="#rsParametros.CGPANO#">,
							<cfqueryparam  cfsqltype="cf_sql_integer"   value="#rsParametros.CGPMES#">,
							<cfqueryparam  cfsqltype="cf_sql_integer"   value="#rsParametros.CGPMES#">,
							'#LSdateformat(Fechaejec,"yyyymmdd")#' <!--- dateadd(dd, 1, getdate()) --->,
							<cfqueryparam cfsqltype="cf_sql_integer"  value="#Val(hora)#">,
							<cfqueryparam cfsqltype="cf_sql_integer"  value="#Val(min)#">,
							<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(RScuentas.CGC3TPOA)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="L">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="P">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#RScuentas.CGM1IM##trim(StrCuentas.CUENTA)#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(segmentos)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsParametros.CGPANO#-#rsParametros.CGPMES#-#trim(RScuentas.ARCHIVO)#-#arreglo[i]#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"  value="S">
						)
					</cfquery>
			 </cfloop>
			 </cfloop> 
		</cfif>
	<cfcatch type="any">

		<script language="JavaScript">
		   var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
		   mensaje = mensaje.substring(40,300)
		   alert(mensaje)
		   history.back()
		</script> 		
		<cfabort>
	</cfcatch>
	</cftry>	
<!---******************************************************************************************* --->	
<cfelse>
	<cflocation url="cmn_RepCuentasFijas.cfm?modo=#modo#">
</cfif>
<!---************************ --->
<!---** STATUS DE RETORNO  ** --->
<!---************************ --->
<cfif modo eq "CAMBIO">
	<cflocation url="cmn_RepCuentasFijas.cfm?modo=#modo#&CGM1IM=#form.CGM1IM#&CGC3TPOA=#form.CGC3TPOA#">
<cfelse>
	<cflocation url="cmn_RepCuentasFijas.cfm?modo=#modo#">
</cfif>


 