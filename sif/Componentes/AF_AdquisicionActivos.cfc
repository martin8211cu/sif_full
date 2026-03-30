<!--- Componente: AF_AdquisicionActivos  --->
<!--- Creado por: Dorian Abarca Gómez --->
<!--- Fecha de Creación: 24/04/2006 --->
<!--- Este componente se trae de CXP todas las líneas de facturas correspondientes a Activos Fijos y crea una adquisición,
para cada línea, para cada adquisición busca documentos de responsabilidad, si los encuentra, los crea como las líneas de
la adquisición, sino, crea n líneas iguales correspondientes a la cantidad indicada en la factura. --->
<!--- Modificado por: Ing. Oscar Bonilla, MBA --->
<!--- Fecha de Creación: 11/03/2009 --->
<!---
	Si se llama desde la lista de Vales, crea todas las adquisiciones de documentos CxP pendientes.
	Si se llama desde el posteo de CxP, solo crea las adquisiciones del documento a postear.
	Cambia la lógica para que se obtengan los vales y se generen las adquisiciones con el siguiente criterio:
		Por cada línea de la factura tipo 'F=Activo Fijo' se obtienen tantos vales como cantidad de la línea:
			Primero se obtienen los vales registrados al documento con el monto = totalLinea * tc / cantidad
			Si hacen falta se obtienen los vales registrados a la misma DOlinea con el monto = totalLinea * tc / cantidad
			Si hacen falta envía error
		Se genera masivamente para todas las líneas procesadas un EAadquisicion, y tantos DAadquisicion y DSActivosAdq como vales obtenidos = sum(DDcantidad):
			Los montos ya no son totalLineaUnitarioLocal sino que costoLineaUnitarioLocal (incluye impuestoCostoLin y descuentoDocProrrateadoXlin)
 --->
<cfcomponent>
	<cffunction name="AF_CreaTablas" access="public">
		<cf_dbtemp name="CRD_V1" returnvariable="CRDvales" datasource="#session.dsn#">
			<cf_dbtempcol name="Ecodigo"		 type="int"			mandatory="no">
			<cf_dbtempcol name="CRDRid"    		 type="numeric"		mandatory="yes">
			<cf_dbtempcol name="DAlinea"   		 type="int"			mandatory="yes">
			<cf_dbtempcol name="DDlinea"   		 type="varchar(100)"	mandatory="yes">
			<cf_dbtempcol name="DOlinea"    	 type="numeric"		mandatory="no">
            <cf_dbtempcol name="IDdocumento"   	 type="numeric"		mandatory="no">
            <cf_dbtempcol name="Monto"   	     type="money" 		mandatory="no">
            <cf_dbtempcol name="MontoOri"           type="money"       mandatory="no">
            <cf_dbtempcol name="CRDRdescripcion" type="varchar(80)"	mandatory="no">
		</cf_dbtemp>
		<cfset request.CRDvales = CRDvales>
        <!---Se crea la siguiente tabla temporal, para alojar los errores que que se presentan en la ejecuacion
        de la Adquisicion de Activos. Esto para darle continuidad a otros Activos que si estan disponibles
        para ser Adquiridos--->
        <cf_dbtemp name="CRD_V2" returnvariable="CRDerrores" datasource="#session.dsn#">
			<cf_dbtempcol name="Documento" 		 type="varchar(60)"	 mandatory="yes">
            <cf_dbtempcol name="TipoError" 		 type="varchar(1)"	 mandatory="yes">
            <cf_dbtempcol name="Linea"		     type="numeric"		 mandatory="no">
			<cf_dbtempcol name="Cantidad"  		 type="int"	    	 mandatory="no">
			<cf_dbtempcol name="TotalLin"  		 type="money"		 mandatory="no">
			<cf_dbtempcol name="MontoUnit"    	 type="money"		 mandatory="no">
            <cf_dbtempcol name="Moneda"     	 type="char(3)"		 mandatory="no">
            <cf_dbtempcol name="Monto"   	     type="money" 		 mandatory="no">
            <cf_dbtempcol name="MontoVales"	     type="money" 		 mandatory="no">
            <cf_dbtempcol name="OC"              type="varchar(120)" mandatory="no">
            <cf_dbtempcol name="MonedaLoc"     	 type="char(3)"		 mandatory="no">
		</cf_dbtemp>
		<cfset request.CRDerrores = CRDerrores>
	</cffunction>

	<cffunction name="AF_AdquisicionActivos" access="public" returntype="numeric">
		<cfargument name="Ecodigo" 		default="#Session.Ecodigo#" required="no" type="numeric">
		<cfargument name="Usucodigo" 	default="#Session.Usucodigo#" required="no" type="numeric">
		<cfargument name="IDdocumento"	default="-1" required="no" type="numeric">
        <cfargument name="Modulo"       default="CxP" required="no" type="string">
		<cfargument name="Debug" 		default="false" required="no" type="boolean">

		<cfset LvarDocumentos_list = ''>
		<cfset rsFacturas = AF_ObtieneLineasFacturas(Arguments.Ecodigo, Arguments.IDdocumento)>
		<cfif not isdefined("request.CRDvales")>
			<cfset AF_CreaTablas()>
		</cfif>
        <cfset AF_ObtieneVales(Arguments.Modulo)>

		<!--- se recorren cada una de las líneas de facturas consultadas para crear la adquisición y las líneas de detalle de la adquisicion --->
		<cfif Arguments.IDdocumento EQ -1>
			<cftransaction>
				<cfset AF_GeneraAdquisiciones(Usucodigo)>
			</cftransaction>
		<cfelse>
			<cfset AF_GeneraAdquisiciones(Usucodigo)>
		</cfif>

		<cfif Arguments.Debug>
			<cfdump var="#rsFacturas#" label="rsFacturas">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from EAadquisicion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
				and EAcpidtrans + EAcpdoc in (#preservesinglequotes(LvarDocumentos_list)#)
			</cfquery>
			<cfdump var="#rsSQL#" label="EAadquisicion">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from DAadquisicion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
				and EAcpidtrans + EAcpdoc in (#preservesinglequotes(LvarDocumentos_list)#)
			</cfquery>
			<cfdump var="#rsSQL#" label="DAadquisicion">
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select * from DSActivosAdq
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.ecodigo#">
				and EAcpidtrans + EAcpdoc in (#preservesinglequotes(LvarDocumentos_list)#)
			</cfquery>
			<cfdump var="#rsSQL#" label="DSActivosAdq">
		</cfif>
		<cfreturn rsFacturas.recordcount>
	</cffunction>

	<cffunction name="AF_ObtieneLineasFacturas" access="public" returntype="query">
		<cfargument name="Ecodigo"		default="#Session.Ecodigo#" required="no" type="numeric">
		<cfargument name="IDdocumento"	default="-1" required="no" type="numeric">

		<cfquery name="rsSQL" datasource="#session.dsn#">
			 select count(1) cantidad
			from DDocumentosCP b
				inner join EDocumentosCP a
				 on a.IDdocumento = b.IDdocumento
             <!---►►Que no provenga del registro de transaccion de importacion◄◄--->
             where (select count(1)
                    from EDocumentosI edi
                     where edi.SNcodigo   = a.SNcodigo
                       and edi.Ddocumento = a.Ddocumento
                       and edi.CPTcodigo  = a.CPTcodigo
                       and edi.Ecodigo    = (select min(doc.Ecodigo)
                                     		  from DOrdenCM doc
                                        		inner join DDocumentosI ddi
                                            		on ddi.EDIid = edi.EDIid) ) = 0
             <!---►Si son lineas de Activos Fijos y tienen Grupos de impuestos,
			       se detienen, ya que no esta Implementado, obtener el costo del Activo◄◄--->
             and (select Icompuesto
                            	from Impuestos
                        	  where Ecodigo        = b.Ecodigo
                                and Icodigo        = b.Icodigo) = 1
			<cfif Arguments.IDdocumento EQ -1>
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and b.DDtipo = 'F'
				  and not exists (
						select 1
						  from EAadquisicion
						 where EAcplinea	= b.DDlinea
						   and EAcpdoc		= b.Ddocumento
						   and EAcpidtrans	= b.CPTcodigo
						   and Ecodigo		= b.Ecodigo
						   and SNcodigo		= b.SNcodigo
					)
			<cfelse>
				  and b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and b.IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdocumento#">
				  and b.DDtipo		= 'F'
			</cfif>
		</cfquery>
        <cfif rsSQL.cantidad GT 0>
        	<cfthrow message="Lineas de Activos Fijos con grupos de impuestos. No implementado">
        </cfif>

		<!--- Consulta que obtiene todos los detalles de las facturas de cxp que corresponden a activos fijos que no han sido adquiridos --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select
				distinct a.IDdocumento,
                a.Ddocumento,
                a.Ecodigo,
				a.Mcodigo,
                a.EDtcultrev
			from HEDocumentosCP a
				inner join HDDocumentosCP b
				 on a.IDdocumento = b.IDdocumento
             <!---►►Que no provenga del registro de transaccion de importacion◄◄--->
             where (select count(1)
                    from EDocumentosI edi
                     where edi.SNcodigo   = a.SNcodigo
                       and edi.Ddocumento = a.Ddocumento
                       and edi.CPTcodigo  = a.CPTcodigo
                       and edi.Ecodigo    = (select min(doc.Ecodigo)
                                     		  from DOrdenCM doc
                                        		inner join DDocumentosI ddi
                                            		on ddi.EDIid = edi.EDIid) ) = 0
			<cfif Arguments.IDdocumento EQ -1>
				  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and b.DDtipo = 'F'
				  and not exists (
						select 1
						  from EAadquisicion
						 where
                           <!--- EAcplinea	= b.DDlinea  Se elimina este filtro --->
                           EAcpdoc		= b.Ddocumento
						   and EAcpidtrans	= b.CPTcodigo
						   and Ecodigo		= b.Ecodigo
						   and SNcodigo		= b.SNcodigo
					)
				order by a.IDdocumento
			<cfelse>
				  and b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				  and b.IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.IDdocumento#">
				  and b.DDtipo		= 'F'
				order by IDdocumento
			</cfif>
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>

	<!---JMRV. Funciones para aplicar al generar la placa consecutiva. 11/04/2014--->
        <!---Funcion para encontrar el consecutivo de la placa--->
        <cffunction name="ObtenerrsConsecutivo" returntype="query">
        	<cfargument name="Ecodigo" type="numeric" required="true">	
        	<cfargument name="ACcodigo"	type="numeric" 	required="true">
        	<cfargument name="ACid"	type="numeric" 	required="true">
			<cfquery name="rsConsecutivo" datasource="#session.DSN#">
        			select coalesce(MAX(AFCconsecutivo),0) + 1 as maxNum
					from AFConsecutivo
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                   <cfif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 1>
                       and AFCcategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#"> <!---filtro para el consecutivo por Categoria--->
                   <cfelseif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 2>
                       and AFCclasificacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#"> <!---filtro para consecutivo por Clasificacion--->
                   </cfif>
        	</cfquery>
			<cfreturn rsConsecutivo>
		</cffunction>
		<!---Funcion para actualizar el valor del consecutivo en la tabla CRDocumentoResponsabilidad--->
		<cffunction name="ActualizarCRDocumentoResponsabilidad" returntype="boolean">
			<cfargument name="maxNum" type="numeric" required="true">	
			<cfargument name="MinimoVale" type="numeric" required="true">
			<cfquery name="rsUpdatePlaca" datasource="#session.DSN#">
        			update CRDocumentoResponsabilidad
					set CRDRconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.maxNum#">
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.MinimoVale#">
        	</cfquery>
        	<cfreturn "true">
        </cffunction>
        <!---Funcion para actualizar el valor del consecutivo en la tabla AFConsecutivo--->
        <cffunction name="ActualizarAFConsecutivo" returntype="boolean">
        	<cfargument name="ACcodigo" type="numeric" required="true">
        	<cfargument name="ACid" type="numeric" required="true">
        	<cfargument name="maxNum" type="numeric" required="true">
        	<cfargument name="Ecodigo" type="numeric" required="true">
        	<cfif isdefined("rsConsecutivo") and rsConsecutivo.maxNum EQ 1>
        		<cfquery datasource="#session.DSN#">
            		insert into AFConsecutivo (AFCcategoria,AFCclasificacion,AFCconsecutivo,Ecodigo,BMUsucodigo)
                	values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#">,
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.maxNum#">,
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
                    		<cfqueryparam cfsqltype="cf_sql_numeric" value="6">)
            		</cfquery>
        		<cfelse>
            		<cfquery name="rsUpdatePlaca" datasource="#session.DSN#">
            			update AFConsecutivo
                      		set AFCconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.maxNum#">
                			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                			<cfif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 1>
                      		and AFCcategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACcodigo#"> <!---filtro para el consecutivo por Categoria--->
                    		<cfelseif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 2>
                      		and AFCclasificacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACid#"> <!---filtro para consecutivo por Clasificacion--->
                    		</cfif>
            		</cfquery>
        		</cfif>
        		<cfreturn "true">
        </cffunction>
        <!---Funcion para encontrar el numero de vales que hacen referencia a la factura cuando la Mascara se genera automaticamente--->
        <cffunction name="ObtenerNumValesMascAut" returntype="query">
				<cfquery name="NVales" datasource="#session.DSN#">
            		select a.CRDRid as CRDRid
					from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CRDRplaca is null
            	</cfquery>	
				<cfreturn NVales>
		</cffunction>
		<!---Funcion para encontrar el numero de vales que hacen referencia a la factura cuando la Mascara no se genera automaticamente--->
		<cffunction name="ObtenerNumVales" returntype="query">
				<cfquery name="NVales" datasource="#session.DSN#">
            			select a.CRDRid as CRDRid
						from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
						where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
						and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						and CRDRconsecutivo is null
            	</cfquery>	
				<cfreturn NVales>
		</cffunction>
	<!---JMRV. Fin del cambio. 11/04/2014--->


	<cffunction name="AF_ObtieneVales" access="public">
        <cfargument name="Modulo"      default="CxP" required="no" type="string">

	<!--- El monto del Vale debería ser en Moneda de la Factura (TotalLinea/Cantidad) --->
	<!--- Para asegurar la unicidad del número de documento, debería incluirse SNid y CPTcodigo --->

    <!---SML. 27/02/2014. Parametro para la generación de mascara automatica--->
	<cfquery name="rsMascaraAut" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  	and Pcodigo = '200050'
	</cfquery>

    <!---SML. 27/02/2014. Parametro para saber si el consecutivo se generará por por categoria o por clasificacion--->
	<cfquery name="rsGenAutPor" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = '200060'
	</cfquery>

	<!---JMRV. 11/04/2014. Genera mensaje para configurar el consecutivo de la placa, ya sea por consecutivo o categoria.--->   
    <cfif isdefined("rsGenAutPor") and ((rsGenAutPor.Pvalor NEQ 1) and (rsGenAutPor.Pvalor NEQ 2))>
    	<cfthrow message="No se ha definido un valor para el consecutivo de la placa. Elijalo en Administracion del sistema/Parametros adicionales en el apartado de Activos">
    </cfif>

    <cfloop query="rsFacturas">
    	<cfset LvarinsertVale  = true>
        <cfset LvarNumFac      = rsFacturas.recordcount>
        <cfset LvarTipoC       = rsFacturas.EDtcultrev>
        <cfif Arguments.Modulo eq 'Adquisicion'>
            <cfset LvarNumFac      = rsFacturas.recordcount + 1>
        </cfif>

    	<!--- Obtiene los vales para Documento --->
        <cfquery name="rsSQL" datasource="#session.dsn#">
            select CRDRid, coalesce(a.DDlineas,a.DOlineas) as lineas, Monto,
            case when coalesce(a.DOlineas,'0') = '0' then 1 else 2 end as Tipo, CRDRdescripcion, CRDRdocori,ACcodigo,ACid
            from CRDocumentoResponsabilidad a
            where Ecodigo			        = <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsFacturas.Ecodigo#">
            and upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Ucase(trim(rsFacturas.Ddocumento))#">
            and CRDRestado = 10
            and not exists(
                select 1
                from DSActivosAdq
                where Ecodigo	= a.Ecodigo
                and CRDRid	= a.CRDRid
            )
            and not exists(
                select 1
                from #request.CRDvales#
                where Ecodigo	= a.Ecodigo
                and CRDRid	= a.CRDRid
            )
        </cfquery>
        <cfset LvarDDocumento  = rsFacturas.DDocumento>
		<cfif rsSQL.recordcount eq 0>
        	<cfif LvarNumFac eq 1>
            	<cfthrow message="No se encontraron Documentos de Responsabilidad de Activos Fijos (Vales) registrados para: Documento '#LvarDDocumento#'">
            <cfelse>
            	<cfquery datasource="#session.dsn#">
                    insert into #request.CRDerrores# (
                    Documento,
                    TipoError
                    )
                    values(
                    '#rsFacturas.DDocumento#',
                    '1'
                    )
                </cfquery>
                <cfset LvarinsertVale = false>
            </cfif>
        </cfif>

        <!---SML. Inicio 28/02/2014 Crear la placa cuando se genera automaticamente--->
        <!---JMRV Cambio 11/04/2014--->
        <!---Si esta activada la generacion automatica de la placa--->
		<cfif isdefined("rsMascaraAut") and rsMascaraAut.Pvalor EQ 1>
            <!---Encuentra la cantidad de vales que hacen referencia a la factura--->
            <cfset NumVales = ObtenerNumValesMascAut()>
            <!---Genera y aplica las placas mientras encuentre vales de responsabilidad que referencien a la factura--->
            <cfloop condition = "NumVales.RecordCount GREATER THAN 0">
            	<!---Se genera una consulta para obtener uno de los vales de responsabilidad a los que se les debe aplicar la placa--->
            	<cfquery name="PlacasParaVales" datasource="#session.DSN#">
            		select min(CRDRid) as MinimoVale
					from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CRDRplaca is null
            	</cfquery>
            	<!---Se obtienen los datos del vale--->
           	 	<cfquery name="DatosVales" datasource="#session.DSN#">
            		select a.ACcodigo as ACcodigo, a.ACid as ACid
					from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CRDRplaca is null
					and CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PlacasParaVales.MinimoVale#">
            	</cfquery>
            	<!---Se obtiene el consecutivo--->
            	<cfset rsConsecutivo = ObtenerrsConsecutivo(#session.Ecodigo#,#DatosVales.ACcodigo#,#DatosVales.ACid#)>
        		<!---Se obtiene la estructura de la placa--->
        		<cfif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 1>
            		<cfquery name="rsGenerarPor" datasource="#session.DSN#">
                		select b.ACmascara as ACmascara, a.ACcodigo as ACcodigo, a.ACid as ACid
						from CRDocumentoResponsabilidad a
							inner join ACategoria b on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
						where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
                    	and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    	and a.ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosVales.ACcodigo#">
                	</cfquery>
                	<cfset varTipoPlaca = "Categoria">
            	<cfelseif isdefined("rsGenAutPor") and rsGenAutPor.Pvalor EQ 2>
            		<cfquery name="rsGenerarPor" datasource="#session.DSN#">
                		select b.ACmascara as ACmascara, a.ACcodigo as ACcodigo, a.ACid as ACid
						from CRDocumentoResponsabilidad a
							inner join AClasificacion b on a.ACid = b.ACid
							and b.Ecodigo = a.Ecodigo
						where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
                    	and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                    	and a.ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DatosVales.ACid#">
                	</cfquery>
                	<cfset varTipoPlaca = "Clasificacion">
            	</cfif>
        		<!---Se obtiene la placa--->
        		<cfif find("*",rsGenerarPor.ACmascara)>
            		<cfset numlen = len(trim(#rsGenerarPor.ACmascara#))>
            		<cfset cantAst = find("*",#rsGenerarPor.ACmascara#)>
                	<cfset numMascara = cantAst - 1>
                	<cfset totalAst = (numlen - cantAst) + 1>
                	<cfset numCons = RepeatString("0",#totalAst#-len(trim(rsConsecutivo.maxNum))) & '#rsConsecutivo.maxNum#'>
                	<cfset textACmascara = Mid(#rsGenerarPor.ACmascara#,1,numMascara)>
					<cfset varACmascara = '#textACmascara#' & '#numCons#'>
            	<cfelse>
            		<cf_throw message = "La mascara '#trim(rsGenerarPor.ACmascara)#' de la '#varTipoPlaca#' de Activos Fijos no tiene el formato correcto, solo considera el simbolo *">
        		</cfif>
            	<!---Aplica la placa al vale--->
           	 	<cfquery name="rsUpdatePlaca" datasource="#session.DSN#">
            		update CRDocumentoResponsabilidad
						set CRDRplaca = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(varACmascara)#">
						where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
						and CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PlacasParaVales.MinimoVale#">
            	</cfquery>
            	<!---Actualiza el valor del consecutivo en la tabla CRDocumentoResponsabilidad--->
                <cfset Actualizar = ActualizarCRDocumentoResponsabilidad(#rsConsecutivo.maxNum#,#PlacasParaVales.MinimoVale#)>
        		<!---Actualiza el valor del consecutivo en la tabla AFConsecutivo--->
        		<cfset Actualizar = ActualizarAFConsecutivo(#DatosVales.ACcodigo#,#DatosVales.ACid#,#rsConsecutivo.maxNum#,#session.Ecodigo#)>
				<!---Ejecuta la funcion para saber si aun hay vales a los cuales se les debe aplicar la placa--->
            	<cfset NumVales = ObtenerNumValesMascAut()>
			</cfloop>
		<!---Generado automático de la placa deshabilitado--->
		<cfelse>
			<!---Encontrar el numero de vales que hacen referencia a la factura--->
            <cfset NumVales = ObtenerNumVales()>
            <!---Genera el consecutivo de las placas mientras encuentre vales de responsabilidad que referencien a la factura--->
            <cfloop condition = "NumVales.RecordCount GREATER THAN 0">
            	<!---Se genera una consulta para obtener uno de los vales de responsabilidad a los que se les debe aplicar la placa--->
            	<cfquery name="PlacasParaVales" datasource="#session.DSN#">
            		select min(CRDRid) as MinimoVale
					from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CRDRconsecutivo is null
            	</cfquery>
            	<!---Se obtienen los datos del vale--->
           	 	<cfquery name="DatosVales" datasource="#session.DSN#">
            		select a.ACcodigo as ACcodigo, a.ACid as ACid
					from CRDocumentoResponsabilidad a
						 inner join ACategoria b
						 	on a.ACcodigo = b.ACcodigo
							and b.Ecodigo = a.Ecodigo
					where upper(rtrim(CRDRdocori)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ucase(trim(rsFacturas.Ddocumento))#">
					and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PlacasParaVales.MinimoVale#">
            	</cfquery>
            	<!---Se obtiene el consecutivo--->
            	<cfset rsConsecutivo = ObtenerrsConsecutivo(#session.Ecodigo#,#DatosVales.ACcodigo#,#DatosVales.ACid#)>
            	<!---Actualiza el valor del consecutivo en la tabla CRDocumentoResponsabilidad--->
                <cfset Actualizar =  ActualizarCRDocumentoResponsabilidad(#rsConsecutivo.maxNum#,#PlacasParaVales.MinimoVale#)>
        		<!---Actualiza el valor del consecutivo en la tabla AFConsecutivo--->
        		<cfset Actualizar =  ActualizarAFConsecutivo(#DatosVales.ACcodigo#,#DatosVales.ACid#,#rsConsecutivo.maxNum#,#session.Ecodigo#)>
				<!---Genera la consulta para saber si aun hay vales a los cuales se les debe generar el consecutivo de la placa--->
            	<cfset NumVales = ObtenerNumVales()>
			</cfloop>
        </cfif>
        <!---JMRV Fin del cambio 11/04/2014--->
        <!---SML. Final 28/02/2014 Crear la placa cuando se genera automaticamente--->

        <cfset LvarIDdocumento = rsFacturas.IDdocumento>
        <cfset Mcodigo         = rsFacturas.Mcodigo>
        <cfset LvarEcodigo     = rsFacturas.Ecodigo>

        <!---Obtengo el total de los vales para luego compararlo con el total de la factura. Ambos montos deben de ser iguales--->
        <cfset montoVales = 0>
        <cfloop query="rsSQL">
        	<cfset montoVales = montoVales + rsSQL.Monto>
        </cfloop>

        <!---Obtengo el total de la factura--->
        <cfset montoFactura = 0>
        <cfset permit = 0>
        <cfquery name="rsDetalleFact" datasource="#session.dsn#">
            select
            b.IDdocumento,
            b.Ecodigo,
            b.DDlinea,
            coalesce(b.DOlinea,0) as DOlinea,
            b.DDcantidad,
            b.DDtipo,
            <!---►Total linea Moneda Origen◄--->
            round((DDtotallin - DDdescdoc + DDimpuestoCosto + DDcostosProrrateados) * #rsFacturas.EDtcultrev#,2) as DDtotallin,
            <!---►Monto Unitario local◄--->
            CASE WHEN b.DDcantidad = 0 THEN 0 ELSE
            round((DDtotallin - DDdescdoc + DDimpuestoCosto + DDcostosProrrateados) * #rsFacturas.EDtcultrev# / b.DDcantidad,2) END as totalLinUnitLocal
            from HDDocumentosCP b
            where b.Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#rsFacturas.Ecodigo#">
            and b.IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFacturas.IDdocumento#">
            order by b.DDlinea
        </cfquery>
        <cfloop query="rsDetalleFact">
        	<cfif rsDetalleFact.DDtipo eq 'F'>
        		<cfset montoFactura = montoFactura + DDtotallin>
                <cfset permit = permit + 0.005>
            </cfif>
        </cfloop>

		<cfset LvarEncontroLin = "">
        <cfset LvarMontoU        = 0>
        <cfset DDcantidad        = 0>
        <cfset DDocumento        = 0>
        <cfset DDtotallin        = 0>
        <cfset TotalLinUnitLocal = 0>
        <cfset DOlinea           = 0>
        <cfset LvarLineaNE       = "">
        <cfset LvarLineasDetalle = "">
        <cfset LvarLineaE        = "">
        <cfset LvarVale          = "">
        <!---Se realiza el recorrido por cada vale, de ahi se obtiene las lineas asociadas a es vale (Puede ser una: (1) o varias lineas (1,2,3,4))
        Se verifica que las lineas de la factura se encuentren en los vales--->
        <cfloop query="rsSQL">
			<cfset LvarLineasDetalle = "">
            <cfloop list="#rsSQL.lineas#"	index="linea">
                <cfloop query="rsDetalleFact">
					<cfif rsDetalleFact.DDtipo eq 'F'>
                    	<cfset LvarDDlinea = rsDetalleFact.DDlinea>
                        <cfset LvarDOlinea = rsDetalleFact.DOlinea>
                        <cfset LvarCantidad = rsDetalleFact.DDcantidad>
                        <cfset LvarTotalLinULocal = rsDetalleFact.totalLinUnitLocal>
                        <cfset Lvarline = rsDetalleFact.CurrentRow>
                        <cfset var = LvarDOlinea>
                        <cfif rsSQL.Tipo eq 1>
                        	<cfset var = Lvarline>
                        </cfif>
                        <cfif LvarCantidad EQ 0>
                            <cfthrow message="La cantidad de Activo Fijo no puede ser CERO">
                        </cfif>
                        <cfif LvarCantidad NEQ round(LvarCantidad)>
                            <cfthrow message="La cantidad de Activo Fijo no puede tener decimales">
                        </cfif>
                        <cfif var eq linea>
                        	<cfset LvarLineaNE = listAppend(LvarLineaNE, "#var#")>
                            <cfset LvarLineaE = "#LvarDDlinea#">
                            <cfif LvarEncontroLin eq var>
                            	<cfset LvarEncontroLin   = "">
                                <cfset LvarMontoU        = 0>
                                <cfset DDcantidad        = 0>
                                <cfset DDocumento        = 0>
                                <cfset DDtotallin        = 0>
                                <cfset TotalLinUnitLocal = 0>
                                <cfset DOlinea           = 0>
                            </cfif>
                        <cfelseif var neq linea and not listContains(LvarLineaNE, "#var#")>
                        	<cfset LvarEncontroLin   = var>
                            <cfset LvarMontoU        = rsDetalleFact.totalLinUnitLocal>
                            <cfset DDcantidad        = rsDetalleFact.DDcantidad>
                            <cfset DDocumento        = LvarDDocumento>
                            <cfset DDtotallin        = rsDetalleFact.DDtotallin>
                            <cfset TotalLinUnitLocal = LvarTotalLinULocal>
                            <cfset DOlinea           = LvarDOlinea>
                        </cfif>
                	</cfif>
                </cfloop>
                <cfset LvarLineasDetalle = listAppend(LvarLineasDetalle, "#LvarLineaE#",',')>
            </cfloop>
            <cfif len(trim(rsSQL.lineas))>
            	<cfset LvarVale = listAppend(LvarVale, "#rsSQL.CRDRid#|#LvarLineasDetalle#|#rsSQL.Monto#|#rsSQL.CRDRdescripcion#",'&')>
            </cfif>
        </cfloop>
        <cfif rsSQL.recordcount gt 0 and not len(trim(LvarVale)) and LvarinsertVale>
        	<cfif LvarNumFac eq 1>
                <cfthrow message="Los Documentos de Responsabilidad de Activos Fijos (Vales) registrados para el Documento '#LvarDDocumento#' no contienen lineas de detalle">
            <cfelse>
            	<cfquery datasource="#session.dsn#">
                    insert into #request.CRDerrores# (
                    Documento,
                    TipoError
                    )
                    values(
                    '#rsFacturas.DDocumento#',
                    '5'
                    )
                </cfquery>
                <cfset LvarinsertVale = false>
            </cfif>
        </cfif>
        <!--- Moneda de la factura --->
        <cfquery name="rsMoneda" datasource="#session.dsn#">
        	select Miso4217 from Monedas where Ecodigo = #session.Ecodigo# and Mcodigo = #Mcodigo#
        </cfquery>
        <cfset LvarMoneda = rsMoneda.Miso4217>
        <!--- Moneda Local y por la tanto la moneda del vale --->
        <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
        	select m.Miso4217
            from Empresas e
            inner join Monedas m
            on m.Mcodigo = e.Mcodigo
            and m.Ecodigo = e.Ecodigo
            where e.Ecodigo = #session.Ecodigo#
        </cfquery>
        <cfset LvarLocMoneda = rsMonedaLoc.Miso4217>
        <!--- Se verifica que no haya encontrado una linea del documento que no este asociada a un vale.
        Ademas el monto total de las lineas del documento deben de ser igual a la suma total de todos
        los vales. --->
        <cfif len(trim(LvarEncontroLin)) or LvarMontoU gt 0 and LvarinsertVale>
			<cfif DOlinea EQ 0>
            	<cfset LvarOC = "">
            <cfelse>
                <cfquery name="rsSQL" datasource="#session.dsn#">
                	select EOnumero, DOconsecutivo from DOrdenCM where DOlinea = #DOlinea#
                </cfquery>
            	<cfset LvarOC = ", Orden de Compra '#rsSQL.EOnumero#' Línea '#rsSQL.DOconsecutivo#'">
            </cfif>

            <cfif LvarNumFac eq 1>
            	<cfthrow message="No se encontro el Documento de Responsabilidad de Activo Fijos (Vale) registrados para: Documento '#DDocumento#' Linea: '#LvarEncontroLin#' Cantidad '#DDcantidad#' Total Linea '#LvarMoneda#s #numberFormat(DDtotallin,',.00')#' Monto Unitario Local '#numberFormat(TotalLinUnitLocal,',.00')#'#LvarOC#.">
            <cfelse>
            	<cfquery datasource="#session.dsn#">
                    insert into #request.CRDerrores# (
                        Documento,
                        TipoError,
                        Linea,
                        Cantidad,
                        TotalLin,
                        MontoUnit,
                        Moneda,
                        OC
                    )
                    values(
                        '#DDocumento#',
                        '2',
                        #LvarEncontroLin#,
                        #DDcantidad#,
                        #DDtotallin#,
                        #TotalLinUnitLocal#,
                        '#LvarMoneda#',
                        '#LvarOC#'
                    )
                </cfquery>
                <cfset LvarinsertVale = false>
            </cfif>
        <cfelseif montoFactura GT montoVales and LvarinsertVale>
        	<cfif abs(montoFactura - montoVales) GT permit>
                <cfif LvarNumFac eq 1>
                	<cfthrow message="El monto ('#LvarLocMoneda#s #montoFactura#') del Documento: '#LvarDDocumento#', es mayor que la suma de los montos ('#LvarLocMoneda#s #montoVales#') de los Documentos de Responsabilidad asociados.">
                <cfelse>
                	<cfquery datasource="#session.dsn#">
                        insert into #request.CRDerrores# (
                            Documento,
                            TipoError,
                            Monto,
    						MontoVales,
                            Moneda,
                            MonedaLoc
                        )
                        values(
                            '#LvarDDocumento#',
                            '3',
                            #montoFactura#,
                            #montoVales#,
                            '#LvarMoneda#',
                            '#LvarLocMoneda#'
                        )
                    </cfquery>
                    <cfset LvarinsertVale = false>
                </cfif>
            </cfif>
        <cfelseif montoVales GT montoFactura and LvarinsertVale>
            <cfif abs(montoVales - montoFactura) GT permit>
                <cfif LvarNumFac eq 1>
                	<cfthrow message="El monto ('#LvarLocMoneda#s #montoVales#') del Documento de Responsabilidad, es mayor que el monto ('#LvarLocMoneda#s #montoFactura#') del Documento: '#LvarDDocumento#'.">
                <cfelse>
                	<cfquery datasource="#session.dsn#">
                        insert into #request.CRDerrores# (
                            Documento,
                            TipoError,
                            Monto,
    						MontoVales,
                            Moneda,
                            MonedaLoc
                        )
                        values(
                            '#LvarDDocumento#',
                            '4',
                            #montoFactura#,
                            #montoVales#,
                            '#LvarMoneda#',
                            '#LvarLocMoneda#'
                        )
                    </cfquery>
                    <cfset LvarinsertVale = false>
                </cfif>
            </cfif>
        </cfif>

        <cfif LvarinsertVale>
            <cfloop list="#LvarVale#" index="e" delimiters="&">
                <cfset split = ListToArray(e,'|')>
                <cfquery datasource="#session.dsn#">
                    insert into #request.CRDvales# (
                    Ecodigo,
                    CRDRid,
                    DAlinea,
                    DDlinea,
                    DOlinea,
                    IDdocumento,
                    MontoOri,
                    Monto,
                    CRDRdescripcion
                    )
                    values(
                    #LvarEcodigo#,
                    #split[1]#,
                    #rsSQL.currentRow#,
                    '#split[2]#',
                    null,
                    #LvarIDdocumento#,
                    (#split[3]#/#LvarTipoC#),
                    #split[3]#,
                    '#split[4]#'
                    )
                </cfquery>
            </cfloop>
        </cfif>
    </cfloop>
	</cffunction>

	<cffunction name="AF_GeneraAdquisiciones" access="private" output="no">
        <cfargument name="Usucodigo" type="numeric" required="no" default="#Session.Usucodigo#">
        <cfargument name="Debug" 	 type="boolean" required="no" default="false">

        <!--- El monto del Vale debería ser en Moneda de la Factura (TotalLinea/Cantidad) --->
        <cfquery name="rsVales" datasource="#session.dsn#">
            select count(1) as cantidad, sum(Monto) as total, sum(MontoOri) as totalOri, DDlinea
            from
            #request.CRDvales#
            group by DDlinea
        </cfquery>

        <!--- Crea una Adquisición para cada Documento de Responsabilidad con Lineas diferentes --->
        <cfloop query="rsVales">
            <cfset lista = "#rsVales.DDlinea#">
            <cfset linea1 = ListToArray(lista,',')>
            <cfset DDlineaSplit = ArrayToList(lista.split(','),"")>
            <cfquery name="rsValesDes" datasource="#session.dsn#">
                select CRDRdescripcion from #request.CRDvales# where DDlinea = '#lista#'
            </cfquery>

            <cfquery name="rsD" datasource="#session.dsn#">
                insert into EAadquisicion (
                    Ecodigo,
                    Ocodigo,
                    SNcodigo,
                    EAcpidtrans,
                    EAcpdoc,
                    EAcplinea,
                    EAPeriodo,
                    EAmes,
                    EAFecha,
                    Mcodigo,
                    EAtipocambio,
                    Ccuenta,
                    EAdescripcion,
                    EAcantidad,
                    EAtotalori,
                    EAtotalloc,
                    EAstatus,
                    EAselect,
                    Usucodigo,
                    BMUsucodigo
                )
                select
                    a.Ecodigo,
                    a.Ocodigo,
                    b.SNcodigo,
                    b.CPTcodigo,
                    b.Ddocumento,
                    #DDlineaSplit# as DDlinea,
                    <cf_dbfunction name="date_part"   args="YY,a.Dfechaarribo"> as Periodo,
                    <cf_dbfunction name="date_part"   args="MM,a.Dfechaarribo"> as Mes,
                    a.Dfechaarribo,
                    a.Mcodigo,
                    a.EDtcultrev,
                    a.Ccuenta,
                    <cf_dbfunction name="sPart"args="'#rsValesDes.CRDRdescripcion#';1;80"  delimiters=";"> as Descripcion,
                    #cantidad# as Cantidad,
                    #totalOri# as costoLinea,
                    #total# as costoLineaLocal,
                    0,
                    0,
                    #arguments.Usucodigo#,
                    #arguments.Usucodigo#
                from HDDocumentosCP b
                inner join HEDocumentosCP a
                on a.IDdocumento = b.IDdocumento
                where  b.DDlinea = #linea1[1]#
            </cfquery>
        </cfloop>

        <cfloop query="rsVales">
            <cfset listaD = "#DDlinea#">
            <cfset linea1D = ListToArray(listaD,',')>
            <cfset DDlineaSplitD = ArrayToList(listaD.split(','),"")>

            <!--- Crea una línea de adquisición y un activo en adquisición por cada cantidad de Documentos de Responsabilidad --->
            <cfquery name="createDAaquisicion" datasource="#session.dsn#">
                insert into DAadquisicion (
                    Ecodigo,
                    EAcpidtrans,
                    EAcpdoc,
                    EAcplinea,
                    DAlinea,
                    DAmonto,
                    DAtc,
                    CFcuenta,
                    Usucodigo,
                    BMUsucodigo
                )
                select
                    a.Ecodigo,
                    b.CPTcodigo,
                    b.Ddocumento,
                    #DDlineaSplitD#,
                    #rsVales.currentRow#,
                    <!---►Costo Unitario en Moneda Local◄--->
                    #rsVales.total# as costoLineaUnitLocal,
                    1.00,
                    b.CFcuenta,
                    #arguments.Usucodigo#,
                    #arguments.Usucodigo#
                from HDDocumentosCP b
                inner join HEDocumentosCP a
                on a.IDdocumento = b.IDdocumento
                where b.DDlinea = #linea1D[1]#
            </cfquery>

            <cfquery name="rsValesU" datasource="#session.dsn#">
                select Monto as total, DDlinea, CRDRdescripcion, DAlinea, CRDRid
                from #request.CRDvales#
                where DDlinea = '#listaD#'
            </cfquery>
            <cfloop query="rsValesU">
                <cfset listaU2 = "#DDlinea#">
                <cfset linea1U2 = ListToArray(listaU2,',')>
                <cfset DDlineaSplitU2 = ArrayToList(listaU2.split(','),"")>
                <!---Activos por ser Adquiridos--->
                <cfquery name="PreDSActivosAdq" datasource="#session.dsn#">
                    select
                        a.Ecodigo,
                        b.CPTcodigo,
                        b.Ddocumento,
                        #DDlineaSplitU2# as DDlinea,
                        #rsVales.currentRow# as DAlinea,
                        a.Mcodigo,
                        a.EDtcultrev,
                        b.SNcodigo,
                        r.CRDRdescripcion,
                        a.Dfecha,
                        a.Dfechaarribo,
                        <!---►Costo Unitario en Moneda Local◄--->
                        #rsValesU.total#  as costoLineaUnitLocal,
                        r.CRDRplaca,
                        r.AFMid,
                        r.AFMMid,
                        r.ACcodigo,
                        r.ACid,
                        r.CRDRserie,
                        r.CFid,
                        r.AFCcodigo,
                        r.DEid,
                        r.CRDRid
                    from HDDocumentosCP b
                    inner join HEDocumentosCP a
                    on a.IDdocumento = b.IDdocumento
                    inner join CRDocumentoResponsabilidad r
                    on r.CRDRid = #rsValesU.CRDRid#
                    where b.DDlinea = #linea1U2[1]#
                </cfquery>
                <cfloop query="PreDSActivosAdq">
                    <cfquery name="createDSActivosAdq" datasource="#session.dsn#">
                        insert into DSActivosAdq (
                            Ecodigo,
                            EAcpidtrans,
                            EAcpdoc,
                            EAcplinea,
                            DAlinea,
                            Mcodigo,
                            DSAtc,
                            SNcodigo,
                            DSdescripcion,
                            DSfechainidep,
                            DSfechainirev,
                            Status,
                            DSmonto,
                            DSplaca,
                            AFMid,
                            AFMMid,
                            ACcodigo,
                            ACid,
                            DSserie,
                            CFid,
                            AFCcodigo,
                            DEid,
                            CRDRid,
                            Usucodigo,
                            BMUsucodigo
                        ) values(
                            #PreDSActivosAdq.Ecodigo#,
                            '#PreDSActivosAdq.CPTcodigo#',
                            '#PreDSActivosAdq.Ddocumento#',
                            #PreDSActivosAdq.DDlinea#,
                            #PreDSActivosAdq.DAlinea#,
                            #PreDSActivosAdq.Mcodigo#,
                            #PreDSActivosAdq.EDtcultrev#,
                            #PreDSActivosAdq.SNcodigo#,
                            '#PreDSActivosAdq.CRDRdescripcion#',
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#PreDSActivosAdq.Dfecha#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#PreDSActivosAdq.Dfecha#">,
                            0,
                            #PreDSActivosAdq.costoLineaUnitLocal#,
                            '#PreDSActivosAdq.CRDRplaca#',
                            #PreDSActivosAdq.AFMid#,
                            #PreDSActivosAdq.AFMMid#,
                            #PreDSActivosAdq.ACcodigo#,
                            #PreDSActivosAdq.ACid#,
                            '#PreDSActivosAdq.CRDRserie#',
                            #PreDSActivosAdq.CFid#,
                            #PreDSActivosAdq.AFCcodigo#,
                            #PreDSActivosAdq.DEid#,
                            #PreDSActivosAdq.CRDRid#,
                            #arguments.Usucodigo#,
                            #arguments.Usucodigo#
                        )
                        <cf_dbidentity1>
                    </cfquery>
                    <cf_dbidentity2 name="createDSActivosAdq" verificar_transaccion="false">
                    <!---Se Copian los datos variables de CRDocumentoResponsabilidad a DSActivosAdq--->
                    <cfinvoke component="sif.Componentes.DatosVariables" method="COPIARVALOR">
                        <cfinvokeargument name="DVTcodigoValor"     value="AF">
                        <cfinvokeargument name="DVVidTablaVal"      value="#PreDSActivosAdq.CRDRid#">
                        <cfinvokeargument name="DVVidTablaSec"      value="1"><!---CRDocumentoResponsabilidad--->
                        <cfinvokeargument name="DVVidTablaVal_new"  value="#createDSActivosAdq.identity#">
                        <cfinvokeargument name="DVVidTablaSec_new"  value="2"><!---DSActivosAdq--->
                    </cfinvoke>
                    <!---Se marca el Documento de responsabilidad como usado en un Sistema Externo para que no se pueda recuperar en la inclusión de Documentos--->
                    <cfquery datasource="#session.dsn#">
                        update CRDocumentoResponsabilidad
                        set CRDRutilaux = 1
                        where CRDRid = #PreDSActivosAdq.CRDRid#
                    </cfquery>
                </cfloop>
            </cfloop>
        </cfloop>
    </cffunction>
    <!---►►Funcion para crear el Encabezado de la Adquisicion◄◄--->
    <cffunction name="AltaEAadquisicion" access="public" hint="Se Crea el Encabezado de la Adquisicion" returntype="numeric">
    	   <cfargument name="Ecodigo" 			type="numeric" required="no">
           <cfargument name="EAcpidtrans" 		type="string"  required="yes" hint="Codigo de transaccion de 2 Catacteres">
           <cfargument name="EAcpdoc" 			type="string"  required="yes" hint="Documento de la Adquisicion">
           <cfargument name="EAcplinea" 		type="numeric" required="no"  hint="Consectivo del Encabezado por Empresa, Codigo de transaccion y Documento de Adquisicion, si no se envia se usa un Incremental">
           <cfargument name="Ocodigo" 			type="numeric" required="yes" hint="Codigo de la Oficina">
           <cfargument name="Aid" 				type="numeric" required="no"  hint="Id del Almacen" default="-1">
           <cfargument name="EAPeriodo" 		type="numeric" required="yes" hint="Periodo">
           <cfargument name="EAmes" 			type="numeric" required="yes" hint="Mes">
           <cfargument name="EAFecha" 			type="date"    required="yes" hint="fecha">
           <cfargument name="Mcodigo" 			type="numeric" required="no"  hint="Moneda" default="-1">
           <cfargument name="EAtipocambio" 		type="numeric" required="yes" hint="Tipo de Cambio">
           <cfargument name="Ccuenta" 			type="numeric" required="no"  hint="Cuenta Contable">
           <cfargument name="CFcuenta" 			type="numeric" required="no"  hint="Cuenta Financiera">
           <cfargument name="SNcodigo" 			type="numeric" required="no"  hint="Socio de Negocios">
           <cfargument name="EAdescripcion" 	type="string"  required="yes" hint="Descripcion Adquisicion">
           <cfargument name="EAcantidad" 		type="numeric" required="yes" hint="Cantidad de Activos">
           <cfargument name="EAtotalori" 		type="numeric" required="yes" hint="Monto Original">
           <cfargument name="EAtotalloc" 		type="numeric" required="yes" hint="Monto Local">
           <cfargument name="EAstatus" 			type="numeric" required="yes" hint="Estatus de la Adquisicion(0=Sin aplicar,1=En proceso,2=Aplicado)" default="0">
           <cfargument name="EAselect" 			type="numeric" required="yes" hint="Seleccionado" default="0">
           <cfargument name="Usucodigo" 		type="numeric" required="no"  hint="Usuario">
           <cfargument name="BMfechaproceso" 	type="date"    required="no"  hint="Fecha transaccion" default="#now()#">
           <cfargument name="IDcontable" 		type="numeric" required="no"  hint="ID contable" default="-1">
           <cfargument name="BMUsucodigo" 		type="numeric" required="no"  hint="Codigo de Usuario que hace la Adquisicion">
           <cfargument name="Conexion" 			type="string"  required="no"  hint="Nombre del Datasource">
           <cfargument name="Miso4217"  	    type="string"  required="no"  hint="ISO de la moneda" 	default="">

           <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
           		<cfset Arguments.Conexion = session.dsn>
           </cfif>
           <cfif NOT ISDEFINED('Arguments.BMUsucodigo') AND ISDEFINED('session.Usucodigo')>
           		<cfset Arguments.BMUsucodigo = session.Usucodigo>
           </cfif>
           <cfif NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('session.Usucodigo')>
           		<cfset Arguments.Usucodigo = session.Usucodigo>
           </cfif>
           <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
           		<cfset Arguments.Ecodigo = session.Ecodigo>
           </cfif>

            <!---►►Valida la empresa enviada◄◄--->
            <cfquery name="rsEmpresa" datasource="#Arguments.Conexion#">
                select Edescripcion from Empresas where Ecodigo = #Arguments.Ecodigo#
            </cfquery>
            <cfif NOT rsEmpresa.RecordCount>
                <cfthrow message="La empresa enviada no existe (Ecodigo = #Arguments.Ecodigo#)">
            </cfif>

            <!---►►Validacion de la moneda--->
			<cfif Arguments.Mcodigo EQ -1 and LEN(TRIM(Arguments.Miso4217))>
                <cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
                    select Mcodigo
                        from Monedas
                    where Ecodigo  = #Arguments.Ecodigo#
                      and Miso4217 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Miso4217#">
                </cfquery>
                <cfif NOT rsMoneda.Recordcount>
                    <cfthrow message="La moneda #Arguments.Miso4217# no existe en la empresa #rsEmpresa.Edescripcion#">
                <cfelse>
                    <cfset Arguments.Mcodigo = rsMoneda.Mcodigo>
                </cfif>
            <cfelseif Arguments.Mcodigo NEQ -1>
                <cfquery name="rsMoneda" datasource="#Arguments.Conexion#">
                    select Mcodigo
                        from Monedas
                    where Ecodigo = #Arguments.Ecodigo#
                      and Mcodigo = #Arguments.Mcodigo#
                </cfquery>
                <cfif NOT rsMoneda.Recordcount>
                    <cfthrow message="La moneda (Mcodigo = #Arguments.Mcodigo#) no existe en la empresa #rsEmpresa.Edescripcion#">
                </cfif>
            <cfelse>
                <cfthrow message="No se envio la moneda del Documento">
            </cfif>


           <cfif NOT ISDEFINED('Arguments.EAcplinea')>
           		<cfquery name="MAXEAcplinea" datasource="#Arguments.Conexion#">
                	select Coalesce(max(EAcplinea),0)+1 as NewEAcplinea
                    	from EAadquisicion
                      where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                        and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EAcpidtrans#">
                        and EAcpdoc  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EAcpdoc#">
                </cfquery>
                <cfset Arguments.EAcplinea = MAXEAcplinea.NewEAcplinea>
           </cfif>
           <cfif NOT ISDEFINED('Arguments.Ccuenta') AND NOT ISDEFINED('Arguments.CFcuenta')>
           		<cfthrow message="Se debe eviar la cuenta Contable o Cuenta Financiera">
           <cfelseif NOT ISDEFINED('Arguments.Ccuenta')>
           		<cfquery name="rsCFinanciera" datasource="#Arguments.Conexion#">
                	select min(Ccuenta) Ccuenta
                    	from CFinanciera
                     where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">
                </cfquery>
                <cfset Arguments.Ccuenta = rsCFinanciera.Ccuenta>
           </cfif>

		<cfquery datasource="#Arguments.Conexion#">
             INSERT INTO EAadquisicion (
               Ecodigo,
               EAcpidtrans,
               EAcpdoc,
               EAcplinea,
               Ocodigo,
               Aid,
               EAPeriodo,
               EAmes,
               EAFecha,
               Mcodigo,
               EAtipocambio,
               Ccuenta,
               SNcodigo,
               EAdescripcion,
               EAcantidad,
               EAtotalori,
               EAtotalloc,
               EAstatus,
               EAselect,
               Usucodigo,
               BMfechaproceso,
               IDcontable,
               BMUsucodigo)
    		VALUES(
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.EAcpidtrans#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.EAcpdoc#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.EAcplinea#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ocodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Aid#"            voidNull null="#Arguments.Aid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.EAPeriodo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.EAmes#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.EAFecha#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Mcodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#Arguments.EAtipocambio#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ccuenta#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.SNcodigo#"       voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="80"  value="#Arguments.EAdescripcion#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#Arguments.EAcantidad#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.EAtotalori#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.EAtotalloc#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.EAstatus#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.EAselect#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.BMfechaproceso#" voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.IDcontable#"     voidNull null="#Arguments.IDcontable EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.BMUsucodigo#">
        	)
    	 </cfquery>
         <cfreturn Arguments.EAcplinea>
    </cffunction>
    <!---►►Funcion para crear el Detalle de Activos en Proceso de Adquisición◄◄--->
    <cffunction name="AltaDAadquisicion" access="public" hint="Funcion para crear el Detalle de Activos en Proceso de Adquisición" returntype="numeric">
        <cfargument name="Ecodigo" 			type="numeric"  required="no"  hint="Codigo de la empresa">
        <cfargument name="EAcpidtrans" 		type="string"   required="yes" hint="Codigo de transaccion de 2 Catacteres">
        <cfargument name="EAcpdoc" 			type="string"   required="yes" hint="Documento de la Adquisicion">
        <cfargument name="EAcplinea" 		type="numeric"  required="yes" hint="Consecutivo del Encabezado por Empresa, Codigo de transaccion y Documento de Adquisicion">
        <cfargument name="DAlinea" 			type="numeric"  required="no"  hint="Consecutivo del detalle por empresa/Codigo transaccion/Documento Adq/linea del Enbezado- Si no se envia se crear  con un Incremental">
        <cfargument name="DAmonto" 			type="numeric"  required="yes" hint="Monto">
        <cfargument name="CFcuenta" 		type="numeric"  required="yes" hint="Cuenta Financiera">
        <cfargument name="Usucodigo" 		type="numeric"  required="no"  hint="Usuario">
        <cfargument name="DAtc" 			type="numeric"  required="no"  hint="Tipo de Cambio" default="-1">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no"  hint="Codigo de Usuario que hace la Adquisicion">
        <cfargument name="Conexion" 		type="string"   required="no"  hint="Nombre del Datasource">

       <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
			<cfset Arguments.Conexion = session.dsn>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.BMUsucodigo') AND ISDEFINED('session.Usucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('session.Usucodigo')>
            <cfset Arguments.Usucodigo = session.Usucodigo>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
       </cfif>

       <cfif NOT ISDEFINED('Arguments.DAlinea')>
            <cfquery name="MAXEAcplinea" datasource="#Arguments.Conexion#">
                select Coalesce(max(DAlinea),0)+1 as NewDAlinea
                    from DAadquisicion
                  where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                    and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EAcpidtrans#">
                    and EAcpdoc  	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.EAcpdoc#">
                    and EAcplinea  	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EAcplinea#">
            </cfquery>
            <cfset Arguments.DAlinea = MAXEAcplinea.NewDAlinea>
       </cfif>

        <cfquery datasource="#Arguments.Conexion#">
        	INSERT INTO DAadquisicion (
               Ecodigo,
               EAcpidtrans,
               EAcpdoc,
               EAcplinea,
               DAlinea,
               DAmonto,
               CFcuenta,
               Usucodigo,
               DAtc,
               BMUsucodigo)
            VALUES(
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Ecodigo#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.EAcpidtrans#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.EAcpdoc#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.EAcplinea#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.DAlinea#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.DAmonto#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFcuenta#"    voidNull null="#Arguments.CFcuenta EQ -1#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#Arguments.DAtc#"        voidNull null="#Arguments.DAtc EQ -1#">,
                   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">
            	)
    	</cfquery>
        <cfreturn Arguments.DAlinea>
	</cffunction>
    <!---►►Funcion para crear la Detalle de Separación de Activos Adquiridos◄◄--->
    <cffunction name="AltaDSActivosAdq" access="public" hint="Funcion para crear la Detalle de Separación de Activos Adquiridos" returntype="numeric">
        <cfargument name="Ecodigo" 			type="numeric"  required="no"  hint="Codigo de la empresa">
        <cfargument name="EAcpidtrans" 		type="string"   required="yes" hint="Codigo de transaccion de 2 Catacteres">
        <cfargument name="EAcpdoc" 			type="string"   required="yes" hint="Documento de la Adquisicion">
        <cfargument name="EAcplinea" 		type="numeric"  required="yes" hint="Consecutivo del Encabezado por Empresa, Codigo de transaccion y Documento de Adquisicion">
        <cfargument name="DAlinea" 			type="numeric"  required="no"  hint="Consecutivo del detalle por empresa/Codigo transaccion/Documento Adq/linea del Enbezado- Si no se envia se crear  con un Incremental">
        <cfargument name="AFMid" 			type="numeric"  required="no"  hint="ID de la Marca"  				default="-1">
        <cfargument name="AFMMid" 			type="numeric"  required="no"  hint="ID del Modelo"   				default="-1">
        <cfargument name="DEid" 			type="numeric"  required="no"  hint="ID del Empleado" 				default="-1">
        <cfargument name="Alm_Aid" 			type="numeric"  required="no"  hint="Almacen"		   				default="-1">
        <cfargument name="Aid" 				type="numeric"  required="no"  hint="ID del Activo" 				default="-1">
        <cfargument name="Mcodigo" 			type="numeric"  required="no"  hint="Codigo de la Moneda" 			default="-1">
        <cfargument name="AFCcodigo" 		type="numeric"  required="no"  hint="Codigo de la Clasificacion" 	default="-1">
        <cfargument name="CFid" 			type="numeric"  required="no"  hint="Centro Funcional" 				default="-1">
        <cfargument name="DSAtc" 			type="numeric"  required="no"  hint="Tipo de cambio" 				default="1">
        <cfargument name="SNcodigo" 		type="numeric"  required="no"  hint="Codigo del Socio de Negocios" 	default="-1">
        <cfargument name="ACcodigo" 		type="numeric"  required="no"  hint="Categoria" 					default="-1">
        <cfargument name="ACid" 			type="numeric"  required="no"  hint="Clasificacion" 				default="-1">
        <cfargument name="DSdescripcion" 	type="string"   required="yes" hint="Descripcion del Activo Fijo">
        <cfargument name="DSserie" 			type="string"   required="no"  hint="Seria"							default="">
        <cfargument name="DSplaca" 			type="string"   required="no"  hint="Placa"							default="">
        <cfargument name="DSfechainAdq" 	type="date"   	required="no"  hint="Fecha de Adquisicion">
        <cfargument name="DSfechainidep" 	type="date"     required="no"  hint="Fecha de Inicio de Depreciacion">
        <cfargument name="DSfechainirev" 	type="date"     required="no"  hint="Fecha de Inicion de Revaluacion">
        <cfargument name="DSmonto" 			type="numeric"  required="yes" hint="Monto">
        <cfargument name="Status" 			type="numeric"  required="no"  hint="Estado"						default="-1">
        <cfargument name="CRDRid" 			type="numeric"  required="no"  hint="Documento de Responsabilidad" 	default="-1">
        <cfargument name="Usucodigo" 		type="numeric"  required="no"  hint="Codigo de la empresa">
        <cfargument name="BMUsucodigo" 		type="numeric"  required="no"  hint="Codigo de la empresa">

        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
			<cfset Arguments.Conexion = session.dsn>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.BMUsucodigo') AND ISDEFINED('session.Usucodigo')>
            <cfset Arguments.BMUsucodigo = session.Usucodigo>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.Usucodigo') AND ISDEFINED('session.Usucodigo')>
            <cfset Arguments.Usucodigo = session.Usucodigo>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.DSfechainidep')>
       		<cfquery name="rsParam940" datasource="#Arguments.Conexion#">
            	select Coalesce(Pvalor,'1') Meses from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 940
            </cfquery>
            <cfset Arguments.DSfechainidep = DATEADD('m',rsParam940.Meses,Arguments.DSfechainAdq)>
       </cfif>
       <cfif NOT ISDEFINED('Arguments.DSfechainirev')>
       		<cfquery name="rsParam950" datasource="#Arguments.Conexion#">
            	select Coalesce(Pvalor,'12') Meses from Parametros where Ecodigo = #Arguments.Ecodigo# and Pcodigo = 950
            </cfquery>
            <cfset Arguments.DSfechainirev = DATEADD('m',rsParam950.Meses,Arguments.DSfechainAdq)>
       </cfif>

        <cfquery name="rsInsertAct" datasource="#Arguments.Conexion#">
            INSERT INTO DSActivosAdq (
               Ecodigo,
               EAcpidtrans,
               EAcpdoc,
               EAcplinea,
               DAlinea,
               AFMid,
               AFMMid,
               DEid,
               Alm_Aid,
               Aid,
               Mcodigo,
               AFCcodigo,
               CFid,
               DSAtc,
               SNcodigo,
               ACcodigo,
               ACid,
               DSdescripcion,
               DSserie,
               DSplaca,
               DSfechainidep,
               DSfechainirev,
               DSmonto,
               Status,
               CRDRid,
               Usucodigo,
               BMUsucodigo)
            VALUES(
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Ecodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#Arguments.EAcpidtrans#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.EAcpdoc#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.EAcplinea#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.DAlinea#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.AFMid#"         voidNull 	null="#Arguments.AFMid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.AFMMid#"        voidNull 	null="#Arguments.AFMMid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.DEid#"          voidNull 	null="#Arguments.DEid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Alm_Aid#"       voidNull 	null="#Arguments.Alm_Aid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Aid#"           voidNull 	null="#Arguments.Aid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Mcodigo#"       voidNull 	null="#Arguments.Mcodigo EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.AFCcodigo#"     voidNull 	null="#Arguments.AFCcodigo EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CFid#"          voidNull 	null="#Arguments.CFid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#Arguments.DSAtc#"         voidNull 	null="#Arguments.DSAtc EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.SNcodigo#"      voidNull 	null="#Arguments.SNcodigo EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.ACcodigo#"      voidNull 	null="#Arguments.ACcodigo EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.ACid#"          voidNull 	null="#Arguments.ACid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="100" value="#Arguments.DSdescripcion#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="50"  value="#Arguments.DSserie#"       voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#Arguments.DSplaca#"       voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.DSfechainidep#" voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#Arguments.DSfechainirev#" voidNull>,
               <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#Arguments.DSmonto#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Status#"        voidNull 	null="#Arguments.Status EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.CRDRid#"        voidNull 	null="#Arguments.CRDRid EQ -1#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#Arguments.Usucodigo#">,
               <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#Arguments.Usucodigo#">
            )
            <cf_dbidentity1 name="rsInsertAct" datasource="#Arguments.Conexion#">
        </cfquery>
            <cf_dbidentity2 name="rsInsertAct" datasource="#Arguments.Conexion#" returnvariable="NewLin">
            <cfreturn NewLin>
	</cffunction>
    <cffunction name="AF_VerificaErrores" access="public" returntype="query" hint="Funcion para verificar que no ocurrieran errores en el proceso de Adquisicion de Activo">
        <cfquery name="rsSelectErr" datasource="#session.dsn#">
        	select * from #request.CRDerrores#
        </cfquery>
        <cfreturn #rsSelectErr#>
	</cffunction>
</cfcomponent>
