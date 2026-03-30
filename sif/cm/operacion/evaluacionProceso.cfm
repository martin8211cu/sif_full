<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cftransaction>
	<cfinclude template="cotizaciones-calculoNotas.cfm">
	<cfif not isdefined("Session.Compras.OrdenCompra") and not lvarProcesar>
		<!--- Sugerencia de Evaluación según el tipo de evaluación solicitado por el usuario --->
		<cfquery name="resetSugerencia" datasource="#Session.DSN#">
			update CMResultadoEval set
				CMRsugerido = 0, 
				CMRseleccionado = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
			and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		</cfquery>
		<!--- Método Total --->
		<cfif isdefined("form.metodo") and (form.metodo EQ 'C')>
			<cfquery name="updSugerencia" datasource="#Session.DSN#">
				update CMResultadoEval set
					CMRsugerido = 1, 
					CMRseleccionado = 0
				where ECid = 
				(
					select min(x.ECid)
					from CMResultadoEval x
					where x.NotaGlobal = 
					(
						select max(y.NotaGlobal)
						from CMResultadoEval y
						where y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
						and y.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					)
					and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
					and x.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				)
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			</cfquery>
		
		<!--- Método por Línea de Cotización --->
		<cfelseif isdefined("form.metodo") and (form.metodo EQ 'L')>
	
			<cfquery name="updSugerencia" datasource="#Session.DSN#">
				update CMResultadoEval set
					CMRsugerido = 1, 
					CMRseleccionado = 0
				where DClinea = 
				(
					select min(x.DClinea)
					from CMResultadoEval x
					where x.DSlinea = CMResultadoEval.DSlinea
					and x.NotaTotalLinea = 
					(
						select max(y.NotaTotalLinea)
						from CMResultadoEval y
						where y.DSlinea = x.DSlinea
						and y.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
						and y.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
					)
					and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
					and x.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
				)
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
				and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
			</cfquery>
		
		</cfif>
	</cfif>

	<cfquery name="rsMejorLinea" datasource="#Session.dsn#">
		select	a.ECid,
				a.DClinea, 
				case when a.NotaTotalLinea > 0 
			       then a.ECnumero
				   else
				   '-'
				   end as  ECnumero,
				a.DCcantidad,
                a.total_loc,
				b.DScant - b.DScantsurt as cantidad, 
				a.NotaTotalLinea,
				case when a.NotaTotalLinea > 0
				    then  sn.SNnumero#_Cat#'-'#_Cat#a.SNnombre
					else 
					'Desierta'
					end as SNnombre,
				a.DSconsecutivo, 
				a.SNcodigo,
				m.Mnombre,
				m.Miso4217,
				a.ECfechacot,
				b.DStipo, 
				b.Aid,			
				b.Cid,
				b.ACcodigo,
				b.ACid,
				b.Ucodigo,
				case b.DStipo when 'A' then ltrim(rtrim(Acodigo))#_Cat#'-'#_Cat#Adescripcion
										when 'S' then  ltrim(rtrim(h.Ccodigo))#_Cat#'-'#_Cat# Cdescripcion
										when 'F' then b.DSdescripcion end as Descripcion,
				a.DSlinea,
				a.NotaTotalLinea,
				a.NotaGlobal,
				#LvarOBJ_PrecioU.enSQL_AS("a.DCpreciou")#,
				es.ESnumero,
                Coalesce(b.DSdescripcion, 'Sin Descripcion') as DescripcionSC, 
                Coalesce(b.DSdescalterna, 'Sin Descripcion Anterna') as DescripcionASC,
                Coalesce(b.DSobservacion, 'Sin Observaciones') as ObservacionesSC
				
		from CMResultadoEval a
        	inner join ECotizacionesCM ec
					on a.ECid = ec.ECid
					and a.Ecodigo = ec.Ecodigo
	
		inner join SNegocios sn
			on a.SNcodigo = sn.SNcodigo 
			and a.Ecodigo = sn.Ecodigo

		inner join DSolicitudCompraCM b
			on a.DSlinea = b.DSlinea
			
			inner join ESolicitudCompraCM es
				on b.ESidsolicitud = es.ESidsolicitud
				and b.Ecodigo = es.Ecodigo			
		
		inner join Monedas m
			on a.Mcodigo = m.Mcodigo
			
		left outer join Articulos f
			on b.Aid=f.Aid
	
		left outer join Conceptos h
			on b.Cid=h.Cid
	
		left outer join ACategoria j
			on b.ACcodigo=j.ACcodigo
			and b.Ecodigo=j.Ecodigo
	
		left outer join AClasificacion k
			on b.ACcodigo=k.ACcodigo
			and b.ACid=k.ACid
			and b.Ecodigo=k.Ecodigo
	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
        <cfif lvarProcesar>
        and (a.CMRseleccionado = 1 or (a.CMRsugerido = 1 and (select count(1) from CMResultadoEval sre where sre.Ecodigo = a.Ecodigo and sre.CMPid = a.CMPid and sre.CMRseleccionado = 1) = 0)) 
        <cfelse>
        and a.CMRsugerido = 1
        </cfif>
	</cfquery>
	<cfquery name="rsMejorCotizacion" datasource="#Session.dsn#">
		<!---- a.SNnombre,---->
		select 	a.ECnumero,
       			ec.ECdescprov, 
                ec.ECobsprov,
				sn.SNnumero#_Cat#'-'#_Cat#a.SNnombre as SNnombre,				
				a.DSconsecutivo,
				a.DCcantidad,
				b.DScant - b.DScantsurt as cantidad,
				a.DCgarantia,
				a.DSlinea,
				a.ECid,
				m.Mnombre,
				m.Miso4217,
				a.ECfechacot,
				b.DStipo,
				b.Aid,			
				b.Cid,
				b.ACcodigo,
				b.ACid,
				b.Ucodigo,
				case b.DStipo 	when 'A' then ltrim(rtrim(f.Acodigo))#_Cat#'-'#_Cat#Adescripcion
								when 'S' then ltrim(rtrim(h.Ccodigo))#_Cat#'-'#_Cat#Cdescripcion
								when 'F' then b.DSdescripcion end as Descripcion,
				a.NotaGlobal,
				a.NotaTotalLinea,
				#LvarOBJ_PrecioU.enSQL_AS("a.DCpreciou")#,
				es.ESnumero,
				ec.ECtotal
		
		from	CMResultadoEval a
						
				inner join ECotizacionesCM ec
					on a.ECid = ec.ECid
					and a.Ecodigo = ec.Ecodigo
					
				inner join SNegocios sn
					on a.SNcodigo = sn.SNcodigo 
					and a.Ecodigo = sn.Ecodigo

				inner join DSolicitudCompraCM b
					on a.DSlinea = b.DSlinea
					
					inner join ESolicitudCompraCM es
						on b.ESidsolicitud = es.ESidsolicitud and b.Ecodigo = es.Ecodigo
					
				inner join Monedas m
					on a.Mcodigo = m.Mcodigo
					
				left outer join Articulos f
					on b.Aid=f.Aid
			
				left outer join Conceptos h
					on b.Cid=h.Cid
			
				left outer join ACategoria j
					on b.ACcodigo=j.ACcodigo and b.Ecodigo=j.Ecodigo
			
				left outer join AClasificacion k
					on b.ACcodigo=k.ACcodigo and b.ACid=k.ACid and b.Ecodigo=k.Ecodigo
	
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#lvarFiltroEcodigo#">
		and a.CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CMPid#">
		<cfif lvarProcesar>
        and (a.CMRseleccionado = 1 or (a.CMRsugerido = 1 and (select count(1) from CMResultadoEval sre where sre.Ecodigo = a.Ecodigo and sre.CMPid = a.CMPid and sre.CMRseleccionado = 1) = 0)) 
        <cfelse>
        and a.CMRsugerido = 1
        </cfif>
	</cfquery>
  	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
	
		<cfif isdefined("form.metodo") and (form.metodo EQ 'L')>		
		function doConlisLineaSolicitud(lineasol, lineacot) {
			var width = 800;
			var height = 400;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			<cfoutput>
			window.open('ConlisLineasSolicitud<cfif lvarSolicitante>-SOL</cfif>.cfm?CMPid=#Form.CMPid#&DSlinea='+lineasol+'&DClinea='+lineacot+'&f=form1&p1=DClinea&p2=DSconsecutivo&<cfif not lvarSolicitante>p3=SNnombre&</cfif>p4=Descripcion&p5=ECnumero&p6=DCcantidad&p7=DCcantidadMax&p8=ECfechacot&p9=Mnombre&p10=DCpreciou&p11=Nota&p12=ESnumero&p13=Ucodigo&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>', 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
			</cfoutput>
		}
		<cfelseif isdefined("form.metodo") and (form.metodo EQ 'C')>
		function doConlisCotizaciones(cotizacion) {
			var width = 800;
			var height = 400;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			<cfoutput>
			window.open('ConlisCotizaciones2<cfif lvarSolicitante>-SOL</cfif>.cfm?CMPid=#Form.CMPid#&ECid='+cotizacion+'&f=form1&p1=ECid&<cfif not lvarSolicitante>p2=SNnombre&</cfif>p3=DSconsecutivo&p4=Descripcion&p5=ECnumero&p6=DCcantidad&p7=DCcantidadMax&p8=ECfechacot&p9=Mnombre&p10=DCpreciou&p11=Nota&p12=NotaGlobal&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>', 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
			</cfoutput>
		}
		</cfif>
	</script>
	
	<form name="form1" method="post" action="<cfif not lvarSolicitante>evaluarCotizaciones.cfm<cfelse>evaluarCotizacionesSolicitante.cfm</cfif>" onSubmit="javascript: return valida(this);">
	<cfoutput>
		<input type="hidden" name="opt" value="">
		<cfif isdefined("Form.CMPid") and Len(Trim(Form.CMPid))>
			<input type="hidden" name="CMPid" value="#Form.CMPid#">
		</cfif>
		<cfif isdefined("Form.metodo") and Len(Trim(Form.metodo))>
			<input type="hidden" name="metodo" value="#Form.metodo#">
		</cfif>
		<cfif isdefined("form.metodo") and (form.metodo EQ 'L')>
		  <input type="hidden" name="DClinea" value="">
		  <table align="center" border="0">
			<tr>
			  <td style="padding-right: 10px;" align="right"><strong>N°.Sol.</strong></td>
			  <td style="padding-right: 10px;" align="right"><strong>N°.Línea</strong></td>
			  <td style="padding-right: 10px;" align="right"><strong>N°.Cotización</strong></td>
			  <cfif not lvarSolicitante><td style="padding-right: 10px;"><strong>Proveedor</strong></td></cfif>
			  <td style="padding-right: 10px;"><strong>Item</strong></td>
              <td style="padding-right: 5px;"><strong>Unidad</strong></td>
			  <td style="padding-right: 10px;" align="right"><strong>Cantidad</strong></td>
			  <td style="padding-right:" align="right"><strong>Precio Uni.</strong></td>
			  <td style="padding-right: 5px;"><strong>Moneda</strong></td>
			  <td style="padding-right: 10px;" align="right"><strong>Nota</strong></td>
              <td style="padding-right: 10px;" align="right" nowrap><strong>Total Ori.</strong></td>
              <td style="padding-right: 10px;" align="right" nowrap><strong>Total Loc.</strong></td>
			  <td style="padding-right: 10px;">&nbsp;</td>
			</tr>
            <cfset TotalLocal = 0>
			<cfloop query="rsMejorLinea">
            	<cfset TotalLocal = TotalLocal + rsMejorLinea.total_loc>
			  <tr>

<!---************  NUMERO DE SOLICITUD  *****************---->								
				<td style="padding-right: 10px;" align="right" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ESnumero_#rsMejorLinea.DSlinea#")>
						<cfset solic = Evaluate("Session.Compras.OrdenCompra.ESnumero_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset solic = rsMejorLinea.ESnumero>
					</cfif>
				  <input size="5" name="ESnumero_#rsMejorLinea.DSlinea#" id="ESnumero_#rsMejorLinea.DSlinea#" tabindex="-1" type="text" value="#solic#" readonly="" style="border-width:0; text-align:right;" >
				</td>
<!---************************************---->				

				<td style="padding-right: 10px;" align="right" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DSconsecutivo_#rsMejorLinea.DSlinea#")>
						<cfset consec = Evaluate("Session.Compras.OrdenCompra.DSconsecutivo_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset consec = rsMejorLinea.DSconsecutivo>
					</cfif>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DClinea_#rsMejorLinea.DSlinea#")>
						<cfset dclin = Evaluate("Session.Compras.OrdenCompra.DClinea_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset dclin = rsMejorLinea.DClinea>
					</cfif>
				  <input size="6" name="DSconsecutivo_#rsMejorLinea.DSlinea#" id="DSconsecutivo_#rsMejorLinea.DSlinea#" tabindex="-1" type="text" value="#consec#" readonly="" style="border-width:0; text-align:right;" >
				  <input type="hidden" name="DClinea_#rsMejorLinea.DSlinea#" value="#dclin#" >
				</td>
				<td style="padding-right: 10px;" align="right" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECnumero_#rsMejorLinea.DSlinea#")>
						<cfset num = Evaluate("Session.Compras.OrdenCompra.ECnumero_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset num = rsMejorLinea.ECnumero>
					</cfif>
					<input size="10" name="ECnumero_#rsMejorLinea.DSlinea#" type="text" value="#Trim(num)#" tabindex="-1" readonly="" style="border-width:0; text-align:right;" >            
				</td>
				<cfif not lvarSolicitante>
				<td style="padding-right: 10px;" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.SNnombre_#rsMejorLinea.DSlinea#")>
						<cfset socio = Evaluate("Session.Compras.OrdenCompra.SNnombre_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset socio = rsMejorLinea.SNnombre>
					</cfif>
				  <input size="40" name="SNnombre_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(socio)#"  tabindex="-1" readonly="" style="border-width:0; <cfif rsMejorLinea.NotaTotalLinea eq 0>color:##FF0000</cfif>" >
				</td>
                </cfif>
				<td style="padding-right: 10px;" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Descripcion_#rsMejorLinea.DSlinea#")>
						<cfset desc = Evaluate("Session.Compras.OrdenCompra.Descripcion_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset desc = rsMejorLinea.Descripcion>
					</cfif>
				  <input size="40" name="Descripcion_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(desc)#" tabindex="-1" readonly="" style="border-width:0" >
				</td>
				<!----►►Unidad◄◄---->
				<td style="padding-right: 10px;" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Ucodigo_#rsMejorLinea.DSlinea#")>
						<cfset codUni = Evaluate("Session.Compras.OrdenCompra.Ucodigo_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset codUni = rsMejorLinea.Ucodigo>
					</cfif>
				  <input size="5" name="Ucodigo_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(codUni)#" tabindex="-1" readonly="" style="border-width:0" >
				</td>
                <!----►►Cantidad◄◄---->
                <cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCcantidad_#rsMejorLinea.DSlinea#")>
					<cfset cant = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.DCcantidad_"&rsMejorLinea.DSlinea), ',9.00')>
                    <cfset cant2 = Evaluate("Session.Compras.OrdenCompra.DCcantidad_"&rsMejorLinea.DSlinea)>
                <cfelse>
                    <cfif rsMejorLinea.DCcantidad  LT rsMejorLinea.cantidad <!---and rsMejorLinea.DCcantidad GT 0----->>
                        <cfset cant = LSNumberFormat(rsMejorLinea.DCcantidad, ',9.00')>							
                        <cfset cant2 = rsMejorLinea.DCcantidad>
                    <cfelse>
                        <cfset cant = LSNumberFormat(rsMejorLinea.cantidad, ',9.00')>
                         <cfset cant2 = rsMejorLinea.cantidad>
                    </cfif>
                </cfif>
				<td style="padding-right: 10px;" align="right" nowrap>
   				 	<input name="DCcantidadMax_#rsMejorLinea.DSlinea#" id="DCcantidadMax_#rsMejorLinea.DSlinea#" type="hidden" value="<cfif rsMejorLinea.DCcantidad  LT rsMejorLinea.cantidad <!---and rsMejorLinea.DCcantidad GT 0---->>#rsMejorLinea.DCcantidad#<cfelse>#rsMejorLinea.cantidad#</cfif>"><!----value="#rsMejorLinea.DCcantidad#"---->
                    <input name="DCcantidad_#rsMejorLinea.DSlinea#" type="text" value="#cant#" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"<cfif lvarSolicitante>readonly style="border-width:0"<cfelse>style="text-align: right;"</cfif>>
				</td>
				<!---►►Costo Unitario◄◄---->
                <cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCpreciou_#rsMejorLinea.DSlinea#")>
					<cfset precio = LvarOBJ_PrecioU.enCF_RPT(Evaluate("Session.Compras.OrdenCompra.DCpreciou_"&rsMejorLinea.DSlinea))>
                <cfelse>
                    <cfset precio = LvarOBJ_PrecioU.enCF_RPT(rsMejorLinea.DCpreciou)>
                </cfif>
                <!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
				<td align="right" nowrap>
					#LvarOBJ_PrecioU.inputNumber("DCpreciou_#rsMejorLinea.DSlinea#", rsMejorLinea.DCpreciou, "1", true, "", "border-width: 0;", "", "")#
				</td>
               
				<td style="padding-right: 5px;" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Mnombre_#rsMejorLinea.DSlinea#")>
						<cfset moneda = Evaluate("Session.Compras.OrdenCompra.Mnombre_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset moneda = rsMejorLinea.Miso4217><!---rsMejorLinea.Mnombre --->
					</cfif>
					<input size="3" name="Mnombre_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(moneda)#" readonly="" style="border-width:0" >
				</td>			
				<td align="right" style="padding-right: 10px;" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Nota_#rsMejorLinea.DSlinea#")>
						<cfset notalinea = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.Nota_"&rsMejorLinea.DSlinea), ',9.00')>
					<cfelse>
						<cfset notalinea = LSNumberFormat(rsMejorLinea.NotaTotalLinea, ',9.00')>
					</cfif>
					<input type="text" name="Nota_#rsMejorLinea.DSlinea#" size="6" value="#notalinea#" readonly="" style="border-width: 0; text-align:right;">
				</td>
                 <!---►►Total Linea Original◄◄---->
                <td nowrap align="right">
                	<cfset numero = rsMejorLinea.DCpreciou>
                	<cfset total3 = (cant2 * numero)>
                    <cfoutput>#LSNumberFormat(total3, ',9.00')#</cfoutput>
                </td>
                 <!---►►Total Linea Local◄◄---->
                <td nowrap align="right">
                	<cfoutput>#LSNumberFormat(rsMejorLinea.total_loc, ',9.00')#</cfoutput>
                </td>
                
                <td>
                <cf_notas position="left" link="<img src='/cfmx/sif/imagenes/info.gif' width='16' height='16' />" titulo="Notas" width="300" pageIndex="#rsMejorLinea.currentRow#" msg="<strong>Descripción:</strong><br>&nbsp;#rsMejorLinea.DescripcionSC#<br><strong>Descripción Alterna:</strong><br>#rsMejorLinea.DescripcionASC#<br><strong>Observaciones:</strong><br>#rsMejorLinea.ObservacionesSC#">
                </td>
                <cfif not (lvarProcesar and lvarSolicitante)>
				<td style="padding-right: 10px;" nowrap> <a href="##" tabindex="-1"><img src="/cfmx/sif/imagenes/iedit.gif" alt="Lista de Lineas de Cotizaci&oacute;n" name="imagen" border="0" align="absmiddle" onClick="javascript:doConlisLineaSolicitud('#rsMejorLinea.DSlinea#', document.form1.DClinea_#rsMejorLinea.DSlinea#.value);"></a> </td>
			  	</cfif>
              </tr>
			</cfloop>
            <tr>
            	<td colspan="8">&nbsp;</td>
                <td colspan="3"><hr /></td>
            </tr>
            <tr>
            	<td colspan="8">&nbsp;</td>
                <td colspan="2" align="right"> <strong>Total Local:</strong></td>
            	<td><cfoutput><strong>#LSNumberFormat(TotalLocal, ',9.00')#</strong></cfoutput></td>
            </tr>
		  </table>
          <cfif lvarSolicitante>
          <table align="center"><tr><td>
          <input type="button" name="btnRegresar" value="Regresar" class="btnAnterior" onclick="window.location='evaluarCotizacionesSolicitante.cfm'" />
          </td></tr></table>
          </cfif>
		</cfif>
	<!--- SI EL METODO SELECCIONADO ES EL DE COTIZACION --->	
		<cfif isdefined("form.metodo") and (form.metodo EQ 'C')>
			<table align="center" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td align="right" nowrap class="fileLabel">Num.Cotizaci&oacute;n:<!-----</td>
					<td nowrap>----->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECnumero")>
							<cfset num = Evaluate("Session.Compras.OrdenCompra.ECnumero")>
						<cfelse>
							<cfset num = rsMejorCotizacion.ECnumero>
						</cfif>
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECid")>
							<cfset coti = Evaluate("Session.Compras.OrdenCompra.ECid")>
						<cfelse>
							<cfset coti = rsMejorCotizacion.ECid>
						</cfif>
						<input size="12" name="ECnumero" type="text" value="#num#" readonly="" style="border-width:0" >
						<input type="hidden" name="ECid" value="#coti#" >
					</td>
                    <cfif not lvarSolicitante>
					<td align="right" nowrap class="fileLabel">Proveedor:<!----</td>
					<td nowrap>----->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.SNnombre")>
							<cfset socio = Evaluate("Session.Compras.OrdenCompra.SNnombre")>
						<cfelse>
							<cfset socio = rsMejorCotizacion.SNnombre>
						</cfif>
						<input size="50" name="SNnombre" type="text" value="#HTMLEditFormat(socio)#" readonly="" style="border-width:0" >
					</td>
                    </cfif>
					<td align="right" nowrap class="fileLabel">Fecha Cot.:<!-----</td><!--- Fecha Cotizaci&oacute;n:---->
					<td nowrap>----->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECfechacot")>
							<cfset fechacot = Evaluate("Session.Compras.OrdenCompra.ECfechacot")>
						<cfelse>
							<cfset fechacot = LSDateFormat(rsMejorCotizacion.ECfechacot, 'dd/mm/yyyy')>
						</cfif>
						<input type="text" size="10" name="ECfechacot" value="#fechacot#" style="border-width:0;">
					</td>
					<td align="right" nowrap class="fileLabel">Monto:<!----</td><!--- Fecha Cotizaci&oacute;n:---->
					<td nowrap>---->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECtotal")>
							<cfset mtototal = Evaluate("Session.Compras.OrdenCompra.ECtotal")>
						<cfelse>
							<cfset mtototal = LSCurrencyFormat(rsMejorCotizacion.ECtotal, 'none')>
						</cfif>
						<input type="text" size="10" name="ECtotal" value="#mtototal#" style="border-width:0;">
					</td>

					<td align="right" nowrap class="fileLabel">Moneda: <!----</td>
					<td nowrap>--->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Mnombre")>
							<cfset moneda = Evaluate("Session.Compras.OrdenCompra.Mnombre")>
						<cfelse>
							<cfset moneda = rsMejorCotizacion.Miso4217><!---rsMejorCotizacion.Mnombre --->
						</cfif>
						<input size="3" name="Mnombre" type="text" value="#HTMLEditFormat(moneda)#" readonly="" style="border-width:0" >
					</td>
					<td align="right" nowrap class="fileLabel">Nota:<!----</td>
					<td nowrap align="left">--->
						<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.NotaGlobal")>
							<cfset notaglobal = LSNumberFormat(Session.Compras.OrdenCompra.NotaGlobal, ',9.00')>
						<cfelse>
							<cfset notaglobal = LSNumberFormat(rsMejorCotizacion.NotaGlobal, ',9.00')>
						</cfif>
						<input type="text" name="NotaGlobal" size="6" value="#notaglobal#" readonly="" style="border-width: 0; ">
					</td>
                    <cfif not (lvarProcesar and lvarSolicitante)>
					<td nowrap>
						&nbsp;<a href="##"><img src="/cfmx/sif/imagenes/iedit.gif" alt="Lista de Cotizaciones" name="imagen" border="0" align="absmiddle" onClick="javascript:doConlisCotizaciones(document.form1.ECid.value);"></a>
					</td>
                    </cfif>
				</tr>
				<tr>
				<td colspan="9">
					<table border="0" cellpadding="2" cellspacing="0" align="center">
					<tr>
						<td align="right" style="padding-right: 10px;" nowrap><strong>N° Solicitud</strong></td>
						<td align="right" style="padding-right: 10px;" nowrap><strong>Linea Solicitud</strong></td>
						<td style="padding-right: 10px;" nowrap><strong>Item</strong></td>
						<td align="right" style="padding-right: 10px;" nowrap><strong>Cantidad</strong></td>						
						<td align="right" style="padding-right: 10px;" nowrap><strong>Unidad</strong></td>						
						<td style="padding-right: 10px;" align="right"><strong>Precio Unitario</strong></td>
						<td style="padding-right: 10px;" align="right"><strong>Nota</strong></td>
						<td nowrap>&nbsp;</td>
					</tr>
					<cfloop query="rsMejorCotizacion">
					<tr>	
<!---************  NUMERO DE SOLICITUD  *****************---->								
						<td style="padding-right: 10px;" align="right" nowrap>
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ESnumero_#rsMejorCotizacion.DSlinea#")>
								<cfset solic = Evaluate("Session.Compras.OrdenCompra.ESnumero_"&rsMejorCotizacion.DSlinea)>
							<cfelse>
								<cfset solic = rsMejorCotizacion.ESnumero>
							</cfif>
						  <input size="10" name="ESnumero_#rsMejorCotizacion.DSlinea#" id="ESnumero" tabindex="-1" type="text" value="#HTMLEditFormat(solic)#" readonly="" style="border-width:0; text-align:right;" >
						</td>
<!---************************************---->		
						<td align="center" style="padding-right: 10px;" nowrap>
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DSconsecutivo_#rsMejorCotizacion.DSlinea#")>
								<cfset consec = Evaluate("Session.Compras.OrdenCompra.DSconsecutivo_"&rsMejorCotizacion.DSlinea)>
							<cfelse>
								<cfset consec = rsMejorCotizacion.DSconsecutivo>
							</cfif>
							<input  size="15" name="DSconsecutivo_#rsMejorCotizacion.DSlinea#" id="DSconsecutivo_#rsMejorCotizacion.DSlinea#" type="text" value="#consec#" readonly="" style="border-width:0; text-align:right;" >
						</td>
						<td style="padding-right: 10px;" nowrap>
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Descripcion_#rsMejorCotizacion.DSlinea#")>
								<cfset desc = Evaluate("Session.Compras.OrdenCompra.Descripcion_"&rsMejorCotizacion.DSlinea)>
							<cfelse>
								<cfset desc = rsMejorCotizacion.Descripcion>
							</cfif>
							<input size="50" name="Descripcion_#rsMejorCotizacion.DSlinea#" type="text" value="#HTMLEditFormat(desc)#" readonly="" style="border-width:0" >
						</td>
						<td style="padding-right: 10px;" align="right" nowrap> <!--- La Cantidad --->
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCcantidad_#rsMejorCotizacion.DSlinea#")>
								<cfset cant = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.DCcantidad_"&rsMejorCotizacion.DSlinea), ',9.00')>
							<cfelse>
								<cfif rsMejorCotizacion.DCcantidad  LT rsMejorCotizacion.cantidad <!----and rsMejorLinea.DCcantidad GT 0----->>
									<cfset cant = LSNumberFormat(rsMejorCotizacion.DCcantidad, ',9.00')>
									<!---<cfset cant = LSNumberFormat(rsMejorLinea.DCcantidad, ',9.00')>--->
								<cfelse>
									<cfset cant = LSNumberFormat(rsMejorCotizacion.cantidad, ',9.00')>
								</cfif>
							</cfif><!--- if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}} --->
                            <input name="DCcantidad_#rsMejorCotizacion.DSlinea#" type="text" value="#cant#" size="10" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" <cfif lvarSolicitante>readonly style="border-width:0; text-align: right;"<cfelse>style="text-align: right;"</cfif>>
							<input name="DCcantidadMax_#rsMejorCotizacion.DSlinea#" id="DCcantidadMax_#rsMejorCotizacion.DSlinea#" type="hidden" value="<cfif rsMejorCotizacion.DCcantidad  LT rsMejorCotizacion.cantidad <!----and rsMejorLinea.DCcantidad GT 0---->>#rsMejorCotizacion.DCcantidad#<cfelse>#rsMejorCotizacion.cantidad#</cfif>"><!----value="#rsMejorCotizacion.DCcantidad#"---->
						</td>
<!----************ UNIDAD	 **********---->
						<td style="padding-right: 10px;" nowrap>
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Ucodigo_#rsMejorCotizacion.DSlinea#")>
								<cfset codUni = Evaluate("Session.Compras.OrdenCompra.Ucodigo_"&rsMejorCotizacion.DSlinea)>
							<cfelse>
								<cfset codUni = rsMejorCotizacion.Ucodigo>
							</cfif>
						  <input size="5" name="Ucodigo_#rsMejorCotizacion.DSlinea#" type="text" value="#HTMLEditFormat(codUni)#" tabindex="-1" readonly="" style="border-width:0" >
						</td>
<!---******************************---->

						<td align="right" nowrap style="padding-right: 10px;">
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCpreciou_#rsMejorCotizacion.DSlinea#")>
								<cfset precio = Evaluate("Session.Compras.OrdenCompra.DCpreciou_"&rsMejorCotizacion.DSlinea)>
							<cfelse>
								<cfset precio = rsMejorCotizacion.DCpreciou>
							</cfif>
							<!---#LvarOBJ_PrecioU.inputNumber("CAMPO", VALOR, "tabIndex", readOnly, "class", "style", "onBlur();", "onChange();")#--->
							#LvarOBJ_PrecioU.inputNumber("DCpreciou_#rsMejorCotizacion.DSlinea#", precio, "1", true, "", "border-width: 0;", "", "")#
						</td>
						<td align="right" style="padding-right: 10px;" nowrap>
							<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Nota_#rsMejorCotizacion.DSlinea#")>
								<cfset notalinea = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.Nota_"&rsMejorCotizacion.DSlinea), ',9.00')>
							<cfelse>
								<cfset notalinea = LSNumberFormat(rsMejorCotizacion.NotaTotalLinea, ',9.00')>
							</cfif>
							<input type="text" name="Nota_#rsMejorCotizacion.DSlinea#" size="6" value="#notalinea#" readonly="" style="border-width: 0; text-align:right;">
						</td>
						<td nowrap>&nbsp;</td>
					</tr>
					</cfloop>
					</table>
				  </td>
				</tr>
			</table>
            <cfif lvarSolicitante>
              <table align="center"><tr><td>
              <input type="button" name="btnRegresar" value="Regresar" class="btnAnterior" onclick="window.location='evaluarCotizacionesSolicitante.cfm'" />
              </td></tr></table>
              </cfif>
		</cfif>
       <cfif not lvarSolicitante>
			<cfset lvarValuesB = "<< Anterior,Siguiente >>">
            <cfset lvarNamesB = "Anterior,Siguiente">
        <cfelse>
            <cfset lvarValuesB = "<< Anterior,Finalizar Solicitante">
            <cfset lvarNamesB = "Anterior,FinalizarS">
        </cfif>
		<table width="100%" align="center" <cfif lvarProcesar>style="display:none"</cfif>>
			<tr>
				<td>
					<cf_botones values="#lvarValuesB#" names="#lvarNamesB#">
				</td>
			</tr>
		</table>
	</cfoutput> 
	</form>
	<script language="javascript" type="text/javascript">
		function funcAnterior() {
			document.form1.opt.value = "3";
			
		}
		<cfif not lvarSolicitante>
		function collectDClinea() {
		<cfif isdefined("form.metodo") and (form.metodo EQ 'L')>
			document.form1.DClinea.value = "";
			<cfoutput query="rsMejorLinea">
				document.form1.DClinea.value = document.form1.DClinea.value + (document.form1.DClinea.value != "" ? "," : "") + document.form1.DClinea_#rsMejorLinea.DSlinea#.value;
			</cfoutput>
		</cfif>
			return true;
		}
		
		function funcSiguiente() {
			document.form1.opt.value = "5";
			collectDClinea();
			
		}
        <cfelse>
        function funcFinalizarS() {
			document.form1.action = "evaluar-Aplicar.cfm";
		}
        </cfif>
		function valida(f) {
		<cfif isdefined("form.metodo") and (form.metodo EQ 'L')>
			<cfoutput query="rsMejorLinea">
				f.obj.DCcantidad_#rsMejorLinea.DSlinea#.value = qf(f.obj.DCcantidad_#rsMejorLinea.DSlinea#.value);
				f.obj.DCpreciou_#rsMejorLinea.DSlinea#.value = qf(f.obj.DCpreciou_#rsMejorLinea.DSlinea#.value);
				f.obj.Nota_#rsMejorLinea.DSlinea#.value = qf(f.obj.Nota_#rsMejorLinea.DSlinea#.value);
			</cfoutput>
		<cfelseif isdefined("form.metodo") and (form.metodo EQ 'C')>
			<cfoutput query="rsMejorCotizacion">
				f.obj.DCcantidad_#rsMejorCotizacion.DSlinea#.value = qf(f.obj.DCcantidad_#rsMejorCotizacion.DSlinea#.value);
				f.obj.DCpreciou_#rsMejorCotizacion.DSlinea#.value = qf(f.obj.DCpreciou_#rsMejorCotizacion.DSlinea#.value);
				f.obj.Nota_#rsMejorCotizacion.DSlinea#.value = qf(f.obj.Nota_#rsMejorCotizacion.DSlinea#.value);
			</cfoutput>
		</cfif>
		}
		
		function __isMaxCantidad() {
			if (this.required) {
				var linea = this.name.split("_")[1];
				var maxcant = document.getElementById("DCcantidadMax_"+linea).value;
				var consec = document.getElementById("DSconsecutivo_"+linea).value;
				if (parseFloat(qf(this.value)) > parseFloat(qf(maxcant))) {
					this.error = "El campo " + this.description + " de la linea " + consec + " no puede ser mayor a " + maxcant;
				}
			}
		}
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		_addValidator("isMaxCantidad", __isMaxCantidad);
		
		<cfif isdefined("form.metodo") and (form.metodo EQ 'L')>
			<cfoutput query="rsMejorLinea">
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.required = true;
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.description = "Cantidad";
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.validateMaxCantidad();
			</cfoutput>
		<cfelseif isdefined("form.metodo") and (form.metodo EQ 'C')>
			<cfoutput query="rsMejorCotizacion">
				objForm.DCcantidad_#rsMejorCotizacion.DSlinea#.required = true;
				objForm.DCcantidad_#rsMejorCotizacion.DSlinea#.description = "Cantidad";
				objForm.DCcantidad_#rsMejorCotizacion.DSlinea#.validateMaxCantidad();
			</cfoutput>
		</cfif>
		<cfif lvarProcesar>
			if(document.form1.Siguiente)
			document.form1.Siguiente.click();
		</cfif>
	</script>
</cftransaction>
