<cf_dbfunction name="OP_concat"	 returnvariable="_Cat">

<cfparam name="lvarProvCorp" 	default="FALSE">
<cfparam name="navegacion" 		default="">
<cfparam name="filtro" 			default="">
<cfparam name="filtrosocio" 	default="">
<cfparam name="filtrotipo" 		default="">
<cfparam name="actEncab" 		default="0">
<cfparam name="actEncab_B" 		default="0">
<cfparam name="costounitario" 	default="0.00">
<cfparam name="form.EDPid" 		default="-1">

<CF_NAVEGACION NAME="EDIid">
<CF_NAVEGACION NAME="SNcodigo">
<CF_NAVEGACION NAME="DOdescripcion">
<CF_NAVEGACION NAME="ETidtracking">
<CF_NAVEGACION NAME="EPDid">
<CF_NAVEGACION NAME="DDIafecta">
<CF_NAVEGACION NAME="validaCantSurtida">

<CF_NAVEGACION NAME="DOobservaciones">
<CF_NAVEGACION NAME="DOalterna">
<CF_NAVEGACION NAME="DOdescripcion">
<CF_NAVEGACION NAME="Acodigo">
<CF_NAVEGACION NAME="Ccodigo">
<CF_NAVEGACION NAME="EOnumero">
<CF_NAVEGACION NAME="fecha">
<CF_NAVEGACION NAME="Observaciones">
<CF_NAVEGACION NAME="numparte">

<CF_NAVEGACION NAME="ECODIGO_F" DEFAULT="#SESSION.Ecodigo#">

<!----Agregar a la navegación los parámetros recibidos por url desde la pantalla que llama el conlis----->
<cfif isdefined("form.EDIid") and len(trim(form.EDIid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDIid=" & Form.EDIid>
</cfif>
<cfif isdefined("form.DDIafecta") and form.DDIafecta NEQ ''>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DDIafecta=" & Form.DDIafecta>
</cfif>
<cfif isdefined("form.ETidtracking") and form.ETidtracking NEQ ''>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "ETidtracking=" & Form.ETidtracking>
</cfif>
<cfif form.EDPid NEQ '' AND form.EDPid NEQ -1>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EDPid=" & Form.EDPid>
</cfif>
<cfif isdefined("form.DDIafecta") and form.DDIafecta NEQ ''>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DDIafecta=" & Form.DDIafecta>
</cfif>
<cfif isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "validaCantSurtida=" & Form.validaCantSurtida>
</cfif>

<!----►►Agregar a la navegacion los filtros recibidos por url del conlis◄◄---->
<cfif isdefined("Form.EOnumero") and Len(Trim(Form.EOnumero)) NEQ 0>
	<cfset filtro = filtro & " and a.EOnumero = " & Form.EOnumero >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EOnumero=" & Form.EOnumero>
</cfif>
<cfif isdefined("Form.Observaciones") and Len(Trim(Form.Observaciones)) NEQ 0>
 	<cfset filtro = filtro & " and upper(Observaciones) like '%" & #UCase(Form.Observaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Observaciones=" & Form.Observaciones>
</cfif>
<cfif isdefined("Form.fecha") and Len(Trim(Form.fecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fecha=" & Form.fecha>
</cfif>
<cfif isdefined("Form.Devoluciones") and Len(Trim(Form.Devoluciones)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Devoluciones=" & Form.Devoluciones>
</cfif>
<cfset LvarFiltroNumeroParte = false>
<cfif isdefined("Form.numparte") and Len(Trim(Form.numparte)) NEQ 0>
	<cfset filtro = filtro & " and upper(g.NumeroParte) like '%" & #UCase(Form.numparte)# & "%'">
	<cfset LvarFiltroNumeroParte = true>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numparte=" & Form.numparte>
</cfif>
<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & Form.SNcodigo>
</cfif>
<cfif isdefined("Form.DOalterna") and Len(Trim(Form.DOalterna)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOalterna) like '%" & #UCase(Form.DOalterna)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOalterna=" & Form.DOalterna>
</cfif>
<cfif isdefined("Form.DOobservaciones") and Len(Trim(Form.DOobservaciones)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOobservaciones) like '%" & #UCase(Form.DOobservaciones)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOobservaciones=" & Form.DOobservaciones>
</cfif>
<cfif isdefined("Form.DOdescripcion") and Len(Trim(Form.DOdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DOdescripcion) like '%" & #UCase(Form.DOdescripcion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DOdescripcion=" & Form.DOdescripcion>
</cfif>
<cfif isdefined("Form.Acodigo") and Len(Trim(Form.Acodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(c.Acodigo) like '%" & #UCase(Form.Acodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Acodigo=" & Form.Acodigo>
</cfif>
<cfif isdefined("Form.Ccodigo") and Len(Trim(Form.Ccodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(d.Ccodigo) like '%" & #UCase(Form.Ccodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ccodigo=" & Form.Ccodigo>
</cfif>

<!-----►►Se guarda en una variable el número de pagina (de la lista)◄◄----->	
<cfset pagina = 1 >
<cfif isdefined("form.pagenum")>
	<cfset pagina = form.pagenum >
<cfelseif isdefined("url.pagenum_lista")>
	<cfset pagina = url.pagenum_lista >
</cfif>

<!---►►Se le suma una para el caso que se de clic al boton de agregar y continuar◄◄---->
<cfset pagina = pagina + 1>

<!---►►Proveeduría Corporativa◄◄--->
<cfquery name="rsProvCorp" datasource="#session.DSN#">
    select Coalesce(Pvalor, 'N') Pvalor
    from Parametros 
    where Ecodigo = #session.Ecodigo#
      and Pcodigo = 5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
  <cfset lvarProvCorp = TRUE>
    <cfquery name="rsEProvCorp" datasource="#session.DSN#">
        select EPCid
        from EProveduriaCorporativa
        where Ecodigo 		  = #session.Ecodigo#
          and EPCempresaAdmin = #session.Ecodigo#
    </cfquery>
    <cfif rsEProvCorp.recordcount eq 0>
    	<cfthrow message="El Catálogo de Proveduría Corporativa no se ha configurado">
    </cfif>
    <cfquery name="rsDProvCorp" datasource="#session.DSN#">
        select DPCecodigo as Ecodigo, Edescripcion
        from DProveduriaCorporativa dpc
        	inner join Empresas e
            	on e.Ecodigo = dpc.DPCecodigo
        where dpc.Ecodigo = #session.Ecodigo#
         and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
       	union
        select e.Ecodigo, e.Edescripcion
        from Empresas e
        where e.Ecodigo = #session.Ecodigo#
        order by 2
    </cfquery>
</cfif>

<!---►►Se obtienen el Socio de Negocios◄◄--->
<cfquery name="rsSocio" datasource="#session.dsn#">
	select SNdoc.SNidentificacion SNidentificacionDoc, SNoc.SNidentificacion SNidentificacionOC, 
    	   SNdoc.SNnumero SNnumeroDoc, SNoc.SNnumero SNnumeroOC,
           SNdoc.SNcodigo SNcodigoDoc, coalesce(SNoc.SNcodigo,-1) SNcodigoOC
    	from SNegocios  SNdoc
        	LEFT OUTER JOIN SNegocios SNoc
            	 on SNoc.SNidentificacion = SNdoc.SNidentificacion
                and SNoc.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECODIGO_F#">
     where SNdoc.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#"> 
       and SNdoc.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<!---►►Se obtienen al Empresa de la OC◄◄--->
<cfquery name="rsEmpresaOC" datasource="#session.dsn#">
	select Edescripcion 
    	from Empresas 
     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECODIGO_F#">
</cfquery>

<!---►►Se obtienen al Empresa del Registro◄◄--->
<cfquery name="rsEmpresaDoc" datasource="#session.dsn#">
    Select Mcodigo
     from Empresas
    where Ecodigo = #session.Ecodigo#
</cfquery>

<!---►►Obtiene el código de la moneda del documento de importación◄◄--->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select mDoc.Mcodigo as McodigoDoc, coalesce(mOC.Mcodigo,-1) as McodigoOC,
    	   mDoc.Miso4217 as Miso4217Doc, mOC.Miso4217 as Miso4217OC
	from EDocumentosI edi
    	INNER JOIN Monedas mDoc	
        	on mDoc.Mcodigo = edi.Mcodigo
        LEFT OUTER JOIN Monedas mOC
        	 on mOC.Miso4217 = mDoc.Miso4217
            and mOC.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECODIGO_F#">
	where edi.EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
</cfquery>


<!---►►AGREGA LAS LINEAS DE COSTO◄◄--->
<cfif isdefined('form.btnAgregar') and form.btnAgregar NEQ '' or (isdefined("form.btnAgregar_y_continuar"))>
	<cfloop collection="#Form#" item="i">
	 
      <!---►►Actualizacion del campo "EOidorden" del encabezado con la primera orden de compra seleccionada en la insercion de los detalles◄◄--->	
		<cfif actEncab EQ 0 and FindNoCase("chkPadre", i) NEQ 0 and Form[i] NEQ 0>
			<cfset MM_columnsPadre = ListToArray(form[i],",")><!----EOidorden de la(s) OC(s) seleccionada(s)----->
			<cfif isdefined('MM_columnsPadre') and ArrayLen(MM_columnsPadre) GT 0>
				<cfquery name="updateEncabezado" datasource="#session.DSN#">
					update EDocumentosI
						set EOidorden  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#MM_columnsPadre[1]#">							
					where EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">
				</cfquery>
				<cfset actEncab = 1>
			</cfif>
		</cfif>		
				
		<!--- Insercion de las lineas de compra --->
		<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
			<cfset MM_columns = ListToArray(form[i],",")><!-----Lineas de la OC----->
			
			<cfif isdefined('MM_columns') and ArrayLen(MM_columns) GT 0><!----Si hay OC's y lineas seleccionados---->
				<cfset j = ArrayLen(MM_columns)>
				<cfloop index = "k" from = "1" to = #j#><!----Recorre c/linea de la OC--->
					<cfquery name="insertd" datasource="#session.DSN#">
						insert into DDocumentosI(DDIconsecutivo, 
												EDIid, 
												Ecodigo, 
												DOlinea, 
												Icodigo, 
												Ucodigo,
												EPDid, 
												DDIcantidad, 
												DDItipo, 
												Cid, 
												Aid, 
												DDIpreciou, 
												cantidadrestante, 
												montorestante, 
												DDItotallinea,
												CFcuenta, 
												DDIafecta, 
												Usucodigo, 
												fechaalta, 
												DDIobs, 
												ETidtracking, 
												DDIporcdesc, 
												BMUsucodigo)
						select (Select coalesce(max(DDIconsecutivo),0) + 1
									from DDocumentosI
									where Ecodigo = #session.Ecodigo#
										and EDIid = <cfqueryparam value="#form.EDIid#" cfsqltype="cf_sql_numeric">),
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDIid#">,
								#session.Ecodigo#,
								DOlinea,
								null,
								Ucodigo,
								<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.EDPid#" voidnull null="#form.EDPid EQ -1#">,
								<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
								a.DOcantidad - (select coalesce(sum(case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
											else
												case when o.CUfactor is not null then o.CUfactor * m.ETcantfactura
													else case when  cv.CUAfactor is not null then cv.CUAfactor * m.ETcantfactura
														 else m.ETcantfactura 
														 end
												end
											end
											),0)
								from ETrackingItems m
			
									inner join DOrdenCM dor
										on m.DOlinea = dor.DOlinea
			
									left outer join ConversionUnidades o
										 on o.Ecodigo    = m.Ecodigo
										and o.Ucodigo    = m.Ucodigo
										and o.Ucodigoref = dor.Ucodigo
			
									left outer join Articulos art
										on dor.Aid = art.Aid
			
									left outer join ConversionUnidadesArt cv
										 on art.Aid     = cv.Aid
										and cv.Ecodigo  = art.Ecodigo
										and art.Ucodigo = m.Ucodigo
										and cv.Ucodigo  = dor.Ucodigo

								where m.Ecodigo = #session.Ecodigo#
								  and m.DOlinea = a.DOlinea
								),
								<cfelse>
								a.DOcantidad - a.DOcantsurtida,
								</cfif>
								CMtipo, 
								Cid, 
								Aid, 
								coalesce(DOpreciou,0),
								<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
								a.DOcantidad - (select coalesce(sum(case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
											else
												case when o.CUfactor is not null then o.CUfactor*m.ETcantfactura
													else case when  cv.CUAfactor is not null then cv.CUAfactor*m.ETcantfactura
														 else m.ETcantfactura 
														 end
												end
											end
											),0)
								from ETrackingItems m
			
									inner join DOrdenCM dor
										 on m.DOlinea = dor.DOlinea
			
									left outer join ConversionUnidades o
										 on o.Ecodigo    = m.Ecodigo
										and o.Ucodigo    = m.Ucodigo
										and o.Ucodigoref = dor.Ucodigo
			
									left outer join Articulos art
										on dor.Aid = art.Aid
			
									left outer join ConversionUnidadesArt cv
										on art.Aid = cv.Aid
										and cv.Ecodigo = art.Ecodigo
										and art.Ucodigo = m.Ucodigo
										and cv.Ucodigo = dor.Ucodigo

								where m.Ecodigo = #session.Ecodigo#
									and m.DOlinea = a.DOlinea
								),
								<cfelse>
								a.DOcantidad - a.DOcantsurtida,
								</cfif>
								<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
									round(
									(a.DOcantidad - (select coalesce(sum(case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
												else
													case when o.CUfactor is not null then o.CUfactor*m.ETcantfactura
														else case when  cv.CUAfactor is not null then cv.CUAfactor*m.ETcantfactura
															 else m.ETcantfactura 
															 end
													end
												end
												),0)
									from ETrackingItems m
				
										inner join DOrdenCM dor
											on m.DOlinea = dor.DOlinea
				
										left outer join ConversionUnidades o
											on o.Ecodigo = m.Ecodigo
											and o.Ucodigo = m.Ucodigo
											and o.Ucodigoref = dor.Ucodigo
				
										left outer join Articulos art
											on art.Aid = dor.Aid
											and art.Ucodigo = m.Ucodigo
				
										left outer join ConversionUnidadesArt cv
											on art.Aid = cv.Aid
											and cv.Ecodigo = art.Ecodigo
											and cv.Ucodigo = dor.Ucodigo
	
									where m.Ecodigo = #session.Ecodigo#
										and m.DOlinea = a.DOlinea
									)) * a.DOpreciou * (1 - (coalesce(a.DOporcdesc, 0) / 100))
									, 2),
								<cfelse>
									round((a.DOcantidad - a.DOcantsurtida) * a.DOpreciou * (1 - (coalesce(a.DOporcdesc, 0) / 100)), 2),
								</cfif>
								<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
									round(
									(a.DOcantidad - (select coalesce(sum(case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
												else
													case when o.CUfactor is not null then o.CUfactor*m.ETcantfactura
														else case when  cv.CUAfactor is not null then cv.CUAfactor*m.ETcantfactura
															 else m.ETcantfactura 
															 end
													end
												end
												),0)
									from ETrackingItems m
				
										inner join DOrdenCM dor
											on m.DOlinea = dor.DOlinea
				
										left outer join ConversionUnidades o
											on o.Ecodigo = m.Ecodigo
											and o.Ucodigo = m.Ucodigo
											and o.Ucodigoref = dor.Ucodigo
				
										left outer join Articulos art
											on art.Aid = dor.Aid
											and art.Ucodigo = m.Ucodigo
				
										left outer join ConversionUnidadesArt cv
											on art.Aid = cv.Aid
											and cv.Ecodigo = art.Ecodigo
											and cv.Ucodigo = dor.Ucodigo
	
									where m.Ecodigo = #session.Ecodigo#
										and m.DOlinea = a.DOlinea
									)) * a.DOpreciou * (1 - (coalesce(a.DOporcdesc, 0) / 100))
									, 2),
								<cfelse>
									round((a.DOcantidad - a.DOcantsurtida) * a.DOpreciou * (1 - (coalesce(a.DOporcdesc, 0) / 100)), 2),
								</cfif>
								CFcuenta,
								<cfqueryparam value="#form.DDIafecta#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								DOobservaciones,
								<cfif isdefined("form.ETidtracking") and len(trim(form.ETidtracking))>
									<cfqueryparam value="#form.ETidtracking#" cfsqltype="cf_sql_numeric">,
								<cfelse>
									null
								</cfif>,
								coalesce(DOporcdesc,0),
								<cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
						from DOrdenCM a
						where a.DOlinea = <cfqueryparam value="#MM_columns[k]#" cfsqltype="cf_sql_numeric">
					</cfquery>
					
					<cfset j = j - 1>
				</cfloop>
			</cfif>
		</cfif>		
	</cfloop>
	
	<cfif isdefined('form.btnAgregar')>
		<script language="JavaScript" type="text/javascript">
			window.opener.document.form1.submit();
			window.close();				
		</script>
	</cfif>
</cfif>



<cfquery name="rsLista" datasource="#session.DSN#">
	select  	 	'#form.EDIid#' as EDIid,
					'#form.DDIafecta#' as DDIafecta,
					<cfif isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida))>
						'#form.validaCantSurtida#' as validaCantSurtida,
					<cfelse>
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null"> as validaCantSurtida,
					</cfif>
					b.SNcodigo,
					a.EOidorden,
					a.DOlinea,
					b.EOestado,
					a.DOconsecutivo,
					coalesce(a.DOcantidad,0) as DOcantidad,
					<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
						coalesce( (
							select sum(
								case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
								else
									case when o.CUfactor is not null then o.CUfactor * m.ETcantfactura
									else 
										case when  cv.CUAfactor is not null then cv.CUAfactor * m.ETcantfactura
										else m.ETcantfactura 
										end
									end
								end
							)
						from ETrackingItems m
	
							inner join DOrdenCM dor
								on dor.DOlinea = m.DOlinea
	
							left outer join ConversionUnidades o
								on o.Ecodigo     = m.Ecodigo
								and o.Ucodigo    = m.Ucodigo
								and o.Ucodigoref = dor.Ucodigo
	
							left outer join Articulos art
								 on dor.Aid     = art.Aid
								and art.Ucodigo = m.Ucodigo
	
							left outer join ConversionUnidadesArt cv
								on  cv.Aid     = art.Aid
								and cv.Ucodigo = dor.Ucodigo
	
						where m.DOlinea = a.DOlinea
						),0) as DOcantsurtida,
					<cfelse>
						coalesce(a.DOcantsurtida,0.00) as DOcantsurtida,
					</cfif>
					case when CMtipo = 'A' then rtrim(c.Acodigo)#_Cat#' - '#_Cat#a.DOdescripcion
						 when CMtipo = 'S' then rtrim(d.Ccodigo)#_Cat#' - '#_Cat#a.DOdescripcion
						 else a.DOdescripcion
					end as DOdescripcion,
					coalesce(
								(
									select min(gp.NumeroParte)
									from NumParteProveedor gp
									where gp.Ecodigo  = a.Ecodigo 
									  and gp.SNcodigo = b.SNcodigo 
									  and gp.Aid      = a.Aid 
									  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between gp.Vdesde and gp.Vhasta
								)
							, c.Acodalterno
						) as numeroparte,
					<cf_dbfunction name="to_char" args="a.EOnumero"> #_Cat#' - '#_Cat#b.Observaciones  as Orden

	from DOrdenCM a
		inner join EOrdenCM b
		  on b.EOidorden = a.EOidorden
          
        INNER JOIN Monedas Moc <!---►Moneda de la Orden de Compra--->
        	ON Moc.Mcodigo = b.Mcodigo
    	INNER JOIN Monedas Mrt <!---►Moneda del Registro de transacciones--->
         	 ON Mrt.Mcodigo  = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsMoneda.McodigoOC#">
        	AND Mrt.Miso4217 = Moc.Miso4217

		LEFT OUTER JOIN CMTipoOrden e
             on e.Ecodigo 			= b.Ecodigo
            and e.CMTOcodigo        = b.CMTOcodigo
            and e.CMTOimportacion   = 1
            and e.CMTgeneratracking = 1
		
		LEFT OUTER JOIN  Articulos c
        	on a.Aid = c.Aid                        

        LEFT OUTER JOIN Conceptos d
        	on a.Cid = d.Cid

		LEFT OUTER JOIN Impuestos i 
			on a.Icodigo = i.Icodigo 
		   and a.Ecodigo = i.Ecodigo
		
		<cfif LvarFiltroNumeroParte>
			LEFT OUTER JOIN NumParteProveedor g
				on g.Ecodigo   = a.Ecodigo 
			   and g.SNcodigo  = b.SNcodigo 
			   and g.Aid       = a.Aid 
			   and <cf_dbfunction name="now"> between g.Vdesde and g.Vhasta
		</cfif>

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECODIGO_F#">
	  and a.DOcantidad - a.DOcantsurtida > 0

	<!---No mostrar las lineas que ya fueron insertadas en cualquier empresa----->
<!---	and (select count(1) 
    		from DDocumentosI d
    			inner join EDocumentosI e
                	on d.EDIid = e.EDIid
             where d.DOlinea   = a.DOlinea 
               and d.DOlinea is not null
               and e.EDIestado in (0,10) <!---►►0-En registro, 10-Aplicada◄◄--->
         ) = 0   ---->

	<cfif not isdefined("form.validaCantSurtida") or ( isdefined("form.validaCantSurtida") and len(trim(form.validaCantSurtida)) EQ 0)>	
		and a.DOcantidad > 
			coalesce((select sum(
				case when m.Ucodigo = dor.Ucodigo then m.ETcantfactura
				else
					case when o.CUfactor is not null then o.CUfactor*m.ETcantfactura
					else 
						case when cv.CUAfactor is not null then cv.CUAfactor*m.ETcantfactura
						else m.ETcantfactura 
						end
					end
				end
				)
			from ETrackingItems m

				inner join DOrdenCM dor
					on dor.DOlinea = m.DOlinea

				left outer join ConversionUnidades o
				 	on o.Ecodigo = m.Ecodigo
				   and o.Ucodigo = m.Ucodigo
				   and o.Ucodigoref = dor.Ucodigo

				left outer join Articulos art
				on art.Aid = dor.Aid
				and art.Ucodigo = m.Ucodigo

				left outer join ConversionUnidadesArt cv
				on  cv.Aid = art.Aid
				and cv.Ucodigo = dor.Ucodigo

			where m.DOlinea = a.DOlinea
			),0) 
	</cfif>

	and b.EOestado = 10
	and b.SNcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#rsSocio.SNcodigoOC#">											

	#preservesinglequotes(filtro)#

	order by a.EOnumero, a.DOconsecutivo
</cfquery>


<!--- Se regresa a la pagina #1 cuando se esta en la ultima pagina y se da clic en el botn de guardar y continuar ---->
<cfif pagina gt ceiling(rsLista.recordcount/8)><!--- Se obtiene la máxima pagina (la pagina hace corte cada 8 lineas, la funcion Ceiling me "redondea" al proximo numero inmediato ---->
	<cfset pagina = 1 >
</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Lista de Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<!----<body onUnload="javascript: window.opener.document.filtroOrden.location.href ='EDocumentosI.cfm?<cfoutput>EDIid=#form.EDIid#&dmodo=CAMBIO</cfoutput>';">----->
<cf_templatecss>
<script language="JavaScript" type="text/javascript">
<!--//
	function Asignar(DOlinea, DOdescripcion) {
		if (window.opener != null) {
			window.opener.document.form1.DOlinea.value = DOlinea;
			window.opener.document.form1.DOdescripcion.value = DOdescripcion;
			window.opener.document.form1.submit();
			window.close();
		}
	}

	function funcAgregar(DOlinea, DOdescripcion) {
		document.linea.EDIID.value = '<cfoutput>#form.EDIid#</cfoutput>';
		document.linea.SNCODIGO.value = '<cfoutput>#form.SNcodigo#</cfoutput>';
		document.linea.DDIAFECTA.value = '<cfoutput>#form.DDIafecta#</cfoutput>';		
		<cfif isdefined("Form.ETidtracking") and len(trim(Form.ETidtracking))>
			document.linea.ETIDTRACKING.value = '<cfoutput>#form.ETidtracking#</cfoutput>';
		</cfif>		
		<cfif isdefined("Form.validaCantSurtida")>
			document.linea.VALIDACANTSURTIDA.value = '<cfoutput>#form.validaCantSurtida#</cfoutput>';
		</cfif>			
	}	
	
	//Funcion para el botón de agregar y continuar 
	function funcAgregar_y_continuar(DOlinea, DOdescripcion) {
		document.linea.EDIID.value = '<cfoutput>#form.EDIid#</cfoutput>';
		document.linea.SNCODIGO.value = '<cfoutput>#form.SNcodigo#</cfoutput>';
		document.linea.DDIAFECTA.value = '<cfoutput>#form.DDIafecta#</cfoutput>';		
		<cfif isdefined("Form.ETidtracking") and len(trim(Form.ETidtracking))>
			document.linea.ETIDTRACKING.value = '<cfoutput>#form.ETidtracking#</cfoutput>';
		</cfif>		
		<cfif isdefined("Form.validaCantSurtida")>
			document.linea.VALIDACANTSURTIDA.value = '<cfoutput>#form.validaCantSurtida#</cfoutput>';
		</cfif>			
		document.linea.PageNum.value = '<cfoutput>#pagina#</cfoutput>';					
	}

	//Funcion para cerrar la pantalla
	function funcCerrar(){		
		window.opener.document.form1.submit();
		window.close();
	}	

//-->
</script>
</head>
<body>
<script  language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td>
			<cfoutput><form style="margin:0;" name="filtroOrden" method="post" action="ConlisLineaCompraTransaccionesC.cfm">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				<tr>
                	<!---►►N° Orden◄◄--->
					<td width="14%" align="right" nowrap>N° Orden:</td>
					<td width="8%"> 
						<input tabindex="1" type="text" name="EOnumero" id="EOnumero" style="text-align:right;"
						   size="22" maxlength="20" 
						   onKeyUp="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
						   onFocus="javascript:this.select();" 
						   onChange="javascript: fm(this,-1);"
						   value="<cfif isdefined("Form.EOnumero")>#Form.EOnumero#</cfif>">
					</td>
                    <!---►►Descripcion de la Orden◄◄--->
					<td width="13%" align="right" nowrap>Descripción Orden:</td>
					<td width="27%"> 
						<input name="Observaciones" type="text" id="desc" size="22" maxlength="80" value="<cfif isdefined("Form.Observaciones")>#Form.Observaciones#</cfif>" onFocus="javascript:this.select();">
					</td>
                    <!---►►Codigo de Articulo◄◄--->
                    <td width="15%" align="right" nowrap>Código Artículo:</td>
					<td><input name="Acodigo" type="text" id="Acodigo" size="20" maxlength="20" value="<cfif isdefined("Form.Acodigo")>#Form.Acodigo#</cfif>"></td>
               	</tr>
                <tr>
                	<!---►►Numero de Parte◄◄--->
				    <td width="15%" align="right" nowrap>Num. de Parte:</td>
				    <td width="7%">
						<input name="numparte" type="text" id="numparte" size="22" maxlength="20" value="<cfif isdefined("Form.numparte")>#Form.numparte#</cfif>" onFocus="javascript:this.select();">
					</td>	
                    <!---►►Descripcion alterna◄◄--->		
                    <td width="15%" align="right" nowrap>Descripción alterna:</td>
					<td><input name="DOalterna" type="text" id="DOalterna" size="22" maxlength="1024" value="<cfif isdefined("Form.DOalterna")>#Form.DOalterna#</cfif>"></td>	
					<!---►►Codigo de servicio◄◄--->
                    <td width="15%" align="right" nowrap>Código Servicio:</td>
					<td><input name="Ccodigo" type="text" id="Ccodigo" size="20" maxlength="20" value="<cfif isdefined("Form.Ccodigo")>#Form.Ccodigo#</cfif>"> </td>									
                 </tr>
				<tr>
                	<!---►►Observaciones◄◄--->
					<td width="15%" align="right" nowrap>Observaciones:</td>
				  	<td><input name="DOobservaciones" type="text" id="DOobservaciones" size="35" maxlength="255" value="<cfif isdefined("Form.DOobservaciones")>#Form.DOobservaciones#</cfif>"> 
					<!---►►Descripcion◄◄--->
                    <td width="15%" align="right" nowrap>Descripción línea:</td>
					<td><input name="DOdescripcion" type="text" id="DOdescripcion" size="35" maxlength="255" value="<cfif isdefined("Form.DOdescripcion")>#Form.DOdescripcion#</cfif>"></td>					
				</tr>
                <TR>
                	<cfif lvarProvCorp>
               	 		<td align="right" nowrap>Empresa:</td>
               			<td colspan="2">
                            <select name="Ecodigo_f">
                                <cfloop query="rsDProvCorp">
                                    <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                </cfloop>	
                            </select>
                		</td>
               		</cfif>
                    <td>
                    	<input name="btnFiltrar" type="submit" class="btnFiltrar" id="btnFiltrar" value="Filtrar">
						<input name="btnlimpiar" type="reset"  class="btnLimpiar" id="btnlimpiar" value="Limpiar">
                   </td>
				</tr>
				<cfif NOT LEN(TRIM(rsSocio.SNidentificacionOC))>
                     <tr>
                        <td colspan="6" align="center"> 
                        	<div style="color:##F00">El socio de Negocios "#rsSocio.SNnumeroDoc#" no existe en la empresa "#rsEmpresaOC.Edescripcion#"</div>
                        </td>
                     </tr>
                </cfif>
                <cfif NOT LEN(TRIM(rsMoneda.Miso4217Doc))>
                	<tr>
                       <td colspan="6" align="center"> 
                        	<div style="color:##F00">La moneda "#rsSocio.Miso4217Doc#" no existe en la empresa "#rsEmpresaOC.Edescripcion#"</div>
                        </td>
                	</tr>
                </cfif>
			</table>
                    <input name="EDIid" 			type="hidden" value="#form.EDIid#">
                    <input name="ETidtracking" 		type="hidden" value="<cfif isdefined("form.ETidtracking")>#form.ETidtracking#</cfif>">
                    <input name="DDIafecta" 		type="hidden" value="#form.DDIafecta#">
                    <input name="SNcodigo" 			type="hidden" value="#form.SNcodigo#">
                    <input name="validaCantSurtida" type="hidden" value="<cfif isdefined("Form.validaCantSurtida") and len(trim(form.validaCantSurtida))>#form.validaCantSurtida#</cfif>">
			</form>
			</cfoutput>
		</td>
	</tr>	
	<tr>
		<td>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet"> 
					<cfinvokeargument name="query" 				value="#rsLista#"/> 
					<cfinvokeargument name="desplegar" 			value="DOconsecutivo, DOdescripcion, numeroparte, DOcantidad , DOcantsurtida"/> 
					<cfinvokeargument name="etiquetas" 			value="L&iacute;nea, Descripci&oacute;n, N. Parte, Cantidad, Cantidad Surtida"/> 
					<cfinvokeargument name="formatos" 			value="S,S,S,M,M"/> 
					<cfinvokeargument name="align" 				value="left,left,right,right,right"/> 
					<cfinvokeargument name="ajustar" 			value="S"/> 				 
					<cfinvokeargument name="chkcortes" 			value="S"/> 	
					<cfinvokeargument name="keycorte" 			value="EOidorden"/>
					<cfinvokeargument name="keys" 				value="DOlinea"/>				
					<cfinvokeargument name="botones" 			value="Agregar,Agregar_y_continuar,Cerrar"/>
					<cfinvokeargument name="showLink" 			value="false"/>
					<cfinvokeargument name="irA" 				value="ConlisLineaCompraTransaccionesC.cfm"/>				
					<cfinvokeargument name="formname" 			value="linea"/> 
					<cfinvokeargument name="maxrows" 			value="8"/> 
					<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" 	value="yes"/>
					<cfinvokeargument name="Cortes" 			value="Orden"/>
			</cfinvoke>  	
		</td>
	</tr>
</table>
</body>
</html>
