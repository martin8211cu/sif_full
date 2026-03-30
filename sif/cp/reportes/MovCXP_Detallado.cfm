<cf_htmlReportsHeaders 
	irA="MovimientosCXP.cfm"
	FileName="MovimientosCXP.xls"
	title="Reporte de Movimientos de CXP">
    
<style type="text/css"></style>
   
<!---<cf_dump var="#Form#">--->
   
<cf_dbfunction name="date_part"	args="yyyy, A.BMfecha"  returnvariable="LvarAno1">
<cf_dbfunction name="date_part"	args="mm, A.BMfecha"  returnvariable="LvarMes1">

<cfquery name="rsReporte" datasource="#session.dsn#">
	Select
        B.SNnombre As NombreSN, 
        Coalesce
        (
            (
            Select 
                Min(DSN.SNCDdescripcion) 
            From 
                SNClasificacionSN CSN
                    Left Join SNClasificacionD DSN On 
                        DSN.SNCDid = CSN.SNCDid
            Where 
                CSN.SNid = B.SNid 
            ),
            'NA'
        ) As Clasificacion,
        Coalesce
        (
            (
            Select 
                Min(DSN.SNCDvalor) 
            From 
                SNClasificacionSN CSN
                    Left Join SNClasificacionD DSN On 
                        DSN.SNCDid = CSN.SNCDid
            Where 
                CSN.SNid = B.SNid 
            ),
            'NA'
        ) As ClasificacionValor,        
        D.CFformato As FormatoCF, A.CPTcodigo As TipoDoc, 
        A.Ddocumento As Doc,
        <cf_dbfunction name="date_format"	args="A.BMfecha, DD/MM/YYYY"> As Fecha,
        E.Miso4217 As Moneda, 
        A.Dtotal As Monto, A.Dtipocambio As TipoCambio, A.Dtotal * A.Dtipocambio As MontoOrigen,
        C.Edocumento As DocPoliza, C.Edescripcion As DesPoliza,
        CPTRcodigo As TipoDocRef, DRdocumento As DocRef
    From
        BMovimientosCxP A
        Inner Join SNegocios B On
            A.SNcodigo = B.SNcodigo And
            A.Ecodigo = B.Ecodigo
        Inner Join HEContables C On
            A.IDcontable = C.IDcontable And
            C.Ecodigo = A.Ecodigo
        Inner Join CFinanciera D On
            B.SNcuentacxp = D.Ccuenta And
            D.Ecodigo = A.Ecodigo
        Inner Join Monedas E On
            A.Mcodigo = E.Mcodigo And
            E.Ecodigo = A.Ecodigo        
    Where
        A.Ecodigo = #session.Ecodigo#
        And #LvarAno1# * 100 + #LvarMes1#  Between #form.periodo# * 100 + #form.mes# And #form.periodo2# *100 + #form.mes2#
        
        <cfif isdefined('Form.SNcodigo') and len(trim(Form.SNcodigo))>
            And B.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(Form.SNcodigo)#">
        </cfif>        
        
        <!---Si se escogio una clasificación:--->
        <cfif isdefined('form.SNCEid') and len(trim(form.SNCEid))>
             And #form.SNCEid#  In 
             (Select B1.SNCEid 
                From SNClasificacionSN A1
                    Left Join SNClasificacionD B1 On 
                        B1.SNCDid = A1.SNCDid
                Where A1.SNid = B.SNid 
              ) 
        </cfif>
    
		<!---Si es escogio un rango de clasificaciones:--->
        <cfif isdefined('form.SNCDvalor1') and len(trim(form.SNCDvalor1)) and isdefined('form.SNCDvalor2') and len(trim(form.SNCDvalor2))>
            And  (Select Count(1)
                    From SNClasificacionSN A1 
                        Left Join SNClasificacionD B2 On 
                            B2.SNCDid = A1.SNCDid 
                    Where A1.SNid = B.SNid
                        And B2.SNCDvalor  Between '#Form.SNCDvalor1#' And '#Form.SNCDvalor2#'
                        And B2.SNCEid =  #Form.SNCEid#
                  )  > 0
        </cfif>        
        
    Order By
        ClasificacionValor, NombreSN, Doc
</cfquery>

<cfquery datasource="#session.DSN#" name="rsEmpresa">
	Select 
        Edescripcion,
        Ecodigo
	From Empresas
	Where Ecodigo=#session.Ecodigo#
</cfquery>

<!---<cfdump var="#rsReporte#">--->

<cfif isdefined("form.btnDownload")>
	<cfset oldlocale = SetLocale("French (Canadian)")>
</cfif>

<table align="center" border="0" summary="Reporte" cellpadding="1" cellspacing="0">
	<cfoutput>
   		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px"> 
        	<td  align="left" bgcolor="BCBCBC" colspan="7"><strong>#rsEmpresa.Edescripcion#</strong></td>
            <td  align="right" bgcolor="BCBCBC" colspan="6"><strong>Fecha:&nbsp;#DateFormat(Now(), "mmm d, yyyy")#</strong></td>
        </tr> 
		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
			<td  align="left" bgcolor="BCBCBC" colspan="7"><strong>Sistema de Cuentas por Pagar</strong></td>
            <td  align="right" bgcolor="BCBCBC" colspan="6"><strong>Hora:&nbsp;#TimeFormat(Now(), "h:mm TT")#</strong></td>
		</tr>
		<tr style="font-family:Arial, Helvetica, sans-serif; font-size:14px">
        	<td  align="left" bgcolor="BCBCBC" colspan="13"><strong>Reporte de Movimientos de Cuentas por Pagar</strong></td>
		</tr>
    </cfoutput>
    <tr><td>&nbsp;</td></tr>
    <cfif rsReporte.RecordCount GT 0>
    	<tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
        	<td colspan="4"></td>
            <td colspan="2" align="center"><strong>Aplica a<strong</td>
        </tr> 
        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
            <td  width="15%" align="center">
                <strong>Socio Negocio</strong>
            </td>
            <td  width="10%" align="center">
                <strong>Cuenta Contable Prov.</strong>
            </td>
            <td  width="5%" align="center">
                <strong>Tipo Doc.</strong>
            </td>                
            <td  width="5%" align="center">
                <strong>Documento</strong>
            </td> 
            <td  width="5%" align="center">
                <strong>Tipo Doc.</strong>
            </td>                
            <td  width="5%" align="center">
                <strong>Documento</strong>
            </td>                                                                               
            <td width="5%" align="center">
                <strong>Fecha</strong>
            </td>
            <td width="5%" align="center">
                <strong>Moneda</strong>
            </td>
            <td width="10%" align="center">
                <strong>Monto</strong>
            </td>
            <td width="5%" align="center">
                <strong>Tipo Cambio</strong>
            </td>
            <td width="10%" align="center">
                <strong>Monto Local</strong>
            </td>
            <td width="5%" align="center">
                <strong>Poliza</strong>
            </td>
            <td width="30%" align="center">
                <strong>Descripcion P&oacute;liza</strong>
            </td>                                                                                                                                                                                                                                                                                                                          
        </tr>
        <cfset totalGeneral1 = 0>
        
        <cfoutput query="rsReporte" group="ClasificacionValor">
            <tr style="font-family:Arial, Helvetica, sans-serif; font-size:13px">
                <td colspan="13" align="Left" bgcolor="DDDDDD">
                    <strong>
                        &nbsp;Clasificaci&oacute;n:&nbsp;#ClasificacionValor#&nbsp;-&nbsp;#Clasificacion#
                    </strong>
                </td>
            </tr>
           	<cfset subTotal1 = 0> 		<!---Monto Total--->
                
			<cfoutput>            
                <cfset contadorTemp = 1> 
                                                                          
                <tr style="font-family:Arial, Helvetica, sans-serif; font-size:11px">
				   <cfif len(#NombreSN#) GT 30 And not isdefined("Form.btnDownload")>
                         <td width="15%" title="#NombreSN#" align="left">
                            #left(NombreSN, 30)#...
                         </td>
                    <cfelse>
                        <td width="15%" align="left">
                            #NombreSN#
                        </td>                                    	
                    </cfif>                    
                    <td width="10%" align="Left">
                        #FormatoCF#
                    </td>
                    <td width="5%" align="center">
                        #TipoDoc#
                    </td>                                
                    <td width="10%" align="center">
                        #Doc#
                    </td>
                    <td width="5%" align="center">
                        #TipoDocRef#
                    </td>                                
                    <td width="10%" align="center">
                        #DocRef#
                    </td>                        
                    <td width="5%" align="center">
                        #Fecha#
                    </td>  
                    <td width="5%" align="center">
                        #Moneda#
                    </td>                                                                                                                               
                    <td width="10%" align="right">
                        <cfif isdefined("Form.btnDownload")>
                            #LSNumberFormat(Monto, "_________.___")# 
                        <cfelse>
                            #LSNumberFormat(Monto, ",.00")#
                        </cfif>
                    </td>
                    <td width="5%" align="right">
                        <cfif isdefined("Form.btnDownload")>
                            #LSNumberFormat(TipoCambio, "_________.___")# 
                        <cfelse>
                            #LSNumberFormat(TipoCambio, ",.00")#
                        </cfif>
                    </td>
                    <td width="10%" align="right">
                        <cfif isdefined("Form.btnDownload")>
                            #LSNumberFormat(MontoOrigen, "_________.___")# 
                        <cfelse>
                            #LSNumberFormat(MontoOrigen, ",.00")#
                        </cfif>
                    </td>
				   <cfif len(#DocPoliza#) GT 5 And not isdefined("Form.btnDownload")>
                         <td width="5%" title="#DocPoliza#" align="center">
                            #left(DocPoliza, 5)#...
                         </td>
                    <cfelse>
                        <td width="5%" align="center">
                            #DocPoliza#
                        </td>                                    	
                    </cfif>                     
				   <cfif len(#DesPoliza#) GT 10 And not isdefined("Form.btnDownload")>
                         <td width="30%" title="#DesPoliza#" align="left">
                            #left(DesPoliza, 10)#...
                         </td>
                    <cfelse>
                        <td width="30%" align="left">
                            #DesPoliza#
                        </td>                                    	
                    </cfif>
                    
            <cfset subTotal1 = subTotal1 + #MontoOrigen#>            
            <cfset totalGeneral1 = totalGeneral1 + #MontoOrigen#>
            		
            </cfoutput>
                    <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
                        <td colspan="10"align="Left">
                            <strong>Totales por Clasificaci&oacute;n&nbsp;#Clasificacion#&nbsp;</strong>
                        </td>
                        <td width="10%" align="right" bgcolor="DDDDDD" style=" border-bottom:1px solid black;">
                            <strong>
                                <cfif isdefined("Form.btnDownload")>
                                    #LSNumberFormat(subTotal1, "_________.___")# 
                                <cfelse>
                                    #LSNumberFormat(subTotal1, ",.00")#
                                </cfif>
                            </strong>
                        </td>
                        <td colspan="2" bgcolor="DDDDDD"></td>                                                                                                                                                                                                
                    </td>                       
        </cfoutput>
        <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px">
            <td colspan="10"align="Left">
                <strong>Total General:&nbsp;</strong>
            </td>
            <td width="10%" align="right" style=" border-bottom:1px solid black;">
            <cfoutput>
                <strong>
                    <cfif isdefined("Form.btnDownload")>
                        #LSNumberFormat(totalGeneral1, "_________.___")# 
                    <cfelse>
                        #LSNumberFormat(totalGeneral1, ",.00")#
                    </cfif>
                </strong>
            </cfoutput>
            </td>
        </tr>
        <tr>
            <td colspan="10"align="right"></td>
            <td colspan="1" width="10%" align="Left" style=" border-top:1px solid black;"></td>                                                                                               
        </tr>                
    <tr>
        <td align="left" nowrap="nowrap" colspan="11"></td>
    </tr>
    <tr style="font-family:Arial, Helvetica, sans-serif; font-size:12px"><td align="center" nowrap="nowrap" colspan="20"><p>&nbsp;</p>
    <p><cfoutput>Cantidad de Registros:&nbsp;#rsReporte.RecordCount#</cfoutput></p>
    <p>***Fin de Linea***</p></td></tr>
    </cfif>
</table>
<cfif rsReporte.RecordCount EQ 0>
    <p align="center" style="font-family:Arial, Helvetica, sans-serif; font-size:12px">No se encontraron registros</p>
</cfif>