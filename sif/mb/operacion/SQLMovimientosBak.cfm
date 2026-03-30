<cfparam name="action" default="listaMovimientos.cfm">
<cfparam name="modo" default="ALTA">
<cfparam name="dmodo" default="ALTA">

<!---  Se va a aplicar un documento?? --->
<cfif isdefined("form.btnAplicar") >

	 <cftry> 
			<cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
				<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
				<cfinvokeargument name="EMid" value="#form.EMid#"/>				
				<cfinvokeargument name="usuario" value="#session.usucodigo#"/>			
				<cfinvokeargument name="debug" value="Y"/>							
			</cfinvoke>

		<cfcatch type="any">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cftransaction action="rollback"/>
		</cfcatch>
	</cftry>			
	<cflocation addtoken="no" url="listaMovimientos.cfm">

</cfif>

<cfif not isdefined("form.btnNuevoD")>

	<cftry>		
		<cfif not isdefined("Form.btnAgregarE") and not isdefined("Form.btnBorrarE") and not isdefined("Form.btnBorrarD")>
			<!----4. Parámetro Indica cuenta manuales ----->
			<cfquery name="rsIndicador" datasource="#session.DSN#">
				select Pvalor from Parametros 
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >	
					and Pcodigo = 2 
			</cfquery>
			<cfif rsIndicador.Pvalor EQ 'N'>
				<!----Obtener el Ocodigo, Dcodigo según el centro funcional---->			
				<cfquery name="rsOficina" datasource="#session.DSN#">
					select Ocodigo, Dcodigo from CFuncional
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">				
				</cfquery>				
				<cfset form.Dcodigo = rsOficina.Dcodigo>			
				<cfinvoke returnvariable="Cuentas" component="sif.Componentes.CG_Complementos" method="TraeCuenta" 
					Oorigen 		= "MBMV"
					Ecodigo			= "#Session.Ecodigo#"
					Conexion 		= "#Session.DSN#"
					BTransacciones  = "#form.BTid#"
					Bancos 			= "#form.Bid#"
					CFuncional      = "#form.CFid#"
					CuentasBancos   = "#form.CBid#"
					Monedas         = "#form.Mcodigo#"
					Oficinas       = "#rsOficina.Ocodigo#"
				/>
				<cfset form.Ccuenta = Cuentas.Ccuenta>
			</cfif>
		</cfif>		

			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("Form.btnAgregarE")>
				<cftransaction>
					<cfquery name="insert" datasource="#session.DSN#" >
						insert into EMovimientos ( Ecodigo, BTid, CBid, EMtipocambio, EMdocumento, EMreferencia, EMfecha, EMdescripcion, EMtotal, Ocodigo, EMusuario )
								 values ( <cfqueryparam value="#session.Ecodigo#"    cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#Form.BTid#"          cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Form.CBid#"          cfsqltype="cf_sql_numeric">, 
										  <cfqueryparam value="#Replace(Form.EMtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
										  <cfqueryparam value="#Form.EMdocumento#"   cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#Form.EMreferencia#"  cfsqltype="cf_sql_char">,
										 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.EMfecha)#">,
										  <cfqueryparam value="#Form.EMdescripcion#" cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#Replace(Form.EMtotal,',','','all')#" cfsqltype="cf_sql_money">,
										  <cfqueryparam value="#Form.Ocodigo#"       cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">
										)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>	
					<cf_dbidentity2 datasource="#session.DSN#" name="insert">
				</cftransaction>
				<cfset modo="CAMBIO">
				<cfset action = "Movimientos.cfm">
				
			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarE")>
				<cfquery name="deleted" datasource="#session.DSN#">
					delete DMovimientos
					where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>	
				<cfquery name="deleted" datasource="#session.DSN#">
					delete EMovimientos
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and EMid    = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
				<!----Obtener el Ocodigo, Dcodigo según el centro funcional---->
				<cfquery name="rsOficina" datasource="#session.DSN#">
					select Ocodigo, Dcodigo from CFuncional
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				<cfset form.Dcodigo = rsOficina.Dcodigo>	
				<cfquery name="inserted" datasource="#session.DSN#">
					insert into DMovimientos ( EMid, Ecodigo, Ccuenta, Dcodigo, DMmonto, DMdescripcion, CFid )
					values ( <cfqueryparam value="#Form.EMid#"       cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Form.Ccuenta#"    cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Form.Dcodigo#"    cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#Form.DMmonto#" cfsqltype="cf_sql_money">,
							  <cfqueryparam value="#Form.DMdescripcion#" cfsqltype="cf_sql_varchar">,
							  <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
							)
				</cfquery>
			
				<cfquery name="updated" datasource="#session.DSN#">
					update EMovimientos
					set BTid = <cfqueryparam value="#Form.BTid#" cfsqltype="cf_sql_numeric">,
						CBid = <cfqueryparam value="#Form.CBid#" cfsqltype="cf_sql_numeric">,
						EMtipocambio  =	<cfqueryparam value="#Replace(Form.EMtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
						EMdocumento   = <cfqueryparam value="#Form.EMdocumento#"  cfsqltype="cf_sql_char">,
						EMreferencia  = <cfqueryparam value="#Form.EMreferencia#" cfsqltype="cf_sql_char">,
						EMfecha       = <cfqueryparam value="#LSParseDateTime(form.EMfecha)#" cfsqltype="cf_sql_timestamp">,
						EMdescripcion = <cfqueryparam value="#Form.EMdescripcion#" cfsqltype="cf_sql_varchar">,
						Ocodigo       = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
						EMtotal = ( select coalesce(sum(DMmonto),0) 
									from DMovimientos 
									where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
									  and EMid      = <cfqueryparam value="#Form.EMid#"       cfsqltype="cf_sql_numeric">
								  )	  
					where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and EMid      = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo="CAMBIO">
				<cfset action = "Movimientos.cfm">

			<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>
				<!----Obtener el Ocodigo, Dcodigo según el centro funcional---->
				<cfquery name="rsOficina" datasource="#session.DSN#">
					select Ocodigo, Dcodigo from CFuncional
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and CFid = <cfqueryparam value="#form.CFid#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				<cfset form.Dcodigo = rsOficina.Dcodigo>		
					
				<cfquery name="updated" datasource="#session.DSN#">
					update DMovimientos
					set Ccuenta = <cfqueryparam value="#Form.Ccuenta#" cfsqltype="cf_sql_numeric">,
						Dcodigo = <cfqueryparam value="#Form.Dcodigo#" cfsqltype="cf_sql_integer">,
						DMmonto = <cfqueryparam value="#Form.DMmonto#" cfsqltype="cf_sql_money">,
						DMdescripcion = <cfqueryparam value="#Form.DMdescripcion#" cfsqltype="cf_sql_varchar">,
						CFid = <cfif isdefined("form.CFid") and len(trim(form.CFid))><cfqueryparam value="#Form.CFid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>
					where EMid      = <cfqueryparam value="#Form.EMid#"    cfsqltype="cf_sql_numeric">
					  and DMlinea   = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
				<cfif form.BTid          NEQ form.bdBTid          or 
					  form.CBid          NEQ form.bdCBid          or 
					  form.EMtipocambio  NEQ form.bdEMtipocambio  or
					  form.EMdocumento   NEQ form.bdEMdocumento	  or
					  form.EMreferencia  NEQ form.bdEMreferencia  or					  
					  form.EMfecha       NEQ form.bdEMfecha       or
					  form.EMdescripcion NEQ form.bdEMdescripcion or
					  form.DMmonto       NEQ form.bdDMmonto		  or
					  form.Ocodigo       NEQ form.bdOcodigo
					  >
						<cfquery name="updated" datasource="#session.DSN#">
							update EMovimientos
							set BTid = <cfqueryparam value="#Form.BTid#" cfsqltype="cf_sql_numeric">,
								CBid = <cfqueryparam value="#Form.CBid#" cfsqltype="cf_sql_numeric">,
								EMtipocambio = <cfqueryparam value="#Replace(Form.EMtipocambio,',','','all')#" cfsqltype="cf_sql_float">,
								EMdocumento  = <cfqueryparam value="#Form.EMdocumento#"  cfsqltype="cf_sql_char">,
								EMreferencia = <cfqueryparam value="#Form.EMreferencia#" cfsqltype="cf_sql_char">,
								EMfecha      = <cfqueryparam value="#LSParseDateTime(form.EMfecha)#" cfsqltype="cf_sql_timestamp">,
								Ocodigo      = <cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
								EMdescripcion = <cfqueryparam value="#Form.EMdescripcion#" cfsqltype="cf_sql_varchar">,
								EMtotal = ( select coalesce(sum(DMmonto),0) 
											from DMovimientos 
											where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
											  and EMid      = <cfqueryparam value="#Form.EMid#"       cfsqltype="cf_sql_numeric">
										  )	  
							where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
							  and EMid      = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
						</cfquery>
							  
				</cfif>
				<cfset modo="CAMBIO">
				<cfset dmodo="CAMBIO">
				<cfset action = "Movimientos.cfm">
				
			<!--- Caso 5: Borrar detalle de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				<cfquery name="deleted" datasource="#session.DSN#">
					delete DMovimientos
					where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
					  and DMlinea = <cfqueryparam value="#Form.DMlinea#" cfsqltype="cf_sql_numeric">
				</cfquery>
				 <cfif isdefined("deleted") and deleted.RecordCount NEQ 0>
					<cfquery name="updated" datasource="#session.DSN#">
						update EMovimientos
						set EMtotal = ( select coalesce(sum(DMmonto),0) 
										from DMovimientos 
										where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
										  and EMid      = <cfqueryparam value="#Form.EMid#"       cfsqltype="cf_sql_numeric">
									  )
						where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
						  and EMid      = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
					</cfquery> 
				</cfif>
	
				<cfset modo="CAMBIO">
				<cfset action = "Movimientos.cfm">

			</cfif>

	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "Movimientos.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>
	
<cfif isdefined("form.EMid") AND form.EMid EQ "" >
	<cfset form.EMid = "#insert.identity#">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EMid"   type="hidden" value="<cfif isdefined("Form.EMid")>#Form.EMid#</cfif>">
	<cfif dmodo neq 'ALTA'>
		<input name="dmodo"   type="hidden" value="<cfif isdefined("dmodo")>#dmodo#</cfif>">
		<input name="DMlinea" type="hidden" value="<cfif isdefined("form.DMlinea")>#form.DMlinea#</cfif>">
	</cfif>
	
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>