<!--- JMRV. Inicio. Pagos a terceros. 31/07/2014 --->

<cfif isdefined("form.botonSel") and form.botonSel eq 'btnEliminar'>
    <cfif (isdefined("form.chk"))><!--- Pagos elegidos con el check --->
        <cfset datos = ListToArray(Form.chk,",")>
        <cfset limite = ArrayLen(datos)>
        <cfloop from="1" to="#limite#" index="idx">
            <cfset Rdatos = ListToArray(datos[idx],"|")>
            <cfquery name = "RsRegDoctoCab" datasource="sifinterfaces">
                delete PS_PMI_INTFZ_PGTR  
                where   PMI_COD_PAGO = '#Rdatos[1]#'
                and     PMI_LINEA = #Rdatos[2]#
            </cfquery>
        </cfloop>
    </cfif>
    <cflocation url="interfazPagoATercerosPMI-sql.cfm">
<cfelse>
<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='PAGOS'>
	
		<cfquery name = "RsRegDoctoCab" datasource="sifinterfaces">
			select PMI_COD_PAGO as Pago, PMI_OBSERVACIONES as Observaciones, PMI_FECHA_EMISI as Fecha, 
            PMI_MONEDA as Moneda, 
            case coalesce(PMI_FORMA_PAGO,-1)
                        when 0  then 'Default'
                        when 1  then 'Cheque'
                        when 2  then 'TEF'
                        when 3  then 'TCE'
                        else ''
                    end as Forma_Pago <!--- JMRV 14/10/2014 --->
			from PS_PMI_INTFZ_PGTR	
			where PMI_COD_PAGO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PMI_COD_PAGO#">
			and PMI_LINEA = <cfqueryparam cfsqltype="cf_sql_integer" value="#PMI_LINEA#">
		</cfquery>
        
        <cfquery name = "RsRegDoctoDet" datasource="sifinterfaces">
			select	PMI_COD_PAGO as Pago, PMI_RUBRO as Rubro, PMI_SUBRUBRO as SubRubro, 
					PMI_BENEFICIARIO as No_empleado, PMI_DESCRIPCION as Descripcion,
					PMI_IMPORTE as Monto, PMI_CTRO_COSTOS as Centro_Costo, PMI_CUENTA as Concepto_Servicio,
					PMI_SNEGOCIOS as SNegocios
				from PS_PMI_INTFZ_PGTR 
				where PMI_COD_PAGO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PMI_COD_PAGO#">
				and PMI_LINEA = <cfqueryparam cfsqltype="cf_sql_integer" value="#PMI_LINEA#">
		</cfquery>
		
 	<form method="post" name="frmDetalle" style="margin:0 0 0 0">
		<hr>
            <table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="ENCABEZADO">
				<cfif isdefined("RsRegDoctoCab") and RsRegDoctoCab.recordCount EQ 1>
					<cfset LvarCampos = RsRegDoctoCab.getColumnnames()>
					<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="RsRegDoctoCab">   
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("RsRegDoctoCab.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop> 						
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
            <cfif isdefined("RsRegDoctoErr") and RsRegDoctoErr.recordcount GT 0>
                <table>
                    <tr>
                        <td align="left">
                            <strong>ERROR:</strong>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <cfoutput>#RsRegDoctoErr.Error#</cfoutput>
                        </td>
                    </tr>
                </table>
            </cfif>
        <hr>
			<table width=500 align=center><tr><td>
			<cf_web_portlet_start titulo="DETALLE">
				<cfif isdefined("RsRegDoctoDet") and RsRegDoctoDet.recordCount GTE 1>
					<cfset LvarCampos = RsRegDoctoDet.getColumnnames()>
					<table width="100%" border="1">
						<TR>
                            <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                <td style="font-size:12;font-weight:bold">
                                    <cfoutput>#ucase(LvarCampos[i])#</cfoutput>
                                </td>
                            </cfloop>
                        </TR>
                        <cfloop query="RsRegDoctoDet">   
                            <TR>
                                <cfloop index="i" from="1" to="#arrayLen(LvarCampos)#">
                                    <td style="font-size:10">
                                    <cfoutput>#evaluate("RsRegDoctoDet.#LvarCampos[i]#")#&nbsp;</cfoutput>
                                    </td>
                                </cfloop>
                            </TR>
                        </cfloop> 						
					</table>
				</cfif> 
			<cf_web_portlet_end>
		 	</td></tr></table>
	</form>
	
   	<!----------------------------------------------------  --->
	<cfoutput>
    <table align="center">
		<tr>
			<td>
				<form action="interfazPagoATercerosPMI-sql.cfm" method="post" style="margin:0 0 0 0" name="sql">
                	<input type="submit" name="btnRegresar" value="Regresar">
				</form>
			</td>
		</tr>
	</table>
    </cfoutput>
   <!----------------------------------------------------  --->


	<cfset LvarFiltro = ""> 
	<cfset LvarNavegacion = "">
	<cfset Inicio = True>

 <cf_templatefooter>
 </cfif>
 <!--- JMRV. Fin. Pagos a terceros. 31/07/2014 --->