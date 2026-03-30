<!--- 
    Archivo: cjc_traeVouchers-sql.cfm
    Creado:  Randall Colomer Villalta
    Fecha:   18 Agosto del 2006, ICE.
 --->

<cftransaction action="begin">

	<cfif isdefined("form.chk") >
		<cfset listaErrores = "">
		<cfloop list="#form.chk#" delimiters="," index="idx" >
			<cfset cuenta=1>
			<cfloop list="#idx#" delimiters="|" index="idx1" >
				<cfswitch expression="#cuenta#">
					<cfcase value="1">
						<cfset autorizacion = #idx1#>
					</cfcase>
				</cfswitch>
				<cfset cuenta = cuenta + 1>
			</cfloop>
							
			<cfquery name="rsVerificar" datasource="#session.Fondos.dsn#">
				select 1 
				from CJX011
				where TS1COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TS1COD#">
					and TR01NUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TR01NUT#"> 
					and CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJM00COD#"> 
					and CJX11AUT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#autorizacion#">				
			</cfquery>
			<cfif isdefined("rsVerificar") and rsVerificar.recordCount GT 0>
				<cfset listaErrores = listaErrores & '#autorizacion#|' >
			</cfif>			
				
		</cfloop>
		
		<!---  --->
		<cfif isdefined("listaErrores") and len(trim(listaErrores)) EQ 0>
			<cftry>
				<!--- Verifica que exista la relación, sino crea una y la inserta en la tabla CJX019 --->
				<cfif isdefined("form.CJX19REL") and trim(form.CJX19REL) EQ 0 >
					<cfquery name="rsRelacion" datasource="#session.Fondos.dsn#">
						select isnull(max(CJX19REL), 0) + 1 as CJX19REL	 
						from CJX019
					</cfquery>
					<cfif isdefined("rsRelacion") and rsRelacion.recordcount GT 0>
						<cfset _cjx19rel = rsRelacion.CJX19REL >
					</cfif>
					<cfquery name="rsInsertar" datasource="#session.Fondos.dsn#">
						insert into CJX019 (CJX19REL,CJ1PER,CJ1MES,CJ01ID,CJX19USR,CJX19FED,CJX19EST)
						values (
							#_cjx19rel#,
							<cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(session.Fondos.Anno)#">,
							<cfqueryparam  cfsqltype="cf_sql_integer" value="#trim(session.Fondos.Mes)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.Fondos.Caja)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.usuario)#">,
							getdate(),
							'D'
						)
					</cfquery>
				<cfelse>
					<cfset _cjx19rel = form.CJX19REL >
				</cfif>
				
				<!--- Recorre la lista de checks marcados línea por línea  --->
				<cfloop list="#form.chk#" delimiters="," index="idx" >
					<!--- SeoObtiene el consecutivo para insertar el voucher --->
					<cfquery name="rsConsec" datasource="#session.Fondos.dsn#">
						select isnull(max(CJX23CON), 0) + 1 as CJX23CON 
						from CJX023
						where CJX19REL = #_cjx19rel#
					</cfquery>
					<cfif isdefined("rsConsec") and rsConsec.recordcount GT 0>
						<cfset _cjx23con = rsConsec.CJX23CON >
					</cfif>
					
					<!--- Recorre la línea para obtener los valores --->
					<cfset cuenta=1>
					<cfloop list="#idx#" delimiters="|" index="idx1" >
						<cfswitch expression="#cuenta#">
							<cfcase value="1">
								<cfset autorizacion = #idx1#>
							</cfcase>
							<cfcase value="2">
								<cfset fecha = #idx1#>
							</cfcase>
							<cfcase value="3">
								<cfset monto = #idx1#>
							</cfcase>
							<cfcase value="4">
								<cfset tipoVoucher = #idx1#>
							</cfcase>
							<cfcase value="5">
								<cfset recibido = #idx1#>
							</cfcase>
		
						</cfswitch>
						<cfset cuenta = cuenta + 1>
					</cfloop>
					
					<!--- Condición para insertar los registros seleccionados --->
					<cfquery name="rsVouchers" datasource="#session.fondos.dsn#">
						insert into CJX023(	CJX19REL,	CJX23CON,	CJX23TIP,	CJX23MON,	CJX5IDE,	
											TS1COD,		TR01NUT,	CJX23CHK,	CP9COD,		EMPCOD,		
											CJX23TTR,	CJX23AUT,	CJX23FEC	)
						values (
							<cfqueryparam cfsqltype="cf_sql_integer" value="#_cjx19rel#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#_cjx23con#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJX23TIP#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#abs(monto)#">,
							null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TS1COD#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TR01NUT#">,
							null,
							null,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EMPCOD#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#tipoVoucher#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#autorizacion#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(fecha)#">
						)
					</cfquery>
					
				</cfloop>
		
				<cfoutput>	
					<script>
						window.opener.document.location = "../operacion/cjc_PrincipalAnticipos.cfm?modo=#modo#&CJX19REL=#_cjx19rel#";
						window.close();
					</script>
				</cfoutput>
		
				<cftransaction action="commit"/>	
			
				<cfcatch type="any">
					<script language="JavaScript">
						var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
						mensaje = mensaje.substring(40,300)
						if (mensaje != "") {
							alert(mensaje)
						}
						history.back()
					</script>
					<cftransaction action="rollback" />
					<cfabort>
				</cfcatch>
			</cftry>
		</cfif>
		
		
		<!--- Imprime la lista de Errores. --->
		<cfif isdefined("listaErrores") and len(trim(listaErrores)) GT 0>
			<script language="JavaScript">
				var win = null;

				function newWindow(mypage,myname,w,h,features)  {
					  var winl = (screen.width-w)/2;
					  var wint = (screen.height-h)/2;
					  if (winl < 0) winl = 0;
					  if (wint < 0) wint = 0;
					  var settings = 'height='+ h +',width='+ w +',top='+ wint +',left='+ winl +',' + features;
					  win = window.open(mypage,myname,settings);
					  win.window.focus();
				}
				
				var params = "AUTORIZACION=<cfoutput>#listaErrores#</cfoutput>&TARJETA=<cfoutput>#form.TR01NUT#</cfoutput>";
				var direccion = "/cfmx/sif/fondos/Utiles/cjc_traeVoucherErrores.cfm?"+params;

				newWindow(direccion,'','400','300','resizable,scrollbars');
				history.back()
			</script>
		</cfif>

		
	</cfif>
	
</cftransaction>

