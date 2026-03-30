<cfif isdefined("form.QPvtaTagid") and len(trim(form.QPvtaTagid))>
	<cf_dbfunction name="op_concat" returnvariable="_Cat">
	<cfquery name="rsDato" datasource="#session.dsn#">
		select
				b.QPtipoCteDes,
				a.QPcteid, 
				a.QPtipoCteid, 
				a.QPcteDocumento, 
				a.QPcteNombre, 
				a.QPcteDireccion, 
				a.QPcteTelefono1,
				a.QPcteTelefono2, 
				a.QPcteTelefonoC, 
				a.QPcteCorreo, 
				a.BMusucodigo,
				a.BMFecha,
				c.Mcodigo,
                d.QPvtaTagFecha,
                d.QPvtaTagPlaca,
                d.QPTidTag,
                e.QPTPAN,
                e.QPTNumSerie,
                d.QPvtaConvid,
                d.ts_rversion,
                c.QPctaBancoTipo,
                c.QPctaBancoNum,
                c.QPctaBancoCC,
                f.QPctaSaldosTipo,
                e.QPPid,
                d.QPvtaAutoriza,
                g.QPPcodigo #_Cat# ' ' #_Cat# g.QPPnombre as Promotor
			from QPventaTags d
                inner join QPcliente a
                	on a.QPcteid = d.QPcteid
                inner join QPtipoCliente b
					on b.QPtipoCteid = a.QPtipoCteid
                left outer join QPcuentaSaldos f
                	on f.QPctaSaldosid = d.QPctaSaldosid
                left outer join QPcuentaBanco c
                	on c.QPcteid = a.QPcteid
                inner join QPassTag e
                	on e.QPTidTag = d.QPTidTag
                left outer join QPPromotor g
                	on g.QPPid = e.QPPid
			where a.Ecodigo = #session.Ecodigo# 
			and  d.QPvtaTagid  = #form.QPvtaTagid#
		order by a.QPcteNombre
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsConvenio" datasource="#session.DSN#">
    select 
        QPvtaConvid,
        QPvtaConvCod,
        QPvtaConvDesc,
        QPvtaConvTipo
    from QPventaConvenio
    where Ecodigo = #session.Ecodigo#
    and <cf_dbfunction name="today"> between <cf_dbfunction name="to_date00" args="QPvtaConvFecIni"> and <cf_dbfunction name="to_date00" args="QPvtaConvFecFin">
    order by QPvtaConvDesc
</cfquery>

<cfquery name="rsCausas" datasource="#session.dsn#">
    select 
    	b.QPvtaConvid, 
        a.QPCid, 
        a.QPCcodigo, 
        a.QPCdescripcion, 
        c.Miso4217 as Moneda, 
        a.QPCmonto as Monto
    from QPCausa a
        inner join QPCausaxConvenio b
            on b.QPCid = a.QPCid
            and b.QPvtaConvid = #rsConvenio.QPvtaConvid#
        inner join Monedas c
            on c.Mcodigo = a.Mcodigo
    where a.Ecodigo = #session.Ecodigo#
    order by a.QPCcodigo
</cfquery>


<cfparam name="LvarCTEtipo" default="">

<cfoutput>
<script language="javascript" type="text/javascript">
	function funcVisible(){
		if(document.form1.QPctaSaldosTipo.value=="1"){
<!---			document.getElementById("QPctaBancoTipoLabel").style.display 	= '';
--->			document.getElementById("QPctaBancoNumLabel").style.display 	= '';
<!---			document.getElementById("QPctaBancoTipo").style.display 	= '';
--->			document.getElementById("QPctaBancoNum").style.display 	= '';
			}
		if(document.form1.QPctaSaldosTipo.value=="2"){
<!---			document.getElementById("QPctaBancoTipoLabel").style.display 	= 'none';
--->			document.getElementById("QPctaBancoNumLabel").style.display 	= 'none';
<!---			document.getElementById("QPctaBancoTipo").style.display 	= 'none';
--->			document.getElementById("QPctaBancoNum").style.display 	= 'none';

				var HTML = "<span id='Contenedor_cuenta'>";
				HTML += "<input name='QPctaBancoNum'  type='text' value='' tabindex='1' maxlength='30' />";
				HTML += "</span>";
				document.getElementById("Contenedor_cuenta").innerHTML = HTML;
			}
	}
	
	function ajaxFunction_Causas(){
		var ajaxRequest;  // The variable that makes Ajax possible!
		var vQPvtaConvid ='';
		vQPvtaConvid = document.form1.QPvtaConvid.value;
		try{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest = new XMLHttpRequest();
		} catch (e){
			// Internet Explorer Browsers
			try{
				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}
	
		ajaxRequest.open("GET", '/cfmx/sif/QPass/operacion/CausasEtiquetasAjax.cfm?QPvtaConvid='+vQPvtaConvid, false);
		ajaxRequest.send(null);
		document.getElementById("contenedor_Causas").innerHTML = ajaxRequest.responseText; 
	}

	function ajaxFunction_Convenio(){
		var ajaxRequest;  // The variable that makes Ajax possible!
		var vQPvtaConvid ='';
		vQPvtaConvid = document.form1.QPvtaConvid.value;
		try{
			// Opera 8.0+, Firefox, Safari
			ajaxRequest = new XMLHttpRequest();
		} catch (e){
			// Internet Explorer Browsers
			try{
				ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try{
					ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e){
					// Something went wrong
					alert("Your browser broke!");
					return false;
				}
			}
		}
	
		ajaxRequest.open("GET", '/cfmx/sif/QPass/operacion/ConvenioComboAjax.cfm?QPvtaConvid='+vQPvtaConvid, false);
		ajaxRequest.send(null);
		document.getElementById("contenedor_tipo").innerHTML = ajaxRequest.responseText; 
		funcVisible();
		ajaxFunction_Causas()
	}
</script>

		<form action="QPassVenTemp_SQL.cfm" method="post" name="form1"  onSubmit="return validar(this);"> 
		<span id="contenedor_ente">
		<input type="hidden" name="QPCente"id="QPCente" tabindex="1" value="-1"/> 
		</span>

        <input name="QPvtaTagid" value="<cfif isdefined("form.QPvtaTagid") and len(trim(form.QPvtaTagid))>#form.QPvtaTagid#</cfif>" type="hidden" />
		<table width="100%" align="left" border="0">
        	<tr>
            	<td align="center">
       	<fieldset style="width:88%">
			<legend>Datos Cliente</legend>
			<table width="100%" align="left" border="0">
				<tr>
					<td align="right" nowrap>*<strong>Ident.:</strong>&nbsp;</td>
					<td align="left" nowrap="nowrap">
						<cfif modo EQ "ALTA"> 
							<select  tabindex="1" name="CTEtipo" onChange="cambiarMascara(this.value);">
								<cfloop query="rsTiposCliente">
									<option value="#rsTiposCliente.QPtipoCteid#">#rsTiposCliente.QPtipoCteDes#</option>
								</cfloop>
							</select>	
						<cfelse>
							<cfif modo NEQ 'ALTA'>#trim(rsDato.QPtipoCteDes)#</cfif>
						</cfif>
                        <input tabindex="1" type="text" name="CTEidentificacion" size="30"
                             value="<cfif modo NEQ "ALTA">#trim(rsDato.QPcteDocumento)#</cfif>" 
							 alt="Identificación"
                             > 
                             <iframe id="frCliente" name="frCliente" src="frCliente.cfm" frameborder="1" height="0" width="0"  scrolling="yes"></iframe>
                    </td>
                    <td align="right">*<strong>Cliente:</strong></td>
					<td colspan="3">
						<input type="text" name="QPcteNombre" maxlength="101" size="40" id="QPcteNombre" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteNombre)#</cfif>"/> 
                    </td>
				</tr>
                <tr>	
                	<td>&nbsp;</td>
                	<td align="right">
						<input  tabindex="-1" type="text" name="SNmask" size="30" readonly value="#LvarCTEtipo#" style="border:none;"> 
					</td>
				</tr>

				<tr>
					<td align="right"><strong>Direcci&oacute;n:</strong></td>
					<td colspan="4">
                    <cfset LvarDireccion = "">
					<cfif modo NEQ 'ALTA'>
                    	<cfset LvarDireccion = trim(rsDato.QPcteDireccion)>
                    </cfif>
                    <textarea  
                    	cols="114" 
                        rows="2" 
                        name="QPcteDireccion" 
                        maxlength="255" 
                        tabindex="1">#LvarDireccion#</textarea>
                     </td>
				</tr>	
				<tr>
					<td align="right"><strong>Telefono1:</strong></td>
					<td colspan="1">
						<input type="text" name="QPcteTelefono1" maxlength="21" size="20" id="QPcteTelefono1" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefono1)#</cfif>"/>
				
					<td align="right"><strong>Telefono2:</strong></td>
					<td colspan="1">
						<input type="text" name="QPcteTelefono2" maxlength="21" size="20" id="QPcteTelefono2" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefono2)#</cfif>"/>
				</tr>
                <tr>
					<td align="right"><strong>Tel. Casa:</strong></td>
					<td colspan="1">
						<input type="text" name="QPcteTelefonoC" maxlength="21" size="20" id="QPcteTelefonoC" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteTelefonoC)#</cfif>"/>
				
					<td align="right" nowrap="nowrap"><strong>Correo:</strong></td>
					<td colspan="1">
						<input type="text" name="QPcteCorreo" maxlength="101" size="40" id="QPcteCorreo" tabindex="1" style="border-spacing:inherit" value="<cfif modo NEQ 'ALTA'>#trim(rsDato.QPcteCorreo)#</cfif>" />
				</tr>
                <tr>
                	<td colspan="6">&nbsp;</td>
                </tr>
                </table>
                </fieldset>
           	</td>
            </tr>
            <tr>
			<td  align="center">
                <fieldset style="width:88%">
				<legend>Datos Venta</legend>
                <table width="100%" align="left" border="0">
                <tr>
					<td align="right"><strong>Fecha:</strong></td>
					<td colspan="5">
						<cfset LvarQPvtaTagFecha =DateFormat(Now(),'DD/MM/YYYY')>
						<cfif modo NEQ 'ALTA'>
                            <cfset LvarQPvtaTagFecha  = DateFormat(#rsDato.QPvtaTagFecha#,'DD/MM/YYYY') > 
                        </cfif>
						<cfif modo NEQ 'ALTA'>
                       	 <cf_sifcalendario name="QPvtaTagFecha" value="#LvarQPvtaTagFecha#" tabindex="1" readOnly = "true">
						<cfelse>
                       	 <cf_sifcalendario name="QPvtaTagFecha" value="#LvarQPvtaTagFecha#" tabindex="1" readOnly = "true">
						</cfif>
                    </td> 
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                       * <strong>TAG:</strong>&nbsp;
                    </td>
                    <td nowrap="nowrap" width="56%" >
                 		<cfif isdefined("rsDato") and LEN(rsDato.QPTidTag) GT 0>
                        	#rsDato.QPTPAN# / #rsDato.QPTNumSerie#
                        <cfelse>
	                        <cfset valuesArray = ArrayNew(1)>
                        	<cfinclude template="QPconlisTags.cfm">
                        </cfif>
                    </td>
                    <td align="right">
                        <strong>Placa:&nbsp;</strong>
                    </td>
                    <td align="left" colspan="3" width="44%">
                        <input name="QPvtaTagPlaca" type="text" value="<cfif modo neq 'Alta'>#rsDato.QPvtaTagPlaca#</cfif>" tabindex="1">
                    </td>
                </tr>
                
                <tr id="trpromotor">
                	<td align="right"><strong>Tag asignado a Promotor:</strong>&nbsp;</td>
                    <td>
                    	<input id="QPPnombre" name="QPPnombre" type="text" readonly="true" value="<cfif modo neq 'Alta'>#rsDato.Promotor#</cfif>" tabindex="1"/>
                        <input id="QPPid" 	  name="QPPid" type="hidden" value="<cfif modo neq 'Alta'>#rsDato.QPPid#</cfif>" tabindex="-1"/>
                        <iframe id="frPromotor" name="frPromotor" src="frPromotor.cfm" frameborder="1" height="0" width="0"  scrolling="yes"></iframe>
                    </td>
                    <td nowrap="nowrap" align="right">
                    	<strong>N&uacute;m. aut.:</strong>
                    </td>
                    <td align="left"><input name="QPvtaAutoriza" value="<cfif modo neq 'Alta'>#rsDato.QPvtaAutoriza#</cfif>" type="text" tabindex="1" maxlength="20" size="25"/></td>
                </tr>
                
                <tr>
                    <td align="right">
                        <strong>Convenio:</strong>&nbsp;
                    </td>
                    <td align="left">
                    	<span id="contenedor_convenio">
                            <select name="QPvtaConvid" tabindex="1" onchange="ajaxFunction_Convenio()">
                                <cfloop query="rsConvenio">
                                    <option value="#rsConvenio.QPvtaConvid#" <cfif modo NEQ 'Alta' and rsConvenio.QPvtaConvid eq rsDato.QPvtaConvid>selected="selected"</cfif>>#rsConvenio.QPvtaConvCod# - #rsConvenio.QPvtaConvDesc#</option>
                                </cfloop>
                            </select>
                        </span>
                    </td>
               
                	<td align="right"><strong>Tipo:</strong>&nbsp;</td>
                    <td>
                    	<span id="contenedor_tipo">
                            <select name="QPctaSaldosTipo" tabindex="1" onchange="funcVisible();">
	                            <cfif rsConvenio.QPvtaConvTipo eq 1>
                                    <option value="1">PostPago</option>
                                </cfif>
                                <cfif rsConvenio.QPvtaConvTipo eq 2>
                                    <option value="2">PrePago</option>
                                </cfif>
                            </select>
                        </span>
                    </td>
                </tr>
                <tr>
                    <!---<td align="right" id="QPctaBancoTipoLabel">
					<strong>Tipo Cuenta:</strong>&nbsp;
					</td>
					<td align="left" id="QPctaBancoTipo">
						<input name="QPctaBancoTipo"  type="text" value="<cfif modo neq 'Alta'>#rsDato.QPctaBancoTipo#</cfif>" tabindex="1"  maxlength="10"/>
					</td>--->
                	
                    <td align="right" id="QPctaBancoNumLabel"><strong>*Cuenta:</strong>&nbsp;</td>
                    <td id="QPctaBancoNum" colspan="3">
                        <span id="Contenedor_cuenta">
                        	<input name="QPctaBancoNum"  type="text" value="<cfif modo neq 'Alta'>#rsDato.QPctaBancoNum#</cfif>" tabindex="1" maxlength="30" />
						</span>
                    </td>
                    
                </tr>
                </table>
                <input name="QPctaBancoTipo"  type="hidden" value="-1" />
                <input name="QPctaBancoCC"  type="hidden" value="-1" tabindex="-1" />
                <input name="Mcodigo"  type="hidden" value="-1" tabindex="-1" />
                </td>
                </tr>			
			    <tr>
                	<td align="center">
                    	<fieldset style="width:88%">
							<legend>Causas del Convenio</legend>
                            <span id="contenedor_Causas">
                                <table>
                                    <cfset LvarCausa = "">
                                    <cfloop query="rsCausas">
                                       <tr>
                                            <td>#rsCausas.QPCcodigo#&nbsp;&nbsp;&nbsp;</td>
                                            <td>#rsCausas.QPCdescripcion#&nbsp;&nbsp;&nbsp;</td>
                                            <td align="right">#numberformat(Monto, "999,999,999.00")#</td>
                                            <td align="right">#Moneda#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </span>
                		</fieldset>
                	</td>
                </tr>
			
				<tr valign="baseline"> 
					<td colspan="6" align="center" nowrap>
						<cf_botones modo="#modo#" tabindex="1" exclude='Baja'><!---  include="Reporte" --->
					</td>
				<tr>
					<td align="left" nowrap colspan="6">
						* campos obligatorios
					</td>
				</tr>				
				<tr>
					<td colspan="3">
						<cfset ts = "">
						<cfif modo NEQ "ALTA">
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsDato.ts_rversion#" returnvariable="ts">        
							</cfinvoke>
							<input type="hidden" name="QPcteid" value="#rsDato.QPcteid#" >
							<input type="hidden" name="ts_rversion" value="#ts#" >
						</cfif>
							<input type="hidden" name="Pagina3" 
							value="
						<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
							#form.pagenum3#
						<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
							#url.PageNum_lista3#
						</cfif>">
					</td>
				</tr>
			
        </table>
		</form>

</cfoutput>

<cf_qforms form="form1">
    <cf_qformsrequiredfield args="CTEidentificacion,Identificación">
    <cfif modo EQ 'ALTA'>
    	<cf_qformsrequiredfield args="QPTidTag,Tag">
	</cfif>
    <cf_qformsrequiredfield args="QPcteNombre,Cliente">
    <!--- <cf_qformsrequiredfield args="QPvtaConvid,Convenio"> --->
</cf_qforms>

<cfoutput>
    <script language="javascript1" type="text/javascript">
		<cfif modo EQ "ALTA">
			document.form1.CTEtipo.focus();
		</cfif>
		
		function funcPromotor(){
            document.getElementById("frPromotor").src = "frPromotor.cfm?QPTidTag="+document.form1.QPTidTag.value;
        }
        funcVisible();
        function trim(dato) {
            return dato.replace(/^\s*|\s*$/g,"");
        }
        
        function validarEmail(valor) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(valor)){
                return (true)
            } 
            else {
                return (false);
            }
        }
    
        function  validar(){
            var error = false;
            var mensaje = 'Se presentaron los siguientes errores:\n';
                
                if ( trim(document.form1.QPcteCorreo.value) != '' ){
                    if (validarEmail(document.form1.QPcteCorreo.value) == false){
                        error = true;
                        mensaje = mensaje + " - El correo electrónico no tiene un formato valido.\n";
                    
                    }
                }
            
            if (error){
                alert(mensaje);
                return false;
            } else {
            	if (confirm('¿Está seguro que los datos son correctos y que desea realizar la venta?'))
					{
						return true
				} else {
						return false;
					}	
			}
        }
        
        
		<cfif modo EQ 'ALTA'>
			document.getElementById("trpromotor").style.display 	= 'none';
		<cfelseif isdefined("rsDato") and len(trim(rsDato.QPPid)) eq 0>
			document.getElementById("trpromotor").style.display 	= 'none';
		</cfif>
		function funcReporte(){
			deshabilitarValidacion();
			alert('En construcción');
			return false;
		}
		function funcCliente(){
			document.getElementById("frCliente").src = "frCliente.cfm?CTEidentificacion="+document.form1.CTEidentificacion.value+"&CTEtipo="+document.form1.CTEtipo.value;
		}
    </script>
</cfoutput>
