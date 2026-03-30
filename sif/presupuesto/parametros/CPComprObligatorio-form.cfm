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

<script language="javascript1.2" type="text/javascript">
	function isDefined( object) 
	{
		 return (typeof(eval(object)) == "undefined")? false: true;
	}

	//Dispara la funcion del iframe que retorna los datos de la cuenta
	function FrameFunction(){
		// RetornaCuenta2() es máscara completa, rellena con comodín
		if( isDefined(window.cuentasIframe1) )
			window.cuentasIframe1.RetornaCuenta2();
		if( isDefined(window.cuentasIframe2) )
			window.cuentasIframe2.RetornaCuenta2();
		if( isDefined(window.cuentasIframe3) )
			window.cuentasIframe3.RetornaCuenta2();
		if( isDefined(window.cuentasIframe4) )
			window.cuentasIframe4.RetornaCuenta2();
		if( isDefined(window.cuentasIframe5) )
			window.cuentasIframe5.RetornaCuenta2();
		if( isDefined(window.cuentasIframe6) )
			window.cuentasIframe6.RetornaCuenta2();
		if( isDefined(window.cuentasIframe7) )
			window.cuentasIframe7.RetornaCuenta2();
		if( isDefined(window.cuentasIframe8) )
			window.cuentasIframe8.RetornaCuenta2();
		if( isDefined(window.cuentasIframe9) )
			window.cuentasIframe9.RetornaCuenta2();
	}
</script>

<cf_templatecss>

<script language="javascript" type="text/javascript">
	function ValidaIngreso(form){
		if (window.FrameFunction) FrameFunction();
		if 	(document.form1.CPmascaraIngreso.value == "")
		{
			alert("Es necesario digitar una Máscara válida");
			return false;
		}
	}
</script>

<form action="CPComprObligatorio-SQL.cfm" method="post" name="form1" onSubmit="return ValidaIngreso(this);">
<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLineas" datasource="#Session.DSN#">
	select 
    	a.CPCCid,
		a.CPCCdescripcion, 
		a.CPCCmascara,
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
	from CPresupuestoObligatorias a		
		inner join CPresupuestoPeriodo b
    		on b.CPPid = a.CPPid     	
    where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and a.CPPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPPid#">
		<cfif isdefined("Form.Descripcion") and Form.Descripcion NEQ "">
			and  a.CPCCdescripcion like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Form.Descripcion#%" />
		</cfif>
		<cfif isdefined("Form.TXT_CMAYOR1") and Form.TXT_CMAYOR1 NEQ "">
			and  a.Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TXT_CMAYOR1#" />
		</cfif>
	</cfquery>

<table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" >
       
        <tr><td>&nbsp;</td></tr>

    	<tr>
	      	<td colspan="5" align="center" class="tituloListas">Configuraci&oacute;n de Cuentas de Presupuesto con Compromiso Obligatorio</td>
    	</tr>
        
		<tr>
        	<td colspan="5">
            	<table border="0">
        			<tr>
            	  		<td>&nbsp;</td>
                        <td>
                    		<strong>Descripci&oacute;n</strong>:&nbsp;
                		</td>
                		<td>&nbsp;</td>
                        <td>
                 	   		<strong>Mascara</strong>:&nbsp;
                		</td>
                		<td>&nbsp;</td>
					</tr>
        
        			<tr>
        				<td >&nbsp;</td>
                        	<input type="hidden" name="CPPid" id="CPPid" value="<cfoutput>#form.CPPid#</cfoutput>">	
                        <td align="center">
                			<input  tabindex="2" type="text" name="Descripcion" id="Descripcion" size="50" alt="Descripcion" >
            			</td>
        				<td>&nbsp;</td>
        	        	<td align="rigth">			
							<cf_cajascuenta index="1" form="form1" tabindex="2" objeto="CPCCmascara" presupuesto="true">
						</td>
             			<td>
							<cfoutput>
									<input type="submit" name="btnFiltrar" value="Filtrar" onclick="javascript:return deshabilitarValidacion();"/>
									<input type="submit" name="btnRegresar" value="Regresar" onclick="javascript:return deshabilitarValidacion();"/>
								</cfoutput>
						</td>
        			</tr>
				</table>
			</td>	        
       	</tr>
       
        
	   	<tr>
			<td colspan="5" align="center">
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>	
		</tr>
	</table>
    
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr>&nbsp;</tr>
    	<tr class="subTitulo">
			<td width="1%">&nbsp;</td> 
            <td width="2%"  bgcolor="E2E2E2" ><strong>&nbsp;L&iacute;nea&nbsp;</strong></td> 
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
                    <td width="22%">#rsLineas.CPCCdescripcion#&nbsp;</td>
                    <td width="17%">#replace(rsLineas.CPCCmascara,"_","?","ALL")#</td>
                   	<td width="1%">
                        <a href="javascript:borrar('#rsLineas.CPCCid#');">
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
        <input type="hidden" name="CPCCid" value="">
		<input type="hidden" name="BorrarD" value="">
        <!--- --------------------------- --->
	</table>
</form>

<script language="JavaScript1.2">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	//Validaciones de los campos requeridos	
	objForm.CPPid.required = true;
	objForm.CPPid.description="Periodo del Presupuesto";
	
	objForm.Descripcion.required = true;
	objForm.Descripcion.description="Descripción";
			
	objForm.txt_Cmayor1.required = true;
	objForm.txt_Cmayor1.description="Mascara";
	
	function deshabilitarValidacion(){
		objForm.CPPid.required = false;
		objForm.Descripcion.required = false;
		objForm.txt_Cmayor1.required = false;
	}
		
	function borrar(cuenta){
		if ( confirm('¿Desea borrar esta cuenta de la lista?') ) {
		document.form1.action = "CPComprObligatorio-SQL.cfm";	
		document.form1.BorrarD.value = "Baja";
		document.form1.CPCCid.value = cuenta;
		document.form1.submit();
		}
	}
</script>

