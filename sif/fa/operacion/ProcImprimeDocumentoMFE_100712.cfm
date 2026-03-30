<!--- Modificacion: Se agregan los campos TESRPTCid, TESRPTCietu
	Justificacion: Se modifica componente para tomar en cuenta el Concepto de cobro por cambio de IETU
	Fecha: 07/07/2009 
	Realizo: ABG --->

<!------
	Proceso de Aplicacion de cotizaciones
	Creado 4 septiembre 2008
	por ABG 
------->
<cfset varControlFlujo = true>
<cfset varControlFiltro = true>
<cfset varPosteo = true>
<!---
<cfif isdefined("url.modo") and url.modo EQ "DATA">
    <cf_soinprintdocs_data>
    <cfabort>
</cfif>
--->
<cfif isdefined("form.btnImprimir") and form.btnImprimir EQ "OK">
	<!--- Actualiza la Orden de Impresion a Registro de Resultados --->
    <cfquery datasource="#session.DSN#">
       	update FAEOrdenImpresion
	        set OIEstado = 'R'
        where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
    	    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    
    
<cfelseif isdefined("form.btnImprimir") and (form.btnImprimir EQ "ERROR" or form.btnImprimir EQ "NOINICIO")>
	<!---Como hubo un Error vuelve la Orden al Estatus en Preparacion --->
    <cfquery datasource="#session.DSN#">
       	update FAEOrdenImpresion
	        set OIEstado = 'P'
        where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
    	    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
</cfif>

<cfif isdefined("form.OImpresionID") and len(trim(form.OImpresionID))>
	<cfif isdefined("form.modo") and form.modo NEQ "GUARDA" and form.modo NEQ "CANCELAOI">
        <cfquery name="rsVerTipoPago" datasource="#session.DSN#">
			select * 
		    from FAEOrdenImpresion a
		    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
		    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif isdefined("form.TipoPago") and rsVerTipoPago.codigo_tipopago NEQ form.TipoPago>        
        	<cfabort showerror="Debe actualizar el Tipo de Pago">
        </cfif>
		<cfif isdefined("form.RegFisc") and rsVerTipoPago.codigo_RegFiscal NEQ form.RegFisc>        
        	<cfabort showerror="Debe actualizar el R&eacute;gimen Fiscal">
        </cfif>
        
	</cfif>
	<cfif isdefined("form.modo") and form.modo EQ "GUARDA">
		<!--- Revisa los valores para los Form que puedan venir en blanco --->
  <cfif form.OIfecha EQ "">
        	<cfabort showerror="La Fecha no puede contener un valor nulo">
	  </cfif>
  <cfif form.TipoPago EQ "">
        	<cfabort showerror="El Tipo de pago no puede contener un valor nulo">
		</cfif>              
  <cfif isdefined("form.TipoCambio") and form.TipoCambio EQ "">
        	<cfabort showerror="Especifique un valor para Tipo de Cambio">
	  </cfif>
        
		<!--- Actualiza la Orden de Impresion con los valores nuevos --->
        <cftransaction>
        <cfquery datasource="#session.DSN#">
        	update FAEOrdenImpresion
            set 
            OIfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.OIfecha,'dd/mm/yyyy')#">,
            OIvencimiento = <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(form.OIvencimiento,'dd/mm/yyyy')#">,
            <cfif form.OIdiasvencimiento EQ "">
            	OIdiasvencimiento =  0,
            <cfelse>
            	OIdiasvencimiento = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OIdiasvencimiento#">,
            </cfif>
            <cfif form.id_direccion EQ "">
        		id_direccionFact = null,
            <cfelse>
            	id_direccionFact = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_direccion#">,
			</cfif>
            <cfif form.id_direccion2 EQ "">
        		id_direccionEnvio = null,
            <cfelse>
            	id_direccionEnvio = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_direccion2#">,
			</cfif>
            <cfif isdefined("form.TipoCambio") and len(trim(form.TipoCambio))> 
            	 <cfqueryparam cfsqltype="cf_sql_float" value="#form.TipoCambio#">,
            </cfif>
            OIObservacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
            TESRPTCid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TESRPTCid#">,
            codigo_tipopago = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.TipoPago#">,
            codigo_RegFiscal = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RegFisc#">
            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        </cftransaction>
	<cfelseif isdefined("form.modo") and form.modo EQ "IMPRIME">
    	<!--- PROCESO DE IMPRESION --->
		<!--- Se actualiza Orden de Impresion --->
        <cfquery datasource="#session.DSN#">
        	update FAEOrdenImpresion
            set OIEstado = 'I'
            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">                                             
        </cfquery>
    <cfelseif isdefined("form.modo") and form.modo EQ "CANCELAOI">
		<!--- Orden De impresion a CAncelar --->
        <cfquery name="rsOIcancel" datasource="#session.DSN#">
			select * 
		    from FAEOrdenImpresion a
		    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
		    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
		<!--- Se actualiza Orden de Impresion al Estado Cancelada --->
    	<cfquery datasource="#session.DSN#">
        	update FAEOrdenImpresion
            set OIEstado = 'C'
            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        </cfquery>
        <!--- Guarda Registro en Bitacora de Movimientos PF --->
		<cfquery datasource="#session.DSN#">
       		insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
		   		FechaAplicacion, TipoMovimiento, BMUsucodigo)
        	select  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
		   		a.IDprefactura,  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.OIdocumento#">,
        	    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.CCTcodigo#">,
		        a.SNcodigo, <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
        	    'D', <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		    from FAPreFacturaE a
        	where a.DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.OIdocumento#">
			and a.CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.CCTcodigo#">
        	and a.TipoDocumentoREF = 1
		    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">   
		</cfquery>
        <!--- Actualiza las Prefacturas MArcandolas como Pendientes y Borrando el DocREF--->
	    <cfquery datasource="#session.DSN#">
    		update FAPreFacturaE
        	set DdocumentoREF = null,
	        CCTcodigoREF = null,
    	    TipoDocumentoREF = null,
        	Estatus = 'P'
	        where DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.OIdocumento#">
		    and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIcancel.CCTcodigo#">
        	and TipoDocumentoREF = 1
	        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	</cfquery>
		<cfset varControlFiltro = false>
        <cfset varControlFlujo = false>
    <cfelseif isdefined("form.modo") and form.modo EQ "REGISTRA">   
    	
    <cfquery name="rsupdfac1" datasource="#session.DSN#">				
				select  enviamail
				FROM FAEOrdenImpresion a   
				inner join faprefacturae f
			    on a.oidocumento = f.ddocumentoref
				WHERE a.OImpresionID =  #OImpresionID#
     </cfquery>     
      		<cfif #rsupdfac1.enviamail# neq 1>	
                	<cfabort showerror="No se ha generado el Archivo XML y/o enviado el mail">            		
            </cfif>
		<cfif  not isdefined("form.ErrorDoc")>
        	<cfoutput>Entro form.ErrorDoc #form.ErrorDoc# </cfoutput>
           	<!--- Se actualiza Orden de Impresion Se regresa al estado en Preparacion--->
	        <cfquery datasource="#session.DSN#">
    	    	update FAEOrdenImpresion
        	    set OIEstado = 'P'
            	where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	</cfquery>
		<cfelse>
			<cfif isdefined("form.DocCxC") and len(trim(form.DocCxC))>                    
            	<cftransaction>
            	<!--- Busca si el Documento No existe en los documentos Aplicados --->
                <cfquery name="rsVerifica" datasource="#session.DSN#">
                	select 1 from HDocumentos
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
                </cfquery>
                <cfquery name="rsVerifica2" datasource="#session.DSN#">
                	select 1 from EDocumentosCxC
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and EDdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
                </cfquery>
              <cfif rsVerifica.recordcount GT 0 OR rsVerifica2.recordcount GT 0>
                	<cfabort showerror="Documento ya existe en los Documentos de CxC">
				</cfif>
                <!--- Inserta del Documento en el auxiliar de CxC --->
                                    
                <cfquery name="rsOIinsert" datasource="#session.DSN#">
					select * 
				    from FAEOrdenImpresion a
				    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
				    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
                <!--- Para Obtener la cuenta del Encabezado --->
                <!--- si la id Direccion es nula toma la cuenta del socio --->
				<cfif rsOIinsert.id_direccionFact EQ "">
                	<cfset varCuenta = rsOIinsert.Ccuenta>
                <cfelse>
                	<!--- Busca la cuenta de la direccion indicada --->
                    <!--- Si la direccion no tiene cuenta Contable usa la cuenta del socio --->
                    <cfquery name="rsCuentaD" datasource="#session.DSN#">
						select SNDCFcuentaCliente 
                        from SNDirecciones sd
                        	inner join SNegocios sn
                            on sd.Ecodigo = sn.Ecodigo 
                            and sd.SNid = sn.SNid
                        where sn.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">
                        and sd.id_direccion = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionFact#">
                    </cfquery>
                 <cfif rsCuentaD.SNDCFcuentaCliente EQ "">
                    	<cfset varCuenta = rsOIinsert.Ccuenta>
                    <cfelse>
                    	<cfset varCuenta = rsCuentaD.SNDCFcuentaCliente>
                  </cfif>
                </cfif>
				<!--- Encabezado --->
                
                <cfquery name="insertDoc"datasource="#session.DSN#">
                	insert into EDocumentosCxC	
                        (Ocodigo, CCTcodigo, EDdocumento, SNcodigo, Mcodigo,
                    	EDtipocambio, Ccuenta, EDdescuento, EDporcdesc, EDimpuesto, 
                        EDtotal, EDfecha, EDusuario, EDselect, Interfaz, 
                        id_direccionFact, id_direccionEnvio, DEdiasVencimiento, EDvencimiento, 
                    	DEobservacion, DEdiasMoratorio, Ecodigo, BMUsucodigo, TESRPTCid, TESRPTCietu)
					values
                		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Ocodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
            	         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.Mcodigo#">,
	                     <cfqueryparam cfsqltype="cf_sql_float" value="#rsOIinsert.OItipoCambio#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#varCuenta#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OIdescuento#">,
                         0,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OIimpuesto#">,
                         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIinsert.OItotal#">,
                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.OIfecha#">,
    	                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usuario#">,
                         0,
                         0,
                         <cfif rsOIinsert.id_direccionFact EQ "">
							 null,
                         <cfelse>
                             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionFact#">,
                         </cfif>
                         <cfif rsOIinsert.id_direccionEnvio EQ "">
                         	null,
                         <cfelse>   
        	             	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.id_direccionEnvio#">,
                         </cfif>
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.OIdiasvencimiento#">, 
                         <cfqueryparam cfsqltype="cf_sql_date" value="#rsOIinsert.OIvencimiento#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIobservacion#">,
                         0,
                         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
        	             <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCid#">,
                         <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.TESRPTCietu#">
                     	)
            			<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="insertDoc" returnvariable="llavecxc">
                <cfquery name="rsOIDinsert" datasource="#session.DSN#">
					select * 
				    from FADOrdenImpresion a
				    where a.OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
				    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
                                
				<!--- Detalles --->

                <cfloop query="rsOIDinsert">
	                <cfquery datasource="#session.DSN#">
    	            	insert DDocumentosCxC
        	            	(EDid, Aid, Cid, Alm_Aid, 
            	             Ccuenta, Ecodigo, DDdescripcion, DDdescalterna,
                	         DDcantidad, DDpreciou, DDdesclinea, 
                    	     DDporcdesclin, DDtotallinea, DDtipo, Icodigo, CFid,
                        	 BMUsucodigo,Dcodigo)
	                    values
    	                	(<cfqueryparam cfsqltype="cf_sql_integer" value="#insertDoc.identity#">, 
        	                 <cfif rsOIDinsert.ItemTipo EQ "A">
	        	            	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.ItemCodigo#">,
                	       	 <cfelse>
                    	       	null,
                        	 </cfif>
	                         <cfif rsOIDinsert.ItemTipo EQ "S">
		                        <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.ItemCodigo#">,
        	                 <cfelse>
            	             	null,
                	         </cfif>
                    	     <cfif rsOIDinsert.ItemTipo EQ "A">
	                    	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.OIDAlmacen#">,
	                         <cfelse>
    	                     	null,
        	                 </cfif>
            	             <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.Ccuenta#">,
                	         <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
                    	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.OIDdescripcion#">,
                        	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.OIDdescnalterna#">,
	                         <cfqueryparam cfsqltype="cf_sql_float" value="#rsOIDinsert.OIDCantidad#">,
   	    	                 <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDPrecioUni#">,
    	                     <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDdescuento#">,
            	             0,
                	         <cfqueryparam cfsqltype="cf_sql_money" value="#rsOIDinsert.OIDtotal#">,
                    	     <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.ItemTipo#">,
                        	 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIDinsert.Icodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIDinsert.CFid#">,
    	                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
        	                 0
            	            )
                	</cfquery>
                </cfloop>
                </cftransaction>
                <cfoutput>
          <cf_dump var = "#llavecxc#"> </cfoutput>
                <!--- Postea Documento CxC          
                <cfif varPosteo> --->
                <cfoutput>
          <cfdump var = "valor #llavecxc#"> </cfoutput>
          
    	         	<cfinvoke component="sif.Componentes.CC_PosteoDocumentosCxC"
						method="PosteoDocumento"
						EDid	= "#llavecxc#"
						Ecodigo = "#Session.Ecodigo#"
						usuario = "#Session.usuario#"
						debug = "S"
						USA_tran = "true"
					/>
			<!---  </cfif> --->
                <!--- Inserta un registro en la Bitacora para la PF--->
                <cfquery datasource="#session.DSN#">
	                insert FABitacoraMovPF (Ecodigo, IDpreFactura, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
    	            select <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,    
                    		IDprefactura,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            'A',
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    from FAPreFacturaE
                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIdocumento#">
			        and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">
				</cfquery>
                <!--- Inserta un registro en la Bitacora para la OI--->
                <cfquery datasource="#session.DSN#">
	                insert FABitacoraMovPF (Ecodigo, OImpresionID, DdocumentoREF, CCTcodigoREF, SNcodigoREF, 
                    		FechaAplicacion, TipoMovimiento, BMUsucodigo)
    	            values (<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,    
                    		<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OImpresionID#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#rsOIinsert.SNcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
                            'A',
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				</cfquery>
                <!--- Marca las PreFacturas con el Documento Generado --->
                <cfquery datasource="#session.DSN#">
	                update FAPreFacturaE
    	                set DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DocCxC#">,
        	            CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">,
            	        TipoDocumentoREF = 2
                    from FAPreFacturaE
                    where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and DdocumentoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.OIdocumento#">
			        and CCTcodigoREF = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsOIinsert.CCTcodigo#">
				</cfquery>
                
				<!--- Marca la Orden de Impresion como Terminada --->
		        <cfquery datasource="#session.DSN#">
    		    	update FAEOrdenImpresion
        		    set OIEstado = 'T'
            		where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	        	</cfquery>
                <cfset From.SNcodigo = "">
                <cfset Form.OIdocumento = "">
                <cfset form.PFDocumento = "">
                <cfset varControlFiltro = false>
				<cfset varControlFlujo = false>
         	</cfif>
	   	</cfif>
	<cfelseif isdefined("form.modo") and form.modo EQ "COPIA">
    	<!--- Se actualiza Orden de Impresion Se regresa al estado en Impresion--->
	    <cfquery datasource="#session.DSN#">
    		update FAEOrdenImpresion
        	set OIEstado = 'I'
            where OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
         </cfquery>
	</cfif>    
<!--- Impresion para la factura electronica   --->
	<cfif isdefined("form.modo") and form.modo EQ "impFACele">
      <cfswitch expression="#session.CEcodigo#">
      	<cfcase value="2"> <cfinclude template="ImpresionMFE.cfm"> 		</cfcase>
      	<cfcase value="3"> <cfinclude template="ImpresionMFECCO.cfm"> 	</cfcase>
      </cfswitch>
    <!--- <cfabort>   --->
    </cfif>
<!--- Codifo de prueba para la factura electronica   --->

	<cfif isdefined("form.modo") and form.modo EQ "FACele">    
     <cfquery name="rsfacele" datasource="#session.DSN#">
                    select foliofacele
					 from FAEOrdenImpresion a , FAPreFacturaE b
					where b.DdocumentoREF = a.OIdocumento
	            	  and OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
		              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			          and b.CCTcodigoREF = a.CCTcodigo
	        	      and b.TipoDocumentoREF = 1
    	        	  and b.Ecodigo = a.Ecodigo   
				</cfquery>
    <cfif rsfacele.foliofacele eq '0'>       
    	<cfif isdefined("form.factura") and len(trim(form.factura))>
               <cfset campofactura = 1>
        <cfelse>              
               <cfset campofactura = 0>
      </cfif>

    	   <cfquery datasource="#session.DSN#">
        	   update FAPreFacturaE
			      set factura = <cfqueryparam cfsqltype="cf_sql_integer" value="#campofactura#">
    	         from FAEOrdenImpresion a , FAPreFacturaE b
				where b.DdocumentoREF = a.OIdocumento
            	  and OImpresionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.OImpresionID#">
	              and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		          and b.CCTcodigoREF = a.CCTcodigo
        	      and b.TipoDocumentoREF = 1
            	  and b.Ecodigo = a.Ecodigo   
    	  	</cfquery>        

    	   <cfquery datasource="#session.DSN#">
        	   update faeordenimpresion
			      set oifecha = ltrim(rtrim(convert(char,oifecha,112)))+' '+convert(char,getdate(),108)
    	              	where oimpresionid = #form.OImpresionID#            	  
    	  	</cfquery>        


    	<cfif not isdefined("form.foliofacele")>
           	<cfif campofactura EQ 1>        
                    <cfif rsfacele.foliofacele eq '0'>


<!---				       <cfinvoke
		               webservice="http://127.0.0.1:8500/cfmx/ws1/book.cfc?wsdl"
                       method="listBooks"
		               returnvariable="rawXMLBookList">
		               <cfinvokeargument name="id" value=#form.OImpresionID#/>
		               </cfinvoke>                                           
                       <cfdump var="ENtro WS">--->
                       <cfinvoke
  			           webservice="http://serverws/mfe/WS_MFE.asmx?wsdl"
<!---                       webservice="http://192.168.2.205/FAC/WS_MFE.asmx?wsdl"  --->
                       method="emitirfactura"
		               returnvariable="rawXMLBookList">
					  <cfinvokeargument name="numdoc" value= #form.OImpresionID#/>
		               </cfinvoke> 
                       
                       <cfswitch expression="#session.CEcodigo#">
                            <cfcase value="2"> <cfinclude template="ImpresionMFE.cfm"> 		</cfcase>
                            <cfcase value="3"> <cfinclude template="ImpresionMFECCO.cfm"> 	</cfcase>
                       </cfswitch>
                       
                       <cfinclude template="Fac_registradocumento.cfm"> 
                             
                    </cfif>   
                                  
            </cfif> 
      </cfif>   
      </cfif>   
	</cfif>    
    
<!--- Fin del Codifo de prueba para la factura electronica --->

    <cfif varControlFlujo>
      <cfinclude template="formImprimeDocumentoMFE.cfm">
      <cfelse>
    	<cfinclude template="ListaImprimeDocumentoMFE.cfm">	
  </cfif>
    <!---<cfset varSNcodigo = form.CDCcodigo>--->
<cfelse>
	<cfinclude template="ListaImprimeDocumentoMFE.cfm"> 
</cfif>


