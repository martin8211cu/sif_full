<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<div  class="titulo">Detalle de las cotizaciones</div>
<cfset lvarFiltroEcodigo = url.Ecodigo>
<cfset Form.CMPid = url.CMPi>

<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cftransaction>
	<cfquery name="rsMejorLinea" datasource="#Session.dsn#">
		select	a.ECid,
				a.DClinea, 
				case when a.NotaTotalLinea > 0 
			       then a.ECnumero
				   else
				   '-'
				   end as  ECnumero,
				a.DCcantidad,
               b.DSobservacion, b.DSdescalterna,
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
        and (a.CMRseleccionado = 1 or (a.CMRsugerido = 1 and (select count(1) from CMResultadoEval sre where sre.Ecodigo = a.Ecodigo and sre.CMPid = a.CMPid and sre.CMRseleccionado = 1) = 0)) 
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
               b.DSobservacion, b.DSdescalterna,
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
        and (a.CMRseleccionado = 1 or (a.CMRsugerido = 1 and (select count(1) from CMResultadoEval sre where sre.Ecodigo = a.Ecodigo and sre.CMPid = a.CMPid and sre.CMRseleccionado = 1) = 0)) 
	</cfquery>
  	<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
	<script language="JavaScript" type="text/javascript">
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
			
		function doConlisLineaSolicitud(lineasol, lineacot) {
			var width = 800;
			var height = 400;
			var left = (screen.width-width)/2;
			var top = (screen.height-height)/2;
			<cfoutput>
			window.open('ConlisLineasSolicitud-SOL.cfm?CMPid=#Form.CMPid#&DSlinea='+lineasol+'&DClinea='+lineacot+'&f=form1&p1=DClinea&p2=DSconsecutivo&p4=Descripcion&p5=ECnumero&p6=DCcantidad&p7=DCcantidadMax&p8=ECfechacot&p9=Mnombre&p10=DCpreciou&p11=Nota&p12=ESnumero&p13=Ucodigo&Ecodigo=<cfoutput>#lvarFiltroEcodigo#</cfoutput>', 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top);
			</cfoutput>
		}
	</script>
	
	<form name="form1" method="post" action="cotizaciones.cfm" onSubmit="javascript: return valida(this);">
	<cfoutput>
		<input type="hidden" name="opt" value="">
		<cfif isdefined("Form.CMPid") and Len(Trim(Form.CMPid))>
			<input type="hidden" name="CMPid" value="#Form.CMPid#">
		</cfif>
		<cfif isdefined("Form.metodo") and Len(Trim(Form.metodo))>
			<input type="hidden" name="metodo" value="#Form.metodo#">
		</cfif>
		  <input type="hidden" name="DClinea" value="">	
		  <table style="font-size:13px" align="center" border="0">
			<tr style="background-color:CCC" >
            	<td align="right"><strong>N°.Sol.</strong></td>
                <td  style="max-width:80px"><strong>Línea</strong></td>
            	<td ><strong>N°.Cotización</strong></td>
                <td style="min-width:150px"><strong>Item</strong></td>
            	<td style="min-width:190px"><strong>Descrici&oacute;n Alterna</strong></td>
                <td style="min-width:160px"><strong>Observaci&oacute;n</strong></td>	
                <td ><strong>Unidad</strong></td>
                <td style="" align="right"><strong>Cantidad</strong></td>
                <td style="width:100px"><strong>Precio Uni.</strong></td>
                <td style=""><strong>Moneda</strong></td>
                <td style=""><strong>Nota</strong></td>
                <td style="" align="right" nowrap><strong>Total Ori.</strong></td>
                <td style="" align="right" nowrap><strong>Total Loc.</strong></td>
			</tr>
            <cfset TotalLocal = 0>
			<cfloop query="rsMejorLinea">
            	<cfset TotalLocal = TotalLocal + rsMejorLinea.total_loc>
			  <tr style=" background-color:FFF">
              	<td align="right" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ESnumero_#rsMejorLinea.DSlinea#")>
						<cfset solic = Evaluate("Session.Compras.OrdenCompra.ESnumero_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset solic = rsMejorLinea.ESnumero>
					</cfif>
				  <input size="1" name="ESnumero_#rsMejorLinea.DSlinea#" id="ESnumero_#rsMejorLinea.DSlinea#" tabindex="-1" type="text" value="#solic#" readonly="" style="border-width:0; text-align:right;" >
				</td>
                <td>
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
				  <input size="1" name="DSconsecutivo_#rsMejorLinea.DSlinea#" id="DSconsecutivo_#rsMejorLinea.DSlinea#" tabindex="-1" type="text" value="#consec#" readonly="" style="border-width:0; text-align:right;" >
				  <input type="hidden" name="DClinea_#rsMejorLinea.DSlinea#" value="#dclin#" >
				</td>
                <td align="right" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.ECnumero_#rsMejorLinea.DSlinea#")>
						<cfset num = Evaluate("Session.Compras.OrdenCompra.ECnumero_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset num = rsMejorLinea.ECnumero>
					</cfif>
					<input size="1" name="ECnumero_#rsMejorLinea.DSlinea#" type="text" value="#Trim(num)#" tabindex="-1" readonly="" style="border-width:0; text-align:right;" >            
				</td>
				<td>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Descripcion_#rsMejorLinea.DSlinea#")>
						<cfset desc = Evaluate("Session.Compras.OrdenCompra.Descripcion_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset desc = rsMejorLinea.Descripcion>
					</cfif> #rsMejorLinea.DSlinea# #HTMLEditFormat(desc)#
				</td>                
                <td>&nbsp;#rsMejorLinea.DSdescalterna#&nbsp;</td>
                <td>&nbsp;#rsMejorLinea.DSobservacion#&nbsp;</td>
                <!----►►Unidad◄◄---->
				<td>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Ucodigo_#rsMejorLinea.DSlinea#")>
						<cfset codUni = Evaluate("Session.Compras.OrdenCompra.Ucodigo_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset codUni = rsMejorLinea.Ucodigo>
					</cfif>
				  <input size="1" name="Ucodigo_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(codUni)#" tabindex="-1" readonly="" style="border-width:0" >
				</td>
                <cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCcantidad_#rsMejorLinea.DSlinea#")>
					<cfset cant = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.DCcantidad_"&rsMejorLinea.DSlinea), ',9.00')>
                    <cfset cant2 = Evaluate("Session.Compras.OrdenCompra.DCcantidad_"&rsMejorLinea.DSlinea)>
                <cfelse>
                    <cfif rsMejorLinea.DCcantidad  LT rsMejorLinea.cantidad >
                        <cfset cant = LSNumberFormat(rsMejorLinea.DCcantidad, ',9.00')>							
                        <cfset cant2 = rsMejorLinea.DCcantidad>
                    <cfelse>
                        <cfset cant = LSNumberFormat(rsMejorLinea.cantidad, ',9.00')>
                         <cfset cant2 = rsMejorLinea.cantidad>
                    </cfif>
                </cfif>
				<td style="" align="right" nowrap>
   				 	<input name="DCcantidadMax_#rsMejorLinea.DSlinea#" id="DCcantidadMax_#rsMejorLinea.DSlinea#" type="hidden" value="<cfif rsMejorLinea.DCcantidad  LT rsMejorLinea.cantidad >#rsMejorLinea.DCcantidad#<cfelse>#rsMejorLinea.cantidad#</cfif>">
                    <input name="DCcantidad_#rsMejorLinea.DSlinea#" type="text" value="#cant#" size="4" maxlength="18" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"readonly style="border-width:0">
				</td>
				<!---►►Costo Unitario◄◄---->
                <cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.DCpreciou_#rsMejorLinea.DSlinea#")>
					<cfset precio = LvarOBJ_PrecioU.enCF_RPT(Evaluate("Session.Compras.OrdenCompra.DCpreciou_"&rsMejorLinea.DSlinea))>
                <cfelse>
                    <cfset precio = LvarOBJ_PrecioU.enCF_RPT(rsMejorLinea.DCpreciou)>
                </cfif>
				<td style="width:auto">
                    #LSNumberFormat(rsMejorLinea.DCpreciou, ',9,999.0000')#
				</td>
               
				<td style="" nowrap>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Mnombre_#rsMejorLinea.DSlinea#")>
						<cfset moneda = Evaluate("Session.Compras.OrdenCompra.Mnombre_"&rsMejorLinea.DSlinea)>
					<cfelse>
						<cfset moneda = rsMejorLinea.Miso4217><!---rsMejorLinea.Mnombre --->
					</cfif>
					<input size="3" name="Mnombre_#rsMejorLinea.DSlinea#" type="text" value="#HTMLEditFormat(moneda)#" readonly="" style="border-width:0" >
				</td>
                <td>
					<cfif isdefined("Session.Compras.OrdenCompra") and isdefined("Session.Compras.OrdenCompra.Nota_#rsMejorLinea.DSlinea#")>
						<cfset notalinea = LSNumberFormat(Evaluate("Session.Compras.OrdenCompra.Nota_"&rsMejorLinea.DSlinea), ',9.00')>
					<cfelse>
						<cfset notalinea = LSNumberFormat(rsMejorLinea.NotaTotalLinea, ',9.00')>
					</cfif>
					<input type="text" name="Nota_#rsMejorLinea.DSlinea#" size="3" value="#notalinea#" readonly="" style="border-width: 0;">
				</td>			
                <td nowrap align="right">
                	<cfset numero = rsMejorLinea.DCpreciou>
                	<cfset total3 = (cant2 * numero)>
                    <cfoutput>#LSNumberFormat(total3, ',9.00')#</cfoutput>
                </td>
                 <!---►►Total Linea Local◄◄---->
                <td nowrap align="right">
                	<cfoutput>#LSNumberFormat(rsMejorLinea.total_loc, ',9.00')#</cfoutput>
                </td>
              </tr>
			</cfloop>
            <tr>
            	<td colspan="10">&nbsp;</td>
                <td colspan="4"><hr /></td>
            </tr>
            <tr>
            	<td colspan="8">&nbsp;</td>
                <td colspan="4" align="right"> <strong>Total Local:</strong></td>
            	<td><cfoutput><strong>#LSNumberFormat(TotalLocal, ',9.00')#</strong></cfoutput></td>
            </tr>
		  </table>
          <table align="center">
              <tr>
              		<td>
                       <a class="btnAprobar" onclick="funcAprobar()"></a>
                  	</td>
                    <td>
                    	<a class="btnRechazar" onclick="funcRechazar()"> </a>
                    </td>
              </tr>
          </table>
	</cfoutput> 
	</form>
	<script language="javascript" type="text/javascript">
		function funcAprobar() {
			if(!confirm("Está seguro de Aprobar la cotización?"))
				return false;
			<!------>	
			window.parent.document.lista.action = "/cfmx/sif/cm/operacion/evaluar-Aplicar.cfm?chk=<cfoutput>#Form.CMPid#</cfoutput>&btnAprobar=btnAprobar&Ecodigo=<cfoutput>#url.Ecodigo#</cfoutput>";
			window.parent.document.lista.submit();
			window.parent.fnLightBoxClose_DetaCotizacion();
		}
		function funcRechazar() {
			window.parent.fnLightBoxSetURL_JustRechazo("/cfmx/proyecto7/justifiRechazo.cfm?CMPi=<cfoutput>#Form.CMPid#</cfoutput>&Ecodigo=<cfoutput>#url.Ecodigo#</cfoutput>");
			window.parent.fnLightBoxOpen_JustRechazo();
			window.parent.fnLightBoxClose_DetaCotizacion();
		}
		function funcAnterior() {
			document.form1.opt.value = "3";
			
		}

        function funcFinalizarS() {
			<!------>	
			document.form1.action = "evaluar-Aplicar.cfm";
		}
      
		function valida(f) {
			<cfoutput query="rsMejorLinea">
				f.obj.DCcantidad_#rsMejorLinea.DSlinea#.value = qf(f.obj.DCcantidad_#rsMejorLinea.DSlinea#.value);
				f.obj.DCpreciou_#rsMejorLinea.DSlinea#.value = qf(f.obj.DCpreciou_#rsMejorLinea.DSlinea#.value);
				f.obj.Nota_#rsMejorLinea.DSlinea#.value = qf(f.obj.Nota_#rsMejorLinea.DSlinea#.value);
			</cfoutput>
		
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

			<cfoutput query="rsMejorLinea">
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.required = true;
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.description = "Cantidad";
				objForm.DCcantidad_#rsMejorLinea.DSlinea#.validateMaxCantidad();
			</cfoutput>
		
			if(document.form1.Siguiente)
			document.form1.Siguiente.click();
	</script>
</cftransaction>
</div>
