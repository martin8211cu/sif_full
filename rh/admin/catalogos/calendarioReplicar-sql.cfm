<!--- Este código se encarga de replicar un calendario de pago en diferentes nóminas--->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<!---esta funcion se encarga de devolver la estructura de la tabla CalendarioPagos para mostrar los tipos y nombres de cada columna--->
<cf_dbstruct name="CalendarioPagos" returnvariable="rsStruct" datasource="#session.DSN#">

<!--- este codigo se encarga de llenar la variable CAMPOS con los campos de la tabla rsStruct exceptuando los campos identity y el campo Tcodigo--->
<cfif isdefined("rsStruct") and rsStruct.RecordCount neq 0 >
	<cfquery dbtype="query" name="rscampos">
		select NAME as cols
		from rsStruct 
		where rsStruct.identity = 0
			and upper(rsStruct.name) not in ('TCODIGO','CPCODIGO','CPHASTA','CPFPAGO','CPDESDE')
	</cfquery>
	
	<cfset campos = valuelist(rscampos.cols)>
	
</cfif>

	<!--- se obtienen los codigos de los tipos de nomina--->
	<cfif form.todos eq 'N'>
		<cfset codigos = form.codigos>
	<cfelse>
		<cfquery name="rs_tiposnomina" datasource="#session.DSN#">
			select Tcodigo
			from TiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery> 
		<cfset codigos = valuelist(rs_tiposnomina.Tcodigo)  >
	</cfif>
	
	
	
	<cfset errores1="">
<!---busca que no exista un calendario de pago con el mismo codigo en la nomina que se quiere insertar, esto antes de insertarla--->	
<cfloop list="#codigos#" index="i">
		<cfquery name="existeCodigoCalendario" datasource="#session.DSN#">
			Select a.Tcodigo #_cat# b.Tdescripcion as existe 
			from CalendarioPagos a
			inner join TiposNomina b
				on a.Tcodigo=b.Tcodigo
				and a.Ecodigo=b.Ecodigo
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			 and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
			 and upper(a.CPcodigo)=upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fCPcodigo#">)
		</cfquery>

		<cfif existeCodigoCalendario.recordcount gt 0 and len(trim(existeCodigoCalendario.existe))>
			<cfset errores1=errores1&"<br/>* #existeCodigoCalendario.existe#">
		</cfif>

</cfloop>
	
<cfif errores1 NEQ ''>
	<cfset errores1="<br>--> El código '#form.fCPcodigo#' ya existe en la(s) n&oacute;mina(s):<br> "& errores1&"<br>">
</cfif>
	
	
	
	
<cfset errores2="">
<!--- analiza que el calendario no exista en el tipo de nomina de destino, si existe se concatena a los errores--->
<cfloop list="#codigos#" index="i">
		<cfquery name="existeCalendarios" datasource="#session.DSN#">
		Select a.Tcodigo #_cat# b.Tdescripcion as existe 
		from CalendarioPagos a
		inner join TiposNomina b
			on a.Tcodigo=b.Tcodigo
			and a.Ecodigo=b.Ecodigo
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
		  and a.CPfpago=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPfpago)#">
		</cfquery>
		

		<cfif existeCalendarios.recordcount gt 0 and len(trim(existeCalendarios.existe))>
			<cfset errores2=errores2&"<br/>* #existeCalendarios.existe#">
		</cfif>
	
</cfloop>

	
<cfif errores2 NEQ ''>
	<cfset errores2="<br>--> Existen Calendarios de Pago con la misma Fecha de Pago: #form.fCPfpago# en las n&oacute;minas: <br> "&errores2&"<br>">
</cfif>


<cfset errores3="">
<!--- analiza que el calendario no exista en el tipo de nomina de destino, con fecha Hasta igual--->
<cfloop list="#codigos#" index="i">
		<cfquery name="existeCalendariosH" datasource="#session.DSN#">
		Select a.Tcodigo #_cat# b.Tdescripcion as existe 
		from CalendarioPagos a
		inner join TiposNomina b
			on a.Tcodigo=b.Tcodigo
			and a.Ecodigo=b.Ecodigo
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		 and a.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
		  and a.CPhasta=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPhasta)#">
		</cfquery>

		<cfif existeCalendariosH.recordcount gt 0 and len(trim(existeCalendariosH.existe))>
			<cfset errores3=errores3&"<br/>* #existeCalendariosH.existe#">
		</cfif>
</cfloop>

	
<cfif errores3 NEQ ''>
	<cfset errores3="<br>--> Existen Calendarios de Pago con la misma Fecha Hasta: '#form.fCPhasta#' en las n&oacute;minas: <br> "&errores3&"<br>">
</cfif>


<cfset errores=errores1 & errores2 & errores3>

<!--- se obtuvieron las variables necesarias para realizar el proceso de replicación de los calendarios--->

<cfif len(trim(errores))>
	<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errTitle=#URLEncodedFormat('Error:  No se puede realizar esta Replicaci&oacute;n!')#&errDet=#URLEncodedFormat(errores)#" addtoken="no">
<cfelse>
	<cftransaction><!--- se comienza proceso transaccional para realizar la replica en las distintas nóminas--->
		<cfloop list="#codigos#" index="i"><!--- cfloop para recorrer los codigos de nóminas donde se desea replicar la nómina deseada---->
	
				<!--- se realiza el insert del calendario de pago nuevo para la nómina que se determina en la lista de nóminas--->
				<cfquery name="insert_tipo" datasource="#session.DSN#">
					insert into CalendarioPagos( Tcodigo, CPcodigo, CPdesde, CPhasta,CPfpago,#campos#)
					select 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">, <!---posee el Tcodigo--->
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fCPcodigo)#">,<!--- posee el nuevo CPcodigo suministrado por el usuario--->
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPhasta)#">, <!---as afecha, posee fecha desde que es igual a la hasta en calendarios especiales--->
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPhasta)#">, <!---posee fecha hasta--->
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPfpago)#">, <!---posee fecha pago--->
							#campos#
					from CalendarioPagos cp
					where cp.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
					and  (  select count(1)
									  from CalendarioPagos
									  where Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
										and CPfpago = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPfpago)#">
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										and cp.CPhasta=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPhasta)#">) = 0
									
				</cfquery>

				<cfquery name="queryNuevoCPid" datasource="#session.DSN#"><!--- obtiene el nuevo CPid--->
					select 	cp.CPid
					from CalendarioPagos cp
					where cp.Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
					and cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and cp.CPfpago=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPfpago)#">
					and cp.CPhasta=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fCPhasta)#">					
				</cfquery>
								
				
				<cfset nuevo_CPid = #queryNuevoCPid.CPid#>
				

			
			<!--- inserta las deducciones a excluir asociadas --->
			<cfquery datasource="#session.DSN#">
				insert into RHExcluirDeduccion(CPid, TDid, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">, ed.TDid, ed.BMUsucodigo
				from RHExcluirDeduccion ed
				where ed.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				and ( select count(1)
						from RHExcluirDeduccion
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">
						and TDid =  ed.TDid ) = 0		
			</cfquery>

			<!--- inserta los conceptos de pago asociados --->
			<cfquery datasource="#session.DSN#">
				insert into CCalendario(CPid, CIid, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">, cc.CIid, cc.BMUsucodigo
				from CCalendario cc
				where cc.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
				and ( select count(1)
						from CCalendario
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">
						and  CIid = cc.CIid ) = 0		
			</cfquery>		
			
			<!--- inserta los creditos fiscales asociados --->
			
			<cfquery datasource="#session.DSN#">
			
				insert into RHExcluirCFiscal(CPid, CDid, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">, cf.CDid, cf.BMUsucodigo
				from RHExcluirCFiscal cf
				where cf.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#"> 
				and ( select count(1)
						from RHExcluirCFiscal
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#"> 
						and  CDid = cf.CDid ) = 0	   
				
			</cfquery>		
			
			<!--- inserta cargas --->
			<cfquery datasource="#session.DSN#">
			
			   		insert into RHCargasExcluir(CPid, DClinea, BMUsucodigo)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#">, ca.DClinea, ca.BMUsucodigo
				from RHCargasExcluir ca
				where ca.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#"> 
				and ( select count(1)
						from RHCargasExcluir
						where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#nuevo_CPid#"> 
						and  DClinea = ca.DClinea )	= 0
			</cfquery>
			
			<!--- fin de insercion de dependencias---->		
			
		</cfloop><!--- fin de loop de codigos de nominas a insertar--->

	</cftransaction>	
</cfif>


	<cfscript>
		WriteOutput('<script language="JavaScript">alert("Proceso de replicaci\u00f3n completado exitosamente!");</script>');
	</cfscript>

	<cfscript>
		WriteOutput('<script language="JavaScript">window.location = "calendarioReplicar.cfm?CPid=#form.CPid#"</script>');
	</cfscript>
	