<cfoutput>

<cfset loteFilter ="">
<cfset loteFilterMin ="">
<cfset loteFilterMax ="">
<cfset loteValueMin ="">
<cfset loteValueMax ="">
<cfset SNValues = "">
<cfset SNFilter = "">
<cfset printFilter= "and Estado = 'G'">

<cfif isDefined('form.modo') and form.modo eq "filtro">
    <cfset loteFilter ="#trim(form.lote)#">
    <cfset loteValueMin ="#trim(form.loteMin)#">
    <cfset loteValueMax ="#trim(form.loteMax)#">
    <cfset SNValues = "#form.CuentaID#,#form.SNid#,#form.SNnumero#,#form.SNnombre#">
    <cfif form.CuentaID neq "">
        <cfset SNFilter= "and c.id = #form.CuentaID#">
    </cfif>
    <cfif trim(form.loteMin) neq "">
        <cfset loteFilterMin= "and lote >= #trim(form.loteMin)#">
    </cfif>
    <cfif trim(form.loteMax) neq "">
        <cfset loteFilterMax= "and lote <= #trim(form.loteMax)#">
    </cfif>
    <cfif isDefined('form.CHK_print')>
        <cfset printFilter= "and Estado = 'I'">
    </cfif>
</cfif>

<cfset query_Folios = "
    select 
            Distinct(f.lote) lote
        ,   f.CRCCuentasid
        ,   c.Numero as SNnumero
        ,   n.SNnombre
    from CRCControlFolio f 
        inner join CRCCuentas c 
            on f.CRCCuentasid = c.id
        inner join SNegocios n 
            on c.SNegociosSNid = n.SNid
    where 
        f.lote like '%#loteFilter#%' 
        #SNFilter# 
        #loteFilterMin#
        #loteFilterMax#
        #printFilter#
        and f.Ecodigo = #session.Ecodigo#">

<cfif isDefined('form.modo') and form.modo neq "filtro">
    <cfif isdefined('form.q_folios')>
        <cfset query_Folios = "#form.q_Folios#">
    </cfif>
</cfif>

<cfquery name="q_Folios" datasource="#session.dsn#"> #PreserveSingleQuotes(query_Folios)# </cfquery>


<form name="form1" action="ImpresionFolios_sql.cfm" method="post">
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
    <input type="hidden" name="q_folios" value="#query_Folios#" >
    <input type="hidden" name="btnAplicar" value="">
    <input type="hidden" name="lotesImpresos" value="">
    <input type="hidden" name="filename" value="">
    <input type="hidden" name="filepath" value="">
    <tr>
        <td align="right"> <strong>Lote:&nbsp;</strong> </td>
        <td>
            <input type="text" name="lote" value="#loteFilter#">
        </td>
        <td>
            <strong>Numero Cuenta:&nbsp;</strong>
            <cf_conlis
                Campos="Cuentaid,SNid,SNnumero,SNnombre"
                values="#SNValues#"
                Desplegables="N,N,S,S"
                Modificables="N,N,S,N"
                Size="0,0,10,30"
                tabindex="2"
                Tabla="Snegocios s inner join CRCCuentas c
                        on c.SNegociosSNid = s.SNid
                        and c.Tipo = 'D'"
                Columnas="id as Cuentaid,SNid,SNnumero,replace(SNnombre,',',' ') as SNnombre"
                form="form1"
                Filtro=" s.Ecodigo = #Session.Ecodigo# and (disT = 1) and s.eliminado is null
                        order by SNnombre"
                Desplegar="SNnumero,SNnombre"
                Etiquetas="Numero, Nombre"
                filtrar_por="SNnumero,SNnombre"
                Formatos="S,S"
                Align="left,left"
                Asignar="Cuentaid,SNid,SNnumero,SNnombre"
                Asignarformatos="S,S,S"/>
        </td>
        <td align="left">
            <input name="btnFiltrar" value="Filtrar" class="btnFiltrar" type="submit">
            <input name="btnLimpiar" value="Limpiar" class="btnFiltrar" type="submit">
        </td>
    </tr>
    <tr>
        <td align="right"> <strong>Rango de Lotes:&nbsp;</strong> </td>
        <td>
            <input type="text" name="loteMin" value="#loteValueMin#"> - 
            <input type="text" name="loteMax" value="#loteValueMax#">
        </td>
        <td align="left">
            <strong>Folios Impresos:&nbsp;</strong>
            <input type="checkbox" name="CHK_print" <cfif isDefined('form.CHK_print')>checked</cfif>>
        </td>
    </tr>
    <tr>
        <cfset buttons = "Imprimir">
        <cfif isDefined('form.CHK_print')><cfset buttons = "Aplicar, Reimprimir"></cfif>
        <td colspan="4">
            <cfinvoke component="commons.Componentes.pListas" method="pListaQuery"
                query="#q_Folios#"
                desplegar   = "lote,SNnumero,SNnombre"
                etiquetas   = "Lote,Num. Cuenta, Socio de Negocio"
                formatos    = "S,S,S"
                align       = "left,left,left"
                checkboxes  = "S"
                checkall    = "S"
                formName    = "form1"
                checkbox_function ="funcChk(this)"
                botones     = "#buttons#"
                ira         = "ImpresionFolios_sql.cfm"
                keys        = "lote">
            </cfinvoke>
        </td>
    </tr>
</form>

<cfset style1 = "
    background-color: rgba(0, 0, 0, 0.5);
    position:fixed; left:0px; right:0px; bottom:0px; 
    height:100%; width:100%;
    z-index:1; display:none;"
    >
<cfset style2 ="
    border: 3px solid ##606060; background-color: white;
    text-align: center; 
    height:20%; width:80%;  
    margin-top:20%; margin-left:10%;
    ">

<div id="div_procesando" style="#style1# ">
    <div  valign="center" id="div_in" style="#style2#">
        <p><font size="20" style="line-height: 250%;"><strong>PROCESANDO...</strong></font></p>
    </div>
</div>

<iframe name="download_iframe" id="download_iframe" 
    src="/cfmx/crc/credito/operacion/ImpresionFolios.cfm" 
    style="border:0; border:none;" 
    <!--- width="800px" height="600px" --->
    width="0px" height="0px"
    >
</iframe>

<cfif isdefined('form.modo') && form.modo eq "print">
    <a id="desc" href="../../../Enviar/foliosPDF/#form.fileName#.pdf" download>
    <script>
        parent.document.getElementById('div_procesando').style.display="none";
        document.getElementById('desc').click();
        /*setTimeout(function(){
            if(confirm("Los folios se imprimieron correctamente?")){
                parent.document.form1.target = "##";
                parent.document.form1.btnAplicar.value="aplicar";
                parent.document.form1.submit();
            }
        }, 2000);*/
    </script>
</cfif>

<script>
    <cfif isDefined('form.CHK_print')>
        var btn = document.form1.btnAplicar
        btn[btn.length - 1].value='Activar'
    </cfif>

    <!--- old function
    function funcImprimir(){
        var checked = false;
        var chks = document.getElementsByName('chk');
        for(var i in chks){ if(chks[i].checked){checked = true;} }
        if(document.getElementsByName('chkAllItems')[0].checked){checked = true;} 
        if(!checked){
            alert("No ha seleccionado lotes para imprimir");
            return false;
        }
        document.getElementById('div_procesando').style.display="inline";
        //document.form1.target = "download_iframe";
        return confirm("Seguro desea imprimir estos folios?");
    }
    --->

    function funcChk(e){
        if(document.getElementsByName('chkAllItems')[0].checked && !e.checked){
            document.getElementsByName('chkAllItems')[0].checked = false;
        }
    }

    function ValidarSeleccion(){
        var checked = false;
        var chks = document.getElementsByName('chk');
        for (var i = 0; i < chks.length; i++){
			if(chks[i].checked){checked = true;}
		}
        if(!checked){
            alert("No ha seleccionado lotes para imprimir");
            return false;
        }
        return true;
    }

    function funcImprimir(){
        document.getElementById('div_procesando').style.display="inline";
        if(ValidarSeleccion()){
            if(confirm("Seguro desea imprimir estos folios?")){
                return true;
            } else { 
                document.getElementById('div_procesando').style.display="none";
                return false;
            }
        }else{
            document.getElementById('div_procesando').style.display="none";
            return false;
        }
    }

    function funcAplicar(){
        document.getElementById('div_procesando').style.display="inline";
        if(ValidarSeleccion()){
            if(confirm("Seguro desea activar estos folios?")){
                return true;
            } else { 
                document.getElementById('div_procesando').style.display="none";
                return false;
            }
        }else{
            document.getElementById('div_procesando').style.display="none";
            return false;
        }
    }

    function funcReimprimir(){
        document.getElementById('div_procesando').style.display="inline";
        if(ValidarSeleccion()){
            if(confirm("Seguro desea reimprimir estos folios?")){
                return true;
            } else { 
                document.getElementById('div_procesando').style.display="none";
                return false;
            }
        }else{
            document.getElementById('div_procesando').style.display="none";
            return false;
        }
    }


</script>



</cfoutput>