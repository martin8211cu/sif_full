<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif> <!--- modo cambio --->

	<input type="hidden" name="CPPid" id="CPPid" value="<cfoutput>#form.CPPid#</cfoutput>">
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
        <tr>
        	<td colspan="5">
            	<table border="0">
        	   		<tr>
            	  		<td>&nbsp;</td>
                		<td>
                    		<strong>Descripcion</strong>:&nbsp;
                		</td>
                		<td>&nbsp;</td>
                		<td>
                 	   		<strong>Mascara</strong>:&nbsp;
                		</td>
                		<td>&nbsp;</td>
					</tr>
        
        			<tr>
        				<td>&nbsp;</td>
        				<td align="center">
                			<input  tabindex="2" type="text" name="Descripcion" id="Descripcion" size="50" alt="Descripcion">
            			</td>
        				<td>&nbsp;</td>
        	        	<td align="rigth" colspan="2">				
							<cf_cajascuenta index="4" form="form1" tabindex="2" objeto="CPmascaraExcepcion" presupuesto="true">
						</td>
             			<td>&nbsp;</td>
        			</tr>
				</table>
			</td>	        
       	</tr>
       
       	<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5" align="center">
					<input tabindex="-1" type="submit" name="Alta"    class="btnGuardar" value="Agregar" onClick="javascript: return ValidaExcepciones(this.form);">
				</td>	    
		   	</tr>
	</table>
    <cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLineas" datasource="#Session.DSN#">
	select 
		a.CPTCid,
		a.CPTCdescripcion, 
		a.CPTCmascara,
        a.CPTCtipo,
        a.Cmayor,
        a.Ecodigo, 
        b.CPPid, 
		b.CPPtipoPeriodo, 
		b.CPPfechaDesde, 
		b.CPPfechaHasta,
        'Presupuesto ' #_Cat#
			case b.CPPtipoPeriodo when 1 then 'Mensual' when 2 then 'Bimestral' when 3 then 'Trimestral' when 4 then 'Cuatrimestral' when 6 then 'Semestral' when 12 then 'Anual' else '' end
				#_Cat# ' de ' #_Cat# 
			case {fn month(b.CPPfechaDesde)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(b.CPPfechaDesde)}">
				#_Cat# ' a ' #_Cat# 
			case {fn month(b.CPPfechaHasta)} when 1 then 'Enero' when 2 then 'Febrero' when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Setiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre' else '' end
				#_Cat# ' ' #_Cat# <cf_dbfunction name="to_char" args="{fn year(b.CPPfechaHasta)}">
		as Periodo	
	from CPtipoCtas a		
		inner join CPresupuestoPeriodo b
    		on b.CPPid = a.CPPid     	
    where a.CPTCtipo = 'X'
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    and a.CPPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
    
	</cfquery>
	                     
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>&nbsp;</tr>
    	<tr class="subTitulo">
			<td width="1%">&nbsp;</td> 
            <td width="2%"  bgcolor="E2E2E2"><strong>&nbsp;L&iacute;nea&nbsp;</strong></td> 
			<td width="22%" bgcolor="E2E2E2" ><strong>Descripci&oacute;n&nbsp;</strong></td>
			<td width="17%" bgcolor="E2E2E2" ><strong>Cuenta&nbsp;</strong></td>
            <td width="1%"  bgcolor="E2E2E2" >&nbsp;</td>
            <td width="1%">&nbsp;</td>
		</tr>
		<cfif rsLineas.RecordCount gt 0>							
			<cfoutput query="rsLineas"> 
                <tr style="cursor: pointer;"
                    onMouseOver="javascript: style.color = 'red'" 
                    onMouseOut="javascript: style.color = 'black'"
                    <cfif rsLineas.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
                    <td  width="1%" bgcolor="F7F9FA">&nbsp;</td> 
                    <td width="2%" align="center">#rsLineas.CurrentRow#</td>
                    <td width="22%">#rsLineas.CPTCdescripcion#&nbsp;</td>
                    <td width="17%" >#replace(rsLineas.CPTCmascara,"_","?","ALL")#</td>
                    <td width="1%">
                        <a href="javascript:borrar3('#rsLineas.CPTCid#', '#rsLineas.CPTCtipo#');">
                            <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Cuenta">
                        </a>
                    </td>
                    <td width="1%" bgcolor="F7F9FA">&nbsp;</td>
                </tr>
            </cfoutput>
        <cfelse>
			<tr>
            	<td width="1%">&nbsp;</td> 
                <td align="center" colspan="4">--- No se encontraron datos ----</td>
                <td width="1%">&nbsp;</td> 
            </tr>
		</cfif>
    	<!--- Para Borrado desde la lista --->
        <input type="hidden" name="CPTCid" value="">
        <input type="hidden" name="CPTCtipo" value="">
        <input type="hidden" name="BorrarD" value="BorrarD">
        <!--- --------------------------- --->
	</table>
 
<script language="JavaScript1.2">
	function isDefined( object) {
		 return (typeof(eval(object)) == "undefined")? false: true;
	}

	function ValidaExcepciones(){
		if( isDefined(window.cuentasIframe4) )
			window.cuentasIframe4.RetornaCuenta2();

		if 	(document.form1.CPmascaraExcepcion.value == "")
		{
			alert("Es necesario digitar una Máscara válida");
			return false;
		}
		if 	(document.form1.Descripcion.value == "")
		{
			alert("Es necesario digitar una Descripcion");
			return false;
		}
	}
		
	function borrar3(cuenta, tipo){
		if ( confirm('¿Desea borrar esta cuenta de la lista?') ) {
		document.form1.action = "ParametrizaContaPres-sql.cfm";	
		document.form1.CPTCid.value = cuenta;
		document.form1.CPTCtipo.value = tipo;
		document.form1.submit();
		}
	}
</script>