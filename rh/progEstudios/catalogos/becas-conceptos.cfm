<cfset filtro = "tbc.RHTBid = #form.RHTBid#">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_dbfunction name="to_char" args="tbc.RHTBid"		returnvariable="to_RHTBid">
<cf_dbfunction name="to_char" args="tbc.RHECBid"	returnvariable="to_RHECBid">
<cfset eliminar = '<a href="javascript:fnEliminarConcepto(''#_CAT##to_RHTBid##_CAT#'',''#_CAT##to_RHECBid##_CAT#'')"><img src="/cfmx/rh/imagenes/delete.small.png" border="0"></a>'>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Concepto" Default="Concepto" XmlFile="/rh/generales.xml" returnvariable="LB_Concepto"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ListaDeConceptos" Default="Lista De Conceptos" XmlFile="/rh/generales.xml" returnvariable="LB_ListaDeConceptos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto" Default="¿Está seguro de que desea eliminar este concepto?" returnvariable="MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto"/>
<cfinvoke component="rh.Componentes.RH_ProgEstudio" method="fnGetBeca" returnvariable="rsBeca">
        <cfinvokeargument name="RHTBid" 		value="#form.RHTBid#">
</cfinvoke>
<cfoutput>
<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td align="center" nowrap><strong style="font-size:18px">#rsBeca.RHTBcodigo#-#rsBeca.RHTBdescripcion#</strong></td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <form name="form1" method="post" action="becas-sql.cfm">
    <input type="hidden" name="RHTBid" value="#form.RHTBid#">
    <tr>
        <td align="center">
            <table border="0" cellspacing="0" cellpadding="0" align="center">
                <tr>
                    <td><strong>#LB_Concepto#:&nbsp;</strong></td>
                    <td nowrap>
                        <cf_conlis
                            campos="RHECBid,RHECBcodigo,RHECBdescripcion"
                            desplegables="N,S,S"
                            modificables="N,S,N"
                            size="0,10,50"
                            title="#LB_ListaDeConceptos#"
                            tabla="RHEConceptosBeca a"
                            columnas="RHECBid, RHECBcodigo, RHECBdescripcion"
                            filtro="a.CEcodigo = #session.CEcodigo# and not exists(select 1 from RHTipoBecaConceptos tbc where tbc.RHTBid = #form.RHTBid# and tbc.RHECBid = a.RHECBid)"
                            desplegar="RHECBcodigo, RHECBdescripcion"
                            filtrar_por="RHECBcodigo|RHECBdescripcion"
                            filtrar_por_delimiters="|"
                            etiquetas="#LB_Codigo#,#LB_Descripcion#"
                            formatos="S,S"
                            align="left,left"
                            asignar="RHECBid,RHECBcodigo,RHECBdescripcion"
                            asignarformatos="I,S,S"
                            showEmptyListMsg="true"
                            form = "form1"
                        >
                    </td>
                    <td>&nbsp;<input type="submit" name="AltaBC" id="AltaBC" class="btnNormal" value="+" onclick="return fnValidarBC()"></td>
                    <td>&nbsp;<input type="submit" name="RegresarBC" id="RegresarBC" class="btnAnterior" value="Regresar"></td>
                </tr>
            </table>
        </td>
    </tr>
    </form>
    <tr>
        <td align="center" nowrap>
            <cfinvoke component="rh.Componentes.pListas" method="pListaRH">
                <cfinvokeargument name="tabla" value="RHTipoBecaConceptos tbc inner join RHEConceptosBeca cb on cb.RHECBid = tbc.RHECBid"/>
                <cfinvokeargument name="columnas" value="tbc.RHTBid, tbc.RHECBid, cb.RHECBcodigo, cb.RHECBdescripcion, '#preservesinglequotes(eliminar)#' as eliminar"/>
                <cfinvokeargument name="desplegar" value="RHECBcodigo, RHECBdescripcion,eliminar"/>
                <cfinvokeargument name="etiquetas" value="#LB_Codigo#,#LB_Descripcion#,&nbsp;"/>
                <cfinvokeargument name="filtro" value="#filtro#"/>
                <cfinvokeargument name="formatos" value="V, V, V"/>
                <cfinvokeargument name="align" value="left, left, center"/>
                <cfinvokeargument name="ajustar" value="S"/>
                <cfinvokeargument name="checkboxes" value="N"/>				
                <cfinvokeargument name="irA" value="becas-sql.cfm"/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                <cfinvokeargument name="showLink" value="false"/>
                <cfinvokeargument name="keys" value="RHTBid, RHECBid"/>
            </cfinvoke>
        </td>
    </tr>
     <form name="formD" method="post" action="becas-sql.cfm">
     	<input type="hidden" name="RHTBid"  value="">
        <input type="hidden" name="RHECBid" value="">
        <input type="hidden" name="BajaBC"  value="BajaBC">
    </form>
</table>
<script language="javascript1.2" type="text/javascript">
	
	function trim(cad){  
    	return cad.replace(/^\s+|\s+$/g,"");  
	}
	
	function fnValidarBC(){
		
		Lid = trim(document.getElementById('RHECBid').value).length;
		errores = "";
		if(Lid == 0)
			errores = errores + " -El concepto es requerido.\n";
		if(errores.length > 0){
			alert("Se presentaron los siguientes errores:\n" + errores);
			return false;
		}
		return true;
	}
	
	function fnEliminarConcepto(RHTBid, RHECBid) {
		if (confirm('#MSG_EstaSeguroDeQueDeseaEliminarEsteConcepto#')) {
			document.formD.RHTBid.value = RHTBid;
			document.formD.RHECBid.value = RHECBid;
			document.formD.submit();
		}
	}
</script>
</cfoutput>