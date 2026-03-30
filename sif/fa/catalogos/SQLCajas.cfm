<cfparam name="LvarPagina" default="Cajas.cfm">
<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<!--- Agregar un usuario --->
		<cfif isdefined("Form.btnAceptar")>
			<cfquery name="rsAgrUsuario" datasource="#Session.DSN#">
				set nocount on
				if not exists
				(
					select *
					from UsuariosCaja
					where
						FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
						and EUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">
				)
					insert UsuariosCaja (FCid, EUcodigo, Usucodigo, Ulocalizacion, Usulogin)
					values
					(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EUcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.Usulogin)#">
					)
				set nocount off
			</cfquery>
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.btnBorrar.X")>

            <cfquery name="rsUsuariosActivos" datasource="#Session.DSN#">
              select * from FCajasActivas
              where
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and EUcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eulin#">
            </cfquery>
           <cfif  rsUsuariosActivos.recordcount gt 0>
             <cf_ErrorCode code="-1" msg="No se puede eliminar el usuario porque actualmente tiene en uso la caja.">
          </cfif>

			<cfquery name="rsDelUsuario" datasource="#Session.DSN#">
				set nocount on
				delete from FCajasActivas
				where
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and EUcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eulin#">
				delete from UsuariosCaja
				where
					FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
					and EUcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eulin#">
				set nocount off
			</cfquery>
			<cfset modo="CAMBIO">
		<cfelse>


			<cfif isdefined("Form.Alta")>
                 <cfif isdefined('form.ECaja') and len(trim(#form.ECaja#)) gt 0>
                     <cfquery name="caja" datasource="#Session.DSN#">
				     update FCajas set
                        FCimportacion = 0
				     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				     and FCid = <cfqueryparam value="#Form.ECaja#" cfsqltype="cf_sql_numeric">
                    </cfquery>
                 </cfif>

              <cfquery name="Cajas" datasource="#Session.DSN#">
				insert FCajas (	Ecodigo, 	FCcodigo, FCcodigoAlt,  	FCdesc, 		FCalmmodif, 	Aid, 	Ccuenta, FCcomplemento,	Ccuentadesc,
							FCestado, 	 FCproceso, 	FCresponsable, 	FCtipodef, Ocodigo, CcuentaFalt, CcuentaSob,FCimportacion)
				values
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCcodigoAlt#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.FCdesc)#">,
					<cfif isdefined("Form.FCalmmodif")>1<cfelse>0</cfif>,
					<cfif isDefined('form.Aid') and Len(Trim(form.Aid))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
						<cfelse>
							null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
   					<cfif isdefined("Form.ComplementoCaja") and Len(Trim(Form.ComplementoCaja)) GT 0 >
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.ComplementoCaja)#">,
                    <cfelse>
                      null,
                    </cfif>
					<cfif isdefined("Form.Ccuentadesc") and Len(Trim(Form.Ccuentadesc)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentadesc#">,<cfelse>null,</cfif>
					<cfif isdefined("Form.FCestado")>1<cfelse>0</cfif>,
					<cfif isdefined('Form.FCproceso')>
                     1
                    <cfelse>
                     0
                    </cfif>,
					<cfif isdefined("Form.FCresponsable") and Len(Trim(Form.FCresponsable)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.FCresponsable)#">,<cfelse>null,</cfif>
					<cfif isdefined("Form.FCtipodef") and Len(Trim(Form.FCtipodef)) GT 0 >
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCtipodef#">,<cfelse>null,</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
					 <cfif isdefined("Form.CcuentaFalt") and Len(Trim(Form.CcuentaFalt)) GT 0 >
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaFalt#"><cfelse>null</cfif>,
					<cfif isdefined("Form.CcuentaSob") and Len(Trim(Form.CcuentaSob)) GT 0 >
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaSob#"><cfelse>null</cfif>,
                   	<cfif isdefined("Form.FCimportacion")>1<cfelse>0</cfif>

				)
		        </cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Baja")>
				<cfquery name="rsTransacciones" datasource="#Session.DSN#">
                  select * from ETransacciones where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
                </cfquery>
                <cfif rsTransacciones.recordcount eq 0>
                    <cfquery name="caja" datasource="#Session.DSN#">
					delete from FCajasActivas
					where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
                    </cfquery>
					<cfquery name="caja" datasource="#Session.DSN#">
					delete from UsuariosCaja
					where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
                    </cfquery>

	                <cfquery name="caja" datasource="#Session.DSN#">
					delete from TipoTransaccionCaja
					where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
                    </cfquery>
                    <cfquery name="caja" datasource="#Session.DSN#">
					delete from FCajas
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						and FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
                    </cfquery>
                <cfelse>
                  <cfthrow message="Existen transacciones que dependen de la caja que intenta eliminar, el proceso se ha cancelado!">
                </cfif>

				<cfset modo="BAJA">

			<cfelseif isdefined("Form.Cambio")>
                  <cfif isdefined('form.ECaja') and len(trim(#form.ECaja#)) gt 0>
                     <cfquery name="caja" datasource="#Session.DSN#">
				     update FCajas set
                        FCimportacion = 0
				     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				     and FCid = <cfqueryparam value="#Form.ECaja#" cfsqltype="cf_sql_numeric">
                    </cfquery>
                 </cfif>

                <cfquery name="caja" datasource="#Session.DSN#">
				     update FCajas set
						FCcodigo = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCcodigo#">)),
						FCcodigoAlt = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCcodigoAlt#">)),
						FCdesc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.FCdesc)#">,
						FCalmmodif = <cfif isdefined("Form.FCalmmodif")>1<cfelse>0</cfif>,
						<cfif isDefined('form.Aid') and Len(Trim(form.Aid))>
							Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
						</cfif>
						Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
                        FCcomplemento = <cfif isdefined("Form.ComplementoCaja") and Len(Trim(Form.ComplementoCaja)) GT 0 >
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.ComplementoCaja)#">,
                                   <cfelse>null,</cfif>
						Ccuentadesc =
							<cfif isdefined("Form.Ccuentadesc") and Len(Trim(Form.Ccuentadesc)) GT 0 >
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuentadesc#">,<cfelse>null,</cfif>
                        CcuentaFalt =
                      <cfif isdefined("Form.CcuentaFalt") and Len(Trim(Form.CcuentaFalt)) GT 0 >
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaFalt#"><cfelse>null</cfif>,
                        CcuentaSob =
					<cfif isdefined("Form.CcuentaSob") and Len(Trim(Form.CcuentaSob)) GT 0 >
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaSob#"><cfelse>null</cfif>,
						<!--- FCestado = <cfif isdefined("Form.FCestado")>1<cfelse>0</cfif>, --->
						FCproceso = 0,
						FCresponsable =
							<cfif isdefined("Form.FCresponsable") and Len(Trim(Form.FCresponsable)) GT 0 >
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#JSStringFormat(Form.FCresponsable)#">,<cfelse>null,</cfif>
						FCtipodef =
							<cfif isdefined("Form.FCtipodef") and Len(Trim(Form.FCtipodef)) GT 0 >
								<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FCtipodef#">,<cfelse>null,</cfif>
						Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
                        FCimportacion= <cfif isdefined('Form.FCimportacion')>1 <cfelse>0</cfif>
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
				  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
               </cfquery>

				<cfset modo="CAMBIO">
			</cfif>
		</cfif>
	<cfcatch type="database">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="<cfoutput>#LvarPagina#</cfoutput>" method="post" name="sql">
	<cfif isDefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="<cfoutput>#Form.Nuevo#</cfoutput>">
	<cfelse>
		<cfif modo NEQ "BAJA">
			<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
		</cfif>
	</cfif>
	<input type="hidden" name="PageNum" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>