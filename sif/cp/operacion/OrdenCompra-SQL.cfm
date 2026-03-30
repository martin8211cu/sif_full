<!--- <cfdump var="#url#">
<cfdump var="#form#"> --->
<!---
	Creado por Gustavo Fonseca H.
	Fecha: 27-5-2005
	Motivo: Requerimiento para formar un registro de facturas tomando en cuenta las órdenes de compra
	Modificado por Gustavo Fonseca H.
	Fecha: 19-7-2005
	Motivo: Se agrega el Centro funcional.
 --->
<cfif isdefined("Form.chk")>
	<cfset pagos = #ListToArray(Form.chk, ',')#>
	<cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
		<cfset LvarDetOC = #ListToArray(LvarLin, "|")#>
		<cfset LvarPos1IDdocumento = LvarDetOC[1]>
		<cfset LvarPos2DOlinea = LvarDetOC[2]>

	<!---
		A con Requisición entrada al Gasto:		Cuenta de la Orden de Compra (CF.Inventario)
		A (otros casos):						Cuenta del Almacen           (Articulo+Almacen)
		S:										Cuenta de la Orden de Compra (CF.Gasto)
		F:										Cuenta de la Orden de Compra (CF.Inversion)
	--->
	<cfset CON_REQUISICION_AL_GASTO	= "(select sc.TRcodigo from ESolicitudCompraCM sc inner join CMTiposSolicitud ts on ts.CMTScodigo = sc.CMTScodigo and ts.Ecodigo = sc.Ecodigo and ts.CMTStarticulo = 1 AND ts.CMTSconRequisicion = 1 where sc.ESidsolicitud = a.ESidsolicitud) is NOT NULL">
	<cfset CUENTA_ALMACEN			= "(select min(cf.CFcuenta) from Existencias e inner join IAContables c inner join CFinanciera cf on cf.Ccuenta=c.IACinventario on c.Ecodigo = e.Ecodigo and c.IACcodigo = e.IACcodigo where e.Ecodigo = a.Ecodigo and e.Aid = a.Aid and e.Alm_Aid = a.Alm_Aid)">
 	<!--- 22/10/2014 ERBG Cambio para evitar la cancelación de orden relacionada a un documento de CXP Inicia---> 
	<cfquery name="rsOCStatus" datasource="#session.dsn#">
        select eo.EOidorden,EOestado, eo.EOjustificacion,EOfecha,eo.EOnumero
        from DOrdenCM do
        inner join EOrdenCM eo on eo.EOidorden = do.EOidorden and do.Ecodigo=eo.Ecodigo
        where do.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
	</cfquery>
    <cfif rsOCStatus.EOestado eq 60>
    	<cfthrow message="La Orden de Compra #rsOCStatus.EOnumero# está cancelada.">
    </cfif>
	<!--- 22/10/2014 FIN--->
	<cftransaction>
		<!---Calculo el monto surtido de la OC---->
		<cfquery name="rsMSOC" datasource="#session.dsn#">
		Select
			case DOcontrolCantidad
				when 0 then coalesce(DOmontoSurtido,0)
				else 0 end as DOmontoSurtido
		  from DOrdenCM
		  	where DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
		</cfquery>
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into DDocumentosCxP (IDdocumento, DOlinea, Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta, CFcuenta, CFid, Aid, DDdescripcion, DDdescalterna,
						DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo, Ucodigo, FPAEid, CFComplemento, PCGDid, OBOid,codIEPS,DDMontoIeps, 
						CPDCid, CTDContid)

				select	#LvarPos1IDdocumento# as IDdocumento,
						a.DOlinea,
						a.Cid,
						a.Alm_Aid,
						a.Ecodigo,
						dep.Dcodigo,
						<!--- Debe escoger la Ccuenta correspondiente a la CFcuenta --->
						(
							select cfin.Ccuenta
							  from CFinanciera cfin
							 where cfin.CFcuenta =
								case
									when a.CMtipo = 'A' AND NOT (#CON_REQUISICION_AL_GASTO#) then #CUENTA_ALMACEN#
									else a.CFcuenta
								end
						),
						case
							when a.CMtipo = 'A' AND NOT (#CON_REQUISICION_AL_GASTO#) then #CUENTA_ALMACEN#
							else a.CFcuenta
						end,
						a.CFid,
						a.Aid,
						a.DOdescripcion,
						LEFT(LTRIM(RTRIM(a.DOalterna)),255),
						a.DOcantidad - a.DOcantsurtida,
						(a.DOpreciou- #rsMSOC.DOmontoSurtido#) as DOpreciou,
						case when a.DOcantidad = 0 then 0
							 else round(a.DOmontodesc / a.DOcantidad * (a.DOcantidad - a.DOcantsurtida),2)
						end,
						a.DOporcdesc,
						00,
						a.CMtipo,
						a.Icodigo,
						e.Ucodigo,
						a.FPAEid,
						a.CFComplemento,
						a.PCGDid,
						a.OBOid,
						a.codIEPS,
						(coalesce(a.DOMontIeps,0) + coalesce(DOMontIepsCF,0)) as IEPS,
						<!---JMRV. Inicio del Cambio. 30/04/2014 --->
						a.CPDCid,
						<!---JMRV. Fin del Cambio. 30/04/2014 --->
						a.CTDContid
				from DOrdenCM a
					left outer join Articulos e
						on a.Aid = e.Aid
						and a.Ecodigo = e.Ecodigo

					left outer join Conceptos f
						on a.Cid = f.Cid
						and a.Ecodigo = f.Ecodigo

					left outer join Unidades u
						on e.Ucodigo = u.Ucodigo
						and e.Ecodigo = u.Ecodigo

					left join CFuncional cf
						on cf.CFid = a.CFid
						and cf.Ecodigo = a.Ecodigo

					left join Departamentos dep
						on dep.Dcodigo = cf.Dcodigo
						and dep.Ecodigo = cf.Ecodigo
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
				Order by DOconsecutivo

		</cfquery>

		<!--- Elimina el descuento si es mayor que el total linea --->
		<cfquery datasource="#session.DSN#">
			update DDocumentosCxP
			   set DDdesclinea		= 0
			     , DDporcdesclin	= 0
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and DOlinea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
			  and DDdesclinea 	> DDcantidad * DDpreciou
		</cfquery>


		<!--- Calcula el total linea --->
		<cfquery datasource="#session.DSN#">
			update DDocumentosCxP
			   set DDtotallinea		= round((DDcantidad * DDpreciou)- DDdesclinea,2)
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and DOlinea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
		</cfquery>

		<!------>
		<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
			select coalesce(sum(case when (b.DDtipo = 'S' or b.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN  
			    		round(DDtotallinea * d.DIporcentaje/100,4)
			      when c.IEscalonado = 0 then 
			      		round(DDtotallinea * d.DIporcentaje/100,4)
			  	  else  
			         round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),4)) * d.DIporcentaje/100,4) 
			  	  end),0) as TotalImpuesto				
			from EDocumentosCxP a left outer join DDocumentosCxP b
			  on a.IDdocumento = b.IDdocumento and
				 a.Ecodigo = b.Ecodigo left outer join Impuestos c
			  on a.Ecodigo = c.Ecodigo and
				 b.Icodigo = c.Icodigo left outer join DImpuestos d
			  on c.Ecodigo = d.Ecodigo and
				 b.Icodigo = d.Icodigo
			  left join Impuestos di
				on b.Ecodigo=di.Ecodigo
				and b.codIEPS=di.Icodigo
			  left join Conceptos e
				on e.Cid = b.Cid				
			  left join Articulos f
				on f.Aid= b.Aid		 
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and  c.Icompuesto = 1
		</cfquery>

		<cfquery name="rsTotalImpuesto1" datasource="#session.DSN#">
			select coalesce(sum(case when (b.DDtipo = 'S' or b.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN  
			    		round(DDtotallinea * c.Iporcentaje/100,4)
			      when c.IEscalonado = 0 then 
			      		round(DDtotallinea * c.Iporcentaje/100,4)
			  	  else  
			         round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),4)) * c.Iporcentaje/100,4) 
			  	  end),0) as TotalImpuesto
			from EDocumentosCxP a left outer join DDocumentosCxP b
			  on a.Ecodigo = b.Ecodigo and
				 a.IDdocumento = b.IDdocumento left outer join Impuestos c
			  on b.Ecodigo = c.Ecodigo and
				 b.Icodigo = c.Icodigo
			  left join Impuestos di
				on a.Ecodigo=di.Ecodigo
				and b.codIEPS=di.Icodigo
			  left join Conceptos e
				on e.Cid = b.Cid				
			  left join Articulos f
				on f.Aid= b.Aid		 
			where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and c.Icompuesto = 0
		</cfquery>
		<cfquery name="rsTotal" datasource="#session.DSN#">
			select coalesce(sum(a.DDtotallinea),0.00) as Total
			from DDocumentosCxP a inner join EDocumentosCxP b
			  on a.IDdocumento = b.IDdocumento
			  and a.Ecodigo = b.Ecodigo
			where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
		</cfquery>

		<cfquery name="rsTotalIEPS" datasource="#session.DSN#">
			select coalesce(sum(round(a.DDtotallinea * COALESCE(d.ValorCalculo/100,0),2)),0) as MotoIEPS 
			from DDocumentosCxP a inner join EDocumentosCxP b
			  on a.IDdocumento = b.IDdocumento
			  and a.Ecodigo = b.Ecodigo
			left join Impuestos d
			  on a.Ecodigo=d.Ecodigo
			  and a.codIEPS=d.Icodigo  
			where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
		</cfquery>


		<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
		<cfquery name="rsUpdateE" datasource="#session.DSN#">
				update EDocumentosCxP
				set EDimpuesto = round(#int(rsTotalImpuesto.TotalImpuesto*1000)/100# + #int(rsTotalImpuesto1.TotalImpuesto*1000)/1000#,2)
						   ,EDtotal = round(#rsTotal.Total#
									  + #int(rsTotalImpuesto.TotalImpuesto*1000)/1000# + #int(rsTotalImpuesto1.TotalImpuesto*1000)/1000#
									  -  EDdescuento + #rsTotalIEPS.MotoIEPS#,2)
						   ,EDTiEPS = #rsTotalIEPS.MotoIEPS# 		  
			   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cftransaction>
	<!--- 	<cfdump var="#LvarPos1IDdocumento#">
		<cfdump var="#LvarPos2Linea#"> --->

	</cfloop>

		<script language="JavaScript" type="text/javascript">
			if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
			window.close();
		</script>


</cfif>