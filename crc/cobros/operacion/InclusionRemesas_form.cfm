<cf_importLibs>
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cf_navegacion name="ERid">
<cfif isdefined ('url.ERid') and (not isdefined('form.ERid') or len(trim(form.ERid)) eq 0)>
	<cfset form.ERid=#url.ERid#>
</cfif>
<cfset LvarTabla ="HPagos">
 <cfif isdefined ('form.NumLote') and len(trim(form.NumLote)) gt 0 >
	<cfset form.NumLote=#form.NumLote#>
    <cfset LvarTabla ="Pagos">
</cfif>

 <cfif isdefined ('url.NumLote') and len(trim(url.NumLote)) gt 0 >
	<cfset form.NumLote=#url.NumLote#>
    <cfset LvarTabla ="Pagos">
</cfif>

<cfif isdefined('form.ERid') and len(trim(form.ERid)) gt 0>
	<cfset modo='CAMBIO'>
<cfelse>
	<cfset modo='ALTA'>
</cfif>

<cfif isdefined ('form.btnNuevo')>
	<cfset modo='ALTA'>
</cfif>

   <cfif not isDefined("Session.Caja")>
                   <cflocation addtoken="no" url="../catalogos/AbrirCaja.cfm?IR=1">
        </cfif>
           <cfif isdefined('session.Caja') and len(trim(#session.Caja#)) gt 0>
            <cfquery name="rsCaja" datasource="#session.dsn#">
             select FCcodigo, FCdesc
              from FCajas
              where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Caja#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.Ecodigo#">
            </cfquery>
         </cfif>

 <cfif isdefined('url.Mcodigo')>
	<cfset form.Mcodigo = url.Mcodigo>
</cfif>

 <cfif isdefined('url.Dep')>
	<cfset form.Dep = url.Dep>
</cfif>


<cfif modo neq 'ALTA'>

    <!---Query que devuelve la remesa actual --->

    <cfquery name="rsNumLote" datasource="#session.dsn#">
 		select RNumLote
		from ERemesas
		where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	</cfquery>

    <cfif rsNumLote.RNumLote neq "">

    <cfset LvarNumLote = rsNumLote.RNumLote>
    <cfset LvarTabla ="Pagos">

    </cfif>

	<cfquery name="rsform" datasource="#session.dsn#">
 	select FCid,
                e.Bid,
				e.CBid,
				e.NumDeposito,
				e.MntEfectivo,
				e.MntCheque,
				e.Mcodigo as Mcodigo,
				e.Fremesa,
                e.FACid,
                e.ERid,
                Miso4217,
				case REstado
					when 'E'  then 'En Preparacion'
				end as estado
			from ERemesas e
             left join Monedas m on m.Mcodigo = e.Mcodigo
		where ERid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERid#">
	</cfquery>

     <cfquery name="rsMonedas" datasource="#Session.DSN#">
		select Mcodigo, Mnombre
        from Monedas
        where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Mcodigo#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>


<cfquery name="rsMontoEfectivoF" datasource="#session.dsn#">
       	  select   coalesce(SUM(FPmontoori),0)  as MontoEfectivoF
            from FPagos a
            inner join ETransacciones et
                on a.ETnumero = et.ETnumero
                and a.FCid = et.FCid
           where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
              and et.FACid IS NULL
              and et.ETestado = 'C'
              <cfif isdefined("LvarNumLote")>
              <cfelse>
              and et.FCid =  #session.Caja#
              </cfif>
              and a.Tipo = 'E'
              and a.ERid IS NULL
               <cfif isdefined ('LvarNumLote')>
             and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif>
        </cfquery>




        <cfquery name="rsMontoEfectivoR" datasource="#session.dsn#">
         select  coalesce(SUM(FPmontoori),0)   as MontoEfectivoR
              from PFPagos a
                inner join #LvarTabla# p
                    on a.CCTcodigo = p.CCTcodigo
                    and a.Pcodigo = p.Pcodigo
               where a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
                 and p.FACid IS NULL
                 <cfif isdefined("LvarNumLote")>
              	 <cfelse>
                 and p.FCid =  #session.Caja#
                 </cfif>
                 and a.Tipo = 'E'
                 and a.ERid IS NULL
                    <cfif isdefined ('LvarNumLote')>
             and p.Plote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif>
        </cfquery>


        <cfquery name="rsMontoVueltos" datasource="#session.dsn#">
         select
          coalesce(sum(coalesce(FPVuelto * et.ETtc,0)),0) as vuelto
        from FPagos a
        inner join ETransacciones et
          on a.ETnumero = et.ETnumero
       	 and a.FCid     = et.FCid
        where
        et.FACid IS NULL
        and ETgeneraVuelto = 1
        and et.ETestado = 'C'
         <cfif isdefined("LvarNumLote")>
         <cfelse>
          and et.FCid = #session.Caja#
         </cfif>
        and a.ERid IS NULL
	     <cfif isdefined ('LvarNumLote')>
         and et.ETlote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
         </cfif>
        </cfquery>

         <cfquery name="rsOtrasRemesas" datasource="#session.dsn#">
     		select  coalesce(SUM(MntEfectivo),0)   as MontoEfectivoR
              from ERemesas
               where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsform.Mcodigo#">
                 and FACid IS NULL
                 <cfif isdefined("LvarNumLote")>
              	 <cfelse>
                 and FCid =  #session.Caja#
                 </cfif>
                 and REstado = 'A'
                  <cfif isdefined ('LvarNumLote')>
             and RNumLote = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarNumLote#">
             </cfif>
        </cfquery>

        <cfset LvarMontoEfectivo = (#rsMontoEfectivoR.MontoEfectivoR# + #rsMontoEfectivoF.MontoEfectivoF#) - #rsMontoVueltos.vuelto# - #rsOtrasRemesas.MontoEfectivoR#>



</cfif>


 <cfif modo eq 'Alta'>
 	<cfquery name="rsMonedas" datasource="#Session.DSN#">
		select a.Mcodigo, Mnombre from CuentasPorMoneda a inner join Monedas b on a.Mcodigo = b.Mcodigo and a.Ecodigo = b.Ecodigo where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfoutput>
<form name="form1" action="InclusionRemesas_sql.cfm" method="post">
<table width="100%" align="center" border="0">
 <tr>
  <td>

	<table width="100%" align="center" border="0">

        <tr>
			<td nowrap="nowrap" align="right">
				<strong>Caja:</strong>
			</td>
			<td>
            	<input type="text" name="cajaAct" value="#rsCaja.FCdesc#" readonly="readonly" maxlength="10"  />
                   <cfif isdefined('form.NumLote')>
                 <input type="hidden" name="NumLote" id="NumLote" value="#form.NumLote#" />
                 <cfelseif isdefined ('LvarNumLote')>
                 <input type="hidden" name="NumLote" id="NumLote" value="#LvarNumLote#" />
                  <cfelseif isdefined ('url.NumLote')>
                 <input type="hidden" name="NumLote" id="NumLote" value="#url.NumLote#" />
                 <cfelse>
                </cfif>
			</td>
        </tr>
    	<tr>
			<td nowrap="nowrap" align="right">
				<strong>Num.Deposito:</strong>
			</td>
			<td>
            <cfif  modo eq 'ALTA'>

             <cfif isdefined("form.Dep")>
				<input type="text" name="num" maxlength="10" id="num"
                value = "#form.Dep#"/>
             <cfelse>
                <input type="text" name="num" id="num" maxlength="10" />
                </cfif>
             <cfelse>
             	<input type="text" name="num" maxlength="10" id="num" readonly="readonly" value = "#rsform.NumDeposito#"/>
             </cfif>
			</td>
        </tr>

		<tr>
         <td align="right"><strong>Moneda:</strong>&nbsp;</td>
           <cfif modo neq 'Alta'>
                <input type="hidden" name="Mcodigo" id="Mcodigo" value="#rsMonedas.Mcodigo#" />
        <td><input type="text" name="Mnombre" maxlength="10" id="Mnombre" readonly="readonly" value = "#rsMonedas.Mnombre#"/>
		 </td>
           <cfelse>
         <td>
      <select name="Mcodigo" id="Mcodigo"onchange="javascript:CambioMoneda();">
                        <cfloop query="rsMonedas">
                          <option value="#Mcodigo#" <cfif isdefined("form.Mcodigo") and Mcodigo eq form.Mcodigo> selected</cfif>> #Mnombre# </option>
                        </cfloop>
                      </select>
<!---         <cf_sifmonedas Conexion="#session.DSN#" form="form1" query="#rsMonedas#" Mcodigo="Mcodigo" tabindex="1" onchange="CambioMoneda();">--->
		 </td>
           </cfif>
         <cfif modo NEQ 'Alta'>
         <input type="hidden" name="ERid" value="#rsForm.ERid#" />
         <input type="hidden" name="NumDeposito" value="#rsform.NumDeposito#" />
         <input type="hidden" name="Fremesa" value="#rsform.Fremesa#" />
         </cfif>
        </tr>
        <cfif modo eq 'Alta'>
                <cfquery name="rsCuentaPorMoneda" datasource="#Session.DSN#">
                Select Ecodigo, Bid ,CBid, Mcodigo
                   from CuentasPorMoneda
                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                <cfif isdefined("Form.Mcodigo")>
                and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
                <cfelseif modo neq 'Alta'>
                  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Mcodigo#">
                </cfif>
               </cfquery>

				<cfset valuesArray = ArrayNew(1)>
					<cfif rsCuentaPorMoneda.recordcount>
                      <cfquery name ="rsCuentas" datasource="#session.DSN#">
                       select b.Bid,a.CBid, b.CBcodigo, b.CBdescripcion, a.Mcodigo from CuentasPorMoneda a
                                inner join CuentasBancos b
                                on a.CBid = b.CBid
                                and a.Ecodigo = b.Ecodigo
                        where a.Ecodigo = #Session.Ecodigo# and a.CBid = #rsCuentaPorMoneda.CBid# and a.Bid = #rsCuentaPorMoneda.Bid#
                       </cfquery>


						<cfset ArrayAppend(valuesArray, rsCuentas.CBid)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBcodigo)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBdescripcion)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.Bid)>
                </cfif>

		   <cfelseif modo neq 'Alta'>
              	<cfset valuesArray = ArrayNew(1)>
                <cfquery name ="rsCuentas" datasource="#session.DSN#">
                       select b.Bid,b.CBid, b.CBcodigo, b.CBdescripcion, b.Mcodigo
                           from  CuentasBancos b
                        where b.Ecodigo = #Session.Ecodigo#
                        and b.CBid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.CBid#">
                        and b.Bid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Bid#">
                         and b.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.Mcodigo#">
                       </cfquery>

                     	<cfset ArrayAppend(valuesArray, rsCuentas.CBid)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBcodigo)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.CBdescripcion)>
                        <cfset ArrayAppend(valuesArray, rsCuentas.Bid)>
           </cfif>



            <tr>
            	<td align="right"><strong>Cuenta Bancaria:</strong>&nbsp;</td>
            <cfif modo EQ 'Alta'>
            <td>
            	<cf_conlis title="Lista de Cuentas Bancarias"
			campos = "CBid, CBcodigo, CBdescripcion, Bid"
			desplegables = "N,S,S,N"
			modificables = "N,S,N"
			size = "0,0,40,0"
            valuesArray="#valuesArray#"
			tabla="CuentasBancos cb
					inner join CuentasPorMoneda cm
					on cb.Bid = cm.Bid
					and cb.CBid = cm.CBid
					and cb.Mcodigo = cm.Mcodigo
					and cb.Ecodigo = cm.Ecodigo
					inner join Monedas m
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo"
			columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
						m.Mnombre, cb.Bid"
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1 and m.Mcodigo = $Mcodigo,numeric$"
			desplegar="CBcodigo, CBdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CBid, CBcodigo, CBdescripcion, Mnombre, Bid"
			asignarformatos="S,S,S,S,U"
			showEmptyListMsg="true"
			debug="false"
			tabindex="6"
            >
            </td>
            <cfelse>
             <td>
     		 	<cf_conlis title="Lista de Cuentas Bancarias"
			campos = "CBid, CBcodigo, CBdescripcion, Bid"
			desplegables = "N,S,S,N"
			modificables = "N,N,N"
			size = "0,0,40"
            valuesArray="#valuesArray#"
			tabla="CuentasBancos cb
					inner join Monedas m
					on cb.Mcodigo = m.Mcodigo
					inner join Empresas e
					on e.Ecodigo = cb.Ecodigo"
			columnas="cb.CBid, cb.CBcodigo, cb.CBdescripcion, cb.Mcodigo,
						m.Mnombre,cb.Bid"
			filtro="cb.Ecodigo = #Session.Ecodigo# and cb.CBesTCE = 0 and cb.CBestado = 1 and cb.Bid = $Bid,numeric$"
			desplegar="CBcodigo, CBdescripcion"
			etiquetas="Código, Descripción"
			formatos="S,S"
			align="left,left"
			asignar="CBid, CBcodigo, CBdescripcion, Mnombre, Bid"
			asignarformatos="S,S,S,S,U"
			showEmptyListMsg="true"
			debug="false"
			tabindex="6"
            readonly="true"
            >
            </td>
            </cfif>
		<!---			 <input type="hidden" name="Bid" id="Bid" value="#rsCuentaPorMoneda.Bid#" />--->
            </table>

           <cfif modo neq 'ALTA'>
           <table width="100%" align="center" border="0">
		  	<tr>
			<!--- <td align="right" width="17%">&nbsp;
                	SE COMENTA SEGUN SOLICITUD DE DESARROLLO- NACION 22-08-2014
					<strong>Monto Recibido en efectivo:</strong>
				</td>--->
				<!---<td width="17%">&nbsp;
                 SE COMENTA SEGUN SOLICITUD DE DESARROLLO- NACION 22-08-2014
                    <input type="hidden" name="efect" id = "efect" value="#LvarMontoEfectivo#" />
                	<input 	type="text" name="montoE" id="montoE" tabindex="1"  value="#NumberFormat(LvarMontoEfectivo,",0.00")#" readonly="readonly" />


				</td>---->
				<td width="20%"  align="right"><strong>Tipo de Cambio:&nbsp;</strong></td>
				<td width="80%" >
                <!---Tipo de cambio--->
                	<cfquery name="TC" datasource="#session.dsn#">
                        select Mcodigo, TCcompra, TCventa
                        from Htipocambio
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and  Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
                        and  Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
                        and Mcodigo=#rsform.Mcodigo#
                    </cfquery>
                    <cfquery datasource="#Session.DSN#" name="rsEmpresa">
                        select Miso4217
                          from Empresas e
                            inner join Monedas m
                                on m.Mcodigo = e.Mcodigo
                         where e.Ecodigo = #session.Ecodigo#
					</cfquery>
<cfset LvarMiso4217LOC = rsEmpresa.Miso4217>
					<input 	type="text" name="tipoCambio" id="tipoCambio" tabindex="1" readonly="readonly"
							value="<cfif rsform.Miso4217 EQ LvarMiso4217LOC>1.0000<cfelse>#LSNumberFormat(TC.TCventa, '9.99')#</cfif>" >
				</td>
			</tr>
            </table>
           </cfif>

       </td>
       <cfif modo NEQ 'Alta'>
        <td>
          <fieldset>
                <legend><b>Total Depósito</b></legend>
   <!---      <cfif isdefined('form.Mefectivo')>--->
          <cfset total = #rsform.MntCheque# + #rsform.MntEfectivo# >

         Efectivo:  <input type="text" name="Mefectivo" id="Mefectivo" maxlength="10" value="#NumberFormat(rsForm.MntEfectivo,",0.00")#"/> </br>
        <!--- Efectivo:  <input type="text" name="Mefectivo" id="Mefectivo" maxlength="10" value="<cfif isdefined('form.Mefectivo')> #form.Mefectivo# <cfelse>#rsForm.MntEfectivo#</cfif>" onBlur="actualizaTotal(#total#);"  />  </br>--->
        <!--- Cheque:    <input type="text" name="Mcheque" id="Mcheque" maxlength="10" value="#NumberFormat(rsform.MntCheque,",0.00")#" readonly="readonly" /> </br> --->
         _________________________________________</br>

         Total depósito:  <input type="text" name="Mtotal" id="Mtotal" maxlength="10" readonly="readonly" value="#NumberFormat(total,",0.00")#"/> </br>
         </fieldset>
        	 </td>
        </cfif>
  		</tr>
  </table>


		<tr>
			<cfif modo eq 'ALTA'>
             <table width="100%" align="center" border="0">
		  	<tr>
				<td colspan="4" align="center">
					<input type="submit" name="Agregar" value="Agregar" onClick="javascript: return validaNumDepostivo(); "/><!---onClick="javascript: habilitarValidacion(); "--->
					<input type="submit" name="Limpiar" value="Limpiar" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
            </tr>
			<cfelseif modo eq 'CAMBIO'><!---EN PROCESO--->
				<td colspan="4" align="center">
                	 <cfif isdefined("LvarNumLote") or isdefined("form.NumLote") >
                     	<input type="submit" name="Modificar" value="Modificar" onClick="return verificaMontoLiq(); "/>
		 			<cfelse>
					<input type="submit" name="Modificar" value="Modificar" onClick="return verificaMonto(); "/>
                    </cfif>
                    <cfif isdefined("LvarNumLote") or isdefined("form.NumLote") >
		 			<cfelse>
                    <input type="submit" id="Generar" name="Generar" value="Generar" onClick="if (!confirm('¿Desea realizar el deposito?')) return false;">
                    </cfif>
					<input type="submit" name="Eliminar" value="Eliminar" onClick="if (!confirm('¿Desea eliminar la remesa actual?')) return false;">
                    <cfif isdefined("LvarNumLote") or isdefined("form.NumLote") >
                    <cfelse>
					<input type="submit" name="Nuevo" value="Nuevo" />
                    </cfif>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			</cfif>
		</tr>
        </table>
	</form>
	<!--- <cfif modo eq 'CAMBIO'>
		<tr>
			<td colspan="4">
	        	<cfinclude template="InclusionRemesas_detalles.cfm">
			</td>
		</tr>
	</cfif> --->

</cfoutput>

<cf_qforms>
<script type="text/javascript" language="javascript" src="../../../CFIDE/scripts/wddx.js"></script>
<script language="javascript" type="text/javascript">

	function CambioMoneda() {
		<cfoutput>
		<cfif isdefined('form.NumLote')>
		location.href='InclusionRemesas.cfm?Nuevo=Nuevo&Mcodigo='+document.getElementById("Mcodigo").value+'&Dep='+document.getElementById("num").value+'&NumLote='+document.getElementById('NumLote').value;

		<cfelse>
	location.href='InclusionRemesas.cfm?Nuevo=Nuevo&Mcodigo='+document.getElementById("Mcodigo").value+'&Dep='+document.getElementById("num").value;

	</cfif>
 </cfoutput>
	}
	function verificaMontoLiq(){

	   if (parseInt(document.getElementById("efect").value) < parseInt(document.getElementById("Mefectivo").value) )	{
			alert("No puede depositar más dinero en efectivo que el efectivo que posee la liquidacion");
			return false;
			}else{
			return true;
		    }
  		}

    	function verificaMonto(){

	   if (parseInt(document.getElementById("efect").value) < parseInt(document.getElementById("Mefectivo").value)){
			alert("Recuerde que está depositando más dinero en efectivo que el efectivo que posee la caja");
			}
			return true;
  		}

		<!---	function validaNumDepostivo(){
			   if (document.getElementById("num").value == "" )	{
					alert("Debe ingresar un numero de depostio");
					return false;
					}else{
					return true;
					}
				}--->

			function validaNumDepostivo(){

			if (document.getElementById("num").value == "" )
			{
				alert("Debe ingresar un numero de depostio");
				return false;
			}

			 var NumDeposito = document.getElementById("num").value;
		     var Bid = document.getElementById("Bid").value;
			 var lista = 0;
				 var dataP = {
				method: "ExisteDeposito",
				 NumDeposito: NumDeposito,
				 Bid: Bid
				}


				try {
					$.ajax ({
						type: "get",
						url: "RemesasMetodos.cfc",
						data: dataP,
						dataType: "json",
						async: false,
						success: function( objResponse ){
						lista = JSON.parse(objResponse);
						},
						error:  function( objRequest, strError ){
							<!---alert('ERROR'+objRequest + ' - ' + strError);--->
							console.log(objRequest);
							console.log(strError);
						}
					});
				} catch(ss){
					alert('FALLO Inesperado');
					console.log(ss);
				}
				  if(lista > 0){
					 alert("El numero de deposito ya existe, debe ingresar otro");
					 return false;
				}else{
					 return true;
				}

			}
</script>
