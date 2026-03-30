<cfscript>
	bcheck0 = false; // Chequeo de Existencia de Pago
	bcheck1 = false; // Chequeo de Transaccion de Pago
	bcheck2 = false; // Chequeo de Oficinas
	bcheck3 = false; // Chequeo de Monedas
	bcheck4 = false; // Chequeo de Socios de Negocios
	bcheck5 = false; // Chequeo de Documento a Pagar
	bcheck6 = false; // Chequeo de Monto de Pago
	bcheck7 = false; // Chequeo de Retenciones
	bcheck8 = false; // Chequeo de Saldo de Documentos
	bcheck9 = false; // Chequeo de Documentos en no mas de un pago
	bcheck10 = false; // Chequeo de Integridad de Encabezados
	bcheck11 = false; // Chequeo de Cuenta Bancaria 
</cfscript>

<!---NUEVO IMPORTADOR COBROS CxC
Realizado por Alejandro Bolaños Gómez APPHOSTING 30-05-08 --->

<!---Se realiza lo siguiente: Se verifican los encabezadoz y se realizan las validaciones necesarias --->

<!--- Verifica si el pago ya existe en sistema --->
<cfquery name="rsCheck0" datasource="#Session.DSN#">
	select count(1) as check0
	from #table_name# a
	where exists (select 1 
			       	from BMovimientosCxP b , SNegocios sn
			        where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                    and sn.Ecodigo = b.Ecodigo
			   	    and b.CPTcodigo = a.TranPago
			        and b.Ddocumento = a.DocPago
                    and b.SNcodigo = sn.SNcodigo
                    and sn.SNcodigoext = a.SNcodigoext) 
    or exists (select 1 
		       	from EPagosCxP p, SNegocios sn
		        where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
                and sn.Ecodigo = p.Ecodigo
		   	    and CPTcodigo = a.TranPago
		        and EPdocumento = a.DocPago
                and p.SNcodigo = sn.SNcodigo
                and SNcodigoext = a.SNcodigoext) 
</cfquery>
<cfset bcheck0 = rsCheck0.check0 LT 1>

<!---Verifica que La transaccion de Documento sea de Pago  --->
<cfif bcheck0>
	<cfquery name="rsCheck1" datasource="#Session.DSN#">
		select count(1) as check1
		from #table_name# a
		where not exists
	    (
			select 1 
        	from CPTransacciones 
	        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
    	    and CPTPago = 1
        	and CPTcodigo = a.TranPago
	      ) 
	</cfquery>
	<cfset bcheck1 = rsCheck1.check1 LT 1>
</cfif>
<!--- Verifica que la Oficina Dada exista--->
<cfif bcheck1>
	<cfquery name="rsCheck2" datasource="#Session.DSN#">
		select count(1) as check2 
        from #table_name# a
        where not exists 
        (select 1 
         from Oficinas 
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
         and Oficodigo = a.COfi
		)
	</cfquery>
    <cfset bcheck2 = rsCheck2.check2 LT 1>
</cfif>

<!--- Verifica que la Moneda de Pago exista --->
<cfif bcheck2>
	<cfquery name="rsCheck3" datasource="#Session.DSN#">
		select count(1) as check3
		from #table_name# a
		where not exists
        (
			select 1
			from Monedas
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and Miso4217 = a.Moneda
		)
	</cfquery>
	<cfset bcheck3 = rsCheck3.check3 LT 1>
</cfif>

<!--- Verifica que el socio de Negocios exista --->
<cfif bcheck3>
	<cfquery name="rsCheck4" datasource="#Session.DSN#">
		select count(1) as check4
		from #table_name# a
		where not exists
        (
			select 1
			from SNegocios 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and SNcodigoext = a.SNcodigoext
		)
	</cfquery>
	<cfset bcheck4 = rsCheck4.check4 LT 1>
</cfif>

<!---Verifica que el documento a Pagar exista y sea de tipo Credito--->
<cfif bcheck4>
	<cfquery name="rsCheck5" datasource="#Session.DSN#">
		select count(1) as check5
		from #table_name# a
		where not exists
        (
			select 1
			from EDocumentosCP d, SNegocios sn, CPTransacciones ct 
            where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and d.Ecodigo = sn.Ecodigo 
            and sn.SNcodigoext = a.SNcodigoext
            and sn.SNcodigo = d.SNcodigo 
            and d.Ddocumento = a.Documento
            and d.CPTcodigo = a.TranDocto
            and ct.Ecodigo = d.Ecodigo 
            and ct.CPTcodigo = d.CPTcodigo 
            and ct.CPTtipo = 'C'
		)
	</cfquery>
	<cfset bcheck5 = rsCheck5.check5 LT 1>
</cfif>

<!---Verifica que El monto del pago sea = a la suma de los Montos a Pagar--->
<cfif bcheck5>
    <cfquery name="rsCheck6" datasource="#Session.DSN#">
		select count(1) as check6
		from #table_name# a
		where MontoPago < (select sum(MontoDoc) 
			        		from #table_name# b
            			    where a.DocPago = b.DocPago
			                group by b.DocPago)
	</cfquery>
	<cfset bcheck6 = rsCheck6.check6 LT 1>
</cfif>

<!---Verifica que los Documentos Marcados con Monto Retencion efectivamente tengan Retencion --->
<cfif bcheck6>
	<cfquery name="rsCheck7" datasource="#Session.DSN#">
		select count(1) as check7
		from #table_name# a
		where abs(isnull(MontoRet,0)) > 0 
        and exists
        (
			select 1
			from EDocumentosCP d, SNegocios sn 
            where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and d.Ecodigo = sn.Ecodigo 
            and sn.SNcodigoext = a.SNcodigoext
            and sn.SNcodigo = d.SNcodigo 
            and d.Ddocumento = a.Documento
            and d.CPTcodigo = a.TranDocto
            and d.Rcodigo is null
		)
	</cfquery>
	<cfset bcheck7 = rsCheck7.check7 LT 1>
</cfif>

<!---Verifica que el Saldo del documento a Pagar sea mayor o igual al monto que se va a pagar --->
<cfif bcheck7>
	<cfquery name="rsCheck8" datasource="#Session.DSN#">
		select count(1) as check8
		from #table_name# a
        where exists
        (
			select 1
			from EDocumentosCP d, SNegocios sn 
            where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and d.Ecodigo = sn.Ecodigo 
            and sn.SNcodigoext = a.SNcodigoext
            and sn.SNcodigo = d.SNcodigo 
            and d.Ddocumento = a.Documento
            and d.CPTcodigo = a.TranDocto
            and (d.EDsaldo * d.Dtipocambio) < ((a.MontoDoc + isnull(a.MontoRet,0)) * a.Tcambio)
		)
	</cfquery>
	<cfset bcheck8 = rsCheck8.check8 LT 1>
</cfif>

<!---Verifica que el Documento no se encuentre en mas de un pago --->
<cfif bcheck8>
	<cfquery name="rsCheck9" datasource="#Session.DSN#">
		select count(1) as check9
		from #table_name# a
        where exists
        (select 1
			from #table_name# b
         	where a.Documento = b.Documento 
           	and a.Ecodigo = b.Ecodigo 
           	and a.TranDocto = b.TranDocto
           	and a.SNcodigoext = b.SNcodigoext
           	and a.DocPago != b.DocPago)
         or exists
         (select 1 
         	from EDocumentosCP e, DPagosCxP p, SNegocios sn
            	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and p.Ecodigo = e.Ecodigo
                and sn.Ecodigo = e.SNcodigo 
                and e.Ddocumento = a.Documento 
                and e.CPTcodigo = a.TranDocto
                and e.SNcodigo = sn.SNcodigo
                and sn.SNcodigoext = a.SNcodigoext
                and e.IDdocumento = p.IDdocumento)
	</cfquery>
	<cfset bcheck9 = rsCheck9.check9 LT 1>
</cfif>

<!---Verifica Que exista la cuenta Bancaria --->
<cfif bcheck9>
    <cfquery name="rsCheck10" datasource="#Session.DSN#">
		select count(1) as check10
        from #table_name# t
        where not exists 
        (select 1 
         from CuentasBancos 
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
         and CBcodigo = isnull(t.CBanco,'')
         and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        )
     </cfquery>
	<cfset bcheck10 = rsCheck10.check10 LT 1>
</cfif>

<!---Verifica Integridad de Encabezados --->
<cfif bcheck10>
<cfquery name="rsEncabezado" datasource="#Session.DSN#">
    	select distinct Ecodigo, TranPago, DocPago, COfi, Moneda, SNcodigoext, 
        	Tcambio, MontoPago, FPago, Benef, CBanco, TPago
        into ##Pagos
       	from #table_name#
    </cfquery>
    <cfquery name="rsCheck11" datasource="#Session.DSN#">
		select count(1) as check11
		from #table_name# a
        where exists
        (
			select 1
			from ##Pagos b
           where a.DocPago = b.DocPago
           and (isnull(a.Ecodigo,'') != isnull(b.Ecodigo,'')
			   	or isnull(a.TranPago,'') != isnull(b.TranPago,'')
    	        or isnull(a.SNcodigoext,'') != isnull(b.SNcodigoext,'')
	            or isnull(a.Moneda,'') != isnull(b.Moneda,'')
    	        or isnull(a.Tcambio,'') != isnull(b.Tcambio,'')
        	  	or isnull(a.MontoPago,'') != isnull(b.MontoPago,'') 
                or isnull(a.FPago,'') != isnull(b.FPago,'')
    	       	or isnull(a.Benef,'') != isnull(b.Benef,'')
                or isnull(a.CBanco,'') != isnull(b.CBanco,'')
                or isnull(a.TPago,'') != isnull(b.TPago,'')
        	    or isnull(a.COfi,'') != isnull(b.COfi,'')
	            )
		)
	</cfquery>
	<cfset bcheck11 = rsCheck11.check11 LT 1>
</cfif>

<cfif bcheck11>
	
    <!--- Se insertan Documentos en Pagos --->
    <cfquery datasource="#session.DSN#">
    	insert EPagosCxP(Ecodigo, CPTcodigo, EPdocumento, Mcodigo, EPtipocambio, EPselect, 
                    	 Ccuenta, EPtotal, EPfecha, EPtipopago, EPbeneficiario, Ocodigo, SNcodigo, 
						 EPusuario, CBid, BTid)
        select distinct t.Ecodigo, TranPago, DocPago, m.Mcodigo, Tcambio,0,
		cb.Ccuenta, MontoPago, FPago, t.Tpago, t.Benef, o.Ocodigo, sn.SNcodigo,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#"> , cb.CBid, cpt.BTid
        from #table_name# t, SNegocios sn, Oficinas o, Monedas m, CuentasBancos cb, CPTransacciones cpt
        where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        and sn.SNcodigoext = t.SNcodigoext
        and o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and o.Oficodigo = t.COfi
        and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and m.Miso4217 = t.Moneda
        and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and CBcodigo = t.CBanco
         and cpt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        and cpt.CPTcodigo = TranPago
    </cfquery>

	<!--- Se toman los encabezados para loop --->
	<cfquery name="rsPagos" datasource="#session.DSN#">
		select distinct DocPago
        from #table_name#
	</cfquery>
    <cfif rsPagos.recordcount GT 0>
    <cfloop query="rsPagos">
    	<!---Calcula el ID Pago--->
        <cfquery name="rsID" datasource="#session.DSN#">
        	select IDPago 
            from EPagosCxP 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
            and EPdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPagos.DocPago#">
        </cfquery>
        <cfif rsID.recordcount EQ 1>
        	<cfset varIDpago = rsID.IDPago>
        </cfif>
        <cfif isdefined("varIDpago")>
        	<cfquery datasource="#session.DSN#">
	        	<!--- Se Insertan registros en DPagos --->
				insert DPagosCxP(Ecodigo, IDpago, IDdocumento, Ccuenta, DPmonto, DPtipocambio, DPmontodoc, 
        	    				DPtotal, DPmontoretdoc,BMUsucodigo) 
        		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
               		<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIDpago#">,
					e.IDdocumento, e.Ccuenta, isnull(MontoDoc,0),Tcambio,
    		        isnull((MontoDoc * Tcambio) / case when isnull(e.Dtipocambio,0) = 0 then 1 else e.Dtipocambio end,0),
        		     isnull(MontoDoc * Tcambio,0), isnull(MontoRet,0), 
                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	        	from #table_name# a , EDocumentosCP e, SNegocios sn
	    	    where sn.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    	    	and sn.SNcodigoext = a.SNcodigoext
	    	    and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    	    	and sn.SNcodigo = e.SNcodigo 
	        	and e.CPTcodigo = a.TranDocto
		        and e.Ddocumento = a.Documento
    		    and a.DocPago = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPagos.DocPago#">
			</cfquery>
        </cfif>
    </cfloop>
	</cfif>

    <cfquery datasource="#session.DSN#">
		drop table ##Pagos
    </cfquery>

<cfelse>
	<!--- Fallo Check0 --->
	<cfif not bcheck0>
    	<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'El pago ya existe en el sistema: ' as MSG, a.DocPago as Documento, a.TranPago as Transaccion_Pago
            from #table_name# a
			where exists (select 1 
				       	from HDocumentos
				        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
			   		    and CCTcodigo = a.TranPago
			        	and Ddocumento = a.DocPago) 
		    or exists (select 1 
				       	from Pagos
		        		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
				   	    and CCTcodigo = a.TranPago
				        and Pcodigo = a.DocPago) 
        </cfquery>

    <!--- Fallo Check1 --->      
	<cfelseif not bcheck1>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'La Transaccion dada para el pago no es transaccion de Pago: ' as MSG, a.DocPago, a.TranPago as Transaccion_Pago
			from #table_name# a
			where not exists
		    (
				select 1 
		        from CCTransacciones 
		        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
		        and CCTPago = 1
		        and CCTcodigo = a.TranPago
		    ) 
		</cfquery>
	
	<!--- Fallo Check2 --->
    <cfelseif not bcheck2>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Oficina no existe: ' as MSG, a.COfi as CODIGO_OFICINA
			from #table_name# a
			where not exists 
	        (select 1 
    	     from Oficinas 
        	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		     and Oficodigo = a.COfi
			)
		</cfquery>
    
	<!--- Fallo Check3 --->    
	<cfelseif not bcheck3>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Moneda no existe: ' as MSG, a.Moneda as CODIGO_MONEDA
			from #table_name# a
			where not exists(
				select 1
				from Monedas b
				where b.Miso4217 = a.Moneda
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			)
		</cfquery>

	<!--- Fallo Check4 --->
	<cfelseif not bcheck4>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Socio de Negocios no existe: ' as MSG, a.SNcodigoext as SOCIO_NEGOCIOS
			from #table_name# a
			where not exists
       		 (
					select 1
					from SNegocios 
        		    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		            and SNcodigoext = a.SNcodigoext
			)
		</cfquery>

	<!--- Fallo Check5 --->
	<cfelseif not bcheck5>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Documento a Pagar NO existe Verifique el Socio y la Transaccion dada: ' as MSG, a.Documento, a.SNcodigoext as SOCIO_NEGOCIOS, a.TranDocto as TRANSACCION 
			from #table_name# a
            where not exists
  		      (
					select 1
					from EDocumentosCP d, SNegocios sn, CPTransacciones ct 
        		    where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		            and d.Ecodigo = sn.Ecodigo 
        		    and sn.SNcodigoext = a.SNcodigoext
		            and sn.SNcodigo = d.SNcodigo 
        		    and d.Ddocumento = a.Documento
		            and d.CPTcodigo = a.TranDocto
        		    and ct.Ecodigo = d.Ecodigo 
		            and ct.CPTcodigo = d.CPTcodigo 
        		    and ct.CPTtipo = 'C'
				)
		</cfquery>

	<!--- Fallo Check6 --->		
    <cfelseif not bcheck6>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Montos a Pagar mayores al Disponible para el pago: ' as MSG, a.DocPago as DOCUMENTO_PAGO
			from #table_name# a
			where MontoPago < (select sum(MontoDoc) 
			        		from #table_name# b
            			    where a.DocPago = b.DocPago
			                group by b.DocPago)
		</cfquery>
        
    <!--- Fallo Check7 --->		
    <cfelseif not bcheck7>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Intento de Pagar Retencion a un Documento sin Retención: ' as MSG, a.Documento
			from #table_name# a
			where abs(isnull(MontoRet,0)) > 0 
  		      and exists
        		(
					select 1
					from EDocumentosCP d, SNegocios sn 
		            where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        		    and d.Ecodigo = sn.Ecodigo 
		            and sn.SNcodigoext = a.SNcodigoext
        		    and sn.SNcodigo = d.SNcodigo 
		            and d.Ddocumento = a.Documento
        		    and d.CPTcodigo = a.TranDocto
		            and d.Rcodigo is null
				)
		</cfquery>
    
	<!--- Fallo Check8 --->		
    <cfelseif not bcheck8>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Saldo de Documento menor al Monto a Pagar: ' as MSG, a.Documento
			from #table_name# a
			where exists
     	   (
				select 1
				from EDocumentosCP d, SNegocios sn 
    	        where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
        	    and d.Ecodigo = sn.Ecodigo 
            	and sn.SNcodigoext = a.SNcodigoext
	            and sn.SNcodigo = d.SNcodigo 
    	        and d.Ddocumento = a.Documento
        	    and d.CPTcodigo = a.TranDocto
            	and (d.EDsaldo * d.Dtipocambio) < ((a.MontoDoc + isnull(a.MontoRet,0)) * a.Tcambio)
			)
		</cfquery>
        
    <!--- Fallo Check9 --->		
    <cfelseif not bcheck9>
		<cfquery name="ERR" datasource="#session.DSN#">
			select distinct 'Documento a Pagar aparece en mas de un Documento de Pago: ' as MSG, a.Documento, a.SNcodigoext as SOCIO_NEGOCIO, a.TranDocto as TRANSACCION_DOCUMENTO
			from #table_name# a
			where exists
   		    (select 1
				from #table_name# b
         		where a.Documento = b.Documento 
	           	and a.Ecodigo = b.Ecodigo 
    	       	and a.TranDocto = b.TranDocto
        	   	and a.SNcodigoext = b.SNcodigoext
           		and a.DocPago != b.DocPago)
	         or exists
    	     (select 1 
        	 	from EDocumentosCP e, DPagosCxP p, SNegocios sn
            	where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                and p.Ecodigo = e.Ecodigo
                and sn.Ecodigo = e.SNcodigo 
                and e.Ddocumento = a.Documento 
                and e.CPTcodigo = a.TranDocto
                and e.SNcodigo = sn.SNcodigo
                and sn.SNcodigoext = a.SNcodigoext)
		</cfquery>
	 
	 <!--- Fallo Check10 --->		
	 <cfelseif not bcheck10>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Cuenta Bancaria no existe: ' as MSG, a.CBanco as CUENTA_BANCO
				from #table_name# a
				where not exists 
        		(select 1 
		         from CuentasBancos 
        		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		         and CBcodigo = isnull(a.CBanco,'')
                 and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        		)                
            </cfquery>
	<cfelse>
		<!--- Fallo Check11 --->		
	    <cfif not bcheck11>
			<cfquery name="ERR" datasource="#session.DSN#">
				select distinct 'Error en Integridad de Documento, verifique los detalles: ' as MSG, a.DocPago
				from #table_name# a
		    	where exists
   			     (
					select 1
					from ##Pagos b
		           where a.DocPago = b.DocPago
        		   and (isnull(a.Ecodigo,'') != isnull(b.Ecodigo,'')
					   	or isnull(a.TranPago,'') != isnull(b.TranPago,'')
    			        or isnull(a.SNcodigoext,'') != isnull(b.SNcodigoext,'')
	            		or isnull(a.Moneda,'') != isnull(b.Moneda,'')
		    	        or isnull(a.Tcambio,'') != isnull(b.Tcambio,'')
        			  	or isnull(a.MontoPago,'') != isnull(b.MontoPago,'') 
                		or isnull(a.FPago,'') != isnull(b.FPago,'')
			          	or isnull(a.Benef,'') != isnull(b.Benef,'')
            		    or isnull(a.CBanco,'') != isnull(b.CBanco,'')
		                or isnull(a.TPago,'') != isnull(b.TPago,'')
        			    or isnull(a.COfi,'') != isnull(b.COfi,'')
	            		)
				)
			</cfquery>
            <cfquery datasource="#session.DSN#">
				drop table ##Pagos
		    </cfquery>
		</cfif>
	</cfif>
</cfif>
