<!--- Parametros Iniciales --->
<cfset params = "">
<cfif isdefined("form.PERCOD") and len(form.PERCOD)>
	<cfif params eq "">
		<cfset params="PERCOD=#form.PERCOD#">
	<cfelse>
		<cfset params=params & "&PERCOD=#form.PERCOD#">
	</cfif>
</cfif>

<cfif isdefined("form.MESCODI") and len(form.MESCODI)>
	<cfif params eq "">
		<cfset params="MESCODI=#form.MESCODI#">
	<cfelse>
		<cfset params=params & "&MESCODI=#form.MESCODI#">
	</cfif>
</cfif>

<cfif isdefined("form.MESCODF") and len(form.MESCODF)>
	<cfif params eq "">
		<cfset params="MESCODF=#form.MESCODF#">
	<cfelse>
		<cfset params=params & "&MESCODF=#form.MESCODF#">
	</cfif>
</cfif>
	
<cfif isdefined("form.CJX12IRC") and len(form.CJX12IRC)>
	<cfif params eq "">
		<cfset params="CJX12IRC=#form.CJX12IRC#">
	<cfelse>
		<cfset params=params & "&CJX12IRC=#form.CJX12IRC#">
	</cfif>
	
	<cfif form.CJX12IRC eq 0>
		<cfset Msgloc = "Recibieron">
	<cfelse>
		<cfset Msgloc = "Rechazaron">
	</cfif>
	
</cfif>
		
<cfif isdefined("form.DIA_RETRAZO") and len(form.DIA_RETRAZO)>
	<cfif params eq "">
		<cfset params="DIA_RETRAZO=#form.DIA_RETRAZO#">
	<cfelse>
		<cfset params=params & "&DIA_RETRAZO=#form.DIA_RETRAZO#">
	</cfif>
</cfif>	
	
<cfif isdefined("form.ORDENAR") and len(form.ORDENAR)>
	<cfif params eq "">
		<cfset params="ORDENAR=#form.ORDENAR#">
	<cfelse>
		<cfset params=params & "&ORDENAR=#form.ORDENAR#">
	</cfif>
</cfif>	

<cfif isdefined("form.CANTIDAD") and len(form.CANTIDAD)>
	<cfif params eq "">
		<cfset params="CANTIDAD=#form.CANTIDAD#">
	<cfelse>
		<cfset params=params & "&CANTIDAD=#form.CANTIDAD#">
	</cfif>
</cfif>		

<cfif isdefined("form.chk") >
	
	<cfloop list="#form.chk#" delimiters="," index="idx" >
	
		<cfset cuenta=1>
		<cfloop list="#idx#" delimiters="|" index="idx1" >
			<cfswitch expression="#cuenta#">
				<cfcase value="1">
					<cfset tipo = #idx1#>
				</cfcase>
				<cfcase value="2">
					<cfset tarjeta = #idx1#>
				</cfcase>
				<cfcase value="3">
					<cfset autorizacion = #idx1#>
				</cfcase>
				<cfcase value="4">
					<cfset fecha = #idx1#>
				</cfcase>
				<cfcase value="5">
					<cfset periodo = #idx1#>
				</cfcase>
				<cfcase value="6">
					<cfset mes = #idx1#>
				</cfcase>															
			</cfswitch>
			<cfset cuenta = cuenta + 1>
		</cfloop>
		
		<cfset Vvalor = 0>	
		<cfif form.CJX12IRC neq 1>
			<cfset Vvalor = 1>
		</cfif>
		
		<cfquery datasource="#session.fondos.dsn#" name="Fmtfecha">
			Select str_replace(convert(varchar,convert(datetime,(substring('#fecha#',4,2) + '/' + substring('#fecha#',1,2) + '/' + substring('#fecha#',7,4))),109),':000AM','AM') as Fecha
		</cfquery>		
		<cfset FechaFinal = #Fmtfecha.Fecha#>
				
		<cfif not isdefined("form.CJX12IRC") or ( isdefined("form.CJX12IRC") and len(trim(form.CJX12IRC)) neq 0 and form.CJX12IRC eq 0)>
			<!--- Actualiza los registros recibidos. --->
			<cfquery datasource="#session.Fondos.dsn#" name="Upd">
				Update CJX012
				set CJX12IRC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Vvalor#">,
					CJX12FRC = getDate(),          
					CJX12URC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
				where PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
				  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
				  and TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo#">
				  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tarjeta#">
				  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#autorizacion#">
				  and CJX12FEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FechaFinal#">
			</cfquery>
			
		<cfelse>
			<!--- Consulta si el registro esta conciliado. --->
			<cfquery datasource="#session.fondos.dsn#" name="rsConciliado">
				select 1 
				from CJX012 
				where PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
				  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
				  and TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo#">
				  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tarjeta#">
				  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#autorizacion#">
				  and CJX12FEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FechaFinal#">
				  and CJX12IND != 'S'
				  and CJX00NGC is null		
			</cfquery>
			
			<!--- Actualiza los registros sin conciliar para rechazar --->
			<cfif isdefined("rsConciliado") and rsConciliado.recordcount GT 0>
				<cfquery datasource="#session.Fondos.dsn#" name="Upd">
					Update CJX012
					set CJX12IRC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Vvalor#">,
						CJX12FRC = getDate(),          
						CJX12URC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">
					where PERCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodo#">
					  and MESCOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#mes#">
					  and TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tipo#">
					  and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tarjeta#">
					  and CJX12AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#autorizacion#">
					  and CJX12FEC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FechaFinal#">
				</cfquery>
			</cfif>
			
		</cfif>
		
	</cfloop>
	
	<cfoutput>	
		<script>
			<cfif isdefined("rsConciliado") and rsConciliado.recordcount EQ 0>
				alert("Error, uno o varios de los vouchers seleccionados \nse encuentra conciliados y no pueden ser rechazados.");
			<cfelse>
				alert("Se #Msgloc# los Vouchers Seleccionados.");
			</cfif>
			document.location = "cjc_RecepcionVauchers.cfm?#params#";
		</script>
	</cfoutput>
	
</cfif>
