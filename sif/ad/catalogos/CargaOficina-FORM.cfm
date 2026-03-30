<cfparam name="ruta" default="">

<cfset modo = "ALTA">
<cfif isdefined("form.DClinea") and len(trim(form.DClinea))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined("url.modo") and len(trim(url.modo))>
	<cfset modo = url.modo>
</cfif>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_Carga" default="Carga" returnvariable="vCarga" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Desde" default="Desde" xmlfile="/rh/generales.xml"	 returnvariable="vDesde" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_Hasta" default="Hasta" xmlfile="/rh/generales.xml"	 returnvariable="vHasta" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor_Empleado" default="Valor Empleado" returnvariable="vValorEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Valor_Patrono" default="Valor Patr&oacute;n" returnvariable="vValorPatrono" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" xmlfile="/rh/generales.xml"	returnvariable="vDescripcion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Carga_Obrero_Patronal" default="Carga Obrero Patronal" xmlfile="/rh/generales.xml"	returnvariable="vCargaOP" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Inicial" default="Fecha Inicial" xmlfile="/rh/generales.xml" returnvariable="vFechaInicial" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_Fecha_Final" default="Fecha Final" xmlfile="/rh/generales.xml" returnvariable="vFechaFinal" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_NUEVO"  default="Nuevo" returnvariable="BTN_NUEVO" component="sif.Componentes.Translate" method="Translate"/>									

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CargasOficina"
	Default="Cargas Obrero Patronales por Oficina"
	returnvariable="LB_CargasOficina"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif modo eq "CAMBIO" >
    <cfquery name="rsCargasOficina" datasource="#session.DSN#">
        select 	a.DClinea,
                b.DCdescripcion, 
                CEdesde, 
                CEhasta, 
                b.DCmetodo, 
                c.ECauto, 
                a.CEvalorpat, 
                a.CEvaloremp,
                b.DCvalorpat,
                b.DCvaloremp
        from CargasOficina a
        inner join  DCargas b
        on a.DClinea=b.DClinea
        inner join ECargas c
        on b.ECid=c.ECid 
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">	
          and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">
          and a.DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DClinea#">
    </cfquery>
    <cfquery name="rsOficina" datasource="#session.DSN#">
        select Oficodigo, Odescripcion from Oficinas a
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">	
          and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">
    </cfquery>
</cfif>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td>
            <form name="form1" method="post"  onSubmit="return validar();" action="SQLcargaOficina.cfm">
                <cfoutput>
                <input type="hidden" name="Ocodigo" value="#Form.Ocodigo#">
                <input type="hidden" name="Odescripcion" value="#Form.Odescripcion#">
                <input type="hidden" name="Oficodigo" value="#Form.Oficodigo#">
                    <table width="100%">										  
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                            <td align="left"><strong>#LB_Oficina#:</strong></td>
                            <td align="left"><strong>#form.Oficodigo#  #form.Odescripcion#</strong></td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                            <td class="fileLabel"><strong>#vCarga#</strong></td>
                            <td nowrap>
                                <cfif isdefined("rsForm") and rsform.ECauto EQ 1>
                                    <cfset vReadonly = 'yes'>
                                <cfelse>
                                    <cfset vReadonly = 'no'>
                                </cfif>
                                <cfif modo eq "ALTA" >
                                    <cf_conlis 
                                        campos="DCdescripcion,DClinea,ECauto,DCmetodo"
                                        asignar="DCdescripcion,DClinea,ECauto,DCmetodo"
                                        size="50,0,0,0"
                                        desplegables="S,N,N,N"
                                        modificables="N,N,N,N"						
                                        title="Lista de Cargas Obrero Patronales"
                                        tabla="DCargas a,ECargas b"
                                        columnas="a.ECid,ECdescripcion,DClinea,DCdescripcion,ECauto,DCmetodo,a.DCvaloremp,a.DCvalorpat"
                                        filtro="a.ECid=b.ECid
                                                and b.Ecodigo= #Session.Ecodigo# 
                                                and DClinea not in ( select distinct DClinea from CargasOficina where Ocodigo = #form.Ocodigo#)
                                                order by a.ECid, DCdescripcion"
                                        filtrar_por="DCdescripcion"
                                        desplegar="DCdescripcion"
                                        etiquetas="#vDescripcion#"
                                        formatos="S"
                                        align="left"								
                                        asignarFormatos="S,S,S,S"
                                        form="form1"
                                        showEmptyListMsg="true"
                                        Cortes="ECdescripcion"
                                        funcion="funcPreCarga"
                                        fparams="DCvaloremp,DCvalorpat"
                                        readonly="#vReadonly#"
                                    />
                                <cfelse>
                                	<input name="fDCcodigo" type="text" value="#rsCargasOficina.DCdescripcion#" maxlength="40" readonly="readonly">
                					<input type="hidden" name="DClinea" value="#rsCargasOficina.DClinea#">
                                </cfif>
                            </td>                        
                        </tr>
                        <tr>
                            <td class="fileLabel"><strong>#vFechaInicial#</strong></td>
                            <td>
                                <cfif modo neq 'ALTA' >
                                    <cfset fechaini = LSDateFormat(rsCargasOficina.CEdesde,"dd/mm/yyyy") >
                                <cfelse>
                                    <cfset fechaini = "" >
                                </cfif>
                                <cf_sifcalendario form="form1" name="CEdesde" value=#fechaini#>
                            </td>	
                        </tr>
                        <tr>
                            <td class="fileLabel"><strong>#vFechaFinal#</strong></td>
                            <td>
                                <cfif modo neq 'ALTA' >
                                    <cfset fechafin = LSDateFormat(rsCargasOficina.CEhasta,"dd/mm/yyyy") >
                                <cfelse>
                                    <cfset fechafin = "" >
                                </cfif>
                                <cf_sifcalendario form="form1" name="CEhasta" value=#fechafin#>
                            </td>	
                        </tr>
                        <tr>
                            <td class="fileLabel"><strong>#vValorPatrono#</strong></td>
                            <td>
                                <input name="CEvalorpat" type="text" style="text-align:right" 
                                    onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                                    onfocus="javascript:this.select();" 
                                    onchange="javascript: fm(this,2);" 
                                    value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsCargasOficina.CEvalorpat,'none')#<cfelse>0.00</cfif>" 
                                    size="18"  maxlength="18" >
                            </td>
                        </tr>
                        <tr>
                            <td class="fileLabel"><strong>#vValorEmpleado#</strong></td>
                            <td>
                                <input name="CEvaloremp" type="text" style="text-align:right" 
                                    onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" 
                                    onfocus="javascript:this.select();" 
                                    onchange="javascript: fm(this,2);" 
                                    value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsCargasOficina.CEvaloremp,'none')#<cfelse>0.00</cfif>" 
                                    size="18"  maxlength="18" >
                            </td>
                        </tr>
                        <tr><td>&nbsp;</td></tr>
                        <tr>
                            <td colspan="2" align="center">
                                <input name="Nuevo" type="submit" value="#BTN_NUEVO#" >
                                <cfif modo eq 'ALTA'>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        Key="BTN_Agregar"
                                        Default="Agregar"
                                        XmlFile="/rh/generales.xml"
                                        returnvariable="BTN_Agregar"/>
                                    <input type="submit" name="alta" value="<cfoutput>#BTN_Agregar#</cfoutput>">												
                                <cfelse>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        Key="BTN_Modificar"
                                        Default="Modificar"
                                        XmlFile="/rh/generales.xml"
                                        returnvariable="BTN_Modificar"/>
                                    <cfinvoke component="sif.Componentes.Translate"
                                        method="Translate"
                                        Key="BTN_Eliminar"
                                        Default="Borrar"
                                        XmlFile="/rh/generales.xml"
                                        returnvariable="BTN_Eliminar"/>
                                    <input type="submit" name="Cambio" value="#BTN_Modificar#">
                                    <input type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
                                </cfif>
								<input type="button" name="btnRegresar"  value="Regresar"  onClick="javascript:funcRegresar();"  >
                            </td>
                        </tr>	  
                    </table>
                </cfoutput>
            </form>
        </td>
    </tr>
</table>
<script src="/cfmx/sif/js/qForms/qforms.js"></script> 
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.CEdesde.required = true;
	<cfoutput>										
	objForm.CEdesde.description = "#vFechaInicial#";
	</cfoutput>
	objForm.CEdesde.validateFecha();
	
	function funcRegresar(){                             									
		<cfoutput>										
			location.href= 'Oficinas.cfm';
		</cfoutput>
	}
	function funcPreCarga(pn_valempleado,pn_valpatrono){
		if (pn_valempleado!= '' && pn_valpatrono != ''){
			document.form1.CEvalorpat.value = pn_valpatrono;
			document.form1.CEvaloremp.value = pn_valempleado;
			document.form1.CEvalorpat.value = fm(document.form1.CEvalorpat.value,2);
			document.form1.CEvaloremp.value = fm(document.form1.CEvaloremp.value,2);
		}
		else{
			document.form1.CEvalorpat.value = 0.00;
			document.form1.CEvaloremp.value = 0.00;
		}
	}
	function validar(){	
		document.form1.CEvalorpat.value = qf(document.form1.CEvalorpat.value);
		document.form1.CEvaloremp.value = qf(document.form1.CEvaloremp.value);
		return true; 
	}            
</script>



