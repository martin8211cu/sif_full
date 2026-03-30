<cfset modo = "ALTA">

<cfquery name="rsSQL" datasource="#Session.DSN#">
	select CPPfechaDesde
	  from CPresupuestoPeriodo
	 where Ecodigo = #Session.Ecodigo#
	   and CPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
</cfquery>
<cfset LvarFecha = rsSQL.CPPfechaDesde>

<cfif not isdefined("Form.Nuevo")>
			<cfinvoke 
			 component="sif.Componentes.PC_GeneraCuentaFinanciera"
			 method="fnGeneraCuentaFinanciera"
			 returnvariable="LvarMSG">
				<cfinvokeargument name="Lprm_CFformato" value="#form.CPformato#"/>
				<cfinvokeargument name="Lprm_fecha" value="#LvarFecha#"/>
				<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
				<cfinvokeargument name="Lprm_Cdescripcion" value="#form.CPdescripcion#"/>
				<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
				<cfinvokeargument name="Lprm_CPPid" value="#form.CPPid#"/>
				<cfinvokeargument name="Lprm_CVPtipoControl" value="0"/>
				<cfinvokeargument name="Lprm_CVPcalculoControl" value="1"/>
				<cfinvokeargument name="Lprm_SoloVerificar" value="yes"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
			</cfinvoke>
			<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
				<cfthrow message="#LvarMSG#">
			</cfif>
			<cfparam name="form.cantDets" default="0">
			<cfloop from="1" to="#form.cantDets#" index="i">
				<cfif isdefined("form.cPadre_#i#") and form['cPadre_#i#'] NEQ ''>
					<cfinvoke 
					 component="sif.Componentes.PC_GeneraCuentaFinanciera"
					 method="fnGeneraCuentaFinanciera"
					 returnvariable="LvarMSG">
						<cfinvokeargument name="Lprm_CFformato" value="#form['cPadre_#i#']#"/>
						<cfinvokeargument name="Lprm_fecha" value="#LvarFecha#"/>
						<cfinvokeargument name="Lprm_Ocodigo" value="0"/>
						<cfinvokeargument name="Lprm_Cdescripcion" value="x"/>
						<cfinvokeargument name="Lprm_CrearPresupuesto" value="true"/>
						<cfinvokeargument name="Lprm_CPPid" value="#form.CPPid#"/>
						<cfinvokeargument name="Lprm_CVPtipoControl" value="0"/>
						<cfinvokeargument name="Lprm_CVPcalculoControl" value="1"/>
						<cfinvokeargument name="Lprm_SoloVerificar" value="yes"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
					</cfinvoke>
					<cfif LvarMSG NEQ "NEW" AND LvarMSG NEQ "OLD">
						<cfthrow message="#LvarMSG#">
					</cfif>
				</cfif>
			</cfloop>
	<cftransaction>
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsCtasVin" datasource="#Session.DSN#">
				select 1
				from CPCtaVinculada
				where Ecodigo=#Session.Ecodigo#
					and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					and CPformato=<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato#">
			</cfquery>
			<cfif isdefined('rsCtasVin') and rsCtasVin.recordCount GT 0>
				<cf_errorCode	code = "50466"
								msg  = "La cuenta '@errorDat_1@' ya está definida como Cuenta Vinculada en el Periodo Presupuestario"
								errorDat_1="#form.CPformato#"
				>
			</cfif>

			<cfquery name="rsCtasVin" datasource="#Session.DSN#">
				select v.CPformato
				from CPCtaVinculada v, CPCtaVinculadaPadres p
				where v.Ecodigo=#Session.Ecodigo#
					and v.CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					and p.CPCVid = v.CPCVid
					and p.CPformatoPadre=<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato#">
			</cfquery>
			<cfif isdefined('rsCtasVin') and rsCtasVin.recordCount GT 0>
				<cf_errorCode	code = "50467"
								msg  = "La cuenta '@errorDat_1@' ya está definida como cuenta Padre dentro de la Cuenta Vinculada '@errorDat_2@' en el Periodo Presupuestario"
								errorDat_1="#form.CPformato#"
								errorDat_2="#rsCtasVin.CPformato#"
				>
			</cfif>

			<cfquery name="A_CtasVinculadas" datasource="#Session.DSN#">
				insert into CPCtaVinculada 
					(Ecodigo, CPPid, CPformato, CPdescripcion, CPCVporcentaje, BMUsucodigo)
					values (
						#Session.Ecodigo#,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#mid(form.CPformato,1,100)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(form.CPdescripcion,1,40)#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.CPCVporcentaje#">,
						#session.usucodigo#)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="A_CtasVinculadas" verificar_transaccion="false" datasource="#Session.DSN#">
			
			<cfset Form.CPCVid = A_CtasVinculadas.identity>
			
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Baja")>
			<cfquery datasource="#Session.DSN#">
				delete from CPCtaVinculadaPadres 
				where CPCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCVid#">
			</cfquery>
			<cfquery datasource="#Session.DSN#">
				delete from CPCtaVinculada 
				where CPCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCVid#">
			</cfquery>
						
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="rsCtasVin" datasource="#Session.DSN#">
				select 1
				from CPCtaVinculada
				where Ecodigo=#Session.Ecodigo#
					and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					and CPformato=<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato#">
					and CPCVid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCVid#">)
			</cfquery>
			
			<cfif isdefined('rsCtasVin') and rsCtasVin.recordCount GT 0>
				<cf_errorCode	code = "50468"
								msg  = "Ya existe una cuenta vinculada con formato: @errorDat_1@"
								errorDat_1="#form.CPformato#"
				>
			<cfelse>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="CPCtaVinculada" 
					redirect="CuentasVinculadas.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#Session.Ecodigo#"
					field2="CPCVid,numeric,#form.CPCVid#">
			
				<cfquery datasource="#Session.DSN#">
					update CPCtaVinculada set
						CPformato=<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPformato#">
						, CPdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#">
						, CPCVporcentaje=<cfqueryparam cfsqltype="cf_sql_float" value="#form.CPCVporcentaje#">
					where Ecodigo=#Session.Ecodigo#
						and CPCVid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCVid#">
						and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
				</cfquery>		 
			</cfif>
			
			<!--- Insercion de la lista de detalles --->
			<cfloop from="1" to="#form.cantDets#" index="i">
				<cfif isdefined("form.cPadre_#i#") and form['cPadre_#i#'] NEQ ''>
					<cfquery name="rsCtasVin" datasource="#Session.DSN#">
						select 1
						from CPCtaVinculada
						where Ecodigo=#Session.Ecodigo#
							and CPPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
							and CPformato=<cfqueryparam cfsqltype="cf_sql_char" value="#form['cPadre_#i#']#">
					</cfquery>
					<cfif isdefined('rsCtasVin') and rsCtasVin.recordCount GT 0>
						<cf_errorCode	code = "50466"
										msg  = "La cuenta '@errorDat_1@' ya está definida como Cuenta Vinculada en el Periodo Presupuestario"
										errorDat_1="#form['cPadre_#i#']#"
						>
					</cfif>
					<cfquery datasource="#session.DSN#">
						insert into CPCtaVinculadaPadres 
							(CPCVid, CPformatoPadre, BMUsucodigo)
							values (
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCVid#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form['cPadre_#i#']#">,
								#session.usucodigo#)
					</cfquery>				
				</cfif>
			</cfloop>			

			<cfset modo="CAMBIO">  				  
		<cfelseif isdefined("Form.idBorrar") and form.idBorrar NEQ ''>
			<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
				delete from CPCtaVinculadaPadres 
				where CPCVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPCVid#">
					and CPCVPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.idBorrar#">
			</cfquery>		
			
			<cfset modo="CAMBIO"> 
		</cfif>			
	</cftransaction>
</cfif>

<cfoutput>
<form action="CuentasVinculadas.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="CPCVid" type="hidden" value="#form.CPCVid#">
	</cfif>
	<input name="CPPid" type="hidden" value="#form.CPPid#">
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


