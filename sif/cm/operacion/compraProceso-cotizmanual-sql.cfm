<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfif isdefined("Form.btnGuardar")>
	<cftransaction>
		<!--- Modo Cambio --->
		<cfif isdefined("Form.ECid") and Len(Trim(Form.ECid))>
			<cf_dbtimestamp datasource="#session.DSN#"
							table="ECotizacionesCM"
							redirect="compraProceso.cfm"
							timestamp="#form.ts_rversion#"
							field1="ECid" 
							type1="numeric" 
							value1="#form.ECid#"
							field2="Ecodigo" 
							type2="integer" 
							value2="#session.Ecodigo#">
	
			<!--- Eliminar Detalle de Cotizaciones --->
			<cfquery name="deleted" datasource="#session.DSN#">
				delete from DCotizacionesCM
				where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
	
		<!--- Modo Alta --->
		<cfelse>
			<!--- Obtener Consecutivo --->
			<cfquery name="rs" datasource="#session.DSN#">
				select max(ECconsecutivo) as ECconsecutivo
				from ECotizacionesCM
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset consecutivo = 1>
			<cfif rs.RecordCount gt 0 and len(trim(rs.ECconsecutivo))>
				<cfset consecutivo = rs.ECconsecutivo + 1>
			</cfif>
			
			<!--- Insertar Encabezado --->
			<cfquery name="insert" datasource="#session.DSN#" >
				insert into ECotizacionesCM( Ecodigo, CMPid, ECconsecutivo, ECnumero, ECfechacot, SNcodigo, ECnumprov, ECdescprov, ECobsprov, ECsubtotal, ECtotdesc , ECtotimp, ECtotal, Usucodigo, fechaalta, CMCid, Mcodigo, ECtipocambio, CMIid, CMFPid, ECfechavalido)
				values ( <cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.Compras.ProcesoCompra.CMPid#"       	cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#consecutivo#" 		cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#form.ECnumero#"  	cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#LSparseDateTime(form.ECfechacot)#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#form.SNcodigo1#" cfsqltype="cf_sql_integer">,
							<cfif len(trim(form.ECnumprov))><cfqueryparam value="#form.ECnumprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
							<cfif len(trim(form.ECdescprov))><cfqueryparam value="#form.ECdescprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
							<cfif len(trim(form.ECobsprov))><cfqueryparam value="#form.ECobsprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif> ,
							0,
							0,
							0,
							0,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam value="#Now()#"	cfsqltype="cf_sql_timestamp">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.compras.comprador#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#form.ECtipocambio#">,
							<cfif isdefined("form.CMIid") and Len(Trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
							<cfif isdefined("form.CMFPid") and Len(Trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
							<cfif Len(Trim(form.ECfechavalido))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ECfechavalido)#"><cfelse>null</cfif>
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert">
			<cfset Form.ECid = insert.identity>
	
		</cfif>
		
		<!--- Insertar el detalle de la cotización --->
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("DCcantidad_", i) NEQ 0>
				<cfset linea = Mid(i, 12, Len(i))>
				<cfquery name="rsImpuesto" datasource="#session.DSN#">
					select Iporcentaje 
					from Impuestos
					where Icodigo = <cfqueryparam value="#Evaluate('Form.Icodigo_'&linea)#" cfsqltype="cf_sql_char">
					and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="insertd" datasource="#session.DSN#" >
					insert into DCotizacionesCM(ECid, CMPid, DSlinea, Ecodigo, DCcantidad, DCpreciou, DCgarantia, DCplazocredito, DCplazoentrega, Icodigo, DCporcimpuesto, DCdesclin, DCtotimp, DCtotallin, DCdescprov, DCunidadcot, DCconversion, Ucodigo, numparte, actnumparteprov, AFMid)
					values ( <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">, 
							 <cfqueryparam value="#Session.Compras.ProcesoCompra.CMPid#" cfsqltype="cf_sql_numeric">, 
							 <cfqueryparam value="#linea#" cfsqltype="cf_sql_numeric">, 
							 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Evaluate('Form.DCcantidad_'&linea)#" cfsqltype="cf_sql_float">,												  
							 #LvarOBJ_PrecioU.enCF(Form["DCpreciou_" & linea])#, 
							 <cfif Len(Trim(Evaluate('Form.DCgarantia_'&linea)))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCgarantia_'&linea)#"><cfelse>null</cfif>,
							 <cfif Len(Trim(Evaluate('Form.DCplazocredito_'&linea)))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCplazocredito_'&linea)#"><cfelse>null</cfif>,
							 <cfif Len(Trim(Evaluate('Form.DCplazoentrega_'&linea)))><cfqueryparam cfsqltype="cf_sql_integer" value="#Evaluate('Form.DCplazoentrega_'&linea)#"><cfelse>null</cfif>,
							 <cfqueryparam value="#Trim(Evaluate('Form.Icodigo_'&linea))#" cfsqltype="cf_sql_char">,
							 <cfqueryparam cfsqltype="cf_sql_float" value="#rsImpuesto.Iporcentaje#">,
							 <cfif isdefined("Form.DCdesclin_#linea#") and len(trim(form['DCdesclin_#linea#']))><cfqueryparam value="#Evaluate('Form.DCdesclin_'&linea)#" cfsqltype="cf_sql_money">,<cfelse>0.00,</cfif>
							 <cfif isdefined("form.MtoImpuesto_#linea#") and len(trim(form['MtoImpuesto_#linea#']))><cfqueryparam value="#Replace(form['MtoImpuesto_#linea#'],',','','all')#" cfsqltype="cf_sql_numeric" scale="2"><cfelse>0.00</cfif>,
							 <cfif isdefined("form.DCtotallin_#linea#") and len(trim(form['DCtotallin_#linea#']))><cfqueryparam value="#Replace(form['DCtotallin_#linea#'],',','','all')#" cfsqltype="cf_sql_numeric" scale="2"><cfelse>0.00</cfif>,
							 <cfqueryparam value="#Evaluate('Form.DCdescprov_'&linea)#" cfsqltype="cf_sql_varchar" null="#Len(Trim(Evaluate('Form.DCdescprov_'&linea))) EQ 0#">,
							 <cfqueryparam value="#trim(Evaluate('Form.Ucodigo_'&linea))#" cfsqltype="cf_sql_varchar">,
							 1,
							 <cfqueryparam value="#trim(Evaluate('Form.Ucodigo_'&linea))#" cfsqltype="cf_sql_varchar">,
							 <cfif isdefined("Form.NumeroParte#linea#")><cfqueryparam cfsqltype="cf_sql_varchar" value="#form['NumeroParte#linea#']#"><cfelse>null</cfif>,
							 <cfif isdefined("form.actnumparteprov#linea#")>1<cfelse>0</cfif>,
							 <cfif isdefined("form.AFMid#linea#") and Len(trim(form['AFMid#linea#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['AFMid#linea#']#"><cfelse>null</cfif>
					)
				</cfquery>				
			</cfif>
		</cfloop>
		
		<!--- Actualizar los totales de impuestos y total de linea --->
				
		<cfquery name="updateDetalle" datasource="#Session.DSN#">
        	<cfset LvarSubtotal = "(round(DCcantidad * DCpreciou,2) - DCdesclin)">
        	<cfset LvarImpuesto = "round( #LvarSubtotal# * DCporcimpuesto / 100.00, 2)">
			update DCotizacionesCM
			set 	DCtotimp	= #LvarImpuesto#,
					DCtotallin	= #LvarSubtotal# + #LvarImpuesto#
			where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
		</cfquery>			

		<!--- Actualizar los Datos del Encabezado --->
		<cfquery name="rsTotal" datasource="#session.DSN#">
			select 										
				coalesce(sum(round(a.DCcantidad*a.DCpreciou,2)), 0) as subtotal,
				coalesce(sum(a.DCdesclin),0)	as totdesc,
                coalesce(sum(DCtotimp), 0)		as totimp,
                coalesce(sum(DCtotallin), 0)	as total
			from DCotizacionesCM a
			where a.ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			and a.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>		
		
		
		<!--- Actualizar el Encabezado --->
		<cfquery name="update" datasource="#session.DSN#">
			update ECotizacionesCM set 
				ECnumero = <cfqueryparam value="#form.ECnumero#"  	cfsqltype="cf_sql_varchar">, 
				ECfechacot = <cfqueryparam value="#LSparseDateTime(form.ECfechacot)#" cfsqltype="cf_sql_timestamp">,				
				SNcodigo = <cfqueryparam value="#form.SNcodigo1#" cfsqltype="cf_sql_integer">,
				ECnumprov = <cfif len(trim(form.ECnumprov))><cfqueryparam value="#form.ECnumprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
				ECdescprov = <cfif len(trim(form.ECdescprov))><cfqueryparam value="#form.ECdescprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
				ECobsprov = <cfif len(trim(form.ECobsprov))><cfqueryparam value="#form.ECobsprov#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
				Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				ECtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#form.ECtipocambio#">,
				CMIid = <cfif Len(Trim(form.CMIid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMIid#"><cfelse>null</cfif>,
				CMFPid = <cfif Len(Trim(form.CMFPid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#"><cfelse>null</cfif>,
				ECfechavalido = <cfif Len(Trim(form.ECfechavalido))><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.ECfechavalido)#"><cfelse>null</cfif>,
				ECsubtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotal.subtotal#" scale="2">,
				ECtotdesc = <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotal.totdesc#">,
				ECtotimp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotal.totimp#" scale="2">,
				ECtotal = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTotal.total#" scale="2">
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			and Ecodigo = #session.Ecodigo#
		</cfquery>
	
	</cftransaction>
	

<cfelseif isdefined("Form.btnEliminar") and isdefined("Form.ECid") and Len(Trim(Form.ECid))>

	<cftransaction>
	
		<cfquery name="deleted" datasource="#session.DSN#" >
			delete from DCotizacionesCM
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
		</cfquery>	  
		
		<cfquery name="delete" datasource="#session.DSN#" >
			delete from ECotizacionesCM
			where ECid = <cfqueryparam value="#form.ECid#" cfsqltype="cf_sql_numeric">
			and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		</cfquery>
		
	</cftransaction>

</cfif>

<cfoutput>
	<form action="compraProceso.cfm" method="post" name="sql">
	<cfif isdefined("Form.opt") and Len(Trim(Form.opt))>
		<input type="hidden" name="opt" value="#Form.opt#">
	</cfif>
	<cfif isdefined("Form.opcion") and Len(Trim(Form.opcion))>
		<input type="hidden" name="opcion" value="#Form.opcion#">
	</cfif>
	<cfif isdefined("Form.btnNuevo")>
		<input type="hidden" name="btnNuevo" value="1">
	</cfif>
	<cfif isdefined("Form.btnAplicar")>
		<input type="hidden" name="btnAplicar" value="1">
	</cfif>
	<cfif not isdefined("Form.btnNuevo") and isdefined("Form.ECid") and not (isdefined("Form.ECid") and isdefined("Form.btnEliminar"))>
		<input type="hidden" name="ECid" value="#Form.ECid#">
	</cfif>
	</form>
</cfoutput>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
