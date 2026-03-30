<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<!--- 1. Crea la navegación --->
<cfset navegacion = "">

<!--- 1.1. Documento actual --->

<!--- 1.1.1. Id del documento de recepción actual --->
<cfif isdefined("form.EDRid") and len(trim(form.EDRid)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "EDRid=" & form.EDRid>
</cfif>

<!--- 1.2. Filtro de detalles --->

<!--- 1.2.1. Número de parte de las líneas --->
<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "numparteF=" & form.numparteF>
</cfif>
<!--- 1.2.2. Descripción alterna --->
<cfif isdefined("form.DOalternaF") and len(trim(form.DOalternaF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "DOalternaF=" & form.DOalternaF>
</cfif>
<!--- 1.2.3. Observaciones de la línea --->
<cfif isdefined("form.DOobservacionesF") and len(trim(form.DOobservacionesF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "DOobservacionesF=" & form.DOobservacionesF>
</cfif>
<!--- 1.2.4. Código de artículo --->
<cfif isdefined("form.AcodigoF") and len(trim(form.AcodigoF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "AcodigoF=" & form.AcodigoF>
</cfif>
<!--- 1.2.5. Descripción de la línea --->
<cfif isdefined("form.DOdescripcionF") and len(trim(form.DOdescripcionF)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "DOdescripcionF=" & form.DOdescripcionF>
</cfif>
<!--- 1.2.6. Comprador de la orden de compra --->
<cfif isdefined("form.CMCid1")>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "CMCid1=" & form.CMCid1>
</cfif>
<!--- 1.2.7. Filtro para las líneas (todas, generan reclamo, no generan reclamo) --->
<cfif isdefined("form.Reclamo") and len(trim(form.Reclamo)) neq 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "Reclamo=" & form.Reclamo>
</cfif>

<!--- 1.3. Línea actual --->

<!--- 1.3.1. Id de la línea actual en modo cambio --->
<cfif isdefined("form.DDRlinea") and len(trim(form.DDRlinea)) gt 0>
	<cfset navegacion = navegacion & Iif(len(trim(navegacion)) neq 0, DE("&"), DE("")) & "DDRlinea=" & form.DDRlinea>
</cfif>

<!--- 2. Obtiene la lista de detalles --->
<cfquery name="rsListaDetalles" datasource="#session.dsn#">
	select  
			edr.EDRid,
			edr.EPDid,
			edr.EDRestado,
			ddr.DDRlinea,
			ddr.Icodigo,
			coalesce(i.Iporcentaje,0) as Iporcentaje, 			<!----Porcentaje de impuesto del documento de recepcion---->
			i.Idescripcion,		
			o.Icodigo as IcodigoOC,
			coalesce(imp.Iporcentaje,0) as IporcentajeOC,		<!----Porcentaje de impuesto de la OC---->
			imp.Idescripcion as IdescripcionOC,
			o.DOcantidad - o.DOcantsurtida as DOcantsaldo, <!--- DOcantsaldo, --->					<!--- Cantidad del saldo en la linea de la orden de compra --->
			ddr.Aid,
			Acodigo,
			Adescripcion,
			ddr.DDRtipoitem,
			ddr.Cid,
			c.Ccodigo,
			c.Cdescripcion,
			ddr.DOlinea,
			edr.EDRnumero,
			EDRfecharec,
			EDRobs,
			edr.SNcodigo,
			SNnumero,
			SNnombre,
			SNidentificacion,
			coalesce(DDRcantorigen,0) as DDRcantorigen,
			coalesce(DDRcantrec,0) as DDRcantrec,
			#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRpreciou,0)", "DDRpreciou")#,
			#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRprecioorig,0)", "DDRprecioorig")#,
			coalesce(DDRcantreclamo,0) as DDRcantreclamo,
			ddr.DOlinea, 
			p.EOnumero,
			coalesce(o.DOcantidad,0) as DOcantidad,
			coalesce(o.DOcantsurtida,0) as DOcantsurtida,
			ddr.DDRobsreclamo,
			coalesce(o.DOmontodesc,0) as DOmontodesc,
			coalesce(o.DOporcdesc,0) as DOporcdesc,
			case 
				when ddr.DDRaprobtolerancia = 10 then 1
				else 0
			end DDRaprobtolerancia,			
			coalesce(ddr.DDRdescporclin,0) as DDRdescporclin,
			case 
				when (ddr.DDRgenreclamo = 1)  and 
					(ddr.DDRaprobtolerancia is null or
					ddr.DDRaprobtolerancia = 5 or
					ddr.DDRaprobtolerancia=20)
											then ((coalesce(clas.Ctolerancia, 0) / 100) * o.DOcantidad)
				else 0
			end Ctolerancia,				<!--- Tolerancia del articulo --->
			case when clas.Ctolerancia is null then 'F'
				 else 'V'
			end as ArticuloTieneTolerancia,
			coalesce(ddr.DDRdesclinea,0) as DDRdesclinea,
			o.DOconsecutivo,
			edr.Mcodigo,
			p.Mcodigo as McodigoOC,
			edr.EDRtc,
			p.EOtc,
			case when o.Ucodigo = ddr.Ucodigo then 1
				 when cu.CUfactor is not null then cu.CUfactor
				 when cua.CUAfactor is not null then cua.CUAfactor
				 else case when ddr.DDRcantorigen = 0 then 0
						   else ddr.DDRcantordenconv / ddr.DDRcantorigen
						   end
				 end as factorConversionU,									<!--- Factor de conversion (factura a orden) --->	
			mon.Mnombre,
			rtrim(a.Acodigo) #_Cat# ' - ' #_Cat# o.DOdescripcion as DOdescripcion, 
			floor(((o.DOcantidad - o.DOcantsurtida) + (o.DOcantidad * coalesce(clas.Ctolerancia, 0.00) / 100.00))) as CantidadPermitida,
			npp.NumeroParte,
			(<cf_dbfunction name="to_char" args="p.EOnumero" datasource="#session.dsn#"> #_Cat# ' - ' #_Cat# p.Observaciones) as descOrden,
			p.EOidorden,

			0 as Exceso,
			case when ddr.DDRgenreclamo = 1 then 'Sí'
				 else 'No'
			end as GeneraReclamo
			
			<cfif isdefined("form.numparteF")>
			, '#form.numparteF#' as numparteF
			</cfif>
			<cfif isdefined("form.DOalternaF")>
			, '#form.DOalternaF#' as DOalternaF
			</cfif>
			<cfif isdefined("form.DOobservacionesF")>
			, '#form.DOobservacionesF#' as DOobservacionesF
			</cfif>
			<cfif isdefined("form.AcodigoF")>
			, '#form.AcodigoF#' as AcodigoF
			</cfif>
			<cfif isdefined("form.DOdescripcionF")>
			, '#form.DOdescripcionF#' as DOdescripcionF
			</cfif>
			<cfif isdefined("form.CMCid1")>
			, '#form.CMCid1#' as CMCid1
			</cfif>
			<cfif isdefined("form.Reclamo")>
			, '#form.Reclamo#' as Reclamo
			</cfif>

	from DDocumentosRecepcion ddr
		inner join EDocumentosRecepcion edr
			on edr.Ecodigo = ddr.Ecodigo
			and edr.EDRid = ddr.EDRid
		
		left outer join Monedas mon
			on edr.Mcodigo = mon.Mcodigo
			and edr.Ecodigo = mon.Ecodigo
	
		inner join SNegocios sn
			on sn.SNcodigo=edr.SNcodigo
			and sn.Ecodigo=edr.Ecodigo

	 	inner join DOrdenCM o
			on o.Ecodigo=ddr.Ecodigo
			and o.DOlinea=ddr.DOlinea
			
		inner join EOrdenCM p
			on o.EOidorden = p.EOidorden
			and o.Ecodigo = p.Ecodigo
	

<!---Impuestos de la orden de compra---->
	  		left outer join Impuestos imp
				on imp.Ecodigo=o.Ecodigo
				and imp.Icodigo=o.Icodigo

		  	left outer join Articulos a
				on a.Ecodigo=ddr.Ecodigo
				and a.Aid=ddr.Aid

				left outer join Clasificaciones clas
					on clas.Ccodigo = a.Ccodigo
					and clas.Ecodigo = a.Ecodigo

		<!--- Factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->			
			left outer join ConversionUnidadesArt cua
				on cua.Aid = a.Aid
				and a.Ucodigo = ddr.Ucodigo
				and cua.Ucodigo = o.Ucodigo
				and cua.Ecodigo = ddr.Ecodigo
					
		<!--- Factor de conversion de factura a orden --->
		left outer join ConversionUnidades cu
			on cu.Ecodigo = ddr.Ecodigo
			and cu.Ucodigo = ddr.Ucodigo
			and cu.Ucodigoref = o.Ucodigo					

	 	 left outer join Conceptos c
			on c.Ecodigo=ddr.Ecodigo
			and c.Cid=ddr.Cid

		<!---Impuestos del documento de recepcion--->
	  	left outer join Impuestos i
			on i.Ecodigo = ddr.Ecodigo
			and i.Icodigo = ddr.Icodigo
				
		<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) neq 0>
		inner join NumParteProveedor npp
			on a.Aid = npp.Aid
			and a.Ecodigo = npp.Ecodigo
			and p.SNcodigo = npp.SNcodigo
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				between npp.Vdesde and npp.Vhasta
		<cfelse>
		left outer join NumParteProveedor npp
			on a.Aid = npp.Aid
			and a.Ecodigo = npp.Ecodigo
			and p.SNcodigo = npp.SNcodigo
			and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				between npp.Vdesde and npp.Vhasta
		</cfif>

	where ddr.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDRid#">
		and ddr.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and ddr.DDRaprobtolerancia = 5
		<cfif isdefined("form.numparteF") and len(trim(form.numparteF)) neq 0>
			and Upper(npp.NumeroParte) like Upper('%#form.numparteF#%')
		</cfif>
		<cfif isdefined("form.DOalternaF") and len(trim(form.DOalternaF)) neq 0>
			and Upper(o.DOalterna) like Upper('%#form.DOalternaF#%')
		</cfif>
		<cfif isdefined("form.DOobservacionesF") and len(trim(form.DOobservacionesF)) neq 0>
			and Upper(o.DOobservaciones) like Upper('%#form.DOobservacionesF#%')
		</cfif>
		<cfif isdefined("form.AcodigoF") and len(trim(form.AcodigoF)) neq 0>
			and Upper(a.Acodigo) like Upper('%#form.AcodigoF#%')
		</cfif>
		<cfif isdefined("form.DOdescripcionF") and len(trim(form.DOdescripcionF)) neq 0>
			and Upper(o.DOdescripcion) like Upper('%#form.DOdescripcionF#%')
		</cfif>
		<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
			and p.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
		</cfif>
	order by npp.NumeroParte, a.Acodigo, ddr.DDRtipoitem
</cfquery>

<cfset contador1 = 1>
<cfloop query="rsListaDetalles">
	<cfset LvarListaNon = (CurrentRow MOD 2)>
		<cfset lineaReclamo = 0>
		<cfset idPoliza = 0>

		<cfif rsListaDetalles.EDRestado eq 10 and rsListaDetalles.DOcantsaldo gt 0>
							
			<cfset lineaReclamo = calcularReclamo(rsListaDetalles.DDRcantorigen, rsListaDetalles.DDRpreciou, rsListaDetalles.DDRdescporclin,
																  rsListaDetalles.Iporcentaje, rsListaDetalles.DOcantsaldo, rsListaDetalles.DDRprecioorig,
																  rsListaDetalles.DOporcdesc, rsListaDetalles.IporcentajeOC, rsListaDetalles.DDRcantrec,
																  rsListaDetalles.Ctolerancia, rsListaDetalles.Mcodigo, rsListaDetalles.McodigoOC,
																  rsListaDetalles.EDRtc, rsListaDetalles.EOtc, rsListaDetalles.factorConversionU, 
																  rsListaDetalles.DDRtipoitem, rsListaDetalles.ArticuloTieneTolerancia,idPoliza,rsListaDetalles.DDRaprobtolerancia)>
		<cfelseif rsListaDetalles.EDRestado eq 10 and rsListaDetalles.DOcantsaldo lte 0>
			
			<cfset lineaReclamo = calcularReclamo(rsListaDetalles.DDRcantorigen, rsListaDetalles.DDRpreciou, rsListaDetalles.DDRdescporclin,
																  rsListaDetalles.Iporcentaje, rsListaDetalles.DOcantidad, rsListaDetalles.DDRprecioorig,
																  rsListaDetalles.DOporcdesc, rsListaDetalles.IporcentajeOC, rsListaDetalles.DDRcantrec,
																  rsListaDetalles.Ctolerancia, rsListaDetalles.Mcodigo, rsListaDetalles.McodigoOC,
																  rsListaDetalles.EDRtc, rsListaDetalles.EOtc, rsListaDetalles.factorConversionU, 
																  rsListaDetalles.DDRtipoitem, rsListaDetalles.ArticuloTieneTolerancia,idPoliza,rsListaDetalles.DDRaprobtolerancia)>														 
		<cfelse>
			
			<cfset lineaReclamo = calcularReclamo(rsListaDetalles.DDRcantorigen, rsListaDetalles.DDRpreciou, rsListaDetalles.DDRdescporclin,
																  rsListaDetalles.Iporcentaje, rsListaDetalles.DOcantsaldo, rsListaDetalles.DDRprecioorig,
																  rsListaDetalles.DOporcdesc, rsListaDetalles.IporcentajeOC, rsListaDetalles.DDRcantrec,
																  rsListaDetalles.Ctolerancia, rsListaDetalles.Mcodigo, rsListaDetalles.McodigoOC,
																  rsListaDetalles.EDRtc, rsListaDetalles.EOtc, rsListaDetalles.factorConversionU, 
																  rsListaDetalles.DDRtipoitem, rsListaDetalles.ArticuloTieneTolerancia,idPoliza,rsListaDetalles.DDRaprobtolerancia)>
		
		</cfif>
		<cfset LvarlineaReclamo = lineaReclamo[1]>
		<cfset LvarlineaUnidadesNoRecibidas = lineaReclamo[5]>
		<cfset LvarlineaUnidadesReclamo = lineaReclamo[4]>

	<cfoutput>
		<cfset QuerySetCell(rsListaDetalles,"Exceso","#LvarlineaUnidadesReclamo#",contador1)>
	</cfoutput>
		<cfset contador1 = contador1 + 1>
</cfloop>

<style type="text/css">
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cfoutput>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<!--- Filtro de la lista de detalles --->
	<tr>
		<td>
		<form name="formFiltroDet" method="post" action="docsAprobarExcTolerancia.cfm">
			<input type="hidden" name="EDRid" id="EDRid" value="#form.EDRid#">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
				<tr>
					<!--- Número de parte --->
					<td align="right" nowrap><strong>N&uacute;mero de Parte: </strong></td>
					<td><input type="text" name="numparteF" id="numparteF" value="<cfif isdefined('form.numparteF') and len(trim(form.numparteF)) gt 0>#form.numparteF#</cfif>"></td>
					
					<!--- Código de artículo --->
					<td align="right" nowrap><strong>C&oacute;digo de Articulo:</strong></td>
					<td><input type="text" name="AcodigoF" id="AcodigoF" value="<cfif isdefined('form.AcodigoF') and len(trim(form.AcodigoF)) gt 0>#form.AcodigoF#</cfif>"></td>
					
					<!--- Descripción --->
					<td align="center" valign="middle"><strong>Descripci&oacute;n:</strong></td>
					<td align="center" valign="middle"><input name="DOdescripcionF" id="DOdescripcionF" value="<cfif isdefined('form.DOdescripcionF') and len(trim(form.DOdescripcionF)) gt 0>#form.DOdescripcionF#</cfif>" type="text" size="30" maxlength="255"></td>
				</tr>
				<tr>
					<!--- Descripción alterna --->
					<td align="right" nowrap><strong>Descripci&oacute;n Alterna: </strong></td>
					<td><input name="DOalternaF" id="DOalternaF" value="<cfif isdefined('form.DOalternaF') and len(trim(form.DOalternaF)) gt 0>#form.DOalternaF#</cfif>" type="text" size="30" maxlength="1024"></td>
					
					<!--- Observaciones --->
					<td align="right" nowrap><strong>Observaciones:</strong></td>
					<td><input name="DOobservacionesF" id="DOobservacionesF" value="<cfif isdefined('form.DOobservacionesF') and len(trim(form.DOobservacionesF)) gt 0>#form.DOobservacionesF#</cfif>" type="text" size="30" maxlength="255"></td>
					
					<!--- Botón de filtro --->
					<td rowspan="2" align="center" valign="middle"><input type="submit" name="btnFiltro" value="Filtrar"></td>
					
					<!--- Botón de limpiar --->
					<td rowspan="2" align="center" valign="middle"><input type='button' onClick="javascript: limpiaFiltro();" name="btnLimpiar" value="Limpiar"></td>
				</tr>
				<tr>
					<!--- Comprador --->
					<td align="right"><strong>Comprador:&nbsp;</strong></td>
					<td>
						<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1)) gt 0>
							<cfquery name="rsCompradorFiltro" datasource="#session.dsn#">
								select CMCid, CMCcodigo, CMCnombre
								from CMCompradores
								where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid1#">
							</cfquery>
						</cfif>
						<input type="text" name="CMCcodigo1" maxlength="10" value="<cfif isdefined('rsCompradorFiltro') and rsCompradorFiltro.RecordCount gt 0>#rsCompradorFiltro.CMCcodigo#</cfif>" size="10" onBlur="javascript:comprador(this.value);">
						<input type="text" name="CMCnombre1" id="CMCnombre1" readonly value="<cfif isdefined('rsCompradorFiltro') and rsCompradorFiltro.RecordCount gt 0>#rsCompradorFiltro.CMCnombre#</cfif>" size="40" maxlength="80">
						<input type="hidden" name="CMCid1" id="CMCid1" value="<cfif isdefined('rsCompradorFiltro') and rsCompradorFiltro.RecordCount gt 0>#rsCompradorFiltro.CMCid#</cfif>">
						<a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores();'></a>
					</td>

					<!--- Filtro de líneas, reclamo --->
					<td align="right"><strong>Mostrar líneas:&nbsp;</strong></td>
					<td>
						<select name="Reclamo" id="Reclamo">
							<option value="0" <cfif not isdefined("form.Reclamo") or form.Reclamo eq 0>selected</cfif>>Todas</option>
							<option value="1" <cfif isdefined("form.Reclamo") and form.Reclamo eq 1>selected</cfif>>Generen reclamo</option>
							<option value="2" <cfif isdefined("form.Reclamo") and form.Reclamo eq 2>selected</cfif>>No generen reclamo</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
		
		<iframe name="frCompradores" id="frCompradores" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src=""></iframe>
		
		<script language="javascript" type="text/javascript">
			var popUpWin = 0;
			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin){
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
			}

			function limpiaFiltro(){
				document.formFiltroDet.numparteF.value = '';
				document.formFiltroDet.DOalternaF.value = '';
				document.formFiltroDet.DOobservacionesF.value = '';
				document.formFiltroDet.AcodigoF.value = '';
				document.formFiltroDet.DOdescripcionF.value = '';
				document.formFiltroDet.CMCcodigo1.value = '';
				document.formFiltroDet.CMCnombre1.value = '';
				document.formFiltroDet.CMCid1.value = '';
				document.formFiltroDet.Reclamo.value = '0';
			}
			
			//Conlis de compradores 
			function doConlisCompradores(){
				var params = "";
					params = "?formulario=formFiltroDet&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function comprador(value){
				if (value != ''){
					document.getElementById("frCompradores").src = "/cfmx/sif/cm/consultas/CompradoresConsulta.cfm?formulario=formFiltroDet&CMCcodigo="+value+"&opcion=1";
				}
				else{
					document.form1.CMCid1.value = '';
					document.form1.CMCcodigo1.value = '';
					document.form1.CMCnombre1.value = '';
				}
			}
		</script>
		</td>
	</tr>
	
	<!--- Lista de detalles --->
	<tr>
		<td>
 			<cfinvoke component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsListaDetalles#"/>
				<cfinvokeargument name="desplegar" value="DOconsecutivo, DOdescripcion, NumeroParte, DOcantidad, DOcantsaldo, Ctolerancia, CantidadPermitida, DDRcantorigen, DDRcantrec, Exceso, GeneraReclamo"/>
				<cfinvokeargument name="etiquetas" value="Linea, Item, Num. Parte, Cantidad OC, Saldo, %Tolerancia, Cantidad Permitida, Cantidad Factura, Cantidad Recibida, Exceso, Genera reclamo"/>
				<cfinvokeargument name="formatos" value="I,S,S,M,M,M,M,M,M,M,S"/>
				<cfinvokeargument name="align" value="center,left,right,right,right,center,right,right,right,right,right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="MaxRows" value="10"/>
				<cfinvokeargument name="keys" value="DDRlinea"/>
				<cfinvokeargument name="cortes" value="descOrden"/>
				<cfinvokeargument name="irA" value="docsAprobarExcTolerancia.cfm"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			</cfinvoke>
		</td>
	</tr>
	
	<!--- Detalle de recepción --->
	<tr>
		<td align="center">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cfinclude template="docsAprobarExcTolerancia-formdet.cfm">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</cfoutput>
