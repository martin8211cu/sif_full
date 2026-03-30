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
  <cfquery name = "rsConceptoGenerico" datasource="#session.dsn#">
	    select Cid, Cformato from Conceptos where Ccodigo = 'COMPRAS' and 
			Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>

	<cfif len(trim(rsConceptoGenerico.Cid)) EQ 0>
	   <cfthrow message="No se ha definido el concepto con el código 'COMPRAS'.">
	<cfelse>
	  <cfif len(trim(rsConceptoGenerico.Cformato)) EQ 0>
		  <cfthrow message="El concepto de 'COMPRAS' no tiene asociada una cuenta contable.">
		</cfif>
	</cfif>

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

        <cfquery name="rsLineaOrden" datasource="#Session.DSN#">
			select Icodigo, codIEPS from DOrdenCM
	  	    where DOLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
		</cfquery>
		
		<cfquery name="rsExistImpAndIEPS" datasource="#Session.DSN#">
			select * from DDocumentosCPR 
				where Icodigo = '#rsLineaOrden.Icodigo#' and 
                <cfif len(trim(rsLineaOrden.codIEPS)) EQ 0>
				    codIEPS is null
                <cfelse>
                   codIEPS = '#rsLineaOrden.codIEPS#'
                </cfif>
					and IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">;
		</cfquery>

    <cfset LINEA_REMISION_GLOBAL = 0>

		<cfif rsExistImpAndIEPS.recordCount EQ 0>
            <!--- Insertar en la linea de la remision--->
		    <cfquery name="rsInsert" datasource="#Session.DSN#" result="resultInsert">
				insert into DDocumentosCPR 
					(IDdocumento, DOlinea, Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta, CFcuenta, CFid, Aid, DDdescripcion, DDdescalterna,
							DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo, Ucodigo, FPAEid, CFComplemento, PCGDid, OBOid,codIEPS,DDMontoIeps, 
							CPDCid, CTDContid)

					select	#LvarPos1IDdocumento# as IDdocumento,
						null as DOlinea,
						#rsConceptoGenerico.Cid# as Cid,
						a.Alm_Aid,
						a.Ecodigo,
						dep.Dcodigo,
						<!--- Debe escoger la Ccuenta correspondiente a la CFcuenta --->
						(
							select cfin.Ccuenta from CFinanciera cfin
							where cfin.CFformato = '#rsConceptoGenerico.Cformato#'
							and cfin.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						),
						(select cfin.CFcuenta from CFinanciera cfin
							where cfin.CFformato = '#rsConceptoGenerico.Cformato#'
							and cfin.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">),
						null as CFid,
						a.Aid,
						'COMPRAS' as DOdescripcion,
						null as DOalterna,
						1 as DOcantidad,
						(a.DOpreciou- #rsMSOC.DOmontoSurtido#) * a.DOcantidad as DOpreciou,
						case when a.DOcantidad = 0 then 0
							else round(a.DOmontodesc / a.DOcantidad * (a.DOcantidad - a.DOcantsurtida),2)
						end,
						a.DOporcdesc,
						00,
						'S',
						a.Icodigo,
						e.Ucodigo,
						a.FPAEid,
						a.CFComplemento,
				  	    a.PCGDid,
					    a.OBOid,
						a.codIEPS,
	  				    (coalesce(a.DOMontIeps,0) + coalesce(DOMontIepsCF,0)) as IEPS,
						a.CPDCid,
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

						SELECT SCOPE_IDENTITY() as lastLineaOrden
		    </cfquery>
        <!--- Actualizar la linea de la orden asociada a la de la remision--->
				<cfquery name = "rsUpdateLineaOrden" datasource="#Session.DSN#">
          update DOrdenCM set DRemisionlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.lastLineaOrden#">
	  	    where DOLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
        </cfquery>
				<cfset LINEA_REMISION_GLOBAL = #rsInsert.lastLineaOrden#>
		<cfelse>
			<cfquery name = "rsDataLineaOrden" datasource="#Session.DSN#">
				select	
					(a.DOpreciou- #rsMSOC.DOmontoSurtido#) * a.DOcantidad as DDpreciou,
						case when a.DOcantidad = 0 then 0
							else round(a.DOmontodesc / a.DOcantidad * (a.DOcantidad - a.DOcantsurtida),2)
							end as DDdesclinea,
							a.DOporcdesc as DDporcdesclin,
							(coalesce(a.DOMontIeps,0) + coalesce(DOMontIepsCF,0)) as DDMontoIeps
					from DOrdenCM a
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and a.DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
						Order by DOconsecutivo
			</cfquery>  
        <!--- Sumar los valores de la linea de la remision con la de la orden--->
        <cfquery name = "rsUpdateLineaRemision" datasource="#Session.DSN#">
          update DDocumentosCPR set DDDESCLINEA = (DDDESCLINEA + #rsDataLineaOrden.DDDESCLINEA#),
            DDMONTOIEPS = (DDMONTOIEPS + #rsDataLineaOrden.DDMONTOIEPS#), 
            DDPORCDESCLIN = (DDPORCDESCLIN + #rsDataLineaOrden.DDPORCDESCLIN#),
            DDPRECIOU = (DDPRECIOU + #rsDataLineaOrden.DDPRECIOU#)
            where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistImpAndIEPS.Linea#">
        </cfquery>
        <!--- Actualizar la linea de la orden asociada a la de la remision--->
        <cfquery name = "rsUpdateLineaOrden" datasource="#Session.DSN#">
          update DOrdenCM set DRemisionlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistImpAndIEPS.Linea#">
	  	      where DOLinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2DOlinea#">
        </cfquery>
				<cfset LINEA_REMISION_GLOBAL = #rsExistImpAndIEPS.Linea#>
		</cfif>

		<!--- Elimina el descuento si es mayor que el total linea --->
		<cfquery datasource="#session.DSN#">
			update 
			    DDocumentosCPR 
			   set DDdesclinea		= 0
			     , DDporcdesclin	= 0
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and Linea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LINEA_REMISION_GLOBAL#">
			  and DDdesclinea 	> DDcantidad * DDpreciou
		</cfquery>

		<!--- Calcula el total linea --->
		<cfquery datasource="#session.DSN#">
			update 
			    DDocumentosCPR 
			   set DDtotallinea		= round((DDcantidad * DDpreciou)- DDdesclinea,2)
			where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
			  and Linea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LINEA_REMISION_GLOBAL#">
		</cfquery>

		<!------>
		<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
			select coalesce(sum(case when (b.DDtipo = 'S' or b.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN  
			    		round(DDtotallinea * d.DIporcentaje/100,2)
			      when c.IEscalonado = 0 then 
			      		round(DDtotallinea * d.DIporcentaje/100,2)
			  	  else  
			         round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),2)) * d.DIporcentaje/100,2) 
			  	  end),0) as TotalImpuesto				
			from 
			    EDocumentosCPR a 
			left outer join 
			    DDocumentosCPR b 
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
			    		round(DDtotallinea * c.Iporcentaje/100,2)
			      when c.IEscalonado = 0 then 
			      		round(DDtotallinea * c.Iporcentaje/100,2)
			  	  else  
			         round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) 
			  	  end),0) as TotalImpuesto
			from 
			    EDocumentosCPR a 
			left outer join 
			    DDocumentosCPR b 
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
			from 
			    DDocumentosCPR a 
			 inner join 
			    EDocumentosCPR b 
			  on a.IDdocumento = b.IDdocumento
			  and a.Ecodigo = b.Ecodigo
			where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
		</cfquery>

		<cfquery name="rsTotalIEPS" datasource="#session.DSN#">
			select coalesce(sum(round(a.DDtotallinea * COALESCE(d.ValorCalculo/100,0),2)),0) as MotoIEPS 
			from 
			    DDocumentosCPR a 
			 inner join 
			    EDocumentosCPR b 
			  on a.IDdocumento = b.IDdocumento
			  and a.Ecodigo = b.Ecodigo
			left join Impuestos d
			  on a.Ecodigo=d.Ecodigo
			  and a.codIEPS=d.Icodigo  
			where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
		</cfquery>


		<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
		<cfquery name="rsUpdateE" datasource="#session.DSN#">
				update 
			    EDocumentosCPR 
				set EDimpuesto = round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
						   ,EDtotal = #rsTotal.Total#
									  + round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
									  -  EDdescuento + #rsTotalIEPS.MotoIEPS#
						   ,EDTiEPS = #rsTotalIEPS.MotoIEPS# 		  
			   where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>
	</cftransaction>

	</cfloop>

		<script language="JavaScript" type="text/javascript">
			if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
			window.close();
		</script>


</cfif>