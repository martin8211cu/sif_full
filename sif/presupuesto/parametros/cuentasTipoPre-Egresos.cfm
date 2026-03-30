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

<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<cf_templatecss>

<script language="javascript" type="text/javascript">
	function ValidaEgresos(form){
		if (window.FrameFunction) FrameFunction();
		if 	(document.form2.CPmascaraExcepciones.value == "")
		{
			alert("Es necesario digitar una Máscara válida");
			return false;
		}
	}
</script>

<form action="cuentasTipoPresupuestoSQL.cfm" method="post" name="form2" onSubmit="javascript: return ValidaEgresos(this);">
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
		<tr><td>&nbsp;</td></tr>
    
    	<tr>
	      	<td colspan="5" align="center" class="tituloListas">Representa la Utilización, Aplicación o Consumo de los Recursos Financieros:</td>
    	</tr>
        
        <tr>
        	<td>&nbsp;</td>
       		<td align="right"> 
				<strong>Todas las cuentas de Gastos</strong>:&nbsp;
			</td>
            <td>&nbsp;</td>	
            <td> 
				(excepto las especiales de Ingresos Presupuestales)
			</td>
            <td>&nbsp;</td>	
		</tr>
        
        <tr>
        	<td>&nbsp;</td>
       		<td align="right"> 
				<strong>Todas las cuentas de Activos</strong>:&nbsp;
			</td>
            <td>&nbsp;</td>	
            <td> 
				(excepto las especiales de Ingresos Presupuestales)
			</td>
            <td>&nbsp;</td>	
		</tr>
                    
       	<tr><td>&nbsp;</td></tr>
    
    	<tr>
	      	<td colspan="5" align="center" class="tituloListas">Cuentas especiales de Pasivo, Capital e Ingresos para Egresos Presupuestales:</td>
    	</tr>
        
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
                        	<input type="hidden" name="TAB" value="2">
                            <input type="hidden" name="CPPid" id="CPPid" value="<cfoutput>#form.CPPid#</cfoutput>">	
            			<td align="center">
                			<input  tabindex="2" type="text" name="Descripcion" id="Descripcion" size="50" alt="Descripcion" >
            			</td>
        				<td>&nbsp;</td>
        	        	<td align="rigth">			
							<cf_cajascuenta index="2" form="form2" tabindex="2" objeto="CPmascaraExcepciones" presupuesto="true" CMtipos="P,C,I">
						</td>
        	     		<td>&nbsp;</td>
        			</tr>
				</table>
			</td>	        
       	</tr>
       
       	<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="5" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">
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
    where a.CPTCtipo  = <cfqueryparam cfsqltype="cf_sql_char" value="E">
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
                    <td width="1%" bgcolor="F7F9FA">&nbsp;</td> 
                    <td width="2%" align="center">#rsLineas.CurrentRow#</td>
                    <td width="22%">#rsLineas.CPTCdescripcion#&nbsp;</td>
                    <td width="17%">#replace(rsLineas.CPTCmascara,"_","?","ALL")#</td>
                    <td width="1%">
                        <a href="javascript:borrar2('#rsLineas.CPTCid#', '#rsLineas.CPTCtipo#');">
                            <img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif" alt="Eliminar Detalle">
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
        <input type="hidden" name="BorrarD" value="">
        <!--- --------------------------- --->
	</table>
</form>

<script language="JavaScript1.2">
	qFormAPI.errorColor = "#FFFFCC";
	objForm2 = new qForm("form2");
		
	//Validaciones de los campos requeridos	
	objForm2.CPPid.required = true;
	objForm2.CPPid.description="Periodo del Presupuesto";
	
	objForm2.Descripcion.required = true;
	objForm2.Descripcion.description="Descripción";
			
	objForm2.txt_Cmayor2.required = true;
	objForm2.txt_Cmayor2.description="Mascara";
				
	function deshabilitarValidacion(){
		objForm2.CPPid.required = false;
		objForm2.Descripcion.required = false;
		objForm2.txt_Cmayor2.required = false;
	}
		
	function borrar2(cuenta, tipo){
		if ( confirm('¿Desea borrar esta cuenta de la lista?') ) {
		document.form2.action = "cuentasTipoPresupuestoSQL.cfm";	
		document.form2.BorrarD.value = "BORRAR";
		document.form2.CPTCid.value = cuenta;
		document.form2.CPTCtipo.value = tipo;
		document.form2.submit();
		}
	}
</script>