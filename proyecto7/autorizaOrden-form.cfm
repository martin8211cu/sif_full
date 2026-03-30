<cfparam name="lvarProvCorp" default="false">
<cfparam name="form.Ecodigo_f" default="#session.ecodigo#">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
<cfquery name="rsLista" datasource="#session.DSN#">
	select a.CMAid,
		   a.CMAestado,
		   a.Nivel, 		
		   b.EOidorden, 
		   b.EOnumero,
		   b.EOfecha,
		   b.Observaciones, 
		   b.SNcodigo, 
		   b.CMCid,
		   d.CMCnombre, 
		   b.Mcodigo,
		   e.Mnombre, 
		   b.EOtc,
		   b.CMTOcodigo #_Cat# ' - ' #_Cat# c.CMTOdescripcion as CMTOdescripcion, 
		   b.EOtotal, 
    	   b.EOestado
	from CMAutorizaOrdenes a
	
	inner join EOrdenCM b
		on a.EOidorden=b.EOidorden
	 	and b.EOestado in (-7,-8,-9)
	 	<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>
	 		and b.EOnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fEOnumero#">
		</cfif>
		 <cfif isdefined("form.fecha") and len(trim(form.fecha))>
			and b.EOfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#"> and EOfecha < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,LSParseDateTime(form.fecha))#">
		 </cfif>
	inner join CMCompradores d
	on b.CMCid = d.CMCid --and b.Ecodigo=d.Ecodigo
	
	inner join CMTipoOrden c
	on b.CMTOcodigo=c.CMTOcodigo
	and b.Ecodigo=c.Ecodigo
<!--- *1* --->	
	inner join Monedas e
	on b.Mcodigo=e.Mcodigo
	and b.Ecodigo=e.Ecodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ecodigo_f#">
	  and a.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#session.compras.comprador#">
	  
	  and a.CMAestadoproceso not in (10,15)			-- no muestra rechazadas ni aprobadas(por todos)
	  
	  <cfif isdefined("form.CMAestado") and len(trim(form.CMAestado))>
	  	<cfif form.CMAestado eq 1>
			and a.CMAestadoproceso = 5
		<cfelse>
			and a.CMAestadoproceso < 10
		</cfif>
	  </cfif>

	order by b.CMTOcodigo, b.EOnumero
</cfquery>
<cfoutput>
<br>

<cfset registros = 0 >

<script type="text/javascript" language="javascript1.2" src="../sif/js/utilesMonto.js"></script>
<form name="filtro" method="post" action="ordenCompras.cfm" style="margin:0;" onsubmit="fnValidaCampos()">
<table width="99%" align="center" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td width="1%" nowrap><strong>No. Orden:&nbsp;</strong></td>
		<td><input type="text" name="fEOnumero" id="fEOnumero" size="10" maxlength="10" value="<cfif isdefined("form.fEOnumero") and len(trim(form.fEOnumero))>#form.fEOnumero#</cfif>" onFocus="javascript:this.select();" style="text-align:right" onKeyUp="if(snumber(this,event,' ')){ if(Key(event)=='13') {this.blur();}}"></td>
		<td width="1%"><strong>Fecha:&nbsp;</strong></td>
		<td>
			 <cfset fecha = '' >
			 <cfif isdefined("form.fecha") and len(trim(form.fecha))>
				<cfset fecha = form.fecha >
			 </cfif>
			 <cf_sifcalendario form="filtro" value="#fecha#">
			
		</td>
		<td width="1%"><strong>Estado:&nbsp;</strong></td>
		<td>
			<select name="CMAestado">
				<option value="">Todos</option>
				<option value="0" <cfif isdefined("form.CMAestado") and form.CMAestado eq 0>selected</cfif>>Pendientes</option>
				<option value="1" <cfif isdefined("form.CMAestado") and form.CMAestado eq 1>selected</cfif>>Rechazadas</option>
			</select>
		</td>
        <cfif lvarProvCorp>
        <td align="right" nowrap><strong>Empresa: </strong></td>
        <td colspan="3">
            <select name="Ecodigo_f">
                <cfloop query="rsDProvCorp">
                    <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ Session.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                </cfloop>	
            </select>
        </td>
      	</cfif>
		<td><input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar"></td>
	</tr>
</table>
</form>
<cfset botonAPRE = false>
<cfset botonReinicar = false>
	<cfset botones= false>
<br>
<table width="990" border="0" align="center" cellpadding="0" cellspacing="0">
<cfloop query="rsLista">
<!---Validar que existen casos para mostrar los campos aprobar rechazar o reiniciar--->
	<cfif rsLista.nivel gt 0 >
        <cfquery name="rsValida" datasource="#session.DSN#">
            select CMAestado
            from CMAutorizaOrdenes
            where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
              and CMAestado = 2
              and Nivel = #rsLista.Nivel#-1
        </cfquery>
    </cfif>
	<cfif ( rsLista.nivel eq 0 ) or (isdefined("rsValida") and rsValida.recordCount gt 0 and rsLista.CMAestado eq 0 ) >
		<cfset botones= true>
		 <cfif not  rsLista.Nivel gt 0 >
            <cfquery name="rsReiniciar" datasource="#session.DSN#">
                select 1 
                from CMAutorizaOrdenes 
                where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and EOidorden =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
                and CMAestadoproceso not in (10,15) and Nivel > 0 and CMAestado=1
            </cfquery>
            <cfif rsReiniciar.recordCount gte 1 >
                <cfset botonReinicar = true>
            </cfif>
        <cfelse>
			<cfset botonAPRE = true>            
        </cfif>
     </cfif>
</cfloop>
	<cfif botones>  
        <tr class="listaNon">
            <td width="60"><strong><font size="2">No. Orden</font></strong></td>
            <td width="180"><strong>Observaciones&nbsp;</strong></td>
            <td width="70"><strong>Estado&nbsp;</strong></td>
            <td width="180"><strong>Comprador&nbsp;</strong></td>
            <td width="70"><strong>Fecha&nbsp;</strong></td>
            <td width="70"><strong>Moneda&nbsp;</strong></td>  
            <td width="60"><strong>Tipo de Cambio&nbsp;</strong></td> 
            <td width="120"><strong>Monto&nbsp;</strong></td>   
            <td width="70"><strong>Ver Seguimiento&nbsp;</strong></td>  
			<td width="70"><strong>Detalle&nbsp;</strong></td>
            <cfif botonReinicar>
                <td width="60"><strong>Reiniciar</strong></td>
            </cfif>
            <cfif botonAPRE>
                <td width="70"><strong>Aprobar&nbsp;</strong></td> 
                <td width="70"><strong>Rechazar&nbsp;</strong></td>               
            </cfif>
        </tr>
    </cfif>
	<cfloop query="rsLista">
		<form name="form1" method="post" action="autorizaOrden-sql.cfm">
			<input type="hidden" name="CMAid" 		value="#rsLista.CMAid#">
			<input type="hidden" name="EOidorden" 	value="#rsLista.EOidorden#" id="EOidorden">
			<input type="hidden" name="Nivel" 		value="#rsLista.Nivel#">
			<cfif rsLista.nivel gt 0 >
				<cfquery name="rsValida" datasource="#session.DSN#">
					select CMAestado
					from CMAutorizaOrdenes
					where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
					  and CMAestado = 2
					  and Nivel = #rsLista.Nivel#-1
				</cfquery>
			</cfif>
			
				<cfquery name="rsDSLinea" datasource="#session.dsn#">
				   select distinct(b.CMPid) 
                   	from DOrdenCM a
					 inner join CMLineasProceso b
						 on a.DSlinea = b.DSlinea 
					where a.Ecodigo = #Session.Ecodigo# 
					 and a.EOidorden =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
				</cfquery>
				<cfif rsDSLinea.recordcount gt 0>
					<cfquery name="rsCodigoProceso" datasource="#session.dsn#" maxrows="1">
					 Select CMPcodigoProceso from CMProcesoCompra where Ecodigo = 	#Session.Ecodigo# and 
					 CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDSLinea.CMPid#">
					</cfquery>			
				</cfif>	
			
			<cfif ( rsLista.nivel eq 0 ) or (isdefined("rsValida") and rsValida.recordCount gt 0 and rsLista.CMAestado eq 0 ) >
                <cfquery name="rsEstado" datasource="#session.DSN#">
                    select CMAestado
                    from CMAutorizaOrdenes
                    where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                      and CMAestadoproceso not in (10)
                      and Nivel = (select max(Nivel) from CMAutorizaOrdenes where CMAestadoproceso not in (10) and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">)
                </cfquery>
               
				<tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                <td>
                    <tr class="<cfif rsLista.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
                        <td width="20">#rsLista.EOnumero#</td>
                        <td>#mid(rsLista.Observaciones,1,50)#</td>
                        <td><cfif rsEstado.CMAestado eq 0 >
                                Pendiente
                            <cfelse>
                                Rechazado
                            </cfif>
                          </td>
                          <td>#rsLista.CMCnombre#</td>
                          <td>#LSDateFormat(rsLista.EOfecha,'dd/mm/yyyy')#</td>
                          <td>#rsLista.Mnombre#</td>
                          <td>#LSNumberFormat(rsLista.EOtc,',9.00')#</td>
                          <td>#LSNumberFormat(rsLista.EOtotal,',9.00')#</td>	
                          <td><a style="cursor:pointer;float:none" title="Seguimiento" onclick="return funcseguimiento('#rsLista.EOidorden#')"><img border="0" align="absmiddle" name="imagen" src="/cfmx/sif/imagenes/next_year.gif"></a></td>
                          <td><a style="cursor:pointer;float:none" title="Detalles" onclick="return fnObtDetalles('#rsLista.EOidorden#','#rsLista.EOnumero#')"><img border="0" align="absmiddle" name="imagen" src="/cfmx/sif/imagenes/Page_Load.gif"></a></td>
                        <cfif not  rsLista.Nivel gt 0 >
                            <cfquery name="rsReiniciar" datasource="#session.DSN#">
                                select 1 
                                from CMAutorizaOrdenes 
                                where Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                and EOidorden =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.EOidorden#">
                                and CMAestadoproceso not in (10,15) and Nivel > 0 and CMAestado=1
                            </cfquery>
                            <cfif rsReiniciar.recordCount gte 1 >
                            	<td align="center">
                                   <a id="btnReiniciar" class="archivos-icon-reiniciar" style="cursor:pointer;float:none" title="Reiniciar" onclick="fncReinici('#rsLista.EOidorden#','#rsLista.Nivel#')"></a>
                                </td>	
                            <cfelse> 
                                <td></td>				
                            </cfif>
                            <cfif botonAPRE>
                                <td> </td>
                                <td> </td>
                            </cfif>
                        <cfelse>
                            <cfif botonReinicar>
                            	<td> </td>
                            </cfif>
                            <td align="center"><a id="btnAprobar" class="archivos-icon-aprobar" style="cursor:pointer;float:none" title="Aprobar" onclick="funcAprobar('#rsLista.EOidorden#','#rsLista.Nivel#','#rsLista.CMAid#')"></a> </td>
                            <td align="center"><a class="archivos-icon-rechazar" style="cursor:pointer;float:none" title="Rechazar" onclick="funcRechazar('#rsLista.EOidorden#','#rsLista.Nivel#','#rsLista.CMAid#')"></a></td>
                        </cfif>
                    </tr>
				</td>
        	</tr>
        <tr><td colspan="15"><hr size="1" color="##CCCCCC"></td></tr>
        <cfset registros = registros + 1 >
    </cfif>	
    </form>
</cfloop>
</table>
	<cfif registros eq 0 >
    <table width="100%">
		<tr><td>&nbsp;</td>
		  <td>&nbsp;</td>
		</tr>
		<tr><td align="center"><strong>-- No se encontraron registros --</strong></td>
		  <td align="center">&nbsp;</td>
		</tr>
     </table>
	</cfif>


<form name="formProceso" action="../sif/cm/operacion/autorizaOrden-listacotizaciones.cfm" method="post">
	<input type="hidden" name="EOidorden" value="">
</form>
<form name="formX" action="autorizaOrden-sql.cfm" method="post">
	<input type="hidden" name="EOidorden" 	value="">
    <input type="hidden" name="CMAid" 		value="">
	<input type="hidden" name="Nivel" 		value="">
    <input type="hidden" name="justificacion" 		value="">
    <input type="hidden" name="notificar"  id="notificar" 	value="">
</form>
</cfoutput>
  
	<cf_Lightbox link="" Titulo="Detalle de la Orden de Compra" width="80" height="90" name="DetaOrdenCompra" url="/cfmx/proyecto7/detalleOrdenCompra.cfm"></cf_Lightbox>
    <cf_Lightbox link="" Titulo="Justificación del Rechazo" width="40" height="30" name="JustRechazo" url="/cfmx/proyecto7/justifiRechazo.cfm"></cf_Lightbox>
    <cf_Lightbox link="" Titulo="Ver Seguimiento" width="50" height="50" name="Seguimiento" url="/cfmx/proyecto7/justifiRechazo.cfm"></cf_Lightbox>
<script language="javascript1.2" type="text/javascript">
	function fnValidaCampos(){
		error="";
		valor1 = document.getElementById("fEOnumero").value;	
		if(!fnValidaNumero(valor1) && valor1 !="" ){
			error += "\n - El campo No. Orden debe ser numérico.";
			document.getElementById("fEOnumero").value="";
		}
		if(error!=""){
			alert("Se presentaron los sigiuentes problemas:"+error);
			return false;
		}else{
			return true;
		}
		
	}
	function fnValidaNumero(valor){
		valor = parseInt(valor)
		
      //Compruebo si es un valor numérico
      if (isNaN(valor)) {
            //entonces (no es numero) devuelvo false
            return false
      }else{
            //En caso contrario (Si era un número) devuelvo el true
            return true
      } 
	}	
	function fnObtDetalles(EOidorden,EOnumero){
		fnLightBoxSetURL_DetaOrdenCompra("/cfmx/proyecto7/detalleOrdenCompra.cfm?EOidorden="+EOidorden+"&EOnumero="+EOnumero);
		fnLightBoxOpen_DetaOrdenCompra();
	}
	function funcAprobar(id,Nivel,CMAid){
		if(confirm('¿Esta seguro de que desea aprobar el proceso?')){
			document.formX.action="autorizaOrden-sql.cfm?btnAprobar=btnAprobar";
			document.formX.Nivel.value = Nivel;
			document.formX.CMAid.value = CMAid;
			document.formX.EOidorden.value = id;
			document.formX.submit();
		}
	}
	function fncReinici(id,Nivel){
		if(confirm('¿Esta seguro de que desea reiniciar el proceso?')){
			document.formX.action="autorizaOrden-sql.cfm?btnReiniciar=btnReiniciar";
			document.formX.Nivel.value = Nivel;
			document.formX.EOidorden.value = id;
			document.formX.submit();
		}
	}
	function funcRechazar(id,Nivel,CMAid){
		fnLightBoxSetURL_JustRechazo("/cfmx/proyecto7/justifiRechazo.cfm?Nivel="+Nivel+"&EOidorden="+id+"&CMAid="+CMAid);
		fnLightBoxOpen_JustRechazo();
	}
	
	function funcseguimiento(id){
		fnLightBoxSetURL_Seguimiento("/cfmx/proyecto7/autorizaSeguimiento.cfm?EOidorden="+id);
		fnLightBoxOpen_Seguimiento();
	}
	
	function funcProceso(parIDorden){
		document.formProceso.EOidorden.value = parIDorden;		
		document.formProceso.submit();
	}

</script>