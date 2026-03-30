<cfinvoke key="LB_Titulo" default="Lote de Impresion"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_Lote" default="Lote"	returnvariable="LB_Lote"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_Fecha" default="Fecha"	returnvariable="LB_Fecha"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_Codigo" default="C&oacute;digo"	returnvariable="LB_Codigo"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n"	returnvariable="LB_Descripcion"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_ImpresoInicial" default="Impreso Inicial"	returnvariable="LB_ImpresoInicial"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
<cfinvoke key="LB_ImpresoFinal" default="Impreso Final"	returnvariable="LB_ImpresoFinal"	method="Translate" component="sif.Componentes.Translate"  
xmlfile="ReporteOrdenPagoDet-filtro.xml"/>
	<form name="formFiltro" method="post" action="ReporteOrdenPagoDet-form.cfm" style="margin: '0' ">
		<table width="100%"  border="0" cellpadding="1" cellspacing="1">
			<tr><td>&nbsp;</td></tr>
			<tr>
			    <td nowrap align="right"><strong><cf_translate key=LB_TrabajarTesoreria>Trabajar con Tesorería</cf_translate>:</strong>&nbsp;</td>
				<td><cf_cboTESid tabindex="1"></td>
				<td align="right"><strong><cf_translate key=LB_EmpresaPago>Empresa&nbsp;Pago</cf_translate>:</strong></td>
				<td><cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1"></td>
			 </tr>
			 <tr>
				<td nowrap align="right"><strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong></td>
				<td><input type="text" name="Beneficiario_F" size="60" tabindex="1"></td>
				<td align="right" nowrap><strong><cf_translate key=LB_CuentaPago>Cuenta Pago</cf_translate>:</strong></td>					
				<td><cf_cboTESCBid name="CBidPago_F" all="yes" tabindex="1" ></td>										
			  </tr>
			  <tr>
				<td align="right" nowrap><strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong></td>
				<td nowrap valign="middle">
					<select name="TESOPestado_F" id="TESOPestado_F" tabindex="1">
						<option value="-1">-- <cf_translate key=LB_Todos>Todos</cf_translate> --</option>
						<option value="10"><cf_translate key=LB_EnPreparacion>En Preparación</cf_translate></option>
						<option value="11"><cf_translate key=LB_Enemison>En Emisión</cf_translate></option>
						<option value="12"><cf_translate key=LB_Emitidas>Emitidas</cf_translate></option>
						<option value="13"><cf_translate key=LB_Anuladas>Anuladas</cf_translate></option>
					</select>
				</td>
				<td align="right" nowrap><strong><cf_translate key=LB_MonedaPago>Moneda Pago</cf_translate>:</strong></td>
				<td nowrap valign="middle">
				<cfquery name="rsMonedas" datasource="#session.DSN#">
					select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
					  from Monedas m 
						inner join TESempresas e
						  on e.TESid = #session.Tesoreria.TESid#
						 and e.Ecodigo = m.Ecodigo
				</cfquery>
					<select name="Miso4217Pago_F" tabindex="1">
						<option value="">(<cf_translate key=LB_Todos>Todas las monedas</cf_translate>)</option>
						<cfoutput query="rsMonedas">
							<option value="#Miso4217#">#Mnombre#</option>
						</cfoutput>
					</select>
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap><strong><cf_translate key=LB_NumOrden>Num.Orden</cf_translate>:</strong></td>
				<td><input name="TESOPnumero_F" type="text" tabindex="1" size="22"></td>
				<td align="right" nowrap><strong>&nbsp;<cf_translate key=LB_DocumentoPago>Documento Pago</cf_translate>:</strong></td>
				<td><input name="DocPago_F" type="text" tabindex="1" size="20"></td>
			  </tr>
               <tr>
                    <td align="right" nowrap><strong><cf_translate key=LB_Oficina>Oficina</cf_translate>:</strong>
                    </td>
                    <td align="right" nowrap>
                    <cfif isdefined("form.Ocodigo") and form.Ocodigo NEQ -1>    
                        <cf_sifoficinas form="formFiltro" id="#form.Ocodigo#">
                    <cfelse>
                        <cf_sifoficinas form="formFiltro">
                    </cfif>
                    </td>
                </tr>
			  <tr>
			  <tr> <td class="fileLabel" align="right"><strong><cf_translate key=LB_Formato>Formato</cf_translate>:</strong></td>
				  <td>
					<select name="formato" tabindex="1">
						<option value="flashpaper">Flashpaper</option>
						<option value="pdf">Pdf</option>
						<option value="excel"><cf_translate key=LB_ExportarArchivoE>Exportar a Archivo Excel</cf_translate></option>
						<option value="txt"><cf_translate key=LB_ExportarArchivoT>Exportar a Archivo TXT</cf_translate></option>
					</select>
				  </td>
			      
			      <td align="right"><strong><cf_translate key=LB_FechaIni>Fecha desde</cf_translate>:&nbsp;</strong></td>
			      <td><cf_sifcalendario form="formFiltro" value="" name="TESOPfechaPago_I" tabindex="1"></td>   
			 </tr>
			 <tr>
				 <td align="right"><strong><cf_translate key=LB_LoteImpresion>Lote de Impresión</cf_translate>:</strong>&nbsp;</td>
                 <td align="left" ><input name="lote" type="radio" onclick="MostrarDivs()" value="1" checked="checked" /></td>                 
			      <td align="right"><strong><cf_translate key=LB_FechaFin>Fecha Hasta</cf_translate>:&nbsp;</strong></td>
			      <td><cf_sifcalendario form="formFiltro" value="" name="TESOPfechaPago_F" tabindex="1"></td>   
			  </tr>			  
               <tr>
			    <td align="right"><strong><cf_translate key=LB_LoteTransferencia>Lote de Transferencia</cf_translate>:</strong>&nbsp;</td>
                <td align="left"><input type="radio" name="lote" value="2" onclick="MostrarDivs()" /></td>                
                <td align="center" colspan="2">&nbsp;</td>
	          </tr>
           <tr>           
            <td align="right" width="20%">
                 <div id="lbLIInit" ><strong><cf_translate key=LB_LoteImpresionInicial>Lote Impresión Inicial</cf_translate>:</strong></div>
                 <div id="lbLTInit" style="display:none"><strong><cf_translate key=LB_LoteTransferenciaTransferencia>Lote Transferencia Inicial</cf_translate>:</strong></div>
            </td> 
             <td>
                <div id="LIiniti">
						 <cf_conlis      
                                campos = "TESCFLid,TESCFLfecha, CBcodigo, CBdescripcion, TESCFLimpresoIni, TESCFLimpresoFin"
                                desplegables = "S,N,N,N,N,N"
                                modificables = "S,S,S,S,S,S"
                                size = "30,30,20,20,20,20"
                                enteros="20,20,20,20,20,20"
                                valuesArray=""
                                title="Lotes de Impresión"
                                tabla="TEScontrolFormulariosL a inner join CuentasBancos cb on a.CBid = cb.CBid"                                       
                                columnas="a.TESCFLid, a.TESCFLfecha, cb.CBcodigo, cb.CBdescripcion, a.TESCFLimpresoIni, a.TESCFLimpresoFin"               
                                filtro="1 = 1 and TESCFLid is not null order by TESCFLid desc"                                                           
                                desplegar="TESCFLid,TESCFLfecha,CBcodigo, CBdescripcion,TESCFLimpresoIni,TESCFLimpresoFin"
                                etiquetas="#LB_Lote#, #LB_Fecha#, #LB_Codigo#, #LB_Descripcion#, #LB_ImpresoInicial#, #LB_ImpresoFinal#"
                                formatos="I,D,S,S,S,S"
                                readonly="false"
                                MaxRowsQuery="500"
                                align="left,left,left,left,left,left"
                                form="formFiltro"
                                asignar="TESCFLid,TESCFLfecha,CBcodigo, CBdescripcion,TESCFLimpresoIni,TESCFLimpresoFin"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen Lotes de impresion --"
                                tabindex="1"
                                top="100"
                                Funcion="cantidadNumeros()"
                                left="400"
                                width="650"
                                height="500"
                                asignarformatos="I,S,S,S,S,S"> 
                      </div>
                      <div id="LTInit" style="display:none;">
						 <cf_conlis      
                                campos = "TESTLid ,TESTLfecha, TESTLreferencia, TESTLtotalDebitado"
                                desplegables = "S,N,N,N"
                                modificables = "N,N,N,N"
                                size = "30,20,20,20"
                                valuesArray=""
                                title="Lotes de transferencia"
                                tabla="TEStransferenciasL a"                                       
                                columnas=" a.TESTLid ,a.TESTLfecha, a.TESTLreferencia, a.TESTLtotalDebitado"               
                                filtro="1 = 1 and a.TESTLid is not null order by TESTLid desc"                                                           
                                desplegar="TESTLid ,TESTLfecha, TESTLreferencia, TESTLtotalDebitado"
                                etiquetas="Lote, Fecha, Referencia, Debitado"
                                formatos="I,D,S,M"
                                readonly="false"
                                MaxRowsQuery="500"
                                align="left,left,left,left"
                                form="formFiltro"
                                asignar="TESTLid ,TESTLfecha, TESTLreferencia, TESTLtotalDebitado"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen lotes de transferencia --"
                                tabindex="2"
                                top="100"
                                left="400"
                                width="650"
                                height="500"
                                asignarformatos="I,S,S,S"> 
                      </div>
               </td>         
             </tr>
             <tr>           
            <td align="right" width="20%">
                 <div id="lbLIFin"><strong>Lote Impresión Final:</strong></div>
                 <div id="lbLTFin" style="display:none"><strong>Lote Transferencia Final:</strong></div>
            </td> 
             <td>
                <div id="LIFin">
						 <cf_conlis      
                                campos = "TESCFLid2,TESCFLfecha2, CBcodigo2, CBdescripcion2, TESCFLimpresoIni2, TESCFLimpresoFin2"
                                desplegables = "S,N,N,N,N,N"
                                modificables = "S,S,S,S,S,S"
                                size = "30,20,20,20,20,20"                              
                                valuesArray=""
                                title="Lotes de Impresión"
                                tabla="TEScontrolFormulariosL a inner join CuentasBancos cb on a.CBid = cb.CBid"                                       
                                columnas="a.TESCFLid as TESCFLid2, a.TESCFLfecha as TESCFLfecha2, cb.CBcodigo as CBcodigo2, CBdescripcion as CBdescripcion2, a.TESCFLimpresoIni as TESCFLimpresoIni2, a.TESCFLimpresoFin as TESCFLimpresoFin2"               
                                filtro="1 = 1 and TESCFLid is not null order by TESCFLid desc"                                                           
                                desplegar="TESCFLid2,TESCFLfecha2,CBcodigo2, CBdescripcion2,TESCFLimpresoIni2,TESCFLimpresoFin2"
                                 filtrar_por="TESCFLid,TESCFLfecha,CBcodigo, CBdescripcion,TESCFLimpresoIni,TESCFLimpresoFin"
                                etiquetas="Lote, Fecha, Cuenta Codigo, Descripcion, Impreso Inicial, Impreso Final"
                                formatos="I,D,S,S,S,S"
                                readonly="false"
                                MaxRowsQuery="500"
                                align="left,left,left,left,left,left"
                                form="formFiltro"
                                asignar="TESCFLid2,TESCFLfecha2,CBcodigo2, CBdescripcion2,TESCFLimpresoIni2,TESCFLimpresoFin2"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen Lotes de impresion --"
                                tabindex="1"
                                top="100"
                                left="400"
                                width="650"
                                height="500"
                                asignarformatos="I,S,S,S,S,S">
                      </div>
                      <div id="LTFin" style="display:none">                               
                                 <cf_conlis      
                                campos = "TESTLid2 ,TESTLfecha2, TESTLreferencia2, TESTLtotalDebitado2"
                                desplegables = "S,N,N,N"
                                modificables = "I,N,N,N"
                                size = "30,20,20,20"
                                valuesArray=""
                                title="Lotes de transferencia"
                                tabla="TEStransferenciasL a"                                       
                                columnas=" a.TESTLid as TESTLid2 ,a.TESTLfecha as TESTLfecha2, a.TESTLreferencia as TESTLreferencia2, a.TESTLtotalDebitado as TESTLtotalDebitado2"               
                                filtro="1 = 1 and a.TESTLid is not null order by TESTLid desc"                                                           
                                desplegar="TESTLid2 ,TESTLfecha2, TESTLreferencia2, TESTLtotalDebitado2"
                                filtrar_por="TESTLid ,TESTLfecha, TESTLreferencia, TESTLtotalDebitado"
                                etiquetas="Lote, Fecha, Referencia, Debitado"
                                formatos="N,D,S,M"
                                readonly="false"
                                MaxRowsQuery="500"
                                align="left,left,left,left"
                                form="formFiltro"
                                asignar="TESTLid2 ,TESTLfecha2, TESTLreferencia2, TESTLtotalDebitado2"
                                showEmptyListMsg="true"
                                EmptyListMsg="-- No existen lotes de transferencia --"
                                tabindex="2"
                                top="100"
                                left="400"
                                width="600"
                                height="500"
                                asignarformatos="I,S,S,S">
                      </div>
               </td>         
             </tr>
             <tr>
			  <td align="center" colspan="4"><cf_botones values="Consultar,Limpiar" tabindex="1"></td>
			  </tr> 			  
			</table>
		</form>
<script language="javascript">
function cantidadNumeros()
{
	
}
function MostrarDivs()
{ 	
   var i
    for (i=0;i<document.formFiltro.lote.length;i++){
       if (document.formFiltro.lote[i].checked)
          break;
     }	
    var op =   document.formFiltro.lote[i].value
	if(op == 1)
	{
	  document.getElementById('lbLIInit').style.display = "";<!----Label Lote impresion Inicial------>
	  document.getElementById('lbLTInit').style.display = "none";<!----Label Lote transferencia Inicial------>
	  document.getElementById('LIiniti').style.display = ""; <!----campo Lote impresion Inicial------>
	  document.getElementById('LTInit').style.display = "none";  <!----campo Lote transferencia Inicial------>	  
  
	  document.getElementById('lbLIFin').style.display = ""; <!----Label Lote impresion Final------>
	  document.getElementById('lbLTFin').style.display = "none"; <!----Label Lote transferencia Final------>
	  document.getElementById('LIFin').style.display = "";   <!----campo Lote impresion Final------>
	  document.getElementById('LTFin').style.display = "none";   <!----campo Lote Tranferencia Final------>  
	}
	else if(op == 2)
	{
	  document.getElementById('lbLIInit').style.display = "none";<!----Label Lote impresion Inicial------>
	  document.getElementById('lbLTInit').style.display = "";<!----Label Lote transferencia Inicial------>
	  document.getElementById('LIiniti').style.display = "none"; <!----campo Lote impresion Inicial------>
	  document.getElementById('LTInit').style.display = "";  <!----campo Lote transferencia Inicial------>	  
  
	  document.getElementById('lbLIFin').style.display = "none"; <!----Label Lote impresion Final------>
	  document.getElementById('lbLTFin').style.display = ""; <!----Label Lote transferencia Final------>
	  document.getElementById('LIFin').style.display = "none";   <!----campo Lote impresion Final------>
	  document.getElementById('LTFin').style.display = "";   <!----campo Lote Tranferencia Final------>  
	}

}
</script>

