<!---
CRUDO:Importador de Compras de Producto en Transito
09 de Febrero del 2009
--->
<cf_dbtemp name="TempImpTracxp_v1" returnvariable="TableErr" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
	 <cf_dbtempcol name="Valor"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="now"	    returnvariable="hoy">
<cfset CPTcodigo= 'NR'>
<cfquery name="Icodigo" datasource="#session.dsn#">
	select Pvalor as valor
	   from Parametros 
	where Ecodigo = #session.Ecodigo#  
	and Pcodigo = 470
</cfquery>
<cfquery name="Impuesto" datasource="#session.dsn#">
	select min(Icodigo) as valor  
 		from Impuestos 
 	where Ecodigo = #session.Ecodigo# 
</cfquery>
<cfquery name="CFid" datasource="#session.dsn#">
	select min(CFid) as valor
		from CFuncional 
	where Ecodigo = #session.Ecodigo# 
</cfquery>
<cfquery name="Almacen" datasource="#session.dsn#">
	select min(Aid) as Aid,
	       min(Dcodigo) as Dcodigo 
	from Almacen
	where Ecodigo = #session.Ecodigo# 
</cfquery>
<cfquery name="Ccuentatransito" datasource="#session.dsn#">
	select min (b.IACtransito) as valor
	from  Existencias a
	 inner join IAContables b
	   on b.Ecodigo   = a.Ecodigo
	  and b.IACcodigo = a.IACcodigo
	where a.Ecodigo   = #session.Ecodigo# 
	  and b.IACtransito is not null
</cfquery>
<cfquery name="Ocodigo" datasource="#session.dsn#">
	select min(Ocodigo) as valor 
		from Oficinas 
	where Ecodigo = #session.Ecodigo# 
</cfquery>
<cfquery name="Mcodigo" datasource="#session.dsn#">
	select Mcodigo as valor 
		from Empresas 
	where Ecodigo = #session.Ecodigo# 
</cfquery>
<!---Validar que existan los Proveedores--->
<cfquery datasource="#session.dsn#">
  insert into #TableErr#(Error, Valor)
  select distinct 'El Proveedor indicado no existe en el Catálogo de Socios de Negocios.' as Error, a.SNnumero as Proveedor
   from #table_name# a
  where not exists(select 1
					  from SNegocios b
				   where b.Ecodigo  = #session.Ecodigo# 
				     and b.SNnumero = a.SNnumero)
</cfquery>
<!---Chequear existencia de artículo--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
	select distinct 'Artículo no Existe o no tiene existencias' as Error, a.Acodigo as Artículo
		from #table_name# a
	where not exists(select 1 
	                   from Articulos b
					     inner join Existencias e
						   on b.Aid = e.Aid
						where b.Ecodigo = #session.Ecodigo# 
						  and e.Alm_Aid  = #Almacen.Aid#
						  and a.Acodigo= b.Acodigo
					  )
</cfquery>
<!---Chequear llave alterna duplicada---> 
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error, Valor)
	  select distinct 'Intento de insertar registro duplicado en EDocumentosCxP con el Documento ', t.documento
	    from #table_name# t
		  inner join SNegocios sn
		    on t.SNnumero = sn.SNnumero
	  where exists(select 1 
	  				from EDocumentosCxP 
					where Ecodigo = #session.Ecodigo#   
					  and CPTcodigo = '#CPTcodigo#'  
					  and SNcodigo = sn.SNcodigo
					  and EDdocumento = t.documento)
		and sn.Ecodigo = #session.Ecodigo# 
</cfquery>
<!---Validacion de la TRANSACCION--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'La Transaccion no Existe', CPTcodigo
	from #table_name#
	where not exists(select 1 
	                  from CPTransacciones tt
					where tt.Ecodigo = #session.Ecodigo#
					  and tt.CPTcodigo = #table_name#.CPTcodigo
					 )
</cfquery>
<!---Validacion deL DOCUMENTO--->
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'Ya existe un documento aplicado en el histórico con ese mismo número de documento', documento
	 from #table_name# 
	where exists(select 1
			       from SNegocios s
					  inner join EDocumentosCP d
						 on d.SNcodigo   = s.SNcodigo
						and d.Ecodigo    = s.Ecodigo
					where s.Ecodigo    = #session.Ecodigo#
					  and s.SNnumero   = #table_name#.SNnumero
					  and d.CPTcodigo  = #table_name#.CPTcodigo
					  and d.Ddocumento = #table_name#.documento
					  )
</cfquery>
<cfquery datasource="#session.dsn#">
	insert into #TableErr#(Error,Valor)
	select 'Ya existe un documento pendiente de aplica con ese mismo número de documento', documento
	 from #table_name# 
	where exists(select 1
			       from SNegocios s
					  inner join EDocumentosCxP d
						 on d.SNcodigo   = s.SNcodigo
						and d.Ecodigo    = s.Ecodigo
					where s.Ecodigo    = #session.Ecodigo#
					  and s.SNnumero   = #table_name#.SNnumero
					  and d.CPTcodigo  = #table_name#.CPTcodigo
					  and d.EDdocumento = #table_name#.documento
					  )
</cfquery>
<cfquery name="Errores" datasource="#session.dsn#">
	select count(1) as cantidad from #TableErr#
</cfquery>
<cfif Errores.cantidad GT 0>
	<cfquery name="ERR" datasource="#session.dsn#">
		select Error,Valor from #TableErr#
	</cfquery>
<cfelse>
	<cftransaction>
		<!---Encabezado de la Factura de CxP--->
		<cfquery datasource="#session.dsn#">
			insert into EDocumentosCxP
				(Ecodigo, CPTcodigo, SNcodigo, Icodigo,Ocodigo, 
				 Ccuenta,  EDtipocambio, EDimpuesto, EDporcdescuento, 
				 EDdescuento, EDtotal, EDfecha, EDusuario, EDdocumento, 
				 Mcodigo,EDfechaarribo )
			select  distinct #session.Ecodigo# , a.CPTcodigo , b.SNcodigo , '#Icodigo.valor#',  
				  #Ocodigo.valor#, b.SNcuentacxp , 1, 0 ,  0 ,0 , 0, #hoy#, '#session.usulogin#' , a.documento, #Mcodigo.valor#, #hoy# 
				from #table_name# a
				 inner join SNegocios b
				   on b.SNnumero = a.SNnumero
				where b.Ecodigo = #session.Ecodigo# 
		</cfquery>
		<!---Detalle de la Factura--->
		<cfquery datasource="#session.dsn#">
			insert into DDocumentosCxP
				(IDdocumento,  Aid,  Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta,
				 DDdescalterna, DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, DDtransito, 
				 DDembarque, DDfembarque, DDobservaciones, DDdescripcion,Icodigo,Ucodigo,CFid )
			select 
				  e.IDdocumento, art.Aid, null, #Almacen.Aid#, #session.Ecodigo# , #Almacen.Dcodigo#, #Ccuentatransito.valor# ,  
				  t.nombredelbarco, round(<cf_dbfunction name="to_number" args="t.cantidad">,2), round(<cf_dbfunction name="to_number" args="t.preciounitario">, 2) as preciounitario, 0, 0, 0,'A',1, 
				  t.codembarque, #hoy#,  t.nombredelbarco #_Cat# ' ' #_Cat# t.state #_Cat# ' ' #_Cat# t.days, 'Prueba PMI','#Impuesto.valor#',
				   art.Ucodigo,#CFid.valor#
				   
				from EDocumentosCxP e
				 inner join #table_name# t
					  on e.CPTcodigo = t.CPTcodigo
					 and rtrim(e.EDdocumento) = rtrim(t.documento)
				 left join Articulos art
					  on art.Acodigo = t.Acodigo
				 inner join SNegocios sn
					 on sn.SNcodigo = e.SNcodigo
					and sn.Ecodigo  = e.Ecodigo
					and sn.SNnumero = t.SNnumero
				where e.Ecodigo     = #session.Ecodigo# 
				   and art.Ecodigo  = #session.Ecodigo# 
		</cfquery>
		<!---Determina la cuenta para los artículos en Tránsito--->
		<cfquery datasource="#session.dsn#">
			update DDocumentosCxP
			set Ccuenta =Coalesce((select iac.IACtransito
									from Existencias exi
										inner join IAContables iac
										   on iac.IACcodigo = exi.IACcodigo
										  and iac.Ecodigo = exi.Ecodigo
									where exi.Aid = DDocumentosCxP.Aid
									   and exi.Alm_Aid = DDocumentosCxP.Alm_Aid), 0)
			where Exists(select 1
						   from EDocumentosCxP e
						  where e.CPTcodigo = '#CPTcodigo#'
							and e.Ecodigo = #session.Ecodigo# 
							and e.EDdocumento in (select  distinct documento from #table_name#)
							and e.IDdocumento = DDocumentosCxP.IDdocumento
						   )
			  and DDtipo = 'A'
		</cfquery>
		<!---Actualiza el total de la cada línea--->
		<cfquery datasource="#session.dsn#">
			update DDocumentosCxP
				set DDtotallinea = DDcantidad * DDpreciou - DDdesclinea
			where Exists(select 1
						  from EDocumentosCxP e
						 where e.Ecodigo = #session.Ecodigo# 
						   and e.EDdocumento in (select  distinct documento from #table_name#)
						   and DDocumentosCxP.IDdocumento = e.IDdocumento
						   )
			   and DDtipo = 'A'
		</cfquery>
		<!---Actualiza el total del encabezado--->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxP 
			set EDtotal = Coalesce((select sum(b.DDtotallinea) 
									   from DDocumentosCxP b
									where b.IDdocumento  =  EDocumentosCxP.IDdocumento), 0.00)
			where Exists(select 1
						   from #table_name# t2
							  inner join SNegocios sn
								 on t2.SNnumero = sn.SNnumero
						  where EDocumentosCxP.EDdocumento = t2.documento  
							and EDocumentosCxP.CPTcodigo   = t2.CPTcodigo
							and EDocumentosCxP.SNcodigo    = sn.SNcodigo
							and EDocumentosCxP.Ecodigo     = #session.Ecodigo# 
							and sn.Ecodigo                 = #session.Ecodigo# 
				         )
		 </cfquery>
		<!---Actualiza la descripción con la del artículo--->
		<cfquery datasource="#session.dsn#">
			 update DDocumentosCxP 
				set DDdescripcion = (select min(art.Adescripcion) 
				                       from Articulos art 
									 where art.Aid = DDocumentosCxP.Aid 
									   and art.Ecodigo= DDocumentosCxP.Ecodigo)
			 where exists(select 1
							from EDocumentosCxP a			
							  inner join Articulos art
								 on art.Ecodigo  = a.Ecodigo 
							 where a.IDdocumento = DDocumentosCxP.IDdocumento 
							   and a.CPTcodigo   = '#CPTcodigo#'
							   and a.Ecodigo     = #session.Ecodigo# 
							   and a.EDdocumento in (select distinct documento from #table_name#)   
							   and art.Aid = DDocumentosCxP.Aid 
						  )
			   and DDtipo  = 'A'
		</cfquery>
	</cftransaction>
</cfif>
