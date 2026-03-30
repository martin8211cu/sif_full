<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif isdefined("url.fEDRnumeroD") and not isdefined("form.fEDRnumeroD")>
	<cfset form.fEDRnumeroD = Url.fEDRnumeroD>
</cfif>
<cfif isdefined("url.fEDRnumeroH") and not isdefined("form.fEDRnumeroH")>
	<cfset form.fEDRnumeroH = Url.fEDRnumeroH>
</cfif>
<cfif isdefined("url.EOnumero1") and not isdefined("form.EOnumero1")>
	<cfset form.EOnumero1 = Url.EOnumero1>
</cfif>
<cfif isdefined("url.EOnumero2") and not isdefined("form.EOnumero2")>
	<cfset form.EOnumero2 = Url.EOnumero2>
</cfif>
<cfif isdefined("url.fechaD") and not isdefined("form.fechaD")>
	<cfset form.fechaD = Url.fechaD>
</cfif>
<cfif isdefined("url.fechaH") and not isdefined("form.fechaH")>
	<cfset form.fechaH = Url.fechaH>
</cfif>
<cfif isdefined("url.fTDRtipo") and not isdefined("form.fTDRtipo")>
	<cfset form.fTDRtipo = Url.fTDRtipo>
</cfif>
<cfif isdefined("url.Usucodigo") and not isdefined("form.Usucodigo")>
	<cfset form.Usucodigo = Url.Usucodigo>
</cfif>

<cfparam name="consultar_Ecodigo" default="#session.Ecodigo#">

<!---
<cfquery name="qryLista" datasource="#session.dsn#">
	select 	hedr.EDRnumero as NumFactura, 
			hedr.EDRfechadoc, 
			hedr.EDRfecharec, 				
			hedr.EDRreferencia, 
			sn.SNnumero ||'-'|| sn.SNnombre as SNnombre , 			 
			m.Mnombre,
			art.Acodigo,
			art.Adescripcion,			
			alm.Almcodigo, 
			alm.Bdescripcion,
			(case when hedr.CFid is null 	then coalesce(alm.Bdescripcion,'') 
									else coalesce(cf.CFdescripcion,'')
			end ) as CFdescripcion ,
			(case when hedr.CFid is null 	then coalesce(2,null) 
									else coalesce(1,null)
			end ) as tipoCF ,			
			--(case when hddr.Cid is null 	then coalesce(art.Adescripcion,'') 
			--						else coalesce(con.Cdescripcion,'')
			--end ) as DescTipoItem ,
			
			--(case when hddr.Cid is null 	then coalesce(u.Udescripcion,'') 
			--						else 'N/A' 
			--end ) as Umedida,
			--hddr.DDRcantrec ,
			--hddr.DDRcantorigen,
			--coalesce(cfi2.CFformato,'No definido') as formatoI, 		
			coalesce((select sum(hddr1.DDRtotallin) 
				from HDDocumentosRecepcion hddr1 
				where  hddr1.Ecodigo = hddr.Ecodigo
				and hddr1.EDRid = hddr.EDRid
			 ),0) as montoRec,
			 coalesce((select sum(hddr1.DDRdesclinea) 
					from HDDocumentosRecepcion hddr1 
					where  hddr1.Ecodigo = hddr.Ecodigo
					and hddr1.EDRid = hddr.EDRid
			 ),0) as DescLinea,			 
			hedr.CPTcodigo || '-' || cpt.CPTdescripcion as TipoDoc, 			
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,
			hddr.DDRdesclinea, 
			hddr.DDRtotallin,
			hddr.DOlinea,
			hddr.Ucodigo, 
			hddr.Aid, 
			hddr.Cid,
			docm.DOdescripcion,  
			docm.EOnumero,
			docm.DOobservaciones,
			docm.DOalterna,
			docm.DOcantidad, 
			#LvarOBJ_PrecioU.enSQL_AS("docm.DOpreciou")#,	
			docm.DOcantsurtida, 
			docm.DOconsecutivo, 
			er.ERobs,
			er.EDRnumero, 		
			coalesce(dr.DRcantrec,0) as DRcantrec,
			coalesce(coalesce(dr.DRcantrec,0) * coalesce(dr.DRpreciorec,0),0) as MtoReclamo,
			eocm.EOplazo,
			coalesce(impu.Iporcentaje,0) as Iporcentaje, 			
			cfi.CFformato						
		
	from EDocumentosRecepcion hedr
	
			inner join SNegocios sn
				on  hedr.Ecodigo = sn.Ecodigo
				and hedr.SNcodigo = sn.SNcodigo
			
			inner join Monedas m
				on hedr.Ecodigo = m.Ecodigo
				and hedr.Mcodigo = m.Mcodigo		  	  	
			
			inner join TipoDocumentoR tdr
				on hedr.TDRcodigo = tdr.TDRcodigo
				and hedr.Ecodigo = tdr.Ecodigo
				<cfif isdefined("Form.fTDRtipo") and Form.fTDRtipo  NEQ 'T'>
					and tdr.TDRtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fTDRtipo#">
				</cfif>
			  
			left outer join CPTransacciones cpt
				on hedr.Ecodigo = cpt.Ecodigo
				and hedr.CPTcodigo = cpt.CPTcodigo
			  
			left outer join CFuncional cf
				on hedr.Ecodigo =  cf.Ecodigo
				and hedr.CFid = cf.CFid	
			
			left outer join Almacen alm
				on hedr.Aid = alm.Aid
				and hedr.Ecodigo = alm.Ecodigo
			  	
			left outer join DDocumentosRecepcion hddr
				on hedr.Ecodigo = hddr.Ecodigo
				and hedr.EDRid = hddr.EDRid
				
				left outer join Impuestos impu
					on hddr.Icodigo = impu.Icodigo
					and hddr.Ecodigo = impu.Ecodigo
				
				left outer join EReclamos er
					on hddr.EDRid = er.EDRid
					 and hddr.Ecodigo = er.Ecodigo
				
					left outer join DReclamos dr
						on dr.ERid = er.ERid
						and dr.Ecodigo = er.Ecodigo
						and hddr.DDRlinea = dr.DDRlinea
						
				left outer join Articulos art
					on hddr.Aid = art.Aid
					and hddr.Ecodigo = art.Ecodigo	
	
				--left outer join Almacen alm
					--on hddr.Aid = alm.Aid
					--and hddr.Ecodigo = alm.Ecodigo
			
				--left outer join  Unidades u
					--on  u.Ucodigo = art.Ucodigo
					--and u.Ecodigo = art.Ecodigo
			
				--left outer join Conceptos con
					--on hddr.Cid = con.Cid
					--and hddr.Ecodigo = con.Ecodigo
			
				inner join DOrdenCM docm		
					on hddr.DOlinea=docm.DOlinea
					and hddr.Ecodigo = docm.Ecodigo	
					<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) neq 0 and (isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) neq 0)>
						<cfif form.EOnumero1  GT form.EOnumero2>
							and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
							and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
						<cfelseif form.EOnumero1 EQ form.EOnumero2>
							and docm.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
						<cfelse>
								and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
								and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
						</cfif>
					</cfif>
					<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and not (isdefined("form.EOnumero2")) >
							and docm.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
					</cfif>
					<cfif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and not (isdefined("form.EOnumero1")) >
							and docm.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
					</cfif>
	
					inner join EOrdenCM eocm
						on docm.EOidorden=eocm.EOidorden
						and docm.Ecodigo = eocm.Ecodigo
			
					inner join CFinanciera cfi
						on docm.Ecodigo = cfi.Ecodigo
						and docm.CFcuenta = cfi.CFcuenta
	
					inner join CPVigencia cpv
						on cfi.Ecodigo = cpv.Ecodigo
						and cfi.Cmayor = cpv.Cmayor
							
					--inner join Impuestos imp
						--on docm.Icodigo = imp.Icodigo
						--and docm.Ecodigo = imp.Ecodigo
			  
						--left outer join CFinanciera cfi2
							--on imp.Ecodigo = cfi2.Ecodigo
							--and imp.Ccuenta = cfi2.CFcuenta						 					
			

	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
		<cfif form.fEDRnumeroD  GT form.fEDRnumeroH>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelseif form.fEDRnumeroD EQ form.fEDRnumeroH>
			and hedr.EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelse>
				and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
				and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
		</cfif>
	</cfif>
	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and not (isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))) >
			and hedr.EDRnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
	</cfif>
	<cfif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH)) and not (isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD))) >
			and hedr.EDRnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
	</cfif>
	
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
		<cfif form.fechaD EQ form.fechaH>
			and  hedr.EDRfecharec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
		<cfelse>
			and  hedr.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
		</cfif>
	</cfif>
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and not ( isdefined("Form.fechaH") and len(trim(Form.fechaH)) )>
		and  hedr.EDRfecharec  >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
	</cfif>
	<cfif isdefined("Form.fechaH") and len(trim(Form.fechaH)) and not ( isdefined("Form.fechaD") and len(trim(Form.fechaD)) )>
		and  hedr.EDRfecharec <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
	</cfif>
	
	<cfif isdefined("Form.fEDRestado") and Form.fEDRestado  NEQ 'T'>	   
		and hedr.EDRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fEDRestado#">
	</cfif>
		
	<cfif isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo))>	  		
	  and hedr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfif>			
	
	order by EDRnumero
</cfquery>

--->

<cfquery name="qryLista" datasource="#session.dsn#">
	select  hedr.SNcodigo,
			sn.SNnombre,
			sn.SNidentificacion,
			hedr.EDRnumero as NumFactura, 
			hedr.EDRfechadoc,
			hedr.EDRfecharec,
			hedr.Usucodigo,
			eocm.EOplazo,
			eocm.EOnumero,
			docm.DOconsecutivo,
			hddr.DDRtipoitem,
			art.Acodigo,
			art.Adescripcion,
			con.Ccodigo,
			con.Cdescripcion,
			alm.Almcodigo,
			docm.numparte,
			hddr.Ucodigo,
			hddr.DDRcantordenconv,
			hddr.DDRcantrec,
			#LvarOBJ_PrecioU.enSQL_AS("hddr.DDRpreciou")#,
			hddr.DDRdesclinea,
			hddr.DDRtotallincd,
			hddr.DDRmtoimpfact,
			hddr.DDRtotallincd - hddr.DDRmtoimpfact as total,
			imp.Icodigo,
			imp.Idescripcion,
			imp.Iporcentaje,
			imp.Icreditofiscal,
			cfi.CFformato,
			er.EDRnumero,
			dr.DRcantorig - dr.DRcantrec as cantReclamo,
			(dr.DRcantorig - dr.DRcantrec) * dr.DRpreciorec as montoReclamo,
			docm.DOobservaciones,
			docm.DOalterna,
			hedr.Mcodigo, m.Mnombre, m.Miso4217
	from EDocumentosRecepcion hedr
	
		inner join DDocumentosRecepcion hddr
			on hedr.Ecodigo = hddr.Ecodigo
			and hedr.EDRid = hddr.EDRid
				
		inner join SNegocios sn
			on  hedr.Ecodigo = sn.Ecodigo
			and hedr.SNcodigo = sn.SNcodigo

		inner join Monedas m
			on hedr.Ecodigo = m.Ecodigo
			and hedr.Mcodigo = m.Mcodigo		  	  	
		
		inner join TipoDocumentoR tdr
			on hedr.TDRcodigo = tdr.TDRcodigo
			and hedr.Ecodigo = tdr.Ecodigo
		<cfif isdefined("Form.fTDRtipo") and Form.fTDRtipo NEQ 'T'>
			and tdr.TDRtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fTDRtipo#">
		</cfif>

		inner join DOrdenCM docm		
			on hddr.DOlinea = docm.DOlinea
			and hddr.Ecodigo = docm.Ecodigo	
		<cfif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) neq 0 and isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) neq 0>
			<cfif form.EOnumero1  GT form.EOnumero2>
				and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
			<cfelseif form.EOnumero1 EQ form.EOnumero2>
				and docm.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
			<cfelse>
				and docm.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
				and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
			</cfif>
		<cfelseif isdefined("form.EOnumero1") and len(trim(form.EOnumero1)) and not (isdefined("form.EOnumero2"))>
				and docm.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero1#">
		<cfelseif isdefined("form.EOnumero2") and len(trim(form.EOnumero2)) and not (isdefined("form.EOnumero1"))>
				and docm.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EOnumero2#">
		</cfif>

		inner join EOrdenCM eocm
			on docm.EOidorden=eocm.EOidorden
			and docm.Ecodigo = eocm.Ecodigo

		left outer join CFinanciera cfi
			on docm.Ecodigo = cfi.Ecodigo
			and docm.CFcuenta = cfi.CFcuenta

		left outer join CPVigencia cpv
			on cfi.Ecodigo = cpv.Ecodigo
			and cfi.Cmayor = cpv.Cmayor

		left outer join Articulos art
			on hddr.Aid = art.Aid
			and hddr.Ecodigo = art.Ecodigo	
		
		left outer join Conceptos con
			on hddr.Cid = con.Cid
			and hddr.Ecodigo = con.Ecodigo

		left outer join Almacen alm
			on docm.Alm_Aid = alm.Aid
			and docm.Ecodigo = alm.Ecodigo

		left outer join Impuestos imp
			on hddr.Icodigo = imp.Icodigo
			and hddr.Ecodigo = imp.Ecodigo

		left outer join EReclamos er
			on hddr.EDRid = er.EDRid
			and hddr.Ecodigo = er.Ecodigo
		
		left outer join DReclamos dr
			on dr.ERid = er.ERid
			and dr.Ecodigo = er.Ecodigo
			and hddr.DDRlinea = dr.DDRlinea
		
	where hedr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and DDRtipoitem <> 'F'
	
	<!--- Cuando vienen los dos filtros de numero llenos --->
	<cfif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD)) and isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))>
		<cfif form.fEDRnumeroD GT form.fEDRnumeroH>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelseif form.fEDRnumeroD EQ form.fEDRnumeroH>
			and hedr.EDRnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
		<cfelse>
			and hedr.EDRnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
			and <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
		</cfif>
	<!--- Cuando solo viene el primer filtro de numero --->
	<cfelseif isdefined("form.fEDRnumeroD") and len(trim(form.fEDRnumeroD))>
			and hedr.EDRnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroD#">
	<!--- Cuando solo viene el segundo filtro de numero --->
	<cfelseif isdefined("form.fEDRnumeroH") and len(trim(form.fEDRnumeroH))>
			and hedr.EDRnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#form.fEDRnumeroH#">
	</cfif>
	
	<!--- Cuando vienen ambos filtros de fecha --->
	<cfif isdefined("Form.fechaD") and len(trim(Form.fechaD)) and isdefined("Form.fechaH") and len(trim(Form.fechaH))>
		<cfif form.fechaD EQ form.fechaH>
			and hedr.EDRfecharec = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
		<cfelse>
			and hedr.EDRfecharec between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
		</cfif>
	<!--- Cuando solo viene el filtro filtro de fecha --->
	<cfelseif isdefined("Form.fechaD") and len(trim(Form.fechaD))>
			and hedr.EDRfecharec >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaD)#">
	<!--- Cuando solo viene el segundo filtro de fecha --->
	<cfelseif isdefined("Form.fechaH") and len(trim(Form.fechaH))>
			and hedr.EDRfecharec <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.fechaH)#">
	</cfif>

	<cfif isdefined("Form.fEDRestado") and Form.fEDRestado NEQ 'T'>
		and hedr.EDRestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fEDRestado#">
	</cfif>
		
	<cfif isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo))>
		and hedr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfif>

	order by hedr.Mcodigo, hedr.SNcodigo, hedr.EDRnumero
</cfquery>

<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  	<tr><td colspan="24" align="center" style="font-size:15px "><strong>Informe de Entradas</strong></td></tr>
	<tr><td>&nbsp;</td></tr>
  <cfoutput>
    <tr>
      <td colspan="24" align="center"><b>Fecha del reporte:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <br><b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
    </tr>
    <tr>
      <td colspan="24">&nbsp;</td>
    </tr>
  </cfoutput> 
	 <tr>	 	
	 	<td align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="2"> 
				<cfif qryLista.RecordCount>
					<cfset cortemoneda = "">
					<cfset cortesocio = "">
					<cfset cortefactura = "">

					<cfset totallinea = 0>
					<cfset totalgeneral = 0>
					<cfloop query="qryLista">
					  <cfoutput>
					  	<cfif cortesocio NEQ qryLista.SNcodigo>
							<cfset cortesocio = qryLista.SNcodigo>
							<cfset cortefactura = qryLista.NumFactura>
							<cfif qryLista.currentRow NEQ 1>
							<!--- Suma de totales de línea --->
							<tr>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							  	<strong>Total:</strong>
							  </td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							  	#LSNumberFormat(totallinea, ',9.00')#
							  </td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							</tr>
							<cfset totallinea = 0>
							</cfif>
							<!--- Pintado de Corte por Socio --->
							<tr>
								<td colspan="22" class="areaFiltro">
								    <table border="0" cellspacing="0" cellpadding="2">
                                      <tr>
										  <td><font size="2"><strong>#qryLista.SNnombre#</strong></font></td>
										  <td><font size="2"><strong>#qryLista.SNidentificacion#</strong></font></td>
                                      </tr>
                                    </table>
								</td>
							</tr>
							<!--- Encabezado Factura --->
							<tr>
								<td colspan="22">
								    <table border="0" cellspacing="0" cellpadding="2">
                                      <tr>
										  <td align="right"><strong>Factura:&nbsp;</strong></td>
										  <td>#cortefactura#</td>
										  <td align="right"><strong>Fecha:&nbsp;</strong></td>
										  <td>#LSDateFormat(qryLista.EDRfechadoc, 'dd/mm/yyyy')#</td>
										  <td align="right"><strong>Plazo:&nbsp;</strong></td>
										  <td>#qryLista.EOplazo#</td>
										  <td align="right"><strong>Fecha de Entrega:&nbsp;</strong></td>
										  <td>#LSDateFormat(qryLista.EDRfecharec, 'dd/mm/yyyy')#</td>
                                      </tr>
                                    </table>
								</td>
							</tr>
							<!--- Linea de Encabezado --->
							<tr>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black;">Orden Compra</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Línea</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Bodega</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;mero de Parte</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descripci&oacute;n del Art&iacute;culo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">UM</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unds. Conv. a UM de O.C.</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad Recibida</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio Unitario</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descuento</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Sub Total</td>
							  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto</td>
							  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Recupera Impuesto</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto Calculado</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Total L&iacute;nea</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cuenta Financiera</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;mero Reclamo</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad Reclamo</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Reclamo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Observaciones</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">Descripci&oacute;n</td>
							</tr>
						</cfif>
					    <cfif cortefactura NEQ qryLista.NumFactura>
							<cfset cortefactura = qryLista.NumFactura>
							<cfif qryLista.currentRow NEQ 1>
							<!--- Suma de totales de línea --->
							<tr>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							  	<strong>Total:</strong>
							  </td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							  	#LSNumberFormat(totallinea, ',9.00')#
							  </td>
							  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
							</tr>
							<cfset totallinea = 0>
							</cfif>
							<!--- Encabezado Factura --->
							<tr>
								<td colspan="22">
								    <table border="0" cellspacing="0" cellpadding="2">
                                      <tr>
										  <td align="right"><strong>Factura:&nbsp;</strong></td>
										  <td>#cortefactura#</td>
										  <td align="right"><strong>Fecha:&nbsp;</strong></td>
										  <td>#LSDateFormat(qryLista.EDRfechadoc, 'dd/mm/yyyy')#</td>
										  <td align="right"><strong>Plazo:&nbsp;</strong></td>
										  <td>#qryLista.EOplazo#</td>
										  <td align="right"><strong>Fecha de Entrega:&nbsp;</strong></td>
										  <td>#LSDateFormat(qryLista.EDRfecharec, 'dd/mm/yyyy')#</td>
                                      </tr>
                                    </table>
								</td>
							</tr>
							<!--- Linea de Encabezado --->
							<tr>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black;">Orden Compra</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Línea</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Bodega</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;mero de Parte</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descripci&oacute;n del Art&iacute;culo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">UM</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Unds. Conv. a UM de O.C.</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad Recibida</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Precio Unitario</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descuento</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Sub Total</td>
							  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto</td>
							  <td align="center" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Recupera Impuesto</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuesto Calculado</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Total L&iacute;nea</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cuenta Financiera</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">N&uacute;mero Reclamo</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad Reclamo</td>
							  <td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Reclamo</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Observaciones</td>
							  <td nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">Descripci&oacute;n</td>
							</tr>
						</cfif>
						<tr>
							<td style="border-bottom: 1px solid black; " nowrap>#qryLista.EOnumero#</td>
							<td style="border-bottom: 1px solid black; " nowrap>#qryLista.DOconsecutivo#</td>
							<td style="border-bottom: 1px solid black; " nowrap>
								<cfif qryLista.DDRtipoitem EQ 'A'>
									#qryLista.Acodigo#
								<cfelseif qryLista.DDRtipoitem EQ 'S'>
									#qryLista.Ccodigo#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " nowrap>
								<cfif Len(Trim(qryLista.Almcodigo))>
									#qryLista.Almcodigo#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td style="border-bottom: 1px solid black; " nowrap>
								<cfif Len(Trim(qryLista.numparte))>
									#qryLista.numparte#
								<cfelse>
									&nbsp;
							</cfif>							</td>
							<td style="border-bottom: 1px solid black; ">
								<cfif qryLista.DDRtipoitem EQ 'A'>
									#qryLista.Adescripcion#
								<cfelseif qryLista.DDRtipoitem EQ 'S'>
									#qryLista.Cdescripcion#
								<cfelse>
									&nbsp;
					        </cfif>							</td>
							<td style="border-bottom: 1px solid black; " nowrap>
								<cfif Len(Trim(qryLista.Ucodigo))>
									#qryLista.Ucodigo#
								<cfelse>
									&nbsp;
						    	</cfif>
							</td>
							<td style="border-bottom: 1px solid black; " nowrap>
								<cfif Len(Trim(qryLista.DDRcantordenconv))>
									#qryLista.DDRcantordenconv#
								<cfelse>
									&nbsp;
						    	</cfif>
							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.DDRcantrec))>
									#LSNumberFormat(qryLista.DDRcantrec, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.DDRpreciou))>
									#LvarOBJ_PrecioU.enCF_RPT(qryLista.DDRpreciou)#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.DDRdesclinea))>
									#LSNumberFormat(qryLista.DDRdesclinea, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.DDRtotallincd))>
									#LSNumberFormat(qryLista.DDRtotallincd, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="center" nowrap>
								<cfif Len(Trim(qryLista.Icodigo))>
									#qryLista.Icodigo# (#qryLista.Iporcentaje#%)
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="center" nowrap>
								<cfif Len(Trim(qryLista.Icodigo)) and qryLista.Icreditofiscal EQ 1>
									X
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.DDRmtoimpfact))>
									#LSNumberFormat(qryLista.DDRmtoimpfact, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.total))>
									#LSNumberFormat(qryLista.total, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " nowrap>#qryLista.CFformato#</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.EDRnumero))>
									#qryLista.EDRnumero#
								<cfelse>
									&nbsp;
							</cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.cantReclamo))>
									#LSNumberFormat(qryLista.cantReclamo, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; " align="right" nowrap>
								<cfif Len(Trim(qryLista.montoReclamo))>
									#LSNumberFormat(qryLista.montoReclamo, ',9.00')#
								<cfelse>
									&nbsp;
						    </cfif>							</td>
							<td style="border-bottom: 1px solid black; ">
								<cfif Len(Trim(qryLista.DOobservaciones))>
									#qryLista.DOobservaciones#
								<cfelse>
									&nbsp;
							</cfif>							</td>
							<td style="border-bottom: 1px solid black; ">
								<cfif Len(Trim(qryLista.DOalterna))>
									#qryLista.DOalterna#
								<cfelse>
									&nbsp;
							</cfif>
							</td>
					    </tr>

						<cfif Len(Trim(qryLista.total))>
							<cfset totallinea = totallinea + qryLista.total>
							<cfset totalgeneral = totalgeneral + qryLista.total>
						</cfif>
					  </cfoutput>
					</cfloop>
					<cfif qryLista.RecordCount>
						<!--- Suma de totales de la última línea --->
						<cfoutput>
						<tr>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							<strong>Total:</strong>
						  </td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							#LSNumberFormat(totallinea, ',9.00')#
						  </td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						</tr>
						<!--- SUMA GENERAL DE LAS LÍNEAS --->
						<tr>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="center" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							<strong>Total General:</strong>
						  </td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>
							#LSNumberFormat(totalgeneral, ',9.00')#
						  </td>
						  <td style="border-bottom: 1px solid black; " nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; " align="right" nowrap>&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						  <td style="border-bottom: 1px solid black; ">&nbsp;</td>
						</tr>
						</cfoutput>
					</cfif>
				<cfelse>
					<tr>
						<td colspan="22" align="center" class="listaCorte">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="22" align="center" class="listaCorte"><strong>----------------------------------  No se encontraron registros ----------------------------------</strong></td>
					</tr>
				</cfif>
				<tr><td colspan="22">&nbsp;</td></tr>
				<cfif qryLista.RecordCount NEQ 0>
					<tr>
						<td colspan="22" align="center" class="listaCorte"><strong>----------------------------------   Fin del reporte   ----------------------------------</strong></td>
					</tr>					
				</cfif>
			</table>
		</td>		
	</tr>
</table>
