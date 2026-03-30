<!--- Importa Socios de Negocio --->

<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name# 
</cfquery>

<!--- Valida que exista al menos un estado de Socio de negocios, si no lo inserta (Activo) --->
<cfquery name="rsCheck" datasource="#session.dsn#">
	select min(ESNid) as ESNid
	from EstadoSNegocios
	where Ecodigo = #session.Ecodigo# 
</cfquery>

<cfif Len(rsCheck.ESNid) EQ 0>
	<cfquery datasource="#session.dsn#">
		insert into EstadoSNegocios 
		(Ecodigo, 
		 ESNcodigo, 
		 ESNdescripcion, 
		 ESNfacturacion)
		values (
		 #session.Ecodigo#, 
		 '01', 
		 'Activo', 
		 0)
	</cfquery>
	
	<cfquery name="rsCheck" datasource="#session.dsn#">
		select min(ESNid) as ESNid
		from EstadoSNegocios
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfset LvarESNid = rsCheck.ESNid>

<cfelse>
	<cfset LvarESNid = rsCheck.ESNid>
</cfif>

<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>
    
    <!--- Valida que exista el detalle de la clasificación --->
    <cfquery name="rsDet1" datasource="#session.DSN#">
        select SND.SNCDid, SND.SNCDdescripcion,SNE.SNCEdescripcion 
        from SNClasificacionD SND
            Inner Join SNClasificacionE SNE On
                (SNE.Ecodigo = #Session.Ecodigo#  Or Ecodigo is Null) And
                SNE.SNCEid = SND.SNCEid
        where 
            SND.SNCDdescripcion = '#rsImportador.DetClasificacion1#' And    
            SNE.SNCEid = (Select SNC1.SNCEid From SNClasificacionE SNC1
            				Where 
                            	SNC1.SNCEdescripcion = '#rsImportador.EncClasificacion1#' And 
                    			(SNC1.Ecodigo = #Session.Ecodigo# Or SNC1.Ecodigo is Null))         	
    </cfquery>
    
    <cfif rsDet1.RecordCount eq 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La clasificaci&oacute;n&nbsp;#rsImportador.EncClasificacion1# no se puede asociar con el valor&nbsp;#rsImportador.DetClasificacion1#!')
		</cfquery>    	
    </cfif>
    
    <!--- Valida que exista el detalle de la clasificación --->
    <cfquery name="rsDet2" datasource="#session.DSN#">
        select SND.SNCDid, SND.SNCDdescripcion,SNE.SNCEdescripcion 
        from SNClasificacionD SND
            Inner Join SNClasificacionE SNE On
                (SNE.Ecodigo = #Session.Ecodigo#  Or Ecodigo is Null) And
                SNE.SNCEid = SND.SNCEid
        where 
            SND.SNCDdescripcion = '#rsImportador.DetClasificacion2#' And    
            SNE.SNCEid = (Select SNCEid From SNClasificacionE SNC1 
            				Where 
                            	SNC1.SNCEdescripcion = '#rsImportador.EncClasificacion2#' And 
                    			(SNC1.Ecodigo = #Session.Ecodigo# Or SNC1.Ecodigo is Null))         	
    </cfquery>
    
    <cfif rsDet2.RecordCount eq 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La clasificaci&oacute;n&nbsp;#rsImportador.EncClasificacion2# no se puede asociar con el valor&nbsp;#rsImportador.DetClasificacion2#!')
		</cfquery>    	
    </cfif>

	<!--- Valida que el socio de negocios no venga repetido en el archivo a importar --->
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad, SNnumero
		from #table_name# 
		where SNnumero = '#rsImportador.SNnumero#'
		group by SNnumero
		having count(1) > 1
	</cfquery>

	<cfif rsCheck.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Socio de Negocios número (#rsImportador.SNnumero#) viene repetido (#rscheck.cantidad# veces) en el archivo a importar!')
		</cfquery>
	</cfif>

	<!--- Valida que el socio no exista en el sistema --->
	<cfquery name="rsCheck" datasource="#session.dsn#">
		select count(1) as cantidad, SNnumero
		from SNegocios
		where SNnumero = '#rsImportador.SNnumero#'
		  and Ecodigo  = #Session.Ecodigo#
		group by SNnumero
		having count(1) > 0
	</cfquery>
	
	<cfif rsCheck.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Socio de Negocios número (#rsImportador.SNnumero#) ya existe en el sistema!')
		</cfquery>
	</cfif>
	
	<!--- Valida que la identificación del socio de negocios no venga repetida en el archivo a importar --->
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad, SNidentificacion
		from #table_name# 
		where SNidentificacion = '#rsImportador.SNidentificacion#'
		group by SNidentificacion
		having count(1) > 1
	</cfquery>

	<cfif rsCheck.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La identificación (#rsImportador.SNidentificacion#) viene repetida (#rscheck.cantidad# veces) en el archivo a importar!')
		</cfquery>
	</cfif>
	
	<!--- Valida que identificacion de Socio de negocios no exista en el sistema --->
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad
		from SNegocios
		where Ecodigo = #session.Ecodigo#
		  and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.SNidentificacion#">
	</cfquery>

	<cfif rsCheck.cantidad GT 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La identificaci&oacute;n #rsImportador.SNidentificacion# digitada, esta asignada a otro Socio de Negocios')
		</cfquery>
	</cfif>
	
	<!--- Valida que el nombre del socio de negocios no venga repetido en el archivo a importar --->
	<cfquery name="rsCheck" datasource="#session.DSN#">
		select count(1) as cantidad, SNnombre
		from #table_name# 
		where SNnombre = '#rsImportador.SNnombre#'
		group by SNnombre
		having count(1) > 1
	</cfquery>

	<cfif rsCheck.cantidad gt 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El nombre del socio (#rsImportador.SNnombre#) viene repetido (#rscheck.cantidad# veces) en el archivo a importar!')
		</cfquery>
	</cfif>

	<!--- Valida que la moneda exista en el sistema --->	
	<cfquery datasource="#session.DSN#" name="rsCheck">
		select count(1) as cantidad
		from Monedas
		where Ecodigo = #session.Ecodigo#
		and upper(Mnombre) = upper('#rsImportador.Mnombre#')
	</cfquery>
	
	<cfif rsCheck.cantidad eq 0 >
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. La moneda #rsImportador.Mnombre# no existe en el sistema!')
		</cfquery>
	</cfif>

	<!--- Si viene el país, valida que el país exista en la tabla Pais --->
	<cfif len(trim(rsImportador.Ppais))>
		<cfquery name="rsCheck" datasource="#session.DSN#">
			select count(1) as cantidad
			from #table_name# a
			inner join Pais b
				on b.Ppais = a.Ppais
			where a.Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsImportador.Ppais#">
		</cfquery>
		<cfif rsCheck.cantidad EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#">
				insert into #errores# (Error)
				values ('Error. El Pais (#rsImportador.Ppais#) no existe en el sistema! (Favor pedir un listado de la tabla Pais a su DBA)')
			</cfquery>
		</cfif>
	</cfif>
	
	<!--- Valida que que SNtipo del Socio sea F o J --->
	<cfif not (Ucase(rsImportador.SNtipo) EQ 'F' or Ucase(rsImportador.SNtipo) EQ 'J')>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Socio de negocios con la identificaci&oacute;n: (#rsImportador.SNidentificacion#) tiene un (SNtipo = #rsImportador.SNtipo#) diferente a (F) o (J)')
		</cfquery>
	</cfif>
	
	<!--- Valida que que SNtiposocio del Socio sea C, P o A --->
	<cfif not (Ucase(rsImportador.SNtiposocio) EQ 'C' or Ucase(rsImportador.SNtiposocio) EQ 'P' or Ucase(rsImportador.SNtiposocio) EQ 'A')>
		<cfquery name="ERR" datasource="#session.DSN#">
			insert into #errores# (Error)
			values ('Error. El Socio de negocios con la identificaci&oacute;n: (#rsImportador.SNidentificacion#) tiene un (SNtiposocio = #rsImportador.SNtiposocio#) diferente a (C), (P) o (A)')
		</cfquery>
	</cfif>
</cfloop>


<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>

<cfif rsErrores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
		group by Error
	</cfquery>
	<cfreturn>
<cfelseif rsErrores.cantidad EQ 0>
	<cftransaction>
		<cfloop query="rsImportador">
			<!--- Calcula el SNcodigo --->
			<cfquery name="rsNextSNcodigo" datasource="#session.DSN#">
				select coalesce(max(SNcodigo),0)+1 as SNcodigo
				from SNegocios 
				where Ecodigo = #session.Ecodigo#
				  and SNcodigo <> 9999
			</cfquery>
			<cfset LvarSNcodidgo = rsNextSNcodigo.SNcodigo>
			
			<!--- Busca la moneda con la empresa y el nombre de la moneda --->		
			<cfquery datasource="#session.DSN#" name="rsCheck">
				select Mcodigo
				from Monedas
				where Ecodigo = #session.Ecodigo#
				  and upper(Mnombre) = upper('#rsImportador.Mnombre#')
			</cfquery>
			<cfset LvarMoneda = rsCheck.Mcodigo>
			
            
            <!--- Se realiza la inserción en la tabla DireccionesSIF --->
            <cfquery name="rsInserSIF" datasource="#session.DSN#">            
                insert into DireccionesSIF (
                    atencion, direccion1, direccion2,
                    ciudad, estado, codPostal, Ppais,
                    BMUsucodigo, BMfechamod)
                values (
                    null,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Dirección1#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Dirección2#">,
                    null,
                    null,
                    null,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Ppais#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)   
                    
                    <cf_dbidentity1 datasource="#session.DSN#">                                          	
            </cfquery> 
            
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInserSIF">
            <cfset LvarSNSIF = rsInserSIF.identity>                       
            
			<!--- Inserta el Socio --->
			<cfquery name="rsInsertSN" datasource="#session.DSN#">
				insert into SNegocios (
					Ecodigo,
					SNcodigo,
					SNnumero,
					SNidentificacion,
					SNtipo,
					SNnombre,
					SNcertificado,
					SNFecha,
					SNtiposocio,
					Mcodigo,
					SNtelefono,
					SNFax,
					SNemail,
					Ppais,
					SNvencompras,
					SNvenventas,
					ESNid,
                    BMUsucodigo,
                    SNcodigoext,
                    id_direccion
				)
				values(
					#session.Ecodigo#,
					#LvarSNcodidgo#,
					<cfqueryparam cfsqltype="cf_sql_char" 	  value="#SNnumero#">,
					<cfqueryparam cfsqltype="cf_sql_char"     value="#SNidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	  value="#Ucase(SNtipo)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#SNnombre#">,
					<cfif len(trim(SNcertificado)) GT 0>
						<cfqueryparam cfsqltype="cf_sql_integer"  value="#SNcertificado#">,
					<cfelse>
						0,
					</cfif>
					
					<cfif len(trim(SNFecha))>
						<cfqueryparam cfsqltype="cf_sql_date" value="#SNFecha#">,
					<cfelse>
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_char" 	  value="#Ucase(SNtiposocio)#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"  value="#LvarMoneda#">,
					<cfif len(trim(SNtelefono))>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#SNtelefono#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNFax))>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#SNFax#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNemail))>
						<cfqueryparam cfsqltype="cf_sql_varchar"  value="#SNemail#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(Ppais))>
						<cfqueryparam cfsqltype="cf_sql_char"  value="#Ppais#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNvencompras))>
						<cfqueryparam cfsqltype="cf_sql_integer"  value="#SNvencompras#">,
					<cfelse>
						null,
					</cfif>
					<cfif len(trim(SNvenventas))>
						<cfqueryparam cfsqltype="cf_sql_integer"  value="#SNvenventas#">,
					<cfelse>
						null,
					</cfif>
					#LvarESNid#,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNcodigoext#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNSIF#">
				)
                
                <cf_dbidentity1 datasource="#session.DSN#"> 
			</cfquery> 
            
            <cf_dbidentity2 datasource="#session.DSN#" name="rsInsertSN">
			<cfset LvarSNid = rsInsertSN.identity>                        
                        
            <!--- Se inserta los datos en la tabla SNDirecciones --->
            <cfquery datasource="#session.DSN#">
                insert into SNDirecciones (
                    SNid, id_direccion, Ecodigo, SNcodigo, SNDcodigo, SNnombre, SNcodigoext,
                    SNDfacturacion, SNDenvio, SNDactivo, SNDlimiteFactura,
                    DEid, BMUsucodigo, SNDtelefono, SNDFax, SNDemail)
                values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNSIF#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodidgo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" 	  value="#SNnumero#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNnombre#">,
                   	null,
                    1, 1, 1, 0, null, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNtelefono#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNFax#">, 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNemail#">
                )        	
            </cfquery>

            <cfquery name="rsDet1" datasource="#session.DSN#">
                select SND.SNCDid, SND.SNCDdescripcion,SNE.SNCEdescripcion 
                from SNClasificacionD SND
                    Inner Join SNClasificacionE SNE On
                        (SNE.Ecodigo = #Session.Ecodigo#  Or Ecodigo is Null) And
                        SNE.SNCEid = SND.SNCEid
                where 
                    SND.SNCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetClasificacion1#"> And    
                    SNE.SNCEid = (Select SNC1.SNCEid From SNClasificacionE SNC1
                    				Where 
                                    	SNC1.SNCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EncClasificacion1#"> And 
                    				(SNC1.Ecodigo = #Session.Ecodigo# Or SNC1.Ecodigo is Null))         	
            </cfquery>
            
            <cfquery name="rsDet2" datasource="#session.DSN#">
                select SND.SNCDid, SND.SNCDdescripcion,SNE.SNCEdescripcion 
                from SNClasificacionD SND
                    Inner Join SNClasificacionE SNE On
                        (SNE.Ecodigo = #Session.Ecodigo#  Or Ecodigo is Null) And
                        SNE.SNCEid = SND.SNCEid
                where 
                    SND.SNCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DetClasificacion2#"> And    
                    SNE.SNCEid = (Select SNC1.SNCEid From SNClasificacionE SNC1
                    				Where SNC1.SNCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EncClasificacion2#"> And 
                    				(SNC1.Ecodigo = #Session.Ecodigo# Or SNC1.Ecodigo is Null))     	
            </cfquery>           
            
            <cfquery datasource="#session.DSN#">
            	insert into SNClasificacionSN (
                	SNid, SNCDid )
                values (
                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDet1.SNCDid#">
             	)
                
            	insert into SNClasificacionSN (
                	SNid, SNCDid )
                values (
                	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDet2.SNCDid#">
             	)            
            </cfquery>
            
            <cfquery datasource="#session.DSN#">
            	insert into SNClasificacionSND (
                	SNid, id_direccion, SNCDid, BMUsucodigo )
                values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNSIF#">,  
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDet1.SNCDid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">             
                )
                
            	insert into SNClasificacionSND (
                	SNid, id_direccion, SNCDid, BMUsucodigo )
                values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNSIF#">,  
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDet2.SNCDid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">             
                )                              
            </cfquery>
                
		</cfloop>
		<cftransaction action="commit"/>
	</cftransaction>
</cfif>