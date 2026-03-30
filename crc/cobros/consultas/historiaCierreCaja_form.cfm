<cfset CierreCaja = createObject('component', 'crc.Componentes.cierre_caja.CRCCierreCaja')>
<cfset CierreHTML = CierreCaja.DrawCierreCaja(CajaID=url.CajaID,CierreID=url.CierreID)>

<table>
    <tr align="center">
        <td widht = "80%">
            <cfoutput>
                <div id="printArea"> #CierreHTML# </div> 
            </cfoutput>
        </td>
        <td>
            <form name="botonesForm">
                <cf_botones values="Imprimir"></br>
                <cf_botones values="Regresar">
            </form>
        </td>
    </tr>
</table>

<script>
    function funcRegresar(){
        parent.document.getElementById('div_procesando').style.display="none";
        return false;
    }
    function funcImprimir(){
        var printContents = document.getElementById('printArea').innerHTML;
        var originalContents = document.body.innerHTML;
        console.log(printContents);
        console.log(originalContents);
        document.body.innerHTML = printContents;

        window.print();

        document.body.innerHTML = originalContents;

        return false;
    }
</script>
        
