<!--- 
	Creado por Gustavo Fonseca Hernández, Fecha: 22-8-2005. Motivo: Manejo de pagos en el modelo de Trámites.
	Modificado por DAG, Fecha: 25-8-2005. Motivo: Agregar Mantenimiento a id_documento_pago.
 --->

<cfparam name="modo" default="ALTA">
<cfset tab = '1'>

<cfif isdefined("form.btnGuardar")>
	<cftransaction>
	
	<cfif isdefined("form.id_documento_pago") and len(form.id_documento_pago) and isdefined("form.rd") and form.rd EQ 0>
		
		<cfquery name="rsDelete" datasource="#session.tramites.dsn#">
			delete TPRequisitoPago 
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
		</cfquery>
		
	<cfelse>
		
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("id_inst_", i) NEQ 0>
				<cfset LvarId_Inst = Mid(i, 9, Len(i))>
				<cfset LvarListaA = ListToArray(i,'_')>
				<cfif isdefined("LvarId_Inst") and len(trim(LvarId_Inst)) gt 0><!--- La primera vez no viene nada en esta variable LvarId_Inst --->
					<cfloop collection="#Form#" item="c">
						<cfif FindNoCase("id_tiposerv_", c) NEQ 0>
							<cfset LvarId_tiposerv = Mid(c, 13, Len(c))>
							 <cfif isdefined("LvarId_tiposerv") and len(trim(LvarId_tiposerv)) gt 0 and #Evaluate('form.costo_requisito_'&LvarId_tiposerv)# gt 0><!--- ---><!--- Siempre tiene que venir si viene  LvarId_Inst --->
								<cfquery name="rsUpdate1" datasource="#session.tramites.dsn#">
									update TPRequisitoPago 
										set id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
											id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Evaluate('form.id_tiposerv_'&LvarId_tiposerv)#">,
											costo_requisito = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Replace(Evaluate('form.costo_requisito_'&LvarId_tiposerv),',','','all')#" scale="2">,
											moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Miso4217#">,
											BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
											BMfechamod = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
											
										where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
											and id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarId_tiposerv#">
								</cfquery>
							<cfelseif isdefined("LvarId_tiposerv") and len(trim(LvarId_tiposerv)) gt 0 and #Evaluate('form.costo_requisito_'&LvarId_tiposerv)# EQ 0>
								<cfquery name="rsDelete" datasource="#session.tramites.dsn#">
									delete TPRequisitoPago
										where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
											and id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarId_tiposerv#">
								</cfquery>
							</cfif>
						</cfif>				
					</cfloop>
				</cfif>
			</cfif>				
		</cfloop>
	
		<cfif isdefined("form.COSTO_REQUISITOAGREGA") and form.COSTO_REQUISITOAGREGA GT 0>
			<cfquery name="rsVerifica" datasource="#session.tramites.dsn#">
				select count(1) as contador
				from TPRequisitoPago
				where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
					and id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposervagrega#">
			</cfquery>
			<cfif rsVerifica.contador gt 0>
				<cfthrow message="Error" detail="No se puede agregar el registro, por que ya existe el Servicio para ese Requisito.">
			</cfif>
			<cfquery name="rsInsert" datasource="#session.tramites.dsn#">
				insert into TPRequisitoPago(id_requisito, id_tiposerv, costo_requisito, moneda, BMUsucodigo, BMfechamod)
					values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tiposervAgrega#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#Replace(form.costo_requisitoAgrega,',','','all')#" scale="2">,<!--- por cada línea --->
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.Miso4217#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						)
			
			</cfquery>
		<cfelse>
			<!--- No inserta en TPRequisitoPago --->
		</cfif>
	
	</cfif>	
	
	<cfquery name="rsUpdate" datasource="#session.tramites.dsn#">
		update TPRequisito
			set 
				<cfif isdefined("form.id_documento_pago") and len(form.id_documento_pago) and isdefined("form.rd") and form.rd EQ 0>
					costo_requisito = 0, 
					moneda = (select moneda_pago from TPDocumento where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento_pago#">), 
					id_documento_pago = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento_pago#">
				<cfelse>
					costo_requisito = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Replace(form.costo_requisitoTotalEnca,',','','all')#" scale="2">, 
					moneda = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Miso4217#">, 
					id_documento_pago = null
				</cfif>
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>
	
	</cftransaction>	
	<cfset tab = '6'>
	<cfset modo="CAMBIO">
</cfif>
<form action="Tp_Requisitos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="id_requisito" type="hidden" value="<cfif isdefined("Form.id_requisito")><cfoutput>#Form.id_requisito#</cfoutput></cfif>">
	<input type="hidden" name="tab" value="<cfoutput>#tab#</cfoutput>">
</form>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
