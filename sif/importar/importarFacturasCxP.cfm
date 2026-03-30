<!---
Importador de Facturas de CxP
06 de Febrero del 2009
--->
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="length" args="BOLDate" 	 returnvariable="LenBOLDate">
<!---********  Formatea la fecha cuando se importa en formato MM/DD/YYYY ***********--->
<cf_dbfunction name="sPart"	 args="BOLDate, 1,2" returnvariable="MM">   <!---*  MM/_ _/ _ _ _ _  *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 4,2" returnvariable="DD">   <!---*  _ _/DD/ _ _ _ _  *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 7,4" returnvariable="YYYY"> <!---*  _ _/_ _/YYYY     *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 3,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="BOLDate, 6,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
	  set BOLDate = <cf_dbfunction name="concat"	args="#DD# | '/' | #MM# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1#     ='/' 
	  and #Slash2#     = '/' 
	  and #LenBOLDate# = 10
</cfquery>

<!---********  Formatea la fecha cuando se importa en formato M/DD/YYYY  ***********--->
<cf_dbfunction name="sPart"	 args="BOLDate, 6,4" returnvariable="YYYY">  <!---*  _/_ _/YYYY       *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 1,1" returnvariable="M">     <!---*  M/_ _/_ _ _ _    *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 3,2" returnvariable="DD">	 <!---*  _/DD/_ _ _ _     *--->	
<cf_dbfunction name="sPart"	 args="BOLDate, 2,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="BOLDate, 5,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
		set BOLDate = <cf_dbfunction name="concat"	args="#DD#| '/' | '0' | #M# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1# ='/' 
	  and #Slash2# = '/'
	  and #LenBOLDate# = 9
</cfquery>

<!---Formatea la fecha cuando se importa en formato MM/D/YYYY--->
<cf_dbfunction name="sPart"	 args="BOLDate, 6,4" returnvariable="YYYY">  <!---*  _ _/_ /YYYY       *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 1,2" returnvariable="MM">    <!---*  MM/ _ / _ _ _ _   *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 4,1" returnvariable="D">     <!---*  _ _/ D / _ _ _ _   *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 3,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="BOLDate, 5,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
		set BOLDate = <cf_dbfunction name="concat"	args="'0'|#D# | '/' | #MM# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1#='/' 
	and #Slash2# = '/' 
	and #LenBOLDate# = 9
</cfquery>

<!---Formatea la fecha cuando se importa en formato M/D/YYYY--->
<cf_dbfunction name="sPart"	 args="BOLDate, 5,4" returnvariable="YYYY">  <!---*  _/ _/YYYY    *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 1,1" returnvariable="M">     <!---*  M/ _/_ _ _ _ *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 3,1" returnvariable="D">	 <!---*  _/ D/_ _ _ _ *--->
<cf_dbfunction name="sPart"	 args="BOLDate, 2,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="BOLDate, 4,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
	set BOLDate = <cf_dbfunction name="concat"	args="'0' | #D# | '0' | #M# | #YYYY#" delimiters="|"> 
	where #Slash1#='/' 
	and #Slash2# = '/' 
	and #LenBOLDate# = 8
</cfquery>

<!---Actualiza las cantidades en nulo o vacío con cero--->
<cfquery datasource="#session.dsn#">
	update #table_name# 
		set BBLQty = Coalesce(BBLQty, '0')
</cfquery>
<cfquery datasource="#session.dsn#">
	update #table_name# 
		set BBLQty = case when Coalesce(rtrim(BBLQty),'') = '' then '0' else BBLQty end
</cfquery>

<!---Actualiza los montos negativos de BBLQty que vienen de la forma (#)--->
<cf_dbfunction name="length"	args="BBLQty"                   returnvariable="LenBBLQty">
<cf_dbfunction name="sPart"		args="BBLQty| 2 | (#LenBBLQty#)-2" returnvariable="SoloBBLQty" delimiters="|">
<cfquery datasource="#session.dsn#">
	update #table_name# 
	   set BBLQty = <cf_dbfunction name="concat" args="'-' | #PreserveSingleQuotes(SoloBBLQty)#" delimiters="|">
	where BBLQty like '(%)'
</cfquery>

<!---Actualiza los montos negativos de Amount que vienen de la forma (#)--->
<cf_dbfunction name="length"	args="Amount"                 returnvariable="LenAmount">
<cf_dbfunction name="sPart"		args="Amount| 2 | (#LenAmount#)-2" returnvariable="SoloAmount" delimiters="|">
<cfquery datasource="#session.dsn#">
	update #table_name# 
		set Amount = <cf_dbfunction name="concat" args="'-' | #PreserveSingleQuotes(SoloAmount)#" delimiters="|">
	where Amount like '(%)'
</cfquery>

<!---Busca el Socio de Importacion--->
<cfquery name="SNcodigo" datasource="#session.dsn#">
	select Pvalor as valor 
	   from Parametros 
	 where Ecodigo = #session.Ecodigo#
	 and Pcodigo = 450
</cfquery>

<!---Codigo Impuesto para Importacion--->
<cfquery name="Icodigo" datasource="#session.dsn#">
	select Pvalor as valor 
	   from Parametros 
	where Ecodigo = #session.Ecodigo# 
	and Pcodigo = 470
</cfquery>

<!---Minimo codigo de Almacen--->
<cfquery name="Alm_Aid" datasource="#session.dsn#">
	select min(Aid) as valor 
	   from Almacen 
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!---Busca el Impuesto Exento--->
<cfquery name="Impuesto" datasource="#session.dsn#">
	select min(Icodigo) as valor 
		from Impuestos 
	where Ecodigo = #session.Ecodigo# 
	and Iporcentaje = 0
</cfquery>

<!---Minimo Centro Funcional--->
<cfquery name="CFid" datasource="#session.dsn#">
	select min(CFid) as valor 
		from CFuncional 
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!---Minima direccion Direccion del minimo Socio--->
<cfquery name="id_direccion" datasource="#session.dsn#">
	select min(b.id_direccion) as valor
	from SNegocios a
	join SNDirecciones b
	  on a.SNid = b.SNid
	join DireccionesSIF c
	  on c.id_direccion = b.id_direccion
	where a.Ecodigo = #session.Ecodigo#
	  and a.SNcodigo = #SNcodigo.valor#
	  and b.SNDfacturacion = 1 
</cfquery>
<!---Verif. existencia de artículo--->
<cfquery name="check1" datasource="#session.dsn#">
	select count(1) as valor
      from #table_name# t
	where (select count(1) 
	  		 from Articulos b
			   inner join Existencias e
			     on e.Aid = b.Aid
	       where rtrim(t.Material) = rtrim(b.Acodigo)
	         and b.Ecodigo = #session.Ecodigo#
	         and e.Alm_Aid  = #Alm_Aid.valor# 
	       ) < 1
</cfquery>
<!---Verif. llave alterna duplicada - Doc sin Aplicar---->
<cfquery name="check2" datasource="#session.dsn#">
	select count(1) as valor
	from #table_name# t
	where ( select count(1) 
	          from EDocumentosCxP 
	       where Ecodigo = #session.Ecodigo#  
	         and CPTcodigo = t.TrnType
	         and SNcodigo = #SNcodigo.valor#  
	         and rtrim(EDdocumento) = rtrim(t.DocumentNo)
		   ) > 0
</cfquery>
<!---Verif. llave alterna duplicada - Doc Aplicados---->
<cfquery name="check3" datasource="#session.dsn#">
	select count(1) as valor
	 from #table_name# t
	where (select count(1) 
	         from EDocumentosCP 
	      where Ecodigo = #session.Ecodigo#  
	        and CPTcodigo = t.TrnType
	        and SNcodigo = #SNcodigo.valor#  
	        and rtrim(Ddocumento) = rtrim(t.DocumentNo)) > 0
</cfquery>
<!---Verif. la existencia del socio por defecto para la importación--->
<cfquery name="check4" datasource="#session.dsn#">
	select 1 - (select count(1)
	             from SNegocios
	           where Ecodigo = #session.Ecodigo#
	             and SNcodigo = #SNcodigo.valor#) as valor
	from dual
</cfquery>
<!---Verif. la existencia del codigo de transaccion de CxP--->
<cfquery name="check5" datasource="#session.dsn#">
	select count(1) as valor
	 from #table_name# t
	where (select count(1) 
	        from CPTransacciones b
	       where b.Ecodigo = #session.Ecodigo#
		   and b.CPTcodigo = t.TrnType
		   ) < 1 
</cfquery>
<!---Verif. correctitud de signo de documentos--->
<cfquery name="check6" datasource="#session.dsn#">
	select count(1) as valor
	from #table_name# t
		inner join CPTransacciones b
			on b.CPTcodigo = t.TrnType
	where b.Ecodigo   = #session.Ecodigo#
	  and ((round(t.Amount,2)  >= 0.00 and b.CPTtipo = 'D') 
	   or  (round(t.Amount,2)  <  0.00 and b.CPTtipo = 'C'))
</cfquery>

<!---Si no hay errores procesa el Archivo--->
<cfif  (#check1.valor# + #check2.valor# + #check3.valor#  + #check4.valor# + #check5.valor# + #check6.valor#) EQ 0>
	<cfquery name="Mcodigo" datasource="#session.dsn#">
		select Mcodigo as valor 
			from Empresas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="Ocodigo" datasource="#session.dsn#">
		select min(Ocodigo) as valor 
			from Oficinas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="Dcodigo" datasource="#session.dsn#">
		select min(Dcodigo) as valor 
			from Departamentos 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfquery name="Cid" datasource="#session.dsn#">
		select min(Cid) as valor 
			from Conceptos 
		where Ecodigo = #session.Ecodigo# 
		and Ctipo = 'G'
	</cfquery>
	<cfquery name="SNcuentacxp" datasource="#session.dsn#">
		select SNcuentacxp as valor 
			from SNegocios 
		where Ecodigo = #session.Ecodigo# 
		and SNcodigo = #SNcodigo.valor#
	</cfquery>
    <cfif len(trim(SNcuentacxp.valor)) eq 0>
     <cfthrow message="El socio de Importación definido en parámetros no tiene una cuenta asociada">      
    </cfif>
	<cfquery name="CuentaConcepto" datasource="#session.dsn#">
		select min(IACgastoajuste) as valor 
			from IAContables 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cftransaction>
		<!---inserta el Encabezado de la Factura--->
		<cfquery datasource="#session.dsn#">
			insert into EDocumentosCxP (
				Ecodigo, CPTcodigo, EDdocumento, Mcodigo, 
				SNcodigo, Icodigo, Ocodigo, Ccuenta, 
				EDtipocambio, EDimpuesto, EDporcdescuento, EDdescuento, EDtotal, 
				EDfecha, EDusuario, EDselect,EDfechaarribo,id_direccion
			)
			select distinct
				#session.Ecodigo#, t.TrnType, t.DocumentNo, #Mcodigo.valor#, 
				#SNcodigo.valor#, '#Icodigo.valor#', #Ocodigo.valor#, #SNcuentacxp.valor#, 
				1.00, 0.00, 0.00, 0.00, 0.00, 
				<cf_dbfunction name="now">, '#session.usulogin#', 0,
				<cf_dbfunction name="now">,
				#id_direccion.valor#
			from #table_name# t
		</cfquery>
		<!---Actualiza las fechas--->
		<cfquery  datasource="#session.dsn#">
		   update EDocumentosCxP set 
			  EDfecha = (select <cf_dbfunction name="to_date"	args="min(tr.BOLDate)">
		                   from #table_name# tr
		                 where tr.DocumentNo = EDocumentosCxP.EDdocumento
		                   and tr.TrnType    = EDocumentosCxP.CPTcodigo)
           where Ecodigo = #session.Ecodigo#
           and exists(select 1
						from #table_name# t
						where t.TrnType    = EDocumentosCxP.CPTcodigo
						  and t.DocumentNo = EDocumentosCxP.EDdocumento)
		</cfquery>	
		<cfquery  datasource="#session.dsn#">
			update EDocumentosCxP set 
	          EDfechaarribo = EDfecha 
            where Ecodigo =  #session.Ecodigo#
              and exists(select 1
						  from #table_name# t
						where t.TrnType    = EDocumentosCxP.CPTcodigo
						  and t.DocumentNo = EDocumentosCxP.EDdocumento)
		</cfquery>	

		<!---Inserta el detalle de la Factura--->
		<cfquery name="dbg" datasource="#session.dsn#">
			insert into DDocumentosCxP (
				IDdocumento, Aid, Cid, Alm_Aid, 
				Ecodigo, Dcodigo, Ccuenta, DDdescripcion, DDdescalterna, 
				DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, 
				DDtipo, DDtransito, DDembarque, DDfembarque,Icodigo,Ucodigo,CFid)
			
			select 
				e.IDdocumento, 
				art.Aid as Articulo, 
				case when t.Material is null then #Cid.valor# else null end as Concepto, 
				case when t.Material is not null then #Alm_Aid.valor# else null end as Almacen, 	
				#session.Ecodigo# as Empresa, 
				#Dcodigo.valor# as Depto,
				#CuentaConcepto.valor# as CuentaInv, 
				Coalesce(art.Adescripcion, 'Concepto') as DDdescripcion, 
				Coalesce(art.Adescripcion, 'Concepto') as DDdescalterna, 	
				case when len(rtrim(t.Material)) > 0  
					 then abs(<cf_dbfunction name="to_float" args="t.BBLQty">) 
						else 1 end, abs(round(t.Amount,2))/case when <cf_dbfunction name="to_float"	 args="t.BBLQty"> != 0 
					  then Coalesce(abs(<cf_dbfunction name="to_float" args="t.BBLQty">),1) 
						else 1 end, 0.00, 0.00, abs(round(t.Amount,2)) as DDcantidad, 
				case when len(rtrim(t.Material)) > 0  then 'A' else 'S' end as DDpreciou, 0, t.BOLNo, <cf_dbfunction name="to_date"	args="t.BOLDate">,
				'#Impuesto.valor#',
				 art.Ucodigo,
				#CFid.valor#
			from #table_name# t
			  inner join EDocumentosCxP e
				 on e.CPTcodigo = t.TrnType
				and rtrim(e.EDdocumento) = rtrim(t.DocumentNo)
			  left join Articulos art
				on t.Material= art.Acodigo
			where e.Ecodigo = #session.Ecodigo#
			  and art.Ecodigo = #session.Ecodigo#
		</cfquery>
		<!---Actualiza el total en el encabezado--->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxP set
				EDtotal = coalesce((select sum(b.DDtotallinea)
									 from DDocumentosCxP b
									where b.IDdocumento = EDocumentosCxP.IDdocumento), 0.00)
			where Ecodigo = #session.Ecodigo#
			  and SNcodigo = #SNcodigo.valor#
			  and (select count(1) 
					 from #table_name# t
					where t.TrnType = EDocumentosCxP.CPTcodigo
					  and t.DocumentNo = EDocumentosCxP.EDdocumento
				   ) > 0
		</cfquery>
		<!---Actualiza el total del documento. Impuesto--->
		<cfquery  datasource="#session.dsn#">
			update EDocumentosCxP set
				EDimpuesto = EDtotal * coalesce((select i.Iporcentaje / 100.00
												   from Impuestos i
												where i.Ecodigo = EDocumentosCxP.Ecodigo
												and   i.Icodigo = EDocumentosCxP.Icodigo), 0.00)
			where Ecodigo = #session.Ecodigo#
			  and EDtotal != 0.00
			  and SNcodigo = #SNcodigo.valor#
			  and (select count(1)
					from #table_name# t
				   where t.TrnType    = EDocumentosCxP.CPTcodigo
					 and t.DocumentNo = EDocumentosCxP.EDdocumento
				   ) > 0
		</cfquery>
		<!---Suma al Total el Impuesto.--->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxP
			  set EDtotal = EDtotal + EDimpuesto
			where Ecodigo = #session.Ecodigo#
			  and EDtotal != 0.00
			  and SNcodigo = #SNcodigo.valor#
			  and exists(select 1
						   from #table_name# t
						  where t.TrnType    = EDocumentosCxP.CPTcodigo
						    and t.DocumentNo = EDocumentosCxP.EDdocumento)
		</cfquery>
		<!---Determina la cuenta para los artículos de Inventario--->
		<cfquery name="ActCuent" datasource="#session.dsn#">
			select  d.IDdocumento, d.Linea, tr.CPTafectacostoventas 
			from EDocumentosCxP e
			  inner join DDocumentosCxP d
			    on d.IDdocumento = e.IDdocumento
			  inner join CPTransacciones tr
			    on tr.Ecodigo   = e.Ecodigo
			   and tr.CPTcodigo = e.CPTcodigo
			where e.SNcodigo = #SNcodigo.valor#
			  and e.Ecodigo = #session.Ecodigo#
			  and d.DDtipo     = 'A'
			  and exists(select 1
							from #table_name# t
						 where t.TrnType    = e.CPTcodigo
						   and t.DocumentNo = e.EDdocumento)
		</cfquery>
		<cfloop query="ActCuent">
			<cfquery datasource="#session.dsn#">
				update DDocumentosCxP
				  set Ccuenta = Coalesce((select case when #ActCuent.CPTafectacostoventas# = 1 
													  then iac.IACcostoventa 
													  else iac.IACinventario 
												   end
										  from Existencias exi
											  inner join IAContables iac
												 on iac.IACcodigo = exi.IACcodigo
												and iac.Ecodigo   = exi.Ecodigo
										where exi.Aid     = DDocumentosCxP.Aid
										  and exi.Alm_Aid = DDocumentosCxP.Alm_Aid
										   ), 0)
				where IDdocumento = #ActCuent.IDdocumento#
				  and Linea  = #ActCuent.Linea# 
		</cfquery>
		</cfloop>
		
		<!---Asigna la cuenta para los Conceptos--->
		<cfquery datasource="#session.dsn#">
			update DDocumentosCxP
				set Ccuenta = #CuentaConcepto.valor#, 
						Cid = #Cid.valor#
			 where (select count(1)
			          from EDocumentosCxP e
				         inner join DDocumentosCxP d
				           on d.IDdocumento = e.IDdocumento
					 where e.SNcodigo = #SNcodigo.valor#
					  and e.Ecodigo = #session.Ecodigo#
					  and d.DDtipo = 'S'
					  and exists(select 1
								  from #table_name# t
								 where t.TrnType    = e.CPTcodigo
								   and t.DocumentNo = e.EDdocumento)
				    )> 0
		  </cfquery>
	</cftransaction>
	<cfelse>
		<cfquery name="ERR"  datasource="#session.dsn#">
		  select distinct 'Intento de insertar registro duplicado en EDocumentosCP (documentos Aplicados) Tipo: ' #_Cat# t.TrnType #_Cat# ' Numero: ' #_Cat# t.DocumentNo as Error
		  from #table_name# t
		  where exists(select 1 from EDocumentosCP 
					where Ecodigo = #session.Ecodigo#  
					  and CPTcodigo = t.TrnType  
					  and SNcodigo = #SNcodigo.valor#  
					  and Ddocumento = t.DocumentNo )
		
		  union all
		
		  select distinct 'Intento de insertar registro duplicado en EDocumentosCxP Tipo: ' #_Cat# t.TrnType #_Cat# ' Numero: ' #_Cat# t.DocumentNo as Error
		  from #table_name# t
		  where exists(select 1 from EDocumentosCxP 
					where Ecodigo = #session.Ecodigo#  
					  and CPTcodigo = t.TrnType  
					  and SNcodigo = #SNcodigo.valor#  
					  and EDdocumento = t.DocumentNo )
		
		  union all
		
		  select distinct 'Artículo no Existe o no tiene Existencias: ' #_Cat# a.Material as Error
		  from #table_name# a
		  where not exists(
			select 1
			from Articulos b, Existencias e
			where rtrim(a.Material) = rtrim(b.Acodigo)
			  and b.Ecodigo = #session.Ecodigo#
			  and e.Alm_Aid  = #Alm_Aid.valor# 
			  and b.Aid = e.Aid
			  and rtrim(a.Material) != '')
		
		  union all
		
		  select distinct 'Transaccion no es correcta: ' #_Cat# t.TrnType as Error
		  from #table_name# t
		  where not exists(
			 select 1 from CPTransacciones tr
			 where tr.Ecodigo = #session.Ecodigo#
			   and tr.CPTcodigo = t.TrnType)
		
		  union all
		
		  select distinct 'Transaccion Esta Invertida: (Debitos o Creditos)' #_Cat# t.TrnType as Error
		  from #table_name# t, CPTransacciones tr
		  where #check6.valor# > 0
			and tr.Ecodigo = #session.Ecodigo#
			and tr.CPTcodigo = t.TrnType
			and ((round(t.Amount, 2) >= 0.00 and tr.CPTtipo = 'D') or (round(t.Amount,2) < 0.00 and tr.CPTtipo = 'C'))
 </cfquery>
</cfif>
