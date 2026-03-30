<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 09 de marzo del 2006
	Motivo: Correccion en error de navegacion en lista de documento de seleccion masiva.
			Se agreg un nuevo filtro, un rango de fechas. 
			Se agrego en el filtro de la lista la opcion de TODOS.
			
	Modificado por: Ana Villavicencio
	Fecha: 22 de febrero del 2006
	Motivo: Se agregaron campos  hidden para mantener los filtros de la seleccion de  facturas.

	Modificado por: Ana Villavicencio
	Fecha: 08 de diciembre del 2005
	Motivo: Cambio en el proceso de seleccin masiva de documentos para Registro de Pagos y Aplicacin de Documentos a Favor.
			Se crea una lista de documentos posibles para asignar al documento de trabajo.
		
 --->
<cfif isdefined('form.btnDistribuir')>
	<cfif isdefined('Form.Chk')>
		<cfset vn_mtodisponible = replace(form.mto_disponible,',','','all')>	<!----Variable con el monto digitado por el usuario ----->	
		<cftransaction>
			<cfloop list="#form.chk#" index="LvarChk">
				<cfset LvarCCTcodigo = listGetAt(LvarChk,1,"|")>
				<cfset LvarDdocumento = listGetAt(LvarChk,2,"|")>
				<cfif vn_mtodisponible LTE 0>	<!----1.Mto disponible mayor a 0---->
					<cfbreak>
				<cfelse>
					<cfquery name="rs" datasource="#session.DSN#">
						select CCTcodigo, Ddocumento, Mcodigo, Ccuenta, Dsaldo
						  from Documentos
						 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						   and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCCTcodigo#">
						   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarDdocumento#">
					</cfquery>
			
					<cfif isdefined("form.Pcodigo") and len(trim(form.Pcodigo))>
						<cfquery name="rsPagos" datasource="#session.DSN#">
							select min(pp.PPnumero) as PPnumero
							  from PlanPagos pp
							 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							   and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCCTcodigo#">
							   and Ddocumento	= <cfqueryparam cfsqltype="cf_sql_char" value="#LvarDdocumento#">
							   and pp.PPfecha_pago is null
						</cfquery>
						<cfif len(rsPagos.PPnumero)>
							<cfquery datasource="#session.DSN#">
								insert into DPagos (	
									Ecodigo, 
									CCTcodigo, 
									Pcodigo, 
									Doc_CCTcodigo, 
									Ddocumento, 
									Mcodigo, 
									Ccuenta, 											 
									DPtipocambio, 											
									DPmontoretdoc, 
									PPnumero,
									DPmonto,
									DPmontodoc, 
									DPtotal,
									BMUsucodigo
								) 
								values ( 
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#form.Pcodigo#">,					
									<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CCTcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ddocumento#">,					
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Mcodigo#">,
									<cfif len(trim(rs.Ccuenta))>
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ccuenta#">
									<cfelse>
										null
									</cfif>,								
									1.00,
									0.00,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagos.PPnumero#">,
									<cfif rs.Dsaldo LTE vn_mtodisponible>
										<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">
									<cfelse>
										<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">
									</cfif>	,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								) 
							</cfquery>
							<cfset vn_mtodisponible = vn_mtodisponible - rs.Dsaldo>
						</cfif>
					<cfelseif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>				 	
						<cfquery datasource="#session.DSN#">
							insert into DFavor(	
								Ecodigo, 
								CCTcodigo, 
								Ddocumento, 
								CCTRcodigo, 
								DRdocumento, 
								SNcodigo,
								Ccuenta,
								Mcodigo, 
								DFmonto,
								DFtotal,
								DFmontodoc,
								DFtipocambio,
								BMUsucodigo
							) 
							values ( 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.Ddocumento#">,					
								<cfqueryparam cfsqltype="cf_sql_char" value="#rs.CCTcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#rs.Ddocumento#">,					
								<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">,								
								<cfif len(trim(rs.Ccuenta))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Ccuenta#">
								<cfelse>
									null
								</cfif>,
								<cfif len(trim(rs.Mcodigo))> 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.Mcodigo#">
								<cfelse>
									null
								</cfif>,
								<cfif rs.Dsaldo LTE vn_mtodisponible>
									<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#rs.Dsaldo#">									
								<cfelse>
									<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#vn_mtodisponible#">									
								</cfif>,
								1.0,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">								
							) 
						</cfquery>

						<cfset vn_mtodisponible = vn_mtodisponible - rs.Dsaldo>
					</cfif>											
				</cfif>
			</cfloop>
            
            <cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>
                <cfquery datasource="#session.DSN#">
                    update EFavor
                    set EFtotal = 
                        (
                        select coalesce(sum(DFtotal),0.00)
                        from DFavor d
                        where d.Ecodigo = EFavor.Ecodigo
                        and d.CCTcodigo = EFavor.CCTcodigo
                        and d.Ddocumento = EFavor.Ddocumento
                        )
                    where EFavor.Ecodigo      = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and EFavor.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.CCTcodigo#">
                        and EFavor.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.Ddocumento#">	
                </cfquery>
	        </cfif>    
        </cftransaction>
        
        

		<cfif vn_mtodisponible LTE 0>	<!----1.Mto disponible mayor a 0---->
			<cflocation url="SeleccionMasiva.cfm?btnCerrar">
		</cfif>
		<cfset form.pn_disponible = vn_mtodisponible>
		<script language="javascript">
			opener.window.document.form1.F5.value = "F5";
		</script>
	</cfif>
</cfif>

<form name="form1" method="post" action="SeleccionMasiva.cfm">
	<cfoutput>
		<input name="SNcodigo" type="hidden" value="#form.SNcodigo#">
		<input name="Mcodigo" type="hidden" value="#form.Mcodigo#">
		<cfif isdefined('form.Ddocumento') and LEN(TRIM(form.Ddocumento))>
			<input name="Ddocumento" type="hidden" value="#form.Ddocumento#">
		<cfelseif isdefined('form.Pcodigo') and LEN(TRIM(form.Pcodigo))>
			<input name="Pcodigo" type="hidden" value="#form.Pcodigo#">
		</cfif>
		<input name="Fdesde" type="hidden" value="#form.Fdesde#">
		<input name="Fhasta" type="hidden" value="#form.Fhasta#">
        <input name="FDdocumento" type="hidden" value="#form.FDdocumento#">
		<input name="CCTcodigo" type="hidden" value="#form.CCTcodigo#">
		<input name="option" type="hidden" value="#form.option#">
		<input name="CCTcodigoDcto" type="hidden" value="#form.CCTcodigoDcto#">
		<input name="id_direccion" type="hidden" value="#form.id_direccion#">
		<input name="pn_disponible" type="hidden" value="#form.pn_disponible#">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
