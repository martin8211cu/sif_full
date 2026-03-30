<!--- 
	Creado por Gustavo Fonseca Hernández.
		Fecha: 12-01-2006.
		Motivo: Nuevo botón de Documentos Recurrentes.
		
 --->

<cfif isdefined("form.IDdocumento") and len(trim(form.IDdocumento)) and isdefined("form.TESRPTCid") and len(trim(form.TESRPTCid))>
	
	<cfquery name="parametroRec" datasource="#session.DSN#">
		select coalesce(Pvalor, '1') as Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo=880
	</cfquery>

	<cfif parametroRec.Pvalor neq 0>
		<!--- fecha de ultimo uso --->
		<cfquery name="validar" datasource="#session.DSN#">
			select HEDfechaultuso as fecha
			from HEDocumentosCP
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
		</cfquery>
		<cfif len(trim(validar.fecha))>
			<cfset fechaultima = createdate(year(validar.fecha), month(validar.fecha), daysinmonth(validar.fecha) ) >	<!--- Ultima fecha de uso del doc recurrente  --->
			<cfset fechadocumento = createdate(year(now()), month(now()), daysinmonth(now()) ) >						<!--- Fecha con periodo y mes del documento nuevo --->
	
			<!--- hay algun documento en proceso que este usando este documento recurrente? --->
			<cfquery name="info" datasource="#session.DSN#">
				select EDdocumento
				from EDocumentosCxP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and IDdocumentorec = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
			</cfquery>
			<cfset mensaje = ' - Existe una facura aplicada para el documento recurrente y el per&iacute;odo y mes indicados.' >
			<cfif info.recordcount gt 0>
				<cfset mensaje = ' - La factura en proceso #trim(info.EDdocumento)# ha sido generada por el documento recurrente.' >
			</cfif>
			
			<cfif info.recordcount gt 0 and datecompare(fechadocumento, fechaultima ) lte 0 >
				<cfset request.Error.backs = 1 >
				<cf_errorCode	code = "50343"
								msg  = "Error al seleccionar documento recurrente para el mes @errorDat_1@ y período @errorDat_2@:<BR>@errorDat_3@"
								errorDat_1="#month(now())#"
								errorDat_2="#year(now())#"
								errorDat_3="#mensaje#"
				>
			</cfif>
		</cfif>
	</cfif>		

	<cftransaction>
		<cfquery name="rsSelectEDocumentosCxP" datasource="#session.DSN#">
				select  
					CPTcodigo, 
					Mcodigo, 
					SNcodigo, 
					Icodigo, 
					Ocodigo, 
					Ccuenta, 
					Rcodigo, 
					CFid, 
					id_direccion, 
					Dtipocambio, 
					0 as EDimpuesto , 
					0  as EDporcdescuento ,
					0  as EDdescuento, 
					Dtotal, 
					EDusuario, 
					 <!--- --convert(char, EDdocref )--,  --->
					0 as EDselect,
					0 as Interfaz,
					<!--- Dfechavenc, ---><!--- ¿SNvencompras? ---> 
					IDdocumento as IDdocumentorec
				from HEDocumentosCP
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
				
		</cfquery>
        <cfquery name="rsRevisaIntegridad" datasource="#session.DSN#">
        	select count(1) Cantidad
            	from EDocumentosCxP 
           	where Ecodigo 	  =  #session.Ecodigo#
              and CPTcodigo   = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#rsSelectEDocumentosCxP.CPTcodigo#"   voidNull>
              and EDdocumento = <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#form.EDdocumento#"       		      voidNull>
              and SNcodigo    = <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelectEDocumentosCxP.SNcodigo#"     voidNull>
        </cfquery>
        <cfif rsRevisaIntegridad.Cantidad GT 0>
        	<cfthrow message="El Documento #rsSelectEDocumentosCxP.CPTcodigo# - #form.EDdocumento# ya existe para el mismo Socio de Negocios">
        </cfif>
        
		<cfquery name="rsEDocumentosCxP" datasource="#session.DSN#">
			insert into EDocumentosCxP 
				(
					Ecodigo, 
					CPTcodigo, 
					EDdocumento, 
					Mcodigo, 
					SNcodigo, 
					Icodigo, 
					Ocodigo, 
					Ccuenta, 
					Rcodigo, 
					CFid, 
					id_direccion, 
					EDtipocambio, 
					EDimpuesto, 
					EDporcdescuento, 
					EDdescuento, 
					EDtotal, 
					EDfecha, 
					EDusuario, 
					EDselect, 
					Interfaz, 
					<!--- EDvencimiento, ---> 
					EDfechaarribo, 
					TESRPTCid,
					BMUsucodigo,
					IDdocumentorec
				) 
				VALUES(
				   #session.Ecodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#rsSelectEDocumentosCxP.CPTcodigo#"         	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#form.EDdocumento#"       					voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelectEDocumentosCxP.Mcodigo#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelectEDocumentosCxP.SNcodigo#"          	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#rsSelectEDocumentosCxP.Icodigo#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelectEDocumentosCxP.Ocodigo#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelectEDocumentosCxP.Ccuenta#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#rsSelectEDocumentosCxP.Rcodigo#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelectEDocumentosCxP.CFid#"              	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelectEDocumentosCxP.id_direccion#"      	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#rsSelectEDocumentosCxP.Dtipocambio#"      	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsSelectEDocumentosCxP.EDimpuesto#"        	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#rsSelectEDocumentosCxP.EDporcdescuento#"   	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsSelectEDocumentosCxP.EDdescuento#"       	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#rsSelectEDocumentosCxP.Dtotal#"           	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#rsSelectEDocumentosCxP.EDusuario#"         	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#rsSelectEDocumentosCxP.EDselect#"          	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#rsSelectEDocumentosCxP.Interfaz#"          	voidNull>,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#now()#">,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#form.TESRPTCid#"         					voidNull>,
				   #session.Usucodigo#,
				   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#rsSelectEDocumentosCxP.IDdocumentorec#"    	voidNull>
				   
			)
				
			<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsEDocumentosCxP"> 
			
			<cfif parametroRec.Pvalor neq 0>
				<!--- actualiza la fecha de ultimo uso --->	
				<cfquery datasource="#session.DSN#">
					update HEDocumentosCP
					set HEDfechaultuso = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
					where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			</cfif>		

			<cfquery datasource="#session.DSN#">
				insert into  DDocumentosCxP 
					(
						IDdocumento, 
						Cid, 
						Ecodigo, 	
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid, 
						DDdescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou, 
						DDdesclinea, 
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque, 
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo
					)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsEDocumentosCxP.identity#">,
						DDcoditem, 
						Ecodigo,
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid,
						DDescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou,
						DDdesclinea, 
						0.00,
						DDtotallin, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque,
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo
						
					from  HDDocumentosCP 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					and IDdocumento =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					and DDtipo = 'S'
			</cfquery>
		
			<cfquery datasource="#session.DSN#">
				insert into  DDocumentosCxP 
					(
						IDdocumento, 
						Aid,
						Alm_Aid,
						Ecodigo, 	
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid, 
						DDdescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou, 
						DDdesclinea, 
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque, 
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo 
					)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsEDocumentosCxP.identity#">,
						DDcoditem,
						Aid,	
						Ecodigo,
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid,
						DDescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou,
						DDdesclinea, 
						0.00,
						DDtotallin, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque,
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo
						
					from  HDDocumentosCP 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					and IDdocumento =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					and DDtipo = 'A'
			</cfquery>
		
			<cfquery datasource="#session.DSN#">
				insert into  DDocumentosCxP 
					(
						IDdocumento, 
						Ecodigo, 	
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid, 
						DDdescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou, 
						DDdesclinea, 
						DDporcdesclin, 
						DDtotallinea, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque, 
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo 
					)
					select 
						<cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsEDocumentosCxP.identity#">,
						Ecodigo,
						Dcodigo, 
						Ccuenta, 
						DOlinea, 
						CFid,
						DDescripcion, 
						DDdescalterna, 
						DDcantidad, 
						DDpreciou,
						DDdesclinea, 
						0.00,
						DDtotallin, 
						DDtipo, 
						DDtransito, 
						DDembarque, 
						DDfembarque,
						DDobservaciones, 
						BMUsucodigo, 
						Icodigo
						
					from  HDDocumentosCP 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
					and IDdocumento =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdocumento#">
					and DDtipo = 'F'
			</cfquery>
		

		<!--- IMPUESTOS --->
		<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
			select coalesce(sum(b.DDtotallin * d.DIporcentaje / 100.00),0.00) as TotalImpuesto
			from HEDocumentosCP a 
				inner join HDDocumentosCP b
					 on b.IDdocumento = a.IDdocumento 
					and b.Ecodigo = a.Ecodigo 
				inner join Impuestos c
					 on c.Ecodigo = b.Ecodigo
					and c.Icodigo = b.Icodigo 
				inner join DImpuestos d
					 on d.Ecodigo = c.Ecodigo 
					and d.Icodigo = c.Icodigo
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			  and  c.Icompuesto = 1
		</cfquery>
		<cfquery name="rsTotalImpuesto1" datasource="#session.DSN#">
			select coalesce(sum(b.DDtotallin * c.Iporcentaje / 100.00),0.00) as TotalImpuesto
			from HEDocumentosCP a 
				inner join HDDocumentosCP b
					 on b.Ecodigo     = a.Ecodigo 
					and b.IDdocumento = a.IDdocumento 
				inner join Impuestos c
					 on c.Ecodigo = b.Ecodigo 
					and c.Icodigo = b.Icodigo
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
			  and c.Icompuesto = 0
		</cfquery>
		<cfquery name="rsTotal" datasource="#session.DSN#">
			select coalesce(sum(a.DDtotallin),0.00) as Total
			from HDDocumentosCP a 
				inner join HEDocumentosCP b
				   on b.IDdocumento = a.IDdocumento
				  and b.Ecodigo     = a.Ecodigo
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IDdocumento#">
		</cfquery>
				
		<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
		<cfquery name="rsUpdateE" datasource="#session.DSN#">
			update EDocumentosCxP 
			set EDimpuesto = round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
					   ,EDtotal = #rsTotal.Total# 
								  + round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
								  -  EDdescuento
		   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#rsEDocumentosCxP.identity#">
			 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>	
		
	</cftransaction>
</cfif>  

<script type="text/javascript" language="javascript">
	if (window.opener != null) {
		window.opener.document.form1.LvarRecurrente.value ="1";
		window.opener.document.form1.action = "RegistroFacturasCP.cfm?IDdocumento=<cfoutput>#rsEDocumentosCxP.identity#</cfoutput>&datos=<cfoutput>#rsEDocumentosCxP.identity#</cfoutput>&tipo=C&modo=CAMBIO&mododet=ALTA";
		window.opener.document.form1.submit();
	}
	window.close();
</script>


