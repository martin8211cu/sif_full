<cfset varAction = 'capturaSalidas-Mant.cfm'>

<cfif not isdefined("Form.btnCancelar")>
	<cfif isdefined("Form.btnAgregar")>
		<cftransaction>
			<cfquery name="altaSalida" datasource="#session.DSN#">
				insert INTO ESalidaProd 
					(Ecodigo, Ocodigo, Pista_id, Turno_id, SPfecha, Observaciones, SPestado, BMUsucodigo)
				values (
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Form.Ocodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Form.pista#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.turno#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#LSParseDateTime(form.SPfecha)#" cfsqltype="cf_sql_timestamp">,
						<cfif isdefined('Form.Observaciones') and Form.Observaciones NEQ ''>
							<cfqueryparam value="#Form.Observaciones#" cfsqltype="cf_sql_varchar">,
						<cfelse>
							null,					
						</cfif>
						0, 
						<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="altaSalida">
		</cftransaction>

		<!--- Ciclo para la insercion del detalle --->
		<cfif isdefined('form.cantReg') and form.cantReg NEQ '' and form.cantReg GT 0 and altaSalida.identity NEQ '' and altaSalida.identity GT 0>
			<cfset cantIteracciones = form.cantReg>
			<cfloop from="1" to="#cantIteracciones#" index="i">
				<cfquery datasource="#session.DSN#">
					insert INTO DSalidaProd 
						(Ecodigo, ID_salprod, Alm_ai, Aid, Lectura_control, Unidades_vendidas, Unidades_despachadas, Unidades_calibracion, Precio, Ingreso, Descuento, DSPimpuesto, BMUsucodigo)
					values (
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#altaSalida.identity#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['almacen_#i#']#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['articulo_#i#']#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Lectura_control_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_vendidas_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_despachadas_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_calibracion_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['precio_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['bruto_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['desc_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['DSPimpuesto_#i#'],',','')#">, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )

				</cfquery>			
			</cfloop>
		</cfif>
	<cfelseif isdefined("Form.btnGuardar")>
 		<cfif isdefined('form.cantReg') and form.cantReg NEQ '' and form.cantReg GT 0 and isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
			<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
				<cf_dbtimestamp datasource="#session.dsn#"
								table="ESalidaProd"
								redirect="#varAction#"
								timestamp="#form.ts_rversion#"
								field1="ID_salprod" 
								type1="numeric" 
								value1="#form.ID_salprod#"
								field2="Ecodigo" 
								type2="integer" 
								value2="#session.Ecodigo#" >		

				<cfquery name="update" datasource="#session.DSN#">
					update ESalidaProd
						set SPfecha = <cfqueryparam value="#LSParseDateTime(form.SPfecha)#" cfsqltype="cf_sql_timestamp">
						, Pista_id = <cfqueryparam value="#Form.pista#" cfsqltype="cf_sql_numeric">
						, Turno_id = <cfqueryparam value="#Form.turno#" cfsqltype="cf_sql_numeric">
						, Observaciones = <cfif isdefined('form.Observaciones') and form.Observaciones NEQ ''><cfqueryparam value="#form.Observaciones#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>
					where ID_salprod = <cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
						and Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>		
			</cfif> 
					
					
		<cfquery name="rsTMP" datasource="#session.DSN#">
			select b.ID_dsalprod, ESVid, b.Aid, DDScantidad, a.BMUsucodigo, a.BMfechaalta
			FROM DDSalidaProd a
				inner join DSalidaProd b
					on b.Ecodigo=a.Ecodigo
						and b.ID_dsalprod=a.ID_dsalprod
						and b.ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>						
					
		<cfif isdefined('rsTMP') and rsTMP.recordCount GT 0>						
			<cfquery name="rsTMPArt" dbtype="query">
				Select distinct Aid as Aid
				from rsTMP
			</cfquery>	
			<cfquery name="rsTMPdet" datasource="#session.DSN#">
				Select ID_dsalprod,Aid,ID_salprod,Ecodigo
				from DSalidaProd
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
					and Aid in (#ValueList(rsTMPArt.Aid)#)
			</cfquery>

			<cfif isdefined('rsTMPdet') and rsTMPdet.recordCount GT 0>
				<!--- Inicio BORRADO --->			
					<cfquery datasource="#session.DSN#">
						delete from DDSalidaProd
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and ID_dsalprod in (#ValueList(rsTMPdet.ID_dsalprod)#) 
					</cfquery>
					
					<cfquery datasource="#session.DSN#">
						delete from DSalidaProd
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and ID_salprod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">
					</cfquery>		
				<!--- Fin BORRADO --->	
			
				<!--- Ciclo para la insercion del detalle --->
				<cfset cantIteracciones = form.cantReg>
				<cfloop from="1" to="#cantIteracciones#" index="i">
					<cfquery datasource="#session.DSN#">
						insert INTO DSalidaProd 
							(Ecodigo, ID_salprod, Alm_ai, Aid, Lectura_control, Unidades_vendidas, Unidades_despachadas, Unidades_calibracion, Precio, Ingreso, Descuento, DSPimpuesto, BMUsucodigo)
						values (
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['almacen_#i#']#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['articulo_#i#']#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Lectura_control_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_vendidas_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_despachadas_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#Replace(form['Unidades_calibracion_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['precio_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['bruto_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['desc_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['DSPimpuesto_#i#'],',','')#">, 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
	
					</cfquery>			
				</cfloop>	
			</cfif>									
		</cfif>						

		<!--- Reinsercion de la tabla DDSalidaProd para registrar los movimientos de ventas de cada uno de los vendedores de pista
			pero con el nuevo id generado del detalle despues de realizado el evento de cambio del detalle --->
			<cfquery name="rsTMPdet2" datasource="#session.DSN#">
				Select ID_dsalprod,Aid,ID_salprod,Ecodigo
				from DSalidaProd
				where Ecodigo= #session.Ecodigo#
					and ID_salprod=<cf_jdbcquery_param value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
					and (Unidades_vendidas + Unidades_despachadas) > 0
					and Aid in (#ValueList(rsTMPArt.Aid)#)
			</cfquery>
			<cfif isdefined('rsTMPdet2') and rsTMPdet2.recordCount GT 0>
				<cfset rsSalidasT = QueryNew("ID_dsalprod, ESVid, Aid, DDScantidad, BMUsucodigo, BMfechaalta")>
				<cfloop query="rsTMP">
					<cfquery name="rsTMPdetCods" dbtype="query" maxrows="1">
						Select ID_dsalprod
						from rsTMPdet2
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
							and Aid=<cfqueryparam value="#rsTMP.Aid#" cfsqltype="cf_sql_numeric">
					</cfquery>		
					
					<cfif isdefined('rsTMPdetCods') and rsTMPdetCods.recordCount GT 0>
						<cfset rsTemp = QueryAddRow(rsSalidasT,1)>
						<cfset QuerySetCell(rsSalidasT,"ID_dsalprod",#rsTMPdetCods.ID_dsalprod#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"ESVid",#rsTMP.ESVid#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"Aid",#rsTMP.Aid#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"DDScantidad",#rsTMP.DDScantidad#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"BMUsucodigo","#rsTMP.BMUsucodigo#",rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"BMfechaalta","#rsTMP.BMfechaalta#",rsTMP.CurrentRow)>
					</cfif>
				</cfloop>
			</cfif>							
				
			<cfif isdefined('rsSalidasT') and rsSalidasT.recordCount GT 0>
				<cfloop query="rsSalidasT">
					<cfquery datasource="#session.DSN#">
						insert into DDSalidaProd 
							(Ecodigo, ID_dsalprod, ESVid, Aid, DDScantidad, BMUsucodigo, BMfechaalta)
						values (
							<cfqueryparam 	value="#session.Ecodigo#" 			cfsqltype="cf_sql_integer" >
							, <cfqueryparam value="#rsSalidasT.ID_dsalprod#" 	cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.ESVid#" 			cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.Aid#" 			cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.DDScantidad#" 	cfsqltype="cf_sql_float">
							, <cfqueryparam value="#rsSalidasT.BMUsucodigo#" 	cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.BMfechaalta#" 	cfsqltype="cf_sql_timestamp">)
					</cfquery>					
				</cfloop>
			</cfif>
		</cfif>				
	<cfelseif isdefined("Form.btnBorrar")>
		<!-- Borra Registro de ventas por vendedores -->
		<cfquery datasource="#session.DSN#">
			delete from DDSalidaProd
			where ID_dsalprod in (
					select ID_dsalprod
					from DSalidaProd
					where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
					)
		</cfquery>
		<!--- Borra Detalles de las ventas --->
		<cfquery datasource="#session.DSN#">
			delete from DSalidaProd
			where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
		</cfquery>		
		
		<!--- Borra los totales de Debitos y Creditos de las ventas --->
		<cfquery datasource="#session.DSN#">
			delete from TotDebitosCreditos
			where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
		</cfquery>		

		<!--- Borra el encabezado de las ventas --->
		<cfquery datasource="#session.DSN#">
			delete from ESalidaProd
			where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and ID_salprod=<cfqueryparam value="#form.ID_salprod#" cfsqltype="cf_sql_numeric">
		</cfquery>		
	</cfif>
<cfelse>
	<cfset varAction = 'capturaSalidas.cfm'>
</cfif>

<form action="<cfoutput>#varAction#</cfoutput>" method="post" name="sql">
	<input name="f_Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfoutput>#form.Ocodigo#</cfoutput></cfif>">
	<input name="Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfoutput>#form.Ocodigo#</cfoutput></cfif>">	
	<input name="pista" type="hidden" value="<cfif isdefined("form.pista") and len(trim(form.pista))><cfoutput>#form.pista#</cfoutput></cfif>">	
	<input name="turno" type="hidden" value="<cfif isdefined("form.turno") and len(trim(form.turno))><cfoutput>#form.turno#</cfoutput></cfif>">	
	<input name="fSPfecha" type="hidden" value="<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))><cfoutput>#form.SPfecha#</cfoutput></cfif>">	
	<cfif not isdefined('form.btnAgregar') and not isdefined('form.btnBorrar') and isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
		<input name="ID_salprod" type="hidden" value="<cfoutput>#form.ID_salprod#</cfoutput>">		
	</cfif>
	<cfif isdefined('form.btnAgregar') and isdefined('altaSalida')>
		<input name="ID_salprod" type="hidden" value="<cfoutput>#altaSalida.identity#</cfoutput>">			
	</cfif>	

	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<cfif isdefined('form.btnBorrar')>
		<input name="btnConsultar" type="hidden" value="Consultar">
	</cfif>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>