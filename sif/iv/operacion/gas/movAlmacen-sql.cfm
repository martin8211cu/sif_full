<cfset varAction = 'movAlmacen-Mant.cfm'>
 
<cfif not isdefined("Form.btnCancelar")>
	<cfif isdefined("Form.btnGuardar")>
		<cfif isdefined('form.cantReg') and form.cantReg NEQ '' and form.cantReg GT 0 and isdefined('form.EMAid') and form.EMAid NEQ ''>
 			<cfif isdefined('form.EMAid') and form.EMAid NEQ ''>
 				<cf_dbtimestamp datasource="#session.dsn#"
								table="EMAlmacen"
								redirect="#varAction#"
								timestamp="#form.ts_rversion#"
								field1="EMAid" 
								type1="numeric" 
								value1="#form.EMAid#">

				<cfquery name="update" datasource="#session.DSN#">
					update EMAlmacen
						set EMAobs = <cfqueryparam value="#form.EMAobs#" cfsqltype="cf_sql_varchar">
						, BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
					where EMAid = <cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
						and Ecodigo= #session.Ecodigo# 
				</cfquery>	
			</cfif>

			<cfquery name="rsTMP" datasource="#session.DSN#">
				SELECT d.DMAid,d.EMAid, d.Aid as codAlmOri, d.Art_Aid, Turno_id, ap.Aid, ALMPcantidad, ap.ALMPdoc, ap.BMUsucodigo, ap.BMfechaalta
				from ALMPistas ap
					inner join DMAlmacen d
						on d.Ecodigo=ap.Ecodigo
							and d.DMAid=ap.DMAid
							and d.EMAid=<cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
				
				where ap.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>	
			
			<cfif isdefined('rsTMP') and rsTMP.recordCount GT 0>
				<cfquery name="rsTMPArt" dbtype="query">
					Select distinct Art_Aid
					from rsTMP
				</cfquery>
			</cfif>	
			<cfif isdefined('rsTMPArt') and rsTMPArt.recordCount GT 0>
				<cfquery name="rsTMPdet" datasource="#session.DSN#">
					Select DMAid,Art_Aid,EMAid,Ecodigo
					from DMAlmacen
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and EMAid=<cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
						and Art_Aid in (#ValueList(rsTMPArt.Art_Aid)#)
				</cfquery>
			</cfif>
				
			<!--- Inicio BORRADO --->						
			<cfif isdefined('rsTMPdet') and rsTMPdet.recordCount GT 0>
				<cfquery datasource="#session.DSN#">
					delete from ALMPistas
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and DMAid in (#ValueList(rsTMPdet.DMAid)#) 
				</cfquery>
			</cfif>	
			
			<cfquery datasource="#session.DSN#">
				delete from DMAlmacen
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and EMAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
			</cfquery>		
			<!--- Fin BORRADO --->				
				
			<!--- Ciclo para la insercion del detalle --->
			<cfset cantIteracciones = form.cantReg>
			<cfloop from="1" to="#cantIteracciones#" index="i">
				<cfquery datasource="#session.DSN#">
					insert INTO DMAlmacen 
						(EMAid, Aid, Art_Aid, Ecodigo, DMAinvIni, DMAcompra, DMAprecio, DMAinvFin, DMAdevol, DMAinvFisico, DMAdoc, BMUsucodigo, BMfechaalta)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['almacenOri_#i#']#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['articulo_#i#']#">
						, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DMAinvIni_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DMAcompra_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form['DMAprecio_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DMAinvFin_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DMAdevol_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form['DMAinvFisico_#i#'],',','')#">
						, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['DMAdoc_#i#']#">
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						, <cf_dbfunction name="now">)
				</cfquery>			
			</cfloop>
	

		<!--- Reinsercion de la tabla ALMPistas para registrar los movimientos de productos del almacen principal al almacen de las pistas
			pero con el nuevo id generado del detalle despues de realizado el evento de cambio del detalle --->
			<cfif isdefined('rsTMPdet') and rsTMPdet.recordCount GT 0>
				<cfquery name="rsTMPdet2" datasource="#session.DSN#">
					Select DMAid,Art_Aid,EMAid,Ecodigo
					from DMAlmacen
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and EMAid=<cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
						and Art_Aid in (#ValueList(rsTMPArt.Art_Aid)#)
				</cfquery>			
			</cfif>
			<cfif isdefined('rsTMPdet2') and rsTMPdet2.recordCount GT 0>
				<cfset rsSalidasT = QueryNew("DMAid, Turno_id, codAlmOri, Aid, Art_Aid, ALMPcantidad, ALMPdoc, BMUsucodigo, BMfechaalta")>

				<cfloop query="rsTMP">
					<cfquery name="rsTMPdetCods" dbtype="query" maxrows="1">
						Select DMAid
						from rsTMPdet2
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and EMAid=<cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
							and Art_Aid=<cfqueryparam value="#rsTMP.Art_Aid#" cfsqltype="cf_sql_numeric">
					</cfquery>		
					
					<cfif isdefined('rsTMPdetCods') and rsTMPdetCods.recordCount GT 0>
						<cfset rsTemp = QueryAddRow(rsSalidasT,1)>			
						<cfset QuerySetCell(rsSalidasT,"DMAid",#rsTMPdetCods.DMAid#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"Turno_id",#rsTMP.Turno_id#,rsTMP.CurrentRow)>					
						<cfset QuerySetCell(rsSalidasT,"codAlmOri",#rsTMP.codAlmOri#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"Aid",rsTMP.Aid,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"Art_Aid",#rsTMP.Art_Aid#,rsTMP.CurrentRow)>
						<cfset QuerySetCell(rsSalidasT,"ALMPcantidad",#rsTMP.ALMPcantidad#,rsTMP.CurrentRow)>			
						<cfset QuerySetCell(rsSalidasT,"ALMPdoc",#rsTMP.ALMPdoc#,rsTMP.CurrentRow)>			
						<cfset QuerySetCell(rsSalidasT,"BMUsucodigo","#rsTMP.BMUsucodigo#",rsTMP.CurrentRow)>								
						<cfset QuerySetCell(rsSalidasT,"BMfechaalta","#rsTMP.BMfechaalta#",rsTMP.CurrentRow)>			
					</cfif>
				</cfloop>
			</cfif>
			
			<cfif isdefined('rsSalidasT') and rsSalidasT.recordCount GT 0>
				<cfloop query="rsSalidasT">
					<cfquery datasource="#session.DSN#">
						insert into ALMPistas 
							(Ecodigo, DMAid, Turno_id, Aid, Art_Aid, ALMPcantidad, ALMPdoc, BMUsucodigo, BMfechaalta)
						values (
							 #session.Ecodigo# 
							, <cfqueryparam value="#rsSalidasT.DMAid#" 			cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.Turno_id#" 		cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.Aid#" 			cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.Art_Aid#" 		cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.ALMPcantidad#" 	cfsqltype="cf_sql_float">
							, <cfqueryparam value="#rsSalidasT.ALMPdoc#" 		cfsqltype="cf_sql_varchar">
							, <cfqueryparam value="#rsSalidasT.BMUsucodigo#" 	cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#rsSalidasT.BMfechaalta#" 	cfsqltype="cf_sql_timestamp">)
					</cfquery>					
				</cfloop>
			</cfif>		
		</cfif>
	<cfelseif isdefined("Form.btnAplicar")>
		<!--- Para postear los movimientos inter-almacen entre el almacén principal al almacen de las pistas --->
		<cfif isdefined('form.EMAid') and form.EMAid NEQ ''>
			<cfquery name="data" datasource="#session.DSN#">
				Select a.EMAfecha,a.EMAid, b.Aid as almOri,b.Art_Aid as articulo,c.ALMPcantidad, c.Aid as almDest, c.Turno_id, c.ALMPdoc
				from EMAlmacen a
					inner join DMAlmacen b
						on b.Ecodigo=a.Ecodigo
							and b.EMAid=a.EMAid
				
					inner join ALMPistas c
						on c.Ecodigo=b.Ecodigo
							and c.DMAid=b.DMAid
							and c.ALMPcantidad > 0
				
				where a.Ecodigo =  #session.Ecodigo# 
					and a.EMAid=<cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
					and a.EMAestado=0
				order by Turno_id
			</cfquery>

			<cfif data.recordcount gt 0>
				<cfquery name="dataTurnos" dbtype="query">
					select distinct Turno_id,ALMPdoc,almOri,almDest
					from data
				</cfquery>
				
				<cfif isdefined('dataTurnos') and dataTurnos.recordCount GT 0>
					<cfset contEnc = 0>
					<cfset listaIds = ''>
					<cfloop query="dataTurnos">
						<!--- Llenado del encabezado del mov interAlmacen --->	
						<cfquery name="dataTurnosCods" dbtype="query" maxrows="1">
							select ALMPdoc,almOri,almDest
							from data
							where Turno_id=<cfqueryparam value="#dataTurnos.Turno_id#" cfsqltype="cf_sql_numeric">
						</cfquery>						
						
						<cfif isdefined('dataTurnosCods') and dataTurnosCods.recordCount GT 0>
							<cftransaction>
								<cfquery name="InsEMinteralmacen" datasource="#session.DSN#">
									insert into EMinteralmacen (Ecodigo, EMalm_Orig, EMalm_Dest, EMdoc, EMusu, EMresp, EMfecha)
									values (
										 #session.Ecodigo# ,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTurnosCods.almOri#">, 
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTurnosCods.almDest#">, 
										<cfqueryparam value="#dataTurnosCods.ALMPdoc#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
										<cfqueryparam value="#data.EMAfecha#" cfsqltype="cf_sql_timestamp">				
									)
									<cf_dbidentity1 datasource="#session.DSN#">
								</cfquery>
								<cf_dbidentity2 datasource="#session.DSN#" name="InsEMinteralmacen">
							</cftransaction>		
								
							<cfif listaIds EQ ''>
								<cfset listaIds = InsEMinteralmacen.identity>
							<cfelse>
								<cfset listaIds = listaIds & ',' & InsEMinteralmacen.identity>							
							</cfif>					
						</cfif>
						
						<!--- Llenado del detalle del mov interAlmacen --->
						<cfif isdefined('InsEMinteralmacen') and InsEMinteralmacen.recordCount GT 0>
							<cfquery name="dataTurnosDet" dbtype="query">
								select *
								from data
								where Turno_id=<cfqueryparam value="#dataTurnos.Turno_id#" cfsqltype="cf_sql_numeric">
							</cfquery>							
						
							<cfif isdefined('dataTurnosDet') and dataTurnosDet.recordCount GT 0>
								<cfloop query="dataTurnosDet">
									<cfquery datasource="#session.DSN#">
										insert into DMinteralmacen (EMid, DMAid, DMcant)
										values (
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#InsEMinteralmacen.identity#">, 
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#dataTurnosDet.articulo#">, 
											<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(dataTurnosDet.ALMPcantidad,',','')#">
										)
									</cfquery>						
								</cfloop>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>

				<!--- Posteo del movimiento interalmacen --->
				<cfloop From = "1" TO = "#ListLen(listaIds)#" INDEX = "Counter">
 					<cfinvoke component="sif.Componentes.IN_MovInterAlmacen" method="MovInterAlmacen">
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="EMid"    value="#ListGetAt(listaIds, Counter)#"/>				
						<cfinvokeargument name="usuario" value="#Session.usuario#"/>	
						<cfinvokeargument name="debug"   value="N"/>							
					</cfinvoke>	 
				</cfloop>
			</cfif>
			
 			<!--- No se hace registro contable ni de inventario porque ese proceso ya lo realizó el modulo de CxP y compras --->
 			<cfquery name="update" datasource="#session.DSN#">
				update EMAlmacen
					set EMAestado = 10 
				where EMAid = <cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
					and Ecodigo= #session.Ecodigo# 
			</cfquery>			
			
			<cfset varAction = 'movAlmacen.cfm'>
		</cfif>
	<cfelseif isdefined("Form.btnBorrar")>
		<!--- Borra Registro de Salidas del Almacen Principal al de las pistas --->
		<cfquery datasource="#session.DSN#">
			delete from ALMPistas
			where DMAid in (
					Select DMAid
					from DMAlmacen
					where Ecodigo= #session.Ecodigo# 
						and EMAid = <cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">
				)
		</cfquery>
		<!--- Borra Detalles de Entradas al Almacen principal --->
		<cfquery datasource="#session.DSN#">
			delete from DMAlmacen
			where Ecodigo= #session.Ecodigo# 
				and EMAid = <cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">		
		</cfquery>		
		<!--- Borra el encabezado de Entradas al Almacen principal --->
		<cfquery datasource="#session.DSN#">
			delete from EMAlmacen
			where Ecodigo= #session.Ecodigo# 
				and EMAid = <cfqueryparam value="#form.EMAid#" cfsqltype="cf_sql_numeric">		
		</cfquery>	
		<cfset varAction = 'movAlmacen.cfm'>	
	</cfif>
<cfelse>
	<cfset varAction = 'movAlmacen.cfm'>
</cfif>

<form action="<cfoutput>#varAction#</cfoutput>" method="post" name="sql">
		<input name="f_Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfoutput>#form.Ocodigo#</cfoutput></cfif>">
	<cfif not isdefined('form.btnBorrar')>
		<input name="Ocodigo"  type="hidden"  value="<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfoutput>#form.Ocodigo#</cfoutput></cfif>">	
	</cfif>
		<input name="fSPfecha" type="hidden"  value="<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))><cfoutput>#form.SPfecha#</cfoutput></cfif>">	
		<input name="EMAfecha" type="hidden"  value="<cfif isdefined("form.EMAfecha") and len(trim(form.EMAfecha))><cfoutput>#form.EMAfecha#</cfoutput></cfif>">		
	<cfif not isdefined('form.btnAgregar') and not isdefined('form.btnBorrar') and isdefined('form.EMAid') and form.EMAid NEQ ''>
		<input name="EMAid" type="hidden" value="<cfoutput>#form.EMAid#</cfoutput>">		
	</cfif>
	<cfif isdefined('form.btnAgregar') and isdefined('altaSalida')>
		<input name="EMAid" type="hidden" value="<cfoutput>#altaSalida.identity#</cfoutput>">			
	</cfif>	
	     <input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<cfif isdefined('form.btnAplicar')>
		<input name="btnConsultar" type="hidden" value="Consultar">
	</cfif>
</form>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>