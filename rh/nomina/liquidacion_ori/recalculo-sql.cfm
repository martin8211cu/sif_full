<cfif isdefined ('form.Recalcular') or isdefined('form.btnAplicar')>
<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
<!---Creo la tabla temporal que me va a almacenar los datos que obtengo del resultado de los calculos nuevos--->
<cf_dbtemp name="recal_liquidacion" returnvariable="recal_liquidacion">
	<cf_dbtempcol name="CIid" type="numeric">
	<cf_dbtempcol name="importe" type="money"> 
	<cf_dbtempcol name="resultado" type="money">
	<cf_dbtempcol name="cantidad" type="float">
</cf_dbtemp>

<!---Buscar cuales conceptos de pago se tienen q recalcular--->
<cfquery name="rsConceptos" datasource="#session.DSN#">
	select    dle.DLfvigencia,
			  dle.DLffin,
			  dle.DEid,
			  dle.Ecodigo,
			  dle.RHTid,
			  dle.DLlinea,
			  coalesce(dle.RHJid, 0) as RHJid,	
	 		eve.EVfantig, i.CIid, 
		   i.CIcantidad, i.CIrango, i.CItipo, i.CIcalculo, i.CIdia, i.CImes
	 from DLaboralesEmpleado  dle
	  inner join RHTipoAccion rhta
		on  dle.Ecodigo = rhta.Ecodigo
		and dle.RHTid = rhta.RHTid
	  inner join EVacacionesEmpleado eve
	    on  dle.DEid = eve.DEid 
	  inner join ConceptosTipoAccion c
	  		inner join CIncidentesD i
			on c.CIid= i.CIid
	  	on c.RHTid=dle.RHTid
	where dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and dle.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
</cfquery>

<!---Recalculo los conceptos--->
<cfloop query="rsConceptos">
	<cfset FVigencia = LSDateFormat(form.Fvigencia, 'DD/MM/YYYY')>
		<cfset FFin = LSDateFormat(form.Fvigencia, 'DD/MM/YYYY')>
	<cfset current_formulas = rsConceptos.CIcalculo>
	<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
								   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
								   rsConceptos.CIcantidad,
								   rsConceptos.CIrango,
								   rsConceptos.CItipo,
								   rsConceptos.DEid,
								   rsConceptos.RHJid,
								   rsConceptos.Ecodigo,
								   rsConceptos.RHTid,
								   0,
								   rsConceptos.CIdia,
								   rsConceptos.CImes,
								   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
								   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
								   'false',
								   '',
								   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!---optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
								   )>
	<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
	<cfset calc_error = RH_Calculadora.getCalc_error()>
	<cfif Not IsDefined("values")>
		<cfif isdefined("presets_text")>
			<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
		<cfelse>
			<cf_throw message="#calc_error#" >
		</cfif>
	</cfif>
	 
	 Incidente<cfdump var="#rsConceptos.CIid#"></br>
	 Importe<cfdump var="#values.get('importe').toString()#"></br>
	 Resultado<cfdump var="#values.get('resultado').toString()#"></br>
	 Cantidad<cfdump var="#values.get('cantidad').toString()#"></br>
	 
	 <cfquery name="updConceptos" datasource="#Session.DSN#">
		insert into #recal_liquidacion#(CIid,importe,resultado,cantidad)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">
		)
	</cfquery> 
</cfloop>

<!---Buscar el monto de los componentes de pago calculados en la primera confección--->
<cfquery name="rsPersonal" datasource="#session.dsn#">
	select	a.DLlinea, a.DEid, a.RHLPfecha, a.fechaalta,
	b.RHLPid, b.RHLPdescripcion as nombre, b.fechaalta,
	c.CIcodigo, c.CIdescripcion,c.CIid,
	case when d.DDCcant is null then b.importe else d.DDCimporte end as importe,
	coalesce(d.DDCres,0) as Resultado, 
	coalesce(d.DDCcant,0) as Cantidad
	from RHLiquidacionPersonal a

	  inner join RHLiqIngresos b
		on  a.Ecodigo = b.Ecodigo
		and a.DEid = b.DEid
		and a.DLlinea = b.DLlinea

	  inner join CIncidentes c
		on  b.CIid = c.CIid
		and b.Ecodigo = c.Ecodigo
	
	  left outer join DDConceptosEmpleado d
		on d.CIid = c.CIid
		and d.DLlinea = a.DLlinea
		
	where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DLlinea#">
	  and b.RHLPautomatico = 1
	order by 2
</cfquery>

<cfset Lvar=0>

<cfloop query="rsPersonal">
	<cfquery name="rsdif" datasource="#session.dsn#">
		select * ,1 as cantidad 
		from #recal_liquidacion#
		where CIid=#rsPersonal.CIid# 
		and importe !=#rsPersonal.importe# 
		and not exists ( select 1 from #recal_liquidacion# a
						where #recal_liquidacion#.CIid=a.CIid
						and #recal_liquidacion#.importe=a.importe)
	</cfquery>
	<cfdump var="#rsdif#">
	<cfif rsdif.cantidad eq 1>
		<cfset Lvar=Lvar+1>
	</cfif>
</cfloop>

<!---Si existen registros que son diferentes a los registros actuales entonces inserta los datos en las tablas de recalculo--->
<cfif Lvar neq 0>
	<!---Encabezado--->
	<cfquery name="rsValida" datasource="#session.dsn#">
		select RHLRLid from RHRLiqPersonal 
		where Ecodigo=#session.Ecodigo#
		and RHLRPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fvigencia#">
		and DEid=#rsConceptos.DEid#
		and DLlinea=#form.DLlinea#
		and RHLRPestado=0
	</cfquery>

	<cfif len(trim(rsValida.RHLRLid)) eq 0>
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into 
			RHRLiqPersonal (DLlinea,
							Ecodigo,
							DEid,
							RHLRPestado,
							RHLRPfecha,
							BMUsucodigo,
							fechaalta)				
			values (#form.DLlinea#,
					#session.Ecodigo#,
					#rsConceptos.DEid#,
					0,
					<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fvigencia#">,
					#session.Usucodigo#,
					#now()#)
		<cf_dbidentity1 datasource="#session.DSN#" name="rsInsert">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" returnvariable="Lvarid">
		<cfquery name="rsdInsert" datasource="#session.dsn#">
			insert into RHRLiqIngresos(	RHLRLid,
										DLlinea,
										DEid,
										CIid,
										Ecodigo,
										RHRLPdescripcion,
										importe,
										BMUsucodigo,
										fechaalta,
										cantidad,
										resultado)
			(select #Lvarid#,
					#form.DLlinea#,
					#rsConceptos.DEid#,
					CIid,
					#session.Ecodigo#,
					'Recalculo',
					importe,
					#session.Ecodigo#,
					#now()#,
					cantidad,
					resultado
			from #recal_liquidacion# 
			where importe != 0)
		</cfquery>
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(resultado),0) as suma
			from RHRLiqIngresos
			where DLlinea=#form.DLlinea#
			and RHLRLid= #Lvarid#
		</cfquery>
		<cfset LvarR=0>
		<cfset LvarR=LvarR+upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(DDCres),0) as suma
			from DDConceptosEmpleado
			where DLlinea=#form.DLlinea#
		</cfquery>	
		<cfset LvarR=LvarR-upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(RHRLdif),0) as suma
			from RHRLiqPersonal
			where DLlinea=#form.DLlinea#
		</cfquery>
		<cfset LvarR=LvarR-upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			update RHRLiqPersonal set RHRLdif=#LvarR#
			where RHLRLid=#Lvarid#
		</cfquery>	
	<cfelse>
		
	<!---Borro las lineas en vez de actualizarlas xq no tengo certeza de que si se realizo un cambio este no me afecte los importes, es decir q uno q antes no presentara importes ahora si--->
		<cfquery name="delDatos" datasource="#session.dsn#">
			delete from RHRLiqIngresos
			where DLlinea=#form.DLlinea#
			and DEid=#rsConceptos.DEid#
			and Ecodigo=#session.Ecodigo#
			and RHLRLid=#rsValida.RHLRLid#
		</cfquery>
		<cfquery name="rsdInsert" datasource="#session.dsn#">
			insert into RHRLiqIngresos(	RHLRLid,
										DLlinea,
										DEid,
										CIid,
										Ecodigo,
										RHRLPdescripcion,
										importe,
										BMUsucodigo,
										fechaalta,
										cantidad,
										resultado)
			(select #rsValida.RHLRLid#,
					#form.DLlinea#,
					#rsConceptos.DEid#,
					CIid,
					#session.Ecodigo#,
					'Recalculo',
					importe,
					#session.Ecodigo#,
					#now()#,
					cantidad,
					resultado
			from #recal_liquidacion# 
			where importe != 0)
		</cfquery>
		
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(resultado),0) as suma
			from RHRLiqIngresos
			where DLlinea=#form.DLlinea#
			and RHLRLid=#rsValida.RHLRLid#
		</cfquery>
		<cfset LvarR=0>
		<cfset LvarR=LvarR+upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(DDCres),0) as suma
			from DDConceptosEmpleado
			where DLlinea=#form.DLlinea#
		</cfquery>	
		<cfset LvarR=LvarR-upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			select coalesce(sum(RHRLdif),0) as suma
			from RHRLiqPersonal
			where DLlinea=#form.DLlinea#
		</cfquery>
		<cfset LvarR=LvarR-upDif.suma>
		<cfquery name="upDif" datasource="#session.dsn#">
			update RHRLiqPersonal set RHRLdif=#LvarR#
			where RHLRLid=#rsValida.RHLRLid#
		</cfquery>			
	</cfif>
	<cfif not isdefined('form.btnAplicar')>
	<cflocation url="recalculo.cfm?DEid=#rsConceptos.DEid#&DLlinea=#form.DLlinea#">
	</cfif>
<cfelse>
	<cflocation url="recalculo.cfm?DEid=#rsConceptos.DEid#&error=1&DLlinea=#form.DLlinea#">
</cfif>	
</cfif>


<cfif isdefined('form.btnAplicar')>
	<cfquery name="rsUpd" datasource="#session.dsn#">
		update RHRLiqPersonal 
		set RHLRPestado= 1,
		fechaalta=#now()#
		where Ecodigo=#session.Ecodigo#
		and RHLRPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fvigencia#">
		and DEid=#form.DEid#
		and DLlinea=#form.DLlinea#
		and RHLRLid=#form.RHLRLid#
	</cfquery>
	<cflocation url="recalculo.cfm?DEid=#form.DEid#&DLlinea=#form.DLlinea#">
</cfif>


