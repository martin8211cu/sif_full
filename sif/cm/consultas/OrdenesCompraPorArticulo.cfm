<!--- Proveduria Corporativa --->
<cfparam name="form.EcodigoE" default="#session.Ecodigo#">
<cfset lvarProvCorp = false>
<cfset lvarFiltroEcodigo = #session.Ecodigo#>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
		select EPCid
		from EProveduriaCorporativa
		where Ecodigo = #session.Ecodigo#
		 and EPCempresaAdmin = #session.Ecodigo#
	</cfquery>
	<cfif rsEProvCorp.recordcount gte 1>
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
        <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
            <cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
        </cfloop>
	</cfif>    
	<cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
		<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
	</cfif>
</cfif>

<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_templateheader title="Compras - &Oacute;rdenes de Compra por tipo de Item">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Rango de &Oacute;rdenes de Compra por tipo de Item, fecha y estado'>

	<cfsavecontent variable="qformsFocusOnDetalle">
        mostrarTipoFiltro();
    </cfsavecontent>        
    
    <!--- Categorias de Activos Fijos --->
    <cfquery name="rsCategorias" datasource="#session.DSN#" >
        select Distinct ACcodigo, ACdescripcion 
        from ACategoria 
        where Ecodigo in (#Form.EcodigoE#)
        Order By ACdescripcion
    </cfquery>      
            
    <form name="form1" method="post" action="OrdenesCompraPorArticulo-form.cfm">
        <table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
            <tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
            <tr>
                <td width="50%" valign="top">
                    <table width="100%">
                        <tr>
                            <td> 
                                <cf_web_portlet_start border="true" titulo="&Oacute;rdenes de Compra por Tipo de Item" skin="info1">
                                    <div align="justify">
                                        <p>Muestra las &oacute;rdenes de compra de acuerdo al rango del tipo de Item escigido, que puede ser un art&iacute;culo, un servicio o un activo fijo el cual quiere adquirir la empresa, tambi&eacute;n se puede filtrar por rango de fechas, por &uacute;ltimo se escoge el estado de la &oacute;rden que puede ser todos los estados o solamente uno</p>
                                    </div>
                                <cf_web_portlet_end> 
                            </td>
                        </tr>
                    </table>
                </td>
                
                <td width="50%" valign="top">
                    <table width="100%" cellpadding="0" cellspacing="0" align="center">
						<cfif rsEProvCorp.recordcount gte 1>    
                            <tr>
                                <td nowrap align="right"><strong>Empresa:&nbsp;</strong></td>
                                <td colspan="2">
                                    <select name="EcodigoE" onchange="cargarPagina();">
                                        <option value="<cfoutput>#Ecodigos#</cfoutput>">--Todas--</option>
                                        <cfloop query="rsDProvCorp">
                                            <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.EcodigoE') and form.EcodigoE eq rsDProvCorp.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                        </cfloop>	
                                    </select>  
                                </td>
                            </tr>
                         <cfelse>
                            <input type="hidden" name="EcodigoE" value="-2"/>
                        </cfif>
                        <tr><td>&nbsp;</td></tr>                      
                        <tr>
                            <td align="right"><strong>Tipo de Item&nbsp;&nbsp;</strong></td>
                            <td width="34%">
                                <select name="TipoReporte" onChange="javascript:mostrarTipoFiltro();">
                                    <option value="A">Art&iacute;culo</option>
                                    <option value="S">Servicio</option>
                                    <option value="F">Activo Fijo</option>
                                </select>   
                                <input type="hidden" name="TRM" value="1" >                          	
                            </td>
                        </tr>
                        <td>&nbsp;</td>
                        <!--- Articulo, clasificacion y servicio --->               
                        <tr id="divArticulo1" style="display:">
                            <td align="right" nowrap><strong>Art&iacute;culo Inicial:&nbsp;</strong>&nbsp;</td>
                            <td nowrap colspan="3">
                                <input type="text" name="codigoArticulo1" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(1,this.value);" >									
                                <input type="text" name="NombreArticulo1" id="NombreArticulo1" tabindex="1" readonly value="" size="40" maxlength="80">
                                <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de &Aacute;rticulos" name="Art1" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisArticulos(1);'></a>
                                <input type="hidden" name="IDArt1" value="" >
                            </td>
                        </tr>
                    
                        <tr id="divArticulo2" style="display:">
                            <td align="right" nowrap><strong>Art&iacute;culo Final:&nbsp;</strong>&nbsp;</td>
                            <td nowrap colspan="3">
                                <input type="text" name="codigoArticulo2" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(2,this.value);" >									
                                <input type="text" name="NombreArticulo2" id="NombreArticulo2" tabindex="1" readonly value="" size="40" maxlength="80">
                                <a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de &Aacute;rticulos" name="Art1" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisArticulos(2);'></a>
                                <input type="hidden" name="IDArt2" value="" >
                            </td>
                        </tr>            
                        <tr id="divActivo1" style="display:none">
                            <td align="right" nowrap><strong>Categor&iacute;a Inicial:&nbsp;</strong>&nbsp;</td>
                            <td nowrap colspan="3">
                           	<select name="ACcodigo1" tabindex="2" onchange="cambiarCategorias();">
                        	<cfoutput>
                                <cfloop query="rsCategorias">
                                    <option value="#rsCategorias.ACdescripcion#">#rsCategorias.ACdescripcion#</option>
                                </cfloop>
                           	</cfoutput>
                        	</select>
                            </td>                            
                        </tr>
                        
                        <tr id="divActivo2" style="display:none">
                            <td align="right" nowrap><strong>Categor&iacute;a Final:&nbsp;</strong>&nbsp;</td>
                            <td nowrap colspan="3">
                           	<select name="ACcodigo2" tabindex="2" >
                        	<cfoutput>
                                <cfloop query="rsCategorias">
                                    <option value="#rsCategorias.ACdescripcion#">#rsCategorias.ACdescripcion#</option>
                                </cfloop>
                           	</cfoutput>
                        	</select>
                            </td>                            
                        </tr>                        
                        
                        <tr id="divServicio1" style="display:none">
                        	<td align="right" nowrap><strong>Servicio Inicial:&nbsp;</strong>&nbsp;</td>
                        	<!---<td><cf_sifconceptos Prueba="1" desc="Cdescripcion" tabindex="2" Ecodigo="#session.Ecodigo#"></td>--->
                            <td><cf_sifconceptos desc="Cdescripcion" verClasificacion="0" tabindex="2" isCorp="true" Empresas="#Form.EcodigoE#"></td>
                        </tr>
                    
                        <tr id="divServicio2" style="display:none">
                            <td align="right" nowrap><strong>Servicio Final:&nbsp;</strong>&nbsp;</td>
                            <!---<td><cf_sifconceptos Prueba="2" desc="Cdescripcion" tabindex="2" Ecodigo="#session.Ecodigo#"></td>--->
                            <td><cf_sifconceptos desc="Cdescripcion2" verClasificacion="0" name="Ccodigo2" id="Cid2" cuentac="cuentac2" tabindex="2" isCorp="true" Empresas="#Form.EcodigoE#"></td>
                        </tr>                                                 
                        <tr><td>&nbsp;</td></tr>
                            <tr align="left">
                            <td width="50%" nowrap align="right"><strong>De la Fecha:&nbsp;</strong></div></td>
                            <td width="50%" nowrap><cf_sifcalendario name="FechaInicial" value="" tabindex="1"></td>
                            <td width="1%">&nbsp;</td>
                        </tr>
                        <tr align="left">
                            <td width="50%" nowrap align="right"><strong>Hasta:&nbsp;</strong></div></td>
                            <td width="50%" nowrap><cf_sifcalendario name="FechaFinal" value="" tabindex="1"></td>
                            <td width="1%">&nbsp;</td>
                        </tr>
                        <tr><td>&nbsp;</td>
                        </tr>                                                        <tr>
                            <td nowrap align="right"><strong>Estado:&nbsp;</strong></td>
                            <td>
                                <select name="EstadOrden" >
                                    <option value="T">---Todas---</option>
                                    <option value="APS">Aplicada Parcialmente Surtida</option>
                                    <option value="ATS">Aplicada Totalmente Surtida</option>
                                    <option value="-10">Pendiente de Aprobación Presupuestaria</option>
                                    <option value="-8">Orden Rechazada</option>
                                    <option value="-7">En Proceso de Aprobación</option>
                                    <option value="0">Pendiente</option>
                                    <option value="5">Pendiente Vía Proceso</option>
                                    <option value="7">Pendiente OC Directa</option>
                                    <option value="8">Pendiente Vía Contrato</option>
                                    <option value="9">Autorizada por jefe Compras</option>
                                    <option value="70">Ordenes Anuladas</option>
                                    <option value="55">Ordenes Canceladas Parcialmente Surtida</option>
                                    <option value="60">Ordenes Canceladas</option>
                                </select>
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td>  
                        <tr>
                            <td align="right" nowrap="nowrap"><strong>Exportar a Excel:&nbsp;</strong>
                            </td>
                            <td><input type="checkbox" name="toExcel" /></td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                            <td align="center" colspan="4">
                                <input type="submit" name="Consultar" value="Consultar">
                                <input type="reset"  name="Limpiar" value="Limpiar">
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
    <iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
    
    <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisArticulos(tipo) {
		var params = "";
		var _form = document.form1;
		var empresa = _form.EcodigoE.value;
		
		if(tipo == 1)
			params = "?formulario=form1&IDArt=IDArt1&codigoArticulo=codigoArticulo1&NombreArticulo=NombreArticulo1&Empresas=" + empresa;
		else
			params = "?formulario=form1&IDArt=IDArt2&codigoArticulo=codigoArticulo2&NombreArticulo=NombreArticulo2&Empresas=" + empresa;
			
		popUpWindow("/cfmx/sif/cm/consultas/ConlisArticulosConsulta.cfm"+params,250,200,650,400);
	}
	
	function existeOrden(opcion, value){
		var _form = document.form1;
		var empresa = _form.EcodigoE.value;
				
		if ( value !='' ){
			document.getElementById("frComprador").src = "ArticulosConsulta.cfm?CodArt=" + value + "&opcion="+ opcion + "&Empresas=" + empresa;
		}
	}
	
	function mostrarTipoFiltro(){
									  
		var _form = document.form1;
		var _divArticulo1 = document.getElementById("divArticulo1");
		var _divArticulo2 = document.getElementById("divArticulo2");			
		var _divServicio1 = document.getElementById("divServicio1");
		var _divServicio2 = document.getElementById("divServicio2");
		var _divActivo1 = document.getElementById("divActivo1");
		var _divActivo2 = document.getElementById("divActivo2");
		
		if(_form.TipoReporte.value == "A"){
			if(_divArticulo1.style.display == 'none'){
				_divArticulo1.style.display = '';
				_divArticulo2.style.display = '';
				document.form1.TRM.value = "1";
			}
			else {
				_divArticulo1.style.display = 'none';
				_divArticulo2.style.display = 'none';
			}
			divServicio1.style.display = 'none';
			divServicio2.style.display = 'none';
			divActivo1.style.display = 'none';
			divActivo2.style.display = 'none';
		}
		else if(_form.TipoReporte.value == "S"){
			if(_divServicio1.style.display == 'none'){
				_divServicio1.style.display = '';
				_divServicio2.style.display = '';
				document.form1.TRM.value = "2";
			}
			else {
				_divServicio1.style.display = 'none';
				_divServicio2.style.display = 'none';		
			}
			_divArticulo1.style.display = 'none';
			_divArticulo2.style.display = 'none';
			_divActivo1.style.display = 'none';
			_divActivo2.style.display = 'none';
		}
		else if(_form.TipoReporte.value == "F") {
			if(_divActivo1.style.display == 'none'){
				_divActivo1.style.display = '';
				_divActivo2.style.display = '';
				document.form1.TRM.value = "3";
			}
			else{ 
				_divActivo1.style.display = 'none';	
				_divActivo2.style.display = 'none';				
			}
			_divArticulo1.style.display = 'none';
			_divArticulo2.style.display = 'none';
			_divServicio1.style.display = 'none';
			_divServicio2.style.display = 'none';
		}
	}
	
	function cambiarCategorias(){
		var categoria1 = document.form1.ACcodigo1.value;
		var comboCategoria1 = document.form1.ACcodigo1;
		var comboCategoria2 = document.form1.ACcodigo2;
		var contador1 = 0;
		var contador2 = 0;
		var bandera = false;
		comboCategoria2.length = 0;
		for(i = 0; i <= comboCategoria1.length; i++){
			if(!bandera){
				if (comboCategoria1.options[contador1].value == categoria1) {						
					bandera = true;
					contador1--;
				}
				contador1++;
			}
			else{
				comboCategoria2.length = contador2 + 1;
				comboCategoria2.options[contador2].value = comboCategoria1.options[contador1].value;
				comboCategoria2.options[contador2].text = comboCategoria1.options[contador1].text;
				contador1++;
				contador2++;
			}
		}					
	}
	
	function cargarPagina(){
		document.form1.action = "";
		document.form1.submit();
	}
	
</script>        