<!--- Este archivo requiere que este definido en el Form el ERNid, sino, lo envía a la lista de Pósibles Nóminas por Corregir. --->
<cfif not isDefined("Form.ERNid")>
	<cflocation url="listaXNomina.cfm">
</cfif>

<!--- Variables utilizadas en este archivo --->
<cfset Action = "XNomina.cfm">

<!--- Consulta: se obtienen la cantidad de personas en la nómina para realizar un proceso posterior --->
<cfquery name="rsCantidadLineas" datasource="#Session.DSN#">
	select count(*) as cantidad
	from DRNomina
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>

<!--- Area de Trabajo: Aquí se construyen los SQL para eliminar o  modificar los detalles de la nómina, o reintentar pagar la nómina --->
<cftry>
	<cfif isDefined("Form.btnEliminar") >
		<cfset vchk = ListToArray(Form.chk)>
		<cfquery name="ABC_XNomina" datasource="#Session.DSN#">
			select CIid 
			from CIncidentes
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pvalor#">
		</cfquery>
		<cfif isdefined("ABC_XNomina") AND ABC_XNomina.RecordCount eq 0)>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ElConceptoDePagoParaPagosNoRealizados"
			Default="Error, El concepto de pago para pagos no realizados, definido en la tabla de parámetros, no corresponde a ningún Concepto de Pago. Procreso Cancelado!"	
			returnvariable="MSG_ElConceptoDePagoParaPagosNoRealizados"/>
			
			<cf_throw message="#MSG_ElConceptoDePagoParaPagosNoRealizados#" errorcode="6040">
		<cfelse>
			<cfloop from="1" index="i" to="#ArrayLen(vchk)#">
				<cfquery name="DEL_DDeducPagos" datasource="#Session.DSN#">
					delete DDeducPagos  
					 where DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
				</cfquery>
				<cfquery name="DEL_DRIncidencias" datasource="#Session.DSN#">
					delete DRIncidencias  
					where DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
				</cfquery>
				<cfquery name="DEL_Incidencias" datasource="#Session.DSN#">
					 delete Incidencias 
					 from ERNomina a, DRNomina b 
					 where b.DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
					   and a.ERNid = b.ERNid 
					   and Incidencias.DEid = b.DEid 
					   and a.RCNid is not null
					   and Incidencias.Ifecha between a.ERNfinicio and a.ERNffin 
				</cfquery>
				<cfquery name="RS_ERNomina" datasource="#Session.DSN#">
					select 
						b.DEid,
						dateadd(dd,1,a.ERNffin) as fecha ,
						b.DRNliquido as Ivalor					
					from ERNomina a, DRNomina b
					where b.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					and b.DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
					and a.ERNid = b.ERNid
					and RCNid is not null
				</cfquery>
				<cfif isdefined("RS_ERNomina") AND RS_ERNomina.RecordCount gt 0 and len(trim(RS_ERNomina.DEid))>
					<cfquery name="insert_Incidencias" datasource="#Session.DSN#">
						insert into Incidencias	(
							DEid,
							CIid,
							Ifecha,
							Ivalor,
							Ifechasis,
							Usucodigo,
							Ulocalizacion
						)
						select 
							RS_ERNomina.DEid,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pvalor100#">,
							RS_ERNomina.fecha,
							RS_ERNomina.Ivalor,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
					</cfquery>
				</cfif>
				<cfquery name="DEL_DRNomina" datasource="#Session.DSN#">
					delete from DRNomina 
					where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vchk[i]#">
				</cfquery>
			</cfloop>
			<cfquery name="RS_DRNomina" datasource="#Session.DSN#">
				select DRNlinea 
				from DRNomina
				where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
			</cfquery>
			<cfif isdefined("RS_DRNomina") AND RS_DRNomina.RecordCount eq 0>
				<cfquery name="RS_ERNomina" datasource="#Session.DSN#">
					select RCNid from ERNomina where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
				</cfquery>
				<cfif isdefined("RS_ERNomina") AND RS_ERNomina.RecordCount gt 0 and len(trim(RS_ERNomina.RCNid))>
					<cfinvoke 
						component="rh.Componentes.RH_HistoricoRCalculo"
						method="HistoricoRCalculo">
						<cfinvokeargument name="RCNid" value="#RS_ERNomina.RCNid#"/>
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
						<cfinvokeargument name="debug" value="N" />
					</cfinvoke>
					
					<cfquery name="DEL_PagosEmpleado" datasource="#Session.DSN#">
						delete from PagosEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_IncidenciasCalculo" datasource="#Session.DSN#">
						delete from IncidenciasCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_CargasCalculo" datasource="#Session.DSN#">
						delete from CargasCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_DeduccionesCalculo" datasource="#Session.DSN#">
						delete from DeduccionesCalculo where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_SalarioEmpleado" datasource="#Session.DSN#">
						delete from SalarioEmpleado where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_RCalculoNomina" datasource="#Session.DSN#">
						delete from RCalculoNomina where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RS_ERNomina.RCNid#">
					</cfquery>
					<cfquery name="DEL_ERNomina" datasource="#Session.DSN#">
						delete from ERNomina where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif isDefined("Form.btnModificar")>
		<cfloop index="i" from="1" to="#rsCantidadLineas.cantidad#">
			<cfif isDefined('Form.DRNlinea_'&i)>
				<cfquery name="UP_DRNomina" datasource="#Session.DSN#">
					update DRNomina 
					set CBcc = <cfqueryparam cfsqltype="cf_sql_char" value="#Evaluate('Form.CBcc'&Evaluate('Form.DRNlinea_'&i))#">
					where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
					and DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('Form.DRNlinea_'&i)#">
				 </cfquery>  
			</cfif>
		</cfloop>
	<cfelseif isdefined("Form.btnReintentar")>
		<cfinvoke 
			component="rh.Componentes.rh_ReintentarPagos"
			method="rh_ReintentarPagos">
			<cfinvokeargument name="ERNid" value="#Form.ERNid#" />
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
			<cfinvokeargument name="debug" value="N" />
		</cfinvoke>
		<cfset Action = "listaXNomina.cfm">	
	</cfif>
<cfcatch type="any">
	<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
	<cfabort>
</cfcatch>
</cftry>
<cfoutput>
  <form action="#Action#" method="post" name="SQLform">
	<cfif Action eq "XNomina.cfm">
		<input name="ERNid" type="hidden" value="#Form.ERNid#">
	</cfif>
  </form>
</cfoutput>
<html>
<head>
<title>Errores de N&oacute;mina</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<script language="JavaScript" type="text/javascript">document.SQLform.submit();</script>
</body>
</html>