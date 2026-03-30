<!---<cfdump var="#form#">--->
<cfif isdefined ('form.btnReporte')>
	<cflocation url="arqueo.cfm?rep=1&CCHAid=#form.CCHAid#">
</cfif>
<cfif isdefined ('form.btnReporteDetallado')>
	<cflocation url="arqueo.cfm?repDetallado=1&CCHAid=#form.CCHAid#">
</cfif>

<cfif isdefined('form.Regresar')>
	<cflocation url="arqueo.cfm">
</cfif>

<cfif isdefined('form.btnRegresar')>
	<cflocation url="arqueo.cfm">
</cfif>

<cfif isdefined ('form.aplica')>
<!---inserta el encabezado del arqueo--->
<cftransaction>
	<cfquery name="rsInserta" datasource="#session.dsn#">
		insert into CCHarqueo(
			CCHid,
			CCHvales,
			CCHgastos,
			CCHefectivo,
			CCHsobrante,
			CCHfaltante,
			Ecodigo,
			BMfecha,BMUsucodigo
		)
		values
		(
			#form.CCHid#,
			#replace(form.vales,',','','ALL')#,
			#replace(form.gasto,',','','ALL')#,
			#replace(form.efectivo,',','','ALL')#,
			0,0,#session.ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
			#session.Usucodigo#
		)
		<cf_dbidentity1 datasource="#session.dsn#" name="rsInserta" verificar_transaccion= "false">
			</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInserta" returnvariable="LvarCCHAid" verificar_transaccion= "false">
</cftransaction>

	<cfquery name="rsMonto" datasource="#session.dsn#">
			select CCHImontoasignado from CCHImportes where CCHid=#form.CCHid#	
	</cfquery>
	
	<cfquery name="rsTotal" datasource="#session.dsn#">
		select CCHIanticipos,CCHIgastos, CCHImontoasignado,(CCHImontoasignado-(CCHIanticipos+CCHIgastos)) as disponible
		from CCHImportes 
		where CCHid=#form.CCHid#
	</cfquery>
	
	<cfset vales=rsTotal.CCHIanticipos>
	<cfset gastos=rsTotal.CCHIgastos>
	
	<cfset efectivo=rsMonto.CCHImontoAsignado-vales-gastos>
	<cfset montoasignadoIngresado = #replace(form.vales,',','','ALL')#+#replace(form.gasto,',','','ALL')#+#replace(form.efectivo,',','','ALL')# >
	<cfset montoasignadoRegistrado= #rsMonto.CCHImontoAsignado#>
	<cfset montoDiferencial= montoasignadoIngresado-montoasignadoRegistrado>
	
		<cfif montoDiferencial gt 0>
			<cfset sobrante= montoDiferencial>
			<cfset faltante=0>
		</cfif>
		
		<cfif montoDiferencial lt 0>
			<cfset sobrante=0 >
			<cfset faltante=montoDiferencial>
		</cfif>
		
		<cfif montoDiferencial eq 0>
			<cfset sobrante=0 >
			<cfset faltante=0>
		</cfif>
		
		<cfquery name="upArqueo" datasource="#session.dsn#">
			update CCHarqueo
			set CCHsobrante=#sobrante#,
			CCHfaltante=#faltante#
			where CCHAid=#LvarCCHAid#
		</cfquery>
		
		<cfset difVales=#vales#-#replace(form.vales,',','','ALL')#>
		<cfset difGasto=#gastos#-#replace(form.gasto,',','','ALL')#>
		<cfset difEfec=(rsMonto.CCHImontoAsignado-vales-gastos)-replace(form.efectivo,',','','ALL')>
		<cfset tot3=difVales+difGasto+difEfec>
<!---inserta el detalle del arqueo--->
		<cfquery name="rsInsertaDet" datasource="#session.dsn#">
			insert into CCHarqueoD(
				MontoAsignado,
				Vales,         
				Gastos,       
				Efectivo,      
				DifVales,    
				DifGastos,  
				DifEfectivo, 
				DifTotal,    
				CCHAid
			)
			values
			(
				#rsMonto.CCHImontoasignado#,
				#vales#,
				#gastos#,
				#efectivo#,			
				#difVales#,
				#difGasto#,
				#difEfec#,
				#tot3#,
				#LvarCCHAid#
			)
		</cfquery>
<!---inserta los datos del vale del reporte del arqueo--->		
	<cfquery name="rsVales" datasource="#session.dsn#">
		select 
			v.CCHVnumero,
			v.CCHVfecha,
			v.CCHVmontonOrig,
			b.TESBeneficiario
		from CCHVales v
			inner join GEanticipo a
					inner join TESbeneficiario b
					on b.TESBid=a.TESBid
			on a.GEAid= v.GEAid
		where v.CCHTid in (
		select  p.CCHTid
		from CCHTransaccionesAplicadas a
			inner join CCHTransaccionesProceso p
			on p.CCHTid = a.CCHTAtranRelacionada
			and p.CCHTestado='CONFIRMADO'
		where a.CCHid=#form.CCHid#
		  and a.CCHTAreintegro=-1
		  and a.CCHTtipo='ANTICIPO'
		  and (
				select count(1)
				from GEliquidacionAnts an
					inner join GEliquidacion l
					on l.GELid=an.GELid
					and l.GELestado <!---NOT---> in (0,1,2,3,4,5)	<!---La idea es q solo salgan anticipos que no tenga ninguno ya liquidado--->			
				where an.GEAid   = p.CCHTrelacionada
			  ) = 0		
		)
	</cfquery>
	
	<cfquery name="rsValesL" datasource="#session.dsn#">
		select 
			v.CCHVnumero,
			v.CCHVfecha,
			v.CCHVmontonOrig,
			b.TESBeneficiario
		from CCHVales v
			inner join GEliquidacion a
					inner join TESbeneficiario b
					on b.TESBid=a.TESBid
			on a.GELid= v.GELid	
		where v.CCHTid in (
			select  p.CCHTid
			from CCHTransaccionesAplicadas a
				inner join CCHTransaccionesProceso p
				on p.CCHTid = a.CCHTAtranRelacionada
                and p.CCHTestado='CONFIRMADO'<!---Le agrego que el estado del vale este confirmado --->
			where a.CCHid=#form.CCHid#
			 and a.CCHTAreintegro=-1
			  and a.CCHTtipo='GASTO'<!---Estaba anticipos lo cambio por gastos--->
			  and (
					select count(1)
					from GEliquidacionAnts an
						inner join GEliquidacion l
						on l.GELid=an.GELid
						and l.GELestado NOT in (0,1)				
					where an.GEAid   = p.CCHTrelacionada
				  ) > 0
		)
	</cfquery>
	<cfloop query="rsVales">
		<cfquery name="inVales" datasource="#session.dsn#">
			insert into CCHarqueoVale(			
				NumVale,
				Solicitante,
				Fecha,      
				Monto,      
				CCHAid 			
			)
			values(
				#rsVales.CCHVnumero#,
				'#rsVales.TESBeneficiario#',
				#rsVales.CCHVfecha#,
				#rsVales.CCHVmontonOrig#,
				#LvarCCHAid#
			)
		</cfquery>
	</cfloop>
		<cfloop query="rsValesL">
		<cfquery name="inValesL" datasource="#session.dsn#">
			insert into CCHarqueoVale(			
				NumVale,
				Solicitante,
				Fecha,      
				Monto,      
				CCHAid 			
			)
			values(
				#rsValesL.CCHVnumero#,
				'#rsValesL.TESBeneficiario#',
				#rsValesL.CCHVfecha#,
				#rsValesL.CCHVmontonOrig#,
				#LvarCCHAid#
			)
		</cfquery>
	</cfloop>
	
<!---inserta los encabezados de los gastos--->
<cfquery name="rsGastos" datasource="#session.dsn#">
	select	 
	b.TESBeneficiario,
	l.GELnumero,
	l.GELid
	 from CCHTransaccionesAplicadas a
        inner join CCHTransaccionesProceso p  
        	on p.CCHTid = a.CCHTAtranRelacionada
            and p.CCHTtipo='GASTO' 
            and p.CCHTestado = 'POR CONFIRMAR'<!---tengo dudas de este--->
		inner join GEliquidacion l
        	on l.GELid=p.CCHTrelacionada
		inner join TESbeneficiario b
			on b.TESBid=l.TESBid
       <!--- inner join CCHTransaccionesProceso r  REPETIDO--->
       <!--- on r.CCHTid=a.CCHTAreintegro primero esta repetido y segundo mal ligue por CCHTAreintegro --->
        <!---and r.CCHTtipo='REINTEGRO' Esta buscando reintegros cuando debe ser gastos--->
        <!---and r.CCHTestado in ('EN PROCESO','EN APROBACION CCH','EN APROBACION TES','POR CONFIRMAR') En caso de usar Me parece que solo deberia ser 'POR CONFIRMAR'--->
   where a.CCHid=#form.CCHid#
	  and a.CCHTtipo='GASTO' 
      and a.CCHTAreintegro=-1 <!---Para excluir los que ya fueron reintegrados--->	
</cfquery>

<cfloop query="rsGastos">
<cfquery name="inGastos" datasource="#session.dsn#">
	insert into CCHarqueoGastos(
		GELid,
		NumLiq ,
		Solicitante,
		CCHAid 	
	)
	values(
		#rsGastos.GELid#,
		#rsGastos.GELnumero#,
		'#rsGastos.TESBeneficiario#',
		#LvarCCHAid#
	)
</cfquery>
</cfloop>
<!---inserta los detalles de los gastos--->
	<cfloop query="rsGastos">
		<cfquery name="rsDetGastos" datasource="#session.dsn#">
			select 
				l.Mcodigo,
				l.GELGdescripcion,
				l.GELGnumeroDoc,
				l.GELGproveedor,
				l.GELGtotalOri,
				m.Miso4217
			from GEliquidacionGasto l
				inner join Monedas m
				on m.Mcodigo=l.Mcodigo
			 where l.GELid=#rsGastos.GELid#		 
		</cfquery>
        <cfloop query="rsDetGastos"> <!---Agrego este loop pues en realidad solo ingresaba el primer detalle de la liquidacion--->
            <cfquery name="inGastosD" datasource="#session.dsn#">
                insert into CCHarqueoDet(
                    GELid  ,
                    Factura,
                    Proveedor,
                    Total ,
                    Moneda ,
                    CCHAid  )
                values (
                    #rsGastos.GELid#,
                    '#rsDetGastos.GELGnumeroDoc#',
                    '#rsDetGastos.GELGproveedor#',
                    #rsDetGastos.GELGtotalOri#,
                    '#rsDetGastos.Miso4217#',
                    #LvarCCHAid#
                    )
            </cfquery>
        </cfloop>    
	</cfloop>
	
<!---inserta los reintegros--->
	<cfquery name="rsReintegro" datasource="#session.dsn#">
		select  
			CCHcod,
			CCHTmonto,
			CCHTestado,
			BMfecha
		from CCHTransaccionesProceso 
		where CCHTtipo='REINTEGRO'
		and CCHid=#form.CCHid#
		and BMfecha <=#now()#
		and CCHTestado <> 'CONFIRMADO'
	</cfquery>
	<cfloop query="rsReintegro">
		<cfquery name="rsRein" datasource="#session.dsn#">
			insert into CCHarqueoReintegro(
				NumTransac,
				Monto,         
				Estado,        
				Fecha ,        
				CCHAid
			)
			values(
				#rsReintegro.CCHcod#,
				#rsReintegro.CCHTmonto#,
				'#rsReintegro.CCHTestado#',
				<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#rsReintegro.BMfecha#">,
				#LvarCCHAid#
			)
		</cfquery>
	</cfloop>
	<cflocation url="arqueo.cfm?CCHAid=#LvarCCHAid#">	
</cfif>
