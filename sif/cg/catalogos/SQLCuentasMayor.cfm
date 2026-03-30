<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 21 de julio del 2005
	Motivo: Se cambiaron las consulta para agregar el nuevo campo Crevaluable 
			de la tabla CtasMayor.
			
	Modificado por Gustavo Fonseca H.
		Fecha: 22-2-2006.
		Motivo: Cuando viene alta, devuelve cambio. se corrige el campo PCEMid de la tabla CPVigencia que tenia tipo integer y es numeric.
 --->

<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
		<cfif isdefined("Form.Alta")>
			<cfquery name="A_CuentasMayor" datasource="#Session.DSN#">			
				insert INTO CtasMayor (Ecodigo, Cmayor, Cdescripcion, CdescripcionA, Ctipo, Csubtipo, Cbalancen, CEcodigo, PCEMid, Cmascara, Crevaluable, CTCconversion, TCHid)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CdescripcionA#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
					<cfif Form.Ctipo EQ 'I'>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
					<cfelseif Form.Ctipo EQ 'G'>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo2#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cbalancen#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
					<cfif form.PCEMid NEQ '' AND form.PCEMid NEQ '0'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cmascara#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Revaluable#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCconversion#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHid#" null="#Len(Trim(form.TCHid)) is 0#">
				)   
			</cfquery>		

			<cfquery name="A_CContables" datasource="#Session.DSN#">
				insert INTO CContables(Ecodigo, Cmayor, Cformato, Mcodigo, Cdescripcion, Cmovimiento)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
					null,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
					<cfif form.PCEMid EQ "" OR form.PCEMid EQ "0">'S'<cfelse>'N'</cfif>
				)				
				<cf_dbidentity1 verificar_transaccion="no" datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="A_CContables" verificar_transaccion="no" datasource="#Session.DSN#">
				
			<cfquery name="A_CPVigencia" datasource="#Session.DSN#">
				insert INTO CPVigencia(Ecodigo, Cmayor, PCEMid, CPVdesde, CPVhasta, CPVdesdeAnoMes, CPVhastaAnoMes, CPVformatoF, CPVformatoPropio)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
					<cfif isdefined('form.PCEMid') and form.PCEMid NEQ '' AND form.PCEMid NEQ '0'>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(form.CPVano,form.CPVmes,1)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#dateFormat(CreateDate(form.CPVano,form.CPVmes,1),'YYYYMM')#">,
					610001
					 , <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPVformatoF#">
					 , <cfif form.PCEMid EQ '0'>1<cfelse>0</cfif>
					 
				)				
				<cf_dbidentity1 verificar_transaccion="no" datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="A_CPVigencia" verificar_transaccion="no" datasource="#Session.DSN#">
			
			<cfquery name="A_CContables" datasource="#Session.DSN#">
				insert INTO CFinanciera
						(CPVid, Ecodigo, Cmayor, CFformato, CFdescripcion, CFmovimiento, Ccuenta)
				values 	(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CPVigencia.identity#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
					<cfif form.PCEMid EQ "" OR form.PCEMid EQ "0">'S'<cfelse>'N'</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#A_CContables.identity#">
				)				
			</cfquery>
				
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				delete from CFinanciera
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				  and CPVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPVid#">
			</cfquery>

			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				delete from CContables
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				  and not exists 
					(
						select 1
						  from CFinanciera
						 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						   and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
						   and CPVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPVid#">
						   and CFinanciera.Ccuenta = CContables.Ccuenta
					)
			</cfquery>
			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				delete from CPresupuesto
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				  and CPVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPVid#">
			</cfquery>
			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				delete from CVMayor
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>
			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				delete from CPVigencia 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				  and CPVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPVid#">
			</cfquery>
	
			<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
				select count(1) as cantidad
				  from CPVigencia
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>

			<cfif B_CtasMayor.cantidad EQ 0>
				<cfquery name="B_CtasMayor" datasource="#Session.DSN#">
					delete from CtasMayor 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				</cfquery>
			</cfif>
			
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>				
			<cf_dbtimestamp
				datasource="#session.dsn#"
				table="CtasMayor" 
				redirect="CuentasMayor.cfm"
				timestamp="#form.ts_rversion#"
				field1="Cmayor,char,#form.Cmayor#"
				field2="Ecodigo,numeric,#session.Ecodigo#">

			<cfquery datasource="#Session.DSN#">
				update CtasMayor set 
					Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
					CdescripcionA = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CdescripcionA#">,
					Ctipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ctipo#">,
					<cfif Form.Ctipo EQ 'I'>
						Csubtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo1#">,
					<cfelseif Form.Ctipo EQ 'G'>
						Csubtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Csubtipo2#">,
					<cfelse>
						Csubtipo = null,
					</cfif>
					Cbalancen= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cbalancen#">,
					CEcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					<cfif form.PCEMid NEQ '' AND form.PCEMid NEQ '0'>
						,PCEMid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEMid#">
					<cfelse>
						,PCEMid=null
					</cfif>
					,Cmascara=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cmascara#">
					,Crevaluable   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Revaluable#">
                    ,CTCconversion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTCconversion#">
                    ,TCHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TCHid#" null="#Len(Trim(form.TCHid)) is 0#">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>		
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select count(1) as cantidad
				  from CContables
				 where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Cmayor   = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				   and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cfquery datasource="#Session.DSN#">
					update CContables 
					   set Cdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
						 , Cbalancen    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cbalancen#">
						 , Cbalancenormal = <cfif Form.Cbalancen EQ "D">1<cfelse>-1</cfif>
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and Cmayor   = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
					  and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				</cfquery>				
			<cfelse>
				<cfquery datasource="#Session.DSN#">
					insert INTO CContables
							(Ecodigo, Cmayor, Cformato, Mcodigo, Cdescripcion, Cmovimiento)
					values 	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
						null,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
						<cfif form.PCEMid EQ "" OR form.PCEMid EQ "0">'S'<cfelse>'N'</cfif>
					)				
				</cfquery>
					
			</cfif>
			<cfquery name="rsSQL" datasource="#Session.DSN#">
				select count(1) as cantidad
				  from CFinanciera 
				 where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				   and Cmayor    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				   and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>
			<cfif rsSQL.cantidad GT 0>
				<cfquery datasource="#Session.DSN#">
					update CFinanciera 
					   set CFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
					 where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and Cmayor    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
					   and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				</cfquery>				
			<cfelse>
				<cfquery name="rsSQL" datasource="#Session.DSN#">
					select Ccuenta
					  from CContables
					 where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					   and Cmayor   = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
					   and Cformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				</cfquery>
				<cfquery datasource="#Session.DSN#">
					insert INTO CFinanciera
							(CPVid, Ecodigo, Cmayor, CFformato, CFdescripcion, CFmovimiento, Ccuenta)
					values 	(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CPVid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">, 
						<cfif form.PCEMid EQ "" OR form.PCEMid EQ "0">'S'<cfelse>'N'</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.Ccuenta#">
					)				
				</cfquery>
			</cfif>

			<cfquery datasource="#Session.DSN#">
				update CPresupuesto 
				   set CPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">
				where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Cmayor    = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
				  and CPformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>				

			<cfquery name="C_CPVigencia" datasource="#Session.DSN#">
				update CPVigencia
				   set PCEMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEMid#" null="#form.PCEMid EQ '' OR form.PCEMid EQ '0'#">
					 , CPVformatoF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPVformatoF#">
					 , CPVformatoPropio = <cfif form.PCEMid EQ '0'>1<cfelse>0</cfif>
				where CPVid = <cfqueryparam value="#form.CPVid#" cfsqltype="cf_sql_integer">
				  and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			</cfquery>
			
			<cfset modo="CAMBIO">
		</cfif>
	</cftransaction>
</cfif>


<form action="CuentasMayor.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
  <cfoutput>
  <cfif not isdefined("form.Baja")>
	  <input name="Cmayor" type="hidden" value="<cfif isdefined("Form.Cmayor") and modo NEQ 'ALTA'>#Form.Cmayor#</cfif>">
	  <cfif isdefined("Form.PageNum10") and Len(Trim(Form.PageNum10))>
		<input type="hidden" name="PageNum_lista10" value="#Form.PageNum10#" />
	  <cfelseif isdefined("Form.PageNum_lista10") and Len(Trim(Form.PageNum_lista10))>
		<input type="hidden" name="PageNum_lista10" value="#Form.PageNum_lista10#" />
	  </cfif>
	  <cfif isdefined("Form.CmayorF") and Len(Trim(Form.CmayorF))>
		<input type="hidden" name="CmayorF" value="#Form.CmayorF#" />
	  </cfif>
	  <cfif isdefined("Form.CdescripcionF") and Len(Trim(Form.CdescripcionF))>
		<input type="hidden" name="CdescripcionF" value="#Form.CdescripcionF#" />
	  </cfif>
	  <cfif isdefined("Form.CtipoF") and Len(Trim(Form.CtipoF))>
		<input type="hidden" name="CtipoF" value="#Form.CtipoF#" />
	  </cfif>
  </cfif>
  </cfoutput>
</form>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
