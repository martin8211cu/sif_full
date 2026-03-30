<cfset modo = 'ALTA'>
<cfset vacio = true>

<!------------------------------------- if del Mantenimiento de fechas de inactivación de la cuenta  -------------------------------->
<cfif isDefined("btnAceptar") or isDefined("btnCambiar") or isDefined("btnBorrar.X") >
	<cfif isDefined("btnAceptar") >
		<cfquery name="A_CInactivas" datasource="#Session.DSN#">
			insert INTO  CCInactivas (Ccuenta, CCIdesde, CCIhasta, Usucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CCIdesde)#">, 
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CCIhasta)#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)		
		</cfquery>
		
		<cfelseif isDefined("btnCambiar")>
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CCInactivas" 
				redirect="CuentasContables.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
				timestamp="#form.ts_rversion#"
				field1="Ccuenta,numeric,#form.Ccuenta#"
				field2="CCIid,numeric,#form.CCIid#">
							
			<cfquery name="C_CInactivas" datasource="#Session.DSN#">
				update CCInactivas set
					CCIdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CCIdesde)#">, 
					CCIhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.CCIhasta)#">, 
					Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
				  and CCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCIid#">		
			</cfquery>
		<cfelseif isDefined("btnBorrar.X")>
			<cfquery name="B_CInactivas" datasource="#Session.DSN#">
				delete from CCInactivas 
				where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
				  and CCIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCIid#">		
			</cfquery>
		</cfif>
	<cfset modo = "CAMBIO">
<!------------------------------------------ if del mantenimiento de la cuenta contable ----------------------------------------->	
<cfelseif isDefined("btnCambiar") >
	<cfset modo = "CAMBIO">
<cfelseif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfif isDefined("Form.CpadreLabel") and Len(Trim(Form.CpadreLabel) NEQ 0 )>
			<cfset vacio = false>
		</cfif>
	</cfif>
	<cfif isdefined("Form.Baja")>
		<cfif isDefined("Form.CpadreLabel") and Len(Trim(Form.CpadreLabel) NEQ 0 )>
			<cfset vacio = false>
		</cfif>
	</cfif>
	<cfif isdefined("Form.Cambio")>
		<cfif isDefined("Form.CpadreLabel") and Len(Trim(Form.CpadreLabel) NEQ 0 )>
			<cfset vacio = false>
		</cfif>
	</cfif>

	<cftry>
		<cfif isdefined("Form.Alta")>		
			<cfif not vacio>
				<cftransaction>			
					<cfquery name="A_CuentasContables" datasource="#Session.DSN#">
						insert INTO  CContables ( Ecodigo, Cmayor, Cformato, Cdescripcion, Cpadre, Cmovimiento, Mcodigo, Cbalancen, Cbalancenormal )
						values ( <cfqueryparam cfsqltype="cf_sql_integer"	value="#Session.Ecodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char"		value="#Form.Cmayor#">,
								 <cfqueryparam cfsqltype="cf_sql_char"		value="#Form.Cformato#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Form.Cdescripcion#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric"	value="#Form.Cpadre#">,
								 'S',
								 <cfqueryparam cfsqltype="cf_sql_integer"	value="#Form.Mcodigo#">,
								 <cfqueryparam cfsqltype="cf_sql_char"		value="#Form.Cbalancen#">,
								 <cfif isdefined('Form.Cbalancen') and Form.Cbalancen EQ 'D'>1<cfelse>-1</cfif>
						)  
						<cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="A_CuentasContables">
				
					<cfquery datasource="#Session.DSN#">
						update CContables set Cmovimiento='N'
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">							
					</cfquery>
					
					<cfif isdefined('Form.tipoMascara') and Form.tipoMascara EQ ''>
						<cfquery name="A_CPVigencia" datasource="#Session.DSN#">
							Select CPVid
							from CPVigencia
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
								and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between CPVdesde 
									and coalesce(CPVhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">)
						</cfquery>
						<cfif A_CPVigencia.CPVid EQ "">
							<cf_errorCode	code = "50220" msg = "No se encontró Vigencia para generar la Cuenta Financiera">
						</cfif>
						
						<cfquery name="Sel_CFinanciera" datasource="#Session.DSN#">
							Select CFformato, CFcuenta as CFpadre
							from CFinanciera
							where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">
							  and CPVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
						</cfquery>					

						<cfif Sel_CFinanciera.CFpadre NEQ "">
							<cfquery datasource="#Session.DSN#">
								update CFinanciera set CFmovimiento='N'
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Sel_CFinanciera.CFpadre#">
							</cfquery>
						</cfif>
	
						<cfquery name="A_CFinanciera" datasource="#Session.DSN#">
							insert INTO CFinanciera(CPVid,Ccuenta,Ecodigo,Cmayor,CFformato,CFdescripcion,CFmovimiento,CFpadre)
							values(
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CuentasContables.identity#">
								, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
								, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
								, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cformato#">
								, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
								<cfif isdefined('Form.Cmovimiento') and Form.Cmovimiento NEQ ''>
									, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmovimiento#">
								<cfelse>
									, 'S'
								</cfif>
								<cfif isdefined('Sel_CFinanciera') and Sel_CFinanciera.recordCount GT 0 and Sel_CFinanciera.CFpadre NEQ ''>
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Sel_CFinanciera.CFpadre#">
								<cfelse>
									, null				
								</cfif>
								)					
						</cfquery>					
					
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinancieraC" method="GeneraCuentaFinanciera" 
							Ecodigo="#Session.Ecodigo#" 
							Cmayor="#form.Cmayor#"
							Cformato="#form.Cformato#"
							debug="N"
							conexion="#Session.DSN#">
						</cfinvoke>
					</cfif>
				</cftransaction>
			</cfif>
				
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfif not vacio>			
				<cfquery name="Cont1" datasource="#Session.DSN#">
					select count(Ccuenta) as cantCCont
					from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">				
				</cfquery>
				<cfif isdefined('Cont1') and Cont1.cantCCont GT 0>
					<cf_errorCode	code = "50221" msg = "La cuenta posee cuentas hijas, no se puede borrar">
				</cfif>
								
				<cfquery name="Cont2" datasource="#Session.DSN#">
					select count(Ccuenta) as cantCCont					
					from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">
				</cfquery>
				
				<cfif isdefined('Form.tipoMascara') and Form.tipoMascara EQ ''>
					<cfquery name="A_CPVigencia" datasource="#Session.DSN#">
						Select CPVid
						from CPVigencia
						where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
							and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between CPVdesde 
								and coalesce(CPVhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">)
					</cfquery>
					<cfif A_CPVigencia.CPVid EQ "">
						<cf_errorCode	code = "50222" msg = "No se encontró Vigencia para modificar la Cuenta Financiera">
					</cfif>

					<cfquery name="rsSQL" datasource="#Session.DSN#">
						select CFcuenta
						  from CFinanciera
						 where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   and Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
						   and CPVid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
					</cfquery>
					<cfif rsSQL.CFcuenta NEQ "">
						<cfquery name="delCatCuenta" datasource="#Session.DSN#">
							delete from PCDCatalogoCuentaF
							where CFcuenta		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.CFcuenta#"> 
							   or CFcuentaniv	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.CFcuenta#"> 
						</cfquery>
						<cfquery name="delCFinanciera" datasource="#Session.DSN#">
							delete from CFinanciera
							 where CFcuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.CFcuenta#"> 
						</cfquery>				
					</cfif>
				</cfif>

				<cfquery name="delCatCuenta" datasource="#Session.DSN#">
					delete from PCDCatalogoCuenta 
					where Ccuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"> 
					   or Ccuentaniv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"> 
				</cfquery>
				<cfquery name="delCContables" datasource="#Session.DSN#">
					delete from CContables 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"> 
				</cfquery>
				  
				<cfquery name="SelCContables" datasource="#Session.DSN#">
					select 1 
					from CContables
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#"> 
				</cfquery>					  
				  
				<cfif isdefined('SelCContables') and SelCContables.recordCount EQ 0 
					and isdefined('Cont2') and Cont2.cantCCont EQ 1>
						<cfquery name="SelCContables" datasource="#Session.DSN#">
							update CContables 
							   set Cmovimiento='S'
							 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">							
						</cfquery>

						<cfif isdefined('Form.tipoMascara') and Form.tipoMascara EQ ''>
							<cfquery name="Sel_CFpadre" datasource="#Session.DSN#">
								Select CFcuenta as CFpadre
								from CFinanciera
								where Ecodigo	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  and Ccuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">
								  and CPVid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
							</cfquery>					
		
							<cfquery datasource="#Session.DSN#">
								update CFinanciera 
								   set CFmovimiento='S'
								 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								   and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Sel_CFpadre.CFpadre#">
							</cfquery>
						</cfif>
				</cfif>
			</cfif>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfif not vacio>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="CContables" 
					redirect="CuentasContables.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
					timestamp="#form.ts_rversion#"
					field1="Ccuenta,numeric,#form.Ccuenta#"
					field2="Ecodigo,numeric,#session.Ecodigo#">			

				<!----================ Si la cuenta contable tiene una sola cuenta financiera asociada =================----->
				<cfquery name="rsVerificaCtaF" datasource="#session.DSN#">
					select count(1) as ctsFinancieras
					from CFinanciera
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">   
				</cfquery>
				<cfif isdefined("rsVerificaCtaF") and rsVerificaCtaF.RecordCount NEQ 0 and rsVerificaCtaF.ctsFinancieras EQ 1>
					<!---===== Actualiza CContables.CdescripcionF con el valor anterior de CContables.Cdescripcion =======---->
					<cfquery datasource="#session.DSN#">
						update CContables
							set CdescripcionF = Cdescripcion 
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">  
					</cfquery>
					<!---====== Actualiza el CFinanciera.CFdescripcion con el valor de CContables.Cdescripcion =====----->
					<cfquery datasource="#session.DSN#">
						update CFinanciera 
							set CFdescripcion =  (
											select min(b.Cdescripcion)
											from CContables b
											where b.Ccuenta = CFinanciera.Ccuenta)
						where CFinanciera.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">	
						  and CFinanciera.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
				</cfif>
				<!----===========================================================================================---->	
				<cfquery name="SelCContables" datasource="#Session.DSN#">
					update CContables set 				
						Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
						Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">,											
						Cbalancen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cbalancen#">,
						Cbalancenormal = <cfif isdefined('Form.Cbalancen') and Form.Cbalancen EQ 'D'>1<cfelse>-1</cfif>
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">    
				</cfquery>

				<cfif isdefined('Form.tipoMascara') and Form.tipoMascara EQ ''>
					<cfquery name="Sel_CFinanciera" datasource="#Session.DSN#">
						Select 1
						from CFinanciera
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">    
					</cfquery>
					
					<cfquery name="Sel_CFpadre" datasource="#Session.DSN#">
						Select CFpadre
						from CFinanciera
						where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">
					</cfquery>
					<cfif isdefined('Sel_CFinanciera') and Sel_CFinanciera.recordCount GT 0>
						<cfquery datasource="#Session.DSN#">
							update CFinanciera set 				
								Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
								, CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cformato#">
								, CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
								<cfif isdefined('Form.Cmovimiento') and Form.Cmovimiento NEQ ''>
									, CFmovimiento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmovimiento#">
								</cfif>			
								<cfif isdefined('Sel_CFpadre') and Sel_CFpadre.recordCount GT 0 and Sel_CFpadre.CFpadre NEQ ''>
									, CFpadre = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Sel_CFpadre.CFpadre#">
								</cfif>
								, Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">    					
						</cfquery>
					<cfelse>
						<cfquery name="A_CPVigencia" datasource="#Session.DSN#">
							Select CPVid
							from CPVigencia
							where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and Cmayor=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between CPVdesde and coalesce(CPVhasta,'21000101')					
						</cfquery>
				
						<cfif isdefined('A_CPVigencia') and A_CPVigencia.recordCount GT 0>
							<cfquery name="A_CFinanciera" datasource="#Session.DSN#">
								insert INTO CFinanciera(CPVid,Ccuenta,Ecodigo,Cmayor,CFformato,CFdescripcion,CFmovimiento,CFpadre)
								values(
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.CPVid#">
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">									
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
									, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
									, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cformato#">
									, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
									<cfif isdefined('Form.Cmovimiento') and Form.Cmovimiento NEQ ''>
										, <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmovimiento#">
									<cfelse>
										, 'S'
									</cfif>
									, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cpadre#">)
							</cfquery>
						</cfif>					
					</cfif>
				</cfif>
			</cfif>
			
			<cfset modo="CAMBIO">
		<cfelseif  isdefined("Form.CambioPadre")>	
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CtasMayor" 
				redirect="CuentasContables.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#"
				timestamp="#form.ts_rversPadre#"
				field1="Cmayor,char,#form.Cmayor#"
				field2="Ecodigo,numeric,#session.Ecodigo#">

			<cfquery name="C_CtasMayor" datasource="#Session.DSN#">
				update CtasMayor set 
					<cfif isdefined("Form.Cdescripcion")>
						Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
					</cfif>
					Cbalancen= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cbalancen#">,
					CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>		

			<!----================ Si la cuenta contable tiene una sola cuenta financiera asociada =================----->
			<cfquery name="rsVerificaCtaF" datasource="#session.DSN#">
				select count(1) as ctsFinancieras
				from CFinanciera
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">   
			</cfquery>
			<cfif isdefined("rsVerificaCtaF") and rsVerificaCtaF.RecordCount NEQ 0 and rsVerificaCtaF.ctsFinancieras EQ 1>
				<!---===== Actualiza CContables.CdescripcionF con el valor anterior de CContables.Cdescripcion =======---->
				<cfquery datasource="#session.DSN#">
					update CContables
						set CdescripcionF = Cdescripcion 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">  
				</cfquery>
				<!---====== Actualiza el CFinanciera.CFdescripcion con el valor de CContables.Cdescripcion =====----->
				<cfquery datasource="#session.DSN#">
						update CFinanciera
						set CFdescripcion = (select b.Cdescripcion
											from CFinanciera a
											inner join CContables b
											on a.Ccuenta = b.Ccuenta 
											where a.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
											and a.Ecodigo = #session.Ecodigo#)
						where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">
						and Ecodigo = #session.Ecodigo#
				</cfquery>
			</cfif>
			<!----===========================================================================================---->	
			
			<cfquery name="C_CContables" datasource="#Session.DSN#">
				update CContables set 
					Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
					Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Mcodigo#">,											
					Cbalancen = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cbalancen#">,
					Cbalancenormal = <cfif isdefined('Form.Cbalancen') and Form.Cbalancen EQ 'D'>1<cfelse>-1</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>						
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfoutput>

<form action="CuentasContables.cfm?Cmayor=#Form.Cmayor#&Formato=#Form.formato#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined('modo')>#modo#</cfif>">
	<input name="Ccuenta" type="hidden" value="<cfif isdefined('Form.Ccuenta') and modo EQ 'CAMBIO'>#Form.Ccuenta#</cfif>">
	<input name="Cmayor" type="hidden" value="<cfif isdefined('Form.Cmayor')>#Form.Cmayor#</cfif>">
	<input name="Cpadre" type="hidden" value="<cfif isdefined('Form.Cpadre')>#Form.Cpadre#</cfif>">
	<input name="formato" type="hidden" value="<cfif isdefined('Form.formato')>#Form.formato#</cfif>">
	<input name="tipoMascara" type="hidden" value="<cfif isdefined('Form.tipoMascara')>#Form.tipoMascara#</cfif>">	
    <input type="hidden" name="Cmovimiento" value="<cfif isdefined('Form.Cmovimiento')>#Form.Cmovimiento#</cfif>"> 

	<cfif not isdefined("form.Nuevo")>
		<input name="Pagina" type="hidden" value="<cfif isdefined('Form.Pagina')>#Form.Pagina#</cfif>">	
	</cfif>

 </form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


