<!---<cfdump var="#form#">
<cfabort> 
 --->
<cfset varPosteo = true>

<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
	select Mcodigo 
    from Empresas
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>
<cfset varMonedaL = rsMonedaLocal.Mcodigo>
<cfset cambioTotEnc = false>
<cfif not isdefined("Form.TipoCambio") and isdefined("url.TipoCambio")>
	<cfset Form.TipoCambio = url.TipoCambio>
<cfelseif not isdefined("Form.TipoCambio") and not isdefined("url.TipoCambio")>
	<cfset Form.TipoCambio = 1>
</cfif>

 <cfif IsDefined("form.Cambio")> <!--- cambio encabezado --->
	<!---<cf_dbtimestamp datasource="#session.dsn#"
		table="FAPreFacturaE"
		redirect="FAprefactura.cfm"
		timestamp="#form.ts_rversion#"
		field1="Ecodigo"
		type1="integer"
		value1="#session.Ecodigo#"
		field2="PFdocumento"
		type2="varchar"
		value2="#form.PFdocumento#"> --->
	<cfquery name="update" datasource="#session.DSN#">
		update FAPreFacturaE 
			set			
				FAX04CVD=<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX04CVD#">, 
		<!---Ocodigo=<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,<cfelse>null,</cfif> --->
				SNcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">, 
		<!--- Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,  ---> 
				FechaCot=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.FechaCot,'dd/mm/yyyy')#">, 
				<cfif isdefined('form.vencimiento') and len(trim(form.vencimiento))>
					FechaVen=<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',form.vencimiento,DateFormat(form.FechaCot,'dd/mm/yyyy'))#">,
				<cfelse>
				 	FechaVen=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateFormat(form.FechaCot,'dd/mm/yyyy')#">,
				</cfif>				
		<!--- PFTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigo#">, --->
				TipoPago=0, 
				Estatus=<cfqueryparam cfsqltype="cf_sql_char" value="#form.Estatus#">, 
				Descuento=<cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuento#">,  
				<cfif isdefined('form.NumOrdenCompra') and len(form.NumOrdenCompra)>
					NumOrdenCompra=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumOrdenCompra#">, 
				<cfelse>
					NumOrdenCompra=null,
				</cfif>				
				Observaciones=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">, 
				TipoCambio=<cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
				BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,		
				id_direccion= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.id_direccion#">,	
				Fecha_doc= null,
                <cfif isdefined('form.vencimiento') and len(trim(form.vencimiento))>
                	vencimiento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.vencimiento#">	
                <cfelse>
                	vencimiento = 0
                </cfif>
		where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">		
	</cfquery> 
	<cfset cambioTotEnc = true>	

<cfelseif IsDefined("form.Baja")> <!--- Elimina Documento --->
	<!--- Si existe un movimiento en la Bitacora para esta Prefactura no permite eliminarla --->
    <cfquery name="rsVerificaBit" datasource="#session.dsn#">
    	select IDpreFactura 
        from FABitacoraMovPF
        where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">
    </cfquery>
    <cfif rsVerificaBit GT 0>
    	<cfabort showerror="La Pre-Factura ya ha tenido movimientos de aplicación Imposible Borrarla, 
        			puede anularla desde la Lista de Pre-Facturas">
    <cfelse>
	    <cfquery datasource="#session.dsn#">
			delete FAPreFacturaD
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			delete FAPreFacturaE
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">
		</cfquery>	
	</cfif>
<cfelseif IsDefined("form.Alta")> <!--- Inserta Documento --->
	<cftransaction>
		<cfquery name="insertEnc" datasource="#session.dsn#">
			insert into FAPreFacturaE 
				(Ecodigo, FAX04CVD, PFDocumento, Ocodigo, SNcodigo, Mcodigo, FechaCot, FechaVen, PFTcodigo, TipoPago, Estatus,
				 Descuento, Impuesto, Total, NumOrdenCompra,  
				 Observaciones, TipoCambio, BMUsucodigo, fechaalta, id_direccion, Fecha_doc,vencimiento)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX04CVD#">, 
   				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFdocumento#">, 
				<cfif isdefined('form.Ocodigo') and len(trim(form.Ocodigo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,<cfelse>null,</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">,  
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaCot#">,
				<cfif isdefined('form.vencimiento') and len(trim(form.vencimiento))>
					<cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',form.vencimiento,DateFormat(form.FechaCot,'dd/mm/yyyy'))#">, 
				<cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_date" value="#form.FechaCot#">,
				</cfif>				
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PFTcodigo#">, 
				0,  
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Estatus#">,   
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Descuento#">, 
                0, 0, 
				<cfif isdefined('form.NumOrdenCompra') and len(form.NumOrdenCompra)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NumOrdenCompra#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_direccion#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mm/yyyy')#">,
				<cfif isdefined('form.vencimiento') and len(trim(form.vencimiento))>
                	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.vencimiento#">	
                <cfelse>
                	0
                </cfif>
				)	
			
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertEnc">
	</cftransaction>
	<!---,,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Direccion#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">--->

<!--- SENTENCIAS PARA EL DETALLE --->
<cfelseif IsDefined("form.AltaDet")> <!--- Inserta Detalle --->
	<cfquery name="proxLinea" datasource="#session.dsn#">
		select (coalesce(max(Linea),0) + 1) as Linea
		from FAPreFacturaD
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">
	</cfquery>

<cftransaction>	
    <cfquery name="insertDet" datasource="#session.dsn#">
		insert INTO FAPreFacturaD 
			(Ecodigo, Linea, IDpreFactura, Cantidad, TipoLinea, Aid, Alm_Aid, Cid, CFid, Icodigo, Descripcion,
            	Descripcion_Alt, PrecioUnitario, DescuentoLinea, TotalLinea, BMUsucodigo, fechaalta, Ccuenta)
		values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#proxLinea.Linea#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.Cantidad#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoLinea#">,
				<cfif isdefined('form.TipoLinea') and Len(Trim(form.TipoLinea)) and form.TipoLinea EQ 'A'>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Almacen#">,					
					null,
				<cfelse>
					null,
					null,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
				</cfif>
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#" null="#Len(Trim(Form.Descripcion)) EQ 0#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion_Alt#" null="#Len(Trim(Form.Descripcion_Alt)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.PrecioUnitario#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.DescuentoLinea#">, 
				<cfqueryparam cfsqltype="cf_sql_money" value="#form.TotalLinea#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 				
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(Now(),'dd/mm/yyyy')#">,
                <cfif len(form.Ccuenta)GT 0>
	                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccuenta#">
                <cfelse>
                	null
				</cfif>
)		
    </cfquery> 
</cftransaction>
	<cfset cambioTotEnc = true>

<cfelseif IsDefined("form.CambioDet")> <!--- Cambia Detalle --->
	<!---<cf_dbtimestamp datasource="#session.dsn#"
		table="FAPreFacturaD"
		redirect="FAprefactura.cfm"
		timestamp="#form.ts_rversionDet#"
		field1="IDprefactura"
		type1="integer"
		value1="#form.IDprefactura#">
		field2="Linea"
		type1="integer"
		value1="#form.Linea#">--->
		
	<cfquery name="insertEnc" datasource="#session.dsn#">
		update FAPreFacturaD set
			Cantidad = <cfqueryparam cfsqltype="cf_sql_money" value="#form.Cantidad#">
			, TipoLinea = <cfqueryparam cfsqltype="cf_sql_char" value="#form.TipoLinea#">
			<cfif isdefined('form.TipoLinea') and Len(Trim(form.TipoLinea)) and form.TipoLinea EQ 'A'>
				, Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
				, Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Almacen#">
				, Cid = null
			<cfelse>
				, Aid = null
				, Alm_Aid = null
				, Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
			</cfif>
            , CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
			, Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
			, Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#" null="#Len(Trim(Form.Descripcion)) EQ 0#">
            , Descripcion_Alt = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion_Alt#" null="#Len(Trim(Form.Descripcion_Alt)) EQ 0#">
			, PrecioUnitario = <cfqueryparam cfsqltype="cf_sql_money" value="#form.PrecioUnitario#">
			, DescuentoLinea = <cfqueryparam cfsqltype="cf_sql_money" value="#form.DescuentoLinea#">
			, TotalLinea = <cfqueryparam cfsqltype="cf_sql_money" value="#form.TotalLinea#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
            , Ccuenta =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ccuenta#">
		where IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">
	        and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Linea#">
	</cfquery>
	
	<cfset cambioTotEnc = true>	

<cfelseif IsDefined("form.BajaDet")> <!--- Elimina un detalle --->
	<cfquery datasource="#session.dsn#">
		delete FAPreFacturaD
		where IDpreFactura = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">
        and Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Linea#">
	</cfquery>
	
	<cfset cambioTotEnc = true>	

<cfelseif (isdefined("Form.btnAnular"))> <!--- Anula Pre-Facturas --->
	<cfif (isdefined("Form.chk"))><!--- Viene de la lista --->
		<cfset datos = ListToArray(Form.chk)>
		<cfset limite = ArrayLen(datos)>
        <cfloop from="1" to="#limite#" index="idx">
			<cftransaction>
            <cfquery datasource="#session.DSN#">
				update FAPreFacturaE 
					set	Estatus='A'
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and IDpreFactura = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_numeric">		
					and Estatus = 'P' 
			</cfquery> 
            </cftransaction>
		</cfloop>
		<cfset cambioTotEnc = false>	
	</cfif>
    
<cfelseif (isdefined("Form.btnAplicar_Factura"))> <!--- Aplica Facturas --->
	<cfif (isdefined("Form.chk"))>
		<!--- Se crea una Tabla temporal para detectar cuantos documentos se crearan --->
        <cf_dbtemp name="PF_aplicacion" returnvariable="PF_aplicacion" datasource="#session.dsn#">
			<cf_dbtempcol name="PFTcodigo" type="char(2)">
            <cf_dbtempcol name="SNcodigo" type="int"> 
			<cf_dbtempcol name="Mcodigo" type="int">
            <cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="IDpreFactura" type="int"> 
		</cf_dbtemp>
        
		<cfset datos = ListToArray(Form.chk,",")>
        <cfset limite = ArrayLen(datos)>
		<cfloop from="1" to="#limite#" index="idx">
			<!--- Toma los valores para la Prefactura --->
            <cfquery name="rsPreFact" datasource="#session.dsn#">
            	select PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura
                from FAPreFacturaE
                where IDpreFactura = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_integer">
            </cfquery>
		
			<!--- Inserta valores en tabla Temporal --->
            <cfquery datasource="#session.dsn#">
            	insert into #PF_aplicacion# (PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.SNcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Mcodigo#">,
		 		 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Ocodigo#">,				 	
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.IDpreFactura#">)
            </cfquery>	
		</cfloop>
        
        <!--- ABCO. Revisa si se aplicaron prefacturas del mismo socio de diferente oficina --->
        <cfquery name="rsVerificaOf" datasource="#session.dsn#">
        	select SNcodigo, PFTcodigo, Mcodigo, count(Distinct Ocodigo) as Conteo
            from #PF_aplicacion#
            group by SNcodigo, PFTcodigo, Mcodigo
            having count(Distinct Ocodigo) > 1
        </cfquery>
        
        <cfif rsVerificaOf.recordcount GT 0>
        	<cfloop query="rsVerificaOf">
            	<!---ABCO/ABG. Se valida si la transacción tiene una oficina definida--->
                <cfquery name="rsOfiTran" datasource="#session.dsn#">
                    select isnull(Ocodigo,-1) as Ocodigo 
                    from FAPFTransacciones
                    where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">
                    and	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and Ocodigo is not null
                </cfquery>
                
                <cfif rsOfiTran.recordcount EQ 1 and rsOfiTran.Ocodigo NEQ -1>
					<cfquery datasource="#session.dsn#">
                    	update #PF_aplicacion# 
                        set Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOfiTran.Ocodigo#">
                        where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.SNcodigo#">
                        and PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVerificaOf.PFTcodigo#">
                        and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.Mcodigo#">
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
        
        <!--- Se toman los valores para saber cuantos documentos se crearan mediante la llave
		PFTcodigo,SNcodigo,Mcodigo --->    
        <cfquery name="rsPFllave" datasource="#session.dsn#">
        	select distinct PFTcodigo,SNcodigo,Mcodigo,Ocodigo
            from #PF_aplicacion#
        </cfquery>
		
        <!---ABCO. Tabla de control--->
        <cf_dbtemp name="PF_EControl" returnvariable="PF_EControl" datasource="#session.dsn#">
            <cf_dbtempcol name="OImpresionID" type="integer"> 
            <cf_dbtempcol name="OIDetalle" type="integer"> 	
            <cf_dbtempcol name="ItemTipo" type="char(1)">
            <cf_dbtempcol name="ItemCodigo" type="integer"> 
            <cf_dbtempcol name="OIDAlmacen" type="integer">
            <cf_dbtempcol name="Ccuenta" type="integer">
            <cf_dbtempcol name="Ecodigo" type="integer">
            <cf_dbtempcol name="Ocodigo" type="integer">
            <cf_dbtempcol name="Icodigo" type="varchar(15)">
            <cf_dbtempcol name="CFid" type="integer">
        </cf_dbtemp>

        <cfloop query="rsPFllave">
                
	    <!---ERBG Busca el Centro Funcional y Cuenta Contable Default para el tipo de Transacción que trae la Prefactura INICIA--->
            <cfif isdefined("Form.opt_CF")>
                <cfquery name="rsCFD" datasource="#session.DSN#">
                    select CFid from FAPFTransacciones
                    where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                    and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">		
                </cfquery>
                
				<cfif len(trim(rsCFD.CFid))>
                    <cfset Var_CFid = "#rsCFD.CFid#">
                <cfelse>
                	<cfabort showerror="La transación de Pre-Factura No tiene Centro Funcional Default">
                </cfif>  
                              
            <cfelse>
                <cfset Var_CFid = 0>
                
            </cfif>
            <cfif isdefined("Form.opt_CC")>
                <cfquery name="rsCCD" datasource="#session.DSN#">
                    select CCuenta from FAPFTransacciones
                    where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                    and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">		
                </cfquery>
				<cfif len(trim(rsCCD.CCuenta))>
                    <cfset Var_CcuentaDef = "#rsCCD.CCuenta#">
                <cfelse>
                	<cfabort showerror="La transación de Pre-Factura No tiene Cuenta Default">
                </cfif>
            <cfelse>
                <cfset Var_CcuentaDef = 0>
            </cfif>
            
         <!---ERBG Busca el Centro Funcional Default y Cuenta Contable Default para el tipo de Transacción que trae la Prefactura TERMINA--->
       
        
        	<!--- Tabla de Documentos a Reversar --->
	        <cf_dbtemp name="PF_reversa" returnvariable="PF_reversa" datasource="#session.dsn#">
				<cf_dbtempcol name="DdocumentoREF" type="char(20)">
        	    <cf_dbtempcol name="CCTcodigoREF" type="char(2)"> 
				<cf_dbtempcol name="CCTcodigoREV" type="char(2)">
                <cf_dbtempcol name="CFid" type="int">
                <cf_dbtempcol name="CCuenta" type="int">
			</cf_dbtemp>
        	<cftransaction>
			<!---Validaciones para Aplicar --->
            <!--- La prefactura debe de tener Lineas de Detalle --->
            <cfquery name="rsVerifica" datasource="#session.dsn#">
            	select IDpreFactura		
                from #PF_aplicacion# pf
                where not exists(select 1 from FAPreFacturaD where IDpreFactura = pf.IDpreFactura)
                and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
            </cfquery>
			<cfif rsVerifica.recordcount GT 0>
            	<cfabort showerror="Pre-Factura No tiene lineas de Detalle">
			</cfif>

			<cfset varGeneraDoc = true>
        	<!--- Si la Prefactura es de Tipo Credito y fue aplicada junto con 
			Prefacturas de tipo Debito que la referencien no genera Documento solo es aplicada
			como un descuento en la factura --->
            <cfquery name="rsVerifica" datasource="#session.dsn#">
            	select IDpreFactura
                from #PF_aplicacion# pf 
                		inner join FAPFTransacciones pft
                		on pf.PFTcodigo = pft.PFTcodigo 
                        and pft.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                and pft.PFTcodigoRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
            </cfquery>
            <cfif rsVerifica.recordcount GT 0>
            	<cfset varGeneraDoc = false>
			</cfif>
			<cfif varGeneraDoc>
	            <!--- valores de catalogo para la transaccion de Prefactura --->
    	        <cfquery name="rsPFtransaccion" datasource="#session.dsn#">
        	    	select * 
            	    from FAPFTransacciones
                	where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
	                and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    	        </cfquery>
                
                <!--- Cuenta de Cliente para El socio de Negocios --->
                <cfquery name="rsSNcuenta" datasource="#session.dsn#">
        	    	select SNnombre,SNcuentacxc
            	    from SNegocios
                	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#"> 
    	        </cfquery>
                <cfif rsSNcuenta.recordcount GT 0 AND rsSNcuenta.SNcuentacxc NEQ "" AND len(ltrim(rsSNcuenta.SNcuentacxc))>
					<cfset varSNcuenta = rsSNcuenta.SNcuentacxc>
                <cfelse>
                	<cfabort showerror="Socio de Negocios #rsSNcuenta.SNnombre# no tiene Cuenta Cliente para CxC correctamente definida">
                </cfif>
                
                <!--- Obtiene valor default para concepto de cobro --->
                <cfquery name="rsTESRPTconcepto" datasource="#Session.DSN#" >
					select 	min(TESRPTCid) as TESRPTCid
					from TESRPTconcepto 
		 			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			 		and TESRPTCcxc=1
					and TESRPTCdevoluciones=0
				</cfquery>
                <cfif isdefined("rsTESRPTconcepto.TESRPTCid") and rsTESRPTconcepto.TESRPTCid NEQ "">
                	<cfset LvarTESRPTCid = rsTESRPTconcepto.TESRPTCid>
				<cfelse>
                	<cfabort showerror="No existe ningun Concepto de Cobro definido en el sistema">
				</cfif>
                
                <!--- Averiguar si el tipo de transaccion es debito o credito --->
				<cfquery name="rsCCTransaccion" datasource="#Session.DSN#">
					select CCTtipo
					from CCTransacciones
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPFtransaccion.CCTcodigoRef#">
				</cfquery>
        
				<cfif rsPFtransaccion.PFTcodigoRef NEQ "" and len(trim(rsPFtransaccion.PFTcodigoRef))>
	                <!--- Descuento a aplicar de las Prefacturas de Credito Referenciadas --->
    	            <cfquery name="rsDescuento" datasource="#session.dsn#">
						select isnull(sum(pf.Total),0) as Descuento
            	        from FAPreFacturaE pf 
                	    	inner join #PF_aplicacion# pfa 
                    	    on pf.IDpreFactura = pfa.IDpreFactura
                            and pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                    where pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
                        and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                		and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
    	            </cfquery>
                    <cfset varDescuento = rsDescuento.Descuento>
                <cfelse>
                	<cfset varDescuento = 0>
                </cfif>
                
                <!--- Direccion de Facturacion --->
                <cfquery name="rsDireccion" datasource="#session.dsn#">
                	select min(id_direccion) as Direccion 
                    from FAPreFacturaE pf 
                	    	inner join #PF_aplicacion# pfa 
                    	    on pf.IDpreFactura = pfa.IDpreFactura
                            and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                    where pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
		                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                </cfquery>
                
                <cfset varIDdireccion = rsDireccion.Direccion>
                
                <!--- Tipo de Cambio --->
                <cfif rsPFllave.Mcodigo NEQ varMonedaL>
	                <cfquery name="rsTCC" datasource="#session.dsn#">
    	            	select count(1) as CantidadPF 
        	            from #PF_aplicacion# pfa 
            	        where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
		        	        and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		    	    and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                        OR
    	                    (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
			                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        			        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
    	            </cfquery>
        	        
            	    <cfquery name="rsTC" datasource="#session.dsn#">
                		select sum(TipoCambio)/<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTCC.CantidadPF#"> as TCambio 
                    	from FAPreFacturaE pf 
	                	    	inner join #PF_aplicacion# pfa 
    	                	    on pf.IDpreFactura = pfa.IDpreFactura
        	                    and pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	        	        where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
		        	        and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		    	    and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                        OR
    	                    (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
			                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        			        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                </cfquery>
                	<cfset varTCambio = rsTC.TCambio>
				<cfelse>
                	<cfset varTCambio = 1>
				</cfif>
                
				<!--- Se prepara el Numero de Documento para la Orden de Impresion --->
            	<cfquery name="rsNumOI" datasource="#session.dsn#">
	            	select isnull(max(OImpresionNumero),0) + 1 as NumOI
    	            from FAEOrdenImpresion
        	        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
            	</cfquery>
	            <cfset varNumOI = rsNumOI.NumOI>
    	        <cfset varDocOI = "OI-" & rsNumOI.NumOI>
        	    <cfset varPFTcodigo = rsPFtransaccion.PFTcodigo>
            	<cfset varCCTcodigoRef = rsPFtransaccion.CCTcodigoRef>
	            <cfset varFormato = rsPFtransaccion.FMT01COD>
            	<!---<cfdump var="No Orden: #varNumOI#">
	                     <cfdump var="Document: #varDocOI#">
        	             <cfdump var="Socio: #rsPFllave.SNcodigo#">
            	         <cfdump var="Moneda: #rsPFllave.Mcodigo#">
                	     <cfdump var="Trans: #varCCTcodigoRef#">
                    	 <cfdump var="Formato: #varFormato#">
	                     <cfdump var="Ofic: #rsPFllave.Ocodigo#">
    	                 <cfdump var="Cuenta: #varSNcuenta#">
        	             <cfdump var="Descuento: #varDescuento#">
                	     <cfdump var="Fecha: #now()#">
                    	 <cfdump var="Usuair: #session.Usuario#">
                         <cfdump var="Dir: #varIDdireccion#">
            	         <cfdump var="Tipo Cam: #varTCambio#">
	                     <cf_dump var="Cod: #session.Usucodigo#"> --->
                <!--- Inserta Encabezado de la Orden de Impresion --->
        	    <cfquery name="insertOIE" datasource="#session.dsn#">
            		insert into FAEOrdenImpresion 
                    	(OImpresionNumero, OIdocumento, Ecodigo, SNcodigo, Mcodigo,
                         CCTcodigo, FormatoImpresion, Ocodigo, Ccuenta, Rcodigo, 
                         OIdescuento, OIimpuesto, OItotal, OIfecha, OIusurio, 
                         OIvencimiento, OIvendedor, id_direccionFact, id_direccionEnvio, 
                         OIdiasvencimiento, OIObservacion, OItipoCambio, OIEstado, 
                         BMUsucodigo, TESRPTCid, TESRPTCietu)
            		values
                		(<cfqueryparam cfsqltype="cf_sql_integer" value="#varNumOI#">,
	                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
    	                 <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
        	             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
            	         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">,
                	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
                    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#varFormato#">,
	                     <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">,
    	                 <cfqueryparam cfsqltype="cf_sql_integer" value="#varSNcuenta#">,
        	             null,
            	         <cfqueryparam cfsqltype="cf_sql_money" value="#varDescuento#">,
                	     0,0, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                    	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
	                     null,
	   	                 <cfif varIDdireccion EQ "">
							null,
                            null,                         
                         <cfelse>
                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
	   	    	            <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
                         </cfif>
            	         0,
                	     null,
                    	 <cfqueryparam cfsqltype="cf_sql_float" value="#varTCambio#">,
	                     'P',
    	                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTESRPTCid#">,
                         <cfif rsCCTransaccion.CCTtipo EQ 'C'>	<!--- 1=Documento Normal DB, 0=Documento Contrario CR --->
							0
						<cfelse>				
							1
						</cfif>
                     	)
            			<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertOIE">
           		<cfquery name="rsOIDetalles" datasource="#session.dsn#">
            		select IDpreFactura
	                from #PF_aplicacion# pf
    	            where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        	        and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
            	    and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                	and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
	            </cfquery>
				
                <cfset varOficina = rsPFllave.Ocodigo>
                
				<cfset varDetalle = 1>
            	<cfloop query="rsOIDetalles">
             		<!--- Reversa Estimados Previos --->
                    <cfquery datasource="#session.dsn#">
                    	insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV,CFid,CCuenta)
                        select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV,#Var_CFid#,#Var_CcuentaDef#
                        from FAPreFacturaE pf
                        		inner join Documentos d
                                	inner join CCTransacciones t
                                    on d.Ecodigo = t.Ecodigo
                                    and d.CCTcodigo = t.CCTcodigo
                                    and t.CCTestimacion = 1
                                on pf.Ecodigo = d.Ecodigo 
                                and pf.DdocumentoREF = d.Ddocumento
                                and pf.CCTcodigoREF = d.CCTcodigo
                                and d.Dsaldo > 0
                        where pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and pf.IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#"> 
                        and pf.TipoDocumentoREF = 0
                    </cfquery>
                                      
                    <cfquery name="rsDatos" datasource="#session.dsn#">
                		select * 
                        from FAPreFacturaD fap
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
	                </cfquery>
					
				    <cfloop query="rsDatos">
                       	<!--- Busca la Cuenta Contable para El detalle --->
						<cfif rsDatos.TipoLinea EQ "A">
                        	<cfquery name="rsCuentaC" datasource="#session.dsn#">
	                            select case when tr.CCTafectacostoventas = 1 
    	                            	then iac.IACcostoventa else iac.IACinventario end as Ccuenta
								from Existencias exi, IAContables iac, CCTransacciones tr
								where exi.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
						 	    and exi.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#"> 
							    and iac.IACcodigo = exi.IACcodigo
			 					and iac.Ecodigo = exi.Ecodigo
                                and exi.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            	and tr.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                                and tr.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">
                            </cfquery>
                        <cfelse>
                        	<cfquery name="rsCuentaC" datasource="#session.dsn#">
                            	select Ccuenta 
                                from CContables cc 
                                	inner join Conceptos c
                                    on cc.Ecodigo = c.Ecodigo 
                                    and cc.Cformato = c.Cformato
                            	where 
                                	c.Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                                    and c.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            </cfquery>
                        </cfif>
                        
                        <cfif isdefined("rsCuentaC") and rsCuentaC.Ccuenta NEQ "" and len(ltrim(rsCuentaC.Ccuenta))>
                        	<cfset varCcuenta = rsCuentaC.Ccuenta>
                        <cfelseif len(rsDatos.Ccuenta) LTE 0>
                        	<cfif rsDatos.TipoLinea EQ "A">
                        		<cfquery name="rsErrorC" datasource="#session.dsn#">
	                            	select Adescripcion
									from Articulos
									where Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
							 	    	and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            	</cfquery>
                                <cfabort showerror="Articulo: #rsErrorC.Adescripcion# no tiene Cuenta Definida">  
	                        <cfelse>
    	                    	<cfquery name="rsErrorC" datasource="#session.dsn#">
        	                    	select Cdescripcion
            	                    from Conceptos 
                            		where Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                                    	and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                            </cfquery>
                                <cfabort showerror="Concepto: #rsErrorC.Cdescripcion# no tiene Cuenta Definida">
                        	</cfif>
                        </cfif>
						
						<!---ABCO. Verifica si inserta Detalle o Actualiza uno ya existente--->
						<cfquery name="rsVerificaDet" datasource="#session.dsn#">
							select * from #PF_EControl#
							where
							ItemTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">
							<cfif rsDatos.TipoLinea EQ "A">
	                        	and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
                            <cfelse>
                            	and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                            </cfif>
							<cfif rsDatos.TipoLinea EQ "A">
	                          	and OIDAlmacen = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">
                            <cfelse>
                              	and isnull(OIDAlmacen,-1) = -1
                            </cfif>
<!---ERBG Pone el Cuenta Default INICIA--->	
						<cfif isdefined("Form.opt_CC")>
                        	and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">
                        <cfelse>                        
								<cfif len(rsDatos.Ccuenta) GT 0>
                                   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">
                                <cfelse>
                                   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">
                                </cfif>
                        </cfif>
<!---ERBG Pone el Cuenta Default FIN--->								
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">
							and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">
<!---ERBG Pone el Centro Funcional Default INICIA--->
						<cfif isdefined("Form.opt_CF")>
                            and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
                        <cfelse>
                            and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
                        </cfif>
<!---ERBG Pone el Centro Funcional Default FIN--->						
						</cfquery>
						
						<cfif rsVerificaDet.recordcount GT 0>
							<!---ABCO. Actualiza el registro del detalle--->
							<cfquery datasource="#session.dsn#">
								update FADOrdenImpresion
	 								set OIDCantidad = OIDCantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,    	                            
                                    OIDtotal = OIDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
                                    OIDdescuento = OIDdescuento + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
                                    OIDPrecioUni = (OIDtotal + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#"> + OIDdescuento + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">)/(OIDCantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">)
                                where
								OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OImpresionID#">
								and OIDetalle = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OIDetalle#">

							</cfquery>
						<cfelse>
							<cfquery datasource="#session.dsn#">
	                            insert FADOrdenImpresion 
    	                        	(OImpresionID, OIDetalle, ItemTipo, ItemCodigo, OIDAlmacen,
        	                         Ccuenta, Ecodigo, OIDdescripcion,OIDdescnalterna,Dcodigo, 
            	                     OIDCantidad,OIDPrecioUni,OIDtotal,
                	                 OIDdescuento, Icodigo, CFid, BMUsucodigo)
                    	        values
                        	    	(<cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">, 
                            	     <cfqueryparam cfsqltype="cf_sql_integer" value="#varDetalle#">, 
                                	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
	                                 <cfif rsDatos.TipoLinea EQ "A">
		                                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
        	                         <cfelse>
            	                     	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
                	                 </cfif>
                    	             <cfif rsDatos.TipoLinea EQ "A">
	                    	             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
                            	     <cfelse>
                                	 	null,
	                                 </cfif>
<!---ERBG Pone el Cuenta Default INICIA--->	
									<cfif isdefined("Form.opt_CC")>
                                    	<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">,
                                    <cfelse>                        
										 <cfif len(rsDatos.Ccuenta) GT 0>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
                                         <cfelse>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
                                         </cfif>
                                     </cfif>
                                     
                        	         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
                            		 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion#">,
	                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion_Alt#">,
    	                             null,
        	                         <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,
            	                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.PrecioUnitario#">,
                	                 <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
                    	             <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
                        	         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
<!---ERBG Pone el Centro Funcional Default INICIA--->
                                 	<cfif isdefined("Form.opt_CF")>
                                 		<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">,
                                 	<cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">,
                                 	</cfif>
<!---ERBG Pone el Centro Funcional Default FIN--->
                                	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	                                )
    	                    </cfquery>
							
							<!----ABCO. Inserta en la tabla de Control--->
							<cfquery name="rsInsertControl" datasource="#session.dsn#">
								insert into #PF_EControl# 
								(OImpresionID,
								 OIDetalle,
								 ItemTipo,
								 ItemCodigo,
								 OIDAlmacen,
								 Ccuenta,
								 Ecodigo,
                                 Ocodigo,
								 Icodigo,
                                 CFid)
								 values
								 (<cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">, 
                	              <cfqueryparam cfsqltype="cf_sql_integer" value="#varDetalle#">, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
								  <cfif rsDatos.TipoLinea EQ "A">
	                        	    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
	                              <cfelse>
    	                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
        	                      </cfif>
								  <cfif rsDatos.TipoLinea EQ "A">
	            	              	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
                    	          <cfelse>
                        	      	null,
                            	  </cfif>
								<!---ERBG Pone el Cuenta Default INICIA--->	
								<cfif isdefined("Form.opt_CC")>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">
                                <cfelse>                        
									  <cfif len(rsDatos.Ccuenta) GT 0>
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
                                      <cfelse>
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
                                      </cfif>
                                </cfif> 
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
                                  <!---ERBG Pone el Centro Funcional Default INICIA--->
								 <cfif isdefined("Form.opt_CF")>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
                                 <cfelse>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
                                 </cfif>
                                    )
								  <!---ERBG Pone el Centro Funcional Default FIN--->
							</cfquery>
		
							<cfset varDetalle = varDetalle + 1>
					</cfif>
                    
		            </cfloop> <!--- Loop Detalles --->
					
	                <!--- Actualiza el Descuento de la OI con el descuento de la Prefctura --->
    	            <cfquery name="rsDescuentoPF" datasource="#session.DSN#">
        	           select isnull(Descuento,0) as Descuento
            	       from FAPreFacturaE
                	   where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                       and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
	                </cfquery>
                    <cfquery datasource="#session.DSN#">
						update FAEOrdenImpresion 
                        set OIdescuento = OIdescuento + 
							<cfif isdefined("rsDescuentoPF") and rsDescuentoPF.Descuento NEQ ""> <cfqueryparam cfsqltype="cf_sql_money" value="#rsDescuentoPF.Descuento#">
                            <cfelse> 0
                            </cfif>
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertOIE.identity#">
                    </cfquery>

                    <!--- Actualiza El estatus de las PreFacturas a Terminadas --->
                    <cfquery datasource="#session.DSN#">
						update FAPreFacturaE 
							set	Estatus='T'
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">		
							and Estatus in ('P','E')
					</cfquery>
    	        </cfloop> <!--- Loop de Encabezados --->
                
				<!--- Actualiza los Totales en el encabezado de La Orden de Impresion --->
                <cfquery name="rsTotalesOI" datasource="#session.DSN#">
					Select 
						sum(cd.OIDdescuento) as sumDescuento,
						sum(OIDCantidad * OIDPrecioUni) as sumSubTotal, 
						sum(((OIDCantidad * OIDPrecioUni) -  cd.OIDdescuento)
								* 
							(Iporcentaje / 100)) as sumImpuesto
					from FADOrdenImpresion cd
						inner join Impuestos i
						on i.Icodigo=cd.Icodigo
						and i.Ecodigo=cd.Ecodigo
					where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and cd.OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfif isdefined('rsTotalesOI') 
					and rsTotalesOI.recordCount GT 0 
					and rsTotalesOI.sumSubTotal NEQ ''
					and rsTotalesOI.sumImpuesto NEQ ''
					and rsTotalesOI.sumDescuento NEQ ''>
					<cfset TotalCot = 0>
					<cfset TotalCot = (rsTotalesOI.sumSubTotal + rsTotalesOI.sumImpuesto) - rsTotalesOI.sumDescuento>
		            <cfquery name="update" datasource="#session.DSN#">
						update FAEOrdenImpresion
						set			
						OIimpuesto=isnull(OIimpuesto,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesOI.sumImpuesto#">,  						
                        OItotal=isnull(OItotal,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - isnull(OIdescuento,0)
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">		
					</cfquery> 
                <cfelse>
                   	<cfquery name="update" datasource="#session.DSN#">
						update FAEOrdenImpresion 
							set			
								OIImpuesto=0,  
								OItotal=0
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and OImpresionID = <cfqueryparam value="#insertOIE.identity#" cfsqltype="cf_sql_numeric">		
					</cfquery> 	
                </cfif>
				<!--- Actualiza la Tabla de Prefacturas especificando el documento generado por la aplicacion--->
                <cfquery datasource="#session.DSN#">
                	update FAPreFacturaE
                    set DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
                    CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
                    TipoDocumentoREF = 1
                    from FAPreFacturaE a
                    	inner join #PF_aplicacion# pf 
                        on a.IDpreFactura = pf.IDpreFactura
                    where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                		and 
                        (pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                        	or 
                         pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)   
                </cfquery>
               <!--- Guarda Registro en Bitacora de Movimientos PF --->
               <cfquery datasource="#session.DSN#">
                	insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
                    select  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
                    		a.IDpreFactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            'I',
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from FAPreFacturaE a
                    	inner join #PF_aplicacion# pf 
                        on a.IDpreFactura = pf.IDpreFactura
                    where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                		and 
                        (pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                        	or 
                         pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)   
                </cfquery>
			<cfelse>
            	<!--- Si no Genera Documento Se marca la PreFactura como Terminada --->
								
                <cfquery datasource="#session.DSN#">
						update FAPreFacturaE 
							set	Estatus='T'
						from FAPreFacturaE a 
                        	inner join #PF_aplicacion# pf 
                            on a.IDpreFactura = pf.IDpreFactura
                        where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                			and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                            and a.Estatus in ('P','E')
				</cfquery>
                
                <!--- Si no Genera Documento Reversa Estimados Previos --->
                <cfquery name="rsDocRev" datasource="#session.dsn#">
                   	insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV)
                    select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV
                    from FAPreFacturaE pf
                    	inner join Documentos d
                           	inner join CCTransacciones t
                            on d.Ecodigo = t.Ecodigo
                            and d.CCTcodigo = t.CCTcodigo
                            and t.CCTestimacion = 1
                        on pf.Ecodigo = d.Ecodigo 
                        and pf.DdocumentoREF = d.Ddocumento
                        and pf.CCTcodigoREF = d.CCTcodigo
                        and d.Dsaldo > 0
                        inner join #PF_aplicacion# pfa 
                        on pf.IDpreFactura = pfa.IDpreFactura
                        and pf.TipoDocumentoREF = 0
                    where pf.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                		and pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                </cfquery>
			</cfif>
            </cftransaction>
            <!--- Reversa Los Estimados Previos --->
            <cfquery name="rsDocRev" datasource="#session.dsn#">
            	select distinct DdocumentoREF, CCTcodigoREF, CCTcodigoREV,COALESCE(CFid,0) as CFid,COALESCE(CCuenta,0) as CCuenta
                from #PF_reversa#
            </cfquery>
			<cfif isdefined("rsDocRev") AND rsDocRev.recordcount GT 0>
           		<cfif rsDocRev.CCTcodigoREF NEQ "" and rsDocRev.DdocumentoREF NEQ "" and rsDocRev.CCTcodigoREV NEQ "">
	                <cfloop query="rsDocRev">
    	         		<cfinvoke 
						component="sif.Componentes.ReversionDocNoFact" 
						method="Reversion" 
						Modulo="CXC"
						debug="false"
						ReversarTotal="true"
						CCTcodigo="#rsDocRev.CCTcodigoREF#"
						CCTCodigoRef="#rsDocRev.CCTcodigoREV#"
						Ddocumento="#rsDocRev.DdocumentoREF#"
                        CFid="#rsDocRev.CFid#"
                        CCuenta="#rsDocRev.CCuenta#"
						/> 
             		</cfloop> <!--- Loop de Reversa--->
	            </cfif>
            </cfif>
 	    </cfloop> <!---Loop de Llave --->        
	</cfif>
<cfelseif (isdefined("Form.btnAplicar_Estimado"))> <!--- Aplica Estimados --->
	<cfif (isdefined("Form.chk"))>
		<!--- Se crea una Tabla temporal para detectar cuantos documentos se crearan --->
        <cf_dbtemp name="PF_aplicacion" returnvariable="PF_aplicacion" datasource="#session.dsn#">
			<cf_dbtempcol name="PFTcodigo" type="char(2)">
            <cf_dbtempcol name="SNcodigo" type="int"> 
			<cf_dbtempcol name="Mcodigo" type="int">
            <cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="IDpreFactura" type="int"> 
		</cf_dbtemp>
		<cfset datos = ListToArray(Form.chk,",")>
        <cfset limite = ArrayLen(datos)>
		<cfloop from="1" to="#limite#" index="idx">
			<!--- Toma los valores para la Prefactura --->
            <cfquery name="rsPreFact" datasource="#session.dsn#">
            	select PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura
                from FAPreFacturaE
                where IDpreFactura = <cfqueryparam value="#datos[idx]#" cfsqltype="cf_sql_integer">
            </cfquery>
			
			<!--- Inserta valores en tabla Temporal --->
            <cfquery datasource="#session.dsn#">
            	insert into #PF_aplicacion# (PFTcodigo,SNcodigo,Mcodigo,Ocodigo,IDpreFactura)
                values
                (<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.SNcodigo#">,
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Mcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.Ocodigo#">,				 	
                 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreFact.IDpreFactura#">)
            </cfquery>	
		</cfloop>
		
        <!--- ABCO. Revisa si se aplicaron prefacturas del mismo socio de diferente oficina --->
        <cfquery name="rsVerificaOf" datasource="#session.dsn#">
        	select SNcodigo, PFTcodigo, Mcodigo, count(Distinct Ocodigo) as Conteo
            from #PF_aplicacion#
            group by SNcodigo, PFTcodigo, Mcodigo
            having count(Distinct Ocodigo) > 1
        </cfquery>
        
        <cfif rsVerificaOf.recordcount GT 0>
        	<cfloop query="rsVerificaOf">
            	<!---ABCO/ABG. Se valida si la transacción tiene una oficina definida--->
                <cfquery name="rsOfiTran" datasource="#session.dsn#">
                    select isnull(Ocodigo,-1) as Ocodigo 
                    from FAPFTransacciones
                    where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreFact.PFTcodigo#">
                    and	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and Ocodigo is not null
                </cfquery>
                
                <cfif rsOfiTran.recordcount EQ 1 and rsOfiTran.Ocodigo NEQ -1>
					<cfquery datasource="#session.dsn#">
                    	update #PF_aplicacion# 
                        set Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOfiTran.Ocodigo#">
                        where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.SNcodigo#">
                        and PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVerificaOf.PFTcodigo#">
                        and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaOf.Mcodigo#">
                    </cfquery>
                </cfif>
            </cfloop>
        </cfif>
		        
        <!--- Se toman los valores para saber cuantos documentos se crearan mediante la llave
		PFTcodigo,SNcodigo,Mcodigo --->    
        <cfquery name="rsPFllave" datasource="#session.dsn#">
        	select distinct PFTcodigo,SNcodigo,Mcodigo,Ocodigo
            from #PF_aplicacion#
        </cfquery>
		
        <!---ABCO. Tabla de control--->
        <cf_dbtemp name="PF_EControl" returnvariable="PF_EControl" datasource="#session.dsn#">
            <cf_dbtempcol name="OImpresionID" type="integer"> 
            <cf_dbtempcol name="OIDetalle" type="integer"> 	
            <cf_dbtempcol name="ItemTipo" type="char(1)">
            <cf_dbtempcol name="ItemCodigo" type="integer"> 
            <cf_dbtempcol name="OIDAlmacen" type="integer">
            <cf_dbtempcol name="Ccuenta" type="integer">
            <cf_dbtempcol name="Ecodigo" type="integer">
            <cf_dbtempcol name="Ocodigo" type="integer">
            <cf_dbtempcol name="Icodigo" type="varchar(15)">
            <cf_dbtempcol name="CFid" type="integer">
        </cf_dbtemp>
        
		<cfloop query="rsPFllave">
	     	<!---ERBG Busca el Centro Funcional y Cuenta Default para el tipo de Transacción que trae la Prefactura INICIA--->
	            <cfif isdefined("Form.opt_CF")>
	                <cfquery name="rsCFD" datasource="#session.DSN#">
	                    select CFid from FAPFTransacciones
	                    where PFTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
	                    and Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">		
	                </cfquery>
					<cfif len(trim(rsCFD.CFid))>
                        <cfset Var_CFid = "#rsCFD.CFid#">
                    <cfelse>
	                	<cfabort showerror="La transación de Pre-Factura No tiene Centro Funcional Default">
                    </cfif>
	            <cfelse>
	                <cfset Var_CFid = 0>
	            </cfif>
            <cfif isdefined("Form.opt_CC")>
                <cfquery name="rsCCD" datasource="#session.DSN#">
                    select CCuenta from FAPFTransacciones
                    where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                    and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">		
                </cfquery>
				<cfif len(trim(rsCCD.CCuenta))>
                    <cfset Var_CcuentaDef = "#rsCCD.CCuenta#">
                <cfelse>
                	<cfabort showerror="La transación de Pre-Factura No tiene Cuenta Default">
                </cfif>
            <cfelse>
                <cfset Var_CcuentaDef = 0>
            </cfif>
	       	<!---ERBG Busca el Centro Funcional y Cuenta Default para el tipo de Transacción que trae la Prefactura TERMINA--->
            
            
            
        	<!--- Tabla de Documentos a Reversar --->
	        <cf_dbtemp name="PF_reversa" returnvariable="PF_reversa" datasource="#session.dsn#">
				<cf_dbtempcol name="DdocumentoREF" type="char(20)">
        	    <cf_dbtempcol name="CCTcodigoREF" type="char(2)"> 
				<cf_dbtempcol name="CCTcodigoREV" type="char(2)">
            	<cf_dbtempcol name="CFid" type="int">
                <cf_dbtempcol name="CCuenta" type="int">
			</cf_dbtemp>
	        <cftransaction>
        	<!---Validaciones para Aplicar --->
            <!--- La prefactura debe de tener Lineas de Detalle --->
            <cfquery name="rsVerifica" datasource="#session.dsn#">
            	select IDpreFactura
                from #PF_aplicacion# pf
                where not exists(select 1 from FAPreFacturaD where IDpreFactura = pf.IDpreFactura)
                and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
            </cfquery>
			<cfif rsVerifica.recordcount GT 0>
            	<cfabort showerror="Pre-Factura No tiene lineas de Detalle">
			</cfif>

			<cfset varGeneraDoc = true>
        	<!--- Si la Prefactura es de Tipo Credito y fue aplicada junto con 
			Prefacturas de tipo Debito que la referencien no genera Documento solo es aplicada
			como un descuento en la factura --->
            <cfquery name="rsVerifica" datasource="#session.dsn#">
            	select IDpreFactura
                from #PF_aplicacion# pf 
                		inner join FAPFTransacciones pft
                		on pf.PFTcodigo = pft.PFTcodigo 
                        and pft.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                and pft.PFTcodigoRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
            </cfquery>
            <cfif rsVerifica.recordcount GT 0>
            	<cfset varGeneraDoc = false>
			</cfif>
			
			<cfif varGeneraDoc>
	            <!--- valores de catalogo para la transaccion de Prefactura --->
    	        <cfquery name="rsPFtransaccion" datasource="#session.dsn#">
        	    	select * 
            	    from FAPFTransacciones
                	where PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
	                and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
    	        </cfquery>
                
                <!--- Cuenta de Cliente para El socio de Negocios --->
                <cfquery name="rsSNcuenta" datasource="#session.dsn#">
        	    	select SNnombre,SNcuentacxc
            	    from SNegocios
                	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#"> 
    	        </cfquery>
                <cfif rsSNcuenta.recordcount GT 0 AND rsSNcuenta.SNcuentacxc NEQ "" AND len(ltrim(rsSNcuenta.SNcuentacxc))>
					<cfset varSNcuenta = rsSNcuenta.SNcuentacxc>
                <cfelse>
                	<cfabort showerror="Socio de Negocios #rsSNcuenta.SNnombre# no tiene Cuenta Cliente para CxC correctamente definida">
                </cfif>
                <!--- Averiguar si el tipo de transaccion es debito o credito --->
				<cfquery name="rsCCTransaccion" datasource="#Session.DSN#">
					select CCTtipo
					from CCTransacciones
					where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPFtransaccion.CCTcodigoRef#">
				</cfquery>
				<cfif rsPFtransaccion.PFTcodigoRef NEQ "" and len(trim(rsPFtransaccion.PFTcodigoRef))>
	                <!--- Descuento a aplicar de las Prefacturas de Credito Referenciadas --->
    	            <cfquery name="rsDescuento" datasource="#session.dsn#">
						select isnull(sum(pf.Total),0) as Descuento
            	        from FAPreFacturaE pf 
                	    	inner join #PF_aplicacion# pfa 
                    	    on pf.IDpreFactura = pfa.IDpreFactura
                            and pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                    where pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
                        and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
                		and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
    	            </cfquery>
                    <cfset varDescuento = rsDescuento.Descuento>
                <cfelse>
                	<cfset varDescuento = 0>
                </cfif>
                
                <!--- Direccion de Facturacion --->
                <cfquery name="rsDireccion" datasource="#session.dsn#">
                	select min(id_direccion) as Direccion 
                    from FAPreFacturaE pf 
                	    	inner join #PF_aplicacion# pfa 
                    	    on pf.IDpreFactura = pfa.IDpreFactura
                            and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                    where pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
		                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                </cfquery>
                
                <cfset varIDdireccion = rsDireccion.Direccion>
                
                <!--- Tipo de Cambio --->
                <cfif rsPFllave.Mcodigo NEQ varMonedaL>

	                <cfquery name="rsTCC" datasource="#session.dsn#">
    	            	select count(1) as CantidadPF 
        	            from #PF_aplicacion# pfa 
            	        where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
		        	        and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		    	    and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                        OR
    	                    (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
			                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        			        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
    	            </cfquery>
        	        
            	    <cfquery name="rsTC" datasource="#session.dsn#">
                		select sum(TipoCambio)/<cfqueryparam cfsqltype="cf_sql_integer" value="#rsTCC.CantidadPF#"> as TCambio 
                    	from FAPreFacturaE pf 
	                	    	inner join #PF_aplicacion# pfa 
    	                	    on pf.IDpreFactura = pfa.IDpreFactura
        	                    and pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	        	        where (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">
		        	        and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        		    	    and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                        OR
    	                    (pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
			                and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        			        and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">) 
	                </cfquery>
                	<cfset varTCambio = rsTC.TCambio>
				<cfelse>
                	<cfset varTCambio = 1>
				</cfif>
                
				<!--- Se prepara el Numero de Documento para la Estimacion --->
            	<cfquery name="rsNumOI" datasource="#session.dsn#">
	            	select isnull(count(1),0) as NumOI
    	            from HDocumentos
        	        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and Ddocumento like 'EPF' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#"> + '-%'
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#">
            	</cfquery>
	            <cfset varNumOI = rsNumOI.NumOI>
                <cfquery name="rsNumOI" datasource="#session.dsn#">
	            	select isnull(count(1),0) as NumOI
    	            from EDocumentosCxC
        	        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    and EDdocumento like 'EPF' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#"> + '-%'
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#">
            	</cfquery>
                <cfset varNumOI = varNumOI + rsNumOI.NumOI>
                <cfset varNumOI = varNumOI + 1>
    	        <cfset varDocOI = "EPF#rsPFtransaccion.CCTcodigoEst#-#varNumOI#">
				<cfset varPFTcodigo = rsPFtransaccion.PFTcodigo>
            	<cfset varCCTcodigoRef = rsPFtransaccion.CCTcodigoRef>
	            <cfset varFormato = rsPFtransaccion.FMT01COD>
				
            	<!---<cfdump var="No Orden: #varNumOI#">
	                     <cfdump var="Document: #varDocOI#">
        	             <cfdump var="Socio: #rsPFllave.SNcodigo#">
            	         <cfdump var="Moneda: #rsPFllave.Mcodigo#">
                	     <cfdump var="Trans: #varCCTcodigoRef#">
                    	 <cfdump var="Formato: #varFormato#">
	                     <cfdump var="Ofic: #rsPFllave.Ocodigo#">
    	                 <cfdump var="Cuenta: #varSNcuenta#">
        	             <cfdump var="Descuento: #varDescuento#">
                	     <cfdump var="Fecha: #now()#">
                    	 <cfdump var="Usuair: #session.Usuario#">
                         <cfdump var="Dir: #varIDdireccion#">
            	         <cfdump var="Tipo Cam: #varTCambio#">
	                     <cf_dump var="Cod: #session.Usucodigo#"> --->
                <!--- Inserta Encabezado de la Orden de Impresion --->
        	    <cfquery name="insertEST" datasource="#session.dsn#">
            		insert into EDocumentosCxC	
                        (Ocodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo,
                    	EDtipocambio, Ccuenta, EDdescuento, EDporcdesc, EDimpuesto, 
                        EDtotal, EDfecha, EDusuario, EDselect, Interfaz, 
                        id_direccionFact, id_direccionEnvio, DEdiasVencimiento, 
                    	DEobservacion, DEdiasMoratorio, Ecodigo, BMUsucodigo, TESRPTCietu)
					values
                		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
            	         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">,
	                     <cfqueryparam cfsqltype="cf_sql_float" value="#varTCambio#">,                         
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#varSNcuenta#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#varDescuento#">,
                         0,0,0,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
                         0,
                         0,
                         <cfif varIDdireccion EQ "">
							null,
                            null,                         
                         <cfelse>
                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
	   	    	            <cfqueryparam cfsqltype="cf_sql_integer" value="#varIDdireccion#">,
                         </cfif>

                         0,
                         'Estimado de Pre-Factura',
                         0,
                         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
        	             <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                         <cfif rsCCTransaccion.CCTtipo EQ 'C'>	<!--- 1=Documento Normal DB, 0=Documento Contrario CR --->
							0
						<cfelse>				
							1
						</cfif>
                     	)
            			<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertEST">
           		<cfquery name="rsOIDetalles" datasource="#session.dsn#">
            		select IDpreFactura
	                from #PF_aplicacion# pf
    	            where pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
        	        and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
            	    and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                	and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
	            </cfquery>
				
				<cfset varOficina = rsPFllave.Ocodigo>
				<cfset varDetalle = 1>
            	<cfloop query="rsOIDetalles">
             		<!--- Reversa Estimados Previos --->
                    <cfquery datasource="#session.dsn#">
                    	insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV,CFid,CCuenta)
                        select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV,#Var_CFid#,#Var_CcuentaDef#
                        from FAPreFacturaE pf
                        		inner join Documentos d
                                	inner join CCTransacciones t
                                    on d.Ecodigo = t.Ecodigo
                                    and d.CCTcodigo = t.CCTcodigo
                                    and t.CCTestimacion = 1
                                on pf.Ecodigo = d.Ecodigo 
                                and pf.DdocumentoREF = d.Ddocumento
                                and pf.CCTcodigoREF = d.CCTcodigo
                                and d.Dsaldo > 0
                        where pf.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and pf.IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#"> 
                        and pf.TipoDocumentoREF = 0
                    </cfquery>
                    
                    <cfquery name="rsDatos" datasource="#session.dsn#">
                		select * 
                        from FAPreFacturaD fap
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
	                </cfquery>
                    
                    <cfloop query="rsDatos">
                       	<!--- Busca la Cuenta Contable para El detalle --->
						<cfif rsDatos.TipoLinea EQ "A">
                        	<cfquery name="rsCuentaC" datasource="#session.dsn#">
	                            select case when tr.CCTafectacostoventas = 1 
    	                            	then iac.IACcostoventa else iac.IACinventario end as Ccuenta
								from Existencias exi, IAContables iac, CCTransacciones tr
								where exi.Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
						 	    and exi.Alm_Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#"> 
							    and iac.IACcodigo = exi.IACcodigo
			 					and iac.Ecodigo = exi.Ecodigo
                                and exi.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            	and tr.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                                and tr.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCCTcodigoRef#">
                            </cfquery>
                        <cfelse>
                        	<cfquery name="rsCuentaC" datasource="#session.dsn#">
                            	select Ccuenta 
                                from CContables cc 
                                	inner join Conceptos c
                                    on cc.Ecodigo = c.Ecodigo 
                                    and cc.Cformato = c.Cformato
                            	where 
                                	c.Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                                    and c.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            </cfquery>
                        </cfif>
                        
                        <cfif isdefined("rsCuentaC") and rsCuentaC.Ccuenta NEQ "" and len(ltrim(rsCuentaC.Ccuenta))>
                        	<cfset varCcuenta = rsCuentaC.Ccuenta>
                        <cfelseif len(rsDatos.Ccuenta) LTE 0>
                        	<cfif rsDatos.TipoLinea EQ "A">
                        		<cfquery name="rsErrorC" datasource="#session.dsn#">
	                            	select Adescripcion
									from Articulos
									where Aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
							 	    	and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                            	</cfquery>
                                <cfabort showerror="Articulo: #rsErrorC.Adescripcion# no tiene Cuenta Definida">  
	                        <cfelse>
    	                    	<cfquery name="rsErrorC" datasource="#session.dsn#">
        	                    	select Cdescripcion
            	                    from Conceptos 
                            		where Cid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                                    	and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
	                            </cfquery>
                                <cfabort showerror="Concepto: #rsErrorC.Cdescripcion# no tiene Cuenta Definida">
                        	</cfif>
                        </cfif>
                    	
                        <!---ABCO. Verifica si inserta Detalle o Actualiza uno ya existente--->
						<cfquery name="rsVerificaDet" datasource="#session.dsn#">
							select * from #PF_EControl#
							where
							ItemTipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">
							<cfif rsDatos.TipoLinea EQ "A">
	                        	and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">
                            <cfelse>
                            	and ItemCodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">
                            </cfif>
							<cfif rsDatos.TipoLinea EQ "A">
	                          	and OIDAlmacen = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">
                            <cfelse>
                              	and isnull(OIDAlmacen,-1) = -1
                            </cfif>
<!---ERBG Pone el Cuenta Default INICIA--->	
							<cfif isdefined("Form.opt_CC")>
                                and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">
                            <cfelse>                        
								<cfif len(rsDatos.Ccuenta) GT 0>
                                   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">
                                <cfelse>
                                   and Ccuenta = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">
                                </cfif>
                            </cfif>
                            
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                            
                            and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">
                            
							and Icodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">
<!---ERBG Pone el Centro Funcional Default INICIA--->
							 <cfif isdefined("Form.opt_CF")>
                                and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
                             <cfelse>
                                and CFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
                             </cfif>
<!---ERBG Pone el Centro Funcional Default FIN--->                            
						</cfquery>
                        
                        <cfif rsVerificaDet.recordcount GT 0>
							<!---ABCO. Actualiza el registro del detalle--->
							<cfquery datasource="#session.dsn#">
								update DDocumentosCxC
                                	set DDcantidad = DDcantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,    	                            
                                    DDtotallinea = DDtotallinea + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
                                    DDdesclinea = DDdesclinea + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
                                    DDpreciou = (DDtotallinea + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#"> + DDdesclinea + <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">)/(DDcantidad + <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">)
								where
								EDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OImpresionID#">
								and DDlinea = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVerificaDet.OIDetalle#">

							</cfquery>
						<cfelse>
                            <cfquery datasource="#session.dsn#">
                                insert DDocumentosCxC
                                (EDid, Aid, Cid, Alm_Aid, 
                                 Ccuenta, Ecodigo, DDdescripcion, DDdescalterna,
                                 DDcantidad, DDpreciou, DDdesclinea, 
                                 DDporcdesclin, DDtotallinea, DDtipo, Icodigo, CFid,
                                 BMUsucodigo,Dcodigo)
                                 values
                                    (<cfqueryparam cfsqltype="cf_sql_integer" value="#insertEST.identity#">, 
                                     <cfif rsDatos.TipoLinea EQ "A">
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
                                     <cfelse>
                                        null,
                                     </cfif>
                                     <cfif rsDatos.TipoLinea EQ "S">
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
                                     <cfelse>
                                        null,
                                     </cfif>
                                     <cfif rsDatos.TipoLinea EQ "A">
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
                                     <cfelse>
                                        null,
                                     </cfif>
<!---ERBG Pone el Cuenta Default INICIA--->	
									<cfif isdefined("Form.opt_CC")>
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">,
                                    <cfelse>                        
										 <cfif len(rsDatos.Ccuenta) GT 0>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
                                         <cfelse>
                                            <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
                                         </cfif>
                                     </cfif>
<!---ERBG Pone el Cuenta Default FIN--->                                     
                                     <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion#">,
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Descripcion_Alt#">,
                                     <cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.Cantidad#">,
                                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.PrecioUnitario#">,
                                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.DescuentoLinea#">,
                                     0,
                                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.TotalLinea#">,
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
                                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
<!---ERBG Pone el Centro Funcional Default INICIA--->
                                     <cfif isdefined("Form.opt_CF")>
	                             		<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">,
	                             	 <cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">,
	                             	 </cfif>
<!---ERBG Pone el Centro Funcional Default FIN--->
                                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                                     0
                                    )
                                    <cf_dbidentity1 datasource="#session.DSN#">
                            </cfquery>
                            <cf_dbidentity2 datasource="#session.DSN#" name="varDetalle">
                            
                            <!----ABCO. Inserta en la tabla de Control--->
							<cfquery name="rsInsertControl" datasource="#session.dsn#">
								insert into #PF_EControl# 
								(OImpresionID,
								 OIDetalle,
								 ItemTipo,
								 ItemCodigo,
								 OIDAlmacen,
								 Ccuenta,
								 Ecodigo,
                                 Ocodigo,
								 Icodigo,
                                 CFid
                                 )
								 values
								 (<cfqueryparam cfsqltype="cf_sql_integer" value="#insertEST.identity#">, 
                	              <cfqueryparam cfsqltype="cf_sql_integer" value="#varDetalle.identity#">, 
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.TipoLinea#">,
								  <cfif rsDatos.TipoLinea EQ "A">
	                        	    <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Aid#">,
	                              <cfelse>
    	                         	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Cid#">,
        	                      </cfif>
								  <cfif rsDatos.TipoLinea EQ "A">
	            	              	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Alm_Aid#">,
                    	          <cfelse>
                        	      	null,
                            	  </cfif>
								<!---ERBG Pone el Cuenta Default INICIA--->	
								<cfif isdefined("Form.opt_CC")>
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CcuentaDef#">,
                                <cfelse>                        
									  <cfif len(rsDatos.Ccuenta) GT 0>
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ccuenta#">,
                                      <cfelse>
                                         <cfqueryparam cfsqltype="cf_sql_integer" value="#varCcuenta#">,
                                      </cfif>
                                </cfif> 
                                <!---ERBG Pone el Cuenta Default FIN---> 
								  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                                  <cfqueryparam cfsqltype="cf_sql_integer" value="#varOficina#">,
								  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Icodigo#">,
                                  <!---ERBG Pone el Centro Funcional Default INICIA--->
                                     <cfif isdefined("Form.opt_CF")>
	                             		<cfqueryparam cfsqltype="cf_sql_integer" value="#Var_CFid#">
	                             	 <cfelse>
										<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.CFid#">
	                             	 </cfif>
                                    )
								  <!---ERBG Pone el Centro Funcional Default FIN--->
							</cfquery>
                        </cfif>
                    </cfloop>
	                <!--- Actualiza el Descuento de la Estimacion con el descuento de la Prefctura --->
    	            <cfquery name="rsDescuentoPF" datasource="#session.DSN#">
        	        	select isnull(Descuento,0) as Descuento
            	        from FAPreFacturaE
                	    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                    	and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">
	                </cfquery>
                    <cfquery datasource="#session.DSN#">
						update EDocumentosCxC
                        set EDdescuento = EDdescuento + 
							<cfif isdefined("rsDescuentoPF") and rsDescuentoPF.Descuento NEQ ""> <cfqueryparam cfsqltype="cf_sql_money" value="#rsDescuentoPF.Descuento#">
                            <cfelse> 0
                            </cfif>
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and EDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertEST.identity#">
                    </cfquery>

                    <!--- Actualiza El estatus de las PreFacturas a Terminadas --->
                    <cfquery datasource="#session.DSN#">
						update FAPreFacturaE 
							set	Estatus='E'
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and IDpreFactura = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDetalles.IDpreFactura#">		
							and Estatus in ('P','E')
					</cfquery>
    	        </cfloop>
				<!--- Actualiza los Totales en el encabezado del Documento Estimado --->
                <cfquery name="rsTotalesOI" datasource="#session.DSN#">
					Select 
						sum(cd.DDdesclinea) as sumDescuento,
						sum(cd.DDcantidad * cd.DDpreciou) as sumSubTotal, 
						sum(((cd.DDcantidad * cd.DDpreciou) -  cd.DDdesclinea)
								* 
							(Iporcentaje / 100)) as sumImpuesto
					from DDocumentosCxC cd
						inner join Impuestos i
						on i.Icodigo=cd.Icodigo
						and i.Ecodigo=cd.Ecodigo
					where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and cd.EDid = <cfqueryparam value="#insertEST.identity#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfif isdefined('rsTotalesOI') 
					and rsTotalesOI.recordCount GT 0 
					and rsTotalesOI.sumSubTotal NEQ ''
					and rsTotalesOI.sumImpuesto NEQ ''
					and rsTotalesOI.sumDescuento NEQ ''>
					<cfset TotalCot = 0>
					<cfset TotalCot = (rsTotalesOI.sumSubTotal + rsTotalesOI.sumImpuesto) - rsTotalesOI.sumDescuento>
		            <cfquery name="update" datasource="#session.DSN#">
						update EDocumentosCxC
						set			
						EDimpuesto=isnull(EDimpuesto,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#rsTotalesOI.sumImpuesto#">,  						
                        EDtotal=isnull(EDtotal,0) + <cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - isnull(EDdescuento,0)
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and EDid = <cfqueryparam value="#insertEST.identity#" cfsqltype="cf_sql_numeric">		
					</cfquery> 
                <cfelse>
                   	<cfquery name="update" datasource="#session.DSN#">
						update EDocumentosCxC
						set			
						EDimpuesto=0,  						
                        EDtotal=0
						where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and EDid = <cfqueryparam value="#insertEST.identity#" cfsqltype="cf_sql_numeric">			
					</cfquery> 	
                </cfif>
                <!--- Actualiza la Tabla de Prefacturas especificando el documento generado por la aplicacion--->
               	<cfquery datasource="#session.DSN#">
               		update FAPreFacturaE
                    set DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
   	                CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#">,
       	            TipoDocumentoREF = 0
           	        from FAPreFacturaE a
               	    	inner join #PF_aplicacion# pf 
                   	    on a.IDpreFactura = pf.IDpreFactura
                    where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
           	    		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
               			and 
                   	    (pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                       		or 
                         pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)   
   	            </cfquery>
                 <!--- Guarda Registro en Bitacora de Movimientos PF --->
               <cfquery datasource="#session.DSN#">
                	insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
                    select  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
                    		a.IDpreFactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varDocOI#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.CCTcodigoEst#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            'E',
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from FAPreFacturaE a
                    	inner join #PF_aplicacion# pf 
                        on a.IDpreFactura = pf.IDpreFactura
                    where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                		and 
                        (pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                        	or 
                         pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFtransaccion.PFTcodigoRef#">)   
                </cfquery>
			<cfelse>
            	<!--- Si no Genera Documento Se marca la PreFactura como Terminada --->
                <cfquery datasource="#session.DSN#">
						update FAPreFacturaE 
							set	Estatus='E'
						from FAPreFacturaE a 
                        	inner join #PF_aplicacion# pf 
                            on a.IDpreFactura = pf.IDpreFactura
                        where a.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
							and pf.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			                and pf.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                			and pf.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                			and pf.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                            and a.Estatus in ('P','E')
				</cfquery>
                
                 <!--- Si no Genera Documento Reversa Estimados Previos --->
                <cfquery name="rsDocRev" datasource="#session.dsn#">
                   	insert into #PF_reversa# (DdocumentoREF, CCTcodigoREF, CCTcodigoREV,CFid,CCuenta)
                    select pf.DdocumentoREF, pf.CCTcodigoREF, t.CCTCodigoRef as CCTcodigoREV,#Var_CFid#,#Var_CcuentaDef#
                    from FAPreFacturaE pf
                    	inner join Documentos d
                           	inner join CCTransacciones t
                            on d.Ecodigo = t.Ecodigo
                            and d.CCTcodigo = t.CCTcodigo
                            and t.CCTestimacion = 1
                        on pf.Ecodigo = d.Ecodigo 
                        and pf.DdocumentoREF = d.Ddocumento
                        and pf.CCTcodigoREF = d.CCTcodigo
                        and d.Dsaldo > 0
                        inner join #PF_aplicacion# pfa 
                        on pf.IDpreFactura = pfa.IDpreFactura
                        and pf.TipoDocumentoREF = 0
                    where pf.Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and pfa.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.SNcodigo#">
			            and pfa.Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Mcodigo#">
                		and pfa.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPFllave.Ocodigo#">
                		and pfa.PFTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPFllave.PFTcodigo#">
                </cfquery>
			</cfif>
 	    </cftransaction>
       	<cfif varGeneraDoc>
	        <!--- Postea Documento Estimado CxC --->
            <cfif varPosteo>
             	<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
					method="PosteoDocumento"
					EDid	= "#insertEST.identity#"
					Ecodigo = "#Session.Ecodigo#"
					usuario = "#Session.usuario#"
					debug = "N"
				/>
			</cfif>
            <!--- Reversa Los Estimados Previos --->
            <cfquery name="rsDocRev" datasource="#session.dsn#">
            	select distinct DdocumentoREF, CCTcodigoREF, CCTcodigoREV,COALESCE(CFid,0) as CFid,COALESCE(CCuenta,0) as CCuenta
                from #PF_reversa#
            </cfquery>
			<cfif isdefined("rsDocRev") AND rsDocRev.recordcount GT 0>
           		<cfif rsDocRev.CCTcodigoREF NEQ "" and rsDocRev.DdocumentoREF NEQ "" and rsDocRev.CCTcodigoREV NEQ "">
	                <cfloop query="rsDocRev">
    	         		<cfinvoke 
					component="sif.Componentes.ReversionDocNoFact" 
					method="Reversion" 
					Modulo="CXC"
					debug="false"
					ReversarTotal="true"
					CCTcodigo="#rsDocRev.CCTcodigoREF#"
					CCTCodigoRef="#rsDocRev.CCTcodigoREV#"
					Ddocumento="#rsDocRev.DdocumentoREF#"
                    CFid="#rsDocRev.CFid#"
                    CCuenta="#rsDocRev.CCuenta#"
				/> 
             		</cfloop>
	            </cfif>
            </cfif>
        </cfif>
        </cfloop>
		<cfset cambioTotEnc = false>
	</cfif>
</cfif>

<!--- Actualizacion de los campos de totales en el encabezado --->
<cfif cambioTotEnc>
	<cfquery name="rsTotales" datasource="#session.DSN#">
		Select 
			sum(cd.DescuentoLinea) as sumDescuento,
			sum(Cantidad * PrecioUnitario) as sumSubTotal, 
			sum(((Cantidad * PrecioUnitario) -  cd.DescuentoLinea)
					* 
				(Iporcentaje / 100)) as sumImpuesto
		from FAPreFacturaD cd
			inner join FAPreFacturaE ce
				on ce.IDpreFactura=cd.IDpreFactura
					and ce.Ecodigo=cd.Ecodigo
		
			inner join Impuestos i
				on i.Icodigo=cd.Icodigo
					and i.Ecodigo=ce.Ecodigo
		
		where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and cd.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">		
	</cfquery>

	<cfif isdefined('rsTotales') 
		and rsTotales.recordCount GT 0 
		and rsTotales.sumSubTotal NEQ ''
		and rsTotales.sumImpuesto NEQ ''
		and rsTotales.sumDescuento NEQ ''>
			<cfset TotalCot = 0>
			<cfset TotalCot = (rsTotales.sumSubTotal + rsTotales.sumImpuesto) - rsTotales.sumDescuento>
            <cfquery name="update" datasource="#session.DSN#">
				update FAPreFacturaE 
					set			
						Impuesto=<cfqueryparam cfsqltype="cf_sql_money" value="#rsTotales.sumImpuesto#">,  
						Total=<cfqueryparam cfsqltype="cf_sql_money" value="#TotalCot#"> - coalesce(Descuento,0)
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">		
			</cfquery> 
           	<!---<cf_dbtimestamp datasource="#session.dsn#"
					table="FAPreFacturaE"
					redirect="FAprefactura.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo"
					type1="integer"
					value1="#session.Ecodigo#"
					field2="PFdocumento"
					type2="varchar"
					value2="#form.PFdocumento#">--->
	<cfelse>
		<!---<cf_dbtimestamp datasource="#session.dsn#"
				table="FAPreFacturaE"
				redirect="FAprefactura.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#session.Ecodigo#"
				field2="PFdocumento"
				type2="varchar"
				value2="#form.PFdocumento#">--->
		<cfquery name="update" datasource="#session.DSN#">
			update FAPreFacturaE 
				set			
					Impuesto=0,  
					Total=0
			where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and IDpreFactura = <cfqueryparam value="#form.IDpreFactura#" cfsqltype="cf_sql_numeric">		
		</cfquery> 	
	</cfif>
</cfif>

<form action="FAprefactura.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Alta')>
            <input name="IDpreFactura" id="IDpreFactura" type="hidden" value="#insertEnc.identity#">
		<cfelseif isdefined('form.Nuevo') or isdefined('form.Baja')>
			<input name="btnNuevo" type="hidden" value="btnNuevo">
		<cfelse>
			<cfif IsDefined("form.CambioDet")>
	            <input name="IDpreFactura" id="IDpreFactura" type="hidden" value="#Form.IDpreFactura#">
                <!---<input name="IDpreFactura" id="IDpreFactura" type="hidden" value="#insertEnc.identity#">--->
                <input name="Linea" type="hidden" value="#form.Linea#">
            <cfelseif IsDefined("form.AltaDet") OR isdefined("Form.NuevoDet") OR isdefined("Form.BajaDet") OR isdefined("Form.Cambio") >
	            <input name="IDpreFactura" id="IDpreFactura" type="hidden" value="#Form.IDpreFactura#">
                <!---<input name="Linea" type="hidden" value="#proxLinea.Linea#">--->
			<cfelseif not isdefined('form.btnAplicar')>
	            <!---<input name="IDpreFactura" id="IDpreFactura" type="hidden" value="#insertEnc.identity#">--->
			</cfif>			
			
		</cfif>			
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>