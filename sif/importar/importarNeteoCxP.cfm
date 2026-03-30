<!---
Importador de Neteo de Documentos de CxP
05 de Febrero de 2009
SE VALIDA: 
	--Cantidad de Monedas.  No puede ser mayor a 1 para evitar errores
	--La moneda debe Existir
	--Cantidad de Socios de Negocio.  No debe ser mayor a 1 para evitar errores.
	--El socio de Negocios debe Existir
	--Documentos No encontrados
	--Transacciones no existentes en CTransacciones
	--Documentos con Monto mayor que el saldo del Documento
	--Documentos con transacciones con montos invertidos
	--Existencia de Transacción para Neteo
	
	--Suma de los montos para garantizar que esta balanceado
	--Documentos repetidos
--->
<cf_dbtemp name="tempImpNetCxP_v1" returnvariable="TableErr" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	 <cf_dbtempcol name="Valor"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 
<cf_dbfunction name="now"	returnvariable="hoy">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset debug= false>
<cfif debug>
	<cfquery name="DBG" datasource="#session.dsn#">select * from #table_name#</cfquery><cf_dump var="#DBG#">
</cfif>
<!---Validacion de la MONEDA--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error)
	  select 'Existe más de una moneda.' as Error from dual
	 where (select count(distinct Moneda) from #table_name#) > 1
</cfquery>
<cfquery datasource="#session.dsn#">
	 insert into #TableErr#(Error)
	  select 'La Moneda no Existe ' from dual
	  where ( select count(1)
				from #table_name# tem
				  inner join Monedas mon
					on mon.Miso4217 = tem.Moneda
			  where mon.Ecodigo = #session.Ecodigo# 
			 ) = 0
</cfquery>		
<!---Validacion deL SOCIO--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error)
	  select 'Existe más de un Socio de Negocios.' as Error from dual
	 where (select count(distinct Socio) from #table_name#) > 1
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error)
	  select 'El socio de Negocios no Existe ' from dual
	 where (select count(1)
			   from #table_name# tem
			     inner join SNegocios SN
				  on SN.SNnumero = tem.Socio
			  where Ecodigo = #session.Ecodigo#
			) = 0
</cfquery>
<!---Validacion deL DOCUMENTO--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'El Documento no Existe', Documento
	 from #table_name# 
	where not exists(select 1
			          from SNegocios s
					   inner join EDocumentosCP d
						 on d.SNcodigo   = s.SNcodigo
						and d.Ecodigo    = s.Ecodigo
					where s.Ecodigo    = #session.Ecodigo#
					  and s.SNnumero   = #table_name#.Socio
					  and d.CPTcodigo  = #table_name#.TipoTransaccion
					  and d.Ddocumento = #table_name#.Documento
					  )
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'Hay documentos repetidos.', TipoTransaccion #_Cat# '-' #_Cat# Documento
	 from #table_name#
	group by TipoTransaccion,Documento
	having count(1) > 1 
</cfquery>
<!---Validacion de la TRANSACCION--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'La Transaccion no Existe', TipoTransaccion
	from #table_name#
	where not exists(select 1 
	                  from CPTransacciones tt
					where tt.Ecodigo = #session.Ecodigo#
					  and tt.CPTcodigo = #table_name#.TipoTransaccion
					 )
</cfquery>
<!---Validacion de MONTOS--->
<cfquery datasource="#session.dsn#">
	update #table_name#
	 set Monto = round(Monto, 2)
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
		select 'Documentos con saldos menores que los importados', Documento
	from #table_name# i
	   inner join EDocumentosCP d
	     on d.CPTcodigo  = i.TipoTransaccion
	    and d.Ddocumento = i.Documento
	where d.Ecodigo = #session.Ecodigo#
	  and abs(i.Monto) > d.EDsaldo
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'Documento con Pago Positivo cuando debe ser Negativo', i.Documento
	  from #table_name# i
	   inner join CPTransacciones tt
	    on tt.CPTcodigo = i.TipoTransaccion
	where tt.Ecodigo = #session.Ecodigo#
	and tt.CPTtipo = 'D'
	and i.Monto > 0
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select ' Documento con Pago Negativo cuando debe ser Positivo', i.Documento
	  from #table_name# i
	   inner join CPTransacciones tt
	    on tt.CPTcodigo = i.TipoTransaccion
	where tt.Ecodigo = #session.Ecodigo#
	and tt.CPTtipo = 'C'
    and i.Monto < 0
</cfquery>
<cfquery name="monto" datasource="#session.dsn#">
	 select sum(Monto) as valor from  #table_name#
</cfquery>
<cfif monto.valor NEQ 0.00>
	<cfquery datasource="#session.dsn#">
		insert into #TableErr#(Error)
		 select 'Los documentos no estan balanceados' 
		  from  dual
	</cfquery>
</cfif>
<!---Validacion de Transacciones de Neteo--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error)
	select 'No está definida la Transacción de Neteo.'
	  from dual
	 where (select count(1)
				from CCTransacciones
			   where Ecodigo = #session.Ecodigo#
				 and CCTtranneteo = 1
			  ) = 0
</cfquery>
<cfquery name="Errores" datasource="#session.dsn#">
	select count(1) as cantidad 
	  from #TableErr#
</cfquery>
<cfif Errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.dsn#">
		select Error, Valor
		  from #TableErr#
	</cfquery>	
<cfelse>
	<cftransaction>
	         <cfquery name="Moneda" datasource="#session.dsn#">  
			  	 select min(Moneda) as valor from #table_name#
			 </cfquery>
			  <cfquery name="Socio" datasource="#session.dsn#">  
			  	 select min(Socio) as valor from #table_name#
			 </cfquery>
             <cfquery name="selectENeteoCxC" datasource="#session.dsn#">
			 	select 
				  
				      (select m.Mcodigo
						from Monedas m
						where Ecodigo = #session.Ecodigo#
						  and Miso4217 = '#Moneda.valor#'
					   ) as Mcodigo,   
					   
					   (select CCTcodigo
					      from CCTransacciones
        	            where Ecodigo = #session.Ecodigo#
               	         and CCTtranneteo = 1
						) as CCTcodigo, 
						
					   'Neteo: ' #_Cat# <cf_dbfunction name="to_sdateDMY"	args="#hoy#"> as DocumentoNeteo,
						1 as TipoNeteo, 
						
						(select  SNcodigo
						   from SNegocios
						 where Ecodigo = #session.Ecodigo#
						   and SNnumero = '#Socio.valor#'
						 ) as SNcodigo,  
						         
						0.00 as Dmonto,               
						#hoy# as Dfechadoc,       
						'Aplicacion de Pagos ' #_Cat# <cf_dbfunction name="to_sdateDMY"	args="#hoy#"> as Observaciones,
						0 as Aplicado, 
						
						(select min(Ocodigo)
							from Oficinas
						  where Ecodigo = #session.Ecodigo#
						 ) as Ocodigo
						 
				from dual
			 </cfquery>
             <cfquery name="ENeteoCxC" datasource="#session.dsn#">  	         
                  insert into DocumentoNeteo (
						Ecodigo,        
						Mcodigo,            
						CCTcodigo,     
						DocumentoNeteo,
						TipoNeteo,      
						SNcodigo,          
						Dmonto,          
						BMUsucodigo,
						Dfechadoc,      
						Observaciones,  
						Aplicado, 
						Ocodigo)
					VALUES(
						   #session.Ecodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#selectENeteoCxC.Mcodigo#"          voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#selectENeteoCxC.CCTcodigo#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#selectENeteoCxC.DocumentoNeteo#"   voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectENeteoCxC.TipoNeteo#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectENeteoCxC.SNcodigo#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#selectENeteoCxC.Dmonto#"           voidNull>,
						   #session.Usucodigo#,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#selectENeteoCxC.Dfechadoc#"        voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#selectENeteoCxC.Observaciones#"    voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_bit"               value="#selectENeteoCxC.Aplicado#"         voidNull>,
						   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#selectENeteoCxC.Ocodigo#"          voidNull>
					)	
				   <cf_dbidentity1 datasource="#session.DSN#">
              </cfquery>   
			  			
				<cf_dbidentity2 datasource="#session.DSN#" name="ENeteoCxP">
				<cfset id = ENeteoCxP.identity> 
				 
                 <cfquery name="aa" datasource="#session.dsn#">  	          
                       insert into DocumentoNeteoDCxP (
					   			idDocumentoNeteo,       
								idDocumento,  
								CPTcodigo,      
								Ddocumento,
                                Dmonto,                 
								BMUsucodigo,    
								Referencia)
					    select #id#,                     
						       d.IDdocumento, 
							   TipoTransaccion, 
							   Documento,
                               abs(round(Monto, 2)),   
							   #session.usucodigo#,     
							   null
                        from #table_name# t
						  inner join EDocumentosCP d
						    on d.CPTcodigo  = t.TipoTransaccion
						   and d.Ddocumento = t.Documento
						where d.Ecodigo    = #session.Ecodigo#
                  </cfquery>    
	</cftransaction>
</cfif>
