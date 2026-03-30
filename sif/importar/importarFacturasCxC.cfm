<!---
Importador de Facturas de CxC
09 de Febrero del 2009
--->
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cf_dbfunction name="length" args="DocumentDate" 	 returnvariable="LenDocumentDate">
<!---********  Formatea la fecha cuando se importa en formato MM/DD/YYYY ***********--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 1,2" returnvariable="MM">   <!---*  MM/_ _/ _ _ _ _  *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 4,2" returnvariable="DD">   <!---*  _ _/DD/ _ _ _ _  *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 7,4" returnvariable="YYYY"> <!---*  _ _/_ _/YYYY     *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 3,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="DocumentDate, 6,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
	  set DocumentDate = <cf_dbfunction name="concat"	args="#DD# | '/' | #MM# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1#     ='/' 
	  and #Slash2#     = '/' 
	  and #LenDocumentDate# = 10
</cfquery>

<!---********  Formatea la fecha cuando se importa en formato M/DD/YYYY  ***********--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 6,4" returnvariable="YYYY">  <!---*  _/_ _/YYYY       *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 1,1" returnvariable="M">     <!---*  M/_ _/_ _ _ _    *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 3,2" returnvariable="DD">	 <!---*  _/DD/_ _ _ _     *--->	
<cf_dbfunction name="sPart"	 args="DocumentDate, 2,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="DocumentDate, 5,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
		set DocumentDate = <cf_dbfunction name="concat"	args="#DD#| '/' | '0' | #M# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1# ='/' 
	  and #Slash2# = '/'
	  and #LenDocumentDate# = 9
</cfquery>

<!---Formatea la fecha cuando se importa en formato MM/D/YYYY--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 6,4" returnvariable="YYYY">  <!---*  _ _/_ /YYYY       *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 1,2" returnvariable="MM">    <!---*  MM/ _ / _ _ _ _   *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 4,1" returnvariable="D">     <!---*  _ _/ D / _ _ _ _   *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 3,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="DocumentDate, 5,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
		set DocumentDate = <cf_dbfunction name="concat"	args="'0'|#D# | '/' | #MM# | '/' | #YYYY#" delimiters="|"> 
	where #Slash1#='/' 
	and #Slash2# = '/' 
	and #LenDocumentDate# = 9
</cfquery>

<!---Formatea la fecha cuando se importa en formato M/D/YYYY--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 5,4" returnvariable="YYYY">  <!---*  _/ _/YYYY    *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 1,1" returnvariable="M">     <!---*  M/ _/_ _ _ _ *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 3,1" returnvariable="D">	 <!---*  _/ D/_ _ _ _ *--->
<cf_dbfunction name="sPart"	 args="DocumentDate, 2,1" returnvariable="Slash1">
<cf_dbfunction name="sPart"	 args="DocumentDate, 4,1" returnvariable="Slash2">
<cfquery datasource="#session.dsn#">
	update #table_name#
	set DocumentDate = <cf_dbfunction name="concat"	args="'0' | #D# | '0' | #M# | #YYYY#" delimiters="|"> 
	where #Slash1#='/' 
	and #Slash2# = '/' 
	and #LenDocumentDate# = 8
</cfquery>

<!---Actualiza las cantidades en nulo o vacío con cero--->
<cfquery datasource="#session.dsn#">
	update #table_name# 
		set QtyBBL = Coalesce(QtyBBL, '0')
</cfquery>

<cfquery datasource="#session.dsn#">
	update #table_name# 
		set QtyBBL = case when Coalesce(rtrim(QtyBBL),'') = '' then '0' else QtyBBL end
</cfquery>

<!---Actualiza los montos negativos de QtyBBL que vienen de la forma (#)--->
<cf_dbfunction name="length"	args="QtyBBL"                   returnvariable="LenQtyBBL">
<cf_dbfunction name="sPart"		args="QtyBBL| 2 | (#LenQtyBBL#)-2" returnvariable="SoloQtyBBL" delimiters="|">
<cfquery datasource="#session.dsn#">
	update #table_name# 
	   set QtyBBL = <cf_dbfunction name="concat" args="'-' | #PreserveSingleQuotes(SoloQtyBBL)#" delimiters="|">
	where QtyBBL like '(%)'
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
<cfif SNcodigo.recordcount EQ 0 or len(SNcodigo.valor) EQ 0>
	<cf_errorCode	code = "50384" msg = "El socio de Negocios de Importación no esta definido">
</cfif>

<!---Codigo Impuesto para Importacion--->
<cfquery name="Icodigo" datasource="#session.dsn#">
	select Pvalor as valor 
	   from Parametros 
	where Ecodigo = #session.Ecodigo# 
	and Pcodigo = 470
</cfquery>
<cfif Icodigo.recordcount EQ 0 or len(Icodigo.valor) EQ 0>
	<cf_errorCode	code = "50385" msg = "El codigo de impuesto para la importación no esta definido">
</cfif>

<!---Minimo codigo de Almacen--->
<cfquery name="Alm_Aid" datasource="#session.dsn#">
	select min(Aid) as valor 
	   from Almacen 
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
</cfquery>
<cfif id_direccion.recordcount EQ 0 or len(id_direccion.valor) EQ 0>
	<cf_errorCode	code = "50386" msg = "La direccion del socio de Negocios para la importacion no esta definido">
</cfif>

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

<!---Verif. llave alterna duplicada-Doc sin Aplicar--->
<cfquery name="check2" datasource="#session.dsn#">
	select count(1) as valor
	from #table_name# t
	where ( select count(1) 
	          from EDocumentosCxC 
	       where Ecodigo = #session.Ecodigo#  
	         and CCTcodigo = t.TrnType
	         and SNcodigo = #SNcodigo.valor#  
	         and rtrim(EDdocumento) = rtrim(t.DocumentNo)
		   ) > 0
</cfquery>

<!---Verif. llave alterna duplicada-Doc Aplicados--->
<cfquery name="check3" datasource="#session.dsn#">
	select count(1) as valor
	 from #table_name# t
	where (select count(1) 
	         from Documentos 
	      where Ecodigo = #session.Ecodigo#  
	        and CCTcodigo = t.TrnType
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

<!---Verif. la existencia del codigo de transaccion de CxC--->
<cfquery name="check5" datasource="#session.dsn#">
	select count(1) as valor
	 from #table_name# t
	where (select count(1) 
	        from CCTransacciones b
	       where b.Ecodigo = #session.Ecodigo#
		   and b.CCTcodigo = t.TrnType
		   ) < 1 
</cfquery>

<!---Verif. correctitud de signo de documentos--->
<cfquery name="check6" datasource="#session.dsn#">
	select count(1) as valor
	from #table_name# t
		inner join CCTransacciones b
			on b.CCTcodigo = t.TrnType
	where b.Ecodigo   = #session.Ecodigo#
	  and ((round(<cf_dbfunction name="to_number" args="t.Amount">,2)  >= 0.00 and b.CCTtipo = 'C') 
	   or  (round(<cf_dbfunction name="to_number" args="t.Amount">,2)  <  0.00 and b.CCTtipo = 'D'))
</cfquery>
<!---Si no hay errores procesa el Archivo--->
<cfif  (#check1.valor# + #check2.valor# + #check3.valor#  + #check4.valor# + #check5.valor# + #check6.valor#) EQ 0>
	<!---Empresa--->
	<cfquery name="Mcodigo" datasource="#session.dsn#">
		select Mcodigo as valor, Edescripcion 
			from Empresas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<!---Oficina--->
	<cfquery name="Ocodigo" datasource="#session.dsn#">
		select min(Ocodigo) as valor 
			from Oficinas 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif Ocodigo.recordcount EQ 0 or len(Ocodigo.valor) EQ 0>>
		<cf_errorCode	code = "50387"
						msg  = "No existen Oficinas en la empresa @errorDat_1@"
						errorDat_1="#Mcodigo.Edescripcion#"
		>
	</cfif>
	<!---departamento--->
	<cfquery name="Dcodigo" datasource="#session.dsn#">
		select min(Dcodigo) as valor 
			from Departamentos 
		where Ecodigo = #session.Ecodigo#
	</cfquery>
	<cfif Dcodigo.recordcount EQ 0 or len(Dcodigo.valor) EQ 0>
		<cf_errorCode	code = "50388"
						msg  = "No existen Departamentos en la empresa @errorDat_1@"
						errorDat_1="#Mcodigo.Edescripcion#"
		>
	</cfif>
	<!---Conceptos--->
	<cfquery name="Cid" datasource="#session.dsn#">
		select min(Cid) as valor 
			from Conceptos 
		where Ecodigo = #session.Ecodigo# 
		and Ctipo = 'G'
	</cfquery>
	<cfif Cid.recordcount EQ 0 or len(Cid.valor) EQ 0>>
		<cf_errorCode	code = "50389"
						msg  = "No existen Conceptos en la empresa @errorDat_1@"
						errorDat_1="#Mcodigo.Edescripcion#"
		>
	</cfif>
	<!---Cuenta CxC--->
	<cfquery name="SNcuentacxc" datasource="#session.dsn#">
		select SNcuentacxc as valor,  SNnombre 
			from SNegocios 
		where Ecodigo = #session.Ecodigo# 
		and SNcodigo = #SNcodigo.valor#
	</cfquery>
	<cfif SNcuentacxc.recordcount EQ 0 or len(SNcuentacxc.valor) EQ 0>
		<cf_errorCode	code = "50390"
						msg  = "El socio de Negocios para la importacion @errorDat_1@ no tienen cuenta de CxC definida"
						errorDat_1="#SNcuentacxc.SNnombre#"
		>
	</cfif>
	<cfquery name="CuentaConcepto" datasource="#session.dsn#">
		select min(IACgastoajuste) as valor 
			from IAContables 
		where Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfquery name="DBG" datasource="#session.dsn#">
		select distinct
					#session.Ecodigo#, rtrim(ltrim(t.TrnType)), rtrim(ltrim(t.DocumentNo)), #Mcodigo.valor#, 
					#SNcodigo.valor#, '#Icodigo.valor#', #Ocodigo.valor#, #SNcuentacxc.valor#, 
					1.00, 0.00, 0.00, 0.00, 0.00, 
					<cf_dbfunction name="now">, '#session.usulogin#', 0,#id_direccion.valor#,#id_direccion.valor#
				from #table_name# t	
	</cfquery>
	<cftransaction>
		<!---Inserta el Encabezado--->
		<cfquery datasource="#session.dsn#">
			insert into EDocumentosCxC (
				Ecodigo, CCTcodigo, EDdocumento, Mcodigo, 
				SNcodigo, Icodigo, Ocodigo, Ccuenta, 
				EDtipocambio, EDimpuesto, EDporcdesc, EDdescuento, EDtotal, 
				EDfecha, EDusuario, EDselect,id_direccionFact,id_direccionEnvio
			)
			select distinct
				#session.Ecodigo#, rtrim(ltrim(t.TrnType)), rtrim(ltrim(t.DocumentNo)), #Mcodigo.valor#, 
				#SNcodigo.valor#, '#Icodigo.valor#', #Ocodigo.valor#, #SNcuentacxc.valor#, 
				1.00, 0.00, 0.00, 0.00, 0.00, 
				<cf_dbfunction name="now">, '#session.usulogin#', 0,#id_direccion.valor#,#id_direccion.valor#
			from #table_name# t	
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxC
				set EDfecha = (select <cf_dbfunction name="to_date"	args="min(tr.DocumentDate)">
								from #table_name# tr
							   where rtrim(ltrim(tr.DocumentNo)) = EDocumentosCxC.EDdocumento
			                     and rtrim(ltrim(tr.TrnType))    = EDocumentosCxC.CCTcodigo)
			where Ecodigo = #session.Ecodigo#
			  and exists( select 1
						    from #table_name# t
						  where rtrim(ltrim(t.TrnType))    = EDocumentosCxC.CCTcodigo
						    and rtrim(ltrim(t.DocumentNo)) = EDocumentosCxC.EDdocumento)
		</cfquery>

		<!---Inserta el detalle de la Factura--->
		<cfquery datasource="#session.dsn#">
			insert into DDocumentosCxC (
				EDid, 
				Aid, 
				Cid, 
				Alm_Aid, 
				Dcodigo, 
				Ccuenta, 
				DDdescripcion, 
				DDdescalterna, 
				DDcantidad, 
				DDpreciou, 
				DDdesclinea, DDporcdesclin, 
				DDtotallinea, 
				DDtipo,
				Ecodigo)
			select 
				e.EDid, 
				art.Aid as Articulo, 
				case when t.Material is not null then #Cid.valor# else null end as Concepto, 
				case when t.Material is not null then #Alm_Aid.valor# else null end as Almacen, 	
				#Dcodigo.valor# as Depto,
				#CuentaConcepto.valor# as Cuenta, 
				coalesce(art.Adescripcion, 'Ajuste') as DDdescripcion, 
				coalesce(art.Adescripcion, 'Ajuste de Ventas') as DDdescalterna, 	
				case when rtrim(t.Material) != '' then abs(<cf_dbfunction name="to_float" args="t.QtyBBL">) else 1 end as DDcantidad, 
				abs(round(<cf_dbfunction name="to_number" args="t.Amount">,2)) / case when <cf_dbfunction name="to_float" args="t.QtyBBL"> != 0 then coalesce(abs(<cf_dbfunction name="to_float" args="t.QtyBBL">),1) else 1 end as DDpreciou, 
				0.00, 0.00, 
				abs(round(<cf_dbfunction name="to_number" args="t.Amount">,2)) as DDtotallinea, 
				case when rtrim(t.Material) != '' then 'A' else 'S' end as DDtipo,
				e.Ecodigo
			from #table_name# t
			  inner join EDocumentosCxC e
				 on e.EDdocumento = rtrim(ltrim(t.DocumentNo))
			    and e.CCTcodigo   = rtrim(ltrim(t.TrnType))
			  left join Articulos art
				on rtrim(ltrim(t.Material))= art.Acodigo
			where e.EDdocumento = rtrim(ltrim(t.DocumentNo))
			  and e.Ecodigo   = #session.Ecodigo#
			  and art.Ecodigo = #session.Ecodigo#
		</cfquery>
		<!---Actualiza el total de documento. Suma de Lineas--->
  		<cfquery datasource="#session.dsn#">
			update EDocumentosCxC
			 set EDtotal = coalesce(( select sum(d.DDtotallinea)
										from DDocumentosCxC d
									  where d.EDid = EDocumentosCxC.EDid), 0.00)
			where Ecodigo = #session.Ecodigo#
			  and exists( select 1
							from #table_name# t
						  where t.TrnType    = EDocumentosCxC.CCTcodigo
						and t.DocumentNo = EDocumentosCxC.EDdocumento)
		</cfquery>
		<!---Actualiza el total de documento. Impuesto--->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxC
				set EDimpuesto = EDtotal * coalesce(( select i.Iporcentaje / 100.00
														from Impuestos i
														where i.Ecodigo = EDocumentosCxC.Ecodigo
														and   i.Icodigo = EDocumentosCxC.Icodigo), 0.00)
			where Ecodigo = #session.Ecodigo#
		 	   and EDtotal != 0.00
		       and exists(select 1
							from #table_name# t
						  where t.TrnType    = EDocumentosCxC.CCTcodigo
							and t.DocumentNo = EDocumentosCxC.EDdocumento)
		</cfquery>
		<!---Actualiza el total de documento--->
		<cfquery datasource="#session.dsn#">
			update EDocumentosCxC
				set EDtotal = EDtotal + EDimpuesto
				where Ecodigo = #session.Ecodigo#
				  and EDtotal != 0.00
				  and exists(select 1
							from #table_name# t
							where t.TrnType    = EDocumentosCxC.CCTcodigo
							  and t.DocumentNo = EDocumentosCxC.EDdocumento)
		</cfquery>
		<!---Actualiza la cuenta de Inventario para los articulos--->
		<cfquery datasource="#session.dsn#">
			update DDocumentosCxC
			set Ccuenta = coalesce((select iac.IACingventa
									from Existencias exi
									 inner join IAContables iac
									    on iac.IACcodigo = exi.IACcodigo
									   and iac.Ecodigo   = exi.Ecodigo
									where exi.Aid     = DDocumentosCxC.Aid
									  and exi.Alm_Aid = DDocumentosCxC.Alm_Aid
									  ), 0)
			where (select count(1) 
					from #table_name# t
					 inner join EDocumentosCxC e
						on e.CCTcodigo = t.TrnType
					   and e.EDdocumento = t.DocumentNo
					where e.Ecodigo = #session.Ecodigo#
					  and e.SNcodigo = #SNcodigo.valor#
					  and DDocumentosCxC.EDid = e.EDid
				  ) > 0
		</cfquery>
	</cftransaction>
<cfelse>
	<cfquery name="ERR"  datasource="#session.dsn#">
		select distinct '1. Artículo no Existe o no tiene Existencias' as Error, t.Material as Item
			from #table_name# t
		where #check1.valor# > 0
		and not exists(select 1
			            from Articulos b
						  inner join Existencias e
						     on b.Aid = e.Aid
						where rtrim(t.Material) = rtrim(b.Acodigo)
						and b.Ecodigo = #session.Ecodigo#
						and e.Alm_Aid  = #Alm_Aid.valor#)
	union all
		select distinct '2. Documento Duplicado en Documentos en Proceso' as Error, rtrim(t.TrnType) #_Cat# '-' #_Cat# t.DocumentNo as Item
		from #table_name# t
		where #check2.valor# > 0
		and exists(select 1 
						from EDocumentosCxC 
					where Ecodigo = #session.Ecodigo# 
					  and CCTcodigo = t.TrnType  
					  and EDdocumento = t.DocumentNo)
	union all
		select distinct '3. Documento Duplicado en Documentos Historicos' as Error, rtrim(t.TrnType) #_Cat# '-' #_Cat# t.DocumentNo as Item
		from #table_name# t
		where #check3.valor# > 0
		and exists(select 1 from Documentos
			where Ecodigo = #session.Ecodigo#   
			  and CCTcodigo = t.TrnType  
			  and Ddocumento = t.DocumentNo)
	union all
		select '4. No Existe Socio de Negocios definido ' as Error, ' ' as Item
		from #table_name# t
		where #check4.valor# > 0
	union all
		select distinct '5. No Existe el codigo de transaccion. ' as Error, TrnType as Item
		from #table_name# t
		where #check5.valor# > 0
		  and not exists (select 1 from CCTransacciones b where b.Ecodigo = #session.Ecodigo#  and b.CCTcodigo = t.TrnType)
	union all
		select distinct '6. Documento con Transaccion Incorrecta. ' as Error, rtrim(t.TrnType) #_Cat# '-' #_Cat# t.DocumentNo as Item
		from #table_name# t, CCTransacciones b
		where #check6.valor# > 0
		  and b.Ecodigo   = #session.Ecodigo# 
		  and b.CCTcodigo = t.TrnType
		  and ((round(<cf_dbfunction name="to_number" args="t.Amount">, 2) >= 0.00 and b.CCTtipo = 'C') 
		  or   (round(<cf_dbfunction name="to_number" args="t.Amount">, 2) < 0.00 and b.CCTtipo = 'D'))
	</cfquery>
</cfif>

