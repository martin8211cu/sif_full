<cfif isdefined("form.btnConfigurarColumna")>
	<cflocation url="RepDinamicosColumnaConfig.cfm?Cid=#form.Cid#&RHRDEid=#form.RHRDEid#">
</cfif>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="MSG_ElConceptoDePagoYaEstaRegistrado" Default="El concepto de pago ya est&aacute; registrado" returnvariable="MSG_ElConceptoDePagoYaEstaRegistrado" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_LaDeduccionYaEstaRegistrada" 	 Default="La deducci&oacute;n ya est&aacute; registrada" returnvariable="MSG_LaDeduccionYaEstaRegistrada" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="MSG_LaCargaYaEstaRegistrada" 		 Default="La Carga ya est&aacute; registrada" returnvariable="MSG_LaCargaYaEstaRegistrada" component="sif.Componentes.Translate" method="Translate"/>	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfset params = ''>

<cfif not isdefined('form.Nuevo') and not isdefined('form.NuevoD')>
	<cfif isdefined('form.Alta')>
    	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
        	insert into RHReportesDinamicoE (RHRDEcodigo,RHRDEdescripcion,BMUsucodigo,fechaalta,CEcodigo)
            values(
            	<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHRDEcodigo#">,
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRDEdescripcion#">,
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
            	)
           <cf_dbidentity1 datasource="#session.DSN#">
        </cfquery>
        <cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
        </cftransaction>
         <cfset params = params & 'RHRDEid=' & rsInsert.identity>
    <cfelseif isdefined('form.Cambio')>
	    <cftransaction>
			<cfquery name="rsUpdate" datasource="#session.DSN#">
				update RHReportesDinamicoE
				set RHRDEcodigo 	  = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHRDEcodigo#">,
					RHRDEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHRDEdescripcion#">,
					BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					fechaalta		  = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
			</cfquery>	
        </cftransaction>
        <cfset params = params & 'RHRDEid=' & form.RHRDEid>
    <cfelseif isdefined('form.Baja')>
    	<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from RHReportesDinamicoCSUM
				where Cid in (select a.Cid
							 from RHReportesDinamicoC a
							 where a.RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
							)
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from RHReportesDinamicoCCTE
				where Cid in (select a.Cid
							 from RHReportesDinamicoC a
							 where a.RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
							)
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from RHReportesDinamicoCFOR
				where Cid in (select a.Cid
							 from RHReportesDinamicoC a
							 where a.RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
							)
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from RHReportesDinamicoC
				where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
			</cfquery>
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from RHReportesDinamicoE
				where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
			</cfquery>
        </cftransaction>
        <cflocation url="RepDinamicos.cfm">	
    <cfelseif isdefined('form.AltaD')>

		<cfquery datasource="#session.dsn#" name="rsDepende">
			select Cdescripcion
			from RHReportesDinamicoC
			where Corden = <cfqueryparam cfsqltype="cf_sql_numeric" scale="1" 	value="#form.Corden#">
			and RHRDEid = #form.RHRDEid#
		</cfquery>
		<cfif rsDepende.recordcount gt 0>
			<cf_errorCode	code = "52257"
							msg  = 'La Columna : "@errorDat_1@" posee el orden: @errorDat_2@'
							errorDat_1="#rsDepende.Cdescripcion#"
							errorDat_2="#form.Corden#" />
		</cfif>
		
		<!--- valida que exista unicamente una columna para Empleado y tipo Nomina---->
		<cfquery datasource="#session.dsn#" name="rsDepende">
			select case Ctipo when 2 then 'Empleado' when 3 then 'Nomina' end as ColumnaTipo
			from RHReportesDinamicoC
			where Ctipo = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.Ctipo#">
			and RHRDEid = #form.RHRDEid#
			and Ctipo not in (1,4,10,20)<!--- que no sea sumarizada, ni formulada---->
		</cfquery>
		<cfif rsDepende.recordcount gt 0>
			<cf_errorCode	code = "52258"
							msg  = 'Solo puede existir una Columna : @errorDat_1@'
							errorDat_1="#rsDepende.ColumnaTipo#" />
		</cfif>
		
		<!--- check, si es una columna existe con el mismo nombre   ---->

		<cfquery datasource="#session.dsn#" name="rsDepende">
			select Cdescripcion
			from RHReportesDinamicoC
			where RHRDEid = #form.RHRDEid#
			and ltrim(rtrim(Cdescripcion)) = '#trim(form.Cdescripcion)#'
		</cfquery>
		<cfif rsDepende.recordcount gt 0>
			<cf_errorCode	code = "52259"
							msg  = 'La Columna : @errorDat_1@ ya existe'
							errorDat_1="#rsDepende.Cdescripcion#" />
		</cfif>
		
    	<cftransaction>
			<cfquery name="rsInsertD" datasource="#session.DSN#">
				insert into RHReportesDinamicoC(RHRDEid,Cdescripcion,Cmostrar,Ctipo,Corden,BMUsucodigo,fechaalta)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">,
					<cfif isdefined("form.Cmostrar")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ctipo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="1" value="#form.Corden#">,
					#session.usucodigo#,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
			   <cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsertD">
        </cftransaction>

		  <cfset params = params & 'RHRDEid=' & form.RHRDEid & '&Cid=' & rsInsertD.identity&'&modoD=CAMBIO'>
    <cfelseif isdefined('form.CambioD')>

			<!--- si existe una columna con el mismo orden   ---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select Cdescripcion
				from RHReportesDinamicoC
				where Corden = <cfqueryparam cfsqltype="cf_sql_numeric" scale="1" 	value="#form.Corden#">
				and RHRDEid = #form.RHRDEid#
				and Cid <> #form.Cid#
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52263"
							msg  = 'La Columna : @errorDat_1@ posee el orden: @errorDat_2@'
							errorDat_1="#rsDepende.Cdescripcion#"
							errorDat_2="#form.Corden#" />
			</cfif>
			
			<!--- check, si es una columna existe con el mismo nombre   ---->

			<cfquery datasource="#session.dsn#" name="rsDepende">
				select Cdescripcion
				from RHReportesDinamicoC
				where RHRDEid = #form.RHRDEid#
				and ltrim(rtrim(Cdescripcion)) = '#trim(form.Cdescripcion)#'
				and Cid <> #form.Cid#
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52260"
								msg  = 'La Columna : @errorDat_1@ ya existe'
								errorDat_1="#rsDepende.Cdescripcion#" />
			</cfif>
		
		
			<!--- check, si es una columna Formulada y se está modificando el orden a un estado previo a un calculo aun no realizado.
			Caso: si existe una columna Total_Entre_100 esta depende de que primero se calcule la columna total, por lo que la columna Total_Entre_100 no puede ser calcula   ---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select  rh.Cdescripcion
				from RHReportesDinamicoCFOR fr 
				inner join RHReportesDinamicoC rh
					on fr.Cid = rh.Cid
					
				where (fr.CFORcolA = #form.Cid# or	fr.CFORcolB =#form.Cid#)
				and rh.Corden < <cfqueryparam cfsqltype="cf_sql_numeric" scale="1" 	value="#form.Corden#">
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52261"
								msg  = 'Esta es utilizada para calcular datos de la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Formulada"
								errorDat_2="#rsDepende.Cdescripcion#" />
			</cfif>			
			
			<!--- check, si es una columna Totaliza y se está modificando el orden a un estado previo a un calculo aun no realizado. ---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select rh.Corden,rh.Cdescripcion
				from RHReportesDinamicoCSUM fr 
			inner join RHReportesDinamicoC rh
					on fr.Cid=rh.Cid
				and rh.Corden < <cfqueryparam cfsqltype="cf_sql_numeric" scale="1"  	value="#form.Corden#">
				and fr.CSUMreferencia = #form.Cid#
				and rh.Ctipo = 20 <!--- totalizada---->
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52261"
								msg  = 'Esta es utilizada para calcular datos de la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Totalizada"
								errorDat_2="#rsDepende.Cdescripcion#" />
			</cfif>			
			
			<!--- check, si es una columna Formulada y se está modificando el orden a un estado previo a un calculo aun no realizado.
			Caso: si existe una columna Total_Entre_100 esta depende de que primero se calcule la columna total, por lo que la columna Total_Entre_100 no puede ser calcula   ---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select  rh.Cdescripcion
				from RHReportesDinamicoCFOR fr 
				inner join RHReportesDinamicoC rh
					on (fr.CFORcolA = rh.Cid or	fr.CFORcolB =rh.Cid)
				and rh.Corden > <cfqueryparam cfsqltype="cf_sql_numeric" scale="1"  	value="#form.Corden#">
				and fr.Cid = #form.Cid#
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52261"
								msg  = 'Esta es utilizada para calcular datos de la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Formulada"
								errorDat_2="#rsDepende.Cdescripcion#" />
			</cfif>
			
			<!---si la columna actual tiene se utiliza en una formulada y se mueve a un posterior  ---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select  rh.Cdescripcion
				from RHReportesDinamicoCFOR fr 
				inner join RHReportesDinamicoC rh
					on (fr.CFORcolA = rh.Cid or	fr.CFORcolB =rh.Cid)
				where rh.Corden > <cfqueryparam cfsqltype="cf_sql_numeric" scale="1"  	value="#form.Corden#">
				and fr.Cid = #form.Cid#
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52261"
								msg  = 'Esta es utilizada para calcular datos de la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Formulada"
								errorDat_2="#rsDepende.Cdescripcion#" />
			</cfif>
			

			<cfquery name="rsUpdateD" datasource="#session.DSN#">
				update RHReportesDinamicoC
				set Cdescripcion =	<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Cdescripcion#">,
					Cmostrar  =	<cfif isdefined("form.Cmostrar")>1<cfelse>0</cfif>,
					Ctipo  = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.Ctipo#">,
					Corden 	  = 	<cfqueryparam cfsqltype="cf_sql_numeric" scale="1" 	value="#form.Corden#">,
					BMUsucodigo 	  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
					fechaalta 		  = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">
				where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
			</cfquery>
        <cfset params = params & 'RHRDEid=' & form.RHRDEid & '&Cid=' & form.Cid&'&modoD=CAMBIO'>
    <cfelseif isdefined('form.BajaD')>
    	<cftransaction>
			<!--- check, si es la columna tiene dependencia a una columna totalizadas, dado que tiene dependencia, se tiene que verificar---->
			<cfquery datasource="#session.dsn#" name="rsDependeT">
				select rh.Cdescripcion
				from RHReportesDinamicoCSUM fr 
				inner join RHReportesDinamicoC rh
					on fr.Cid=rh.Cid
					and fr.CSUMtipo = 20
				where CSUMreferencia = #form.Cid#
			</cfquery>
			<cfif rsDependeT.recordcount gt 0>
				<cf_errorCode	code = "52262"
								msg  = 'Esta es utilizada en la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Totalizada"
								errorDat_2="#rsDependeT.Cdescripcion#" />
			</cfif>
		
			<!--- check, si es una columna Formulada, dado que tiene dependencia, se tiene que verificar---->
			<cfquery datasource="#session.dsn#" name="rsDepende">
				select rh.Cdescripcion
				from RHReportesDinamicoCFOR fr 
				inner join RHReportesDinamicoC rh
					on fr.Cid=rh.Cid
				where (fr.CFORcolA = #form.Cid# or	fr.CFORcolB = #form.Cid#)
			</cfquery>
			<cfif rsDepende.recordcount gt 0>
				<cf_errorCode	code = "52262"
								msg  = 'Esta es utilizada en la Columna @errorDat_1@: @errorDat_2@'
								errorDat_1="Formulada"
								errorDat_2="#rsDepende.Cdescripcion#" />
			<cfelse>
				<cfquery datasource="#session.DSN#">
					delete from RHReportesDinamicoCFOR
					where Cid = #form.Cid#
				</cfquery>
				<cfquery datasource="#session.DSN#">
					delete from RHReportesDinamicoCSUM
					where Cid = #form.Cid#
				</cfquery>
				<cfquery datasource="#session.DSN#">
					delete from RHReportesDinamicoCCTE
					where Cid = #form.Cid#
				</cfquery>
				<cfquery name="rsDeleteCol" datasource="#session.DSN#">
					delete from RHReportesDinamicoC
					where RHRDEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRDEid#">
					  and Cid = #form.Cid#
				</cfquery>
			</cfif>
        </cftransaction>
		<cfset params = params & '&RHRDEid=' & form.RHRDEid>
	</cfif>	
<cfelseif isdefined('form.NuevoD')>
	 <cfset params = params & 'RHRDEid=' & form.RHRDEid>
</cfif>
<cflocation url="RepDinamicosColumna.cfm?#params#">	