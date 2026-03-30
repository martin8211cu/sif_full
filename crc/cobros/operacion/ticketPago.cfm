<!---
<script type="text/javascript">
    window.open('/crc/cobros/operacion/Ingresos.cfm','_blank');
</script>
--->
<cfif url.ET eq 'X'>
    <cfset url.ET = form.ETNumero>
</cfif>

<cfquery name="q_datosPago" datasource="#session.dsn#">
    select 
          et.ETnumero
        , et.ETtotal
        , et.ETfecha
        , dt.CRCCuentaid
        , sn.SNcodigo
        , sn.SNnombre
        , c.Numero
        , c.tipo
        , et.Usucodigo
        , et.ETserie
        , et.ETdocumento
    from ETransacciones et
    inner join DTransacciones dt
        on et.ETnumero = dt.ETnumero
    inner join SNegocios sn
        on et.SNcodigo = sn.SNcodigo
    inner join CRCCuentas c
        on c.id = dt.CRCCuentaid
    where et.ETnumero = #url.ET#;
</cfquery>

<cfquery name="q_Corte" datasource="#session.dsn#">
    select fechafin from CRCCortes where Ecodigo = #session.ecodigo# and tipo = '#q_datosPago.tipo#' and status = 1;
</cfquery>

<cfquery name="q_usuario" datasource="#session.dsn#">
    select ur.Usucodigo, de.DEid, de.DEidentificacion, concat(isNull(de.DEnombre,''),' ',isNull(de.DEapellido1,''),' ', isNull(de.DEapellido2,'')) as nombreEmpleado
    from UsuarioReferencia ur
        left join DatosEmpleado de
            on de.DEid = ur.llave
    where ur.Usucodigo = #q_datosPago.usucodigo# and ur.STabla = 'DatosEmpleado';
</cfquery>

<cfobject component="sif.Componentes.montoEnLetras" name="LvarObj">
<cfset LvarMontoEnLetrasCompleto = LvarObj.fnMontoEnLetras(q_datosPago.ETtotal)>
<cfset LvarMontoEnLetras = splitLines(LvarMontoEnLetrasCompleto,25)>

<cfset mensajeCompleto = 'Su informacion personal podra ser utilizada para fines de identificacion y o analisis mercadologico y o cualquier otro previsto en el Aviso de  Privaciad integral publicado en nuestro Centro de Atencion a Clientes o en'>
<cfset mensaje = splitLines(mensajeCompleto,32)>

<cfquery name="logo" datasource="#session.DSN#">
      Select  Elogo
      From  Empresa
      where Ereferencia = #Session.Ecodigo#
  </cfquery>
<cfset file_path = "#ExpandPath( GetContextRoot() )#">
<cfif REFind('(cfmx)$',file_path) gt 0> 
<cfset file_path = "#Replace(file_path,'cfmx','')#"> 
<cfelse> 
<cfset file_path = "#file_path#\">
</cfif>
<cffile action="write" file="#file_path#Enviar\lastLogo.jpg" output="#logo.Elogo#" addnewline="No" >

<cfset fontM = "style='font-size: 12px;'">
<cfset fontL = "style='font-size: 15px;'">

<cfoutput>

<cfdocument 
    format = "PDF"
    marginBottom = "0"
    marginLeft = "0"
    marginRight = "0"
    marginTop = "0"
    pagetype="custom"
    pageWidth = "8"
    pageHeight = "27"
    unit = "cm"
>

<html>
    <body>
        <table border="0">
            <tr>
                <td width="100%" style="padding: 15px;">
                    <div align="center" width="100%" #fontL#>
				        <img src="../../../Enviar/lastLogo.jpg" alt="Logo_IMG" width="75%">
                    </div>
                    <div align="center" width="100%" #fontL#>
                        <br>TIENDAS FULL
                        <br>
                        <br>RECIBO DE PAGO #q_datosPago.ETserie#-#q_datosPago.ETdocumento#
                        <br>Fecha #DateFormat(Now(),"dd/mm/yyyy")#
                    </div>
                    <div align="left" #fontM#>
                        <br>Recibimos de
                        <br>&emsp;#q_datosPago.Numero#
                        <br>&emsp;#UCase(q_datosPago.SNnombre)#
                    </div>
                    <div align="left" #fontM#>
                        <br>La cantidad de #lsCurrencyFormat(q_datosPago.ETtotal)#
                        <!---
                        <cfloop array="#LvarMontoEnLetras#" index="id" item="it">
                            <br>#UCase(LvarMontoEnLetras[id])#
                        </cfloop>
                        --->
                        <br><p style="padding-left:15px;">#Ucase(LvarMontoEnLetrasCompleto)#</p>
                    </div>
                    <div align="left" #fontM#>
                        <br>Por concepto de
                        <br>&emsp;Pago del corte del
                        <br>&emsp;&emsp;&emsp;#DateFormat(q_Corte.fechafin,"dd/mm/yyyy")#
                    </div>
                    <div align="left" #fontM#>
                        <br>
                        <br>
                        <br>
                        <br>
                        <br>RECIBIO _ _ _ _ _ _ _ _ _ _ _ _ _
                    </div>
                    <div align="center" #fontM#>
                        <br>#Ucase(q_usuario.nombreEmpleado)#
                    </div>
                    <div align="left">
                        <br>
                        <table #fontM# width="100%">
                            <tr>
                                <td align="left">Fecha Pago</td>
                                <td align="right">#DateFormat(q_datosPago.ETfecha,"dd/mm/yyyy")#</td>
                            </tr>
                            <tr>
                                <td align="left">Hora de Pago</td>
                                <td align="right">#DateTimeFormat(q_datosPago.ETfecha,"hh:nn:sstt")#</td>
                            </tr>
                        </table>
                    </div>
                    <div align="left" >
                        <table #fontM# width="100%" >
                            <tr>
                                <td align="left">Fecha Impresion</td>
                                <td align="right">#DateFormat(Now(),"dd/mm/yyyy")#</td>
                            </tr>
                            <tr>
                                <td align="left">Hora de Impresion</td>
                                <td align="right">#DateTimeFormat(Now(),"hh:nn:sstt")#</td>
                            </tr>
                        </table>
                    </div>
                    <div align="center" #fontM#>
                        <br>Cuide su linea de Credito
                        <br>GRACIAS POR SU PAGO
                    </div>
                    <div align="center" #fontM#>
                        <br>Aviso de Privacidad
                    </div>
                    <div align="left" #fontM#>
                        <!---
                        <cfloop array="#mensaje#" index="id" item="it">
                            <br>#mensaje[id]#
                        </cfloop>
                        --->
                        <br>#mensajeCompleto#
                    </div>
                    <div align="center" #fontM#>
                        <br>www.tiendasfull.com
                    </div>
                </td>
            </tr>
        </table>
    </body>
</html>
</cfdocument>
</cfoutput>

<cffunction  name="splitLines">
    <cfargument  name="text" required="true">
    <cfargument  name="size" required="true">

    <cfset lines = []>
    <cfset line = "">
    <cfset words = listToArray(arguments.text,' ')>
    <cfloop index="i" from="1" to="#ArrayLen(words)#">
        <cfif len("#line# #words[i]#") lt arguments.size>
            <cfset line = "#line# #words[i]#">
        <cfelse>  
            <cfset arrayAppend(lines,line)>  
            <cfset line = "#words[i]#">
        </cfif>
    </cfloop>
    <cfset arrayAppend(lines,line)>  
    
    <cfreturn lines>

</cffunction>