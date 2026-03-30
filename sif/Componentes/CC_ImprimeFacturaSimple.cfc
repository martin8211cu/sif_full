<cfcomponent>
	<cffunction name="ImprimeFacturaCxC" access="public" returntype="string">
		<cfargument name="Ecodigo"    type="numeric" required="yes">
		<cfargument name="CCTcodigo"  type="string"  required="yes">
		<cfargument name="Ddocumento" type="string"  required="yes">
		<cfargument name="datasource" type="string"  required="yes">
		<cfargument name="ImpAsiento" type="boolean" required="no" default="false">

		<cfinclude template="../Utiles/sifConcat.cfm">
		<cfquery name="rsEncabezado" datasource="#Arguments.datasource#">
				select 
					(( select min(hist.HDid) 
						from HDocumentos hist 
						where hist.Ecodigo = enc.Ecodigo 
						  and hist.CCTcodigo = enc.CCTcodigo 
						  and hist.Ddocumento = enc.Ddocumento )) as NoTransaccion,
					enc.Ddocumento as Documento,
					enc.CCTcodigo as Transaccion,
					rtrim(t.CCTcodigo) #_Cat# ' ' #_Cat# enc.Ddocumento as NoDocumento,
					enc.Dfecha as Fecha,
					sn.SNnombre as NombreSocio,
					ltrim(rtrim(dir.atencion #_Cat# ' ' #_Cat# dir.direccion1)) as Direccion,
					sn.SNidentificacion as Identificacion,
					enc.DEordenCompra as OrdenCompra,
					enc.DEnumReclamo  as Referencia,
					coalesce((
						select sum(DDtotal)
						from DDocumentos d
						where d.Ecodigo = enc.Ecodigo
						   and  d.CCTcodigo = enc.CCTcodigo
						   and d.Ddocumento = enc.Ddocumento
						), 0.00) as SubTotal,
					
					enc.Dtotal -
					coalesce((
						select sum(DDtotal)
						from DDocumentos d
						where d.Ecodigo = enc.Ecodigo
						   and  d.CCTcodigo = enc.CCTcodigo
						   and d.Ddocumento = enc.Ddocumento
						), 0.00) as Impuesto,
					enc.Dtotal as Total,
					m.Msimbolo as Simbolo,
					m.Miso4217 as CodigoMoneda,
					m.Mnombre as Moneda,
					(select min(e.Edescripcion)
					from Empresas e
					where e.Ecodigo = enc.Ecodigo) as Empresa,
					(select min(e.EDireccion1)
					from Empresas e
					where e.Ecodigo = enc.Ecodigo) as EDireccion1,
					(select min(e.EIdentificacion)
					from Empresas e
						where e.Ecodigo = enc.Ecodigo
					) as EIdentificacion,
					enc.DEobservacion as Observaciones
				
				from Documentos enc
				
					inner join CCTransacciones t
					on t.CCTcodigo = enc.CCTcodigo
					and t.Ecodigo = enc.Ecodigo
				
					inner join SNegocios sn
					on sn.SNcodigo = enc.SNcodigo
					and sn.Ecodigo = enc.Ecodigo
				
					inner join Monedas m
					on m.Mcodigo = enc.Mcodigo
				
					inner join DireccionesSIF dir
					on dir.id_direccion = enc.id_direccionFact
				
				where enc.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and enc.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and enc.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
		</cfquery>

		<cfset LvarSimboloMoneda = rsEncabezado.Simbolo>
		<cfset LvarNombreMoneda  = rsEncabezado.Moneda>

		<cfif not isdefined("rsEncabezado") or rsEncabezado.Recordcount LT 1>
			<cfsavecontent variable="LvarFactura">
				<p>&nbsp;</p>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
				<p>&nbsp;</p>
				<p align="center">**** No se Encontro el Documento Requerido *** <cfoutput>#Arguments.CCTcodigo# #Arguments.Ddocumento#</cfoutput></p>
			</cfsavecontent>
			<cfreturn LvarFactura>
		</cfif>

		<cfquery name="rsDetalle" datasource="#Arguments.datasource#">
				select 
					DDcantidad as Cantidad,
					rtrim(ltrim(d.DDescripcion #_Cat# ' ' #_Cat# d.DDdescalterna)) as Descripcion,
					d.DDtotal as Monto
				from DDocumentos d
				where d.Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and d.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
		</cfquery>
		
		<cfif Arguments.ImpAsiento>
		   <cfquery name="rsIDcontable" datasource="#Arguments.datasource#">
				select IDcontable
				from BMovimientos
				where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				  and CCTcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and Ddocumento  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
				  and CCTRcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
				  and DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ddocumento#">
				  and Ddocumento  = DRdocumento
				  and CCTcodigo   = CCTRcodigo
		   </cfquery>
		   
			<cfif rsIDcontable.recordcount EQ 1 and rsIDcontable.IDcontable GT 0>
				<!--- Se encontr el registro.  Buscar el dato del asiento --->
				<!--- Primero se busca en Asientos sin Postear ( ms posibilidad de encontrarlo porque se acaba de generar ) --->
				<cfquery name="rsAsiento" datasource="#arguments.datasource#">
					 select 
					  a.Cconcepto    as Concepto, 
					  a.Edocumento   as Documento,
					  a.Eperiodo     as Periodo,
					  a.Emes         as Mes,
					  a.Edescripcion as Descripcion,
					  c.Cdescripcion as DescripcionLote
					 from EContables a
					  inner join ConceptoContableE c
					  on c.Ecodigo     = a.Ecodigo
					  and c.Cconcepto  = a.Cconcepto
					 where IDcontable = #rsIDcontable.IDcontable#
				</cfquery>
			 
				<cfif rsAsiento.recordcount LT 1>
					 <!--- Si no existe en Asientos sin Postear, se busca en Asientos Posteados --->
					 <cfquery name="rsAsiento" datasource="#arguments.datasource#">
						  select 
						   a.Cconcepto    as Concepto, 
						   a.Edocumento   as Documento,
						   a.Eperiodo     as Periodo,
						   a.Emes         as Mes,
						   a.Edescripcion as Descripcion,
						   c.Cdescripcion as DescripcionLote
						  from HEContables a
						   inner join ConceptoContableE c
						   on c.Ecodigo     = a.Ecodigo
						   and c.Cconcepto  = a.Cconcepto
						  where IDcontable = #rsIDcontable.IDcontable#
					 </cfquery>
				</cfif>
			   </cfif>
		</cfif>
		
		<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
		<cfset LvarMontoEnLetras = LvarObj.fnMontoEnLetras(rsEncabezado.Total)>
		
		<cfsavecontent variable="LvarFactura">
			<cfoutput>
				<cfinclude template="/sif/cc/reportes/CC_ImprimeFacturaSimpleFormato.cfm">
			</cfoutput>
		</cfsavecontent>
		<cfreturn LvarFactura>
	</cffunction>
</cfcomponent>
