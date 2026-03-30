<!--- 
	Desarrollado por Rosalba Vargas Díaz APH
	Fecha: 18-04-2013
	Motivo: Importacion de Movimientos Adicionales de Utilidad Bruta
--->
	 <cf_templateheader title="Importaci&oacute;n de Movimientos Adicionales de Utilidad Bruta">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Movimientos Adicionales de Utilidad Bruta sin Aplicar'>

<!---Lista de Movimientos Adicionales sin aplicar--->

<cfquery name="rsLista" datasource="#Session.DSN#">
select a.ID,
    a.fltPeriodo,
    a.fltMes,
    a.Contrato,
    a.fltTipoDoc,
    a.fltNaturaleza,
    a.Importe,
    a.Observaciones,
    a.Poliza,
    a.fltMoneda,
    a.fltOperacion
	from ImportVtasCost a
</cfquery>
		<cfif rsLista.recordCount LT 1>
			<center>

        		<table border="0" align="center">
            		<tr>
                		<td width="100%" align="center">
                      		<strong> NO HAY MOVIMIENTOS PENDIENTES DE APLICAR</strong>
                    	</td>
                	</tr>
                </table>
        	</center>
        
        
        </cfif>



<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfparam name="PageNum_rsLista" default="1">

<cfset MaxRows_rsLista = 20 > <!--- 20 --->

<!--- Paginacion --->
<cfset StartRow_rsLista		= Min( (PageNum_rsLista-1)*MaxRows_rsLista+1, Max(rsLista.RecordCount,1) )>
<cfset EndRow_rsLista		= Min(StartRow_rsLista+MaxRows_rsLista-1,rsLista.RecordCount)>
<cfset TotalPages_rsLista	= Ceiling(rsLista.RecordCount/MaxRows_rsLista)>

<!--- ========================================================================================= --->
<!--- QueryString_rsLista (Declara y limpi ala variable ) --->
<!--- ========================================================================================= --->
<cfset QueryString_rsLista = Iif(CGI.QUERY_STRING NEQ "",DE("&"&CGI.QUERY_STRING),DE(""))>
<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"PageNum_rsLista=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Fecha=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Fecha")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Fecha=#Form.Fecha#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Transaccion=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Transaccion")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Transaccion=#Form.Transaccion#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Usuario=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Usuario")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Usuario=#Form.Usuario#" >
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_rsLista,"Moneda=","&")>
<cfif tempPos NEQ 0>
  <cfset QueryString_rsLista = ListDeleteAt(QueryString_rsLista,tempPos,"&")>
</cfif>
<cfif isdefined("Form.Moneda")>
	<cfset QueryString_rsLista = QueryString_rsLista & "&Moneda=#Form.Moneda#" >
</cfif>
<!--- ========================================================================================= --->

<style type="text/css">
	.tituloFiltros {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>



<script language="JavaScript" type="text/javascript">

	
	function checkAll(f) {
		if (f.ID != null) {
			if (f.ID.value != null) {
				if (!f.ID.disabled) f.ID.checked = f.chkAll.checked;
			} else {
				for (var i=0; i<f.ID.length; i++) {
					if (!f.ID[i].disabled) f.ID[i].checked = f.chkAll.checked;
				}
			}
		}
	}
	
	function validaAplicacion(f) {
		if (f.ID != null) {
			if (f.ID.value != null) {
				if (!f.ID.checked) { 
					alert("Debe escoger un Registro para aplicar");
					return false;
				} else {
					return confirm("¿Está seguro de que desea aplicar los Registros Seleccionados?");
				}
			} else {
				for (var i=0; i<f.ID.length; i++) {
					if (f.ID[i].checked) {
						return confirm("¿Está seguro de que desea aplicar los Registros Seleccionados?");
					}x
				}
				alert("Debe escoger un Registro para aplicar");
				return false;
			}
		} else {
			alert("No hay Movimientos Adicionales para aplicar");
			return false;
		}
	}
</script>

  <tr> 
    <td> 
		<cfif rsLista.recordCount GT 0>
   
    <form style="margin:0;" name="form1" method="post" action="ImportaVtas-CostoOrden-sql.cfm">

    	<fieldset>

			 <table border="0" width="100%" cellpadding="0" cellspacing="0">
	          <tr>
	            <td class="tituloListas" width="4%" align="center"><input type="checkbox" name="chkAll" onclick="javascript: checkAll(this.form);"/></td>
	            <td class="tituloListas" width="8%">Periodo</td>
	            <td class="tituloListas" width="6%">Mes</td>
	            <td class="tituloListas" width="13%">Orden Comercial</td>
	            <td class="tituloListas" width="11%"><p>Tipo</p>
	              <p> Documento</p></td>
	            <td class="tituloListas" width="10%">Moneda</td>
	            <td class="tituloListas" width="8%">Movimiento</td>
	            <td class="tituloListas" width="10%">Poliza Origen</td>
	            <td class="tituloListas" width="13%">Observaciones</td>
	            <td class="tituloListas" width="8%">Operacion</td>
	            <td class="tituloListas" width="9%">Importe</td>	</tr>
				<cfoutput query="rsLista" startrow="#StartRow_rsLista#" maxrows="#MaxRows_rsLista#">
	            <tr <cfif rsLista.CurrentRow Mod 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
                    
	              <td align="center" nowrap><input type="checkbox" name="ID" tabindex="-1" value="#ID#" />

                  
                  </td>
	              <td align="rigth" nowrap>#fltPeriodo#<input type="hidden" name="fltPeriodo" value="#rsLista.fltPeriodo#" /></td>
	              <td align="rigth" nowrap>#fltMes#<input type="hidden" name="fltMes" value="#rsLista.fltMes#" /></td>
   	              <td align="rigth" nowrap>#Contrato#<input type="hidden" name="Contrato" value="#rsLista.Contrato#" /></td>
   	              <td align="rigth" nowrap>#fltTipoDoc#<input type="hidden" name="fltTipoDoc" value="#rsLista.fltTipoDoc#" /></td>
   	              <td align="rigth" nowrap>#fltMoneda#<input type="hidden" name="fltMoneda" value="#rsLista.fltMoneda#" /></td>
   	              <td align="rigth" nowrap>#fltNaturaleza#<input type="hidden" name="fltNaturaleza" value="#rsLista.fltNaturaleza#" /></td>                  
   	              <td align="rigth" nowrap>#Poliza#<input type="hidden" name="Poliza" value="#rsLista.Poliza#" /></td>                  
   	              <td align="rigth" nowrap>#Observaciones#<input type="hidden" name="Observaciones" value="#rsLista.Observaciones#" /></td>                  
   	              <td align="rigth" nowrap>#fltOperacion#<input type="hidden" name="fltOperacion" value="#rsLista.fltOperacion#" /></td>                  
                  <td align="rigth" nowrap>#LSCurrencyFormat(Importe,'none')#<input type="hidden" name="Importe" value="#LSCurrencyFormat(Importe,'none')#" /></td>                </tr>
				</cfoutput> 
				<tr> 
				  <td colspan="9" align="center">&nbsp; 
					<table border="0" width="50%" align="center">
					  <cfoutput> 
						<tr> 
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista GT 1>
							  <a href="#CurrentPage#?PageNum_rsLista=1#QueryString_rsLista#"><img src="../../sif/imagenes/First.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="31%" align="center"> 
							<cfif PageNum_rsLista GT 1>
							  <a href="#CurrentPage#?PageNum_rsLista=#Max(DecrementValue(PageNum_rsLista),1)##QueryString_rsLista#"><img src="../../sif/imagenes/Previous.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista LT TotalPages_rsLista>
							  <a href="#CurrentPage#?PageNum_rsLista=#Min(IncrementValue(PageNum_rsLista),TotalPages_rsLista)##QueryString_rsLista#"><img src="../../sif/imagenes/Next.gif" border=0></a> 
							</cfif>
						  </td>
						  <td width="23%" align="center"> 
							<cfif PageNum_rsLista LT TotalPages_rsLista>
							  <a href="#CurrentPage#?PageNum_rsLista=#TotalPages_rsLista##QueryString_rsLista#"></a><a href="#CurrentPage#?PageNum_rsLista=#TotalPages_rsLista##QueryString_rsLista#"><img src="../../sif/imagenes/Last.gif" border=0 /></a>
							</cfif>
						  </td>
						</tr>
					  </cfoutput> 
					</table>
				  </td>
				</tr>
				
			  </table>
       
      </cfif>

    </td>
  </tr>
<tr align="center"> 

            <td>
	  			<input type="submit" name="Guardar" value="Procesar" onclick="javascript: document.form1.action='ImportaVtas-CostoOrden-sql.cfm'; return 						                 validaAplicacion(this.form);funcGuardar(this.form); "/>
                <input name="BorrarMovimiento"  type="submit" value="Borrar Movimiento"  onclick="javascript: document.form1.action='ImportaVtas-CostoOrden-sql.cfm';funcBorrar(this.form);">
                <input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='/cfmx/ModuloIntegracion/VtasOrdenComercial/ActualizaVtas-CostoOrden-form.cfm'">
         
</tr>
</fieldset>
</table>

	</form>
              	
    <!---TERMINA FORM--->
	


<cf_templatefooter>


<script language="javascript" type="text/javascript">

	function funcGuardar()
		{
			var mensaje = '';
			if (document.form1.fltPeriodo.value == '-1'){
				mensaje += '- Periodo\n';
			}
			if (document.form1.fltMes.value == '-1'){
				mensaje += '- Mes\n';
			}
			if (document.form1.fltMoneda.value == '-1'){
				mensaje += '- Moneda\n';
			}
			if (document.form1.fltTipoDoc.value == '-1'){
				mensaje += '- Tipo de Documento\n';
			}
			if (document.form1.fltNaturaleza.value == '-1'){
				mensaje += '- Movimiento\n';
			}
			if (document.form1.fltOperacion.value == '-1'){
				mensaje += '- Operacion\n';
			}
			if (document.form1.Importe.value == ''){
				mensaje += '- Importe\n';
			}
			if(document.form1.Contrato.value == ''){
				mensaje += '- Orden Comercial\n';
			}
			if(document.form1.Poliza.value == ''){
				mensaje += '- Poliza(s) Origen';
			}
			if (mensaje != ''){
				alert('Los siguientes campos son requeridos:\n\n' + mensaje)
				return false;
			}
			else
			{
			return true;
			}
		}
		
</script>
