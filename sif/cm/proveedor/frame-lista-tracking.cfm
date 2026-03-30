<cfset pagina = GetFileFromPath(GetTemplatePath())>

<!---<cfset index = "">--->
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.idx")>
	<cfset index = Url.idx>
<cfelseif not isdefined("url.idx")  and not isdefined("form.idx") and not isdefined("index")>	
	<cfset index = ''>
</cfif>

<!---<cfset nameForm = "">----->
<cfif isdefined("Url.nameForm") and Len(Trim(Url.nameForm)) and not isdefined("Form.nameForm")>
	<cfset Form.nameForm = Url.nameForm>
</cfif>
<cfif isdefined("Form.nameForm") and Len(Trim(Form.nameForm))>
	<cfset nameForm = Form.nameForm>
<cfelse>
	<cfset nameForm = 'form1'>
</cfif>
<cfif isdefined("url.fESnumeroD") and not isdefined("form.fESnumeroD") >
	<cfset form.fESnumeroD = url.fESnumeroD >
</cfif>

<cfif isdefined("url.fESnumeroH") and not isdefined("form.fESnumeroH") >
    <cfset form.fESnumeroH = url.fESnumeroH >
</cfif>
<cfif isdefined("url.DetalleTransito")>
	<cfset form.DetalleTransito = url.DetalleTransito>
</cfif>
<cfif isdefined("url.validaEstado")>
	<cfset form.validaEstado = url.validaEstado>
</cfif>
<cfif isdefined("url.validaFacturado")>
	<cfset form.validaFacturado = url.validaFacturado>
</cfif>
<cfif isdefined("url.validaPoliza")>
	<cfset form.validaPoliza = url.validaPoliza>
</cfif>
<cfif isdefined("url.ETidtrackingActual")>
	<cfset form.ETidtrackingActual = url.ETidtrackingActual>
</cfif>

<cfset ent = "">
<cfif isdefined("Form.ent") and Len(Trim(Form.ent))>
	<cfset ent = Form.ent>
<cfelseif isdefined("Url.ent") and Len(Trim(Url.ent)) and not isdefined("Form.ent")>
	<cfset ent = Url.ent>
</cfif>

<cfset navegacion = "">

<cfif isdefined("Url.fETconsecutivo") and not isdefined("Form.fETconsecutivo")>
	<cfset Form.fETconsecutivo = Url.fETconsecutivo>
</cfif>
<cfif isdefined("Url.fETnumtracking") and not isdefined("Form.fETnumtracking")>
	<cfset Form.fETnumtracking = Url.fETnumtracking>
</cfif>
<cfif isdefined("Url.fETfechasalida") and not isdefined("Form.fETfechasalida")>
	<cfset Form.fETfechasalida = Url.fETfechasalida>
</cfif>
<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) >
	<cfset navegacion = navegacion & "&fESnumeroD=#form.fESnumeroD#">
</cfif>
<cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) >
    <cfset navegacion = navegacion & "&fESnumeroH=#form.fESnumeroH#">
</cfif>
<cfif isdefined("form.fETconsecutivo") and len(trim(form.fETconsecutivo)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fETconsecutivo=#form.fETconsecutivo#">
</cfif>
<cfif isdefined("form.fETnumtracking") and len(trim(form.fETnumtracking)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fETnumtracking=#form.fETnumtracking#">
</cfif>
<cfif isdefined("form.fETfechasalida") and len(trim(form.fETfechasalida)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fETfechasalida=#form.fETfechasalida#">
</cfif>
<cfif isdefined("index") and len(trim(index)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "index=#index#">
</cfif>
<cfif isdefined("nameForm") and len(trim(nameForm)) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "nameForm=#nameForm#">
</cfif>
<cfif isdefined("form.DetalleTransito")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "DetalleTransito=#form.DetalleTransito#">
</cfif>
<cfif isdefined("form.validaEstado")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "validaEstado=#form.validaEstado#">
</cfif>
<cfif isdefined("form.validaFacturado")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "validaFacturado=#form.validaFacturado#">
</cfif>
<cfif isdefined("form.validaPoliza")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "validaPoliza=#form.validaPoliza#">
</cfif>
<cfif isdefined("form.ETidtrackingActual")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ETidtrackingActual=#form.ETidtrackingActual#">
</cfif>

<cfif isdefined("form.DetalleTransito")><!-----Conlis que se muestra cuando el tipo de transaccion es Nota debito o nota crédito y es fletes o seguros------>
	<cfquery name="rsLista" datasource="#session.dsn#">
		select distinct a.cncache,		
				a.Ecodigo,
				a.EOidorden,
				a.ETidtracking, 
				a.ETconsecutivo,
				a.ETnumtracking, 
				'' as EOnumero,
				'' as Observaciones,
				a.CRid, 
				'' as CRdescripcion, 
				a.ETnumreferencia, 
				a.ETfechasalida, 
				a.ETfechaestimada, 
				a.ETfechaentrega
		from ETracking a
			inner join ETrackingItems b
				on a.ETidtracking = b.ETidtracking
				and a.Ecodigo = b.Ecodigo
				and b.DOlinea in (select a.DOlinea
                                            from CMDetalleTransito a
                                                inner join EDocumentosI b
                                                	inner join EOrdenCM eo
                                                    	on eo.EOidorden = b.EOidorden
                                                         <!--- Filtro por OC -------------------------------------->
														<cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
                                                            <cfif form.fESnumeroD  GT form.fESnumeroH>
                                                                and eo.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                                                and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                            <cfelseif form.fESnumeroD EQ form.fESnumeroH>
                                                                and eo.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                            <cfelse>
                                                                and eo.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                                and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                                            </cfif>
                                                        </cfif>
                                                        <cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and not (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
                                                            and eo.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                        </cfif>
                                                        <cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) and not (isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD))) >
                                                            and eo.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                                        </cfif>
                                                        <!------------------------------------------------------------->
                                                    on a.EDIid = b.EDIidRef 
                                                    and a.Ecodigo = b.Ecodigo
                                                    and b.EDItipo = 'F'	
                                            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
									)
                     
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">						
			<cfif not isdefined("form.validaEstado") or len(trim(form.validaEstado)) eq 0 or form.validaEstado neq 0>
				<cfif isdefined("ent") and Len(Trim(ent)) and ent EQ '1'>
					and a.ETestado in ('T', 'E')
				<cfelseif isdefined("ent") and Len(Trim(ent)) and ent EQ '2'>
					and a.ETestado = 'E'
				<cfelse>
					and a.ETestado <> 'E'
				</cfif>
			</cfif>
			<cfif isdefined("form.fETconsecutivo") and Len(Trim(form.fETconsecutivo))>
				and a.ETconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fETconsecutivo#">
			</cfif>
			<cfif isdefined("form.fETnumtracking") and Len(Trim(form.fETnumtracking))>
				and a.ETnumtracking like '%#form.fETnumtracking#%'
			</cfif>
			<cfif isdefined("form.fETfechasalida") and Len(Trim(form.fETfechasalida))>
				and a.ETfechasalida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fETfechasalida)#">
			</cfif>
			and (
					select sum(ETIcantidad)
					from ETrackingItems eti1
					where eti1.ETidtracking = a.ETidtracking
						and eti1.Ecodigo = a.Ecodigo
				)
				=
				(
					select sum(ETcantfactura)
					from ETrackingItems eti2
					where eti2.ETidtracking = a.ETidtracking
						and eti2.Ecodigo = a.Ecodigo
				)
			and (
					select sum(ETcantfactura)
					from ETrackingItems eti2
					where eti2.ETidtracking = a.ETidtracking
						and eti2.Ecodigo = a.Ecodigo
				)
				>
				0
			and a.ETidtracking not in (
				select <cf_dbfunction name="to_char" args="epd.EPembarque">
				from EPolizaDesalmacenaje epd
				where epd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and epd.EPDestado = 0
			)
		order by a.ETconsecutivo
	</cfquery>
<cfelse>
	<cfquery name="rsLista" datasource="#session.dsn#">
		select distinct 	
        		a.cncache,
				a.Ecodigo,
				a.EOidorden,
				a.ETidtracking, 
				a.ETconsecutivo,
				a.ETnumtracking, 
				'' as EOnumero,
				'' as Observaciones,
				a.CRid, '' as CRdescripcion, a.ETnumreferencia, 
				a.ETfechasalida, a.ETfechaestimada, a.ETfechaentrega
		from ETracking a
			<!--- Filtro por OC --->
            left join ETrackingItems b
                on a.ETidtracking = b.ETidtracking
                and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			<cfif not isdefined("form.validaEstado") or len(trim(form.validaEstado)) eq 0 or form.validaEstado neq 0>
				<cfif isdefined("ent") and Len(Trim(ent)) and ent EQ '1'>
					and a.ETestado in ('T', 'E')
				<cfelseif isdefined("ent") and Len(Trim(ent)) and ent EQ '2'>
					and a.ETestado = 'E'
				<cfelse>
					and a.ETestado <> 'E'
				</cfif>
			</cfif>
			<cfif isdefined("form.fETconsecutivo") and Len(Trim(form.fETconsecutivo))>
				and a.ETconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fETconsecutivo#">
			</cfif>
			<cfif isdefined("form.fETnumtracking") and Len(Trim(form.fETnumtracking))>
				and a.ETnumtracking like '%#form.fETnumtracking#%'
			</cfif>
			<cfif isdefined("form.fETfechasalida") and Len(Trim(form.fETfechasalida))>
				and a.ETfechasalida = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fETfechasalida)#">
			</cfif>
			<cfif isdefined("form.ETidtrackingActual") and Len(Trim(form.ETidtrackingActual))>
				and a.ETidtracking <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETidtrackingActual#">
			</cfif>
            and b.DOlinea in (select do.DOlinea
                                        from DOrdenCM do
                                        where do.DOlinea = b.DOlinea
                                        <!--- Filtro por OC --->
                                            <cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
                                                <cfif form.fESnumeroD  GT form.fESnumeroH>
                                                    and do.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                                    and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                <cfelseif form.fESnumeroD EQ form.fESnumeroH>
                                                    and do.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                <cfelse>
                                                    and do.EOnumero between <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                                    and <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                                </cfif>
                                            </cfif>
                                            <cfif isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD)) and not (isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH))) >
                                                and do.EOnumero >= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroD#">
                                            </cfif>
                                            <cfif isdefined("form.fESnumeroH") and len(trim(form.fESnumeroH)) and not (isdefined("form.fESnumeroD") and len(trim(form.fESnumeroD))) >
                                                and do.EOnumero <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fESnumeroH#">
                                            </cfif>)
			<cfif isdefined("form.validaFacturado") and form.validaFacturado eq 1>
				and (
						select sum(ETIcantidad + ETcantrecibida)
						from ETrackingItems eti1
						where eti1.ETidtracking = a.ETidtracking
							and eti1.Ecodigo = a.Ecodigo
					)
					=
					(
						select sum(ETcantfactura)
						from ETrackingItems eti2
						where eti2.ETidtracking = a.ETidtracking
							and eti2.Ecodigo = a.Ecodigo
					)
				and (
						select sum(ETcantfactura)
						from ETrackingItems eti2
						where eti2.ETidtracking = a.ETidtracking
							and eti2.Ecodigo = a.Ecodigo
					)
					>
					0
			</cfif>
			<cfif isdefined("form.validaPoliza") and form.validaPoliza eq 1>
				and a.ETidtracking not in (
					select <cf_dbfunction name="to_number" args="epd.EPembarque"> 
					from EPolizaDesalmacenaje epd
					where epd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and epd.EPDestado = 0
				)
			</cfif>
		order by a.ETconsecutivo
	</cfquery>
</cfif>

<cfquery name="rsCourier" datasource="sifcontrol">
	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.EcodigoSDC#">

	union

	select CRid, CRcodigo, CRdescripcion
	from Courier
	where CEcodigo is null
	and Ecodigo is null
	and EcodigoSDC is null

	order by 2
</cfquery>
<cfif rsCourier.recordCount GT 0>
	<cfset listaCRid = ValueList(rsCourier.CRid, ',')>
	<cfset listaCRdesc = ValueList(rsCourier.CRdescripcion, ',')>
<cfelse>
	<cfset crid = "">
	<cfset crdesc = "">
</cfif>

<!--- Actualizacion de la descripcion de los courier en la lista de trackings --->
<cfset LvarOrdenes = "">
<cfloop query="rsLista">
	<cfquery name="rsOrden" datasource="#rsLista.cncache#">
		select EOnumero, Observaciones
		from EOrdenCM
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsLista.Ecodigo#">
		and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
	</cfquery> 
	<cfquery name="rsOrdenes" datasource="#rsLista.cncache#">
        select distinct d.EOnumero 
        from ETrackingItems a 
            inner join ETracking b 
                on a.ETidtracking = b.ETidtracking 	 
            inner join DOrdenCM d
                on d.DOlinea = a.DOlinea
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.Ecodigo#"> 	 
            and a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.ETidtracking#"> 	  	 
            and a.ETIestado = 0 	 
        group by d.EOnumero
     </cfquery>
	<cfset cont = 0>
    <cfloop query="rsOrdenes">
		 <cfif LvarOrdenes neq "" and rsOrdenes.recordcount gt 0>
         	<cfif cont LT 3>
            	<cfset LvarOrdenes = LvarOrdenes&"|"&rsOrdenes.EOnumero>
            	<cfset cont = cont+1>
            <cfelse>
            	    <cfset LvarOrdenes = LvarOrdenes&"<br>"&rsOrdenes.EOnumero>
            		<cfset cont = 0>
            </cfif>
        <cfelse>
            <cfset LvarOrdenes = LvarOrdenes&rsOrdenes.EOnumero>    
            <cfset cont = cont+1>
        </cfif> 
    </cfloop>
	<cfset QuerySetCell(rsLista, "EOnumero", LvarOrdenes, currentRow)>
	<cfset QuerySetCell(rsLista, "Observaciones", rsOrden.Observaciones, currentRow)>

	<cfif Len(Trim(rsLista.CRid))>
		<cfset pos = ListFind(listaCRid, rsLista.CRid, ",")>
		<cfif pos NEQ 0>
			<cfset QuerySetCell(rsLista, "CRdescripcion", ListGetAt(listaCRdesc, pos, ','), currentRow)>
		</cfif>
	</cfif>
    <cfset LvarOrdenes="">
</cfloop>

<cfoutput>

	<script language="JavaScript" type="text/javascript">

		<cfif CompareNoCase(pagina, "ConlisTrackings.cfm") EQ 0>
		function Asignar<cfoutput>#index#</cfoutput>(ETidtracking, ETnumtracking, ETconsecutivo) {
			if (window.opener != null) {
				window.opener.document.<cfoutput>#nameForm#</cfoutput>.ETconsecutivo_move<cfoutput>#index#</cfoutput>.value = ETconsecutivo;
				window.opener.document.<cfoutput>#nameForm#</cfoutput>.ETidtracking_move<cfoutput>#index#</cfoutput>.value = ETidtracking;
				window.opener.document.<cfoutput>#nameForm#</cfoutput>.ETnumtracking_move<cfoutput>#index#</cfoutput>.value = ETnumtracking;
				window.close();
			}
		}
		</cfif>
		
		function funcNuevo() {
			document.<cfoutput>#nameForm#</cfoutput>.ETIDTRACKING.value = "";
		}
		
		function esNumero(evento)
		{		
			evento = (evento) ? evento : event;
			var charCode = (evento.charCode) ? evento.charCode : ((evento.keyCode) ? evento.keyCode : ((evento.which) ? evento.which : 0));
			var res = true;
			if (charCode > 31 && (charCode < 48 || charCode > 57)){res= false;}
			return res;
		}
	</script>
	
	<table width="99%" align="center" border="0" cellspacing="0" cellpadding="2">
		<tr>
			<td>
			  <form name="filtro" method="post" action="#pagina#">
			  	<cfif isdefined('form.nameForm') and form.nameForm NEQ ''>
					<input type="hidden" name="nameForm" value="#form.nameForm#">
				</cfif>
			  	<cfif Len(Trim(index))>
				<input type="hidden" name="idx" value="#index#">
				</cfif>
			  	<cfif Len(Trim(ent))>
				<input type="hidden" name="ent" value="#ent#">
				</cfif>
				<cfif isdefined("form.DetalleTransito")>
					<input type="hidden" name="DetalleTransito" value="#form.DetalleTransito#">
				</cfif>
				<cfif isdefined("form.validaEstado")>
					<input type="hidden" name="validaEstado" value="#form.validaEstado#">
				</cfif>
				<cfif isdefined("form.validaFacturado")>
					<input type="hidden" name="validaFacturado" value="#form.validaFacturado#">
				</cfif>
				<cfif isdefined("form.validaPoliza")>
					<input type="hidden" name="validaPoliza" value="#form.validaPoliza#">
				</cfif>
				<cfif isdefined("form.ETidtrackingActual")>
					<input type="hidden" name="ETidtrackingActual" value="#form.ETidtrackingActual#">
				</cfif>
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
                  <tr>
					<td class="fileLabel" align="right" nowrap>
						<strong>No. Tracking:</strong>
					</td>
					<td>
						<input type="text" name="fETconsecutivo" size="30" maxlength="20" value="<cfif isdefined('form.fETconsecutivo')><cfoutput>#form.fETconsecutivo#</cfoutput></cfif>">
					</td>

					<td class="fileLabel" align="right" nowrap>
						<strong>No. Control:</strong>
					</td>
					<td>
						<input type="text" name="fETnumtracking" size="30" maxlength="20" value="<cfif isdefined('form.fETnumtracking')><cfoutput>#form.fETnumtracking#</cfoutput></cfif>">
					</td>
											
					<td class="fileLabel" align="right" nowrap>
						<strong>Fecha Salida:</strong>
					</td>
					<td>
						<cfif isdefined('form.fETfechasalida')>
							<cfset fsalida = form.fETfechasalida>
						<cfelse>
							<cfset fsalida = "">
						</cfif>
						<cf_sifcalendario name="fETfechasalida" form="filtro" value="#fsalida#">
					</td>
				  </tr>
                   <tr>
                        <td  class="fileLabel" align="center" colspan="2" nowrap>
                           <fieldset>
                                <legend>Ordenes</legend>
                                <strong>Del N&uacute;mero:&nbsp;</strong>
                                <input type="text" name="fEsnumeroD" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroD')><cfoutput> #form.fESnumeroD# </cfoutput></cfif>" onkeypress="return esNumero(event);"> &nbsp;
                                <strong>Al N&uacute;mero:&nbsp;</strong>
                                <input type="text" name="fEsnumeroH" size="10" maxlength="100" value="<cfif isdefined('form.fESnumeroH')><cfoutput> #form.fESnumeroH# </cfoutput></cfif>" onkeypress="return esNumero(event);"> &nbsp;
                            </fieldset>
                        </td>
                        <td align="center">
                            <input type="submit" name="btnBuscar" class="btnNormal" value="Buscar">
                        </td>	
                  </tr>
				</table>
			  </form>
			</td>
		</tr>
		<tr>
			<td>
				<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#rsLista#"/>
					<cfinvokeargument name="desplegar" value="ETconsecutivo, ETnumtracking, EOnumero, CRdescripcion, ETnumreferencia, ETfechasalida, ETfechaestimada, ETfechaentrega"/>
					<cfinvokeargument name="etiquetas" value="No. Tracking, No. Control, No. Orden, Courier, Courier Tracking, Fecha Salida, Fecha Estimada, Fecha Entrega"/>
					<cfinvokeargument name="formatos" value="V,V,V,V,V,D,D,D"/>
					<cfinvokeargument name="align" value="left, left, left, left, left, center, center, center"/>
	
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="formName" value="#nameForm#"/>
					<cfinvokeargument name="checkboxes" value="N"/>
					<cfinvokeargument name="maxRows" value="15"/>
					<cfif isdefined("paginaSQL") and Len(Trim(paginaSQL))>
					<cfinvokeargument name="irA" value="#paginaSQL#"/>
					<cfelse>
					<cfinvokeargument name="irA" value="#pagina#"/>
					</cfif>
					
					<cfif CompareNoCase(pagina, "ConlisTrackings.cfm") EQ 0>
					<cfinvokeargument name="funcion" value="Asignar#index#"/>
					<cfinvokeargument name="fparams" value="ETidtracking, ETnumtracking,ETconsecutivo"/>
					</cfif>
	
					<cfinvokeargument name="keys" value="ETidtracking"/>
					<cfinvokeargument name="debug" value="N"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
				</cfinvoke>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>

</cfoutput>