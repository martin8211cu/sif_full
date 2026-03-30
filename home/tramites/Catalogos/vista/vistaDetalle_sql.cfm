<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->

<!--- <cf_dump var="#form#"> --->
<cfset modo = "CAMBIO">


<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->

<cfquery datasource="#session.tramites.dsn#" name="primergrupo">
	select id_vistagrupo
	from DDVistaGrupo
	where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
</cfquery>


<cftransaction>
	<cfif primergrupo.recordCount EQ 0>
		<cfquery datasource="#session.tramites.dsn#" name="primergrupo">
			insert into DDVistaGrupo
				(
					 id_vista         
					,etiqueta        
					,BMfechamod
					,BMUsucodigo
				)
			values
				(
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
					,'GENERAL'
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
			<cf_dbidentity1 datasource="#session.tramites.dsn#" name="primergrupo">
		</cfquery>
		<cf_dbidentity2 datasource="#session.tramites.dsn#" name="primergrupo">
		<cfset primergrupo = primergrupo.identity>
	<cfelse>
		<cfset primergrupo = primergrupo.id_vistagrupo>
	</cfif>
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("idcampo_", i) NEQ 0>				
			<cfset LvarIdcampo = Mid(i, 9, Len(i))><!--- --->

			<cfif i is "">
			
			<cfelseif len(trim(i)) gt 0>	
			 <!---<cfdump var="#len(trim(Evaluate('form.idcampo_'&LvarIdcampo)))# len del valor del form  |">
			 <cfdump var="#len(trim(i))# len de i  |">
			 <cfdump var="#Evaluate('form.idcampo_'&LvarIdcampo)# valor del form  | ">
			<cfdump var="#LvarIdcampo# idCampo  |">  --->
			
				<cfquery name="rslista" datasource="#session.tramites.dsn#">
					select distinct
						dd.id_vista,	
						a.id_campo, 
						a.id_tipocampo, 
						a.nombre_campo, 
						b.nombre_tipo,
						dd.orden_campo,
						dd.es_encabezado,
						dd.etiqueta_campo,
						dd.ts_rversion 
						
					from  DDTipoCampo a
						left outer join  DDVistaCampo dd
							on  a.id_campo = dd.id_campo
							and dd.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
						 inner join DDTipo b
							on b.id_tipo = a.id_tipocampo
						
					<!--- where a.id_tipo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tipo#"> --->
					where dd.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
					and dd.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdcampo#">
					
				</cfquery>
				<!--- <cfdump var="#rslista.recordcount# recordcount de la lista  |">
				<cfdump var="#isdefined("rslista")# isssdefine"><br> --->
				<cfif len(trim(i)) gt 0 and len(trim(Evaluate('form.idcampo_'&LvarIdcampo))) eq 0 
					and isdefined("rslista") and rslista.recordcount GT 0>
				<!--- Borrar --->
					<cfquery datasource="#session.tramites.dsn#">
						delete DDVistaCampo 
						where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
						and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdcampo#">
					</cfquery>	
				<!--- <cfabort> --->
				</cfif>
				
					
				<cfif len(trim(i)) gt 0 and isdefined("rslista") and rslista.recordcount EQ 1>
					<cfloop collection="#Form#" item="c">
						<cfif FindNoCase("orden_", c) NEQ 0>
							<cfset LvarCampoOrden = Mid(c, 7, Len(c))>
							<cfif trim(LvarIdcampo) EQ trim(LvarCampoOrden)>
								<cfset orden_campo = Evaluate('form.orden_'&LvarIdcampo)>
								<cfif Len(Trim(orden_campo)) EQ 0>
									<cfquery name="rsBuscaNombreC" datasource="#session.tramites.dsn#">
										select coalesce(orden_campo,0)as orden_campo
										from DDTipoCampo
										where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdcampo#">
									</cfquery>
									<cfset orden_campo = rsBuscaNombreC.orden_campo>
								</cfif>
								<cfif Len(Trim(orden_campo)) EQ 0>
									<cfset orden_campo = 0>
								</cfif>
							
								<cfquery datasource="#session.tramites.dsn#">
									update DDVistaCampo set
										orden_campo = <cfqueryparam cfsqltype="cf_sql_integer" value="#orden_campo#" null="#Len(Trim(orden_campo)) EQ 0#">
										<cfif isdefined("form.chk_enc_#LvarIdcampo#")>
											, es_encabezado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('form.chk_enc_'&LvarIdcampo)#">
										<cfelseif isdefined("form.chk_det_#LvarIdcampo#")>
											, es_encabezado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('form.chk_det_'&LvarIdcampo)#">
										</cfif>
										, es_obligatorio = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.chk_req_' & LvarIdcampo)#">
										, id_vistagrupo = 
										<cfif form.es_requisito eq 0 AND Len(form['id_vistagrupo_'&LvarIdcampo])>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['id_vistagrupo_'&LvarIdcampo]#">
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#primergrupo#">
										</cfif>
									where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">
										and id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdcampo#">
								</cfquery>
							</cfif><!--- LvarCampoOrden --->
						</cfif>
					</cfloop>
				<!--- </cfif> --->
				<!--- insert --->
				<cfelseif len(trim(i)) gt 0 and isdefined("rslista") and rslista.recordcount EQ 0>
				<cfloop collection="#Form#" item="cInsert">
					<cfif FindNoCase("orden_", cInsert) NEQ 0>
						<cfset LvarCampoOrden = Mid(cInsert, 7, Len(cInsert))>
						<cfif trim(LvarIdcampo) EQ trim(LvarCampoOrden)>
							<cfquery name="rsBuscaNombreC" datasource="#session.tramites.dsn#">
								select nombre_campo, coalesce(orden_campo,0) as orden_campo
								from DDTipoCampo
								where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdcampo#">
							</cfquery>
							<cfset orden_campo = form['orden_'&LvarCampoOrden]>
							<cfif Len(Trim(orden_campo)) EQ 0>
								<cfset orden_campo = rsBuscaNombreC.orden_campo>
							</cfif>
							
							<cfquery name="rsInsertDDVistaCampo" datasource="#session.tramites.dsn#">
								insert into DDVistaCampo (id_vista, id_campo, 
									id_vistagrupo,
									orden_campo, 
									es_encabezado, es_obligatorio, etiqueta_campo, BMfechamod, BMUsucodigo)	
								values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_vista#">,  <!--- id_vista =  --->
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCampoOrden#">, <!--- id_campo =  --->
										<cfif form.es_requisito eq 0 and Len(trim(form['id_vistagrupo_'&LvarIdcampo]))>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#form['id_vistagrupo_'&LvarIdcampo]#">
										<cfelse>
											<cfqueryparam cfsqltype="cf_sql_numeric" value="#primergrupo#">
										</cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#orden_campo#">, <!--- orden_campo =  --->
										<cfif isdefined("form.chk_enc_#LvarIdcampo#")>
											<cfqueryparam cfsqltype="cf_sql_bit" value="#Evaluate('form.chk_enc_'&LvarIdcampo)#"> <!--- es_encabezado =  --->
										<cfelseif isdefined("form.chk_det_#LvarIdcampo#")>
											<cfqueryparam cfsqltype="cf_sql_bit" value="#Evaluate('form.chk_det_'&LvarIdcampo)#"> <!--- es_encabezado =  --->
										</cfif>,
										<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.chk_req_' & LvarIdcampo)#">,<!--- es_requerido --->
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBuscaNombreC.nombre_campo#">, <!--- etiqueta_campo =  --->
										<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, <!--- BMfechamod =  --->
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> <!--- BMUsucodigo =  --->
								)
							</cfquery>
						</cfif><!--- LvarCampoOrden --->
					</cfif>
				</cfloop>
				</cfif> <!--- <cfelseif len(trim(i)) gt 0 and isdefined("rslista") and rslista.recordcount EQ 0> --->
			</cfif>
		</cfif>
	</cfloop>
</cftransaction>
<!--- <cf_dump var="#form#"> --->
<cflocation addtoken="no" url="vistaDetalle_form2.cfm?tab=2&id_tipo=#form.id_tipo#&id_vista=#id_vista#&es_requisito=#form.es_requisito#">
